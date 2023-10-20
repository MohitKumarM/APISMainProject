tableextension 50031 SalesLine extends "Sales Line"
{
    fields
    {
        field(50050; "TCS Nature of Collection 1"; Code[10])
        {
            DataClassification = CustomerContent;


        }
    }

    var
        myInt: Integer;
}