codeunit 50021 "Update Canceled Items"
{
  trigger OnRun()begin
    if cntCancelItem <= 500 then exit;
    Cancelitems.Reset;
    Cancelitems.SetCurrentKey(Updated, CancelledDatetime);
    Cancelitems.SetRange(Updated, false);
    if Cancelitems.FindFirst then repeat if OrdTrack.Get(Cancelitems.GSOrderItemUID)then begin
          cntCancelItem+=1;
          OrdTrack."Order Item Status":=OrdTrack."Order Item Status"::Canceled;
          OrdTrack."Cancel DatTime":=Cancelitems.CancelledDatetime;
          OrdTrack.Modify;
          SalesLines.Reset;
          SalesLines.SetCurrentKey(GSOrderItemID);
          SalesLines.SetRange(GSOrderItemID, Cancelitems.GSOrderItemUID);
          SalesLines.SetFilter("Order Status", '<>%1|<>%2', SalesLines."Order Status"::Canceled, SalesLines."Order Status"::Shipped);
          if SalesLines.FindFirst then begin
            SalesLines.Validate("Order Status", SalesLines."Order Status"::Canceled);
            SalesLines.Validate(Quantity, 0);
            SalesLines.Validate("Unit Price", 0);
            SalesLines.Validate("Line Amount", 0);
            SalesLines.Modify;
          end;
          WhActLines.Reset;
          WhActLines.SetCurrentKey(GSOrderItemUID);
          WhActLines.SetRange("Activity Type", WhActLines."Activity Type"::Pick);
          WhActLines.SetRange(GSOrderItemUID, Cancelitems.GSOrderItemUID);
          if WhActLines.FindSet then repeat WhActLines.OrderStatus:=WhActLines.OrderStatus::Canceled;
              WhActLines."Bin Code":='';
              WhActLines."Zone Code":='';
              WhActLines."Qty. Outstanding":=0;
              WhActLines."Qty. Outstanding (Base)":=0;
              //WhActLines.Quantity=0;
              //WhActLines."Qty. (Base)":=0;
              WhActLines.Validate(Quantity, 0);
              WhActLines.Modify;
            until WhActLines.Next = 0;
          Cancelitems.Updated:=TRUE;
          Cancelitems.updated_at:=CurrentDateTime;
          Cancelitems.Modify();
        End
        ELse
        Begin
          Cancelitems.Updated:=TRUE;
          Cancelitems.updated_at:=CurrentDateTime;
          Cancelitems.Modify();
        END;
      until(Cancelitems.Next = 0) Or (cntCancelItem <= 500);
  end;
  var Cancelitems: Record "Cancelled Items";
  SalesLines: Record "Sales Line";
  OrdTrack: Record "Order Tracking Table";
  WhsShipLine: Record "Warehouse Journal Line";
  WhActLines: Record "Warehouse Activity Line";
  cntCancelItem: Integer;
}
