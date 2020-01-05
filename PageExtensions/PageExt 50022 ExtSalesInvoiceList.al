pageextension 50022 ExtSalesInvoiceLists extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Location Code")
        {
            field("Payment Method Code"; "Payment Method Code")
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