codeunit 50200 "OAuth2 Mgt. NAvNab"
{
    internal procedure SetExample()
    var
        OAuth2Setup: Record "OAuth2 Setup NavNAb";
    begin
        if not OAuth2Setup.Get('LINKEDIN') then begin
            OAuth2Setup.Init();
            OAuth2Setup.Validate(Code, 'LINKEDIN');
            OAuth2Setup.Validate("Base URL", 'https://www.linkedin.com/oauth/v2');
            OAuth2Setup.Validate("Auth Path", 'authorization');
            OAuth2Setup.Validate("Token Path", 'accessToken');
            OAuth2Setup.Validate("Redirect URI", 'http://bc22/BC/OAuthLanding.htm');
            OAuth2Setup.Validate("Client Id", 'my_client_id');
            OAuth2Setup.Validate("Client Secret", 'my_client_secret');
            OAuth2Setup.Validate("Grant Type", 'authorization_code');
            OAuth2Setup.Validate("Response Type", 'code');
            OAuth2Setup.Validate(Scopes, 'profile');
            OAuth2Setup.Insert(true);
        end;
    end;

    internal procedure GenerateRandomState(): Text
    begin
        exit(Format(CreateGuid(), 0, 3).ToLower());
    end;

    internal procedure GetAuthUrl(OAuth2Setup: Record "OAuth2 Setup NavNAb"; RandomState: Text): Text
    var
        TypeHelper: Codeunit "Type Helper";
        AuthUrlLbl: Label '%1/%2?client_id=%3&client_secret=%4&grant_type=%5&redirect_uri=%6&state=%7&response_type=%8&scope=%9';
        AuthUrl: Text;
        RedirectUrl: Text;
        Scopes: Text;
    begin
        RedirectUrl := OAuth2Setup."Redirect URI";
        Scopes := OAuth2Setup.Scopes;

        AuthUrl :=
            StrSubstNo(AuthUrlLbl,
                OAuth2Setup."Base URL",
                OAuth2Setup."Auth Path",
                OAuth2Setup."Client Id",
                OAuth2Setup."Client Secret",
                OAuth2Setup."Grant Type",
                TypeHelper.HtmlEncode(RedirectUrl),
                RandomState,
                OAuth2Setup."Response Type",
                TypeHelper.HtmlEncode(Scopes));

        exit(AuthUrl);
    end;

    internal procedure HandleRetrievedAuthorizationCode(var OAuth2Setup: Record "OAuth2 Setup NavNAb"; RandomState: Text; AuthCode: Text)
    var
        Code: Text;
        State: Text;
    begin
        if not TryGetCodeAndStateFromAuthCode(AuthCode, Code, State) then
            Error(GetLastErrorText());

        CheckState(RandomState, State);
        GetAccessTokenInfo(OAuth2Setup, Code);
    end;

    local procedure BuildRequest(OAuth2Setup: Record "OAuth2 Setup NavNAb"; var Request: HttpRequestMessage; RequestContentTxt: Text)
    var
        Content: HttpContent;
        Headers: HttpHeaders;
    begin
        Request.Method := 'POST';
        Request.SetRequestUri(OAuth2Setup."Base URL" + '/' + OAuth2Setup."Token Path");
        Content.WriteFrom(RequestContentTxt);
        Request.GetHeaders(Headers);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/x-www-form-urlencoded');
        Request.Content := Content;
    end;

    local procedure BuildRequestContentTxt(var OAuth2Setup: Record "OAuth2 Setup NavNAb"; Code: Text): Text
    var
        RequestContentLbl: Label 'grant_type=%1&client_id=%2&client_secret=%3&code=%4&redirect_uri=%5';
        RequestContentTxt: Text;
    begin
        RequestContentTxt :=
            StrSubstNo(RequestContentLbl,
                OAuth2Setup."Grant Type",
                OAuth2Setup."Client Id",
                OAuth2Setup."Client Secret",
                Code,
                OAuth2Setup."Redirect URI");

        exit(RequestContentTxt);
    end;

    local procedure CheckState(RandomState: Text; State: Text)
    var
        StateErr: Label 'OAuth state mismatch, aborting!\\Local value=%1\Received value=%2)';
    begin
        if State <> RandomState then
            Error(StateErr, RandomState, State);
    end;

    local procedure GetAccessTokenInfo(var OAuth2Setup: Record "OAuth2 Setup NavNAb"; Code: Text)
    var
        Request: HttpRequestMessage;
        RequestContentTxt: Text;
        ResponseTxt: Text;
    begin
        RequestContentTxt := BuildRequestContentTxt(OAuth2Setup, Code);
        BuildRequest(OAuth2Setup, Request, RequestContentTxt);
        ResponseTxt := GetResponseAsText(Request);

        ParseResponse(OAuth2Setup, ResponseTxt);
    end;

    local procedure GetResponseAsText(var Request: HttpRequestMessage): Text
    var
        Client: HttpClient;
        Content: HttpContent;
        Response: HttpResponseMessage;
        BlockedByEnvironmentErr: Label 'Access to the requested resource has been blocked by the environment.\\%1';
        SuccessStatusCodeErr: Label 'The request was not successful.\\%1\%2';
        SendErr: Label 'An error occurred while sending the request.\\%1';
        ContentTxt: Text;
    begin
        if not Client.Send(Request, Response) then
            Error(SendErr, GetLastErrorText());

        if Response.IsBlockedByEnvironment then
            Error(BlockedByEnvironmentErr, GetLastErrorText());

        if not Response.IsSuccessStatusCode then
            Error(SuccessStatusCodeErr, Response.HttpStatusCode, GetLastErrorText());

        Content := Response.Content;
        Content.ReadAs(ContentTxt);
        exit(ContentTxt);
    end;

    local procedure ParseResponse(var OAuth2Setup: Record "OAuth2 Setup NavNAb"; ResponseTxt: Text)
    var
        JObj: JsonObject;
        JToken: JsonToken;
        JValue: JsonValue;
    begin
        JObj.ReadFrom(ResponseTxt);

        JObj.Get('access_token', JToken);
        JValue := JToken.AsValue();
        OAuth2Setup.Validate("Last Access Token", JValue.AsText());

        OAuth2Setup.Validate("Access Token Creation DateTime", CurrentDateTime);

        JObj.Get('expires_in', JToken);
        JValue := JToken.AsValue();
        OAuth2Setup.Validate("Access Token TTL (s)", JValue.AsBigInteger());
    end;

    [TryFunction]
    local procedure TryGetCodeAndStateFromAuthCode(AuthCode: Text; var Code: Text; var State: Text)
    var
        Element: Text;
    begin
        foreach Element in AuthCode.Split('&') do
            case true of
                Element.StartsWith('code='):
                    Code := Element.Substring(6);
                Element.StartsWith('state='):
                    State := Element.Substring(7);
            end;
    end;
}