pageextension 50055 ExtendContactList extends "Contact List"
{
  layout
  {
  }
  actions
  {
    addafter("Pro&files")
    {
      action(DeleteAll)
      {
        ApplicationArea = All;

        trigger OnAction()var ContactAltAdd: Record "Contact Alt. Address";
        ContactBusRel: Record "Contact Business Relation";
        begin
          DeleteAll();
          ContactAltAdd.DeleteAll();
          ContactBusRel.DeleteAll();
        end;
      }
    }
  }
  var myInt: Integer;
}
