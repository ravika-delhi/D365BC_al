pageextension 50014 ExtendWhWorkerRoleCenter extends "Whse. WMS Role Center"
{
    layout
    {
    }
    actions
    {
        modify(TransferOrders)
        {
            Visible = false;
        }
        modify(ReleasedProductionOrders)
        {
            Visible = false;
        }
        modify(AssemblyOrders)
        {
            Visible = false;
        }
        modify(WhseShpt)
        {
            Visible = false;
        }
        modify(WhseShptReleased)
        {
            visible = false;
        }
        modify(WhseShptComplPicked)
        {
            visible = false;
        }
        modify(WhseShptPartShipped)
        {
            visible = false;
        }
        modify(WhseRcpt)
        {
            visible = false;
        }
        modify(WhseRcptPartReceived)
        {
            visible = false;
        }
        modify(PhysInvtOrders)
        {
            visible = false;
        }
        modify(PhysInvtRecordings)
        {
            visible = false;
        }
        modify(Picks)
        {
            visible = false;
        }
        modify(PicksUnassigned)
        {
            visible = false;
        }
        modify(Putaway)
        {
            visible = false;
        }
        modify(Movements)
        {
            visible = false;
        }
        modify(MovementsUnassigned)
        {
            visible = false;
        }
        modify(BinContents)
        {
            visible = false;
        }



        modify(PhysInventoryJournals)
        {
            Visible = false;
        }
        addafter(AssemblyOrders)
        {
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
                RunObject = Page "KSA Manifests Lists";
                Caption = 'Manifests';
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
                RunObject = Page "Item Details";
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
