pageextension 50100 "GTFS Location Card Ext" extends "Location Card"
{
    layout
    {
        addafter("Bin Policies")
        {
            group("GTFS WebService")
            {
                group(Aramex)
                {
                    field("Aramex Facility"; "Aramex Facility")
                    {
                        ApplicationArea = All;
                    }
                    field("Aramex Forwarder"; "Aramex Forwarder")
                    {
                        ApplicationArea = All;
                    }
                    field("Aramex StorerKey"; "Aramex StorerKey")
                    {
                        ApplicationArea = All;
                    }
                    field("Transportation Mode"; "Transportation Mode")
                    {
                        ApplicationArea = All;
                    }
                    field("Multiple Carriers"; "Multiple Carriers")
                    {
                        ApplicationArea = All;
                    }
                    field(InventoryTypeBin; InventoryTypeBin)
                    {
                        ApplicationArea = All;
                    }
                    field(printerID; printerID)
                    {
                        ApplicationArea = all;
                    }
                    field(CrossDockZone; CrossDockZone)
                    {
                        ApplicationArea = All;
                    }
                    field(NDays; NDays)
                    {
                        ApplicationArea = All;
                    }
                    field(ExportVAT; ExportVAT)
                    {
                        ApplicationArea = All;
                    }
                    Field(DomesticVAT; DomesticVAT)
                    {
                        ApplicationArea = All;
                    }
                    Field(VATApplicable; VATApplicable)
                    {
                        ApplicationArea = All;
                    }
                    Field(PickBinScanMand; PickBinScanMand)
                    {
                        ApplicationArea = All;
                    }
                    field(EntityName; EntityName)
                    {
                        ApplicationArea = All;
                    }
                    field(WMSIntegration; WMSIntegration)
                    {
                        ApplicationArea = All;
                    }
                    field(BatchNos; BatchNos)
                    {
                        ApplicationArea = All;
                    }
                    field(NALocations; NALocations)
                    {
                        ApplicationArea = All;
                    }
                    field(ZoneCode; ZoneCode)
                    {
                        ApplicationArea = all;
                    }
                    field(BinChng; BinChng)
                    {
                        ApplicationArea = all;
                    }
                    field(NewBinType; NewBinType)
                    {
                        ApplicationArea = all;
                    }
                    field(AramexTransactionID; AramexTransactionID)
                    {
                        ApplicationArea = All;
                    }
                    field(AramexSOReference; AramexSOReference)
                    {
                        ApplicationArea = All;
                    }
                    field(printerkey; printerkey)
                    {
                        ApplicationArea = All;
                    }
                    field(BatchNoSeries; BatchNoSeries)
                    {
                        ApplicationArea = All;
                    }
                    field(ReturnCustomer; ReturnCustomer)
                    {
                        ApplicationArea = All;
                    }
                    field(aramexUser; aramexUser)
                    {
                        ApplicationArea = All;
                    }
                    field(aramexPwd; aramexPwd)
                    {
                        ApplicationArea = All;
                    }
                    field(switchAramexOrderSync; switchAramexOrderSync)
                    {
                        ApplicationArea = All;
                    }

                }
            }
        }
    }
    actions
    {
    }
}
