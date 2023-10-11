pageextension 50019 PurchaseOrder extends "Purchase Order"
{

    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Order Type"; Rec."Order Type")
            {
                ApplicationArea = all;
            }
            field("Short Close Comment"; Rec."Short Close Comment")
            {
                ApplicationArea = all;
            }
        }
    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if not CONFIRM('Do you want to Receive the selected Order?', false) then
                    exit;
            end;
        }
        modify(Statistics)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                rec.CallnewTdsfunctionsForMessage();//200523
                Rec.CallnewTdsfunctions();//200523
            end;
        }
        addafter("Archive Document")
        {
            action("Short Closed")
            {
                Caption = 'Short Closed';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                trigger OnAction()
                var
                    PurchasePayableSetup: Record "Purchases & Payables Setup";
                    PurchaseHeader: Record "Purchase Header";
                    ArchiveManagement: Codeunit ArchiveManagement;
                begin
                    PurchasePayableSetup.get;
                    PurchasePayableSetup.TestField("Archive Orders", true);
                    rec.TestField("Short Close Comment");
                    IF NOT CONFIRM('Do you want to Short Close the selected Order?', FALSE) THEN
                        EXIT;
                    Rec."Short Close" := true;
                    Rec.Modify();
                    ArchiveManagement.AutoArchivePurchDocument(Rec);
                    CurrPage.Close();
                end;
            }
        }

    }
    trigger OnOpenPage()
    begin
        Rec.FILTERGROUP(2);
        Rec.SetRange("Short Close", false);
        Rec.FILTERGROUP(0);
    end;




}