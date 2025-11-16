from typing import List, Literal, Dict, Any, Optional
from pydantic import BaseModel, Field


CloudName = Literal["azure", "aws", "gcp", "oci"]
DataClassification = Literal["public", "internal", "sensitive", "restricted"]


class ProductRequest(BaseModel):
    product_name: str = Field(..., min_length=3)
    target_clouds: List[CloudName] = Field(..., min_length=1)
    data_classification: DataClassification
    rto_target: int = Field(..., ge=1)
    rpo_target: int = Field(..., ge=0)
    business_owner: str = "unknown-owner"
    description: str = ""

    class Config:
        extra = "forbid"


class ArchitectureComponent(BaseModel):
    name: str
    responsibility: str
    cloud: CloudName
    tier: Literal["control-plane", "data-plane", "observability", "shared"]
    dependencies: List[str] = []


class SLO(BaseModel):
    rto_minutes: int
    rpo_minutes: int
    availability_percentage: float


class ArchitectureSpec(BaseModel):
    product: ProductRequest
    components: List[ArchitectureComponent]
    shared_services: List[str]
    slo: SLO
    assumptions: List[str]
    decisions: List[str]


class SecurityGuardrail(BaseModel):
    id: str
    description: str
    control_family: str
    required: bool
    configuration_ref: Optional[str] = None


class SecurityProfile(BaseModel):
    product: ProductRequest
    architecture: ArchitectureSpec
    data_classification: DataClassification
    guardrails: List[SecurityGuardrail]
    logging_standards: List[str]
    encryption_standards: List[str]
    network_segmentation_model: str


class IaCModuleRef(BaseModel):
    id: str
    cloud: CloudName
    path: str
    description: str


class PolicyPackRef(BaseModel):
    id: str
    cloud: CloudName
    path: str
    description: str


class IaCPlan(BaseModel):
    product: ProductRequest
    modules: List[IaCModuleRef]
    policies: List[PolicyPackRef]
    state_model: str
    tagging_strategy: Dict[str, str]


class TestCase(BaseModel):
    id: str
    name: str
    description: str
    type: Literal["unit", "integration", "policy", "performance"]
    mandatory: bool


class QASummary(BaseModel):
    product: ProductRequest
    test_cases: List[TestCase]
    acceptance_criteria: List[str]
    risk_summary: str
    status: Literal["draft", "ready-for-approval", "approved", "rejected"]


class BackstageBundle(BaseModel):
    product: ProductRequest
    template_path: str
    catalog_info_path: str
    repo_pr_path: str
    notes: str


class EvidenceItem(BaseModel):
    type: str
    path: str
    description: str


class EvidenceRecord(BaseModel):
    product_name: str
    bundle_path: str
    items: List[EvidenceItem]
    repo_pr_path: str
    backstage_template_path: str
    status: Literal["pending", "ready-for-review", "archived"]


def to_safe_dict(model: BaseModel) -> Dict[str, Any]:
    return model.model_dump()
