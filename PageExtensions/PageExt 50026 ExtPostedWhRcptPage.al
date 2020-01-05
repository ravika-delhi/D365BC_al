pageextension 50026 ExtPostedWhRcptPage extends "Posted Whse. Receipt"
{
    layout
    {
        addafter("No.")
        {
            field(DocumentNr; DocumentNr)
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify("Create Put-away")
        {
            Visible = False;
        }
        addafter("Create Put-away")
        {
            action("Create PutawayNew")
            {
                ApplicationArea = All;
                Caption = 'Create PutawayNew', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                visible = True;

                trigger OnAction()
                begin
                    CurrPage.Update(true);
                    CurrPage.PostedWhseRcptLines.PAGE.PutAwayCreateN;
                end;
            }
        }
    }
}
