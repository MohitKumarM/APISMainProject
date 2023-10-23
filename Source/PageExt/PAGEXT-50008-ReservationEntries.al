pageextension 50008 ReservationEntry extends "Reservation Entries"
{
    layout
    {
        addafter("Package No.")
        {
            field("MRP Price"; Rec."MRP Price")
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