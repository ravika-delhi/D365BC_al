pageextension 50010 ExtPurchExt extends "Purchases & Payables Setup"
{
    layout
    {
        addafter("Exact Cost Reversing Mandatory")
        {

            field(DefaultVatGrp; DefaultVatGrp)
            {
                ApplicationArea = All;
            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}