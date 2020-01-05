pageextension 50052 ExtendPickSubForm extends "Whse. Pick Subform"
{
    layout
    {
        modify("Zone Code")
        {
            Visible = false;
            Editable = true;
        }
        modify("Bin Code")
        {
            Visible = TRUE;
            Editable = true;
        }
        modify(Description)
        {
            Visible = False;
        }
        addafter("Item No.")
        {
            field(ProductName; ProductName)
            {
                ApplicationArea = All;
            }
            field(putawayItemScanned; putawayItemScanned)
            {
                ApplicationArea = All;
                Caption = 'IsScanned';
            }
        }
    }
    actions
    {
        addafter(SplitWhseActivityLine)
        {
            action("Reset/Update Bins")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    WarehouseActivityLine: Record "Warehouse Activity Line";
                    FindBin: Boolean;
                    binContent: Record "Bin Content";
                    Qty: Decimal;
                    WarehouseActivityLine2: Record "Warehouse Activity Line";
                    Loc: Record Location;
                    binCode: code[20];
                    bincontent1: Record "Bin Content";
                begin
                    Loc.get("Location Code");
                    ClearTakeBins("No.");
                    WarehouseActivityLine.RESET;
                    WarehouseActivityLine.SETRANGE("Activity Type", "Activity Type"::Pick);
                    WarehouseActivityLine.SETRANGE("No.", "No.");
                    WarehouseActivityLine.SETRANGE("Action Type", WarehouseActivityLine."Action Type"::Take);
                    WarehouseActivityLine.SETFILTER(WarehouseActivityLine."Qty. Outstanding", '>%1', 0);
                    WarehouseActivityLine.SETRANGE("Source Type", 37);
                    IF WarehouseActivityLine.FINDSET THEN
                        REPEAT
                            IF WarehouseActivityLine.OrderStatus <> WarehouseActivityLine.OrderStatus::Canceled THEN BEGIN
                                FindBin := FALSE;
                                bincontent.RESET;
                                binContent.Setcurrentkey("Location Code", "Bin Code", "Item No.");
                                bincontent.SETRANGE("Location Code", WarehouseActivityLine."Location Code");
                                bincontent.SETRANGE("Item No.", WarehouseActivityLine."Item No.");
                                bincontent.SETFILTER(bincontent."Bin Type Code", '%1', Loc.InventoryTypeBin);
                                IF bincontent.FINDSET THEN
                                    REPEAT
                                        bincontent.CALCFIELDS(bincontent.Quantity, bincontent."Pick Quantity (Base)");
                                        Qty := bincontent.Quantity - bincontent."Pick Quantity (Base)";
                                        IF (Qty > 0) AND (WarehouseActivityLine."Qty. Outstanding" > 0) THEN BEGIN
                                            WarehouseActivityLine.VALIDATE("Bin Code", bincontent."Bin Code");
                                            IF WarehouseActivityLine."Qty. Outstanding" < Qty THEN
                                                WarehouseActivityLine.VALIDATE(WarehouseActivityLine."Qty. to Handle", WarehouseActivityLine."Qty. Outstanding")
                                            ELSE
                                                WarehouseActivityLine.VALIDATE(WarehouseActivityLine."Qty. to Handle", Qty);
                                            WarehouseActivityLine.MODIFY(TRUE);
                                        END;
                                        IF WarehouseActivityLine2.GET(WarehouseActivityLine."Activity Type", WarehouseActivityLine."No.", WarehouseActivityLine."Line No." + 10000) THEN BEGIN
                                            WarehouseActivityLine2.VALIDATE("Qty. to Handle", WarehouseActivityLine2."Qty. Outstanding");
                                            WarehouseActivityLine2.MODIFY;
                                        END;
                                        FindBin := TRUE;
                                    UNTIL (bincontent.NEXT() = 0) OR (FindBin = TRUE);
                                IF NOT FindBin THEN BEGIN
                                    WarehouseActivityLine.VALIDATE(WarehouseActivityLine."Qty. to Handle", 0);
                                    WarehouseActivityLine2.RESET;
                                    WarehouseActivityLine2.SETRANGE("Activity Type", "Activity Type"::Pick);
                                    WarehouseActivityLine2.SETRANGE("No.", "No.");
                                    WarehouseActivityLine2.SETRANGE("Action Type", WarehouseActivityLine."Action Type"::Place);
                                    WarehouseActivityLine2.SETRANGE(WarehouseActivityLine2."Item No.", WarehouseActivityLine."Item No.");
                                    WarehouseActivityLine2.SETFILTER("Bin Code", '%1', '');
                                    IF WarehouseActivityLine2.FINDFIRST THEN BEGIN
                                        WarehouseActivityLine2.VALIDATE("Qty. to Handle", 0);
                                        WarehouseActivityLine2.MODIFY(TRUE);
                                    END;
                                    WarehouseActivityLine.MODIFY(TRUE);
                                END;
                            END;
                        UNTIL WarehouseActivityLine.NEXT = 0;
                end;
            }
        }
    }
    local procedure ClearTakeBins(pickNr: code[20])
    var
        whsActLines: Record "Warehouse Activity Line";
    begin
        whsActLines.RESET;
        whsActLines.SETRANGE("Activity Type", whsActLines."Activity Type"::Pick);
        whsActLines.SETRANGE("No.", PickNr);
        whsActLines.SETRANGE("Action Type", whsActLines."Action Type"::Take);
        whsActLines.SETFILTER("Bin Code", '<>%1', '');
        IF whsActLines.FINDSET THEN
            REPEAT
                whsActLines."Zone Code" := '';
                whsActLines."Bin Code" := '';
                whsActLines."Bin Type Code" := '';
                whsActLines.MODIFY;
            UNTIL whsActLines.NEXT = 0;
    end;

    var
        myInt: Integer;
}
