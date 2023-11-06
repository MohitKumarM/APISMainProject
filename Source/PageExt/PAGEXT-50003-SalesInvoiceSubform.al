pageextension 50003 SalesInvoiceSubform extends "Sales Invoice Subform"
{
    layout
    {
        modify("TCS Nature of Collection")
        {
            Visible = false;
        }
        addafter("TCS Nature of Collection")
        {
            field("TCS Nature of Collection 1"; Rec."TCS Nature of Collection 1")
            {
                Caption = 'TCS Nature of Collection';
                trigger OnLookup(var Text: Text): Boolean
                var
                    LCustomer: Record Customer;
                begin
                    Clear(rec."TCS Nature of Collection");
                    Clear(rec."TCS Nature of Collection 1");
                    if LCustomer.get(Rec."Sell-to Customer No.") then
                        if not LCustomer."Skip Tcs" then begin
                            Rec.AllowedNocLookup(Rec, Rec."Sell-to Customer No.");
                            Rec."TCS Nature of Collection 1" := Rec."TCS Nature of Collection";
                            UpdateTaxAmount();
                        end else begin
                            UpdateTaxAmount();
                            Message('Not eligible for TCS');
                        end;
                end;

                trigger OnValidate()
                var
                    LCustomer: Record Customer;
                    AllowedNOC: Record "Allowed NOC";
                    TCSNatureOfCollection: Record "TCS Nature Of Collection";
                    NOCTypeErr: Label '%1 does not exist in table %2.', Comment = '%1=TCS Nature of Collection., %2=The Table Name.';
                    NOCNotDefinedErr: Label 'TCS Nature of Collection %1 is not defined for Customer no. %2.', Comment = '%1= TCS Nature of Collection, %2=Customer No.';
                begin
                    Rec."TCS Nature of Collection" := rec."TCS Nature of Collection 1";
                    UpdateTaxAmount();
                    if Rec."TCS Nature of Collection 1" = '' then
                        exit;
                    if not TCSNatureOfCollection.Get(Rec."TCS Nature of Collection 1") then
                        Error(NOCTypeErr, Rec."TCS Nature of Collection 1", TCSNatureOfCollection.TableCaption());

                    if not AllowedNOC.Get(Rec."Bill-to Customer No.", Rec."TCS Nature of Collection 1") then
                        Error(NOCNotDefinedErr, Rec."TCS Nature of Collection 1", Rec."Bill-to Customer No.");
                    if LCustomer.get(Rec."Sell-to Customer No.") then
                        if LCustomer."Skip Tcs" then begin
                            Clear(rec."TCS Nature of Collection");
                            Clear(rec."TCS Nature of Collection 1");
                            UpdateTaxAmount();
                            Message('Not eligible for TCS');
                        end;
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    local procedure UpdateTaxAmount()
    var
        CalculateTax: Codeunit "Calculate Tax";
    begin
        CurrPage.SaveRecord();
        CalculateTax.CallTaxEngineOnSalesLine(Rec, xRec);
    end;
}