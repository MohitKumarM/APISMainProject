pageextension 50004 CustomerCard extends "Customer Card"
{
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

    var
        myInt: Integer;
}