codeunit 50002 "Order Conversion-Job"
{
  TableNo = "Job Queue Entry";

  trigger OnRun()begin
    REPORT.RunModal(50009, false, false);
    Sleep(1000);
    Commit;
    REPORT.RunModal(50152, false, false);
    Commit;
    Sleep(1000);
    //REPORT.RUNMODAL(50002,FALSE,FALSE);
    //COMMIT;
    //SLEEP(1000);
    REPORT.RunModal(50157, false, false);
    Commit;
    Sleep(1000);
    REPORT.RunModal(50160, false, false);
    Commit;
    Sleep(1000);
    CODEUNIT.Run(50151, Rec);
    Commit;
    Sleep(1000);
    REPORT.RunModal(50154, false, false);
    Commit;
  //CODEUNIT.RUN(50016);
  //CLEARALL;
  end;
}
