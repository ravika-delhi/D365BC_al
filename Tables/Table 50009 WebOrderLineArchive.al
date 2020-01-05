table 50009 "Web Order Line Archive"
{
    Permissions = tabledata "Web Order Line Archive" = rimd;
    DataPerCompany = false;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(2; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(3; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            Editable = True;
        }
        field(4; Address; Text[150])
        {
            Caption = 'Address';
        }
        field(5; "Address 2"; Text[150])
        {
            Caption = 'Address 2';
        }
        field(6; "Address 3"; Text[100])
        {
            Caption = 'Address 3';
        }
        field(7; "Address 4"; Text[100])
        {
            Caption = 'Address 4';
        }
        field(8; Blank; Text[30])
        {
            Caption = 'Blank';
        }
        field(9; "Address 5"; Text[100])
        {
            Caption = 'Address 5';
        }
        field(10; "Blank 2"; Text[30])
        {
            Caption = 'Blank 2';
        }
        field(11; City; Text[30])
        {
            Caption = 'City';
        }
        field(12; "State Code"; Code[10])
        {
            Caption = 'State Code';
        }
        field(13; "State Name"; Text[30])
        {
            Caption = 'State';
        }
        field(14; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
        }
        field(15; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            Editable = TRUE;
        }
        field(16; "Phone No. 2"; Text[30])
        {
            Caption = 'Phone No. 2';
            Editable = TRUE;
        }
        field(17; "Payment Terms Code"; Code[20])
        {
            Caption = 'Payment Terms Code';
        }
        field(18; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(19; "Order Value"; Decimal)
        {
            Caption = 'Order Value';
        }
        field(20; "Blank 3"; Text[30])
        {
            Caption = 'Blank 3';
        }
        field(21; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
        }
        field(22; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(23; "Item Code"; Code[20])
        {
            Caption = 'Item Code';
        }
        field(24; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(25; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(26; "Extended Price"; Decimal)
        {
            Caption = 'Extended Price';
        }
        field(27; "Shipping Handling Chrg."; Decimal)
        {
            Caption = 'Shipping Handling Chrg.';
        }
        field(28; Tax; Decimal)
        {
            Caption = 'Tax';
        }
        field(29; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(30; Authorized; Text[30])
        {
            Caption = 'Authorized';
        }
        field(31; "Order Type"; Option)
        {
            OptionCaption = 'Full,Partial';
            OptionMembers = Full,Partial;
        }
        field(32; Unknown; Text[30])
        {
            Caption = 'Unknown';
        }
        field(33; "Unknown 2"; Text[30])
        {
            Caption = 'CompName';
        }
        field(34; "Unknown 3"; Text[30])
        {
            Caption = 'Unknown 3';
        }
        field(35; "Unknown 4"; Text[30])
        {
            Caption = 'Unknown 4';
        }
        field(36; "Alternate Instructions"; Text[250])
        {
            Caption = 'Alternate Instructions';
        }
        field(37; "Unknown 5"; Integer)
        {
            Caption = 'Unknown 5';
        }
        field(38; "Offer Code"; Code[20])
        {
            Caption = 'Offer Code';
        }
        field(39; "Unknown 6"; Boolean)
        {
            Caption = 'Unknown 6';
        }
        field(40; "File Name"; Text[50])
        {
            Caption = 'File Name';
        }
        field(41; "Customer Updated"; Boolean)
        {
            Caption = 'Customer Updated';
        }
        field(42; "Order Updated"; Boolean)
        {
            Caption = 'Order Updated';
        }
        field(43; "Address 1 Extn."; Text[50])
        {
        }
        field(44; "Address 2 Extn."; Text[50])
        {
        }
        field(45; "Individual File Name"; Text[50])
        {
        }
        field(46; "Master Order No."; Code[20])
        {
        }
        field(47; "Continuity Sequence No."; Integer)
        {
        }
        field(48; "Ship-to-Customer Name"; Text[30])
        {
        }
        field(49; "Ship to Phone No."; Text[30])
        {
        }
        field(50; "Ship to Address"; Text[150])
        {
        }
        field(51; "Ship to Address 2"; Text[150])
        {
        }
        field(52; "Ship to City"; Text[50])
        {
        }
        field(53; "Ship to Postcode"; Code[20])
        {
        }
        field(54; "Ship To State"; Text[50])
        {
        }
        field(55; "Shipping Amount"; Decimal)
        {
        }
        field(56; "Coupon Code"; Code[50])
        {
        }
        field(57; "Order Status"; Option)
        {
            OptionCaption = 'Under verification,Under Process,Ready to Ship,Shipped,Canceled,Returned,Closed,Exportable';
            OptionMembers = "Under verification","Under Process","Ready to Ship",Shipped,Canceled,Returned,Closed,Exportable;
        }
        field(58; "Order Status Line"; Option)
        {
            Caption = 'Order Status Line';
            Editable = true;
            OptionCaption = ' ,Created,Scheduled,Released,Shipped,Return Created,Canceled,Exportable';
            OptionMembers = " ",Created,Scheduled,Released,Shipped,"Return Created",Canceled,Exportable;
        }
        field(59; "Coupon Money"; Decimal)
        {
        }
        field(60; "Coupon Percentage"; Decimal)
        {
        }
        field(61; "Paid Price"; Decimal)
        {
        }
        field(62; "Shipment Date"; Date)
        {
        }
        field(63; OrderDateTime; DateTime)
        {
        }
        field(64; "Unknown 8"; Time)
        {
        }
        field(65; "Unknown 9"; Text[30])
        {
            /* trigger OnValidate()
                     begin
                         IF ("Unknown 9" <> 'GS-DMM') THEN BEGIN
                             NewLocationCode := 'GS-DXB';
                             "Location Code" := 'GS-DXB';
                         END ELSE BEGIN
                             NewLocationCode := 'GS-DMM';
                             "Location Code" := 'GS-DMM';
                         END;

                     end;*/
        }
        field(66; "Unknown 10"; Text[30])
        {
        }
        field(67; "Unknown 11"; Decimal)
        {
        }
        field(68; "Unknown 12"; Decimal)
        {
        }
        field(69; "Country/Region"; Code[10])
        {
        }
        field(70; "Discount Amount"; Decimal)
        {
        }
        field(71; "Order Time"; Time)
        {
        }
        field(72; "Return Reason"; Text[80])
        {
        }
        field(73; "Item Name"; Text[50])
        {
        }
        field(74; "Unknown 15"; Integer)
        {
        }
        field(75; "Creation Date"; Date)
        {
        }
        field(76; "Payment Gateway"; Code[20])
        {
        }
        field(77; "Special Price"; Decimal)
        {
        }
        field(78; "Ship to Address 3"; Text[171])
        {
        }
        field(79; "Record Printed"; Boolean)
        {
            Editable = false;
        }
        field(80; "Order Credit"; Decimal)
        {
        }
        field(81; "Item Credit Amt"; Decimal)
        {
        }
        field(82; "Shipping Charge"; Decimal)
        {
        }
        field(83; "Shipping Item Charge"; Decimal)
        {
        }
        field(84; Country; Code[20])
        {
        }
        field(85; "Ship to Country"; Code[20])
        {
        }
        field(86; Currrency; Code[10])
        {
        }
        field(87; "Created Date"; DateTime)
        {
        }
        field(88; Allocation; Text[50])
        {
        }
        field(89; "Customer Last Name"; Text[50])
        {
        }
        field(90; ORDER_ITEM_ID; Text[50])
        {
        }
        field(91; PROMO; Code[50])
        {
        }
        field(92; SerialNo; Code[20])
        {
        }
        field(93; "Shipping Agent Code"; Code[20])
        {
        }
        field(94; "Customer Name2"; Text[50])
        {
        }
        field(95; "Location Code"; Code[20])
        {
            TableRelation = Location;
        }
        field(96; "Exportable DateTime"; DateTime)
        {
        }
        field(97; "Sync DateTime"; DateTime)
        {
        }
        field(98; CreatedDateTime; DateTime)
        {
        }
        field(99; NewLocationCode; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(100; VAT_AMT; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(101; Gift_Chrgs; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(102; "Company Name"; Text[50])
        {
            Caption = 'Company Name';
        }
        field(103; CompName; Text[50])
        {
            Caption = 'Company Name';
        }
        field(104; "Item UnitPrice"; Decimal)
        {
            Caption = 'Item UnitPrice';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup (Item."Unit Price" where ("No." = field ("Item Code")));
        }
    }
    keys
    {
        key(Key1; "Order No.", "Line No.")
        {
        }
        key(Key2; ORDER_ITEM_ID)
        {
        }
        key(Key3; "Ship to City", "Location Code")
        {
        }
    }
    fieldgroups
    {
    }
    trigger OnInsert()
    var
        GSDXBItm: Record "GS-DXB Items";
    begin
        IF "Unknown 9" = 'GS-DMM' then
            "Location Code" := 'GS-DMM'
        ELSE BEGIN
            IF "Unknown 9" = 'GS-JDH' THEN
                "Location Code" := 'GS-JDH'
            else
                "Location Code" := 'GS-DXB';
        end;
    end;
}
