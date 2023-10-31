pageextension 50006 ItemTrackingLine extends "Item Tracking Lines"
{
    layout
    {
        modify("Item No.")
        {
            Visible = true;
        }

        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                PriceListLine: Record "Price List Line";
            begin
                if rec."Source Type" <> 37 then begin
                    PriceListLine.Reset();
                    PriceListLine.SetCurrentKey("Ending Date");
                    PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"All Customers");
                    PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
                    PriceListLine.SetRange("Product No.", Rec."Item No.");
                    PriceListLine.SetRange(Status, PriceListLine.Status::Active);
                    if PriceListLine.FindLast() then begin
                        Rec."MRP Price" := PriceListLine."MRP Price";
                        Rec.Modify();
                    end;
                end;
            end;
        }
        addafter("Appl.-from Item Entry")
        {
            field("MRP Price"; Rec."MRP Price")
            {
                ApplicationArea = all;
            }
            field("MFG. Date"; Rec."MFG. Date")
            {
                ApplicationArea = all;
                trigger OnValidate()
                var
                    L_Item: Record Item;
                begin
                    if Rec."MFG. Date" <> 0D then begin
                        Rec.TestField("Lot No.");
                        if L_Item.get(Rec."Item No.") then
                            if Format(L_Item."Expiry Date Formula") <> '' then begin
                                Rec."Expiration Date" := CalcDate(L_Item."Expiry Date Formula", Rec."MFG. Date");
                                Rec.Modify();
                            end;
                    end else
                        Clear(Rec."Expiration Date");
                end;
            }
            field(Tin; Rec.Tin)
            {
                Editable = Item_Editable;
                ApplicationArea = all;
            }
            field(Drum; Rec.Drum)
            {
                ApplicationArea = all;
                Editable = Item_Editable;
            }
            field(Bucket; Rec.Bucket)
            {
                ApplicationArea = all;
                Editable = Item_Editable;
            }
        }
    }

    actions
    {
    }

    var
        Item_Editable: Boolean;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        if Rec."Source Type" <> 39 then
            Item_Editable := false
        else
            Item_Editable := true;
    end;

    trigger OnAfterGetRecord()
    var

    begin
        if Rec."Source Type" <> 39 then
            Item_Editable := false
        else
            Item_Editable := true;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var

    // TrackingSpecfiaction: Record "Tracking Specification";
    begin

        /*         rec.TestField("MRP Price");
                Rec.TestField("MFG. Date");
                Rec.TestField("Lot No.");
                Rec.TestField("Expiration Date"); */
    end;
}