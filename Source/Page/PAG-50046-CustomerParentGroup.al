page 50046 "Customer Parent Group"
{
    PageType = List;
    Caption = 'Customer Groups';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = 18;
    SourceTableView = WHERE("Parent Group" = filter(<> ''));
    CardPageId = 50047;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Parent Group"; Rec."Parent Group")
                {
                    ApplicationArea = All;

                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = all;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
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