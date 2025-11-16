from typing import Dict
import json

from ruamel.yaml import YAML


def build_policy_pack(product_name: str) -> Dict[str, str]:
    yaml = YAML()
    yaml.indent(mapping=2, sequence=4, offset=2)

    azure_initiative = {
        "name": f"{product_name}-baseline-initiative",
        "properties": {
            "displayName": f"{product_name} Baseline Guardrails",
            "policyType": "Custom",
            "policyDefinitions": [
                {
                    "policyDefinitionReferenceId": "encryptionAtRest",
                    "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/enforce-encryption-at-rest",
                },
                {
                    "policyDefinitionReferenceId": "denyPublicStorage",
                    "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/deny-public-storage",
                },
                {
                    "policyDefinitionReferenceId": "requireOwnerTag",
                    "policyDefinitionId": "/providers/Microsoft.Authorization/policyDefinitions/require-tags",
                    "parameters": {"tagName": {"value": "owner"}},
                },
            ],
        },
    }

    aws_pack = {
        "ConformancePackName": f"{product_name}-baseline-pack",
        "TemplateBody": {
            "Resources": {
                "EncryptedBucketsOnly": {
                    "Type": "AWS::Config::ConfigRule",
                    "Properties": {
                        "ConfigRuleName": "encrypted-s3-buckets-only",
                        "Source": {"Owner": "AWS", "SourceIdentifier": "S3_BUCKET_SERVER_SIDE_ENCRYPTION_ENABLED"},
                    },
                },
                "NoPublicBuckets": {
                    "Type": "AWS::Config::ConfigRule",
                    "Properties": {
                        "ConfigRuleName": "s3-block-public-access",
                        "Source": {"Owner": "AWS", "SourceIdentifier": "S3_BUCKET_PUBLIC_READ_PROHIBITED"},
                    },
                },
            }
        },
    }

    gcp_constraint = {
        "apiVersion": "constraints.gatekeeper.sh/v1beta1",
        "kind": "K8sPSPCustom",
        "metadata": {"name": f"{product_name.lower().replace(' ', '-')}-no-public-service"},
        "spec": {
            "match": {
                "kinds": [{"apiGroups": [""], "kinds": ["Service"]}],
            },
            "parameters": {"forbiddenAnnotations": ["cloud.google.com/load-balancer-type=external"]},
        },
    }

    oci_recipe = {
        "displayName": f"{product_name} Baseline Detector",
        "description": "Detects public object storage and missing encryption.",
        "source": "IAAP",
        "rules": [
            {
                "id": "no-public-buckets",
                "condition": "eventType = 'OBJECTSTORAGE.BUCKET.CREATE' and data.publicAccessType != 'NoPublicAccess'",
                "recommendation": "Disable public access.",
            }
        ],
    }

    aws_stream = []
    yaml.dump(aws_pack, aws_stream)
    aws_yaml = "".join(aws_stream)

    gcp_stream = []
    yaml.dump(gcp_constraint, gcp_stream)
    gcp_yaml = "".join(gcp_stream)

    return {
        "policy/azure/initiative.json": json.dumps(azure_initiative, indent=2) + "\n",
        "policy/aws/conformance-pack.yaml": aws_yaml,
        "policy/gcp/gatekeeper-constraint.yaml": gcp_yaml,
        "policy/oci/cloud-guard-recipe.json": json.dumps(oci_recipe, indent=2) + "\n",
    }
