# SDD en KARNITAS

La spec es el artefacto primario. Código y tests se derivan de ella. Todo vive en `.agents/`.

## Fases

| # | Fase | Output | Gate |
|---|------|--------|------|
| 0 | Constitution | `core/` completo | Equipo alineado |
| 1 | Specify | `specs/NNN/spec.md` | Revisar spec |
| 2 | Clarify | spec sin ambigüedades | Sin bloqueos abiertos |
| 3 | Plan | `plan.md` | Revisar arquitectura |
| 4 | Tasks | `tasks.md` (1–4h/tarea) | Orden lógico |
| 5 | Implement | código + tests | Tests + EARS OK |
| 6 | Iterate | spec actualizada primero | Revisión humana |

Plantillas: `specs/_templates/`

## EARS (criterios de aceptación)

Un criterio = una afirmación testeable. Patrones:

- **Ubiquitous:** El sistema shall [comportamiento permanente].
- **Event:** WHEN [evento] THE sistema SHALL [respuesta].
- **State:** WHILE [estado] THE sistema SHALL [comportamiento].
- **Unwanted:** IF [condición] THEN THE sistema SHALL [respuesta].
- **Optional:** WHERE [feature] THE sistema SHALL [comportamiento].

Mapear cada criterio a un test en la spec (tabla EARS → test).

## Por fase (qué hace el agente)

**Specify** — Crear `specs/NNN-nombre/` desde plantilla. User stories, RF, NFR, EARS, fuera de alcance. Sin código.

**Clarify** — Detectar vaguedad y edge cases. Preguntar al humano. Actualizar spec.

**Plan** — Arquitectura, decisiones, riesgos. Alineado con `governance/` y ADRs. Sin contradecir spec.

**Tasks** — Tareas atómicas (1–4h, un PR razonable). ID, done, enlace a criterio EARS. Marcar `[P]` si paralelo.

**Implement** — Una tarea a la vez. Tests por criterio EARS. Marcar `[x]` en tasks.md.

**Iterate** — Cualquier cambio de comportamiento: spec primero, luego plan/tasks/código.

## DoD (PR)

- Spec actualizada si cambia comportamiento
- Tests cubren EARS afectados
- `refs specs/NNN/spec.md` en commit
- ADR si arquitectura; `governance/` si dependencia nueva

## Evitar

Over-spec (implementación en spec), under-spec (sin EARS), tareas >4h, merge sin revisión humana.
