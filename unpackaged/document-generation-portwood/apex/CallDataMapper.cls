public with sharing class CallDataMapper {

    public class FlowInput {
        @InvocableVariable(label='Data Mapper Name' required=true)
        public String dataMapperName;

        @InvocableVariable(label='Record ID' required=true)
        public Id recordId;

        @InvocableVariable(label='Additional Input (JSON)')
        public String additionalInputJson;
    }

    public class FlowOutput {
        @InvocableVariable(label='Response Data (JSON)')
        public String responseDataJson;
    }

    @InvocableMethod(label='Call Data Mapper' description='Calls the specified data mapper with the given input.')
    public static List<FlowOutput> generate(List<FlowInput> inputs) {
        List<FlowOutput> outputs = new List<FlowOutput>();

        for (FlowInput input : inputs) {
            Map<String, Object> extractInput = new Map<String, Object>{
                'recordId' => String.valueOf(input.recordId)
            };
            if (String.isNotBlank(input.additionalInputJson)) {
                extractInput.putAll((Map<String, Object>) JSON.deserializeUntyped(input.additionalInputJson));
            }

            FlowOutput output = new FlowOutput();
            output.responseDataJson = JSON.serialize(callDataMapper(input.dataMapperName, extractInput));
            outputs.add(output);
        }

        return outputs;
    }

    private static Map<String, Object> callDataMapper(String bundleName, Map<String, Object> inputData) {
        ConnectApi.DataMapperExecuteInputRepresentation apexInput = new ConnectApi.DataMapperExecuteInputRepresentation();
        apexInput.dataMapperInput = new List<String>{ JSON.serialize(inputData) };
        apexInput.inputType = 'JSON';

        ConnectApi.DataMapperExecuteOptionsRepresentation options = new ConnectApi.DataMapperExecuteOptionsRepresentation();
        options.locale = null;
        options.shouldSendLegacyResponse = true;
        apexInput.options = options;

        ConnectApi.DataMapperExecuteOutputRepresentation dmOutput =
            ConnectApi.OmniDesignerConnect.executeDataMapper(bundleName, apexInput);

        if (dmOutput.response == null || dmOutput.response.isEmpty()) {
            return new Map<String, Object>();
        }

        Map<String, Object> outerMap = (Map<String, Object>) JSON.deserializeUntyped(dmOutput.response.get(0));
        Object responseData = outerMap.get('response');

        if (responseData instanceof Map<String, Object>) {
            return (Map<String, Object>) responseData;
        }
        if (responseData instanceof List<Object>) {
            List<Object> responseList = (List<Object>) responseData;
            if (!responseList.isEmpty() && responseList.get(0) instanceof Map<String, Object>) {
                return (Map<String, Object>) responseList.get(0);
            }
        }

        return new Map<String, Object>();
    }
}
