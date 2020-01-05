pageextension 50191 ExtendsPostedWhsRcpts extends "Posted Whse. Receipt List"
{
  layout
  {
    addafter("No.")
    {
      field(DocumentNr;DocumentNr)
      {
        ApplicationArea = all;
      }
    }
  }
  actions
  {
  }
  var myInt: Integer;
}
