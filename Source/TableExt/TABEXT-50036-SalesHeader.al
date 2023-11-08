tableextension 50036 SalesHeader extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
    procedure PerformManualRelease()
    var
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        if Rec.Status <> Rec.Status::Released then begin
            ReleaseSalesDoc.PerformManualRelease(Rec);
            Commit();
        end;
    end;

    procedure PerformManualRelease(var SalesHeader: Record "Sales Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := SalesHeader.Count;
        SalesHeader.SetFilter(Status, '<>%1', SalesHeader.Status::Released);
        NoOfSkipped := NoOfSelected - SalesHeader.Count;
        BatchProcessingMgt.BatchProcess(SalesHeader, Codeunit::"Sales Manual Release", "Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
    end;

    procedure PerformManualReopen(var SalesHeader: Record "Sales Header")
    var
        BatchProcessingMgt: Codeunit "Batch Processing Mgt.";
        NoOfSelected: Integer;
        NoOfSkipped: Integer;
    begin
        NoOfSelected := SalesHeader.Count;
        SalesHeader.SetFilter(Status, '<>%1', SalesHeader.Status::Open);
        NoOfSkipped := NoOfSelected - SalesHeader.Count;
        BatchProcessingMgt.BatchProcess(SalesHeader, Codeunit::"Sales Manual Reopen", "Error Handling Options"::"Show Error", NoOfSelected, NoOfSkipped);
    end;

    var
        myInt: Integer;
}