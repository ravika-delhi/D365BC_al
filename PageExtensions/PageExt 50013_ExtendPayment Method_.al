pageextension 50013 "ExtendPayment Method" extends "Payment Methods"
{
    layout
    {
        addafter(Description)
        {
            field(COD; COD)
            {
                ApplicationArea = ALL;
            }
            field(Prepaid; Prepaid)
            {
                ApplicationArea = ALL;
            }
            field(GLAccountNo; GLAccountNo)
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
    }
}
