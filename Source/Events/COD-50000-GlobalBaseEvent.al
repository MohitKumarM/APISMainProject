codeunit 50000 Tble83
{
    trigger OnRun()
    begin

    end;
    // Table83 Start

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    var
        recDeal: Record "Deal Dispatch Details";
        recSalespersonPurchaser: Record "Salesperson/Purchaser";
    begin
        //Iappc - 16 Jan 16 - Deals Details Begin
        ItemJnlLine."Deal No." := PurchLine."Deal No.";
        ItemJnlLine."Deal Line No." := PurchLine."Deal Line No.";
        ItemJnlLine."Packing Type" := PurchLine."Packing Type";
        ItemJnlLine."Qty. in Pack" := PurchLine."Qty. in Pack";
        ItemJnlLine."Dispatched Qty. in Kg." := PurchLine."Dispatched Qty. in Kg.";
        ItemJnlLine.Flora := PurchLine.Flora;
        ItemJnlLine."New Product Group Code" := PurchLine."New Product Group Code";

        IF recDeal.GET(PurchLine."Deal No.", PurchLine."Deal Line No.") THEN
            ItemJnlLine."Vehicle No." := recDeal."Vehicle No.";
        ItemJnlLine."Purchaser Code" := PurchLine."Purchaser Code";
        IF recSalespersonPurchaser.GET(PurchLine."Purchaser Code") THEN
            ItemJnlLine."Purchaser Name" := recSalespersonPurchaser.Name;
        //Iappc - 16 Jan 16 - Deals Details End
    end;

    // Table83 End

    // Codeunit22 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    var
    begin
        NewItemLedgEntry."Deal No." := ItemJournalLine."Deal No.";
        NewItemLedgEntry."Deal Line No." := ItemJournalLine."Deal Line No.";
        NewItemLedgEntry."Dispatched Qty. in Kg." := ItemJournalLine."Dispatched Qty. in Kg.";
        NewItemLedgEntry.Flora := ItemJournalLine.Flora;
        NewItemLedgEntry."Vehicle No." := ItemJournalLine."Vehicle No.";
        NewItemLedgEntry."Purchaser Code" := ItemJournalLine."Purchaser Code";
        NewItemLedgEntry."Purchaser Name" := ItemJournalLine."Purchaser Name";
    end;
    // Codeunit22 End

    // Codeunit90 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvLineInsert', '', false, false)]
    local procedure OnAfterPurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchHeader: Record "Purchase Header"; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header")
    var
        decCurrencyFactor: Decimal;
        recVendor: Record Vendor;
        Location: Record Location;
        BeekeeperLedgerEntries: Record "BeeKeeper VendorLedger Entries";
        BeekeeperEntryNo: Integer;
    begin
        //Iappc - 20 Mar 15 - Purchase Report Update end

        //Iappc - 23 Jan 16 - Beekeeper Accounting Begin
        IF (PurchInvLine."Deal No." <> '') THEN BEGIN
            BeekeeperLedgerEntries.RESET;
            IF BeekeeperLedgerEntries.FINDLAST THEN
                BeekeeperEntryNo := BeekeeperLedgerEntries."Entry No."
            ELSE
                BeekeeperEntryNo := 0;

            BeekeeperLedgerEntries.INIT;
            BeekeeperEntryNo += 1;
            BeekeeperLedgerEntries."Entry No." := BeekeeperEntryNo;
            BeekeeperLedgerEntries."Vendor Code" := PurchInvHeader."Buy-from Vendor No.";
            BeekeeperLedgerEntries."Beekeeper Code" := PurchInvLine."Purchaser Code";
            BeekeeperLedgerEntries."Document No." := PurchInvLine."Document No.";
            BeekeeperLedgerEntries."Document Line No." := PurchInvLine."Line No.";
            BeekeeperLedgerEntries."Document Date" := PurchInvLine."Posting Date";
            BeekeeperLedgerEntries."External Document No." := PurchInvHeader."Vendor Invoice No.";
            BeekeeperLedgerEntries."Deal No." := PurchInvLine."Deal No.";
            BeekeeperLedgerEntries."Deal Dispatch No." := PurchInvLine."Deal Line No.";
            BeekeeperLedgerEntries.Flora := PurchInvLine.Flora;
            BeekeeperLedgerEntries."Dispatched Qty." := PurchInvLine."Qty. in Pack";
            BeekeeperLedgerEntries."Packing Type" := PurchInvLine."Packing Type";
            BeekeeperLedgerEntries."Vehicle No." := '';
            BeekeeperLedgerEntries."Qty. in Kg." := PurchInvLine."Dispatched Qty. in Kg.";
            BeekeeperLedgerEntries."Invoiced Qty." := PurchInvLine.Quantity;
            BeekeeperLedgerEntries."Unit Rate" := PurchInvLine."Unit Rate";
            BeekeeperLedgerEntries.Discount := PurchInvLine."Other Charges";
            BeekeeperLedgerEntries."Line Amount" := PurchInvLine."Line Amount";
            BeekeeperLedgerEntries."User Id" := USERID;
            BeekeeperLedgerEntries."Debit Amount" := 0;
            IF PurchInvLine."Dispatched Qty. in Kg." < PurchInvLine.Quantity THEN
                BeekeeperLedgerEntries."Credit Amount" := PurchInvLine."Dispatched Qty. in Kg." * (PurchInvLine."Unit Rate" - PurchInvLine."Other Charges")
            ELSE
                BeekeeperLedgerEntries."Credit Amount" := PurchInvLine.Quantity * (PurchInvLine."Unit Rate" - PurchInvLine."Other Charges");
            BeekeeperLedgerEntries.Amount := -BeekeeperLedgerEntries."Credit Amount";
            BeekeeperLedgerEntries.INSERT;
        END;
        //Iappc - 23 Jan 16 - Beekeeper Accounting End
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchCrMemoLineInsert', '', false, false)]
    local procedure OnAfterPurchCrMemoLineInsert(var PurchCrMemoLine: Record "Purch. Cr. Memo Line"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchLine: Record "Purchase Line"; CommitIsSupressed: Boolean; var PurchaseHeader: Record "Purchase Header")
    var
        decCurrencyFactor: Decimal;
        recVendor: Record Vendor;
        Location: Record Location;
        BeekeeperLedgerEntries: Record "BeeKeeper VendorLedger Entries";
        BeekeeperEntryNo: Integer;
    begin

        //Iappc - 20 Mar 15 - Purchase Report Update begin

        //Iappc - 23 Jan 16 - Beekeeper Accounting Begin
        IF (PurchCrMemoLine."Deal No." <> '') THEN BEGIN
            BeekeeperLedgerEntries.RESET;
            IF BeekeeperLedgerEntries.FINDLAST THEN
                BeekeeperEntryNo := BeekeeperLedgerEntries."Entry No."
            ELSE
                BeekeeperEntryNo := 0;

            BeekeeperLedgerEntries.INIT;
            BeekeeperEntryNo += 1;
            BeekeeperLedgerEntries."Entry No." := BeekeeperEntryNo;
            BeekeeperLedgerEntries."Vendor Code" := PurchCrMemoHdr."Buy-from Vendor No.";
            BeekeeperLedgerEntries."Beekeeper Code" := PurchCrMemoLine."Purchaser Code";
            BeekeeperLedgerEntries."Document No." := PurchCrMemoLine."Document No.";
            BeekeeperLedgerEntries."Document Line No." := PurchCrMemoLine."Line No.";
            BeekeeperLedgerEntries."Document Date" := PurchCrMemoLine."Posting Date";
            BeekeeperLedgerEntries."External Document No." := PurchCrMemoHdr."Vendor Cr. Memo No.";
            BeekeeperLedgerEntries."Deal No." := PurchCrMemoLine."Deal No.";
            BeekeeperLedgerEntries."Deal Dispatch No." := PurchCrMemoLine."Deal Line No.";
            BeekeeperLedgerEntries.Flora := PurchCrMemoLine.Flora;
            BeekeeperLedgerEntries."Dispatched Qty." := PurchCrMemoLine."Qty. in Pack";
            BeekeeperLedgerEntries."Packing Type" := PurchCrMemoLine."Packing Type";
            BeekeeperLedgerEntries."Vehicle No." := '';
            BeekeeperLedgerEntries."Qty. in Kg." := PurchCrMemoLine."Dispatched Qty. in Kg.";
            BeekeeperLedgerEntries."Invoiced Qty." := PurchCrMemoLine.Quantity;
            BeekeeperLedgerEntries."Unit Rate" := PurchCrMemoLine."Unit Rate";
            BeekeeperLedgerEntries.Discount := PurchCrMemoLine."Other Charges";
            BeekeeperLedgerEntries."Line Amount" := PurchCrMemoLine."Line Amount";
            BeekeeperLedgerEntries."User Id" := USERID;
            BeekeeperLedgerEntries."Debit Amount" := PurchCrMemoLine.Quantity * (PurchCrMemoLine."Unit Rate" - PurchCrMemoLine."Other Charges");
            BeekeeperLedgerEntries."Credit Amount" := 0;
            BeekeeperLedgerEntries.Amount := BeekeeperLedgerEntries."Debit Amount";
            BeekeeperLedgerEntries.INSERT;
        END;
        //Iappc - 23 Jan 16 - Beekeeper Accounting End
    end;

    // Codeunit90 End


    // Codeunit91 Start
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost_Purch(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer)
    var
        Rec_PurchLine: Record "Purchase Line";
    begin
        //Iappc - GAN Validation Begin
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) AND (PurchaseHeader."Order Type" = PurchaseHeader."Order Type"::Honey) THEN BEGIN
            Rec_PurchLine.RESET;
            Rec_PurchLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            Rec_PurchLine.SETRANGE("Document No.", PurchaseHeader."No.");
            IF Rec_PurchLine.FINDFIRST THEN
                REPEAT
                    Rec_PurchLine.TESTFIELD(Type, Rec_PurchLine.Type::Item);
                    Rec_PurchLine.TESTFIELD("No.");
                    Rec_PurchLine.TESTFIELD("Location Code");
                    Rec_PurchLine.TESTFIELD(Quantity);
                    Rec_PurchLine.TESTFIELD("Deal No.");
                    Rec_PurchLine.TESTFIELD("Packing Type");
                    Rec_PurchLine.TESTFIELD("Qty. in Pack");
                UNTIL Rec_PurchLine.NEXT = 0;
        END;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost(var PurchaseHeader: Record "Purchase Header")
    var
        Rec_UserSetup: Record "User Setup";
        Rec_PurchLine: Record "Purchase Line";
        Rec_PurchaseSetup: Record "Purchases & Payables Setup";
        Rec_DealDispatch: Record "Deal Dispatch Details";
        Rec_DealCard: Record "Deal Master";
    begin
        Rec_UserSetup.GET(USERID);
        IF PurchaseHeader."Document Type" IN [PurchaseHeader."Document Type"::Invoice, PurchaseHeader."Document Type"::"Credit Memo"] THEN BEGIN
            IF NOT Rec_UserSetup."Allow Purchase Invoice" THEN
                ERROR('You are not authorise to post invoice.');
        END ELSE BEGIN
            IF (PurchaseHeader.Receive) AND (NOT Rec_UserSetup."Allow Receipt") THEN
                ERROR('You are not authorise to post receipt.');
            IF (PurchaseHeader.Invoice) AND (NOT Rec_UserSetup."Allow Purchase Invoice") THEN
                ERROR('You are not authorise to post invoice.');
        END;
        //Iappc - 12 Jan 16 - Honey Price Validation Begin
        IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) THEN BEGIN//AND (PurchHeader."Order Type" = PurchHeader."Order Type"::Honey) THEN BEGIN
            Rec_PurchaseSetup.GET;
            Rec_PurchaseSetup.TESTFIELD("Raw Honey Item");

            Rec_PurchLine.RESET;
            Rec_PurchLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
            Rec_PurchLine.SETRANGE("Document No.", PurchaseHeader."No.");
            Rec_PurchLine.SETRANGE(Type, Rec_PurchLine.Type::Item);
            Rec_PurchLine.SETFILTER("No.", '%1', Rec_PurchaseSetup."Raw Honey Item");
            IF Rec_PurchLine.FINDFIRST THEN
                REPEAT
                    Rec_DealDispatch.RESET;
                    Rec_DealDispatch.SETRANGE("Sauda No.", Rec_PurchLine."Deal No.");
                    Rec_DealDispatch.SETRANGE("Line No.", Rec_PurchLine."Deal Line No.");
                    Rec_DealDispatch.FINDFIRST;

                    Rec_DealCard.GET(Rec_PurchLine."Deal No.");

                    IF Rec_PurchLine.Quantity <= Rec_DealDispatch."Qty. in Kg." THEN BEGIN
                        IF Rec_PurchLine."Line Amount" <> (Rec_PurchLine.Quantity * Rec_DealCard."Unit Rate in Kg.") THEN
                            ERROR('Line amount must be %1 for line no. %2', (Rec_PurchLine.Quantity * Rec_DealCard."Unit Rate in Kg."), Rec_PurchLine."Line No.");
                    END ELSE BEGIN
                        IF Rec_PurchLine."Line Amount" <> (Rec_DealDispatch."Qty. in Kg." * Rec_DealCard."Unit Rate in Kg.") THEN
                            ERROR('Line amount must be %1 for line no. %2', (Rec_DealDispatch."Qty. in Kg." * Rec_DealCard."Unit Rate in Kg."), Rec_PurchLine."Line No.");
                    END;
                UNTIL Rec_PurchLine.NEXT = 0;
        END;
        //Iappc - 12 Jan 16 - Honey Price Validation End
    end;

    [EventSubscriber(ObjectType::Codeunit, 91, 'OnBeforeSelectPostOrderOption', '', false, false)]
    local procedure OnBeforeSelectPostOrderOption(var PurchaseHeader: Record "Purchase Header"; DefaultOption: Integer; var Result: Boolean; var IsHandled: Boolean)
    var
        Selection: Integer;
        ReceiveInvoiceOptionsQst: Label '&Receive';
    begin
        IsHandled := true;
        //Selection := StrMenu(ReceiveInvoiceOptionsQst, DefaultOption);
        Selection := 1;
        if Selection = 0 then
            Result := false;
        PurchaseHeader.Receive := Selection in [1, 3];
        if Selection <> 0 then
            Result := true;

    end;

    // Codeunit91 End

    // Table39 Start
    [EventSubscriber(ObjectType::Table, 39, 'OnValidateNoOnCopyFromTempPurchLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary; xPurchLine: Record "Purchase Line")
    begin
        PurchLine."Honey Item No." := TempPurchaseLine."Honey Item No.";
    end;

    // Table39 End




}