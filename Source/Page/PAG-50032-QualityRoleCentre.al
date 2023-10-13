page 50032 "Quality Role Centre New"
{
    Caption = 'Quality Role Centre';
    PageType = RoleCenter;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(rolecenter)
        {
            group(General)
            {
                part("Quality Activities"; "Quality Activities New")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Masters)
            {
                Caption = 'Masters';
                Image = Journals;
                group("Masters View")
                {
                    Caption = 'Masters View';
                    Image = Bank;
                    action("Item View")
                    {
                        Image = Item;
                        // RunObject = Page 16566;
                    }
                }
                group("Production Design")
                {
                    Caption = 'Production Design';
                    Image = Bank;
                    action("BOM List View")
                    {
                        // RunObject = Page "Production BOM Lines View";
                    }
                    action("Quality Process")
                    {
                        Caption = 'Quality Process';
                        Image = Questionaire;
                        RunObject = Page "Standard Tasks";
                    }
                }
            }
        }
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';
                Image = Statistics;
                group("Production / Quality Reports")
                {
                    Caption = 'Production / Quality Reports';
                    Image = Ledger;

                    action("PM Stock with QC Details")
                    {
                        // RunObject = Report 50053;
                    }
                }
            }
            group("History & Balances")
            {
                Caption = 'History & Balances';
                group(Balances)
                {
                    Caption = 'Balances';
                    Image = Statistics;
                    action("Item Balance")
                    {
                        Caption = 'Item Balance';
                        RunObject = Page "VAT Product Posting Groups";
                    }
                }
            }
            group("Books and Ledger")
            {
                Caption = 'Books and Ledger';
                group(Ledgers)
                {
                    Caption = 'Ledgers';
                    Image = Ledger;
                    action("Item Ledger")
                    {
                        Caption = 'Item Ledger';
                        RunObject = Report "Inventory - Transaction Detail";
                    }
                }
            }
        }
    }
}

