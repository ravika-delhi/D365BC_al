pageextension 50036 Ext_WhsShipmntSubform extends "Whse. Shipment Subform"
{
    layout
    {
        addafter("Source No.")
        {
            field("Batch No"; "Batch No")
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

    procedure PickCreateN()
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
        WhseShptLine: Record "Warehouse Shipment Line";
        ReleaseWhseShipment: Codeunit "Whse.-Shipment Release";
    begin
        WhseShptLine.Copy(Rec);
        WhseShptHeader.Get(WhseShptLine."No.");
        if WhseShptHeader.Status = WhseShptHeader.Status::Open then ReleaseWhseShipment.Release(WhseShptHeader);
        CreatePickDoc1(WhseShptLine, WhseShptHeader);
    end;
}
