tableextension 50006 SalesRecivableSetup extends "Sales & Receivables Setup"
{
    fields
    {
        field(50000; "Sauda Nos."; Code[10])
        {
            Caption = 'Deal No.';
            TableRelation = "No. Series";
        }
    }
}