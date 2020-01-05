pageextension 50035 Ext_WhsShipment extends "Warehouse Shipment"
{
  layout
  {
  }
  actions
  {
    modify("Create Pick")
    {
      Visible = false;
    }
    addafter("Create Pick")
    {
      action("Create PickN")
      {
        Caption = 'Create Pick';
        ApplicationArea = All;

        trigger OnAction()begin
          CurrPage.Update(true);
          CurrPage.WhseShptLines.PAGE.PickCreateN;
        end;
      }
      action(GetShipmentReqN)
      {
        ApplicationArea = All;
        Promoted = true;
        PromotedCategory = Process;
        Image = XMLFile;
        Visible = false;

        trigger OnAction()var GetShipment: Codeunit "ProcessShipment";
        begin
          GetShipment.UpdateShipmentTracking('200851621');
        //GetShipment.RUN;
        end;
      }
      action(GetShipmentReq)
      {
        ApplicationArea = All;
        Promoted = true;
        PromotedCategory = Process;
        Image = XMLFile;
        Visible = false;

        trigger OnAction()var GetShipment: Codeunit "ProcessShipments";
        begin
          GetShipment.UpdateShipmentTracking();
        //GetShipment.RUN;
        end;
      }
      action(GetShipmentReqT)
      {
        ApplicationArea = All;
        Promoted = true;
        PromotedCategory = Process;
        Image = XMLFile;

        trigger OnAction()var GetShipment: Codeunit "ProcessShipment_test";
        begin
          GetShipment.UpdateShipmentTracking(Rec."External Document No.");
        //GetShipment.RUN;
        end;
      }
    }
  }
}
