Reviewed 2026-05-29 through 2026-06-05 session and archived session logs for repeated approval requests.

Added narrow default rules for these safe repeated families:
- `terraform validate` (21 approvals)
- `terraform plan` (12 approvals)
- `terraform state list` (3 approvals)
- `aws ec2 describe-route-tables` (12 approvals)
- `aws rds describe-db-instances` (8 approvals)
- `aws ssm get-command-invocation` (17 approvals)
- `aws ecs describe-services` (10 approvals)
- `aws elbv2 describe-target-health` (7 approvals)

Skipped mutating or ambiguity-prone families such as `git push`, `git fetch`, `mix format`, `mix compile`, `terraform init`, `terraform import`, and `pulumi state move`.

Run time: 2026-06-05T15:22:18Z
