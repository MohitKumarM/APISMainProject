tableextension 50027 Customer extends Customer
{
    fields
    {
        field(50000; "Quality Process"; Code[20])
        {
            TableRelation = "Standard Task";
        }
        field(50001; "Skip TCS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Authorized person"; Text[50])
        {
        }
        field(50003; "RSM Name"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            DataClassification = ToBeClassified;
        }
        field(50004; "Security Cheque No"; Text[10])
        {
        }
        field(50005; "MSME No."; Text[20])
        {
        }
        field(50006; "FASSAI No."; Code[20])
        {
        }
        field(80002; "Print Name"; Text[100])
        {
        }
        field(80003; "Address 3"; Text[50])
        {
        }
    }

    trigger OnAfterInsert()
    begin
        Rec.Blocked := Rec.Blocked::All;
    end;

    trigger OnAfterModify()

    begin
        Rec.Blocked := Rec.Blocked::All;
    end;
}
