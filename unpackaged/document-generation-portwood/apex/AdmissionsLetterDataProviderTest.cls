@IsTest
private class AdmissionsLetterDataProviderTest {

    private static String individualApplicationId;

    static void setup() {
        individualApplicationId = DocGenTestSetup.createTestData();
    }

    @IsTest
    static void testGetDataAdmit() {
        DocGenTestSetup.applicationDecision = 'Admit';
        setup();
        
        Test.startTest();
        Map<String, Object> result = new AdmissionsLetterDataProvider().getData(individualApplicationId);
        Test.stopTest();

        Assert.isNotNull(result.get('date'));
        Assert.areEqual('Jane Doe', result.get('studentName'));
        Assert.areEqual('Doe', result.get('lastName'));
        Assert.areEqual('Ms.', result.get('salutation'));
        Assert.areEqual('123 Main St', result.get('streetAddress'));
        Assert.areEqual('Springfield, IL 62701', result.get('cityStateZip'));
        Assert.areEqual('Bachelor of Science in Computer Science', result.get('programName'));
        Assert.areEqual('Fall 2025', result.get('startTerm'));
        Assert.isNotNull(result.get('enrollmentDeadline'));
        Assert.isTrue((Boolean)result.get('isAccepted'));
        Assert.isFalse((Boolean)result.get('isRejected'));
        Assert.areEqual(UserInfo.getName(), result.get('signatoryName'));
        Assert.areEqual('Adam Advisor', result.get('counselorName'));
        Assert.areEqual('adam@connecteduniversity.edu', result.get('counselorEmail'));
    }

    @IsTest
    static void testGetDataDeny() {
        DocGenTestSetup.applicationDecision = 'Deny';
        setup();

        Test.startTest();
        Map<String, Object> result = new AdmissionsLetterDataProvider().getData(individualApplicationId);
        Test.stopTest();

        Assert.isFalse((Boolean)result.get('isAccepted'));
        Assert.isTrue((Boolean)result.get('isRejected'));
    }

    @IsTest
    static void testGetDataNoDecision() {
        DocGenTestSetup.applicationDecision = null;
        setup();

        Test.startTest();
        Map<String, Object> result = new AdmissionsLetterDataProvider().getData(individualApplicationId);
        Test.stopTest();

        Assert.isFalse((Boolean)result.get('isAccepted'));
        Assert.isFalse((Boolean)result.get('isRejected'));
    }

    @IsTest
    static void testGetDataWithInvalidRecordId() {
        Test.startTest();
        Map<String, Object> result = new AdmissionsLetterDataProvider().getData('0iTO00000000xxxAAA');
        Test.stopTest();

        Assert.isFalse((Boolean)result.get('isAccepted'));
        Assert.isFalse((Boolean)result.get('isRejected'));
    }

    @IsTest
    static void testGetFieldNames() {
        List<String> fields = new AdmissionsLetterDataProvider().getFieldNames();

        Set<String> expected = new Set<String>{
            'date', 'studentName', 'streetAddress', 'cityStateZip', 'salutation',
            'lastName', 'isAccepted', 'isRejected', 'programName', 'startTerm',
            'enrollmentDeadline', 'counselorName', 'counselorEmail',
            'signatoryName', 'signatoryTitle'
        };
        Assert.areEqual(expected.size(), fields.size());
        Assert.isTrue(new Set<String>(fields).containsAll(expected));
    }
}
