# Adaptadores IDE / LLM

Puntos de entrada **delgados** por herramienta. El contenido semántico vive en `.agents/` (SSOT).

| Adaptador | Origen | Destino en el proyecto |
|-----------|--------|------------------------|
| Cursor | `cursor/rules/karnitas.mdc` | `.cursor/rules/karnitas.mdc` |
| Copilot | `copilot/copilot-instructions.md` | `copilot-instructions.md` |
| Claude | `claude/CLAUDE.md` | `CLAUDE.md` |
| Aider | `aider/.aider.conf.yml` | `.aider.conf.yml` |
| Continue | `continue/config.json` | `.continue/config.json` |

## Instalar

Con el script de bootstrap:

```bash
./scripts/init-karnitas.sh . --adapter cursor
./scripts/init-karnitas.sh . --adapter all      # default
./scripts/init-karnitas.sh . --adapter none     # solo AGENTS.md + .agents/
```

Manual: copiar el archivo del adaptador al destino indicado.

## Reglas

- **No duplicar** `skills/`, specs ni governance aquí — solo routing hacia `.agents/`.
- Editar procesos SDD en `.agents/skills/`, no en estos archivos.
- `AGENTS.md` (raíz) es el entrypoint común a todas las herramientas.
