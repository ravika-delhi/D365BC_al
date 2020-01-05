table 50012 ManifestsKSA
{
    Permissions = tabledata ManifestsKSA = rimd;

    fields
    {
        field(1; AWBNo; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(2; ManifestDate; Date)
        {
            DataClassification = ToBeClassified;

        }
        field(3; Carrier; code[20])
        {
            DataClassification = ToBeClassified;

        }

        field(4; UploadBy; Text[100])
        {
            DataClassification = ToBeClassified;

        }
        field(5; Upload_at; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(6; LocationCode; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(7; IsCompleteMagento; Boolean)
        {
            DataClassification = ToBeClassified;

        }
        field(8; OrderNo; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(9; IsSalesPosted; code[20])
        {
            DataClassification = ToBeClassified;

        }
        field(10; SalesPosted_at; DateTime)
        {
            DataClassification = ToBeClassified;

        }
        field(11; SalesInvoiced; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = exist ("Sales Invoice Header" WHERE("External Document No." = FIELD(OrderNo)));
        }
        field(12; MagentoCompleteOrder; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("ItemStatus Sync".OrderNo WHERE(AWBNo = field(AWBNo)));
        }

    }

    keys
    {
        key(PK; AWBNo, Carrier)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";

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

    procedure CreateGenJnlLine(SalesHeader: Record "Sales Header";
    ManifestHdr: Record "Manifest HeaderN";
    paidValue: Decimal)
    var
        SalesOrderStatistics: Page "Sales Order Statistics";
        PaymentMethod: Record "Payment Method";
        GenJnlLine: Record "Gen. Journal Line";
        ShippingAgent: Record "Shipping Agent";
        SalesSetup: Record "Sales & Receivables Setup";
        SalesLine: Record "Sales Line";
        Amt: Decimal;
        LineNo: Integer;
    begin
        PaymentMethod.GET(SalesHeader."Payment Method Code");
        // IF PaymentMethod.Prepaid THEN
        //   EXIT;
        ShippingAgent.GET(ManifestHdr."Shipping Agent Code");
        ShippingAgent.TESTFIELD(ShippingAgent."Customer No.");
        SalesSetup.GET;
        SalesSetup.TESTFIELD(SalesSetup.PaymentJrnlTemplate);
        SalesSetup.TESTFIELD(SalesSetup.PaymentJrnlBatch);
        Amt := paidValue;
        IF Amt <> 0 THEN BEGIN
            GenJnlLine.LOCKTABLE;
            LineNo := 0;
            GenJnlLine.RESET;
            GenJnlLine.SETRANGE("Journal Template Name", SalesSetup.PaymentJrnlTemplate);
            GenJnlLine.SETRANGE("Journal Batch Name", SalesSetup.PaymentJrnlBatch);
            IF GenJnlLine.FINDLAST THEN LineNo := GenJnlLine."Line No.";
            LineNo += 10000;
            GenJnlLine.INIT;
            GenJnlLine.VALIDATE("Journal Template Name", SalesSetup.PaymentJrnlTemplate);
            GenJnlLine.VALIDATE("Journal Batch Name", SalesSetup.PaymentJrnlBatch);
            GenJnlLine.VALIDATE("Line No.", LineNo);
            GenJnlLine.VALIDATE("External Document No.", SalesHeader."No.");
            GenJnlLine.VALIDATE("Document No.", ManifestHdr."Manifest No.");
            GenJnlLine.VALIDATE("Posting Date", ManifestHdr."Manifest Date");
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code", SalesHeader."Currency Code");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", SalesHeader."Bill-to Customer No.");
            GenJnlLine.VALIDATE(Amount, -Amt);
            //GenJnlLine.INSERT;
            IF Amt <> 0 THEN GenJnlPostLine.RunWithCheck(GenJnlLine);
            LineNo += 10000;
            GenJnlLine.INIT;
            GenJnlLine.VALIDATE("Journal Template Name", SalesSetup.PaymentJrnlTemplate);
            GenJnlLine.VALIDATE("Journal Batch Name", SalesSetup.PaymentJrnlBatch);
            GenJnlLine.VALIDATE("Line No.", LineNo);
            GenJnlLine.VALIDATE("External Document No.", SalesHeader."No.");
            //GenJnlLine.VALIDATE(GenJnlLine."Currency Code",SalesHeader."Currency Code");
            GenJnlLine.VALIDATE("Document No.", ManifestHdr."Manifest No.");
            GenJnlLine.VALIDATE("Posting Date", ManifestHdr."Manifest Date");
            GenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
            GenJnlLine.VALIDATE("Account No.", ShippingAgent."Customer No.");
            GenJnlLine.VALIDATE(GenJnlLine."Currency Code", SalesHeader."Currency Code");
            GenJnlLine.VALIDATE(Amount, Amt);
            //GenJnlLine.INSERT;
            IF Amt <> 0 THEN GenJnlPostLine.RunWithCheck(GenJnlLine);
        END;
    end;


}