# KARNITAS — instrucciones Copilot

SSOT: `.agents/`. No inventar stack ni arquitectura fuera de ahí.

## Protocolo

1. Leer `.agents/index.json`.
2. Cargar siempre: `.agents/core/constraints.md`, `.agents/core/directives.md`.
3. Feature activa: `.agents/specs/<id>/spec.md` (y plan/tasks si aplica).
4. SDD: seguir `index.json` → `sdd.skills` y `context_map` por fase.
5. Multi-agente: `workflows/spec_driven.yaml`, roles en `.agents/agents/`.
6. Memoria: ADRs y `.agents/memory/known_issues.md` antes de proponer cambios.
7. Sin contexto documentado → pedir aclaración; no asumir.

Ver también `AGENTS.md` en la raíz del repositorio.
