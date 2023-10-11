tableextension 50017 PurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(50000; "Order Type"; Option)
        {
            OptionCaption = ' ,Honey,Packing Material,Other';
            OptionMembers = " ",Honey,"Packing Material",Other;
        }
        field(50001; "Invoice Type Old"; Option)
        {
            OptionCaption = 'Trading';
            OptionMembers = Trading;
        }
        field(50002; "Short Close Comment"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Order Approval Pending"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Shipping Vendor"; Code[20])
        {
            TableRelation = Vendor;
        }
        field(50017; "Transit Insurance"; Option)
        {
            OptionCaption = ' ,Buyer Scope,Supplier Scope';
            OptionMembers = " ","Buyer Scope","Supplier Scope";
        }
        field(50018; "Valid Till"; Date)
        {
        }
        field(50005; "Freight Liability"; Option)
        {
            OptionCaption = ' ,Supplier,Buyer';
            OptionMembers = " ",Supplier,Buyer;
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD(Status, Status::Open);
            end;
        }
        field(80002; "GST Dependency Type"; Option)
        {
            OptionMembers = " ","Buy-from Address","Order Address","Location Address";
            // ValuesAllowed = " ";
            // "Buy-from Address";

            trigger OnValidate()
            begin
                //TaxAreaUpdate;
            end;
        }
        field(50006; "Waybill No."; Code[20])
        {
            Caption = 'E-Way Bill';
        }
        field(90002; "Product Group Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "New Product Group".Code;

        }
        field(90003; "Short Close"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    var
        myInt: Integer;

    procedure CallnewTdsfunctionsForMessage()
    var
        PurchlineforTds: Record "Purchase Line";
    begin
        PurchlineforTds.Reset();
        PurchlineforTds.SetRange("Document Type", "Document Type");
        PurchlineforTds.SetRange("Document No.", "No.");
        PurchlineforTds.CalculateTDS_TradingTransForMessage(Rec);
    end;

    procedure CallnewTdsfunctions()
    var
        PurchlineforTds: Record "Purchase Line";
    begin
        PurchlineforTds.Reset();
        PurchlineforTds.SetRange("Document Type", "Document Type");
        PurchlineforTds.SetRange("Document No.", "No.");
        PurchlineforTds.CalculateTDS_TradingTrans(Rec);
    end;

    trigger OnAfterInsert()
    begin
        Rec."Invoice Type Old" := Rec."Invoice Type Old"::Trading;
    end;

}