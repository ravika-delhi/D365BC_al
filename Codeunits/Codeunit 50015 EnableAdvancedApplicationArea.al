codeunit 50015 EnableAdvancedApplicationArea
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnGetEssentialExperienceAppAreas', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnGetEssentialExperienceAppAreas(var TempApplicationAreaSetup: record 9178 temporary)
    begin
        TempApplicationAreaSetup.Advanced := true
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnGetPremiumExperienceAppAreas', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnGetPremiumExperienceAppAreas(var TempApplicationAreaSetup: record 9178 temporary)
    begin
        TempApplicationAreaSetup.Advanced := true
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Application Area Mgmt. Facade", 'OnSetExperienceTier', '', false, false)]
    local procedure EnableAdvancedApplicationAreaOnSetExperienceTier(ExperienceTierSetup: record 9176; var TempApplicationAreaSetup: record 9178 temporary; var ApplicationAreasSet: boolean)
    begin
        TempApplicationAreaSetup.Advanced := true
    end;
}
