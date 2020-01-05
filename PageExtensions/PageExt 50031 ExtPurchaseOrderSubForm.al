pageextension 50031 ExtPurchaseOrderSubForm extends "Purchase Order Subform"
{
    layout
    {
        modify(Description)
        {
            Visible = False;
        }
        addafter("No.")
        {
            field(Manufacturer_Brand; Manufacturer_Brand)
            {
                ApplicationArea = All;
            }
            Field(ProductName; ProductName)
            {
                ApplicationArea = All;
            }
            field(Size; Size)
            {
                ApplicationArea = all;
            }
            field(Concentration; Concentration)
            {
                ApplicationArea = all;
            }


            field("Web Order Id"; "Web Order Id")
            {
                ApplicationArea = All;
            }
            field("Order Status"; "Order Status")
            {
                ApplicationArea = All;
            }
            field(GSOrderItemUID; GSOrderItemUID)
            {
                ApplicationArea = All;
            }
            field("Invoice No."; "Invoice No.")
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
        addafter("Insert Ext. Texts")
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
            action("Update Costs")
            {
                ApplicationArea = Planning;
                Caption = 'UpdateC ost';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update Suppliers and Cost';
                Visible = true;

                trigger OnAction()
                var
                    CustXmlFile: File;
                    lineText: Text;
                    OrderTrack: Record "Order Tracking Table";
                    CancelledItems: Record "Cancelled Items";
                    purchLine: Record "Purchase Line";
                    GSItemID: Code[20];
                    vendNo: Integer;
                    unitP: Decimal;
                    CSVBuffer: Record "CSV Buffer";
                    //TempBlob: Codeunit "Temp Blob";
                    UploadResult: Boolean;
                    DialogCaption: Text;
                    CSVFileName: Text;
                    StreamInTest: InStream;
                begin
                    UploadResult := UploadIntoStream(DialogCaption, '', '', CSVFileName, StreamInTest);
                    CSVBuffer.DeleteAll();
                    CSVBuffer.LoadDataFromStream(StreamInTest, ',');
                    IF CSVBuffer.FindSet() then
                        repeat
                            IF CSVBuffer."Field No." = 1 Then
                                purchLine.SETRANGE("Document Type", purchLine."Document Type"::Order);
                            purchLine.setrange("Document No.", GSItemID);
                            Case CSVBuffer."Field No." of
                                1:
                                    GSItemID := CSVBuffer.Value;
                                2:
                                    Evaluate(vendNo, CSVBuffer.VALUE);
                                3:
                                    Evaluate(unitP, CSVBuffer.VALUE);
                            END;
                            purchLine.RESET;
                            purchLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                            purchLine.SETRANGE("Document Type", purchLine."Document Type"::Order);
                            purchLine.setrange("Document No.", GSItemID);
                            purchLine.setrange("Line No.", VendNo);

                            IF purchLine.FINDFIRST THEN BEGIN


                                purchLine.VALIDATE(purchLine."Direct Unit Cost", unitP);
                                purchLine.Modify();
                            END;

                        until CSVBuffer.Next = 0;
                    MESSAGE('DONE');
                END;
            }
            action("Update InvoicesNo &Cost")
            {
                ApplicationArea = Planning;
                Caption = 'Update InvoiceNo & Cost';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update Suppliers and Cost';
                Visible = true;

                trigger OnAction()
                var
                    CustXmlFile: File;
                    lineText: Text;
                    OrderTrack: Record "Order Tracking Table";
                    CancelledItems: Record "Cancelled Items";
                    purchLine: Record "Purchase Line";
                    GSItemID: Code[20];
                    vendNo: Integer;
                    unitP: Decimal;
                    CSVBuffer: Record "CSV Buffer";
                    //TempBlob: Codeunit "Temp Blob";
                    UploadResult: Boolean;
                    DialogCaption: Text;
                    CSVFileName: Text;
                    StreamInTest: InStream;
                    InvoiceNo: Text[50];

                begin
                    UploadResult := UploadIntoStream(DialogCaption, '', '', CSVFileName, StreamInTest);
                    CSVBuffer.DeleteAll();
                    CSVBuffer.LoadDataFromStream(StreamInTest, ',');
                    IF CSVBuffer.FindSet() then
                        repeat
                            IF CSVBuffer."Field No." = 1 Then
                                purchLine.SETRANGE("Document Type", purchLine."Document Type"::Order);
                            purchLine.setrange("Document No.", GSItemID);
                            Case CSVBuffer."Field No." of
                                1:
                                    GSItemID := CSVBuffer.Value;
                                2:
                                    Evaluate(vendNo, CSVBuffer.VALUE);
                                3:
                                    Evaluate(unitP, CSVBuffer.VALUE);
                                4:
                                    Evaluate(InvoiceNo, CSVBuffer.Value);
                            END;
                            purchLine.RESET;
                            purchLine.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                            purchLine.SETRANGE("Document Type", purchLine."Document Type"::Order);
                            purchLine.setrange("Document No.", GSItemID);
                            purchLine.setrange("Line No.", VendNo);

                            IF purchLine.FINDFIRST THEN BEGIN


                                purchLine.VALIDATE(purchLine."Direct Unit Cost", unitP);

                                purchLine."Invoice No." := InvoiceNo;
                                purchLine.Modify();

                            END;

                        until CSVBuffer.Next = 0;
                    MESSAGE('DONE');
                END;
            }

        }
    }
}
