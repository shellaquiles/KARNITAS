# Spec — 001-integrar-multiagentes

## Resumen

Integrar la orquestación multi-agente en el ciclo SDD de KARNITAS: cada feature define en su spec quién hace qué (specifier, planner, implementer), cuándo hay handoff y qué puede paralelizarse. El arquetipo nivel 5 expone roles, skills, workflow y tools como SSOT en `.agents/`.

## User stories

- Como **equipo con agentes IA**, quiero **roles y handoffs explícitos por feature**, para **evitar solapamiento y retrabajo entre fases**.
- Como **specifier**, quiero **documentar orquestación en spec.md**, para **que planner e implementer respeten alcance acordado**.
- Como **planner**, quiero **tasks con agente asignado y marcas [P]**, para **ejecutar en paralelo solo lo seguro**.
- Como **humano revisor**, quiero **gates por fase**, para **aprobar spec, plan y código por separado**.

## Requisitos

- RF-001: La plantilla `specs/_templates/spec-template.md` incluye sección **Orquestación multi-agente**.
- RF-002: `skills/sdd_specify.md` exige completar orquestación antes del gate de Specify.
- RF-003: `skills/sdd_clarify.md` valida handoffs, alcance por agente y reglas de paralelización.
- RF-004: `skills/sdd_plan.md` y `skills/sdd_tasks.md` respetan la orquestación de la spec; no expanden alcance del implementer.
- RF-005: Registro de agentes en `agents/` con `handoff` explícito specifier → planner → implementer.
- RF-006: `workflows/spec_driven.yaml` asocia fase SDD, skill, agente y outputs.
- RF-007: `index.json` expone `context_map.sdd_specify` para cargar agentes en fase Specify sin inflar `always_load`.
- NFR-001: Token economy — `always_load` sigue siendo solo `core/constraints.md` + `core/directives.md`.
- NFR-002: KISS — una tabla de orquestación por spec; sin duplicar contenido de `knowledge/sdd.md`.

## Criterios EARS

- [ ] Ubiquitous: THE sistema SHALL definir en cada spec.md la orquestación multi-agente (fases, agentes, handoffs).
- [ ] WHEN una spec es aprobada THE specifier SHALL handoff a planner solo si la sección Orquestación multi-agente está completa.
- [ ] WHEN planner genera plan.md THE plan SHALL NOT asignar trabajo fuera del alcance del implementer definido en spec.
- [ ] WHEN tasks.md marca una tarea [P] THE spec SHALL haber autorizado paralelización sin estado compartido.
- [ ] IF spec y plan entran en conflicto THEN THE equipo SHALL volver a Clarify antes de Tasks.
- [ ] WHEN se inicia Specify THE agente SHALL cargar contexto vía `context_map.sdd_specify` (agents/, workflow).

## Orquestación multi-agente

| Fase SDD | Agente | Entregable | Gate humano |
|----------|--------|------------|-------------|
| Specify / Clarify | specifier | spec.md (incl. esta sección) | [ ] |
| Plan / Tasks | planner | plan.md, tasks.md | [ ] |
| Implement / Iterate | implementer | código + tests EARS | [ ] |

### Alcance por agente

| Agente | Responsabilidad en esta feature | Fuera de alcance |
|--------|--------------------------------|------------------|
| specifier | Plantilla spec, skills specify/clarify, validación EARS de orquestación | plan.md, tasks.md, código |
| planner | Alinear plan/tasks con spec; marcar [P] y agente por tarea | Cambiar RF/EARS sin volver a spec |
| implementer | Ejecutar tasks.md; cumplir EARS con tests | Redefinir arquitectura sin plan aprobado |

### Handoffs

- specifier → planner cuando: spec aprobada y tabla Orquestación multi-agente completa (handoffs, alcance, paralelización).
- planner → implementer cuando: plan.md y tasks.md aprobados; agente y [P] coherentes con spec.

### Paralelización

- [ ] Tareas `[P]` posibles en bootstrap: documentar ADR-002, actualizar README arquetipo, validar index.json — sin estado compartido entre ellas.
- [ ] Sin estado compartido entre tareas paralelas: [x] sí (cada tarea toca archivos distintos o solo lectura).

### Tools (opcional)

| Tool | Uso en esta feature |
|------|---------------------|
| `tools/mcp_servers.json` | No requerido para esta feature |
| `tools/openapi_specs/` | No requerido |

## Tests derivados

| Criterio EARS | Test |
|---------------|------|
| Plantilla incluye orquestación | `spec-template.md` contiene sección Orquestación multi-agente |
| Specify carga agentes | `index.json` tiene `context_map.sdd_specify` con `agents/` |
| Handoff specifier | `agents/specifier.yaml` define `handoff.when` con orquestación completa |
| Plan no expande alcance | Revisión manual: plan.md no añade RF no presentes en spec |
| [P] autorizado | tasks.md solo [P] donde spec lo indica |

## Fuera de alcance

- Runtime de orquestación (LangGraph, CrewAI, etc.) — solo contrato documental en `.agents/`.
- Nuevos roles más allá de specifier / planner / implementer.
- Automatización de gates humanos.

## Preguntas abiertas

- [ ] ¿Gate humano siempre obligatorio o configurable por proyecto en `core/directives.md`?
