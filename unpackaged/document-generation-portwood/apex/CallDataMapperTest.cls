@IsTest
private class CallDataMapperTest {

    private static String individualApplicationId;

    static void setup() {
        individualApplicationId = DocGenTestSetup.createTestData();
    }

    private static CallDataMapper.FlowInput makeInput(Id recordId) {
        CallDataMapper.FlowInput input = new CallDataMapper.FlowInput();
        input.dataMapperName = 'AdmissionsExtract';
        input.recordId = recordId;
        return input;
    }

    @IsTest(SeeAllData=true)
    static void testGenerateAdmit() {
        DocGenTestSetup.applicationDecision = 'Admit';
        setup();

        Test.startTest();
        List<CallDataMapper.FlowOutput> outputs = CallDataMapper.generate(
            new List<CallDataMapper.FlowInput>{ makeInput(individualApplicationId) }
        );
        Test.stopTest();

        Assert.areEqual(1, outputs.size());
        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(outputs[0].responseDataJson);
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

    @IsTest(SeeAllData=true)
    static void testGenerateDeny() {
        DocGenTestSetup.applicationDecision = 'Deny';
        setup();

        Test.startTest();
        List<CallDataMapper.FlowOutput> outputs = CallDataMapper.generate(
            new List<CallDataMapper.FlowInput>{ makeInput(individualApplicationId) }
        );
        Test.stopTest();

        Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(outputs[0].responseDataJson);
        Assert.isFalse((Boolean)result.get('isAccepted'));
        Assert.isTrue((Boolean)result.get('isRejected'));
    }

    @IsTest(SeeAllData=true)
    static void testGenerateWithInvalidRecordId() {
        Test.startTest();
        List<CallDataMapper.FlowOutput> outputs = CallDataMapper.generate(
            new List<CallDataMapper.FlowInput>{ makeInput('0iTO00000000xxxAAA') }
        );
        Test.stopTest();
        
        Assert.areEqual(1, outputs.size());
        Assert.isTrue(String.isNotBlank(outputs[0].responseDataJson));
    }

    @IsTest(SeeAllData=true)
    static void testGenerateBulkInputs() {
        setup();

        Test.startTest();
        List<CallDataMapper.FlowOutput> outputs = CallDataMapper.generate(
            new List<CallDataMapper.FlowInput>{ makeInput(individualApplicationId), makeInput(individualApplicationId) }
        );
        Test.stopTest();

        Assert.areEqual(2, outputs.size());
        for (CallDataMapper.FlowOutput output : outputs) {
            Assert.isTrue(String.isNotBlank(output.responseDataJson));
        }
    }

    @IsTest(SeeAllData=true)
    static void testGenerateWithAdditionalInput() {
        setup();

        CallDataMapper.FlowInput input = makeInput(individualApplicationId);
        input.additionalInputJson = '{"additionalProperty": "testValue"}';

        Test.startTest();
        List<CallDataMapper.FlowOutput> outputs = CallDataMapper.generate(
            new List<CallDataMapper.FlowInput>{ input }
        );
        Test.stopTest();

        Assert.areEqual(1, outputs.size());
        Assert.isTrue(String.isNotBlank(outputs[0].responseDataJson));
    }
}
