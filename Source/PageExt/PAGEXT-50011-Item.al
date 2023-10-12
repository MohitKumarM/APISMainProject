pageextension 50011 ItemN1 extends "Item Card"
{
    layout
    {
        addafter(Blocked)
        {

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