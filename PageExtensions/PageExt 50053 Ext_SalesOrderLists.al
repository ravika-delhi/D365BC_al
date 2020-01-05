pageextension 50053 UpdateLocationSH extends "Sales Order List"
{
    layout
    {
        addafter("Location Code")
        {
            field(BatchNo; BatchNo)
            {
                ApplicationArea = All;
            }
            field("Order Date"; "Order Date")
            {
                ApplicationArea = ALL;
            }
            field("Order Status"; "Order Status")
            {
                ApplicationArea = All;
            }
            field("Aramex Reference No."; "Aramex Reference No.")
            {
                ApplicationArea = All;
            }
            field(Carrier; Carrier)
            {
                ApplicationArea = All;
            }
            field(AWBNo; AWBNo)
            {
                ApplicationArea = All;
            }

            field("Payment Method Code"; "Payment Method Code")
            {
                ApplicationArea = All;
            }
            Field(AmttoCollect; AmttoCollect)
            {
                ApplicationArea = All;

            }

            field("Amount to Customer"; "Amount to Customer")
            {
                ApplicationArea = all;
            }
            field(SalesInvoiced; SalesInvoiced)
            {
                ApplicationArea = All;
            }

            field("Bill-to City"; "Bill-to City")
            {
                ApplicationArea = all;
            }
            field("Bill-to Address"; "Bill-to Address")
            {
                ApplicationArea = all;
            }
            field("Ship-to City"; "Ship-to City")
            {
                ApplicationArea = all;
            }
            field("Ship-to Address"; "Ship-to Address")
            {
                ApplicationArea = all;
            }
            field("Ship-to Address 2"; "Ship-to Address 2")
            {
                ApplicationArea = all;
            }
            field("Manifest No."; "Manifest No.")
            {
                ApplicationArea = All;
            }
            field(completed_at; completed_at)
            {
                ApplicationArea = all;
            }
            field(ARCreated; ARCreated)
            {
                ApplicationArea = All;
            }
            field(RetryCount; RetryCount)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Release")
        {
            action(UpdateLocations_DXB)
            {
                ApplicationArea = All;
                Promoted = TRUE;
                PromotedCategory = Process;
                Visible = TRUE;

                trigger OnAction()
                begin
                    REPORT.RunModal(50014, False, False);
                end;
            }
            action(Reset_RetryCount)
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Process;
                Visible = true;
                trigger OnAction()
                begin
                    SetRange("Document Type", "Document Type"::Order);
                    SetFilter(RetryCount, '>%1', 0);
                    IF FindFirst then
                        ModifyAll(RetryCount, 0);
                end;

            }
        }
    }
}
