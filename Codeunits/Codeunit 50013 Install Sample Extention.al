codeunit 50013 "Install Example Extension"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        EnableApplicationArea: Codeunit EnableExampleExtension;
    begin
        if (EnableApplicationArea.IsExampleApplicationAreaEnabled()) then
            exit;

        EnableApplicationArea.EnableExampleExtension();
    end;
}
