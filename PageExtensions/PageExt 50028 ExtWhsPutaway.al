pageextension 50028 ExtWhsPutaway extends "Warehouse Put-away"
{
    layout
    {
        modify("No.")
        {
            QuickEntry = false;
        }
        modify(CurrentLocationCode)
        {
            QuickEntry = false;
        }
        modify("Breakbulk Filter")
        {
            QuickEntry = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
            QuickEntry = false;
        }
        modify("Assignment Date")
        {
            Visible = false;
            QuickEntry = false;
        }
        modify("Assignment Time")
        {
            Visible = false;
            QuickEntry = false;
        }
        modify("Sorting Method")
        {
            Visible = false;
            QuickEntry = false;
        }
        addafter("Sorting Method")
        {
            field(updateCrossDock; updateCrossDock)
            {
                QuickEntry = false;
                ApplicationArea = All;
                Visible = false;

                trigger OnValidate()
                begin
                    /* if updateCrossDock then
                                   fieldEnabled := true
                               else
                                   fieldEnabled := false;*/
                    updateCrossDock := false;
                end;
            }
            field(scanB2BBin; scanB2BBin)
            {
                Caption = 'scanB2BBin';
                Editable = true;
                Enabled = true;
                ApplicationArea = All;

                trigger OnValidate()
                var
                    recWareActLine2: Record "Warehouse Activity Line";
                begin
                    recWareActLine2.RESET;
                    recWareActLine2.SETRANGE(recWareActLine2."Activity Type", recWareActLine2."Activity Type"::"Put-away");
                    recWareActLine2.SETRANGE(recWareActLine2."No.", "No.");
                    recWareActLine2.SETRANGE(putawayItemScanned, FALSE);
                    IF recWareActLine2.FINDFIRST THEN
                        REPEAT
                            IF recWareActLine2."Qty. Outstanding" > 0 THEN BEGIN
                                IF recWareActLine2."Action Type" = recWareActLine2."Action Type"::Place THEN recWareActLine2.VALIDATE(recWareActLine2."Bin Code", scanB2BBin);
                                recWareActLine2.VALIDATE("Qty. to Handle", recWareActLine2."Qty. Outstanding");
                                recWareActLine2.scanned_at := CURRENTDATETIME;
                                recWareActLine2.ScannedbyUser := USERID;
                                recWareActLine2.putawayItemScanned := TRUE;
                                //recWareActLine.VALIDATE("Qty. to Handle",1);
                                recWareActLine2.MODIFY;
                            END;
                        UNTIL recWareActLine2.NEXT = 0;
                    CLEAR(scanB2BBin);
                    CurrPage.UPDATE;
                end;
            }
            field("<scanbin>"; scanBin)
            {
                Caption = 'scan bin';
                TableRelation = Bin.Code WHERE ("Location Code" = FIELD ("Location Code"));
                ApplicationArea = All;

                trigger OnValidate()
                var
                    recWareActLine: Record "Warehouse Activity Line";
                begin
                    /*recWareActLine.RESET;
                              recWareActLine.SETRANGE(recWareActLine."Activity Type",recWareActLine."Activity Type"::"Invt. Put-away");
                              recWareActLine.SETRANGE(recWareActLine."No.","No.");
                              recWareActLine.SETRANGE(putawayItemScanned,FALSE);
                              IF recWareActLine.FINDFIRST THEN
                                REPEAT
                                 IF recWareActLine."Qty. Outstanding">0 THEN BEGIN
                                      IF recWareActLine."Action Type"=recWareActLine."Action Type"::Place THEN
                                       recWareActLine.VALIDATE(recWareActLine."Bin Code",scanBin);
                                       recWareActLine.VALIDATE("Qty. to Handle",recWareActLine."Qty. Outstanding");
                                       recWareActLine.scanned_at:=CURRENTDATETIME;
                                       recWareActLine.ScannedbyUser:=USERID;
                                       recWareActLine.putawayItemScanned:=TRUE;
                                       //recWareActLine.VALIDATE("Qty. to Handle",1);
                                      recWareActLine.MODIFY;
                                     END;
                                UNTIL recWareActLine.NEXT=0;


                              CLEAR(scanBin);*/
                    CurrPage.Update;
                end;
            }
            field(scanItem; scanItem)
            {
                Caption = 'scanItem';
                Editable = true;
                QuickEntry = true;
                Visible = true;
                ApplicationArea = ALL;

                trigger OnValidate()
                var
                    serial: Code[10];
                    itemno: Code[20];
                    recWareActLine: Record "Warehouse Activity Line";
                    sourceLineNo: Integer;
                    recWareActLineTake: Record "Warehouse Activity Line";
                    recWareActLinePlace: Record "Warehouse Activity Line";
                    Items: Record Item;
                    scanItems: Code[20];
                    checkBin: Record Bin;
                    recItems: record Item;
                    Locationtbl: Record location;
                begin
                    Locationtbl.GET("Location Code");
                    IF updateCrossDock = False THEN BEGIN
                        if scanBin = '' then Error('Please scan bin first');
                        checkBin.Get("Location Code", scanBin);
                        IF not recItems.GET(scanItem) Then
                            scanItems := Items.scannedItem(scanItem)
                        else
                            scanItems := scanItem;
                    end;
                    IF scanBin = '' THEN ERROR('Please scan bin first');
                    recWareActLine.RESET;
                    recWareActLine.SETCURRENTKEY(recWareActLine."Activity Type", recWareActLine."No.", recWareActLine."Line No.");
                    recWareActLine.SETRANGE(recWareActLine."Activity Type", Rec.Type);
                    recWareActLine.SETRANGE(recWareActLine."No.", Rec."No.");
                    //recWareActLine.SETFILTER(recWareActLine."Qty. Outstanding",'>0');
                    //recWareActLine.SETFILTER(recWareActLine."Qty. to Handle",'<>%1',recWareActLine.Quantity);
                    recWareActLine.SETRANGE(recWareActLine."Action Type", recWareActLine."Action Type"::Place);
                    recWareActLine.SETRANGE(recWareActLine."Item No.", scanItems);
                    recWareActLine.SETRANGE(recWareActLine.putawayItemScanned, FALSE);
                    IF recWareActLine.FINDFIRST THEN BEGIN
                        recWareActLinePlace.RESET;
                        recWareActLinePlace.SETRANGE("Activity Type", recWareActLine."Activity Type");
                        recWareActLinePlace.SETRANGE("No.", recWareActLine."No.");
                        recWareActLinePlace.SETRANGE("Item No.", recWareActLine."Item No.");
                        recWareActLinePlace.SETRANGE("Whse. Document No.", recWareActLine."Whse. Document No.");
                        recWareActLinePlace.SETRANGE("Whse. Document Line No.", recWareActLine."Whse. Document Line No.");
                        recWareActLinePlace.SETFILTER(recWareActLinePlace."Qty. Outstanding", '>=%1', recWareActLinePlace."Qty. to Handle" + 1);
                        IF recWareActLinePlace.FINDSET THEN
                            REPEAT
                                IF recWareActLinePlace."Bin Code" <> Locationtbl."Receipt Bin Code" THEN BEGIN
                                    IF (recWareActLinePlace."Bin Code" = '') OR (recWareActLinePlace."Bin Code" <> scanBin) AND (recWareActLinePlace.putawayItemScanned = FALSE) THEN BEGIN
                                        recWareActLinePlace.VALIDATE("Zone Code", '');
                                        recWareActLinePlace.VALIDATE("Bin Code", scanBin);
                                        recWareActLinePlace.VALIDATE("Qty. to Handle", 1);
                                        recWareActLinePlace.putawayItemScanned := TRUE;
                                        recWareActLinePlace.ScannedbyUser := USERID;
                                        recWareActLinePlace.scanned_at := CURRENTDATETIME;
                                        recWareActLinePlace.MODIFY;
                                    END;
                                END
                                ELSE BEGIN
                                    recWareActLinePlace.VALIDATE(recWareActLinePlace."Qty. to Handle", recWareActLinePlace."Qty. to Handle" + 1);
                                    recWareActLinePlace.ScannedbyUser := USERID;
                                    recWareActLinePlace.putawayItemScanned := TRUE;
                                    recWareActLinePlace.scanned_at := CURRENTDATETIME;
                                    recWareActLinePlace.MODIFY;
                                END;
                            UNTIL recWareActLinePlace.NEXT = 0;
                    END
                    ELSE BEGIN
                        ERROR('No Item Is Pending for item No %1 in putaway %2 and Line %3', scanItems, "No.", recWareActLine."Line No.");
                    END;
                    CLEAR(scanItem);
                    CLEAR(scanBin);
                    CurrPage.UPDATE;
                    updateCrossDock := False;
                    CurrPage.Update;
                end;
            }
        }
    }
    actions
    {
        modify("&Register Put-away")
        {
            Visible = False;
        }
        addafter("&Print")
        {

            action("Register PutawayNew")
            {
                Caption = '&Register Put-awayNew';
                Visible = TRUE;
                ApplicationArea = aLL;

                trigger OnAction()
                begin
                    RegisterPutAwayYesNoNew;
                end;
            }
        }
    }
    procedure RegisterPutAwayYesNoNew()
    begin
        CurrPage.WhseActivityLines.PAGE.RegisterPutAwayYesNoNew;
    end;

    var
        scanBin: Code[20];
        scanItem: Code[20];
        updateCrossDock: Boolean;
        scanB2BBin: Code[20];
        fieldEnabled: Boolean;
}
