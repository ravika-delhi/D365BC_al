pageextension 50019 ExtGeneralLedgerEntries extends "General Ledger Entries"
{
    layout
    {
        addafter("Source Code")
        {
            field("Source No."; "Source No.")
            {
                ApplicationArea = All;
            }
            field(DocType; DocType)
            {
                ApplicationArea = All;
            }
            field(UploadBy; UploadBy)
            {
                ApplicationArea = All;
            }
            field("Document Date"; "Document Date")
            {
                ApplicationArea = all;
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