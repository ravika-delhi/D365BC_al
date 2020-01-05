table 50002 ItemsPickedSuppliers
{
    Permissions = tabledata ItemsPickedSuppliers = rimd;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; PONum; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; VendorName; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(3; WebOrderNo; code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(4; OrderStatus; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Created,Scheduled,Released,Shipped,Return Created,Canceled,Exportable,Short Closed';
            OptionMembers = " ",Created,Scheduled,Released,Shipped,"Return Created",Canceled,Exportable,"Short Closed";

        }
        field(5; ItemSku; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(6; scannedQty; decimal)
        {
            DataClassification = ToBeClassified;


        }
        field(7; ProductName; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(8; OutStandingQty; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';

        }
        field(9; scannedAt; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';

        }
        field(10; scannedBy; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';

        }
        field(11; GSOrderItemID; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Quantity';

        }
        field(12; VendorCode; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(13; Open; Boolean)
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; GSOrderItemID)
        {
            Clustered = true;
        }
        key(key1; PONum, ItemSku, OrderStatus)
        {

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