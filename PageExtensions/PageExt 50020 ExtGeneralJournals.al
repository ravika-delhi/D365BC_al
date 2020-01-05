pageextension 50020 ExtGeneralJournals extends "General Journal"
{
    layout
    {
        modify("Account Type")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Gen. Posting Type")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Document Date")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Bal. Account Type")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Bal. Account No.")
        {
            Visible = true;
            ApplicationArea = All;
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Bal. Gen. Posting Type")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("VAT Bus. Posting Group")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Document Type")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify(Amount)
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Amount (LCY)")
        {
            Visible = true;
            ApplicationArea = all;
        }
        modify("Bal. Account Name")
        {
            Visible = true;

        }
        addafter("Document Type")
        {
            field(DocType; DocType)
            {
                ApplicationArea = All;
            }
            field(Remarks; Remarks)
            {
                ApplicationArea = All;
            }

        }
        addafter("Currency Code")
        {
            field(UploadBy; UploadBy)
            {
                ApplicationArea = All;
            }
            field(UploadDateTime; UploadDateTime)
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