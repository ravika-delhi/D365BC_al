pageextension 50030 ExtJobQueueEntryList extends "Job Queue Entries"
{
    layout
    {
        addafter("Earliest Start Date/Time")
        {

            field(IsReadyToStart; IsReadyToStart)
            {
                ApplicationArea = ALL;
            }
            field("Timeout (sec.)"; "Timeout (sec.)")
            {
                ApplicationArea = ALL;
            }
            field("Reference Starting Time"; "Reference Starting Time")
            {
                ApplicationArea = ALL;
            }
            field("Inactivity Timeout Period"; "Inactivity Timeout Period")
            {
                ApplicationArea = ALL;
            }
            field("System Task ID"; "System Task ID")
            {
                ApplicationArea = ALL;
            }

            field("Rerun Delay (sec.)"; "Rerun Delay (sec.)")
            {
                ApplicationArea = ALL;
            }
            field(ID; ID)
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