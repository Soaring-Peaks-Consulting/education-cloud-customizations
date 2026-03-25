List<ApplicationStageDefinition> profileStageDef = [
    SELECT Id
    FROM ApplicationStageDefinition
    WHERE Name = 'Profile'
];

if (profileStageDef.isEmpty()) {
    throw new MissingDataException('Required ApplicationStageDefinition "Profile" not found. Please ensure sample data is loaded.');
}

ActionPlanTemplate apt = new ActionPlanTemplate(
    Name = 'Undergraduate Application',
    ActionPlanType = 'Industries',
    TargetEntityType = 'PreliminaryApplicationRef'
);
insert apt;

List<ActionPlanTemplateVersion> aptv = [SELECT Id FROM ActionPlanTemplateVersion WHERE ActionPlanTemplateId = :apt.Id];

if (aptv.isEmpty()) {
    throw new MissingDataException('Required ActionPlanTemplateVersion not found.');
}

ActionPlanTemplateItem apti = new ActionPlanTemplateItem(
    Name = 'Profile',
    ActionPlanTemplateVersionId = aptv.get(0).Id,
    DisplayOrder = 1,
    IsActive = true,
    IsRequired = true,
    ItemEntityType = 'IndividualApplicationTask'
);
insert apti;

List<ActionPlanTemplateItemValue> itemValues = new List<ActionPlanTemplateItemValue>{
    new ActionPlanTemplateItemValue(
        Name = 'Name',
        ActionPlanTemplateItemId = apti.Id,
        IsActive = true,
        ItemEntityFieldName = 'IndividualApplicationTask.Name',
        ValueLiteral = 'Profile'
    ),
    new ActionPlanTemplateItemValue(
        Name = 'ApplicationStageDefinitionId',
        ActionPlanTemplateItemId = apti.Id,
        IsActive = true,
        ItemEntityFieldName = 'IndividualApplicationTask.ApplicationStageDefinitionId',
        ValueLiteral = profileStageDef.get(0).Id
    )
};
insert itemValues;

List<ProgramTermApplnTimeline> ptats = [SELECT Id FROM ProgramTermApplnTimeline WHERE ActionPlanTemplateVersionId = null];
for (ProgramTermApplnTimeline ptatToUpdate : ptats) {
    ptatToUpdate.ActionPlanTemplateVersionId = aptv.get(0).Id;
}
update ptats;

public class MissingDataException extends Exception {}