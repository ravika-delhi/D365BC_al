codeunit 50009 JobQueueSubs
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Queue Dispatcher", 'OnBeforeHandleRequest', '', true, true)]
    local procedure ResetGetShip(var JobQueueEntry: Record "Job Queue Entry")
    begin
        ExecuteBusinessLogic(JobQueueEntry);
    end;

    local procedure ExecuteBusinessLogic(JQEntry: Record "Job Queue Entry")
    var
        MyCodeCalledFromSubscriber: Codeunit JobQueueSubs;
    begin
        jobQueEnt.RESET;
        jobQueEnt.SetRange(Status, jobQueEnt.Status::Error);
        //jobQueEnt.SetRange("Object Type to Run", jobQueEnt."Object Type to Run"::Codeunit);
        //jobQueEnt.SetRange("Object ID to Run", 50172);
        IF jobQueEnt.FindFirst() then begin
            // jobQueEnt.Status := jobQueEnt.Status::Ready;
            jobQueEnt.Status := jobQueEnt.Status::Ready;
            jobQueEnt."Earliest Start Date/Time" := CurrentDateTime + 3 * 60000;
            jobQueEnt.modify;
        end;
        CheckJobs(JQEntry);
    end;

    var
        WhsActHdrs: Record "Warehouse Shipment Header";
        whsShpmtLine: Record "Warehouse Shipment Line";
        jobQueEnt: Record "Job Queue Entry";

    local procedure CheckJobs(JQEnt: Record "Job Queue Entry")
    var
        JobQueueEntr: Record "Job Queue Entry";
        JQE: Record "Job Queue Entry";
    begin
        JobQueueEntr.Reset;
        //JobQueueEntr.SetFilter(Status, '%1|%2', JobQueueEntr.Status::"In Process", JobQueueEntr.Status::Ready);
        JobQueueEntr.SetFilter(Status, '<>%1', JobQueueEntr.Status::"On Hold");
        JobQueueEntr.Setrange(Scheduled, False);
        IF JobQueueEntr.FindFirst then
            repeat
                IF (JobQueueEntr."Earliest Start Date/Time" < CurrentDateTime) then begin
                    JobQueueEntr.Status := JobQueueEntr.Status::Ready;

                    // JobQueueEntr.VALIDATE(Status, JobQueueEntr.Status::Ready);
                    JobQueueEntr."Earliest Start Date/Time" := CurrentDateTime + 3 * 60000;
                    JQE.Scheduled := TRUE;
                    JobQueueEntr.Restart();

                    JobQueueEntr.Modify;
                End;

            until JobQueueEntr.Next = 0;


    end;
}
