codeunit 50017 ResetJobQueue
{
    trigger OnRun()
    begin
        salesSetup.get();
        JobQueueEntry.Reset;
        JobQueueEntry.SetRange(JobQueueEntry."Object ID to Run", salesSetup.JobQueueID);
        IF JobQueueEntry.FindFirst() then begin
            JobQueueEntry.Status := JobQueueEntry.Status::"On Hold";
            JobQueueEntry.Modify();
        end;
    end;


    var
        JobQueueEntry: Record "Job Queue Entry";
        salesSetup: Record "Sales & Receivables Setup";
}