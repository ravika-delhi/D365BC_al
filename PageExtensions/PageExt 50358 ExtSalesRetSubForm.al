pageextension 50358 ExtSalesRetSubForm extends "Sales Return Order Subform"
{
    layout
    {
        modify(Description)
        {
            Visible = False;
        }
        addafter("No.")
        {
            Field("Shipment No."; "Shipment No.")
            {
                ApplicationArea = All;
                Editable = True;
            }
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
            }
            /* Field(ProductName; ProductName)
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
                    }*/
        }
    }
    actions
    {
        addafter("Reserve")
        {
            action("Import SalesReturn File")
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
                    purchLine: Record "Sales Line";
                    purchLine2: Record "Sales Line";
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
                    webOrderID: code[20];
                    RAWB: code[20];
                    alternateBarcode: Record "ItemSku Mappings";
                    ItemNo: code[20];
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
                                        IF not recItem.Get(ItemSKU) then
                                            ItemNo := recItem.CheckAlternateBarcode(ItemSKU)
                                        else
                                            ItemNo := ItemSku;

                                        purchLine2.VALIDATE("No.", ItemNo);
                                    END;
                                2: //EVALUATE(qty,currFile.Value); 
                                    BEGIN
                                        EVALUATE(qty, CSVBuffer.Value);
                                        purchLine2.VALIDATE(Quantity, qty);
                                    END;
                                3:
                                    BEGIN
                                        EVALUATE(unitCost, CSVBuffer.Value);
                                        purchLine2.VALIDATE("Unit Price", unitCost);
                                    END;
                                4:
                                    BEGIN
                                        EVALUATE(webOrderID, CSVBuffer.Value);
                                        purchLine2.VALIDATE("Web Order ID", webOrderID);
                                    END;
                                5:
                                    BEGIN
                                        EVALUATE(RAWB, CSVBuffer.Value);
                                        purchLine2.VALIDATE("Docket No.", RAWB);
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
