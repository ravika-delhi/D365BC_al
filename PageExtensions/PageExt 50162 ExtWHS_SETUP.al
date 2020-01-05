pageextension 50162 ExtWHS_SETUP extends "Warehouse Setup"
{
  layout
  {
    addafter("Require Pick")
    {
      field(Shipment_Url;Shipment_Url)
      {
        ApplicationArea = ALL;
      }
      field(Shipment_method;Shipment_method)
      {
        ApplicationArea = all;
      }
      field(consumerKey;consumerKey)
      {
        ApplicationArea = all;
      }
      field(consumerSecret;consumerSecret)
      {
        ApplicationArea = All;
      }
      field(accessSecret;accessSecret)
      {
        ApplicationArea = all;
      }
      field(accessToken;accessToken)
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
