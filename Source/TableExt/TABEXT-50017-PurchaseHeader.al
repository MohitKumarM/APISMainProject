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