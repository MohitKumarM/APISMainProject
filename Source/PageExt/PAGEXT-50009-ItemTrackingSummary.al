pageextension 50009 "ItemTrackingSummary" extends "Item Tracking Summary"
{
    layout
    {
        addafter("Total Quantity")
        {
            field("MRP Price"; Rec."MRP Price")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("MFG. Date"; Rec."MFG. Date")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Tin; Rec.Tin)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Drum; Rec.Drum)
            {
                ApplicationArea = all;
                Editable = false;
            }
            field(Bucket; Rec.Bucket)
            {
                ApplicationArea = all;
                Editable = false;
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