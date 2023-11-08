pageextension 50035 SalesOrderList extends "Sales Order List"
{

    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var


    trigger OnOpenPage()
    var

    begin
        rec.FilterGroup(2);
        rec.SetFilter("GST Customer Type", '<>%1', Rec."GST Customer Type"::Export);
        rec.FilterGroup(0);
    end;
}