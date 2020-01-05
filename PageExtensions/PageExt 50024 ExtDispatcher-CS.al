pageextension 50024 ExtDispatcherCS extends "Service Dispatcher Role Center"
{

    layout
    {


    }

    actions
    {
        modify(Items)
        {
            Visible = False;
        }
        modify("Item Journals")
        {
            Visible = False;
        }
        modify("Requisition Worksheets")
        {
            Visible = false;
        }
        addafter(Customers)
        {
            action("Customer ReturnsCS")
            {

                RunObject = Page "Customer ReturnsCS";
                ApplicationArea = ALL;
                Promoted = TRUE;
                PromotedCategory = Process;

            }
        }
    }

    var
        myInt: Integer;
}