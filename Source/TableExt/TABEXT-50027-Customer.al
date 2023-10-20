tableextension 50027 Customer extends Customer
{
    fields
    {
        field(50000; "Quality Process"; Code[20])
        {
            TableRelation = "Standard Task";
        }
        field(50001; "Skip TCS"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}