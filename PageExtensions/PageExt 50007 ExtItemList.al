pageextension 50007 ExtItemList extends "Item List"
{
    layout
    {
        modify(Description)
        {
            Visible = false;
            ApplicationArea = All;
        }
        addAfter("No.")
        {
            field(ProductName; ProductName)
            {
                ApplicationArea = All;
            }

        }
        addafter("Cost is Adjusted")
        {
            field(SyncedWMS; SyncedWMS)
            {
                ApplicationArea = All;
            }

            field("Return Prod Posting Group"; "Return Prod Posting Group")
            {
                ApplicationArea = All;
            }
            field("Return Inventory Posting Group"; "Return Inventory Posting Group")
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        addafter(Item)
        {
            action(SendItemstoWMS)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    SyncItems: codeunit SyncItemsInfor;
                    myCount: Integer;
                begin
                    myCount := 0;
                    setrange(SyncedWMS, False);
                    IF Findfirst then
                        repeat
                            myCount += 1;
                            SyncItems.NewSKus(rec."No.");

                        until (next = 0) or (myCount >= 100);
                end;
            }
            action(SendBulkItemstoWMS)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    SyncItems: codeunit SyncItemsInfor;
                begin
                    rec.SetRange(SyncedWMS, FALSE);

                    SyncItems.AllSkuNdays(Rec);
                end;
            }
        }
    }

    var
        myInt: Integer;
}