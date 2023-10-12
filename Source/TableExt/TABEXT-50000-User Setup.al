tableextension 50000 UserSetup extends "User Setup"
{
    fields
    {

        field(50002; "Allow Receipt"; Boolean)
        {

            trigger OnValidate()
            begin
                recUser.RESET;
                recUser.SETRANGE("User Name", USERID);
                recUser.FINDFIRST;
                IF (recUser."License Type" = recUser."License Type"::"Limited User") AND ("Allow Receipt") THEN
                    ERROR('Posting rights can not be assigned to a limited user.');
            end;
        }
        field(50003; "Allow Purchase Invoice"; Boolean)
        {

            trigger OnValidate()
            begin
                recUser.RESET;
                recUser.SETRANGE("User Name", USERID);
                recUser.FINDFIRST;
                IF (recUser."License Type" = recUser."License Type"::"Limited User") AND ("Allow Purchase Invoice") THEN
                    ERROR('Posting rights can not be assigned to a limited user.');
            end;
        }
        field(50007; "Purchaser Profile"; Option)
        {
            OptionCaption = ' ,All,Honey,Packing,Other';
            OptionMembers = " ",All,Honey,Packing,Other;
        }
        field(50012; "Allow Customer Approval"; Boolean)
        {

            trigger OnValidate()
            begin
                recUser.RESET;
                recUser.SETRANGE("User Name", USERID);
                recUser.FINDFIRST;
                IF recUser."License Type" = recUser."License Type"::"Limited User" THEN BEGIN
                    IF ("Allow Vendor Approval") OR ("Allow Deal Approval") OR ("Allow Purch. Order Approval") THEN
                        ERROR('Approval rights in multiple modules can not be assigned to a limited user.');
                END;
            end;
        }
        field(50013; "Allow Vendor Approval"; Boolean)
        {

            trigger OnValidate()
            begin
                recUser.RESET;
                recUser.SETRANGE("User Name", USERID);
                recUser.FINDFIRST;
                IF recUser."License Type" = recUser."License Type"::"Limited User" THEN BEGIN
                    IF ("Allow Customer Approval") OR ("Allow Sales Order Approval") THEN
                        ERROR('Approval rights in multiple modules can not be assigned to a limited user.');
                END;
            end;
        }
        field(50015; "Allow Purch. Order Approval"; Boolean)
        {

            trigger OnValidate()
            begin
                recUser.RESET;
                recUser.SETRANGE("User Name", USERID);
                recUser.FINDFIRST;
                IF recUser."License Type" = recUser."License Type"::"Limited User" THEN BEGIN
                    IF ("Allow Customer Approval") OR ("Allow Sales Order Approval") THEN
                        ERROR('Approval rights in multiple modules can not be assigned to a limited user.');
                END;
            end;
        }
        field(50016; "Allow Sales Order Approval"; Boolean)
        {

            trigger OnValidate()
            begin
                recUser.RESET;
                recUser.SETRANGE("User Name", USERID);
                recUser.FINDFIRST;
                IF recUser."License Type" = recUser."License Type"::"Limited User" THEN BEGIN
                    IF ("Allow Vendor Approval") OR ("Allow Purch. Order Approval") THEN
                        ERROR('Approval rights in multiple modules can not be assigned to a limited user.');
                END;
            end;
        }
        field(50017; "Allow Deal Approval"; Boolean)
        {

            trigger OnValidate()
            begin
                recUser.RESET;
                recUser.SETRANGE("User Name", USERID);
                recUser.FINDFIRST;
                IF recUser."License Type" = recUser."License Type"::"Limited User" THEN BEGIN
                    IF ("Allow Customer Approval") OR ("Allow Sales Order Approval") THEN
                        ERROR('Approval rights in multiple modules can not be assigned to a limited user.');
                END;
            end;
        }
    }

    var
        recUser: Record User;
}