# Skill: SDD Plan

**Fase 3** · Input: `spec.md` · Output: `plan.md` (+ opcionales)

## Objetivo

Traducir **qué** (spec) en **cómo** (plan técnico). Respetar **Orquestación multi-agente** definida en la spec.

## Pasos

1. **Leer spec** — RF, NFR, EARS y tabla de orquestación multi-agente
2. **Contrastar** — `governance/`, `memory/ADRs/`
3. **Arquitectura** — Componentes, flujos, integraciones
4. **Decisiones** — Tabla: decisión | alternativas | justificación | origen (RF/EARS)
5. **Alineación multi-agente** — El plan no expande alcance del implementer más allá de la spec; handoffs explícitos en plan si difieren de la spec → actualizar spec primero
6. **Datos y contratos** — Opcional: `data-model.md`, `contracts/`
7. **Riesgos** — Tabla riesgo | mitigación
8. **Dependencias** — Solo las documentadas en `constraints.md` / `governance/`

## Reglas

- planner no asigna trabajo al implementer fuera del alcance de la spec
- Cada decisión técnica enlaza a RF o criterio EARS
- Conflicto spec ↔ plan → volver a Clarify

## Gate

Revisión humana arquitectónica + coherencia multi-agente antes de Tasks.
