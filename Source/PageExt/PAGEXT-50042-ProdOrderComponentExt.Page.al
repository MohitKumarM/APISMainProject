pageextension 50042 MyExtension extends "Prod. Order Components"
{
    layout
    {
        addbefore("Quantity per")
        {
            field("Required Qty"; Rec."Required Qty")
            {
                ApplicationArea = all;
            }
        }
        addafter("Routing Link Code")
        {
            field("Consumed Qty."; Rec."Consumed Qty.")
            {
                ApplicationArea = all;
            }
            field("Lot Tracking Qty."; Rec."Lot Tracking Qty.")
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