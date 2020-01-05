pageextension 50043 ExtendWhsRoleCenter extends "Whse. Basic Role Center"
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
        modify(InventoryPicks)
        {
            Visible = false;
        }
        modify(InventoryPutaways)
        {
            Visible = false;
        }
        modify(InventoryMovements)
        {
            Visible = false;
        }
        modify("Internal Movements")
        {
            Visible = false;
        }
        modify(PhysInventoryOrders)
        {
            Visible = false;
        }
        modify(PhysInventoryRecordings)
        {
            Visible = false;
        }
        modify(ShippingAgents)
        {
            Visible = false;
        }
        modify(PhysInventoryJournals)
        {
            Visible = false;
        }
        addafter(AssemblyOrders)
        {
            action("Stock Count")
            {
                //      RunObject = Page "Whse. Item Journals";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }
            action("Print Picks")
            {
                RunObject = Page "Picks Not Printed";
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
                RunObject = Page "Bin wise Stock check";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;
            }
            action("Open Picks")
            {
                RunObject = Page "Warehouse Picks";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Whs Picks")
            {
                RunObject = Page "Warehouse Picks";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Whs Put-aways")
            {
                RunObject = Page "Warehouse Put-aways";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Whs Receipts")
            {
                RunObject = Page "Warehouse Receipts";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Whs Shipments")
            {
                RunObject = Page "Warehouse Shipment List";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Print Awb")
            {
                RunObject = Page "AWBIntegrationLists";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Manifest")
            {
                RunObject = Page "Manifest List";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Reclass")
            {
                RunObject = Page "Whse. Reclass Jnl. List";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }
            action("Sales Return")
            {
                RunObject = Page "Order Return";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }

        }
    }
    var
        myInt: Integer;
}
