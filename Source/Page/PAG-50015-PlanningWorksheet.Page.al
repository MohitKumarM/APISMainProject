page 50015 "PM Planning Worksheet"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Item;
    Caption = 'PM Planning Worksheet';
    SourceTableTemporary = true;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Select"; Rec."Price Includes VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Select';

                }
                field("Item No."; Rec."No.")
                {
                    ApplicationArea = All;

                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;

                }
                field("Item UOM"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;

                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;

                }
                field("Product Group Code"; Rec."New Product Group Code")
                {
                    ApplicationArea = All;

                }
                field("Total Stock Qty."; Rec."Unit Price")
                {
                    ApplicationArea = All;

                }
                field("Total SO Qty."; Rec."Unit Cost")
                {
                    ApplicationArea = All;

                }
                field("Pending PO's"; Rec."Standard Cost")
                {
                    ApplicationArea = All;

                }
                field("Qty on Indent"; Rec."Unit List Price")
                {
                    ApplicationArea = All;

                }
                field("Remaining / Required Qty."; Rec."Rolled-up Material Cost")
                {
                    ApplicationArea = All;

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
    begin

    end;

    var
        myInt: Integer;
}