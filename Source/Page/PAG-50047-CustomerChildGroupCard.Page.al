page 50047 "Customer Child Group Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = 18;
    layout
    {
        area(Content)
        {
            group(GroupName)
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

            part("Customer Child Group"; "Customer Child Group Subform")
            {
                SubPageLink = "Child Group" = field("Parent Group");
            }

        }

    }
}