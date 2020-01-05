pageextension 50015 Extend_WhsShipmntLists extends "Warehouse Shipment List"
{
    layout
    {
        modify("Assigned User ID")
        {
            Visible = true;
            ApplicationArea = ALL;
        }
        addafter("Assigned User ID")
        {
            field(NoOfItems; NoOfItems)
            {
                ApplicationArea = All;
            }
            field("External Document No."; "External Document No.")
            {
                ApplicationArea = All;
            }
            field(OrderNo; OrderNo)
            {
                ApplicationArea = All;
            }
            Field(BatchNo; BatchNo)
            {
                ApplicationArea = All;
            }
            Field(RetryCnt; RetryCnt)
            {
                ApplicationArea = All;
            }
            Field(AWBExists; AWBExists)
            {
                ApplicationArea = All;
            }

        }
    }
    actions
    {
    }
    var
        myInt: Integer;
}
