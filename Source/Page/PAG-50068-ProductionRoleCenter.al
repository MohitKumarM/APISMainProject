page 50068 "Production Role Center"
{
    Caption = 'Production Role Center';
    PageType = RoleCenter;
    actions
    {
        area(Sections)
        {
            group("Group")
            {
                action("Production Planning")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Production Planning';
                    RunObject = page "Production Planning";

                }

                action("Prod. Order to Refresh")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Prod. Order to Refresh';
                    RunObject = page "Production Orders to Refresh";

                }
                action("Select Honey Batch")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Select Honey Batch';
                    RunObject = page "Prod. Orders Material Request";

                }
                action("Output Journal")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Output Journal';
                    RunObject = page "Output Journal";

                }
                action("Output Posting")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Output Posting';
                    RunObject = page "Output Posting";

                }
                action("Material Requisition")
                {
                    ApplicationArea = Manufacturing;
                    Caption = 'Material Requisition';
                    RunObject = page "Material Req. List";

                }

            }
        }
    }
}
