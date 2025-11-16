from typing import Dict

from jinja2 import Template


TEMPLATE_YAML = Template(
    """
    apiVersion: scaffolder.backstage.io/v1beta3
    kind: Template
    metadata:
      name: {{ slug }}-infra-product
      title: {{ name }} Infrastructure Product
      description: Secure infra product with storage and guardrails.
      tags:
        - infrastructure
        - multi-cloud
    spec:
      owner: platform-team
      type: service
      parameters:
        - title: Infra product configuration
          required:
            - product_name
          properties:
            product_name:
              type: string
              title: Product name
      steps:
        - id: fetch-base
          name: Fetch base skeleton
          action: fetch:template
          input:
            url: ./skeleton
            values:
              product_name: "{{ '{{' }} parameters.product_name {{ '}}' }}"
        - id: publish
          name: Publish via PR
          action: publish:github:pull-request
          input:
            repoUrl: "{{ repo_url }}"
            branchName: "feature/{{ slug }}-infra"
            title: "Create infra product {{ name }}"
            targetPath: "."
            draft: false
      output:
        links:
          - title: Pull Request
            url: "{{ '{{' }} steps.publish.output.remoteUrl {{ '}}' }}"
    """
)


CATALOG_YAML = Template(
    """
    apiVersion: backstage.io/v1alpha1
    kind: Component
    metadata:
      name: {{ slug }}-infra-template
      description: Backstage template for {{ name }} infra product.
      annotations:
        backstage.io/techdocs-ref: dir:.
    spec:
      type: template
      owner: platform-team
      lifecycle: production
    """
)


README_MD = Template(
    """
    # {{ name }} Infrastructure Product

    This template provisions a secure storage‑centric infra product with
    baseline policy guardrails and tagging. Use it as a golden path for
    regulated workloads.
    """
)


def generate_backstage_bundle(product_name: str, repo_url: str) -> Dict[str, str]:
    slug = product_name.lower().replace(" ", "-")
    return {
        f"backstage/templates/infra-product/{slug}/template.yaml": TEMPLATE_YAML.render(
            slug=slug, name=product_name, repo_url=repo_url
        ).strip()
        + "\n",
        f"backstage/templates/infra-product/{slug}/catalog-info.yaml": CATALOG_YAML.render(
            slug=slug, name=product_name
        ).strip()
        + "\n",
        f"backstage/templates/infra-product/{slug}/README.md": README_MD.render(name=product_name).strip()
        + "\n",
    }
