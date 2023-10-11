pageextension 50011 Item extends "Item Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Full Description"; Rec."Full Description")
            {
                ApplicationArea = all;
            }
            field("New Product Group Code"; Rec."New Product Group Code")
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