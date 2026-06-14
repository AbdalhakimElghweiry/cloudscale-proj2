# Project 2: Infrastructure as Code with Terraform and Azure ACI
# V2

**Course:** Cloud Computing & DevOps Engineering  
**Instructor:** M.Sc. Abdelhakim Rashid  
**Weight:** 15% of Final Grade  
**Due Date:** 13/06/2026

---

## 1. Authors

| # | Name |                 Student ID |
|---|------|                 ------------|
| 1 | Abdalhakim Elghweiry |        5061 |
| 2 | | Yousif Abodaya  |         4809 |
| 3 | | Abdalsalam Yahya|  4702|
| 4 | | Wael Mohamed |  4886|

---

## 2. Project Title and Description

**Title:** CloudScale – Containerized Web Application Deployment using Terraform and Azure ACI

**Description:**  
This project provisions a complete cloud infrastructure on Microsoft Azure using Infrastructure as Code (IaC) with Terraform. The application is containerized with Docker, pushed to Docker Hub, and deployed to Azure Container Instances (ACI) – a serverless container platform that eliminates the need to manage virtual machines. The entire provisioning process is automated using a GitHub Actions CI/CD pipeline with a manual approval gate for production deployments.

---

## 3. Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        Developer Machine                         │
│                                                                   │
│   ┌──────────────┐    ┌──────────────┐    ┌──────────────────┐  │
│   │  index.html  │    │  Dockerfile  │    │  Terraform Files │  │
│   │  (Web App)   │    │              │    │  main.tf         │  │
│   └──────┬───────┘    └──────┬───────┘    │  providers.tf    │  │
│          │                   │            │  variables.tf    │  │
│          └─────────┬─────────┘            │  outputs.tf      │  │
│                    │                      └────────┬─────────┘  │
└────────────────────┼───────────────────────────────┼────────────┘
                     │                               │
                     ▼                               ▼
          ┌──────────────────┐            ┌──────────────────────┐
          │    Docker Hub    │            │      GitHub Repo      │
          │                  │            │                        │
          │  abdalhakimelgh  │            │  Push / Pull Request  │
          │  weiry/          │            │                        │
          │  cloudscale-app  │            └──────────┬───────────┘
          └──────────────────┘                       │
                     ▲                               ▼
                     │                  ┌──────────────────────────┐
                     │                  │    GitHub Actions CI/CD   │
                     │                  │                            │
                     │                  │  PR → terraform plan       │
                     │                  │  Push → terraform apply    │
                     │                  │  Manual Approval Gate      │
                     │                  └──────────┬───────────────┘
                     │                             │
                     │                             ▼
                     │              ┌──────────────────────────────┐
                     │              │         Microsoft Azure        │
                     │              │                                │
                     │              │  ┌─────────────────────────┐  │
                     │              │  │  Resource Group          │  │
                     │              │  │  abdalhakim-proj2-aci-rg │  │
                     │              │  │                           │  │
                     │              │  │  ┌─────────────────────┐ │  │
                     │              │  │  │  Azure Container     │ │  │
                     └──────────────┼──┼──│  Instance (ACI)      │ │  │
                                    │  │  │                       │ │  │
                                    │  │  │  Port 80 → Public IP  │ │  │
                                    │  │  └─────────────────────┘ │  │
                                    │  └─────────────────────────┘  │
                                    │                                │
                                    │  ┌─────────────────────────┐  │
                                    │  │  Storage Account         │  │
                                    │  │  tfstateabdalhakim123    │  │
                                    │  │  (Terraform Remote State)│  │
                                    │  └─────────────────────────┘  │
                                    └──────────────────────────────┘
```

**Components:**
| Component | Technology | Purpose |
|---|---|---|
| Web Application | HTML/CSS | Custom CloudScale webpage |
| Containerization | Docker | Package app into portable image |
| Image Registry | Docker Hub | Store and distribute Docker image |
| IaC Tool | Terraform v1.9.8 | Provision Azure resources as code |
| Cloud Platform | Microsoft Azure | Host the container instance |
| Container Service | Azure ACI | Run container without managing VMs |
| Remote State | Azure Blob Storage | Store Terraform state for team use |
| CI/CD | GitHub Actions | Automate plan and apply pipeline |
| Approval Gate | GitHub Environments | Manual gate before production deploy |

---

## 4. Docker Image Build and Push Instructions

### Step 4.1: Prerequisites
Make sure Docker Desktop is installed and running:
```bash
docker --version
```

### Step 4.2: Project File Structure
```
cloudscale-proj2/
├── Dockerfile
├── index.html
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── .gitignore
└── .github/
    └── workflows/
        └── terraform.yml
```

### Step 4.3: The Web Application (index.html)
The `index.html` file contains a custom CloudScale branded webpage that displays the student name and project information, served on port 80.

### Step 4.4: The Dockerfile
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Explanation:**

| Line | What It Does |
|---|---|
| `FROM nginx:alpine` | Uses lightweight nginx base image |
| `COPY index.html` | Copies our web page into the container |
| `EXPOSE 80` | Opens port 80 for web traffic |
| `CMD` | Starts the nginx web server |

### Step 4.5: Build the Docker Image
```bash
docker build -t abdalhakimelghweiry/cloudscale-app:latest .
```

Expected output:
```
[+] Building 2.3s (7/7) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load .dockerignore
 => [internal] load metadata for docker.io/library/nginx:alpine
 => [1/2] FROM docker.io/library/nginx:alpine
 => [2/2] COPY index.html /usr/share/nginx/html/index.html
 => exporting to image
 => => writing image sha256:...
 => => naming to docker.io/abdalhakimelghweiry/cloudscale-app:latest
```

### Step 4.6: Login to Docker Hub
```bash
docker login
```
Enter your Docker Hub username and password when prompted.

### Step 4.7: Push the Image to Docker Hub
```bash
docker push abdalhakimelghweiry/cloudscale-app:latest
```

Expected output:
```
The push refers to repository [docker.io/abdalhakimelghweiry/cloudscale-app]
latest: digest: sha256:... size: 1234
```

### Step 4.8: Verify on Docker Hub
Go to: `https://hub.docker.com/r/abdalhakimelghweiry/cloudscale-app`  
You should see your image listed with the `latest` tag.

---

## 5. Terraform Setup Instructions

### Step 5.1: Install Terraform
Download from [terraform.io/downloads](https://terraform.io/downloads) or use Chocolatey:
```powershell
choco install terraform
```

Verify:
```bash
terraform --version
# Expected: Terraform v1.9.8
```

### Step 5.2: Login to Azure
```bash
az login
az account show
```

### Step 5.3: Create Remote State Storage

**Create resource group for state:**
```powershell
az group create --name tfstate-rg --location swedencentral
```

**Create storage account:**
```powershell
az storage account create `
  --name tfstateabdalhakim123 `
  --resource-group tfstate-rg `
  --sku Standard_LRS `
  --location swedencentral
```

**Create blob container:**
```powershell
az storage container create `
  --name tfstate `
  --account-name tfstateabdalhakim123 `
  --auth-mode login
```

### Step 5.4: Terraform Configuration Files

**providers.tf** – Configures Azure provider and remote backend:
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateabdalhakim123"
    container_name       = "tfstate"
    key                  = "project2.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
```

| Block | Purpose |
|---|---|
| `required_providers` | Declares the Azure provider |
| `backend "azurerm"` | Stores state file in Azure Blob Storage |
| `provider "azurerm"` | Configures the Azure connection |

**variables.tf** – Defines reusable input variables:
```hcl
variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "swedencentral"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = "abdalhakim-proj2-aci-rg"
}

variable "container_name" {
  description = "Name of the Azure Container Instance"
  type        = string
  default     = "abdalhakim-v2cloudanddevopsproject"
}

variable "docker_image" {
  description = "Docker image to deploy"
  type        = string
  default     = "abdalhakimelghweiry/cloudscale-app:latest"
}
```

**main.tf** – Defines the Azure resources:
```hcl
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Project     = "Project2"
    Environment = "production"
    StudentName = "abdalhakim"
  }
}

resource "azurerm_container_group" "main" {
  name                = var.container_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  dns_name_label      = "abdalhakim-proj2-app"
  os_type             = "Linux"

  container {
    name   = "v2cloudanddevopsproject-web"
    image  = var.docker_image
    cpu    = 1
    memory = 1.5

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = {
    Project     = "Project2"
    Environment = "production"
    StudentName = "abdalhakim"
  }
}
```

**outputs.tf** – Displays key information after apply:
```hcl
output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "container_ip_address" {
  description = "Public IP address of the container"
  value       = azurerm_container_group.main.ip_address
}

output "container_fqdn" {
  description = "Fully qualified domain name of the container"
  value       = azurerm_container_group.main.fqdn
}

output "app_url" {
  description = "URL to access the web application"
  value       = "http://${azurerm_container_group.main.fqdn}"
}
```

### Step 5.5: Run Terraform

**Initialize:**
```bash
terraform init
```
Expected output:
```
Successfully configured the backend "azurerm"!
Terraform has been successfully initialized!
```

**Preview changes:**
```bash
terraform plan
```
Expected output:
```
Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + app_url              = (known after apply)
  + container_fqdn       = (known after apply)
  + container_ip_address = (known after apply)
  + resource_group_name  = "abdalhakim-proj2-aci-rg"
```

**Apply (create resources):**
```bash
terraform apply -auto-approve
```
Expected output:
```
azurerm_resource_group.main: Creating...
azurerm_resource_group.main: Creation complete after 14s
azurerm_container_group.main: Creating...
azurerm_container_group.main: Creation complete after 44s

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
app_url              = "http://abdalhakim-proj2-app.swedencentral.azurecontainer.io"
container_fqdn       = "abdalhakim-proj2-app.swedencentral.azurecontainer.io"
container_ip_address = "9.223.237.233"
resource_group_name  = "abdalhakim-proj2-aci-rg"
```

---

## 6. GitHub Actions Workflow Explanation

### Step 6.1: Add GitHub Secrets
Go to: **GitHub Repo → Settings → Secrets and variables → Actions → New repository secret**

| Secret Name | Description |
|---|---|
| `AZURE_CLIENT_ID` | Service Principal App ID |
| `AZURE_CLIENT_SECRET` | Service Principal Secret |
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID |
| `AZURE_TENANT_ID` | Azure Tenant ID |

Get values:
```powershell
az account show --query "{subscriptionId:id, tenantId:tenantId}"
az ad sp list --display-name "proj2-sp" --query "[].appId"
```

### Step 6.2: Create Production Environment with Approval Gate
1. Go to **Settings → Environments → New environment**
2. Name: `production`
3. Enable **Required reviewers** → add your GitHub username
4. Click **Save protection rules**

### Step 6.3: The Workflow File (`.github/workflows/terraform.yml`)

```yaml
name: Terraform CI/CD

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

env:
  ARM_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
  ARM_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}
  ARM_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
  ARM_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}

jobs:
  terraform-plan:
    name: Terraform Plan
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.9.8

      - name: Terraform Init
        run: terraform init

      - name: Terraform Plan
        run: terraform plan

  terraform-apply:
    name: Terraform Apply
    runs-on: ubuntu-latest
    needs: terraform-plan
    if: github.ref == 'refs/heads/main' && github.event_name == 'push'
    environment: production

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.9.8

      - name: Terraform Init
        run: terraform init

      - name: Terraform Apply
        run: terraform apply -auto-approve
```

**Workflow Explanation:**

| Section | What It Does |
|---|---|
| `on: pull_request` | Triggers `terraform plan` on every PR to main |
| `on: push` | Triggers `terraform apply` on every push to main |
| `env:` | Injects Azure credentials from GitHub Secrets |
| `terraform-plan` job | Runs `init` and `plan` — shows what will change |
| `terraform-apply` job | Runs `init` and `apply` — creates real resources |
| `needs: terraform-plan` | Apply only runs after plan succeeds |
| `environment: production` | Pauses and waits for manual approval before applying |

### Step 6.4: How the Pipeline Works

```
Developer pushes code
        │
        ▼
┌───────────────────┐
│  Pull Request     │──→ terraform plan runs automatically
│  to main          │    Results shown in Actions tab
└───────────────────┘
        │
        │ (PR approved and merged)
        ▼
┌───────────────────┐
│  Push to main     │──→ terraform plan runs first
└───────────────────┘
        │
        ▼
┌───────────────────┐
│  Approval Gate    │──→ Waits for manual approval
│  (production env) │    Only designated reviewer can approve
└───────────────────┘
        │
        │ (Approved)
        ▼
┌───────────────────┐
│  terraform apply  │──→ Resources created in Azure
└───────────────────┘
        │
        ▼
   ✅ App is live at:
   http://abdalhakim-proj2-app
   .swedencentral.azurecontainer.io
```

---

## 7. Screenshots

### Screenshot 1 – Docker Image Build
![Docker Build](screenshots/1-docker-build.png)

*Docker image built successfully in terminal using `docker build` command.*

---

### Screenshot 2 – Docker Image Pushed to Docker Hub
![Docker Push](screenshots/2-docker-push.png)

*Docker image pushed to Docker Hub public repository.*

---

### Screenshot 3 – Terraform Plan Output
![Terraform Plan](screenshots/3-terraform-plan.png)

*`terraform plan` output showing 2 resources to be created: resource group and container instance.*

---

### Screenshot 4 – Terraform Apply Output
![Terraform Apply](screenshots/4-terraform-apply.png)

*`terraform apply` output showing successful creation of all resources in swedencentral region.*

---

### Screenshot 5 – GitHub Actions Workflow (Plan on PR)
![GitHub Actions Plan](screenshots/5-github-actions-plan.png)

*GitHub Actions workflow showing successful `terraform plan` triggered by Pull Request.*

---

### Screenshot 6 – GitHub Actions Workflow (Approved Apply)
![GitHub Actions Apply](screenshots/6-github-actions-apply.png)

*GitHub Actions workflow showing manual approval gate and successful `terraform apply`.*

---

### Screenshot 7 – Web App in Browser
![Web App](screenshots/7-browser-app.png)

*Browser showing the CloudScale web application running at `http://abdalhakim-proj2-app.swedencentral.azurecontainer.io`*

---

### Screenshot 8 – Azure Portal
![Azure Portal](screenshots/8-azure-portal.png)

*Azure Portal showing resource group `abdalhakim-proj2-aci-rg` with all provisioned resources.*

---

## 8. Step-by-Step Detailed Solution

### Phase 1: Environment Setup

**Step 1.1: Install Required Tools**
```powershell
# Install Git
winget install Git.Git

# Install Docker Desktop
# Download from https://www.docker.com/products/docker-desktop

# Install Terraform
choco install terraform

# Install Azure CLI
winget install Microsoft.AzureCLI
```

**Verify all tools:**
```powershell
git --version
docker --version
terraform --version
az --version
```

**Step 1.2: Create GitHub Repository**
1. Go to GitHub → New repository
2. Name: `cloudscale-proj2`
3. Visibility: Public
4. Do NOT initialize with README
5. Click Create repository

**Step 1.3: Clone Repository Locally**
```powershell
git clone https://github.com/YOUR-USERNAME/cloudscale-proj2.git
cd cloudscale-proj2
```

---

### Phase 2: Build the Docker Container

**Step 2.1: Create the Web Application**

Create `index.html` with a custom CloudScale webpage that includes your name and project branding.

**Step 2.2: Create the Dockerfile**
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

**Step 2.3: Create `.gitignore`**
```
# Terraform state files
*.tfstate
*.tfstate.*
.terraform/
.terraform.lock.hcl
crash.log
terraform.tfvars
```

**Step 2.4: Build the Docker Image**
```bash
docker build -t abdalhakimelghweiry/cloudscale-app:latest .
```
→ **Take Screenshot #1 here**

**Step 2.5: Push to Docker Hub**
```bash
docker login
docker push abdalhakimelghweiry/cloudscale-app:latest
```
→ **Take Screenshot #2 here**

---

### Phase 3: Write Terraform Configuration

**Step 3.1: Create `variables.tf`**  
Define variables for location, resource group name, container name, and Docker image.

**Step 3.2: Create `outputs.tf`**  
Define outputs for resource group name, container IP, FQDN, and app URL.

**Step 3.3: Create `main.tf`**  
Define `azurerm_resource_group` and `azurerm_container_group` resources with required tags.

**Step 3.4: Create `providers.tf`** (initially without backend):
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

---

### Phase 4: Configure Azure and Remote State

**Step 4.1: Login to Azure**
```bash
az login
az account show
```

**Step 4.2: Create Service Principal**
```powershell
az ad sp create-for-rbac `
  --name "proj2-sp" `
  --role Contributor `
  --scopes /subscriptions/YOUR-SUBSCRIPTION-ID
```
Save the `appId`, `password`, and `tenant` values.

**Step 4.3: Create Remote State Infrastructure**
```powershell
# Resource group for state
az group create --name tfstate-rg --location swedencentral

# Storage account
az storage account create `
  --name tfstateabdalhakim123 `
  --resource-group tfstate-rg `
  --sku Standard_LRS `
  --location swedencentral

# Blob container
az storage container create `
  --name tfstate `
  --account-name tfstateabdalhakim123 `
  --auth-mode login
```

**Step 4.4: Update `providers.tf` with Remote Backend**  
Add the `backend "azurerm"` block pointing to the storage account created above.

---

### Phase 5: Run Terraform

**Step 5.1: Initialize**
```bash
terraform init
```
Expected: `Terraform has been successfully initialized!`

**Step 5.2: Plan**
```bash
terraform plan
```
Expected: `Plan: 2 to add, 0 to change, 0 to destroy.`  
→ **Take Screenshot #3 here**

**Step 5.3: Apply**
```bash
terraform apply -auto-approve
```
Expected: `Apply complete! Resources: 2 added, 0 changed, 0 destroyed.`  
→ **Take Screenshot #4 here**

**Step 5.4: Verify in Browser**  
Open: `http://abdalhakim-proj2-app.swedencentral.azurecontainer.io`  
→ **Take Screenshot #7 here**

**Step 5.5: Verify in Azure Portal**  
Go to portal.azure.com → Resource groups → `abdalhakim-proj2-aci-rg`  
→ **Take Screenshot #8 here**

---

### Phase 6: GitHub Actions CI/CD

**Step 6.1: Add GitHub Secrets**  
Go to repo → Settings → Secrets → add all 4 Azure credentials.

**Step 6.2: Create Production Environment**  
Settings → Environments → New environment → `production` → Required reviewers → add yourself.

**Step 6.3: Create Workflow File**
```powershell
mkdir -p .github/workflows
# Create .github/workflows/terraform.yml with the workflow content shown in Section 6
```

**Step 6.4: Commit and Push**
```powershell
git add .github/workflows/terraform.yml
git commit -m "Add GitHub Actions CI/CD workflow with manual approval gate"
git push origin main
```

**Step 6.5: Monitor the Pipeline**
1. Go to GitHub repo → **Actions tab**
2. Watch `terraform plan` run automatically
3. When it reaches `terraform apply`, click **Review deployments**
4. Click **Approve and deploy**

→ **Take Screenshot #5** (plan result)  
→ **Take Screenshot #6** (approved apply)

---

### Phase 7: Commits History

```powershell
# Commit 1
git add index.html
git commit -m "Add web application homepage with CloudScale branding"

# Commit 2
git add Dockerfile
git commit -m "Add Dockerfile to containerize the web application"

# Commit 3
git add variables.tf
git commit -m "Add Terraform variables for location, resource group, and container config"

# Commit 4
git add outputs.tf
git commit -m "Add Terraform outputs for app URL, FQDN, and IP address"

# Commit 5
git add main.tf providers.tf
git commit -m "Add Terraform main config with ACI resource and Azure remote backend"

# Commit 6
git add .github/workflows/terraform.yml
git commit -m "Add GitHub Actions workflow with plan on PR and manual approval gate"

# Commit 7
git add .gitignore
git commit -m "Add .gitignore to exclude Terraform state and local config files"

# Commit 8
git add README.md
git commit -m "Add README with architecture, setup instructions, and screenshots"

git push origin main
```

---

## 9. Quick Reference – Terraform Commands

| Command | Purpose |
|---|---|
| `terraform init` | Initialize providers and backend |
| `terraform plan` | Preview changes (no execution) |
| `terraform apply` | Create/update resources |
| `terraform apply -auto-approve` | Apply without confirmation prompt |
| `terraform destroy` | Delete all resources |
| `terraform destroy -auto-approve` | Destroy without confirmation |
| `terraform validate` | Check configuration syntax |
| `terraform fmt` | Format code to standard style |
| `terraform output` | Display output values |
| `terraform state list` | List all resources in state |

---

## 10. Troubleshooting

| Problem | Likely Cause | Solution |
|---|---|---|
| `terraform: command not found` | Terraform not installed | Reinstall Terraform |
| `az: command not found` | Azure CLI not installed | Install Azure CLI |
| `Error: 403 Forbidden` | Region policy restriction | Change location to `swedencentral` |
| `Backend configuration changed` | Changed backend after init | Run `terraform init -reconfigure` |
| `GitHub Action fails with auth error` | Secrets not configured | Verify all 4 Azure secrets are added |
| `Approval gate not showing` | Environment not created | Create `production` environment in Settings |
| `Error building account` | Not logged in to Azure | Run `az login` again |

---

## 11. Repository Link

🔗 **GitHub Repository:** `https://github.com/YOUR-USERNAME/cloudscale-proj2`

---

## 12. References

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions for Terraform](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)
- [Azure Container Instances Docs](https://docs.microsoft.com/en-us/azure/container-instances/)
- [Azure CLI Documentation](https://docs.microsoft.com/en-us/cli/azure/)
- [Docker Hub](https://hub.docker.com/)

---

*End of README – Project 2: Infrastructure as Code with Terraform and Azure ACI*
