codeunit 50025 "CreatePicks"
{
    trigger OnRun()
    var
        cntBatchs: Integer;
    begin
        OrderBatch.RESET;
        OrderBatch.SETCURRENTKEY(OrderBatch.Created_at, OrderBatch.PickCreated);
        OrderBatch.SETRANGE(OrderBatch.PickCreated, FALSE);
        IF OrderBatch.FINDFIRST THEN
            REPEAT
                cntBatchs += 1;
                OrderTrack.RESET;
                OrderTrack.SETCURRENTKEY("Batch No.", "Pick No.");
                OrderTrack.SETRANGE("Batch No.", OrderBatch.Code);
                OrderTrack.SETRANGE("Pick No.", '');
                OrderTrack.SETRANGE("Order Item Status", OrderTrack."Order Item Status"::Released);
                OrderTrack.SETFILTER("Location Code", '%1|%2', 'GS-DMM', 'GS-DXB');
                IF OrderTrack.FINDSET THEN
                    REPEAT
                        WhseShptHeader.RESET;
                        WhseShptHeader.SETRANGE("No.", OrderTrack."Wh Shipment No.");
                        IF WhseShptHeader.FINDFIRST THEN BEGIN
                            WhseShptHeader.TESTFIELD(Status, WhseShptHeader.Status::Released);
                            /*  IF WhseShptHeader.Status=WhseShptHeader.Status::Open then
                                             WhseShpmtReleaseNew.Release(WhseShptHeader);*/
                            WhseShptLine.RESET;
                            //WhseShptLine.SETFILTER(Quantity, '>0');
                            //WhseShptLine.SETRANGE("Completely Picked", FALSE);
                            WhseShptLine.SETRANGE(WhseShptLine."No.", WhseShptHeader."No.");
                            WhseShptLine.CALCFIELDS("Pick Qty.");
                            WhseShptLine.SETFILTER(WhseShptLine."Pick Qty.", '0');
                            IF WhseShptLine.FIND('-') THEN BEGIN
                                CreatePickFromWhseShpt.SetWhseShipmentLine(WhseShptLine, WhseShptHeader);
                                CreatePickFromWhseShpt.SetHideValidationDialog(TRUE);
                                CreatePickFromWhseShpt.USEREQUESTPAGE(FALSE);
                                CreatePickFromWhseShpt.RUNMODAL;
                                //CreatePickFromWhseShpt.GetResultMessage;
                                CLEAR(CreatePickFromWhseShpt);
                            END;
                        END;
                        UpdateStockStatus(OrderTrack."Order Item ID");
                    UNTIL OrderTrack.NEXT = 0;
                OrderBatch.PickCreated := TRUE;
                OrderBatch.PickCreatedDateTime := CURRENTDATETIME;
                OrderBatch.MODIFY;
            UNTIL (OrderBatch.NEXT = 0) OR (cntBatchs > 5);
        MESSAGE('Picks Created');
    end;

    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        CreatePickFromWhseShpt: Report "Whse.-Shipment - Create PickN";
        OrderBatch: Record "Order Batch";
        OrderTrack: Record "Order Tracking Table";
        WhseShpmtReleaseNew: Codeunit "Whse.-Shipment ReleaseNew";

    local procedure UpdateStockStatus(ItemUID: Code[20])
    var
        salesLines: Record "Sales Line";
        serviceOrder: Record "Order Batch";
        WALines: Record "Warehouse Activity Line";
    begin
        WALines.RESET;
        WALines.SETRANGE("Activity Type", WALines."Activity Type"::Pick);
        WALines.SETRANGE("Action Type", WALines."Action Type"::Take);
        WALines.SETRANGE(GSOrderItemUID, ItemUID);
        IF WALines.FINDFIRST THEN BEGIN
            IF (WALines."Action Type" = WALines."Action Type"::Take) AND (WALines."Bin Code" <> '') THEN BEGIN
                /* IF serviceOrder.GET(WALines."Batch No.") THEN BEGIN
                           serviceOrder."Bin Found":=TRUE;
                           serviceOrder.MODIFY;
                           END;*/
                salesLines.RESET;
                salesLines.SETRANGE("Document Type", salesLines."Document Type"::Order);
                salesLines.SETRANGE(GSOrderItemID, WALines.GSOrderItemUID);
                salesLines.SETRANGE("Order Status", salesLines."Order Status"::Released);
                IF salesLines.FINDFIRST THEN BEGIN
                    salesLines."Converted to PO" := TRUE;
                    salesLines."PO Created" := TRUE;
                    salesLines.MODIFY;
                END;
            END;
        END;
    end;
}
