pageextension 50032 "RequestToApprove" extends "Requests to Approve"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify(Approve)
        {
            trigger OnBeforeAction()
            var
                myInt: Integer;
            begin
                //  Message('Test');
            end;
        }
    }

    var
        myInt: Integer;
}