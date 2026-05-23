# Education Cloud Customizations

Various Education Cloud customizations, configuration, and sample data that help consultants, developers, and customers quickly setup Education Cloud in scratch orgs and other development environments.

## Deployment

To deploy these customizations in a scratch org:

1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
1. Run `cci flow run dev_org --org dev`. (Note: replace `dev_org` with `dev_org_with_community` to include a default Education Cloud community.)
1. Run `cci org browser dev` to open the org in your browser.

Don't want one of the configuration tasks to run? Modify the `deploy_education_cloud_customizations` steps locally and remove the task(s) that shouldn't be executed.

## Demo Video
[![Demo Video](https://img.youtube.com/vi/XzDTpzfNMOU/0.jpg)](https://www.youtube.com/watch?v=XzDTpzfNMOU)

## Custom Flows Reference
### `deploy_education_cloud_customizations`
Assigns the necessary permission sets to the running user and deploys various metadata components including record types and account settings. Also deploys configuration for appointment scheduling in Education Cloud, sets org-wide sharing settings for the relevant Education Cloud objects, and inserts sample data.
1. task: `assign_permission_sets` - assigns the EducationCloudAccess and OmniStudioExecution permission sets to the running user
1. task: [`deploy_account_record_types`](#deploy_account_record_types)
1. flow: [`deploy_appointments_configuration`](#deploy_appointments_configuration)
1. task: [`deploy_case_record_types`](#deploy_case_record_types)
1. task: [`deploy_individual_application_record_types`](#deploy_individual_application_record_types)
1. task: [`deploy_learning_achievement_record_types`](#deploy_learning_achievement_record_types)
1. task: [`set_education_cloud_objects_org_wide_defaults`](#set_education_cloud_objects_org_wide_defaults)
1. task: `update_admin_profile` - enables the new record types for the System Administrator profile
1. flow: [`insert_sample_data`](#insert_sample_data)

---

### `deploy_appointments_configuration`
Deploys basic setup for appointment scheduling in Education Cloud, as well as Public Read Only org-wide sharing settings for the relevant objects.
1. task: [`deploy_appointments_configuration`](#deploy_appointments_configuration-1)
1. task: [`set_education_cloud_appointment_objects_org_wide_defaults`](#set_education_cloud_appointment_objects_org_wide_defaults)
1. task: `add_page_layout_related_lists` - adds Shift Work Topics related list to the Shift page layout
1. task: `add_page_layout_related_lists` - adds Shift Engagement Channels related list to the Shift page layout

---

### `insert_sample_data`
Inserts sample data for testing and demonstration purposes.
1. task: `snowfakery` - inserts records from the recipe files in the `datasets/sample-data` directory
1. task: `execute_anon` - inserts an "Undergraduate Application" Action Plan Template and associates it with the sample Program Term Application Timeline records

---

### `setup_education_cloud_community`
Creates and publishes a community using the Education Portal template and inserts sample data, including prospective student and current student community users.
1. task: `execute_anon` - creates a "President" user role and assigns the running user to the role
1. task: `create_community` - creates the "Connected University Student Portal" community
1. task: `publish_community` - publishes the "Connected University Student Portal" community
1. task: `create_network_member_groups` - assigns the Customer Community Plus User profile to the community
1. task: [`deploy_community_permissions`](#deploy_community_permissions)
1. task: [`deploy_community_flows`](#deploy_community_flows)
1. task: `snowfakery` - inserts records from the recipe files in the `datasets/community-sample-data` directory

**Important Notes:** There are additional manual steps required before a community user can create and access certain portal features. For example, in order to successfully create an application:
1. In Setup --> Sharing Settings, update the sharing settings for `Action Plan Templates` to Read Only for both internal and external users.
1. Navigate to the `Action Plan Templates` list view and manually Publish all records.
1. In the Experience Builder for the "Connected University Student Portal" community, update the "Individual Application Task Detail" page. Set the Omni Viewer properties to use `{!recordId}` for the Record ID and `OmniScript` for the Render Method Type, and Publish your changes.

---

### `configure_salesforce_document_generation`
Deploys the necessary components for Salesforce Document Generation to work in the org, including example templates and flows. The flows fire when a new Application Decision record is created or updated with an Application Decision of "Admit" or "Deny". The flows generate both a DOCX and PDF document. One templates is configured to query for the data via the AdmissionsExtract and AdmissionsTransform OmniStudio Data Mappers and the other template queries for the data via the Admissions Context Service.
1. task: `assign_permission_sets` - assigns the DocGenDesigner and DocGenUser permission sets to the running user
1. task: [`deploy_document_generation_components`](#deploy_document_generation_components)
1. task: `add_page_layout_related_lists` - adds Files related list to the Individual Application page layout

**Important Notes:** There are additional manual steps required before document generation with Salesforce Document Generation will work. In order to test the provided example:
1. In Setup --> Document Generation --> General Settings, enable the `Design Document Templates in Salesforce` setting.
1. Navigate to `Design Document Template` and activate Version 1 of the included `Admissions` and `AdmissionsUsingContextService` templates. (Before activating the `AdmissionsUsingContextService` template, set the Context Transformation Name picklist to `AdmissionsTransform`, as it is currently not automatically set.)
1. Navigate to `Individual Applications` and create a new application record for a learner account (for example, Sophia Student).
1. On the Related tab for the new record, create an `Application Decision` record and set the Application Decision to either "Admit" or "Deny".
1. Refresh the page to view the updated Files related list.

---

### `configure_portwood_docgen_integration`
Installs the Portwood DocGen managed package and deploys the necessary components for it to work in the org, including an example flow. The flow fires when a new Application Decision record is created or updated with an Application Decision of "Admit" or "Deny". The flow calls the managed package to generate both a DOCX and PDF document. The provided templates are configured to query for the data via the custom AdmissionsLetterDataProvider Apex class. The flow also generates a DOCX document after calling the custom CallDataMapper Apex class to query for the data via the AdmissionsExtract OmniStudio Data Mapper, demonstrating that it is possible to use the managed package in conjunction with OmniStudio.
1. task `install_managed` - installs the Portwood DocGen managed package
1. task: `assign_permission_sets` - assigns the DocGen_Admin permission set to the running user
1. task: [`deploy_portwood_docgen_components`](#deploy_portwood_docgen_components)
1. task: `add_page_layout_related_lists` - adds Files related list to the Individual Application page layout

**Important Notes:** There are additional manual steps required before document generation with the Portwood DocGen managed package will work. In order to test the provided example:
1. Navigate to the `DocGen` application and click on "Your Templates" from the Template Library.
1. Click the "Import Template" button and upload the `Admissions_-_DOCX.docgen.json` JSON file. Do the same for the `Admissions_-_PDF.docgen.json` JSON file.
1. Navigate to `Individual Applications` and create a new application record for a learner account (for example, Sophia Student).
1. On the Related tab for the new record, create an `Application Decision` record and set the Application Decision to either "Admit" or "Deny".
1. Refresh the page to view the updated Files related list.

## Custom Tasks Reference
### `deploy_account_record_types`
Deploys standard Account record types (College) for Education Cloud.

---

### `deploy_appointments_configuration`
Deploys basic setup for appointment scheduling in Education Cloud.

---

### `deploy_case_record_types`
Deploys standard Case record types (Academic) for Education Cloud, as well as the business processes.

---

### `deploy_individual_application_record_types`
Deploys standard Individual Application record types (Admissions) for Education Cloud, as well as the Application Record Type Config.

---

### `deploy_learning_achievement_record_types`
Deploys standard Learning Achievement record types (Learning Course, Learning Program, and Achievement Group) for Education Cloud, as well as the Learning Achievement Config.

---

### `set_education_cloud_appointment_objects_org_wide_defaults`
Updates the organization-wide sharing settings for the objects related to appointment scheduling in Education Cloud.

---

### `set_education_cloud_objects_org_wide_defaults`
Updates the organization-wide sharing settings for the relevant Education Cloud objects.

---

### `deploy_community_permissions`
Deploys sharing settings and a permission set for the Connected University Student Portal.

---

### `deploy_community_flows`
Deploys flows for the Connected University Student Portal, including a flow to automatically create Contact Profile records.

---

### `deploy_document_generation_components`
Deploys the necessary components for Salesforce Document Generation to work in the org, including example templates and flows.

---

### `deploy_portwood_docgen_components`
Deploys the necessary components for the Portwood DocGen managed package to work in the org, including example templates and flows.