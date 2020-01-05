table 50011 PurchaseReceivedKSA
{
    Permissions = tabledata PurchaseReceivedKSA = rimd;

    fields
    {
        field(1; PONum; Code[20])
        {


        }
        field(2; SupplierName; Code[20])
        {


        }
        field(3; SupplierCode; Code[20])
        {


        }
        field(4; LineNo; Integer)
        {
            AutoIncrement = True;

        }
        field(5; ItemSku; Code[20])
        {


        }
        field(6; ProductName; Code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Item.ProductName WHERE ("No." = FIELD (ItemSku)));

        }
        field(7; Quantity; Decimal)
        {


        }
        field(8; ScannedBy; text[100])
        {


        }
        field(9; scanned_at; DateTime)
        {


        }
        field(10; IsPosted; Boolean)
        {


        }
        field(11; LocationCode; code[10])
        {


        }
    }

    keys
    {
        key(PK; PONum, LineNo)
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