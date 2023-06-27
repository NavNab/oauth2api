page 50201 "OAuth2 Setup NAvNab"
{
    ApplicationArea = All;
    Caption = 'Oauth2 Setup';
    PageType = List;
    SourceTable = "OAuth2 Setup NavNAb";
    UsageCategory = Administration;
    Editable = false;
    CardPageId = "OAuth2 Setup Card NavNAb";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
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
                field("Redirect URI"; Rec."Redirect URI")
                {
                    ToolTip = 'Specifies the value of the redirect_uri field.';
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
                field("Access Token Creation DateTime"; Rec."Access Token Creation DateTime")
                {
                    ToolTip = 'Specifies the value of the Access token creation date-time field.';
                }
                field("Access Token TTL (s)"; Rec."Access Token TTL (s)")
                {
                    ToolTip = 'Specifies the value of the Access token TTL (s) field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        OAuth2Mgt: Codeunit "OAuth2 Mgt. NAvNab";
    begin
        OAuth2Mgt.SetExample();
    end;
}
