pageextension 50034 ExeWhsReceipt extends "Warehouse Receipt"
{
    layout
    {
        addafter("Assignment Time")
        {
            field(scanItem; scanItem)
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    whsRcptLine: Record "Warehouse Receipt Line";
                    recItems: Record Item;
                    Items: Record Item;
                    barcode1: code[20];
                    barcode: code[20];
                    barcode2: code[20];
                    NewItems: Page "Item List";
                    updated: Boolean;
                    canceledItem: Record "Cancelled Items";
                begin
                    updated := false;
                    If not recItems.Get(scanItem) then
                        barcode1 := recItems.scannedItem(scanItem)
                    ELSE
                        barcode1 := scanItem;
                    updated := FALSE;
                    whsRcptLine.RESET;
                    whsRcptLine.SETRANGE(whsRcptLine."No.", "No.");
                    whsRcptLine.SETRANGE(whsRcptLine."Item No.", barcode1);
                    IF whsRcptLine.FINDFIRST THEN BEGIN

                        REPEAT
                            IF whsRcptLine.Quantity <> whsRcptLine."Qty. to Receive" THEN BEGIN // ADDED BEGIN 1st June 14
                                IF ((whsRcptLine.ScannedBy = '') OR (UPPERCASE(whsRcptLine.ScannedBy) = UPPERCASE(USERID))) THEN BEGIN
                                    IF not canceledItem.get(whsRcptLine.GSOrderItemUID) THEN BEGIN
                                        whsRcptLine.VALIDATE("Qty. to Receive", whsRcptLine."Qty. to Receive" + 1);
                                        IF whsRcptLine."Web Order Id" <> '' Then
                                            whsRcptLine.Validate("Qty. to Cross-Dock", whsRcptLine."Qty. to Cross-Dock" + 1);
                                        whsRcptLine.ScannedBy := USERID;
                                        updated := TRUE;
                                        whsRcptLine.MODIFY;
                                        CurrPage.Update();
                                        clear(scanItem);
                                    END;
                                END
                                ELSE
                                    MESSAGE('Item %1 IS ALLOCATED TO %2 ', scanItem, whsRcptLine.ScannedBy);
                            END;
                            IF updated THEN EXIT;
                        UNTIL whsRcptLine.NEXT = 0;
                        IF NOT updated THEN MESSAGE('Item %1 IS already RECIEVED BY %2 ', barcode1, whsRcptLine.ScannedBy);
                    END
                    ELSE
                        MESSAGE('Item %1 NOT AWAILABLE', barcode1);
                    CLEAR(scanItem);
                end;
            }
        }
    }
    actions
    {
        modify("Delete Qty. to Receive")
        {
            ApplicationArea = All;
            Promoted = True;
            PromotedCategory = Process;
        }
        modify("Post Receipt")
        {
            Visible = false;
        }
        addafter("Post Receipt")
        {
            action("Post WhsRcpts")
            {
                Promoted = TRUE;
                PromotedCategory = Process;
                ApplicationArea = ALL;

                trigger OnAction()
                begin
                    WhsePostRcptYesNoNew;
                end;
            }
        }
    }
    var
        scanItem: Code[20];

    local procedure WhsePostRcptYesNoNew()
    begin
        CurrPage.WhseReceiptLines.PAGE.WhsePostRcptYesNo_New;
    end;
}
