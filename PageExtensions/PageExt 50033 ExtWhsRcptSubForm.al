pageextension 50033 ExtWhsRcptSubForm extends "Whse. Receipt Subform"
{
    layout
    {
        modify(Description)
        {
            visible = False;
        }
        modify("Location Code")
        {
            ApplicationArea = All;
            Visible = true;
        }
        addafter("Item No.")
        {
            field(ProductName; ProductName)
            {
                ApplicationArea = All;
            }
            field("Web Order Id"; "Web Order Id")
            {
                ApplicationArea = All;
            }
            field(Cancelled; Cancelled)
            {
                ApplicationArea = All;
            }
            field(WebOrderLineNo; WebOrderLineNo)
            {
                ApplicationArea = All;
                Visible = false;
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
    procedure WhsePostRcptYesNo_New()
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        salesSetup: Record "Sales & Receivables Setup";
        loc: Record Location;
    begin
        loc.get(Rec."Location Code");

        WhseRcptLine.SetRange(ScannedBy, UserId);
        WhseRcptLine.Copy(Rec);
        IF loc.PickBinScanMand then begin
            If (WhseRcptLine."Source Type" = 39) and (WhseRcptLine.ScannedBy = '') then
                Error('Please scan the quantity');
            CODEUNIT.Run(CODEUNIT::"Whse.-Post Receipt (Yes/No)N", WhseRcptLine);
        end else begin
            CODEUNIT.Run(CODEUNIT::"Whse.-Post Receipt (Yes/No)N", WhseRcptLine);
        end;
        Reset;
        SetCurrentKey("No.", "Sorting Sequence No.");
        CurrPage.Update(false);
    end;
}
