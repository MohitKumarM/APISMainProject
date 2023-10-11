pageextension 50016 InventerySetup extends "Inventory Setup"
{
    layout
    {
        addafter("Automatic Cost Adjustment")
        {
            field("Quality Nos."; Rec."Quality Nos.")
            {
                ApplicationArea = all;
            }
            field("QC Entry Template"; Rec."QC Entry Template")
            {
                ApplicationArea = all;
            }
            field("QC Entry Batch"; Rec."QC Entry Batch")
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