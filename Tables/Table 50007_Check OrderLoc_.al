table 50007 "Check OrderLoc"
{
  // version Mod113.01
  Permissions = tabledata "Check OrderLoc"=rimd;
  DataPerCompany = false;

  fields
  {
    field(1;OrderNo;Code[50])
    {
      DataClassification = ToBeClassified;
    }
    field(2;LocationCode;Code[10])
    {
      DataClassification = ToBeClassified;
    }
    field(3;Split;Boolean)
    {
      DataClassification = ToBeClassified;
    }
    field(4;NoOfLines;Integer)
    {
      DataClassification = ToBeClassified;
    }
    field(5;CmpName;Text[20])
    {
      DataClassification = ToBeClassified;
    }
    field(6;ItemVendorStk;Decimal)
    {
      DataClassification = ToBeClassified;
    }
    field(7;ShipToLocation;Code[10])
    {
      DataClassification = ToBeClassified;
    }
    field(8;Used;Boolean)
    {
      DataClassification = ToBeClassified;
    }
    field(9;Order_QtyDue;Decimal)
    {
      DataClassification = ToBeClassified;
    }
    field(10;B2BQty;Decimal)
    {
      DataClassification = ToBeClassified;
    }
    field(11;CntOfItemsInWHSStock;Integer)
    {
      DataClassification = ToBeClassified;
    }
    field(12;B2BStockDefinedforWHS;Integer)
    {
      DataClassification = ToBeClassified;
    }
    field(13;NoOfItemsForOrders;Integer)
    {
      DataClassification = ToBeClassified;
    }
    field(14;TotalItemsAvailForShipping;Integer)
    {
      DataClassification = ToBeClassified;
    }
    field(15;Instock;Integer)
    {
      DataClassification = ToBeClassified;
    }
  }
  keys
  {
    key(Key1;OrderNo, LocationCode)
    {
    }
    key(Key2;NoOfLines, OrderNo)
    {
    }
    key(Key3;B2BQty, Order_QtyDue)
    {
    }
    key(Key4;Used, B2BQty, TotalItemsAvailForShipping)
    {
    }
  }
  fieldgroups
  {
  }
}
