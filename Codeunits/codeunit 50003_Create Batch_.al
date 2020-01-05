codeunit 50003 "Create Batch"
{
  TableNo = "Job Queue Entry";

  trigger OnRun()begin
    REPORT.RunModal(50151, false, false);
    Commit;
    Sleep(1000);
    CODEUNIT.Run(50151, Rec);
    Commit;
    Sleep(1000);
    REPORT.RunModal(50154, false, false);
  end;
}
