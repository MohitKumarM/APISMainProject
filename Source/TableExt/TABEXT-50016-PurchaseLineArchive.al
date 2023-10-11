tableextension 50016 PurchaseLineArchive extends "Purchase Line Archive"
{
    fields
    {
        field(50001; "Deal No."; Code[20])
        {
            TableRelation = "Deal Master" WHERE(Status = FILTER(Release));
        }
        field(50004; "Deal Line No."; Integer)
        {
            TableRelation = "Deal Dispatch Details"."Line No." WHERE("Sauda No." = FIELD("Deal No."),
                                                                      "GAN Created" = FILTER(false));
        }
        field(50002; "Packing Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Drums,Tins,Buckets,Cans';
            OptionMembers = " ",Drums,Tins,Buckets,Cans;
        }
        field(50003; "Qty. in Pack"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(50005; "Dispatched Qty. in Kg."; Decimal)
        {
            Editable = false;
        }

        field(50006; Flora; Code[20])
        {
            Editable = false;
            TableRelation = "New Product Group".Code WHERE("Item Category Code" = FILTER(''));
        }
        field(50007; "Unit Rate"; Decimal)
        {
        }
        field(50008; "Purchaser Code"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser";
            /*comment by amar*/
        }
        field(50009; "Other Charges"; Decimal)
        {
        }
        field(60000; "QC Completed"; Boolean)
        {
        }
    }

    var
        myInt: Integer;
}