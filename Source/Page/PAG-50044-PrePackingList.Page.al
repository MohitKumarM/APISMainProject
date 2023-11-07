page 50044 "Pre Packing List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Pre Packing List";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Item Code"; Rec."Item Code")
                {
                    ToolTip = 'Specifies the value of the Item Code field.';
                }
                field("Order No."; Rec."Order No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Order No. field.';
                }
                field("Order Line No."; Rec."Order Line No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Order Line No. field.';
                }
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Specifies the value of the Item Description field.';
                }
                field("Batch No."; Rec."Batch No.")
                {
                    ToolTip = 'Specifies the value of the Batch No. field.';
                }
                field("Best Before"; Rec."Best Before")
                {
                    ToolTip = 'Specifies the value of the Best Before field.';
                }
                field("Cartoons Serial No."; Rec."Cartoons Serial No.")
                {
                    ToolTip = 'Specifies the value of the Cartoons Serial No. field.';
                }
                field("Container No."; Rec."Container No.")
                {
                    ToolTip = 'Specifies the value of the Container No. field.';
                }
                field("Drum Weight (Kg.)"; Rec."Drum Weight (Kg.)")
                {
                    ToolTip = 'Specifies the value of the Drum Weight (Kg.) field.';
                }
                field("Expiry Date"; Rec."Expiry Date")
                {
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field("FCL Type"; Rec."FCL Type")
                {
                    ToolTip = 'Specifies the value of the FCL Type field.';
                }
                field("Factory Code"; Rec."Factory Code")
                {
                    ToolTip = 'Specifies the value of the Factory Code field.';
                }
                field("Gross Weight In Kg"; Rec."Gross Weight In Kg")
                {
                    ToolTip = 'Specifies the value of the Gross Weight In Kg field.';
                }
                field("Meilleur Avant"; Rec."Meilleur Avant")
                {
                    ToolTip = 'Specifies the value of the Meilleur Avant field.';
                }
                field("Net Weight In Kg"; Rec."Net Weight In Kg")
                {
                    ToolTip = 'Specifies the value of the Net Weight In Kg field.';
                }
                field("No. of Pallets"; Rec."No. of Pallets")
                {
                    ToolTip = 'Specifies the value of the No. of Pallets field.';
                }

                field(Packing; Rec.Packing)
                {
                    ToolTip = 'Specifies the value of the Packing field.';
                }
                field("Packing Size"; Rec."Packing Size")
                {
                    ToolTip = 'Specifies the value of the Packing Size field.';
                }
                field("Pallet Serial No."; Rec."Pallet Serial No.")
                {
                    ToolTip = 'Specifies the value of the Pallet Serial No. field.';
                }
                field("Pallet Total"; Rec."Pallet Total")
                {
                    ToolTip = 'Specifies the value of the Pallet Total field.';
                }
                field("Pallet Weight (Kg.)"; Rec."Pallet Weight (Kg.)")
                {
                    ToolTip = 'Specifies the value of the Pallet Weight (Kg.) field.';
                }
                field("Per Pallet Weight"; Rec."Per Pallet Weight")
                {
                    ToolTip = 'Specifies the value of the Per Pallet Weight field.';
                }
                field("Prod. Date"; Rec."Prod. Date")
                {
                    ToolTip = 'Specifies the value of the Prod. Date field.';
                }
                field("Product Code"; Rec."Product Code")
                {
                    ToolTip = 'Specifies the value of the Product Code field.';
                }
                field("Product Code Text"; Rec."Product Code Text")
                {
                    ToolTip = 'Specifies the value of the Product Code Text field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
                field("Quantity In Case Of Drum"; Rec."Quantity In Case Of Drum")
                {
                    ToolTip = 'Specifies the value of the Quantity In Case Of Drum field.';
                }
                field("Tare Weight"; Rec."Tare Weight")
                {
                    ToolTip = 'Specifies the value of the Tare Weight field.';
                }
                field("Total Pallet Weight Kg"; Rec."Total Pallet Weight Kg")
                {
                    ToolTip = 'Specifies the value of the Total Pallet Weight Kg field.';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}