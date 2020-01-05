table 50001 GLAccountMapping
{
    DataClassification = ToBeClassified;
    Permissions = tabledata GLAccountMapping = rimd;
    fields
    {
        field(1; oldglAC; code[10])
        {
            DataClassification = ToBeClassified;

        }
        field(2; NewglAC; code[10])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; oldglAC)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

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