pageextension 50037 ExtRequisitionWksh extends "Req. Worksheet"
{
    layout
    {
        addafter("Location Code")
        {
            field(GSOrderItemUID; GSOrderItemUID)
            {
                ApplicationArea = All;
            }
            field(WebOrderNo; WebOrderNo)
            {
                ApplicationArea = All;
            }
            field("Sales Order Date"; "Order Date")
            {
                ApplicationArea = All;
            }
            field("Product Name (Eng)"; "Product Name (Eng)")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify(CarryOutActionMessage)
        {
            Visible = false;
        }
        addafter(CarryOutActionMessage)
        {
            action("Create B2B POs")
            {
                ApplicationArea = Planning;
                Caption = 'Create B2B POs';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Use a batch job to help you create actual supply orders from the order proposals.';
                Visible = true;

                trigger OnAction()
                var
                    PerformAction: Report "Carry Out Action Msg. - Req.N";
                    CurrentJnlBatchName: Code[10];
                begin
                    OrderTracking.get(GSOrderItemUID);
                    IF OrderTracking."Order Item Status" = OrderTracking."Order Item Status"::Released THEN BEGIN
                        PerformAction.SetReqWkshLine(Rec);
                        PerformAction.RUNMODAL;
                        PerformAction.GetReqWkshLine(Rec);
                        CurrentJnlBatchName := GETRANGEMAX("Journal Batch Name");
                        CurrPage.UPDATE(FALSE);
                    END;
                end;
            }
            action(SelectAll)
            {
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update Suppliers and Cost';
                Visible = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                begin
                    ModifyAll("Accept Action Message", TRUE);
                end;
            }
            action("CleaSellection-All")
            {
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update Suppliers and Cost';
                Visible = true;
                ApplicationArea = all;

                trigger OnAction()
                var
                begin
                    ModifyAll("Accept Action Message", false);
                end;
            }
            action("Upload File")
            {
                ApplicationArea = Planning;
                Caption = 'Upload File';
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
                    reqLine: Record "Requisition Line";
                    GSItemID: Code[20];
                    vendNo: code[20];
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
                            IF CSVBuffer."Field No." = 1 Then reqLine.SETRANGE(GSOrderItemUID, GSItemID);
                            Case CSVBuffer."Field No." of
                                1:
                                    GSItemID := CSVBuffer.Value;
                                2:
                                    vendNo := CSVBuffer.VALUE;
                                3:
                                    Evaluate(unitP, CSVBuffer.VALUE);
                            END;
                            reqLine.RESET;
                            reqLine.SETCURRENTKEY(GSOrderItemUID);
                            reqLine.SETRANGE(GSOrderItemUID, GSItemID);
                            IF reqLine.FINDFIRST THEN BEGIN
                                IF OrderTrack.GET(GSItemID) and (OrderTrack."Order Item Status" = OrderTrack."Order Item Status"::Released) THEN BEGIN
                                    reqLine.VALIDATE(reqLine."Vendor No.", vendNo);
                                    reqLine.VALIDATE(reqLine."Direct Unit Cost", unitP);
                                    reqLine.VALIDATE("Action Message", 1);
                                    reqLine.VALIDATE("Accept Action Message", TRUE);
                                    reqLine.MODIFY(TRUE);
                                END;
                            END;
                        until CSVBuffer.Next = 0;
                    MESSAGE('DONE');
                END;
            }
            action("Upload File withDisc%")
            {
                ApplicationArea = Planning;
                Caption = 'Upload File Discount';
                Ellipsis = true;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Update Suppliers and Cost&Dis';
                Visible = true;

                trigger OnAction()
                var
                    CustXmlFile: File;
                    lineText: Text;
                    reqLine: Record "Requisition Line";
                    GSItemID: Code[20];
                    vendNo: code[20];
                    unitP: Decimal;
                    Disc: Decimal;
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
                            IF CSVBuffer."Field No." = 1 Then reqLine.SETRANGE(GSOrderItemUID, GSItemID);
                            Case CSVBuffer."Field No." of
                                1:
                                    GSItemID := CSVBuffer.Value;
                                2:
                                    vendNo := CSVBuffer.VALUE;
                                3:
                                    Evaluate(unitP, CSVBuffer.VALUE);
                                4:
                                    Evaluate(Disc, CSVBuffer.Value);
                            END;
                            reqLine.RESET;
                            reqLine.SETCURRENTKEY(GSOrderItemUID);
                            reqLine.SETRANGE(GSOrderItemUID, GSItemID);
                            IF reqLine.FINDFIRST THEN BEGIN
                                reqLine.VALIDATE(reqLine."Vendor No.", vendNo);
                                reqLine.VALIDATE(reqLine."Direct Unit Cost", unitP);
                                reqLine.Validate(reqLine."Line Discount %", disc);
                                reqLine.VALIDATE("Action Message", 1);
                                reqLine.VALIDATE("Accept Action Message", TRUE);
                                reqLine.MODIFY(TRUE);
                            END;
                        until CSVBuffer.Next = 0;
                    MESSAGE('DONE');
                END;
            }
        }
    }
    var
        OrderTracking: Record "Order Tracking Table";
}
