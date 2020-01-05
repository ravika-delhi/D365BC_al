pageextension 50002 ExtSalesLineSubForm extends "Sales Order Subform"
{
    layout
    {
        modify("ATO Whse. Outstanding Qty.")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("ATO Whse. Outstd. Qty. (Base)")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Qty. to Assemble to Order")
        {
            ApplicationArea = all;
            Visible = true;
        }
        modify("Qty. to Assign")
        {
            ApplicationArea = all;
            Visible = true;
        }
        addafter("No.")
        {
            field(ProductName; ProductName)
            {
                ApplicationArea = All;
            }
            field("Order Status"; "Order Status")
            {
                ApplicationArea = All;
            }
            field(AssemblyQty; AssemblyQty)
            {
                ApplicationArea = all;
            }

        }

    }
    actions
    {
        addafter(GetPrice)
        {
            action("Import Sales File")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    fileMngmt: Codeunit "File Management";
                    CSVInStream: InStream;
                    UploadResult: Boolean;
                    //TempBlob: Codeunit "Temp Blob";
                    DialogCaption: Text;
                    CurrFile: File;
                    CSVBuffer: Record "CSV Buffer";
                    CSVFileName: Text;
                    readTExt: Text[1024];
                    salesLine: Record "Sales Line";
                    salesLine2: Record "Sales Line";
                    filePath: Text[1024];
                    StreamInTest: InStream;
                    lineNo: Integer;
                    unitCost: Decimal;
                    inStock: Boolean;
                    qty: Decimal;
                    recItem: Record Item;
                    frght: Decimal;
                    vatAmt: Decimal;
                    vatDif: Decimal;
                    ItemSKU: code[20];
                    orderNo: code[20];
                    OrderID: code[20];
                begin
                    // currFile.Open(fileMngmt.UploadFile('Select a file', ''));
                    //currFile.TextMode(true);
                    UploadResult := UploadIntoStream(DialogCaption, '', '', CSVFileName, StreamInTest);
                    CSVBuffer.DeleteAll();
                    CSVBuffer.LoadDataFromStream(StreamInTest, ',');
                    // if FindLast then;
                    IF CSVBuffer.findset Then
                        repeat
                            IF CSVBuffer."Field No." = 1 then salesLine2.Init;
                            CASE CSVBuffer."Field No." OF
                                1:
                                    BEGIN
                                        salesLine2.VALIDATE(salesLine2."Document Type", "Document Type");
                                        salesLine2.VALIDATE(salesLine2."Document No.", "Document No.");
                                        salesLine2."Line No." := salesLine2."Line No." + 10000;
                                        salesLine2.VALIDATE(Type, Type::Item);
                                        EVALUATE(ItemSku, CSVBuffer.Value);
                                        salesLine2.VALIDATE("No.", ItemSku);
                                    END;
                                2: //EVALUATE(qty,currFile.Value); 
                                    BEGIN
                                        EVALUATE(qty, CSVBuffer.Value);
                                        salesLine2.VALIDATE(Quantity, qty);
                                    END;
                                3:
                                    BEGIN
                                        EVALUATE(unitCost, CSVBuffer.Value);
                                        salesLine2.VALIDATE("Unit Price", unitCost);
                                    END;
                            END;
                            IF NOT salesLine2.INSERT THEN salesLine2.MODIFY;
                        until CSVBuffer.Next() = 0;
                    //end;
                    //currFile.Close;
                end;
            }
            action("Import Sales with Bins")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    fileMngmt: Codeunit "File Management";
                    CSVInStream: InStream;
                    UploadResult: Boolean;
                    //TempBlob: Codeunit "Temp Blob";
                    DialogCaption: Text;
                    CurrFile: File;
                    CSVBuffer: Record "CSV Buffer";
                    CSVFileName: Text;
                    readTExt: Text[1024];
                    salesLine: Record "Sales Line";
                    salesLine2: Record "Sales Line";
                    filePath: Text[1024];
                    StreamInTest: InStream;
                    lineNo: Integer;
                    unitCost: Decimal;
                    inStock: Boolean;
                    qty: Decimal;
                    recItem: Record Item;
                    frght: Decimal;
                    vatAmt: Decimal;
                    vatDif: Decimal;
                    ItemSKU: code[20];
                    orderNo: code[20];
                    OrderID: code[20];
                    binC: code[20];
                begin
                    // currFile.Open(fileMngmt.UploadFile('Select a file', ''));
                    //currFile.TextMode(true);
                    UploadResult := UploadIntoStream(DialogCaption, '', '', CSVFileName, StreamInTest);
                    CSVBuffer.DeleteAll();
                    CSVBuffer.LoadDataFromStream(StreamInTest, ',');
                    // if FindLast then;
                    IF CSVBuffer.findset Then
                        repeat
                            IF CSVBuffer."Field No." = 1 then salesLine2.Init;
                            CASE CSVBuffer."Field No." OF
                                1:
                                    BEGIN
                                        salesLine2.VALIDATE(salesLine2."Document Type", "Document Type");
                                        salesLine2.VALIDATE(salesLine2."Document No.", "Document No.");
                                        salesLine2."Line No." := salesLine2."Line No." + 10000;
                                        salesLine2.VALIDATE(Type, Type::Item);
                                        EVALUATE(ItemSku, CSVBuffer.Value);
                                        salesLine2.VALIDATE("No.", ItemSku);
                                    END;
                                2: //EVALUATE(qty,currFile.Value); 
                                    BEGIN
                                        EVALUATE(qty, CSVBuffer.Value);
                                        salesLine2.VALIDATE(Quantity, qty);
                                    END;
                                3:
                                    BEGIN
                                        EVALUATE(unitCost, CSVBuffer.Value);
                                        salesLine2.VALIDATE("Unit Price", unitCost);
                                    END;
                                4:
                                    begin
                                        Evaluate(binC, CSVBuffer.Value);
                                        salesLine2.Validate("Bin Code", binC);
                                    End;
                            END;
                            IF NOT salesLine2.INSERT THEN salesLine2.MODIFY;
                        until CSVBuffer.Next() = 0;
                    //end;
                    //currFile.Close;
                end;
            }
        }
    }
    var
        myInt: Integer;
}
