pageextension 50068 ExtPCR extends "Posted Whse. Receipt Subform"
{
    layout
    {
        addafter("Source No.")
        {
            field("Web Order Id"; "Web Order Id")
            {
                ApplicationArea = All;
            }
            field(WebOrderLineNo; WebOrderLineNo)
            {
                ApplicationArea = All;
            }
            field(GSOrderItemUID; GSOrderItemUID)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }

    procedure PutAwayCreateN()
    var
        PostedWhseRcptHdr: Record "Posted Whse. Receipt Header";
        PostedWhseRcptLine: Record "Posted Whse. Receipt Line";
    begin
        PostedWhseRcptHdr.Get("No.");
        PostedWhseRcptLine.Copy(Rec);
        CreatePutAwayDoc1(PostedWhseRcptLine, PostedWhseRcptHdr."Assigned User ID");
    end;
}
