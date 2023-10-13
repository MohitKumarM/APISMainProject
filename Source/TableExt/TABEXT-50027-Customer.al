tableextension 50027 Customer extends Customer
{
    fields
    {
        field(50000; "Quality Process"; Code[20])
        {
            TableRelation = "Standard Task";
        }
    }

    var
        myInt: Integer;
}