pageextension 50027 Ext_PurchaseOrderN extends "Purchase Order"
{
    layout
    {
        modify("Purchaser Code")
        {
            Visible = True;
            ShowMandatory = true;
            Importance = Additional;
            ShowCaption = true;
            ApplicationArea = ALL;
        }
        modify("Vendor Invoice No.")
        {
            ApplicationArea = all;
            //Visible = false;
            trigger OnAfterValidate()
            var
                purchLines: Record "Purchase Line";
            begin
                purchLines.reset;
                purchLines.SetRange("Document Type", rec."Document Type");
                purchLines.SetRange("Document No.", rec."No.");
                IF purchLines.FindFirst() then
                    purchLines.ModifyAll("Invoice No.", rec."Vendor Invoice No.");
            end;
        }
        modify("Vendor Shipment No.")
        {
            ApplicationArea = All;
            Visible = false;
        }
        addafter("Vendor Shipment No.")
        {
            field("Vendor Invoice No"; "Vendor Invoice No")
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnValidate()
                var
                    purchLines: Record "Purchase Line";
                    purchHdr: Record "Purchase Header";
                begin
                    purchHdr.reset;
                    purchHdr.get(Rec."Document Type", Rec."No.");
                    purchHdr.Validate(purchHdr."Vendor Invoice No.", Rec."Vendor Invoice No");
                    purchHdr.Modify(True);
                    purchLines.reset;
                    purchLines.SetRange("Document Type", rec."Document Type");
                    purchLines.SetRange("Document No.", rec."No.");
                    IF purchLines.FindFirst() then
                        purchLines.ModifyAll("Invoice No.", rec."Vendor Invoice No");
                End;
            }
            field("Vendor Invoice Qty"; "Vendor Invoice Qty")
            {
                ApplicationArea = All;
            }
            field("Vendor Invoice Val"; "Vendor Invoice Val")
            {
                ApplicationArea = All;
            }
            field(scanItems; scanItems)
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    POLines: Record "Purchase Line";
                    NewPO: Record "Purchase Line";
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
                    KSAVendMapping: Record KSASupplierMapping;
                    Items1: Record Item;
                begin
                    userSetup.Get(UserId);
                    barcode1 := Items1.CheckAlternateBarcode(scanItems);
                    IF not recItems.Get(barcode1) then BEgin
                        if not recItems.Get(scanItems) then
                            barcode1 := recItems.scannedItem(scanItems)
                        else
                            barcode1 := scanItems;
                    End;
                    salesSetup.Get;
                    POLines.Reset;
                    POLines.SetRange(POLines."Document No.", Rec."No.");
                    POLines.SetRange(POLines."No.", barcode1);
                    if POLines.FindFirst then begin
                        POLines.Validate(POLines.Quantity, POLines.Quantity + 1);
                        POLines."PO Num" := Rec."No.";
                        POLines."Stock Item" := true;
                        POLines.Modify;
                        CurrPage.Update(true);
                    end
                    else begin
                        NewPO.Reset;
                        NewPO.SetCurrentKey("Document Type", "No.", "Line No.");
                        NewPO.SetRange("Document Type", NewPO."Document Type"::Order);
                        NewPO.SetRange("Document No.", Rec."No.");
                        if not NewPO.Findset then
                            Linenos := 0
                        else
                            repeat
                                Linenos := Max(Linenos, NewPO."Line No.");
                            until NewPO.next = 0;


                        Linenos += 1000;
                        POLines.Init;
                        POLines."Document Type" := POLines."Document Type"::Order;
                        POLines."Document No." := Rec."No.";
                        POLines."Line No." := Linenos;
                        POLines.Validate("Buy-from Vendor No.", Rec."Buy-from Vendor No.");
                        POLines.Type := POLines.Type::Item;

                        POLines.Validate("No.", barcode1);
                        POLines.Validate(Quantity, 1);
                        KSAVendMapping.RESET;
                        KSAVendMapping.SetRange(Suppliers, Rec."Buy-from Vendor No.");
                        KSAVendMapping.SetRange(ItemSku, barcode1);
                        KSAVendMapping.SetRange(ShiptoWHS, rec."Location Code");
                        IF KSAVendMapping.FINDFIRST THEN
                            POLines.Validate("Direct Unit Cost", KSAVendMapping.UnitCost);
                        POLines."PO Num" := Rec."No.";
                        POLines.Insert;
                    end;
                    scanItems := '';
                    barcode1 := '';
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
            Visible = false;
        }
        addafter("Create &Whse. Receipt")
        {
            action("Create &Whse. ReceiptNew")
            {
                AccessByPermission = TableData "Warehouse Receipt Header" = R;
                ApplicationArea = Warehouse;
                Caption = 'Create &Whse. ReceiptNew';
                Image = NewReceipt;
                ToolTip = 'Create a warehouse receipt to start a receive and put-away process according to an advanced warehouse configuration.';
                Visible = true;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GetSourceDocInbound: Codeunit "Get Source Doc. Inbound New";
                begin
                    GetSourceDocInbound.CreateFromPurchOrder(Rec);
                    if not Find('=><') then Init;
                end;
            }
            action(Export2Excel)
            {
                Caption = 'Export to Excel';
                ApplicationArea = All;
                Image = Excel;

                trigger OnAction()
                var
                    purchaseLines: Record "Purchase Line";
                    exp2xl: Codeunit Export2Excel;
                begin
                    purchaseLines.reset;
                    purchaseLines.SetRange("Document Type", rec."Document Type");
                    purchaseLines.setrange("Document No.", rec."No.");
                    IF purchaseLines.Findfirst then exp2xl.Export2ExcelF(purchaseLines);
                    //Codeunit.Run(codeunit::Export2Excel);
                end;
            }
            action("Send Purchase ASN")
            {
                Caption = 'Send to Aramex ASN';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = XMLFile;

                trigger OnAction()
                var
                    GTFSWebservice: Codeunit "GTFS Webservice Initialize";
                    SyncSingleOrder: Codeunit "Sync-ASNs";
                    locs: Record Location;
                begin
                    locs.get("Location Code");
                    IF "Document Type" = "Document Type"::"Return Order" Then
                        SyncSingleOrder.SyncPurchaseASN(Rec);
                end;
            }
        }
    }
    procedure Max(number1: Integer; number2: Integer): Integer
    var

    begin
        IF number1 > number2 THEN
            EXIT(number1);
        EXIT(number2)
    end;

    var
        scanItems: code[20];
        salesSetup: Record "Sales & Receivables Setup";
        Line_nr: BigInteger;
}
