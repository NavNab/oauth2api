page 50200 "OAuth2 Setup Card NAvNab"
{
    ApplicationArea = All;
    Caption = 'OAuth2 Setup';
    PageType = Card;
    SourceTable = "OAuth2 Setup NavNAb";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            usercontrol(Oauth; OAuthControlAddIn)
            {
                trigger ControlAddInReady()
                begin
                    IsControlAddInReady := true;
                end;

                trigger AuthorizationCodeRetrieved(AuthCode: Text)
                var
                    OAuth2Mgt: Codeunit "OAuth2 Mgt. NAvNab";
                begin
                    OAuth2Mgt.HandleRetrievedAuthorizationCode(Rec, RandomState, AuthCode);
                    CurrPage.Update(true);
                end;

                trigger AuthorizationErrorOccurred(AuthError: Text; AuthErrorDescription: Text)
                var
                    AuthErr: Label 'An error has occurred.\Code=%1\Description=%2';
                begin
                    Error(AuthErr, AuthError, AuthErrorDescription);
                end;
            }
            group(Authentication)
            {
                Caption = 'Authentication';

                field("Code"; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Base URL"; Rec."Base URL")
                {
                    ToolTip = 'Specifies the value of the Base URL field.';
                }
                field("Auth Path"; Rec."Auth Path")
                {
                    ToolTip = 'Specifies the value of the Auth Path field.';
                }
                field("Token Path"; Rec."Token Path")
                {
                    ToolTip = 'Specifies the value of the Token Path field.';
                }
            }
            group(RedirectUri)
            {
                Caption = 'Redirect Uri';

                field("Redirect URI"; Rec."Redirect URI")
                {
                    ToolTip = 'Specifies the value of the redirect_uri field.';
                }
            }
            group(General)
            {
                Caption = 'General';

                field("Client Id"; Rec."Client Id")
                {
                    ToolTip = 'Specifies the value of the client_id field.';
                }
                field("Client Secret"; Rec."Client Secret")
                {
                    ToolTip = 'Specifies the value of the client_secret field.';
                }
                field("Grant Type"; Rec."Grant Type")
                {
                    ToolTip = 'Specifies the value of the grant_type field.';
                }
                field("Response Type"; Rec."Response Type")
                {
                    ToolTip = 'Specifies the value of the response_type field.';
                }
                field(Scopes; Rec.Scopes)
                {
                    ToolTip = 'Specifies the value of the scope field.';
                }
            }
            group(LastAccessToken)
            {
                Caption = 'Access Token';

                field("Last Access Token"; Rec."Last Access Token")
                {
                    ToolTip = 'Specifies the value of the Access Token field.';
                }
                field("Access Token Creation DateTime"; Rec."Access Token Creation DateTime")
                {
                    ToolTip = 'Specifies the value of the Access Token Creation DateTime field.';
                }
                field("Access Token Expiration DateTime"; Rec."Access Token TTL (s)")
                {
                    ToolTip = 'Specifies the value of the Access Token Expiration DateTime field.';
                }
            }
        }
    }

    actions
    {
        area(Navigation)
        {
            action(Authorize)
            {
                ApplicationArea = All;
                Caption = 'Authorize';
                Image = ApprovalSetup;
                ToolTip = 'Start authorization process. You will be prompted to login to your app if you''re nor already logged in';
                trigger OnAction()
                var
                    Oauth2Mgt: Codeunit "OAuth2 Mgt. NAvNab";
                begin
                    if IsControlAddInReady then begin
                        RandomState := Oauth2Mgt.GenerateRandomState();
                        CurrPage.Oauth.StartAuthorization(Oauth2Mgt.GetAuthUrl(Rec, RandomState));
                    end;
                end;
            }
        }
        area(Promoted)
        {
            group(AuthorizeGrp)
            {
                Caption = 'Authorize';
                actionref(Authorize_Promoted; Authorize)
                {
                }
            }
        }
    }

    var
        IsControlAddInReady: Boolean;
        RandomState: Text;
}
