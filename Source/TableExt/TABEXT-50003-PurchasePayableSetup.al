tableextension 50003 PurchPayableSetup extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "Indent No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(70001; "Deal Tolerance"; Decimal)
        {
        }
        field(50002; "Raw Honey Item"; Code[20])
        {
            TableRelation = Item;
        }
    }

    var
        myInt: Integer;
}