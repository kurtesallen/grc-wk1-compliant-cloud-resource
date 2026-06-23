GRC Engineering 6‑Week Challenge
End‑to‑End Governed Cloud Application
This repository contains the full 6‑week GRC Engineering Challenge: an end‑to‑end governed cloud application that evolves from compliant infrastructure (Week 1) to a fully automated governance pipeline (Week 6).

Each week adds a new layer of governance:

Week 1 — Compliant Cloud Resource (Terraform)

Week 2 — Executable Policies (Rego / OPA)

Week 3 — OSCAL Documentation

Week 4 — Evidence Automation Pipeline

Week 5 — Control Inheritance & System Security Plan

Week 6 — Final GRC Gate & Continuous Compliance

By the end of the challenge, this repo will become a completely governed system:
controls defined → enforced → tested → documented → evidenced → automated.

📦 Week 1 — Compliant Cloud Resource (Terraform)
Week 1 delivers a fully compliant AWS S3 deployment using Infrastructure‑as‑Code and produces machine‑readable evidence proving control enforcement.

Controls Implemented
SC‑28 — Protection of Information at Rest
AES‑256 server‑side encryption on both buckets.

AC‑3 — Access Enforcement
All four S3 public access block settings are enabled.

CM‑6 — Configuration Settings
Versioning enabled.

Provider‑level default_tags applied.

AU‑3 / AU‑6 — Audit Logging
Log bucket ownership controls and ACLs.

Primary bucket configured to deliver access logs.

Week 1 Structure
Code
week1/
├── main.tf
├── variables.tf
├── outputs.tf
├── verify.sh
└── evidence/
    └── plan.json
Generate Evidence
bash
terraform init
terraform plan -out=tfplan
terraform show -json tfplan > evidence/plan.json
Verify Compliance
bash
./verify.sh

🛡️ Week 2 — Executable Policies (Rego / OPA)
Week 2 converts written controls into executable policy‑as‑code using Rego.
These policies validate the Week 1 Terraform plan and enforce compliance at plan time.

Controls Enforced via Rego
SC‑28 — Encryption at Rest
Every S3 bucket must have a matching encryption configuration referencing it.

AC‑3 — Access Enforcement
Every S3 bucket must have a public access block with all four flags set to true.

CM‑6 — Required Tags
All taggable resources must include:

Project

Environment

ManagedBy

ComplianceScope

Week 2 Structure
Code
policies/
├── sc28_encryption_aws.rego
├── ac3_no_public_aws.rego
├── cm6_required_tags_aws.rego
└── *_test.rego
Run Policy Tests
bash
opa test policies/ -v
Expected:

Code
6 tests, 6 passed
Validate Week 1 Terraform Plan
bash
conftest test --policy policies --namespace compliance.sc28_aws plan.json
conftest test --policy policies --namespace compliance.ac3_aws  plan.json
conftest test --policy policies --namespace compliance.cm6_aws  plan.json

📘 Week 3 — OSCAL Documentation (Coming Soon)
Week 3 introduces OSCAL catalogs, profiles, and component definitions that describe the controls implemented in Weeks 1–2.

📁 Week 4 — Evidence Automation Pipeline (Coming Soon)
Week 4 builds a CI/CD pipeline that automatically:

Generates Terraform evidence

Runs Rego policies

Stores evidence artifacts

Produces OSCAL‑formatted results

🏛️ Week 5 — Control Inheritance & SSP (Coming Soon)
Week 5 ties everything together into a System Security Plan (SSP) and demonstrates control inheritance across components.

🚦 Week 6 — Final GRC Gate (Coming Soon)
Week 6 implements the final governance gate:

Automated compliance checks

Evidence validation

OSCAL export

Pass/fail governance decision

🎯 Purpose
This repository demonstrates how modern GRC engineering works:

Define controls in Terraform

Enforce them with Rego

Test them with OPA

Document them in OSCAL

Automate evidence collection

Govern the entire system through CI/CD

By the end of the challenge, this repo becomes a complete, auditable, continuously compliant cloud application.
