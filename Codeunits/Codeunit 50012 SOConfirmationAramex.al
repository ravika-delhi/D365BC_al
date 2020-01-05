codeunit 50012 SOConfirmationAramex
{
    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Order % synced Successfully';

    procedure SalesOrderConfir(SOConfirmation: XMLport SOConfimration)

    begin
        SOConfirmation.Import;

    end;
}
