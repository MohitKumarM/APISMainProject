pageextension 50026 PurchaseOrders extends "Purchase Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    begin
        Rec.FILTERGROUP(2);
        Rec.SetRange("Short Close", false);
        Rec.FILTERGROUP(0);
    end;
}