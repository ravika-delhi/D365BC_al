pageextension 50003 ExtTransOrderSubDorm extends "Transfer Order Subform"
{
    layout

    {
        modify("Transfer-from Bin Code")
        {
            Visible = false;

        }
        modify("Transfer-To Bin Code")
        {
            Visible = false;
        }
        modify(Description)
        {
            Visible = false;
        }
        addafter("Qty. to Ship")
        {
            field(PickFromBin; PickFromBin)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(Reserve)
        {
            action(ImportFile)
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
                    transLine: Record "Transfer Line";
                    transLine2: Record "Transfer Line";
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
                    binCode: code[20];
                begin
                    // currFile.Open(fileMngmt.UploadFile('Select a file', ''));
                    //currFile.TextMode(true);
                    UploadResult := UploadIntoStream(DialogCaption, '', '', CSVFileName, StreamInTest);
                    CSVBuffer.DeleteAll();
                    CSVBuffer.LoadDataFromStream(StreamInTest, ',');
                    // if FindLast then;
                    IF CSVBuffer.findset Then
                        repeat
                            IF CSVBuffer."Field No." = 1 then transLine2.Init;
                            CASE CSVBuffer."Field No." OF
                                1:
                                    BEGIN

                                        transLine2.VALIDATE(transLine2."Document No.", "Document No.");
                                        transLine2."Line No." := transLine2."Line No." + 10000;

                                        EVALUATE(ItemSku, CSVBuffer.Value);
                                        transLine2.VALIDATE("Item No.", ItemSku);
                                    END;
                                2: //EVALUATE(qty,currFile.Value); 
                                    BEGIN
                                        EVALUATE(qty, CSVBuffer.Value);
                                        transLine2.VALIDATE(Quantity, qty);
                                    END;
                                3:

                                    BEGIN
                                        EVALUATE(binCode, CSVBuffer.Value);
                                        transLine2.VALIDATE(PickFromBin, binCode);
                                    END;
                            END;
                            IF NOT transLine2.INSERT THEN transLine2.MODIFY;
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