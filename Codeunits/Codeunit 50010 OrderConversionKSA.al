codeunit 50010 OrderConversionKSA
{
    trigger OnRun()
    begin
        salesSetup.get;
        Report.Run(50011, false, false);
        Sleep(1000);
        commit;

        IF salesSetup.CheckLocation then
            /*Report.RunModal(50081, false, false);
            Sleep(1000);
            commit;*/
            REPORT.RunModal(50020, false, false);
        Sleep(1000);
        Commit;

        REPORT.RunModal(50019, false, false);
        Sleep(1000);
        Commit;
        REPORT.RunModal(50018, false, false);
        sleep(1000);
        Commit;
        REPORT.RunModal(50079, false, false);
        Sleep(1000);
        Commit;
    end;

    var
        myInt: Integer;
        salesSetup: Record "Sales & Receivables Setup";
}