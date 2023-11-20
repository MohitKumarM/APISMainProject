pageextension 50042 MyExtension extends "Prod. Order Components"
{
    layout
    {
        addbefore("Quantity per")
        {
            field("Required Qty"; Rec."Required Qty")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    Rec."Quantity per" := CalculateQuantityRequired();
                    Rec.Validate("Quantity per");
                end;
            }
        }
        addafter("Routing Link Code")
        {
            field("Consumed Qty."; Rec."Consumed Qty.")
            {
                ApplicationArea = all;
            }
            field("Lot Tracking Qty."; Rec."Lot Tracking Qty.")
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

    procedure CalculateQuantityRequired(): Decimal
    var
        ProdOrderLine: Record "Prod. Order Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        Item_Loc: Record Item;
        ProdBomHeader: Record "Production BOM Header";
        ProdBomLine: Record "Production BOM Line";
        TotalQuantityWithScrap: Decimal;
        NetScrap: Decimal;

    begin
        Clear(NetScrap);
        Clear(TotalQuantityWithScrap);

        ProdOrderLine.GET(Rec.Status, Rec."Prod. Order No.", Rec."Prod. Order Line No.");

        Rec."Due Date" := ProdOrderLine."Starting Date";

        ProdOrderRtngLine.RESET;
        ProdOrderRtngLine.SETRANGE(Status, Rec.Status);
        ProdOrderRtngLine.SETRANGE("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderRtngLine.SETRANGE("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        IF Rec."Routing Link Code" <> '' THEN
            ProdOrderRtngLine.SETRANGE("Routing Link Code", Rec."Routing Link Code");
        IF ProdOrderRtngLine.FINDFIRST THEN begin
            TotalQuantityWithScrap := (ProdOrderLine.Quantity *
                  (1 + ProdOrderLine."Scrap %" / 100) *
                  (1 + ProdOrderRtngLine."Scrap Factor % (Accumulated)") *
                  (1 + Rec."Scrap %" / 100) +
                  ProdOrderRtngLine."Fixed Scrap Qty. (Accum.)");
        end else begin
            TotalQuantityWithScrap := (ProdOrderLine.Quantity *
              (1 + ProdOrderLine."Scrap %" / 100) * (1 + Rec."Scrap %" / 100));
        end;

        NetScrap := TotalQuantityWithScrap - ProdOrderLine.Quantity;
        exit(Rec."Required Qty" / (ProdOrderLine.Quantity - NetScrap));
    end;
}