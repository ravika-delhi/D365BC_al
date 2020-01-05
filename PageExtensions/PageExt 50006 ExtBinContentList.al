pageextension 50006 ExtBinContentList extends "Bin Contents List"
{
    layout
    {
        addafter("Item No.")
        {
            field(ProductName; ProductName)
            {
                ApplicationArea = all;
                Visible = true;
            }
            field(InventoryType; InventoryType)
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