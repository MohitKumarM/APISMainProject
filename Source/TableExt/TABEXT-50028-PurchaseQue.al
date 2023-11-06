tableextension 50028 PurhaseQue extends "Purchase Cue"
{
    fields
    {
        field(50024; "Pending Inward Quality"; Integer)
        {
            CalcFormula = Count("Item Ledger Entry" WHERE("Entry Type" = FILTER('Purchase'),
                                                           "Document Type" = FILTER('Purchase Receipt'),
                                                           "Quality Checked" = const(false),
                                                           "QC To Approve" = const(false)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50025; "Quality to Approve"; Integer)
        {
            CalcFormula = Count("Item Ledger Entry" WHERE("Entry Type" = FILTER('Purchase'),
                                                           "Document Type" = FILTER('Purchase Receipt'),
                                                           "Quality Checked" = const(false),
                                                           "QC To Approve" = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50026; "Pending Output QC"; Integer)
        {
            CalcFormula = Count("Item Journal Line" WHERE("Journal Template Name" = FILTER('OUTPUTAPP'),
                                                           "Journal Batch Name" = FILTER('DEFAULT')));
            Editable = false;
            FieldClass = FlowField;
        }
        field(50027; "Posted QC"; Integer)
        {
            CalcFormula = Count("Quality Header" WHERE(Posted = const(true)));
            Editable = false;
            FieldClass = FlowField;
        }
    }
}