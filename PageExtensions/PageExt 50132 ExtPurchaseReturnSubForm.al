pageextension 50132 ExtPurchaseReturnSubForm extends "Purchase Return Order Subform"
{
    layout
    {
        modify(Description)
        {
            Visible = False;
        }
        addafter("No.")
        {
            Field(ProductName; ProductName)
            {
                ApplicationArea = All;
            }
            field("Web Order Id"; "Web Order Id")
            {
                ApplicationArea = All;
            }
            field(GSOrderItemUID; GSOrderItemUID)
            {
                ApplicationArea = All;
            }
            field(WebOrderLineNo; WebOrderLineNo)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("E&xplode BOM")
        {
            action("Import Purchase FileNew")
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
                    purchLine: Record "Purchase Line";
                    purchLine2: Record "Purchase Line";
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
                            IF CSVBuffer."Field No." = 1 then purchLine2.Init;
                            CASE CSVBuffer."Field No." OF
                                1:
                                    BEGIN
                                        purchLine2.VALIDATE(purchLine2."Document Type", "Document Type");
                                        purchLine2.VALIDATE(purchLine2."Document No.", "Document No.");
                                        purchLine2."Line No." := purchLine2."Line No." + 10000;
                                        purchLine2.VALIDATE(Type, Type::Item);
                                        EVALUATE(ItemSku, CSVBuffer.Value);
                                        purchLine2.VALIDATE("No.", ItemSku);
                                    END;
                                2: //EVALUATE(qty,currFile.Value); 
                                    BEGIN
                                        EVALUATE(qty, CSVBuffer.Value);
                                        purchLine2.VALIDATE(Quantity, qty);
                                    END;
                                3:
                                    BEGIN
                                        EVALUATE(unitCost, CSVBuffer.Value);
                                        purchLine2.VALIDATE("Direct Unit Cost", unitCost);
                                    END;
                                4:
                                    begin
                                        Evaluate(orderNo, CSVBuffer.Value);
                                        purchLine2.Validate("Web Order Id", orderNo);
                                    END;
                                5:
                                    begin
                                        Evaluate(OrderID, CSVBuffer.Value);
                                        purchLine2.Validate(GSOrderItemUID, OrderID);
                                    END;
                            END;
                            IF NOT purchLine2.INSERT THEN purchLine2.MODIFY;
                        until CSVBuffer.Next() = 0;
                    //end;
                    //currFile.Close;
                end;
            }
            action("Import Purchase File")
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
                    purchLine: Record "Purchase Line";
                    purchLine2: Record "Purchase Line";
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
                            IF CSVBuffer."Field No." = 1 then purchLine2.Init;
                            CASE CSVBuffer."Field No." OF
                                1:
                                    BEGIN
                                        purchLine2.VALIDATE(purchLine2."Document Type", "Document Type");
                                        purchLine2.VALIDATE(purchLine2."Document No.", "Document No.");
                                        purchLine2."Line No." := purchLine2."Line No." + 10000;
                                        purchLine2.VALIDATE(Type, Type::Item);
                                        EVALUATE(ItemSku, CSVBuffer.Value);
                                        purchLine2.VALIDATE("No.", ItemSku);
                                    END;
                                2: //EVALUATE(qty,currFile.Value); 
                                    BEGIN
                                        EVALUATE(qty, CSVBuffer.Value);
                                        purchLine2.VALIDATE(Quantity, qty);
                                    END;
                                3:
                                    BEGIN
                                        EVALUATE(unitCost, CSVBuffer.Value);
                                        purchLine2.VALIDATE("Direct Unit Cost", unitCost);
                                    END;
                            END;
                            IF NOT purchLine2.INSERT THEN purchLine2.MODIFY;
                        until CSVBuffer.Next() = 0;
                    //end;
                    //currFile.Close;
                end;
            }
        }
    }
}
