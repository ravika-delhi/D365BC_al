pageextension 50016 "Sales&ReceivableSetup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Skip Manual Reservation")
        {
            field("Default Location Code"; "Default Location Code")
            {
                ApplicationArea = ALL;
            }
            field(PaymentJrnlTemplate; PaymentJrnlTemplate)
            {
                ApplicationArea = ALL;
            }
            field(PaymentJrnlBatch; PaymentJrnlBatch)
            {
                ApplicationArea = ALL;
            }
            field(ShippingChrgsAc; ShippingChrgsAc)
            {
                ApplicationArea = ALL;
            }
            field(CODChrgsAC; CODChrgsAC)
            {
                ApplicationArea = ALL;
            }
            field(DefaultCusPostingGrp; DefaultCusPostingGrp)
            {
                ApplicationArea = ALL;
            }
            field(DefaultBusPostingGrp; DefaultBusPostingGrp)
            {
                ApplicationArea = ALL;
            }
            field(NoOfOrders; NoOfOrders)
            {
                ApplicationArea = ALL;
            }
            field(MinNoOfOrders; MinNoOfOrders)
            {
                ApplicationArea = ALL;
            }
            field(BatchNoSeries; BatchNoSeries)
            {
                ApplicationArea = ALL;
            }
            field(SplitOrderSeries; SplitOrderSeries)
            {
                ApplicationArea = ALL;
            }
            field(ICSOSeries; ICSOSeries)
            {
                ApplicationArea = ALL;
            }
            field(InterCompBin; InterCompBin)
            {
                ApplicationArea = ALL;
            }
            field(InterCompVendor; InterCompVendor)
            {
                ApplicationArea = ALL;
            }
            field(CombineChrgs; CombineChrgs)
            {
                ApplicationArea = ALL;
            }
            field(DefaultCODChrgs; DefaultCODChrgs)
            {
                ApplicationArea = ALL;
            }
            field(DefaultShippingChrgs; DefaultShippingChrgs)
            {
                ApplicationArea = ALL;
            }
            field(GiftChrgsAC; GiftChrgsAC)
            {
                ApplicationArea = ALL;
            }
            field(ManifestNos; ManifestNos)
            {
                ApplicationArea = ALL;
            }
            field("WhsIntegration API/URL"; "WhsIntegration API/URL")
            {
                ApplicationArea = ALL;
            }
            field(ShipLocLogicAsOrdfromCity; ShipLocLogicAsOrdfromCity)
            {
                ApplicationArea = ALL;
            }
            field(MegentoUrl; MegentoUrl)
            {
                ApplicationArea = ALL;
            }
            field(OMS_Stock; OMS_Stock)
            {
                ApplicationArea = ALL;
            }
            field(CompName; CompName)
            {
                ApplicationArea = ALL;
            }
            field(DefaultItemGroup; DefaultItemGroup)
            {
                ApplicationArea = All;
            }
            field(UserwisePrinter; UserwisePrinter)
            {
                ApplicationArea = all;
            }
            field(PrintOnlyCompletedOrd; PrintOnlyCompletedOrd)
            {
                ApplicationArea = all;
            }
            field(NoOfAttempt; NoOfAttempt)
            {
                ApplicationArea = all;
            }
            field(MultipleLocations; MultipleLocations)
            {
                ApplicationArea = all;
            }
            field(Locations; Locations)
            {
                ApplicationArea = All;
            }
            field(NoOfRecorstoSync; NoOfRecorstoSync)
            {
                ApplicationArea = All;
            }
            field(CheckPendingorderSync; CheckPendingorderSync)
            {
                ApplicationArea = all;
            }
            field(AWBSendPostSync; AWBSendPostSync)
            {
                ApplicationArea = All;
            }
            field(JobQueueID; JobQueueID)
            {
                ApplicationArea = All;
            }
            field(EnableOrderTransfers; EnableOrderTransfers)
            {
                ApplicationArea = All;
            }
            field(EnablePromotionDate; EnablePromotionDate)
            {
                ApplicationArea = All;
                Caption = 'Enable Promotions with EndDate';
            }
            field(FilterStatus; FilterStatus)
            {
                ApplicationArea = All;
            }
            field(EnableGLDirectPosting; EnableGLDirectPosting)
            {
                ApplicationArea = All;
            }
            field(SalesReturnsLocation; SalesReturnsLocation)
            {
                ApplicationArea = All;
            }
            field(OrderDateFilter; OrderDateFilter)
            {
                ApplicationArea = all;
            }
            field(datetimeFilter; datetimeFilter)
            {
                ApplicationArea = aLL;
            }
            field(CheckLocation; CheckLocation)
            {
                ApplicationArea = all;
            }


        }
        addafter(General)
        {
            group("CHECK Setups")
            {
                field(EnableUserTemplates; EnableUserTemplates)
                {
                    ApplicationArea = All;
                }
                field(PutawayB2BAllocation; PutawayB2BAllocation)
                {
                    ApplicationArea = All;
                }
                field(FilterRemark; FilterRemark)
                {
                    ApplicationArea = All;
                }
                field(CheckOrderTracking; CheckOrderTracking)
                {
                    ApplicationArea = All;
                }
                field(EnableBulkRcpt; EnableBulkRcpt)
                {
                    ApplicationArea = All;
                }
                field(ReleaseSO; ReleaseSO)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    actions
    {
    }
}
