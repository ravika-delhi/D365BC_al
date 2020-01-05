pageextension 50054 ExtPutAwayLists extends "Warehouse Put-aways"
{
    layout
    {
        addafter("Source Document")
        {
            field("Registering No."; "Registering No.")
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