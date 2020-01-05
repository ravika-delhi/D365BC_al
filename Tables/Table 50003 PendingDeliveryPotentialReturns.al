table 50003 PendingDeliveryPotReturns

{
    Permissions = tabledata PendingDeliveryPotReturns = rimd;





    fields
    {
        field(1; RAWBNo; code[20])
        {


        }
        field(2; OrderNo; code[20])
        {


        }
        field(3; ItemNo; code[20])
        {


        }
        field(4; Quantity; decimal)
        {


        }
        field(5; AWBNo; code[20])
        {


        }
        field(6; Value; Decimal)
        {


        }
        field(7; ReturnProcessed_at; DateTime)
        {


        }
        field(8; ReturnByUserID; text[50])
        {

        }
        field(9; Returned; Boolean)
        {

        }
        field(10; GSOrderItemID; code[20])
        {

        }
        field(11; PaidPrice; Decimal)
        {

        }
        field(12; "Amount without VAT"; Decimal)
        {

        }
        field(13; "COD Charges"; Decimal)
        {

        }
        field(14; "Shipping Charges"; Decimal)
        {

        }
        field(15; "Gift Charges"; Decimal)
        {

        }
        field(16; LineNo; Integer)
        {

        }
        field(17; shippedFromwhs; code[10])
        {

        }

    }

    keys
    {
        key(PK; RAWBNo, OrderNo, LineNo, AWBNo, ItemNo)
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