pageextension 50001 ExtWhsReclassJournals extends "Whse. Reclassification Journal"
{
    layout
    {
    }
    actions
    {
        addbefore(Register)
        {
            action("Import  File")
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
                    WhsJrnLine: Record "Warehouse Journal Line";
                    WhsJrnLine2: Record "Warehouse Journal Line";
                    filePath: Text[1024];
                    StreamInTest: InStream;
                    lineNo: Integer;
                    ItemSKU: code[20];
                    FromBin: code[20];
                    ToBin: code[20];
                    Qty: Decimal;
                    SalesSetup: Record "Sales & Receivables Setup";
                begin
                    SalesSetup.get;
                    // currFile.Open(fileMngmt.UploadFile('Select a file', ''));
                    //currFile.TextMode(true);
                    UploadResult := UploadIntoStream(DialogCaption, '', '', CSVFileName, StreamInTest);
                    CSVBuffer.DeleteAll();
                    CSVBuffer.LoadDataFromStream(StreamInTest, ',');
                    // if FindLast then;
                    IF CSVBuffer.findset Then
                        repeat
                            IF CSVBuffer."Field No." = 1 then WhsJrnLine2.Init;
                            CASE CSVBuffer."Field No." OF
                                1:
                                    BEGIN
                                        WhsJrnLine2.VALIDATE("Journal Template Name", 'RECLASSIFI');
                                        WhsJrnLine2.VALIDATE("Journal Batch Name", 'DEFAULT');
                                        WhsJrnLine2."Line No." := WhsJrnLine2."Line No." + 10000;
                                        whsJrnLine2.Validate("Location Code", SalesSetup."Default Location Code");
                                        EVALUATE(ItemSku, CSVBuffer.Value);
                                        WhsJrnLine2.VALIDATE("Item No.", ItemSku);
                                    END;
                                2:
                                    begin
                                        Evaluate(FromBin, CSVBuffer.Value);
                                        WhsJrnLine2.Validate("From Bin Code", FromBin);
                                    End;
                                3:
                                    BEGIN
                                        EVALUATE(ToBin, CSVBuffer.Value);
                                        WhsJrnLine2.VALIDATE("To Bin Code", ToBin);
                                    END;
                                4:
                                    begin
                                        BEGIN
                                            EVALUATE(Qty, CSVBuffer.Value);
                                            WhsJrnLine2.VALIDATE(Quantity, Qty);
                                        END;
                                    END;
                            END;
                            IF NOT WhsJrnLine2.INSERT THEN WhsJrnLine2.MODIFY;
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
