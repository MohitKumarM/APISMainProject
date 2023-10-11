tableextension 50007 InventorySetup extends "Inventory Setup"
{
    fields
    {
        field(50000; "Quality Nos."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(60000; "QC Entry Template"; Code[10])
        {
            TableRelation = "Item Journal Template" WHERE(Type = FILTER(Transfer));
        }
        field(60001; "QC Entry Batch"; Code[10])
        {
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("QC Entry Template"));
        }
    }

    var
        myInt: Integer;
}