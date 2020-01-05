pageextension 50021 ExtSalesReturnOrderLists extends "Sales Return Order List"
{
    layout
    {
        addafter(Status)
        {
            field("Order Status"; "Order Status")
            {
                ApplicationArea = All;
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