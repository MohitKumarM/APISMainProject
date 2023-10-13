tableextension 50026 ReservatonEntry extends "Reservation Entry"
{
    fields
    {
        field(50002; "Packing Type"; enum "Packing Type")
        {

        }
        field(50003; "Qty. in Pack"; Decimal)
        {
        }
        field(50004; "Qty. Per Pack"; Decimal)
        {
        }
        field(50005; "Original Qty. in Pack"; Decimal)
        {
        }
        field(50006; "Tare Weight"; Decimal)
        {
        }
        field(50007; "Manufacturing Date"; Date)
        {
        }
    }

    var
        myInt: Integer;
}