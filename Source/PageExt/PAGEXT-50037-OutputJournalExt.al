// pageextension 50037 "Output Journal Ext." extends "Output Journal"
// {
//     layout
//     {
//         modify("Order Line No.")
//         {
//             Editable = false;
//         }
//         modify("Document No.")
//         {
//             Editable = false;
//         }
//         modify("Item No.")
//         {
//             Editable = false;
//         }
//         modify("Operation No.")
//         {
//             Editable = false;
//         }
//         modify(Type)
//         {
//             Editable = false;
//         }
//         modify("No.")
//         {
//             Editable = false;
//         }
//         modify(Description)
//         {
//             Editable = false;
//         }
//         modify("Location Code")
//         {
//             Editable = false;
//         }
//         addafter("Location Code")
//         {
//             field("Starting Date Time"; Rec."Starting Date Time")
//             {
//                 ApplicationArea = all;
//             }
//             field("Ending Date Time"; Rec."Ending Date Time")
//             {
//                 ApplicationArea = all;
//             }
//             field("ByProduct Item Code"; Rec."ByProduct Item Code")
//             {
//                 ApplicationArea = all;
//             }
//             field("ByProduct Qty."; Rec."ByProduct Qty.")
//             {
//                 ApplicationArea = all;
//             }
//             field("Prod. Date for Expiry Calc"; Rec."Prod. Date for Expiry Calc")
//             {
//                 ApplicationArea = all;
//             }
//         }
//     }

//     actions
//     {
//         addafter("Explode &Routing")
//         {
//             action("Quality")
//             {

//                 Promoted = true;
//                 Visible = false;
//                 Image = TestReport;
//                 trigger OnAction()
//                 var
//                 begin
//                     OpenQCInfo(Rec."Document No.", Rec."Line No.");
//                 END;
//             }
//             action("De-Crystlizer Details")
//             {
//                 Caption = 'De-Crystlizer Details';
//                 Promoted = true;
//                 Image = Production;
//                 PromotedCategory = Process;
//                 trigger OnAction()

//                 begin
//                     Rec.TESTFIELD("Order No.");
//                     Rec.TESTFIELD("No.");
//                     ProductionOrder.GET(ProductionOrder.Status::Released, Rec."Order No.");

//                     recBatchProcess.RESET;
//                     recBatchProcess.SETRANGE(Type, recBatchProcess.Type::"De-Crystallizer");
//                     recBatchProcess.SETRANGE("Document No.", ProductionOrder."No.");
//                     IF NOT recBatchProcess.FINDFIRST THEN BEGIN
//                         recBatchProcess.INIT;
//                         recBatchProcess.Type := recBatchProcess.Type::"De-Crystallizer";
//                         recBatchProcess."Document No." := ProductionOrder."No.";
//                         recBatchProcess.Date := TODAY;
//                         recBatchProcess."Customer Code" := ProductionOrder."Customer Code";
//                         recBatchProcess."Customer Batch No." := ProductionOrder."Batch No.";
//                         recBatchProcess.INSERT;
//                     END;

//                     recBatchProcess.RESET;
//                     recBatchProcess.FILTERGROUP(0);
//                     recBatchProcess.SETRANGE(Type, recBatchProcess.Type::"De-Crystallizer");
//                     recBatchProcess.SETRANGE("Document No.", ProductionOrder."No.");
//                     recBatchProcess.FILTERGROUP(2);

//                     CLEAR(pgBatchProcess);
//                     pgBatchProcess.SETTABLEVIEW(recBatchProcess);
//                     pgBatchProcess.RUN;
//                 END;
//             }
//             Action("Vacuum Circulation")
//             {
//                 Caption = 'Vacuum Circulation';
//                 Promoted = true;
//                 Image = Production;
//                 PromotedCategory = Process;
//                 trigger OnAction()
//                 BEGIN
//                     Rec.TESTFIELD("Order No.");
//                     Rec.TESTFIELD("No.");
//                     ProductionOrder.GET(ProductionOrder.Status::Released, Rec."Order No.");

//                     recBatchProcess.RESET;
//                     recBatchProcess.SETRANGE(Type, recBatchProcess.Type::"Vaccum Circulation");
//                     recBatchProcess.SETRANGE("Document No.", ProductionOrder."No.");
//                     IF NOT recBatchProcess.FINDFIRST THEN BEGIN
//                         recBatchProcess.INIT;
//                         recBatchProcess.Type := recBatchProcess.Type::"Vaccum Circulation";
//                         recBatchProcess."Document No." := ProductionOrder."No.";
//                         recBatchProcess.Date := TODAY;
//                         recBatchProcess.INSERT;
//                     END;

//                     recBatchProcess.RESET;
//                     recBatchProcess.FILTERGROUP(0);
//                     recBatchProcess.SETRANGE(Type, recBatchProcess.Type::"Vaccum Circulation");
//                     recBatchProcess.SETRANGE("Document No.", ProductionOrder."No.");
//                     recBatchProcess.FILTERGROUP(2);

//                     CLEAR(pgVacuumCirculation);
//                     pgVacuumCirculation.SETTABLEVIEW(recBatchProcess);
//                     pgVacuumCirculation.RUN;

//                 END;
//             }
//         }

//     procedure OpenQCInfo(DocNo: Code[20]; DocLineNo: Integer)
//     VAR
//         recMachineCenter: Record 99000758;
//         recInventorySetup: Record 313;
//         recQualityCheck: Record 50005;
//         cdDocNo: Code[20];
//         cuNoSeries: Codeunit 396;
//         intLineNo: Integer;
//         recQualityMeasure2 Record 99000784;
//         recQualityLines: Record 50006;
//         pgQuality: Page 50088;
//         recBatchProcess: Record 50007;
//         pgBatchProcess: Page 50065;
//         pgVacuumCirculation: Page 50067;
//         recReservationEntry: Record 337;
//         recBatchProcessLine: Record 50008;
//     BEGIN
//         recMachineCenter.GET(Rec."No.");
//         IF recMachineCenter."QC Mandatory" THEN BEGIN
//             IF recMachineCenter."QC Type" = recMachineCenter."QC Type"::Quality THEN BEGIN

//                 IF recMachineCenter."Quality Process" = '' THEN
//                     ERROR('No quality process defined for the item no. %1', Rec."No.");

//                 recInventorySetup.GET;
//                 recInventorySetup.TESTFIELD("Quality Nos.");

//                 recQualityCheck.RESET;
//                 recQualityCheck.SETRANGE("Document Type", recQualityCheck."Document Type"::Output);
//                 recQualityCheck.SETRANGE("Document No.", Rec."Document No.");
//                 recQualityCheck.SETRANGE("Document Line No.", Rec."Order Line No.");
//                 recQualityCheck.SETRANGE(Posted, FALSE);
//                 IF NOT recQualityCheck.FINDFIRST THEN BEGIN
//                     cdDocNo := cuNoSeries.GetNextNo(recInventorySetup."Quality Nos.", TODAY, TRUE);

//                     recQualityCheck.INIT;
//                     recQualityCheck."No." := cdDocNo;
//                     recQualityCheck.Date := TODAY;
//                     recQualityCheck."Document Type" := recQualityCheck."Document Type"::Output;
//                     recQualityCheck."Document No." := Rec."Document No.";
//                     recQualityCheck."Document Line No." := Rec."Order Line No.";
//                     recQualityCheck."Document Date" := TODAY;
//                     recQualityCheck.Quantity := Rec.Quantity;
//                     recQualityCheck."Item Code" := Rec."Item No.";
//                     recQualityCheck."Item Name" := Rec.Description;
//                     recQualityCheck."Machine No." := recMachineCenter."No.";
//                     recQualityCheck."Machine Name" := recMachineCenter.Name;
//                     recQualityCheck.INSERT;

//                     intLineNo := 0;
//                     recQualityMeasure.RESET;
//                     recQualityMeasure.SETRANGE("Standard Task Code", recMachineCenter."Quality Process");
//                     IF recQualityMeasure.FINDFIRST THEN
//                         REPEAT
//                             recQualityLines.INIT;
//                             recQualityLines."QC No." := cdDocNo;
//                             intLineNo += 10000;
//                             recQualityLines."Line No." := intLineNo;
//                             recQualityLines."Lot No." := '';
//                             recQualityLines."Quality Process" := recQualityMeasure."Standard Task Code";
//                             recQualityLines."Quality Measure" := recQualityMeasure."Qlty Measure Code";
//                             recQualityLines.Parameter := recQualityMeasure.Parameter;
//                             recQualityLines.Specs := recQualityMeasure.Specs;
//                             recQualityLines.Limit := recQualityMeasure.Limit;
//                             recQualityLines.INSERT;
//                         UNTIL recQualityMeasure.NEXT = 0;
//                 END ELSE
//                     cdDocNo := recQualityCheck."No.";

//                 recQualityCheck.RESET;
//                 recQualityCheck.SETRANGE("No.", cdDocNo);

//                 CLEAR(pgQuality);
//                 pgQuality.SETTABLEVIEW(recQualityCheck);
//                 pgQuality.RUN;

//             END ELSE
//                 IF recMachineCenter."QC Type" = recMachineCenter."QC Type"::"De-Crystlizer" THEN BEGIN

//                     recBatchProcess.RESET;
//                     recBatchProcess.SETRANGE(Type, recBatchProcess.Type::"De-Crystalizer");
//                     recBatchProcess.SETRANGE("Document No.", Rec."Order No.");
//                     IF NOT recBatchProcess.FINDFIRST THEN BEGIN
//                         recBatchProcess.INIT;
//                         recBatchProcess.Type := recBatchProcess.Type::"De-Crystalizer";
//                         recBatchProcess."Document No." := Rec."Order No.";
//                         recBatchProcess.Date := TODAY;
//                         recBatchProcess.INSERT;
//                     END;

//                     recBatchProcess.RESET;
//                     recBatchProcess.FILTERGROUP(0);
//                     recBatchProcess.SETRANGE(Type, recBatchProcess.Type::"De-Crystalizer");
//                     recBatchProcess.SETRANGE("Document No.", Rec."Order No.");
//                     recBatchProcess.FILTERGROUP(2);

//                     CLEAR(pgBatchProcess);
//                     pgBatchProcess.SETTABLEVIEW(recBatchProcess);
//                     pgBatchProcess.RUN;
//                 END ELSE
//                     IF recMachineCenter."QC Type" = recMachineCenter."QC Type"::Vacumm THEN BEGIN

//                         recBatchProcess.RESET;
//                         recBatchProcess.SETRANGE(Type, recBatchProcess.Type::"Vaccum Circulation");
//                         recBatchProcess.SETRANGE("Document No.", Rec."Order No.");
//                         IF NOT recBatchProcess.FINDFIRST THEN BEGIN
//                             recBatchProcess.INIT;
//                             recBatchProcess.Type := recBatchProcess.Type::"Vaccum Circulation";
//                             recBatchProcess."Document No." := Rec."Order No.";
//                             recBatchProcess.Date := TODAY;
//                             recBatchProcess.INSERT;
//                         END;

//                         recBatchProcess.RESET;
//                         recBatchProcess.FILTERGROUP(0);
//                         recBatchProcess.SETRANGE(Type, recBatchProcess.Type::"Vaccum Circulation");
//                         recBatchProcess.SETRANGE("Document No.", Rec."Order No.");
//                         recBatchProcess.FILTERGROUP(2);

//                         CLEAR(pgVacuumCirculation);
//                         pgVacuumCirculation.SETTABLEVIEW(recBatchProcess);
//                         pgVacuumCirculation.RUN;
//                     END;
//         end;

//     procedure ValidateOutputLines(Type: Integer)
//     BEGIN
//         //Iappc - Output Approval Process Begin
//         recItemJournalLines.RESET;
//         recItemJournalLines.SETRANGE("Journal Template Name", Rec."Journal Template Name");
//         recItemJournalLines.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
//         recItemJournalLines.SETFILTER("Document No.", '<>%1', Rec."Order No.");
//         IF recItemJournalLines.FINDFIRST THEN
//             ERROR('There are output lines of other production order, post the same first.');

//         IF Type = 0 THEN BEGIN  //Submit for QC
//             recItemJournalLines.RESET;
//             recItemJournalLines.COPYFILTERS(Rec);
//             IF recItemJournalLines.FINDFIRST THEN
//                 REPEAT
//                     recMachineCenter.GET(recItemJournalLines."No.");
//                     IF NOT recMachineCenter."QC Mandatory" THEN
//                         ERROR('Quality is not mandatory for the selected routing, post the same directly.');
//                 UNTIL recItemJournalLines.NEXT = 0;
//         END ELSE BEGIN          //Post Output
//             recItemJournalLines.RESET;
//             recItemJournalLines.SETFILTER("Journal Template Name", '<>%1', Rec."Journal Template Name");
//             recItemJournalLines.SETFILTER("Document No.", '%1', Rec."Document No.");
//             IF recItemJournalLines.FINDFIRST THEN
//                 ERROR('There are output lines already submitted for QC, post the same first.');

//             recItemJournalLines.RESET;
//             recItemJournalLines.COPYFILTERS(Rec);
//             IF recItemJournalLines.FINDFIRST THEN
//                 REPEAT
//                     recMachineCenter.GET(recItemJournalLines."No.");
//                     IF (recMachineCenter."QC Mandatory") AND (recMachineCenter."QC Type" = recMachineCenter."QC Type"::Quality) THEN
//                         ERROR('Quality is mandatory for the selected routing, submit for quality first.');
//                 UNTIL recItemJournalLines.NEXT = 0;
//         END;
//         //Iappc - Output Approval Process End
//     END;

//     var
//         ProductionOrder: Record "Production Order";
//         recItemJournalLines: Record "Item Journal Line";
//         recMachineCenter: Record "Machine Center";
//         recBatchProcess: Record "Batch Process Header";
//         pgBatchProcess: Record "De-Crystallizer Card";
//         pgVacuumCirculation: Record "Vacuum Circulation Card";
// }