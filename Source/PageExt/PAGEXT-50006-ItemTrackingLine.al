pageextension 50006 ItemTrackingLine extends "Item Tracking Lines"
{
    layout
    {
        modify("Lot No.")
        {
            trigger OnAfterValidate()
            var
                PriceListLine: Record "Price List Line";
            begin
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

        }
        addafter("Appl.-from Item Entry")
        {
            field("MRP Price"; Rec."MRP Price")
            {
                ApplicationArea = all;

            }
        }
    }


    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;



    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
    begin
        rec.TestField("MRP Price");
    end;
}