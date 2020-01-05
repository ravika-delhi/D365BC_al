table 50005 CityMappingsKSANew
{
    Permissions = tabledata "CityMappingsKSANew" = rimd;
    DataPerCompany = false;

    fields
    {
        field(1; DeliveryCity; Text[80])
        {


        }
        field(2; CityCode; Text[80])
        {

        }
        field(3; WhsLocation; code[10])
        {

        }
        field(4; Carrier; code[20])
        {

        }
        field(5; PickupTime; Time)
        {

        }

    }

    keys
    {
        key(PK; DeliveryCity, CityCode, WhsLocation)
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