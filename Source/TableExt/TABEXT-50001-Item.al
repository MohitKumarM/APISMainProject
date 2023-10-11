tableextension 50001 Item extends Item
{
    fields
    {
        field(50000; "Full Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "New Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
            TableRelation = "New Product Group" WHERE("Item Category Code" = FIELD("Item Category Code"));

        }
    }

    var
        myInt: Integer;
}