pageextension 50013 PurchaOrderSubform extends "Purchase Order Subform"
{
    layout
    {

        addafter(Description)
        {
            field("Deal No."; Rec."Deal No.")
            {
                ApplicationArea = All;
                Visible = false;
            }

            field("Packing Type"; Rec."Packing Type")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Qty. in Pack"; Rec."Qty. in Pack")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Dispatched Qty. in Kg."; Rec."Dispatched Qty. in Kg.")
            {
                ApplicationArea = All;
                Caption = 'Order Quantity';
                Visible = false;
            }
            field(Flora; Rec.Flora)
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Unit Rate"; Rec."Unit Rate")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Purchaser Code"; Rec."Purchaser Code")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("Other Charges"; Rec."Other Charges")
            {
                ApplicationArea = all;
                Visible = false;
            }
            field("P.A.N. No."; Rec."P.A.N. No.")
            {
                ApplicationArea = All;
            }
            field("New TDS Base Amount"; Rec."New TDS Base Amount")
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


    procedure UpdateTaxAmount()
    var
        CalculateTax: Codeunit "Calculate Tax";
    begin
        CurrPage.SaveRecord();
        CalculateTax.CallTaxEngineOnPurchaseLine(Rec, xRec);
    end;

}