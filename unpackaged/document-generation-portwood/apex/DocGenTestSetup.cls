@IsTest
public class DocGenTestSetup {

    public static String applicationDecision = 'Admit';

    public static String createTestData() {
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Disable_Flow_Automations' LIMIT 1];
        insert new PermissionSetAssignment(AssigneeId = UserInfo.getUserId(), PermissionSetId = ps.Id);

        String individualApplicationId;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            AcademicYear ay = new AcademicYear(Name = '2025-2026 Academic Year', Year = '2025');
            insert ay;

            AcademicTerm term = new AcademicTerm(
                Name = 'Fall 2025',
                AcademicYearId = ay.Id,
                StartDate = Date.newInstance(2025, 8, 19),
                EndDate = Date.newInstance(2025, 12, 13),
                Season = 'Fall',
                IsActive = true,
                RegistrationCloseDate = Date.newInstance(2025, 9, 15)
            );
            insert term;

            Learning learning = new Learning(
                Name = 'Bachelor of Science in Computer Science',
                Type = 'LearningProgram',
                IsActive = true
            );
            insert learning;

            LearningProgram program = new LearningProgram(
                Name = 'Bachelor of Science in Computer Science',
                LearningId = learning.Id,
                IsTopLevelProgram = true
            );
            insert program;

            ApplicationTimeline timeline = new ApplicationTimeline(
                Name = '2025-2026',
                Type = 'Admissions',
                ApplicationOpenDate = Date.newInstance(2025, 8, 1),
                ApplicationCloseDate = Date.newInstance(2026, 7, 31)
            );
            insert timeline;

            ProgramTermApplnTimeline ptat = new ProgramTermApplnTimeline(
                AcademicTermId = term.Id,
                ApplicationTimelineId = timeline.Id,
                LearningProgramId = program.Id
            );
            insert ptat;

            RecordType personAccountRT = [
                SELECT Id FROM RecordType
                WHERE SObjectType = 'Account' AND DeveloperName = 'PersonAccount'
                LIMIT 1
            ];
            Account acc = new Account(
                RecordTypeId = personAccountRT.Id,
                FirstName = 'Jane',
                LastName = 'Doe',
                Salutation = 'Ms.',
                PersonMailingStreet = '123 Main St',
                PersonMailingCity = 'Springfield',
                PersonMailingState = 'IL',
                PersonMailingPostalCode = '62701'
            );
            insert acc;

            IndividualApplication app = new IndividualApplication(
                AccountId = acc.Id,
                ProgramTermApplnTimelineId = ptat.Id,
                Category = 'Education'
            );
            insert app;
            individualApplicationId = app.Id;

            insert new ApplicationDecision(
                ApplicationId = app.Id,
                ApplicationDecision = applicationDecision,
                DecisionAuthorityId = UserInfo.getUserId()
            );
        }

        return individualApplicationId;
    }
}
