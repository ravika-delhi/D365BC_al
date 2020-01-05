pageextension 50012 ExtAssemblyOrder extends "Assembly Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        modify("Create Warehouse Pick")
        {
            Visible = false;
            ApplicationArea = All;
        }
        addafter("Create Inventor&y Movement")
        {
            action("Create PickNew")
            {
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger onAction()
                var
                    myInt: Integer;
                begin
                    CreatePickN(TRUE, USERID, 0, FALSE, FALSE, FALSE);
                end;
            }
        }
    }
    var
        myInt: Integer;
}