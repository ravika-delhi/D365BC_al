pageextension 50023 ExtPostedSalesCreditMemos extends "Posted Sales Credit Memos"
{
    layout
    {
        addafter("Posting Date")
        {
            field("External Document No."; "External Document No.")
            {
                ApplicationArea = All;
                Visible = true;
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