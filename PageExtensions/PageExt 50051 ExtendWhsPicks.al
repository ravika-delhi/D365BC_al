pageextension 50051 ExtendWhsPicks extends "Warehouse Pick"
{
    layout
    {
        modify("Breakbulk Filter")
        {
            visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Assignment Date")
        {
            visible = false;
        }
        modify("Assignment Time")
        {
            Visible = false;
        }
        addafter("Sorting Method")
        {
            field("changeBin"; changeBin)
            {
                Caption = 'Change bin';
                ApplicationArea = ALL;
                TableRelation = Bin.Code WHERE ("Location Code" = FIELD ("Location Code"));
                Visible = false;

                trigger OnValidate()
                var
                    userSetup: Record "User Setup";
                    recWareActLine: Record "Warehouse Activity Line";
                    recWarActLineSys: Record "Warehouse Activity Line";
                begin
                    userSetup.get(UserId);
                    if not userSetup.SuperAdmin then
                        Error('Your are not authorized to change Bin');
                    recWareActLine.Reset;
                    recWareActLine.Setrange("Activity Type", Rec."Type");
                    recWareActLine.SetRange("No.", Rec."No.");
                    recWareActLine.SetRange(OrderStatus, recWareActLine.OrderStatus::Released);
                    recWareActLine.SetFilter("Qty. Outstanding", '>0');
                    IF recWareActLine."Activity Type" = recWareActLine."Activity Type"::"Put-away" then begin
                        recWareActLine.setrange("Action Type", recWareActLine."Action Type"::Place);
                        if recWareActLine.FindSet() then
                            repeat
                                recWareActLine.Validate("Zone Code", '');
                                recWareActLine.Validate("Bin Code", changeBin);
                                recWareActLine.Validate("Qty. to Handle", recWareActLine."Qty. Outstanding");
                                recWareActLine.putawayItemScanned := true;
                                recWareActLine.ScannedbyUser := UserId;
                                recWareActLine.scanned_at := CurrentDateTime;
                                recWareActLine.Modify;
                                recWarActLineSys.Reset;
                                recWarActLineSys.SetRange("Activity Type", recWareActLine."Activity Type");
                                recWarActLineSys.SetRange("Action Type", recWarActLineSys."Action Type"::Take);
                                recWarActLineSys.SetRange("No.", recWareActLine."No.");
                                recWarActLineSys.SetRange("Item No.", recWareActLine."Item No.");
                                recWarActLineSys.setrange(putawayItemScanned, false);
                                IF recWarActLineSys.FindFirst() then
                                    recWarActLineSys.ModifyAll(putawayItemScanned, True);
                            until recWareActLine.Next = 0;
                    end else begin
                        IF recWareActLine."Activity Type" = recWareActLine."Activity Type"::Pick then begin
                            recWareActLine.setrange("Action Type", recWareActLine."Action Type"::Take);
                            if recWareActLine.FindSet() then
                                repeat
                                    recWareActLine.Validate("Zone Code", '');
                                    recWareActLine.Validate("Bin Code", changeBin);
                                    recWareActLine.Validate("Qty. to Handle", recWareActLine."Qty. Outstanding");
                                    recWareActLine.putawayItemScanned := true;
                                    recWareActLine.ScannedbyUser := UserId;
                                    recWareActLine.scanned_at := CurrentDateTime;
                                    recWareActLine.Modify();
                                    Commit;
                                    recWarActLineSys.Reset;
                                    recWarActLineSys.SetRange("Activity Type", recWareActLine."Activity Type");
                                    recWarActLineSys.SetRange("Action Type", recWarActLineSys."Action Type"::Place);
                                    recWarActLineSys.SetRange("No.", recWareActLine."No.");
                                    recWarActLineSys.SetRange("Item No.", recWareActLine."Item No.");
                                    recWarActLineSys.setrange(putawayItemScanned, false);
                                    IF recWarActLineSys.FindFirst() then
                                        recWarActLineSys.ModifyAll(putawayItemScanned, True);
                                until recWareActLine.Next = 0;
                        end;


                    End;
                end;
            }
            field("<scanbin>"; scanBin)
            {
                Caption = 'scan bin';
                ApplicationArea = All;
                TableRelation = Bin.Code WHERE ("Location Code" = FIELD ("Location Code"));

                trigger OnValidate()
                var
                    recWareActLine: Record "Warehouse Activity Line";
                begin
                    CurrPage.Update;
                end;
            }
            field(scanItem; scanItem)
            {
                Caption = 'scanItem';
                ApplicationArea = All;
                Editable = true;
                QuickEntry = true;
                Visible = true;

                trigger OnValidate()
                var
                    serial: Code[10];
                    itemno: Code[20];
                    recWareActLine: Record "Warehouse Activity Line";
                    sourceLineNo: Integer;
                    recWareActLineTake: Record "Warehouse Activity Line";
                    recWareActLinePlace: Record "Warehouse Activity Line";
                    Items: Record Item;
                begin
                    if scanBin = '' then Error('Please scan bin first');
                    scanItems := Items.scannedItem(scanItem);
                    /* if not recItems.Get(scanItems) then begin
                                  Items.Reset;
                                  Items.SetFilter(Items."No.", '%1|%2', '*' + scanItem + '*', CopyStr(scanItems, 2, StrLen(scanItems)));
                                  if Items.FindFirst then
                                      barcode1 := Items."No."
                                  else begin
                                      Evaluate(barcode2, scanItems);

                                      if not Items.Get(barcode2) then
                                          NewItems.Run()

                                      // Error('Item Sku %1 not found', barcode2)
                                      else
                                          Evaluate(barcode1, Items."No.");
                                  end;
                              end else
                                  barcode1 := scanItems;*/
                    recWareActLine.Reset;
                    recWareActLine.SetCurrentKey(recWareActLine."Activity Type", recWareActLine."No.", recWareActLine."Line No.");
                    recWareActLine.SetRange(recWareActLine."Activity Type", Rec.Type);
                    recWareActLine.SetRange(recWareActLine."No.", Rec."No.");
                    recWareActLine.SetFilter(recWareActLine."Qty. Outstanding", '>0');
                    //recWareActLine.SETFILTER(recWareActLine."Qty. to Handle",'<>%1',recWareActLine.Quantity);
                    recWareActLine.SetRange(recWareActLine."Action Type", recWareActLine."Action Type"::Take);
                    recWareActLine.SetRange(recWareActLine."Bin Code", scanBin);
                    recWareActLine.SetRange(recWareActLine."Item No.", scanItem);
                    recWareActLine.SETRANGE(recWareActLine.putawayItemScanned, FALSE);
                    if recWareActLine.FindFirst then begin
                        recWareActLinePlace.Reset;
                        recWareActLinePlace.SetRange("Activity Type", recWareActLine."Activity Type");
                        recWareActLinePlace.SetRange("No.", recWareActLine."No.");
                        recWareActLinePlace.SetRange("Item No.", recWareActLine."Item No.");
                        recWareActLinePlace.SetRange("Whse. Document No.", recWareActLine."Whse. Document No.");
                        recWareActLinePlace.SetRange("Whse. Document Line No.", recWareActLine."Whse. Document Line No.");
                        recWareActLinePlace.SetFilter(recWareActLinePlace."Qty. Outstanding", '>=%1', recWareActLinePlace."Qty. to Handle");
                        if recWareActLinePlace.FindSet then
                            repeat
                                if recWareActLinePlace."Bin Code" <> 'SHIP' then begin
                                    recWareActLinePlace.Validate("Zone Code", '');
                                    recWareActLinePlace.Validate("Bin Code", scanBin);
                                    recWareActLinePlace.Validate("Qty. to Handle", 1);
                                    recWareActLinePlace.putawayItemScanned := true;
                                    recWareActLinePlace.ScannedbyUser := UserId;
                                    recWareActLinePlace.scanned_at := CurrentDateTime;
                                    recWareActLinePlace.putawayItemScanned := True;
                                    recWareActLinePlace.Modify;
                                end
                                else begin
                                    recWareActLinePlace.Validate(recWareActLinePlace."Qty. to Handle", 1);
                                    recWareActLinePlace.ScannedbyUser := UserId;
                                    recWareActLinePlace.putawayItemScanned := true;
                                    recWareActLinePlace.scanned_at := CurrentDateTime;
                                    recWareActLinePlace.Modify;
                                end;
                            until recWareActLinePlace.Next = 0;
                    end
                    else begin
                        Error('No Item Is Pending for item No %1 in Order %2 and Line %3', scanItem, "Source No.", recWareActLine."Line No.");
                    end;
                    Clear(scanItem);
                    Clear(scanBin);
                    CurrPage.Update;
                end;
            }
        }
    }
    actions
    {
        modify("Delete Qty. to Handle")
        {
            Promoted = True;
            PromotedCategory = Process;
            PromotedIsBig = True;
        }
        modify("Autofill Qty. to Handle")
        {
            Promoted = True;
            PromotedCategory = Process;
            PromotedIsBig = True;
        }
        modify(RegisterPick)
        {
            visible = false;
        }
        addbefore("Autofill Qty. to Handle")
        {
            action(RegisterPicks)
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                var
                    whsActLinePicked: Record "Warehouse Activity Line";
                    salesSetup: Record "Sales & Receivables Setup";
                    recLocation: Record Location;
                begin
                    IF recLocation.GET(rec."Location Code") then
                        IF recLocation.PickBinScanMand THEN BEGIN
                            salesSetup.get;
                            whsActLinePicked.Reset;
                            whsActLinePicked.SetRange("Activity Type", rec.Type);
                            whsActLinePicked.SetRange("No.", Rec."No.");
                            whsActLinePicked.SetRange(putawayItemScanned, false);
                            IF whsActLinePicked.FindFirst then
                                Error('Please scanbin for item %1 & %2 bin', whsActLinePicked."Item No.", whsActLinePicked."Bin Code")
                            else
                                RegisterActivityYesNo;
                        END ELSE
                            RegisterActivityYesNo;

                end;

            }
        }


    }
    procedure RegisterActivityYesNo()
    begin
        CurrPage.WhseActivityLines.PAGE.RegisterActivityYesNo;
    end;

    var
        scanBin: Code[20];
        scanItem: Code[20];
        scanItems: code[20];
        Items: record Item;
        barcode1: code[30];
        barcode2: code[30];
        recItems: Record Item;
        NewItems: Page "Item Card";
        changeBin: code[20];
}
