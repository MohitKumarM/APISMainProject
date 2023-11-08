pageextension 50033 "Sales Order Subform" extends "Sales Order Subform"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter("&Line")
        {
            action("Packing List")
            {
                Image = PickLines;
                ApplicationArea = All;
                RunObject = page "Pre Packing List";
                RunPageLink = "Order No." = field("Document No."), "Order Line No." = field("Line No."), "Item Code" = field("No.");

            }
        }
    }

    var
        myInt: Integer;
}