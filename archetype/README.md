# {{PROJECT_NAME}}

## Agentes

`AGENTS.md` · `.agents/index.json`

## IDE / LLM

Adaptadores delgados en `adapters/` (SSOT sigue en `.agents/`):

```bash
../scripts/init-karnitas.sh . --adapter cursor   # o copilot, claude, aider, continue, all
```

Ver `adapters/README.md`.

## Configurar

1. `.agents/core/constraints.md`
2. `.agents/governance/architecture.md`

## SDD (multi-agente)

```bash
mkdir -p .agents/specs/001-nombre
cp .agents/specs/_templates/spec-template.md .agents/specs/001-nombre/spec.md
# Tras aprobar spec → plan con skills/sdd_plan.md
cp .agents/specs/_templates/plan-template.md .agents/specs/001-nombre/plan.md
```

Flujo: specifier → planner → implementer · `workflows/spec_driven.yaml`
