page 50048 "Customer Child Group Subform"
{
    ApplicationArea = All;
    Caption = 'Customer Child Group Subform';
    PageType = ListPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the customer''s name.';
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {

                }
            }
        }
    }
}
