tableextension 50021 PurchaseInvoiceHeader extends "Purch. Inv. Header"
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
        field(50005; "Freight Liability"; Option)
        {
            OptionCaption = ' ,Supplier,Buyer';
            OptionMembers = " ",Supplier,Buyer;
            DataClassification = ToBeClassified;
        }
        field(50006; "Waybill No."; Code[20])
        {
            Caption = 'E-Way Bill';
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
        field(80002; "GST Dependency Type"; Option)
        {
            OptionMembers = " ","Buy-from Address","Order Address","Location Address";
            // ValuesAllowed = " ";
            // "Buy-from Address";
        }
        field(90002; "Product Group Code"; Code[50])
        {
            DataClassification = ToBeClassified;
            TableRelation = "New Product Group".Code;
        }
        field(50007; "GAN Approval Pending"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "GR / LR No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "GR / LR Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Gate Entry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Gate Entry No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Vendor Invoice Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}