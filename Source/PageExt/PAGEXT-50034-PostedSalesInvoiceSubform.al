pageextension 50034 "Posted Sales Invoice Subform" extends "Posted Sales Invoice Subform"
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
                RunObject = page "Posted Packing List";
                RunPageLink = "Order No." = field("Document No."), "Order Line No." = field("Line No."), "Item Code" = field("No.");
            }
        }
    }
}