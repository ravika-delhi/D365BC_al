codeunit 50019 MyUpgradeCodeunit
{
  Subtype = Upgrade;

  trigger OnCheckPreconditionsPerDatabase();
  var myInfo: ModuleInfo;
  begin
    if NavApp.GetCurrentModuleInfo(myInfo)then if myInfo.DataVersion = Version.Create(1, 0, 0, 1)then error('The upgrade is not compatible');
  end;
  trigger OnUpgradePerCompany()begin
    NAVAPP.RESTOREARCHIVEDATA(50164);
    NavApp.RestoreArchiveData(50101);
    NavApp.RestoreArchiveData(50175);
  end;
  trigger OnValidateUpgradePerCompany()begin
  end;
}
