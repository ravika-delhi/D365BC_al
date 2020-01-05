pageextension 50151 ExtShipping_Agents extends "Shipping Agents"
{
  layout
  {
    addafter("Internet Address")
    {
      field("Customer No.";"Customer No.")
      {
        ApplicationArea = All;
      }
      field("COD A/C No.";"COD A/C No.")
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
