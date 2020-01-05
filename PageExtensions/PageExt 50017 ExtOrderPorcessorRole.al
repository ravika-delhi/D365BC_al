pageextension 50017 ExtendOrderProcessorRoleCenter extends "Order Processor Role Center"
{
    layout
    {
    }
    actions
    {
        modify(SalesOrdersShptNotInv)
        {
            Visible = false;
        }
        modify(SalesOrdersComplShtNotInv)
        {
            Visible = false;
        }
        modify(Customer)
        {
            Visible = false;
        }
        modify("Item Journals")
        {
            Visible = false;
        }
        modify(SalesJournals)
        {
            visible = false;
        }
        modify(CashReceiptJournals)
        {
            visible = false;
        }
        modify("Transfer Orders")
        {
            visible = false;
        }

        addafter("Transfer Orders")
        {
            action(PurchaseOrders)
            {
                ApplicationArea = All;
                RunObject = Page "Purchase Order List";
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Import Supplier Orders")
            {
                RunObject = Page "KSASupplierMapping";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }
            action("Purchase Receive")
            {
                RunObject = Page "Purchase Order List";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }
            action("Import Manifest")
            {
                RunObject = page "KSA Manifests Lists";
                ApplicationArea = ALL;
                Promoted = TRUE;
            }
            action("Item Lists")
            {
                RunObject = Page "Item List";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }
            action("Physical Inventory")
            {
                RunObject = Page "Whse. Phys. Invt. Jnl. List";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }

            action("Sales Return")
            {
                RunObject = Page "Order Return";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("PurchaseReceiveNew")
            {
                RunObject = Page "Purchase Order List";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }
            action("JED Sales Returns")
            {
                RunObject = Page "OrderTrackingReturnLists";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }
        }
    }
    var
        myInt: Integer;
}
