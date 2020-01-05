pageextension 50079 Ex_CompInfo extends "Company Information"
{
    layout
    {
        addafter("Contact Person")
        {
            field("Arabic Packing Slip Note"; "Arabic Packing Slip Note")
            {
                ApplicationArea = All;
            }
            field(InboundImage; InboundImage)
            {
                ApplicationArea = All;
            }
            field("Seller help email"; "Seller help email")
            {
                ApplicationArea = all;
            }
            field(MultipleLocations; MultipleLocations)
            {
                ApplicationArea = All;
            }
            field(WHSLocation1; WHSLocation1)
            {
                ApplicationArea = All;
            }
            field(WHSLocation2; WHSLocation2)
            {
                ApplicationArea = All;
            }
            field(WHSLocation3; WHSLocation3)
            {
                ApplicationArea = All;
            }
            field(VATApplication; VATApplication)
            {
                ApplicationArea = aLL;
            }
            field(InboundVAT; InboundVAT)
            {
                ApplicationArea = aLL;
            }
            field(OutboundVAT; OutboundVAT)
            {
                ApplicationArea = aLL;
            }





        }
    }
    actions
    {
    }
    var
        myInt: Integer;
}
