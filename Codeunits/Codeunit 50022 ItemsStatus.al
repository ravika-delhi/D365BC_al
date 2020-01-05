codeunit 50022 ItemsStatus
{
    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'Canceled Items Synced Successfully';

    procedure ItemStatus(ItemStatus: XMLport "ItemStatus-Sync"): Code[1024]
    var
        DocNo: Code[50];
        OStream: OutStream;
        IStream: InStream;
    //TempBlob: Codeunit "Temp Blob";
    begin
        ItemStatus.Import;
        exit(StrSubstNo(Text001));
    end;
}
