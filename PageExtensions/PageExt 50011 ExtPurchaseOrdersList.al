pageextension 50011 ExtPurchaseOrdersLists extends "Purchase Order List"
{
    layout
    {
        addafter("Buy-from Vendor No.")
        {
            field("Vendor Invoice No."; "Vendor Invoice No.")
            {
                ApplicationArea = All;
            }
            field("Order Date"; "Order Date")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter(Statistics)

        {
            action(PurchaseReceiptNew)
            {
                RunObject = Page "Purchase OrderNew";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }
            action("PurchaseReceiveNew")
            {
                RunObject = Page "PurchaseOrderDevices";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }

        }
    }

    var
        myInt: Integer;
}