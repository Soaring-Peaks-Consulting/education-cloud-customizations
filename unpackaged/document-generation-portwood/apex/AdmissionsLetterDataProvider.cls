global with sharing class AdmissionsLetterDataProvider implements portwoodglobal.DocGenDataProvider {

    global Map<String, Object> getData(Id recordId) {
        List<IndividualApplication> apps = [
            SELECT
                AcademicTerm,
                LearningProgram,
                ProgramTermApplnTimeline.AcademicTerm.RegistrationCloseDate,
                Account.Name,
                Account.LastName,
                Account.PersonMailingCity,
                Account.PersonMailingState,
                Account.PersonMailingStreet,
                Account.PersonMailingPostalCode,
                Account.Salutation,
                (
                    SELECT ApplicationDecision, DecisionAuthority.Name, DecisionAuthority.Title
                    FROM ApplicationDecisions
                    WHERE ApplicationDecision != null
                    ORDER BY LastModifiedDate DESC
                    LIMIT 1
                )
            FROM IndividualApplication
            WHERE Id = :recordId
        ];

        IndividualApplication app = apps.isEmpty() ? null : apps[0];
        List<SObject> decisions = app?.getSObjects('ApplicationDecisions');
        SObject decision = (decisions != null && !decisions.isEmpty()) ? decisions[0] : null;
        String decisionValue = decision != null ? (String) decision.get('ApplicationDecision') : null;
        SObject decisionAuthority = decision?.getSObject('DecisionAuthority');

        SObject timeline = app?.getSObject('ProgramTermApplnTimeline');
        SObject timelineAcademicTerm = timeline?.getSObject('AcademicTerm');
        DateTime registrationCloseDate = timelineAcademicTerm != null
            ? (DateTime) timelineAcademicTerm.get('RegistrationCloseDate')
            : null;

        return new Map<String, Object>{
            'date'               => Date.today().format(),
            'studentName'        => app?.Account?.Name,
            'streetAddress'      => app?.Account?.PersonMailingStreet,
            'cityStateZip'       => buildCityStateZip(app?.Account?.PersonMailingCity, app?.Account?.PersonMailingState, app?.Account?.PersonMailingPostalCode),
            'salutation'         => app?.Account?.Salutation,
            'lastName'           => app?.Account?.LastName,
            'isAccepted'         => decisionValue == 'Admit',
            'isRejected'         => decisionValue == 'Deny',
            'programName'        => app?.LearningProgram,
            'startTerm'          => app?.AcademicTerm,
            'enrollmentDeadline' => registrationCloseDate?.date().format(),
            'counselorName'      => 'Adam Advisor', // Placeholder
            'counselorEmail'     => 'adam@connecteduniversity.edu', // Placeholder
            'signatoryName'      => (String) decisionAuthority?.get('Name'),
            'signatoryTitle'     => (String) decisionAuthority?.get('Title')
        };
    }

    private static String buildCityStateZip(String city, String state, String zip) {
        if (String.isBlank(city) && String.isBlank(state) && String.isBlank(zip)) return null;
        String cityState = String.isBlank(city) || String.isBlank(state)
            ? (String.isNotBlank(city) ? city : state)
            : city + ', ' + state;
        if (String.isBlank(zip)) return cityState;
        if (String.isBlank(cityState)) return zip;
        return cityState + ' ' + zip;
    }

    global List<String> getFieldNames() {
        return new List<String>{
            'date',
            'studentName',
            'streetAddress',
            'cityStateZip',
            'salutation',
            'lastName',
            'isAccepted',
            'isRejected',
            'programName',
            'startTerm',
            'enrollmentDeadline',
            'counselorName',
            'counselorEmail',
            'signatoryName',
            'signatoryTitle'
        };
    }
}
