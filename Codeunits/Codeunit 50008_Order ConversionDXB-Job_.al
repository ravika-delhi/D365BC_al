codeunit 50008 "Order ConversionDXB-Job"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        REPORT.RunModal(50011, false, false);
        Sleep(1000);
        Commit;

        REPORT.RunModal(50152, false, false);
        Commit;
        Sleep(1000);
        REPORT.RunModal(50157, false, false);
        Commit;
        Sleep(1000);
        REPORT.RunModal(50116, false, false);
        Commit;
        Sleep(1000);
        CODEUNIT.Run(50025, Rec);
        Commit;
        Sleep(1000);
        REPORT.RunModal(50154, false, false);
        Commit;
    end;
}
