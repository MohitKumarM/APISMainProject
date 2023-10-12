tableextension 50003 PurchPayableSetup extends "Purchases & Payables Setup"
{
    fields
    {

        field(50002; "Raw Honey Item"; Code[20])
        {
            TableRelation = Item;
        }
        field(50003; "Honey Order Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(70001; "Deal Tolerance"; Decimal)
        {
        }
        field(50004; "PO Terms & Conditions"; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}