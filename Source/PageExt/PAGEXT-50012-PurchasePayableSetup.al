pageextension 50012 PurchasePayableSetup extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Calc. Inv. Discount")
        {
            field("Deal Tolerance"; Rec."Deal Tolerance")
            {
                ApplicationArea = all;
            }
            field("Raw Honey Item"; Rec."Raw Honey Item")
            {
                ApplicationArea = all;
            }

        }
        addafter("Return Order Nos.")
        {
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = All;
            }
            field("Honey Order Nos."; Rec."Honey Order Nos.")
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