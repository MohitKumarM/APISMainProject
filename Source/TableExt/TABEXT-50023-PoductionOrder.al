tableextension 50023 ProductionOrder extends "Production Order"
{
    fields
    {
        field(50006; "Batch No."; Code[20])
        {
        }
        field(50007; "Customer Code"; Code[20])
        {
            TableRelation = Customer;
        }
        field(50009; "Customer Name"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer Code")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        myInt: Integer;
}