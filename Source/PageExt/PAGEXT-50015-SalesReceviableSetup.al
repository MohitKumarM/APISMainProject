pageextension 50015 SalesRecivalbeSetup extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Credit Memo Nos.")
        {
            field("Sauda Nos."; Rec."Sauda Nos.")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}