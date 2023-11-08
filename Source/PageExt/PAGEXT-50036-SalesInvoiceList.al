pageextension 50036 SalesInvoiceList extends "Sales Invoice List"
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
        myInt: Integer;

    trigger OnOpenPage()
    begin
        rec.FilterGroup(2);
        rec.SetFilter("GST Customer Type", '<>%1', Rec."GST Customer Type"::Export);
        rec.FilterGroup(0);
    end;
}