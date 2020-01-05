codeunit 50027 "Batch Post Sales"
{
    trigger OnRun()
    begin
        REPORT.RunModal(50353, false, false);
        Sleep(1000);
        Commit;
        REPORT.RunModal(50107, false, false);
        Sleep(1000);
        Commit;

        REPORT.RunModal(50105, false, false);
        Sleep(1000);
        Commit;
    end;

    var
        myInt: Integer;
}