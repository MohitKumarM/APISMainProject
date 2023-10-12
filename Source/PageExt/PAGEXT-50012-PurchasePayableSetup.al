pageextension 50012 PurchasePayableSetupN1 extends "Purchases & Payables Setup"
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
        addafter(Archiving)
        {
            group("PO Instruction")
            {
                field("Purchase Order Instruction"; Rec."PO Terms & Conditions")
                {
                    MultiLine = true;
                    ApplicationArea = all;
                }
            }
        }
        addafter("Return Order Nos.")
        {

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