# Education Cloud Customizations

Various Education Cloud customizations that help Education Cloud consultants, developers, and customers use Education Cloud to its full potential in scratch orgs and other development environments.

## Deployment

To deploy these customizations in a scratch org:

1. [Set up CumulusCI](https://cumulusci.readthedocs.io/en/latest/tutorial.html)
2. Run `cci flow run dev_org --org dev`. (Note: replace `dev_org` with `dev_org_with_community` to include a default Education Cloud community.)
3. Run `cci org browser dev` to open the org in your browser.

Don't want one of the configuration tasks to run? Modify the `deploy_education_cloud_customizations` steps locally and remove the task(s) that shouldn't be executed.

## Custom Flows & Tasks Reference

### Custom Flows
#### `deploy_education_cloud_customizations`
Assigns the necessary permission sets to the running user and deploys various metadata components including record types, account settings, and custom report types. Also deploys a quickstart for appointment scheduling in Education Cloud, and sets org-wide sharing settings for the relevant Education Cloud objects.
1. task: `assign_permission_sets` - assigns the EducationCloudAccess and OmniStudioExecution permission sets to the running user
2. task: `deploy_account_record_types`
3. task: `deploy_account_settings`
4. flow: `deploy_appointments_quickstart`
5. task: `deploy_case_record_types`
6. task: `deploy_individual_application_record_types`
7. task: `deploy_custom_report_types`
8. task: `set_education_cloud_objects_org_wide_defaults`
9. task: `update_admin_profile` - enables the new record types for the System Administrator profile
10. task: `snowfakery` - inserts sample data

#### `deploy_appointments_quickstart`
Deploys basic setup for appointment scheduling in Education Cloud, as well as Public Read Only org-wide sharing settings for the relevant objects.
1. task: `deploy_appointments_quickstart`
2. task: `set_education_cloud_appointment_objects_org_wide_defaults`

#### `setup_education_cloud_community`
Creates and publishes a community using the Education Portal template.
1. task: `create_community`
2. task: `publish_community`

### Custom Tasks
#### `deploy_account_record_types`
Deploys standard Account record types (College) for Education Cloud.
#### `deploy_account_settings`
Enables relating contacts to multiple accounts.
#### `deploy_appointments_quickstart`
Deploys basic setup for appointment scheduling in Education Cloud.
#### `deploy_case_record_types`
Deploys standard Case record types (Academic) for Education Cloud, as well as the business processes.
#### `deploy_custom_report_types`
Deploys custom report types for Education Cloud.
#### `deploy_individual_application_record_types`
Deploys standard Individual Application record types (Admissions) for Education Cloud, as well as the Application Record Type Config.
#### `set_education_cloud_appointment_objects_org_wide_defaults`
Updates the organization-wide sharing settings for the objects related to appointment scheduling in Education Cloud.
#### `set_education_cloud_objects_org_wide_defaults`
Updates the organization-wide sharing settings for the relevant Education Cloud objects.