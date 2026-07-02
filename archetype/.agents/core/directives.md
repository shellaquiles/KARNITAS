# Directivas

## Protocolo

**READ** `index.json` → **LOAD** `always_load` + contexto de tarea → **VALIDATE** `constraints.md` → **RECALL** `memory/` → **EXECUTE**

Rutas relativas a `.agents/` salvo `AGENTS.md`.

## SDD

Flujo: `core/` (fase 0) → `specs/NNN/spec.md` → clarify → `plan.md` → `tasks.md` → implement → iterate.

Detalle en `knowledge/sdd.md`. Todo cambio de comportamiento empieza por la spec.

## Commits

`feat(ámbito): descripción, refs specs/NNN-nombre/spec.md`
