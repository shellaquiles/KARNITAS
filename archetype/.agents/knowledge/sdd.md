# SDD en KARNITAS

La spec es el artefacto primario. Código y tests se derivan de ella. Todo vive en `.agents/`.

Orquestación: `workflows/spec_driven.yaml` · Skills por fase en `skills/` · Roles en `agents/`

## Fases

| # | Fase | Skill | Agente | Output |
|---|------|-------|--------|--------|
| 0 | Constitution | — | — | `core/` |
| 1 | Specify | `sdd_specify.md` | specifier | `spec.md` |
| 2 | Clarify | `sdd_clarify.md` | specifier | `spec.md` |
| 3 | Plan | `sdd_plan.md` | planner | `plan.md` |
| 4 | Tasks | `sdd_tasks.md` | planner | `tasks.md` |
| 5 | Implement | `sdd_implement.md` | implementer | código + tests |
| 6 | Iterate | `sdd_implement.md` | implementer | spec actualizada |

Plantillas: `specs/_templates/` — la spec incluye sección **Orquestación multi-agente**.

## EARS

Un criterio = una afirmación testeable:

- **Ubiquitous:** El sistema shall …
- **Event:** WHEN … THE sistema SHALL …
- **State:** WHILE … THE sistema SHALL …
- **Unwanted:** IF … THEN THE sistema SHALL …
- **Optional:** WHERE … THE sistema SHALL …

Mapear cada criterio a un test en la spec.

## Plan (fase 3)

Ver `skills/sdd_plan.md`. Respeta la orquestación definida en la spec.

## DoD (PR)

- Spec/plan/tasks alineados; orquestación multi-agente respetada
- Tests cubren EARS afectados
- `refs specs/NNN/spec.md` en commit
- ADR si arquitectura; `governance/` si dependencia nueva

## Evitar

Over-spec, under-spec, tareas >4h, merge sin revisión humana.
