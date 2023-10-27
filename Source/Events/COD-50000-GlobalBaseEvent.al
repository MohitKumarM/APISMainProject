codeunit 50000 Tble83
{
    trigger OnRun()
    begin

    end;
    // Table83 Start

    var
        MRPPrice: Decimal;
        ModifyRun: Boolean;
        MFGDate: Date;
        Tin: Decimal;
        Drum: Decimal;
        Bucket: Decimal;


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
        NewItemLedgEntry."MRP Price" := ItemJournalLine."MRP Price"; // 
        NewItemLedgEntry."MFG. Date" := ItemJournalLine."MFG. Date";
        NewItemLedgEntry.Tin := ItemJournalLine.Tin;
        NewItemLedgEntry.Drum := ItemJournalLine.Drum;
        NewItemLedgEntry.Bucket := ItemJournalLine.Bucket;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', false, false)]
    local procedure OnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempItemJournalLine: Record "Item Journal Line" temporary; var PostItemJnlLine: Boolean; var ItemJournalLine2: Record "Item Journal Line"; SignFactor: Integer; FloatingFactor: Decimal)
    begin
        TempItemJournalLine."MRP Price" := TempTrackingSpecification."MRP Price";
        TempItemJournalLine."MFG. Date" := TempTrackingSpecification."MFG. Date";
        TempItemJournalLine.Tin := TempTrackingSpecification.Tin;
        TempItemJournalLine.Drum := TempTrackingSpecification.Drum;
        TempItemJournalLine.Bucket := TempTrackingSpecification.Bucket;
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeSelectPostOrderOption', '', false, false)]
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
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateNoOnCopyFromTempPurchLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary; xPurchLine: Record "Purchase Line")
    begin
        PurchLine."Honey Item No." := TempPurchaseLine."Honey Item No.";
    end;



    /// Quantiy To receive as per the GAN condition


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateQuantityOnBeforeDropShptCheck', '', true, true)]
    local procedure "Purchase Line_OnValidateQuantityOnBeforeDropShptCheck"
    (
        var PurchaseLine: Record "Purchase Line";
        xPurchaseLine: Record "Purchase Line";
        CallingFieldNo: Integer;
        var IsHandled: Boolean
    )
    var
        decTempQty: Decimal;
        Item: Record Item;
        recItemCategory: Record "Item Category";
    begin
        //Uncomment by Shivam 11-07-23
        //Iappc - Gan Tolarance Adjustment
        IF (PurchaseLine.Type = PurchaseLine.Type::Item) AND (PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order) THEN BEGIN
            PurchaseLine."Dispatched Qty. in Kg." := PurchaseLine.Quantity;
            Item.GET(PurchaseLine."No.");
            IF recItemCategory.GET(Item."Item Category Code") THEN
                decTempQty := PurchaseLine.Quantity + (PurchaseLine.Quantity * recItemCategory."GAN Tolerance %" / 100)
            ELSE
                decTempQty := PurchaseLine.Quantity;
        END ELSE BEGIN
            decTempQty := PurchaseLine.Quantity;
            PurchaseLine."Dispatched Qty. in Kg." := PurchaseLine.Quantity;
        END;

        IF (PurchaseLine.Type = PurchaseLine.Type::Item) AND (PurchaseLine."Document Type" <> PurchaseLine."Document Type"::"Credit Memo") THEN
            PurchaseLine.Quantity := ROUND(decTempQty, 1, '<');
        //Iappc - Gan Tolarance Adjustment
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateOverReceiptQuantity', '', true, true)]
    local procedure OnValidateOverReceiptQuantity(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CalledByFieldNo: Integer; var Handled: Boolean)
    begin
        Handled := true;

    end;

    // Table39 End

    // ********** Item Tracking Specification to Item Ledger Entry Field Flow ************** Start

    // Page6510 Start
    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry', '', false, false)]
    local procedure OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry(var TrackingSpecification: Record "Tracking Specification"; var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; FormRunMode: Option)
    begin
        ModifyRun := false;
        MRPPrice := NewTrackingSpecification."MRP Price";
        MFGDate := NewTrackingSpecification."MFG. Date";
        Tin := NewTrackingSpecification.Tin;
        Drum := NewTrackingSpecification.Drum;
        Bucket := NewTrackingSpecification.Bucket;

    end;

    // Page6510 End
    // Codeunit99000830 Start
    [EventSubscriber(ObjectType::Codeunit, 99000830, 'OnAfterSetDates', '', false, false)]
    local procedure OnAfterSetDates(var ReservationEntry: Record "Reservation Entry")
    begin
        ReservationEntry."MRP Price" := MRPPrice;
        ReservationEntry."MFG. Date" := MFGDate;
        ReservationEntry.Tin := Tin;
        ReservationEntry.Drum := Drum;
        ReservationEntry.Bucket := Bucket;

    end;

    [EventSubscriber(ObjectType::Codeunit, 99000830, 'OnCreateReservEntryExtraFields', '', false, false)]
    local procedure OnCreateReservEntryExtraFields(var InsertReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification"; NewTrackingSpecification: Record "Tracking Specification")
    begin
        InsertReservEntry."MRP Price" := NewTrackingSpecification."MRP Price";
        InsertReservEntry."MFG. Date" := NewTrackingSpecification."MFG. Date";
        InsertReservEntry.Tin := NewTrackingSpecification.Tin;
        InsertReservEntry.Drum := NewTrackingSpecification.Drum;
        InsertReservEntry.Bucket := NewTrackingSpecification.Bucket;
    end;

    // Codeunit99000830 End

    // Page6510 Start
    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterEntriesAreIdentical', '', false, false)]
    local procedure OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        IdenticalArray[2] := ((ReservEntry1."MRP Price" = ReservEntry2."MRP Price") and (ReservEntry1."MFG. Date" = ReservEntry2."MFG. Date") and (ReservEntry1.Tin = ReservEntry2.Tin) and (ReservEntry1.Drum = ReservEntry2.Drum) and (ReservEntry1.Bucket = ReservEntry2.Bucket));
    end;

    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterCopyTrackingSpec', '', false, false)]
    local procedure OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        if ModifyRun = false then begin
            SourceTrackingSpec."MRP Price" := DestTrkgSpec."MRP Price";
            SourceTrackingSpec."MFG. Date" := DestTrkgSpec."MFG. Date";
            SourceTrackingSpec.Tin := DestTrkgSpec.Tin;
            SourceTrackingSpec.Drum := DestTrkgSpec.Drum;
            SourceTrackingSpec.Bucket := DestTrkgSpec.Bucket;
        end else begin
            DestTrkgSpec."MRP Price" := SourceTrackingSpec."MRP Price";
            DestTrkgSpec."MFG. Date" := SourceTrackingSpec."MFG. Date";
            DestTrkgSpec.Tin := SourceTrackingSpec.Tin;
            DestTrkgSpec.Drum := SourceTrackingSpec.Drum;
            DestTrkgSpec.Bucket := SourceTrackingSpec.Bucket;
        end;
    end;

    [EventSubscriber(ObjectType::Page, 6510, 'OnAfterMoveFields', '', false, false)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry."MRP Price" := TrkgSpec."MRP Price";
        ReservEntry."MFG. Date" := TrkgSpec."MFG. Date";
        ReservEntry.Tin := TrkgSpec.Tin;
        ReservEntry.Drum := TrkgSpec.Drum;
        ReservEntry.Bucket := TrkgSpec.Bucket;
    end;
    // Page6510 End

    // ********** Item Tracking Specification to Item Ledger Entry Field Flow ************** End





}