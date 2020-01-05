pageextension 50008 ExtAssemblyOrders extends "Assembly Orders"
{
    layout
    {
        addafter("Item No.")
        {
            field(WebOrderNo; WebOrderNo)
            {
                ApplicationArea = all;
            }
            field(GSOrderID; GSOrderID)
            {
                ApplicationArea = All;
            }
            field("Inventory Posting Group"; "Inventory Posting Group")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Gen. Prod. Posting Group"; "Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Editable = true;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}