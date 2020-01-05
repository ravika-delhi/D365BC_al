table 50010 KSASupplierMapping
{
    Permissions = tabledata KSASupplierMapping = rimd;

    fields
    {
        field(1; ItemSku; Code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(2; Suppliers; Code[20])
        {
            trigger OnValidate()
            var
            begin
                If not Vend.Get(Suppliers) then begin
                    Vend.SetRange("Search Name", Suppliers);
                    IF Vend.FINDFIRST then
                        Suppliers := Vend."No."
                    Else
                        Error('Supplier not correct');
                end;
            end;



        }
        field(3; OrderDate; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(4; Quantity; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(5; UnitCost; Decimal)
        {
            DataClassification = ToBeClassified;

        }
        field(6; ShipToWHS; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; InsertDateTime; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(8; CreatedBy; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(9; Used; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(10; Used_at; DateTime)
        {

        }
        field(11; Modified_at; DateTime)
        {

        }
        field(12; Manufacturer_Brand; Text[100])
        {
            //  FieldClass = FlowField;
            // CalcFormula = Lookup (Item.BrandCode WHERE ("No." = FIELD (ItemSku)));
        }
        field(13; ItemDescription; Text[250])
        {
            //FieldClass = FlowField;
            //CalcFormula = Lookup (Item.ProductName WHERE ("No." = FIELD (ItemSku)));
        }
        field(14; Gender; code[20])
        {
            //FieldClass = FlowField;
            //CalcFormula = Lookup (Item.Gender WHERE ("No." = FIELD (ItemSku)));
            //Caption = 'Concentration';
        }


        field(15; Concentration; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Item."Item_type(Conc)" WHERE ("No." = FIELD (ItemSku)));
            Caption = 'Concentration';
        }
        field(16; Size; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Item.Size WHERE ("No." = FIELD (ItemSku)));
        }
        field(17; BrandCode; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Item.BrandCode WHERE ("No." = FIELD (ItemSku)));
        }
        field(18; ProductName; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Item.ProductName WHERE ("No." = FIELD (ItemSku)));
        }







    }

    keys
    {
        key(PK; ItemSku, Suppliers, OrderDate, ShipToWHS, Used)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        Vend: Record Vendor;

    trigger OnInsert()
    begin
        InsertDateTime := CurrentDateTime;
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