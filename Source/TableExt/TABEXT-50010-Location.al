tableextension 50010 Locations extends Location
{
    fields
    {
        field(60000; "QC Rejection Location"; Code[20])
        {
            TableRelation = Location WHERE("Use As In-Transit" = FILTER(false));
        }
        field(60001; "OK Store Location"; Code[20])
        {
            TableRelation = Location;
        }
    }

    var
        myInt: Integer;
}