pageextension 50041 ExtPickLists extends "Warehouse Picks"
{
    layout
    {
        addafter("Location Code")
        {
            field("In Complete"; "In Complete")
            {
                ApplicationArea = All;
            }
            field(BatchNo; BatchNo)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        addfirst("P&ick")
        {

            action("Open Picks")
            {
                RunObject = Page "Open Picks";
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
            }

        }

    }
    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.GET(UserId);
        If NOT UserSetup.SuperAdmin THEN SETRANGE("In Complete", FALSE);
    end;
}
