# gcp_vpc-[build](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build) , [change](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-change), [destory](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-destroy)

Build infrastructure
10min
|
Terraform
Terraform

Reference this often? Create an account to bookmark tutorials.

With Terraform installed, you are ready to create some infrastructure.

You will build infrastructure on Google Cloud Platform (GCP) for this tutorial, but Terraform can manage a wide variety of resources using providers. You can find more examples in the use cases section.

As you follow these tutorials, you will use Terraform to provision, update, and destroy a simple set of infrastructure using the sample configuration provided. The sample configuration provisions a network and a Linux virtual machine. You will also learn about remote backends, input and output variables, and how to configure resource dependencies. These are the building blocks for more complex configurations.

Warning

While everything provisioned in this tutorial should fall within GCP's free tier, if you provision resources outside of the free tier, you may be charged. We are not responsible for any charges you may incur.

Prerequisites
A Google Cloud Platform account. If you do not have a GCP account, create one now. This tutorial can be completed using only the services included in the GCP free tier

Terraform 0.15.3+ installed locally.

Google Cloud Shell
This tutorial is also available as an interactive tutorial within Google Cloud Shell. If you prefer, you can follow this tutorial in Google Cloud Shell.

Set up GCP
After creating your GCP account, create or modify the following resources to enable Terraform to provision your infrastructure:

A GCP Project: GCP organizes resources into projects. Create one now in the GCP console and make note of the project ID. You can see a list of your projects in the cloud resource manager.

Google Compute Engine: Enable Google Compute Engine for your project in the GCP console. Make sure to select the project you are using to follow this tutorial and click the "Enable" button.

A GCP service account key: Create a service account key to enable Terraform to access your GCP account. When creating the key, use the following settings:

Select the project you created in the previous step.
Click "Create Service Account".
Give it any name you like and click "Create".
For the Role, choose "Project -> Editor", then click "Continue".
Skip granting additional users access, and click "Done".
After you create your service account, download your service account key.

Select your service account from the list.
Select the "Keys" tab.
In the drop down menu, select "Create new key".
Leave the "Key Type" as JSON.
Click "Create" to create the key and save the key file to your system.
You can read more about service account keys in Google's documentation.

Warning

The service account key file provides access to your GCP project. It should be treated like any other secret credentials. Specifically, it should never be checked into source control.

Write configuration
The set of files used to describe infrastructure in Terraform is known as a Terraform configuration. You will now write your first configuration to create a network.

Each Terraform configuration must be in its own working directory. Create a directory for your configuration.

 mkdir learn-terraform-gcp
Copy
Change into the directory.

 cd learn-terraform-gcp
Copy
Terraform loads all files ending in .tf or .tf.json in the working directory. Create a main.tf file for your configuration.

 touch main.tf
Copy
Open main.tf in your text editor, and paste in the configuration below. Be sure to replace <NAME> with the path to the service account key file you downloaded and <PROJECT_ID> with your project's ID, and save the file.

terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("<NAME>.json")

  project = "<PROJECT_ID>"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}
Copy
This is a complete configuration that Terraform can apply. In the following sections you will review each block of the configuration in more detail.

Tip

To learn about other ways to authenticate the GCP provider, see the provider reference.

Terraform Block
The terraform {} block contains Terraform settings, including the required providers Terraform will use to provision your infrastructure. For each provider, the source attribute defines an optional hostname, a namespace, and the provider type. Terraform installs providers from the Terraform Registry by default. In this example configuration, the google provider's source is defined as hashicorp/google, which is shorthand for registry.terraform.io/hashicorp/google.

You can also define a version constraint for each provider in the required_providers block. The version attribute is optional, but we recommend using it to enforce the provider version. Without it, Terraform will always use the latest version of the provider, which may introduce breaking changes.

To learn more, reference the provider source documentation.

Providers
The provider block configures the specified provider, in this case google. A provider is a plugin that Terraform uses to create and manage your resources. You can define multiple provider blocks in a Terraform configuration to manage resources from different providers.

Resource
Use resource blocks to define components of your infrastructure. A resource might be a physical component such as a server, or it can be a logical resource such as a Heroku application.

Resource blocks have two strings before the block: the resource type and the resource name. In this example, the resource type is google_compute_network and the name is vpc_network. The prefix of the type maps to the name of the provider. In the example configuration, Terraform manages the google_compute_network resource with the google provider. Together, the resource type and resource name form a unique ID for the resource. For example, the ID for your network is google_compute_network.vpc_network.

Resource blocks contain arguments which you use to configure the resource. Arguments can include things like machine sizes, disk image names, or VPC IDs. The Terraform Registry GCP documentation page documents the required and optional arguments for each GCP resource. For example, you can read the google_compute_network documentation to view the resource's supported arguments and available attributes.

The GCP provider documents supported resources, including google_compute_network and its supported arguments.

Initialize the directory
When you create a new configuration — or check out an existing configuration from version control — you need to initialize the directory with terraform init. This step downloads the providers defined in the configuration.

Initialize the directory.

 terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/google versions matching "4.51.0"...
- Installing hashicorp/google v4.51.0...
- Installed hashicorp/google v4.51.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
Copy
Terraform downloads the google provider and installs it in a hidden subdirectory of your current working directory, named .terraform. The terraform init command prints the provider version Terraform installed. Terraform also creates a lock file named .terraform.lock.hcl, which specifies the exact provider versions used to ensure that every Terraform run is consistent. This also allows you to control when you want to upgrade the providers used in your configuration.

Format and validate the configuration
We recommend using consistent formatting in all of your configuration files. The terraform fmt command automatically updates configurations in the current directory for readability and consistency.

Format your configuration. Terraform will print out the names of the files it modified, if any. In this case, your configuration file was already formatted correctly, so Terraform won't return any file names.

 terraform fmt
Copy
You can also make sure your configuration is syntactically valid and internally consistent by using the terraform validate command.

Validate your configuration. The example configuration provided above is valid, so Terraform will return a success message.

 terraform validate
Success! The configuration is valid.
Copy
Create infrastructure
Apply the configuration now with the terraform apply command. Terraform will print output similar to what is shown below. We have truncated some of the output for brevity.

 terraform apply

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

   google_compute_network.vpc_network will be created
  + resource "google_compute_network" "vpc_network" {
      + auto_create_subnetworks         = true
      + delete_default_routes_on_create = false
      + gateway_ipv4                    = (known after apply)
      + id                              = (known after apply)
      + ipv4_range                      = (known after apply)
      + name                            = "terraform-network"
      + project                         = (known after apply)
      + routing_mode                    = (known after apply)
      + self_link                       = (known after apply)
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
Copy
Terraform will indicate what infrastructure changes it plans to make, and prompt for your approval before it makes those changes.

This output shows the execution plan, describing which actions Terraform will take in order to create infrastructure to match the configuration. The output format is similar to the diff format generated by tools such as Git. The output has a + next to resource "google_compute_network" "vpc_network", meaning that Terraform will create this resource. Beneath that, it shows the attributes that will be set. When the value displayed is (known after apply), it means that the value will not be known until the resource is created.

Terraform will now pause and wait for approval before proceeding. If anything in the plan seems incorrect or dangerous, it is safe to abort here with no changes made to your infrastructure.

In this case the plan looks acceptable, so type yes at the confirmation prompt to proceed. It may take a few minutes for Terraform to provision the network.

  Enter a value: yes

google_compute_network.vpc_network: Creating...
google_compute_network.vpc_network: Still creating... [10s elapsed]
google_compute_network.vpc_network: Still creating... [20s elapsed]
google_compute_network.vpc_network: Still creating... [30s elapsed]
google_compute_network.vpc_network: Creation complete after 38s [id=projects/testing-project/global/networks/terraform-network]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
You have now created infrastructure using Terraform! Visit the GCP console to see the network you provisioned. Make sure you are looking at the same region and project that you configured in the provider configuration.

Inspect state
When you applied your configuration, Terraform wrote data into a file called terraform.tfstate. Terraform stores the IDs and properties of the resources it manages in this file, so that it can update or destroy those resources going forward.

The Terraform state file is the only way Terraform can track which resources it manages, and often contains sensitive information, so you must store your state file securely and distribute it only to trusted team members who need to manage your infrastructure. In production, we recommend storing your state remotely with Terraform Cloud or Terraform Enterprise. Terraform also supports several other remote backends you can use to store and manage your state.

Inspect the current state using terraform show.

 terraform show
 google_compute_network.vpc_network:
resource "google_compute_network" "vpc_network" {
    auto_create_subnetworks         = true
    delete_default_routes_on_create = false
    id                              = "projects/testing-project/global/networks/terraform-network"
    name                            = "terraform-network"
    project                         = "testing-project"
    routing_mode                    = "REGIONAL"
    self_link                       = "https://www.googleapis.com/compute/v1/projects/testing-project/global/networks/terraform-network"
}
Copy
When Terraform created this network, it also gathered its metadata from the Google provider and recorded it in the state file. Later, you will modify your configuration to reference these values to configure other resources or outputs.
