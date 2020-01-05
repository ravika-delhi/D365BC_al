pageextension 50029 Ext_WhsPutawaySubForm extends "Whse. Put-away Subform"
{
    layout
    {
        modify(Description)
        {
            Visible = False;
        }
        modify("Zone Code")
        {
            Visible = TRUE;
            ApplicationArea = ALL;
        }
        modify("Bin Code")
        {
            Visible = True;
            ApplicationArea = All;
        }
        addafter("Source No.")
        {
            Field(ProductName; ProductName)
            {
                ApplicationArea = All;
            }
            field("Web Order ID"; "Web Order ID")
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
            field(putawayItemScanned; putawayItemScanned)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
    procedure RegisterPutAwayYesNoNew()
    var
        WhseActivLine: Record "Warehouse Activity Line";
    begin
        WhseActivLine.Copy(Rec);
        WhseActivLine.FilterGroup(3);
        WhseActivLine.SetRange(Breakbulk);
        WhseActivLine.FilterGroup(0);
        CODEUNIT.Run(CODEUNIT::"Whse.-Act-RegisterN (Yes/No)", WhseActivLine);
        Reset;
        SetCurrentKey("Activity Type", "No.", "Sorting Sequence No.");
        FilterGroup(4);
        SetRange("Activity Type", "Activity Type");
        SetRange("No.", "No.");
        FilterGroup(3);
        SetRange(Breakbulk, false);
        FilterGroup(0);
        CurrPage.Update(false);
    end;
}
