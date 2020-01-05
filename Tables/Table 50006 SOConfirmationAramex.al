table 50006 SOConfirmationAramex
{
    Permissions = tabledata "SOConfirmationAramex" = rimd;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; OrderKey; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; ClinetSystemRef; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; ExternalOrderKey; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(4; ExternLineNo; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(5; SKU; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; QtyOrdered; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(7; QtyShipped; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(8; GSOrderID; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(9; InsertedDatetime; DateTime)
        {

        }




    }

    keys
    {
        key(PK; OrderKey, ExternLineNo, ClinetSystemRef)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        InsertedDatetime := CurrentDateTime;
    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}