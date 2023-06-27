table 50200 "OAuth2 Setup NAvNab"
{
    Caption = 'OAuth2 Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; "Client Id"; Text[100])
        {
            Caption = 'Client ID';
            DataClassification = ToBeClassified;
        }
        field(3; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            DataClassification = ToBeClassified;
        }
        field(4; "Grant Type"; Text[50])
        {
            Caption = 'Grant Type';
            DataClassification = ToBeClassified;
        }
        field(5; "Redirect URI"; Text[250])
        {
            Caption = 'Redirect URI';
            DataClassification = ToBeClassified;
        }
        field(6; "Response Type"; Text[50])
        {
            Caption = 'Response Type';
            DataClassification = ToBeClassified;
        }
        field(7; Scopes; Text[250])
        {
            Caption = 'Scopes';
            DataClassification = ToBeClassified;
        }
        field(8; "Base URL"; Text[250])
        {
            Caption = 'Base URL';
            DataClassification = ToBeClassified;
        }
        field(9; "Auth Path"; Text[50])
        {
            Caption = 'Auth Path';
            DataClassification = ToBeClassified;
        }
        field(10; "Token Path"; Text[250])
        {
            Caption = 'Token Path';
            DataClassification = ToBeClassified;
        }
        field(11; "Last Access Token"; Text[500])
        {
            Caption = 'Last Access Token';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(12; "Access Token Creation DateTime"; DateTime)
        {
            Caption = 'Access Token Creation DateTime';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Access Token TTL (s)"; BigInteger)
        {
            Caption = 'Access Token TTL (s)';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(PK; Code)
        {
            Clustered = true;
        }
    }
}
