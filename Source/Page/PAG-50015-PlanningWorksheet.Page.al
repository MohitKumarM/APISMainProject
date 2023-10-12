//>>----------------Documentation-------------------
//Created this page for Calculating Planning for Packing Material short on the basis of inventory and sales orders finished goods

//Field mapping for the used temporary table
//"Automatic Ext. Texts"		"No."		Description	"Base Unit of Measure"		"Item Category Code"	"Product Group Code"	Inventory Posting Group		"Unit Price"		"Unit Cost"	        "Standard Cost"		"Unit List Price"	"Rolled-up Material Cost"    Rec."Last Direct Cost"
//Select				        Item No.	Description	Item UOM			        Item Category Code	    Product Group Code	    Inventory Posting group		Total Stock Qty.	Total Demand for SO	Pending PO's		Qty on Indent		 Remaining /Required Qty.    "Qty. for Indent"

//<<-----------------------------------------------------


page 50015 "PM Planning Worksheet"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;
    Caption = 'PM Planning Worksheet';
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item UOM"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Inventory Posting Group"; Rec."Inventory Posting Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Product Group Code"; Rec."New Product Group Code")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Total Stock Qty."; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    Caption = 'Total Stock Qty.';
                    Editable = false;
                }
                field("Total Demand for SO"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Total Demand for SO';
                    Editable = false;
                }
                field("Pending PO's"; Rec."Standard Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Pending PO Qty';
                    Editable = false;
                }
                field("Qty on Indent"; Rec."Unit List Price")
                {
                    ApplicationArea = All;
                    Caption = 'Qty on Indent';
                    Editable = false;
                }
                field("Remaining / Required Qty."; Rec."Rolled-up Material Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Required Qty.';
                    Editable = false;
                }
                field("Select"; Rec."Automatic Ext. Texts")
                {
                    ApplicationArea = All;
                    Caption = 'Select';
                }
                field("Qty. for Indent"; Rec."Last Direct Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Qty. for Indent';

                    trigger OnValidate()
                    var
                    begin
                        IF (Rec."Last Direct Cost" > Rec."Rolled-up Material Cost") then
                            Error(StrSubstNo('Qty. for Indent must be less than or Equal to Required Qty. i.e -%1', Rec."Rolled-up Material Cost"));
                    end;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Update Planning Lines")
            {
                Caption = 'Update Planning Lines';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;


                trigger OnAction()
                begin
                    Update_PM_Planning_Worksheet();
                    CurrPage.Update(true);
                end;
            }
        }
    }

    local procedure Update_PM_Planning_Worksheet()
    var
        SalesLine_Rec: Record "Sales Line";
        Item_Rec: Record Item;
        Item_TempRec1: Record Item temporary;
        // Rec: Record Item temporary;
        INvPostGrp_Rec: Record "Inventory Posting Group";
        ProdBomHeader_Rec: Record "Production BOM Header";
        ProdBomLine_Rec: Record "Production BOM Line";
        PurchLine_Rec: Record "Purchase Line";
        Inventory_Var: Decimal;
        BOM_Inventory_Var: Decimal;
        BOM_Demand_Qty_Var: Decimal;
    begin
        IF Rec.IsTemporary then Begin
            Rec.DeleteAll();

            IF Item_TempRec1.IsTemporary then
                Item_TempRec1.DeleteAll();
            // IF Rec.IsTemporary then
            //     Rec.DeleteAll();

            SalesLine_Rec.Reset();
            SalesLine_Rec.SetCurrentKey(Type, "No.");
            SalesLine_Rec.SetRange("Document Type", SalesLine_Rec."Document Type"::Order);
            SalesLine_Rec.SetRange(Type, SalesLine_Rec.Type::Item);
            IF SalesLine_Rec.FindSet() THEN begin
                repeat
                    IF Item_Rec.Get(SalesLine_Rec."No.") then;
                    IF INvPostGrp_Rec.Get(Item_Rec."Inventory Posting Group") and INvPostGrp_Rec."Planning Applicable" THEN begin
                        IF not Item_TempRec1.Get(SalesLine_Rec."No.") THEN begin
                            Item_TempRec1.Init();
                            Item_TempRec1."No." := Item_Rec."No.";
                            Item_TempRec1.Description := Item_Rec.Description;
                            Item_TempRec1."Base Unit of Measure" := SalesLine_Rec."Unit of Measure Code";
                            Item_TempRec1."Item Category Code" := SalesLine_Rec."Item Category Code";
                            Item_TempRec1."New Product Group Code" := Item_Rec."New Product Group Code";
                            Item_TempRec1."Inventory Posting Group" := Item_Rec."Inventory Posting Group";
                            Item_TempRec1."Unit Cost" := (SalesLine_Rec.Quantity - SalesLine_Rec."Quantity Shipped");
                            Item_TempRec1.Insert();
                        end else begin
                            Item_TempRec1."Unit Cost" += (SalesLine_Rec.Quantity - SalesLine_Rec."Quantity Shipped");
                            Item_TempRec1.Modify();
                        end;
                    end;
                until SalesLine_Rec.next() = 0;
            end;

            Item_TempRec1.Reset();
            IF Item_TempRec1.FindSet() then begin
                repeat
                    Clear(Inventory_Var);
                    Item_Rec.Get(Item_TempRec1."No.");
                    Item_Rec.CalcFields(Inventory);
                    Inventory_Var := Item_Rec.Inventory;

                    IF (Item_TempRec1."Unit Cost" > Inventory_Var) then begin
                        Item_TempRec1."Unit Cost" := Item_TempRec1."Unit Cost" - Inventory_Var;
                        IF ProdBomHeader_Rec.Get(Item_Rec."Production BOM No.") and (ProdBomHeader_Rec.Status = ProdBomHeader_Rec.Status::Certified) then begin
                            ProdBomLine_Rec.Reset();
                            ProdBomLine_Rec.SetRange("Production BOM No.", ProdBomHeader_Rec."No.");
                            ProdBomLine_Rec.SetFilter("Version Code", '');
                            ProdBomLine_Rec.SetRange(Type, ProdBomLine_Rec.Type::Item);
                            IF ProdBomLine_Rec.FindSet() THEN begin
                                repeat
                                    Item_Rec.Get(ProdBomLine_Rec."No.");
                                    Item_Rec.CalcFields(Inventory);
                                    BOM_Inventory_Var := Item_Rec.Inventory;

                                    BOM_Demand_Qty_Var := ProdBomLine_Rec."Quantity per" * Item_TempRec1."Unit Cost";

                                    IF (BOM_Inventory_Var < BOM_Demand_Qty_Var) then begin

                                        IF not Rec.Get(ProdBomLine_Rec."No.") then begin
                                            Rec.Init();
                                            Rec."No." := ProdBomLine_Rec."No.";
                                            Rec.Description := ProdBomLine_Rec.Description;
                                            Rec."Base Unit of Measure" := ProdBomLine_Rec."Unit of Measure Code";
                                            Rec."Item Category Code" := Item_Rec."Item Category Code";
                                            Rec."New Product Group Code" := Item_Rec."New Product Group Code";
                                            Rec."Inventory Posting Group" := Item_Rec."Inventory Posting Group";
                                            Rec."Unit Price" := BOM_Inventory_Var;
                                            Rec."Unit Cost" := ProdBomLine_Rec."Quantity per" * Item_TempRec1."Unit Cost";

                                            PurchLine_Rec.Reset();
                                            PurchLine_Rec.SetRange("Document Type", PurchLine_Rec."Document Type"::Order);
                                            PurchLine_Rec.SetRange(Type, PurchLine_Rec.Type::Item);
                                            PurchLine_Rec.SetFilter("No.", Rec."No.");
                                            IF PurchLine_Rec.FindSet() then begin
                                                repeat
                                                    Rec."Standard Cost" += PurchLine_Rec.Quantity - PurchLine_Rec."Quantity Received";
                                                until PurchLine_Rec.Next() = 0;
                                            end;


                                            Rec."Rolled-up Material Cost" := Abs((Rec."Unit Price" - Rec."Unit Cost") + Rec."Standard Cost");
                                            Rec.Insert();
                                        end else begin
                                            Rec."Unit Cost" += ProdBomLine_Rec."Quantity per" * Item_TempRec1."Unit Cost";
                                            Rec."Rolled-up Material Cost" := Abs((Rec."Unit Price" - Rec."Unit Cost") + Rec."Standard Cost");
                                            Rec.Modify();
                                        end;
                                    end;
                                until ProdBomLine_Rec.Next() = 0;
                            end;
                        end else begin
                            //>>Non BOM Item
                            Item_Rec.Get(Item_TempRec1."No.");
                            IF not Rec.Get(Item_Rec."No.") then begin
                                Rec.Init();
                                Rec."No." := Item_Rec."No.";
                                Rec.Description := Item_Rec.Description;
                                Rec."Base Unit of Measure" := Item_Rec."Base Unit of Measure";
                                Rec."Item Category Code" := Item_Rec."Item Category Code";
                                Rec."New Product Group Code" := Item_Rec."New Product Group Code";
                                Rec."Inventory Posting Group" := Item_Rec."Inventory Posting Group";
                                Rec."Unit Price" := Inventory_Var;
                                Rec."Unit Cost" := Item_TempRec1."Unit Cost";

                                PurchLine_Rec.Reset();
                                PurchLine_Rec.SetRange("Document Type", PurchLine_Rec."Document Type"::Order);
                                PurchLine_Rec.SetRange(Type, PurchLine_Rec.Type::Item);
                                PurchLine_Rec.SetFilter("No.", Item_Rec."No.");
                                IF PurchLine_Rec.FindSet() then begin
                                    repeat
                                        Rec."Standard Cost" += PurchLine_Rec.Quantity - PurchLine_Rec."Quantity Received";
                                    until PurchLine_Rec.Next() = 0;
                                end;

                                Rec."Rolled-up Material Cost" := Abs((Rec."Unit Price" - Rec."Unit Cost") + Rec."Standard Cost");
                                Rec."Automatic Ext. Texts" := false;
                                Rec.Insert();
                            end else begin
                                Rec."Automatic Ext. Texts" := false;
                                Rec."Unit Cost" += Item_TempRec1."Unit Cost";
                                Rec."Rolled-up Material Cost" := Abs((Rec."Unit Price" - Rec."Unit Cost") + Rec."Standard Cost");
                                Rec.Modify();
                            end;
                            //<<
                        end;
                    end;
                until Item_TempRec1.Next() = 0;
            end;
        end;
        Message('Planning Worksheet has been calculated successfully');
    end;

    trigger OnOpenPage()
    begin

    end;


    var
        myInt: Integer;
}