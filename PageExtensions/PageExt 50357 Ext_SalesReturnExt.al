pageextension 50357 Ext_SalesReturnExt extends "Sales Return Order"
{
    layout
    {
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Campaign No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Assigned User ID")
        {
            Visible = false;
        }
        modify("Your Reference")
        {
            Caption = 'Return AWB';
            ShowMandatory = true;
        }
        addafter("Status")
        {
            field("Order Status"; "Order Status")
            {
                ApplicationArea = All;
            }
            field(scanItems; scanItems)
            {
                ApplicationArea = All;
                QuickEntry = true;

                trigger OnValidate()
                var
                    SRLines: Record "Sales Line";
                    NewSR: Record "Sales Line";
                    Linenos: Integer;
                    ItemRec: Record Item;
                    barcode: Code[20];
                    barcode1: Code[20];
                    userSetup: Record "User Setup";
                    recItems: Record Item;
                    Items: Record Item;
                    barcode2: Code[20];
                    scanItem: Code[20];
                    NewItems: Page "Item List";
                begin
                    IF ("External Document No." = '') Or ("Your Reference" = '') THEN Error('Please update External Document No field and Your Reference.');
                    userSetup.Get(UserId);
                    if not recItems.Get(scanItems) then begin
                        Items.Reset;
                        Items.SetFilter(Items."No.", '%1|%2', '*' + scanItems + '*', CopyStr(scanItems, 2, StrLen(scanItems)));
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
                    end
                    else
                        barcode1 := scanItems;
                    salesSetup.Get;
                    SRLines.Reset;
                    SRLines.SetRange("Document Type", SRLines."Document Type"::"Return Order");
                    SRLines.SetRange(SRLines."Document No.", Rec."No.");
                    SRLines.SetRange(SRLines."No.", barcode1);
                    if SRLines.FindFirst then begin
                        SRLines.Validate(SRLines.Quantity, SRLines.Quantity + 1);
                        // SRLines."Shipment No." := Rec."External Document No.";
                        SRLines.Modify;
                        CurrPage.Update(True);
                    end
                    else begin
                        NewSR.Reset;
                        NewSR.SetCurrentKey("Document Type", "No.", "Line No.");
                        NewSR.Ascending(True);
                        NewSR.SetRange("Document Type", NewSR."Document Type"::"Return Order");
                        NewSR.SetRange("Document No.", Rec."No.");
                        if NewSR.FindLast then
                            Linenos := NewSR."Line No."
                        else
                            Linenos := 0;
                        Linenos += 100;
                        SRLines.Init;
                        SRLines."Document Type" := SRLines."Document Type"::"Return Order";
                        SRLines."Document No." := Rec."No.";
                        SRLines."Line No." := SRLines."Line No." + 100;
                        SRLines.Validate("Sell-to Customer No.", Rec."Sell-to Customer No.");
                        SRLines.Type := SRLines.Type::Item;
                        SRLines.Validate("No.", barcode1);
                        SRLines.Validate(Quantity, 1);
                        //SRLines."Shipment No." := rec."External Document No.";
                        SRLines.Insert;
                    end;
                    scanItems := '';
                    CurrPage.Update;
                end;
            }
        }
    }
    actions
    {
        modify("Create &Whse. Receipt")
        {
            Caption = 'Create &Whse. Receipt';
            Visible = true;
        }
        addafter("F&unctions")
        {
            action("Send SalesReturnASN")
            {
                Caption = 'Send to Aramex ASN';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = XMLFile;

                trigger OnAction()
                var

                    SyncSingleOrder: Codeunit "Sync-ASNs";
                    locs: Record Location;
                begin
                    locs.get("Location Code");

                    SyncSingleOrder.SyncSingleOrder(Rec);
                end;
            }
        }
    }
    var
        scanItems: code[20];
        salesSetup: Record "Sales & Receivables Setup";
        Line_nr: BigInteger;
}
