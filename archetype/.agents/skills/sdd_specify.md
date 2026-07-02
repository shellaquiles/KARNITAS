# Skill: SDD Specify

**Fase 1** · Output: `specs/NNN-nombre/spec.md`

**Cargar:** `agents/`, `workflows/spec_driven.yaml`, `knowledge/sdd.md`

1. Escanear `specs/` → siguiente ID (`001`, `002`…)
2. Copiar `specs/_templates/spec-template.md`
3. Completar: user stories, RF, NFR, EARS, fuera de alcance
4. Completar sección **Orquestación multi-agente**:
   - Qué agente lidera cada fase (specifier / planner / implementer)
   - Alcance por agente y criterios de handoff
   - Oportunidades de paralelización `[P]` para tasks.md
   - Tools MCP/OpenAPI si la feature los requiere
5. Validar contra `core/constraints.md` y `governance/`
6. No generar código ni plan.md en esta fase

Gate: revisión humana de spec + orquestación acordada.
