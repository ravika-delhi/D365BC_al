pageextension 50097 ExtSalesOrders extends "Sales Order"
{
    layout
    {
        modify("Payment Method Code")
        {
            ApplicationArea = All;
            Visible = True;
        }
        addafter("External Document No.")
        {
            field("Order Status"; "Order Status")
            {
                ApplicationArea = All;

                trigger OnValidate()
                var
                    salesLine: Record "Sales Line";
                begin
                    salesLine.reset;
                    salesLine.SetRange("Document Type", "Document Type");
                    salesLine.SetRange("Document No.", "No.");
                    salesLine.setfilter("Order Status", '%1|%2', salesLine."Order Status"::Exportable, salesLine."Order Status"::Released);
                    If salesLine.FINDSET THEN
                        repeat
                            salesLine.VALIDATE("Order Status", salesLine."Order Status"::Canceled);
                            salesLine.Modify();
                        until salesLine.Next = 0;
                end;
            }
            Field(AmttoCollect; AmttoCollect)
            {
                ApplicationArea = All;

            }
            field("Order Value"; "Order Value")
            {
                ApplicationArea = All;
            }
            field("Amount to Customer"; "Amount to Customer")
            {
                ApplicationArea = all;
            }
            field("Aramex Reference No."; "Aramex Reference No.")
            {
                ApplicationArea = All;
            }


        }
    }
    actions
    {
        addafter("F&unctions")
        {
            action(PrintPackingSlip)
            {
                ApplicationArea = All;
                Caption = 'Print PickPackSlips', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SendAramexItems: Report "GoldenScent Packing Slip";
                begin
                    // REPORT.RUNMODAL(50098, FALSE, FALSE);
                    SendAramexItems.Run;
                end;
            }
            action("Process Customer")
            {
                ApplicationArea = All;
                Caption = 'Process Customer', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    REPORT.RUNMODAL(50152, false, false);
                end;
            }
            action("Release SO")
            {
                caption = 'Release SO';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = True;

                trigger OnAction()
                var
                    ReleaseSalesDoc: Codeunit "Release Sales DocumentN";
                begin
                end;
            }
            action("Send to Aramex EDI")
            {
                Caption = 'Send to Aramex EDI';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = XMLFile;

                trigger OnAction()
                var
                    GTFSWebservice: Codeunit "GTFS Webservice Initialize";
                    SyncSingleOrder: Codeunit "Sync-SalesOrdersJDH";
                    locs: Record Location;
                begin
                    locs.get("Location Code");
                    IF locs.switchAramexOrderSync then
                        SyncSingleOrder.SyncSingleOrder(Rec)
                    else
                        GTFSWebservice.ExecuteAramexEDIWebService(Rec);
                end;
            }
            action("Send SalesReturnASN")
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

                    SyncSingleOrder.SyncSingleOrder(Rec);
                end;
            }

        }
    }
}

