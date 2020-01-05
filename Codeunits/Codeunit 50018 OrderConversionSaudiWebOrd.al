codeunit 50018 OrderConversionSaudiWebOrd
{
    trigger OnRun()
    begin
        REPORT.RunModal(50043, false, false);
        Sleep(1000);
        Commit;
        REPORT.RunModal(50042, false, false);
        Sleep(1000);
        Commit;
        REPORT.RunModal(50041, false, false);
        Commit;
        REPORT.RunModal(50079, false, false);
        Commit;
    end;

    var
        myInt: Integer;
}