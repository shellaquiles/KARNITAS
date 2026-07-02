# KARNITAS — Claude Code / Projects

El contexto operativo del proyecto está en `.agents/` (única fuente de verdad).

## Al iniciar

1. Leer `.agents/index.json`.
2. Cargar `core/constraints.md` y `core/directives.md` (always_load).
3. Si hay feature en curso: `specs/<id>/spec.md`, `plan.md`, `tasks.md`.

## SDD

| Fase | Cargar |
|------|--------|
| Specify / Clarify | `context_map.sdd_specify`, `skills/sdd_specify.md`, `skills/sdd_clarify.md` |
| Plan / Tasks | `skills/sdd_plan.md`, `skills/sdd_tasks.md`, `governance/` |
| Implement | `skills/sdd_implement.md` + spec/plan/tasks de la feature |

Orquestación multi-agente: `workflows/spec_driven.yaml`, `agents/`.

## Reglas

- Validar contra `governance/` y ADRs en `memory/`.
- Cambio de comportamiento → actualizar spec antes que código.
- Sin información en `.agents/` → no proceder; preguntar al humano.

Entrypoint: `AGENTS.md`.
