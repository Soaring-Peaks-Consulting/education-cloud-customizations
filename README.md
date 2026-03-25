# Education Cloud Customizations

Various Education Cloud customizations that help Education Cloud consultants, developers, and customers use Education Cloud to its full potential in scratch orgs and other development environments.

## Deployment

To deploy these customizations in a scratch org:

1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
1. Run `cci flow run dev_org --org dev`. (Note: replace `dev_org` with `dev_org_with_community` to include a default Education Cloud community.)
1. Run `cci org browser dev` to open the org in your browser.

Don't want one of the configuration tasks to run? Modify the `deploy_education_cloud_customizations` steps locally and remove the task(s) that shouldn't be executed.

## Custom Flows & Tasks Reference

### Custom Flows
#### `deploy_education_cloud_customizations`
Assigns the necessary permission sets to the running user and deploys various metadata components including record types and account settings. Also deploys a quickstart for appointment scheduling in Education Cloud, sets org-wide sharing settings for the relevant Education Cloud objects, and inserts sample data.
1. task: `assign_permission_sets` - assigns the EducationCloudAccess and OmniStudioExecution permission sets to the running user
1. task: [`deploy_account_record_types`](#deploy_account_record_types)
1. flow: [`deploy_appointments_quickstart`](#deploy_appointments_quickstart)
1. task: [`deploy_case_record_types`](#deploy_case_record_types)
1. task: [`deploy_individual_application_record_types`](#deploy_individual_application_record_types)
1. task: [`deploy_learning_achievement_record_types`](#deploy_learning_achievement_record_types)
1. task: [`deploy_custom_report_types`](#deploy_custom_report_types)
1. task: [`set_education_cloud_objects_org_wide_defaults`](#set_education_cloud_objects_org_wide_defaults)
1. task: `update_admin_profile` - enables the new record types for the System Administrator profile
1. flow: [`insert_sample_data`](#insert_sample_data)

#### `deploy_appointments_quickstart`
Deploys basic setup for appointment scheduling in Education Cloud, as well as Public Read Only org-wide sharing settings for the relevant objects.
1. task: [`deploy_appointments_quickstart`](#deploy_appointments_quickstart-1)
1. task: [`set_education_cloud_appointment_objects_org_wide_defaults`](#set_education_cloud_appointment_objects_org_wide_defaults)
1. task: `add_page_layout_related_lists` - adds Shift Work Topics related list to the Shift page layout
1. task: `add_page_layout_related_lists` - adds Shift Engagement Channels related list to the Shift page layout

#### `insert_sample_data`
Inserts sample data for testing and demonstration purposes.
1. task: `snowfakery` - inserts records from the recipe files in the `datasets/sample-data` directory
1. task: `execute_anon` - inserts an "Undergraduate Application" Action Plan Template and associates it with the sample Program Term Application Timeline records

#### `setup_education_cloud_community`
Creates and publishes a community using the Education Portal template and inserts sample data, including prospective student and current student community users.
1. task: `execute_anon` - creates a "President" user role and assigns the running user to the role
1. task: `create_community` - creates the "Connected University Student Portal" community
1. task: `publish_community` - publishes the "Connected University Student Portal" community
1. task: `create_network_member_groups` - assigns the Customer Community Plus User profile to the community
1. task: [`deploy_community_permissions`](#deploy_community_permissions)
1. task: [`deploy_community_flows`](#deploy_community_flows)
1. task: `snowfakery` - inserts records from the recipe files in the `datasets/community-sample-data` directory

**Important Notes:** There are additional manual steps required before a community user can create and access certain portal features. For example, in order to successfully create an application:
1. Update the sharing settings for `Action Plan Templates` to Read Only for both internal and external users.
1. Navigate to the `Action Plan Templates` list view and manually Publish all records.
1. In the Experience Builder for the "Connected University Student Portal" community, update the "Individual Application Task Detail" page. Set the Omni Viewer properties to use `{!recordId}` for the Record ID and `OmniScript` for the Render Method Type, and Publish your changes.

### Custom Tasks
#### `deploy_account_record_types`
Deploys standard Account record types (College) for Education Cloud.
#### `deploy_appointments_quickstart`
Deploys basic setup for appointment scheduling in Education Cloud.
#### `deploy_case_record_types`
Deploys standard Case record types (Academic) for Education Cloud, as well as the business processes.
#### `deploy_custom_report_types`
Deploys custom report types for Education Cloud.
#### `deploy_individual_application_record_types`
Deploys standard Individual Application record types (Admissions) for Education Cloud, as well as the Application Record Type Config.
#### `deploy_learning_achievement_record_types`
Deploys standard Learning Achievement record types (Learning Course, Learning Program, and Achievement Group) for Education Cloud, as well as the Learning Achievement Config.
#### `set_education_cloud_appointment_objects_org_wide_defaults`
Updates the organization-wide sharing settings for the objects related to appointment scheduling in Education Cloud.
#### `set_education_cloud_objects_org_wide_defaults`
Updates the organization-wide sharing settings for the relevant Education Cloud objects.
#### `deploy_community_permissions`
Deploys sharing settings and a permission set for the Connected University Student Portal.
#### `deploy_community_flows`
Deploys flows for the Connected University Student Portal, including a flow to automatically create Contact Profile records.