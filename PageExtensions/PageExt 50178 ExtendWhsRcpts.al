pageextension 50178 ExtendWhsRcpts extends "Warehouse Receipts"
{
  layout
  {
    addafter("No.")
    {
      field(DocumentNr;DocumentNr)
      {
        ApplicationArea = All;
      }
    }
  }
  actions
  {
  }
  var myInt: Integer;
}
