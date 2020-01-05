pageextension 50009 Ext_UserSetup extends "User Setup"
{
    layout
    {
        addafter("Time Sheet Admin.")
        {
            field(SuperAdmin; SuperAdmin)
            {
                ApplicationArea = ALL;
            }
            field(EnableAutoFill; EnableAutoFill)
            {
                ApplicationArea = ALL;
            }
            field(ShowAllPicks; ShowAllPicks)
            {
                ApplicationArea = ALL;
            }
            field(StockCountBatchs; StockCountBatchs)
            {
                ApplicationArea = ALL;
            }
            field(StockCntTemp; StockCntTemp)
            {
                ApplicationArea = ALL;
            }
            field(userPrinter; userPrinter)
            {
                ApplicationArea = All;
            }
            field(userLoc; userLoc)
            {
                ApplicationArea = All;
            }
            field(PickTemplates; PickTemplates)
            {
                ApplicationArea = All;
            }
            field(PutAwayTemplates; PutAwayTemplates)
            {
                ApplicationArea = all;
            }
            field(GenJnlTemp; GenJnlTemp)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
    }
    var
        myInt: Integer;
}
