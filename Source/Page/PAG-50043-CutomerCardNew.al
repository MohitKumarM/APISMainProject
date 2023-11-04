page 50043 "Customer Card New"
{


    Caption = 'Customer Card';
    LinksAllowed = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Customer;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    Importance = Promoted;
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        IF Rec.AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Name; Rec.Name)
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }

                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                }
                field("Address 3"; Rec."Address 3")
                {
                    ApplicationArea = All;
                }
                field("Post Code"; Rec."Post Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("State Code"; Rec."State Code")
                {
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    var
                        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
                        CustLedgEntry: Record "Cust. Ledger Entry";
                    begin
                        DtldCustLedgEntry.SETRANGE("Customer No.", Rec."No.");
                        Rec.COPYFILTER("Global Dimension 1 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 1");
                        Rec.COPYFILTER("Global Dimension 2 Filter", DtldCustLedgEntry."Initial Entry Global Dim. 2");
                        Rec.COPYFILTER("Currency Filter", DtldCustLedgEntry."Currency Code");
                        CustLedgEntry.DrillDownOnEntries(DtldCustLedgEntry);
                    end;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                }
                field("Phone No.2"; Rec."Phone No.")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }

                field("E-Mail"; Rec."E-Mail")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = All;
                }
                field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }

                field("Customer Posting Group"; Rec."Customer Posting Group")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Customer Price Group"; Rec."Customer Price Group")
                {
                    ApplicationArea = All;
                }
                field("Application Method"; Rec."Application Method")
                {
                    ApplicationArea = All;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }

                field("GST Registration No."; Rec."GST Registration No.")
                {
                    ApplicationArea = All;
                }
                field("GST Customer Type"; Rec."GST Customer Type")
                {
                    ApplicationArea = All;
                }
                field("P.A.N. No."; Rec."P.A.N. No.")
                {
                    Importance = Promoted;
                    ApplicationArea = All;
                }
                field("P.A.N. Status"; Rec."P.A.N. Status")
                {
                    ApplicationArea = All;
                }
                field("P.A.N. Reference No."; Rec."P.A.N. Reference No.")
                {
                    Caption = 'P.A.N. Reference No.';
                    ApplicationArea = All;
                }
                field("Skip TCS Calc."; Rec."Skip TCS")
                {
                    ApplicationArea = All;
                }
                field("Quality Process"; Rec."Quality Process")
                {
                    ApplicationArea = All;
                }
                field("Authorized person"; Rec."Authorized person")
                {
                    ApplicationArea = All;
                }
                field("Print Name"; Rec."Print Name")
                {
                    ApplicationArea = all;
                }
                field("RSM Name"; Rec."RSM Name")
                {
                    ApplicationArea = All;
                }
                field("Security Cheque No"; Rec."Security Cheque No")
                {
                    ApplicationArea = All;
                }
                field("MSME No."; Rec."MSME No.")
                {
                    ApplicationArea = All;
                }
                field("FASSAI No."; Rec."FASSAI No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Customer")
            {
                Caption = '&Customer';
                Image = Customer;
                action(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = CONST(18),
                                  "No." = FIELD("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Ship-&to Addresses")
                {
                    Caption = 'Ship-&to Addresses';
                    Image = ShipAddress;
                    RunObject = Page "Ship-to Address List";
                    RunPageLink = "Customer No." = FIELD("No.");
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Customer Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                    ShortCutKey = 'F7';
                }
                action("S&ales")
                {
                    Caption = 'S&ales';
                    Image = Sales;
                    RunObject = Page "Customer Sales";
                    RunPageLink = "No." = FIELD("No."),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }
                action("Entry Statistics")
                {
                    Caption = 'Entry Statistics';
                    Image = EntryStatistics;
                    RunObject = Page "Customer Entry Statistics";
                    RunPageLink = "No." = FIELD("No."),
                                  "Date Filter" = FIELD("Date Filter"),
                                  "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                                  "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter");
                }

                action("Ledger E&ntries")
                {
                    Caption = 'Ledger E&ntries';
                    Image = CustomerLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Customer Ledger Entries";
                    RunPageLink = "Customer No." = FIELD("No.");
                    RunPageView = SORTING("Customer No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("Ledger Report")
                {
                    Caption = 'Ledger Report';
                    RunObject = Report "Customer - Detail Trial Bal.";
                    RunPageOnRec = true;
                }
                action(PriceLines)
                {
                    AccessByPermission = TableData "Sales Price Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Prices';
                    Image = Price;
                    Scope = Repeater;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'View or set up sales price lines for products that you sell to the customer. A product price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                    trigger OnAction()
                    var
                        PriceSource: Record "Price Source";
                        PriceUXManagement: Codeunit "Price UX Management";
                    begin
                        Rec.ToPriceSource(PriceSource);
                        PriceUXManagement.ShowPriceListLines(PriceSource, "Price Amount Type"::Price);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ActivateFields;
        StyleTxt := Rec.SetStyle;
    end;

    trigger OnAfterGetRecord()
    begin
        ActivateFields;
        StyleTxt := Rec.SetStyle;
    end;

    trigger OnInit()
    begin
        ContactEditable := TRUE;
        MapPointVisible := TRUE;
    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
    begin
        ActivateFields;
        IF NOT MapMgt.TestSetup THEN
            MapPointVisible := FALSE;
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        Rec.TESTFIELD("RSM Name");
        Rec.TESTFIELD("Security Cheque No");
        Rec.TESTFIELD("MSME No.");
        Rec.TESTFIELD("E-Mail");
    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        ExtendedPriceEnabled: Boolean;
        Text001: Label 'Do you want to allow payment tolerance for entries that are currently open?';
        CustomizedCalendar: Record "Customized Calendar Change";
        Text002: Label 'Do you want to remove payment tolerance from entries that are currently open?';
        CalendarMgmt: Codeunit "Calendar Management";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        StyleTxt: Text;

        MapPointVisible: Boolean;

        ContactEditable: Boolean;


    procedure ActivateFields()
    begin
        ContactEditable := Rec."Primary Contact No." = '';
    end;

    local procedure ContactOnAfterValidate()
    begin
        ActivateFields;
    end;
}

