pageextension 50004 CustomerCard extends "Customer Card"
{
    Editable = false;
    layout
    {
        addafter("Disable Search by Name")
        {
            field("Skip TCS"; Rec."Skip TCS")
            {
                ApplicationArea = all;
            }
        }
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