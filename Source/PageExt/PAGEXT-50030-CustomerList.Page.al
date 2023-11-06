pageextension 50030 "Customer List" extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }



    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Error('Do Not Insert any Record for this Page You Can only View the Data');
    end;

    trigger OnModifyRecord(): Boolean
    begin
        Error('Do Not Modify any Record for this Page You Can only View the Data');
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('Do Not Delete any Record for this Page You Can only View the Data');
    end;
}