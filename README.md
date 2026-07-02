# K.A.R.N.I.T.A.S.

**Kernel Agentic Runtime Network for Intelligent Tasks & Automation Systems**

Convención abierta: un directorio `.agents/` como fuente de verdad compartida entre humanos y agentes, con SDD integrado.

| | |
|---|---|
| Versión del estándar | 1.0.1 |
| Estado | RFC |
| Licencia | MIT |

## Este repositorio

| Ruta | Qué es |
|------|--------|
| `README.md` | Documentación del estándar |
| `archetype/` | Plantilla que se copia a tu proyecto |
| `scripts/init-karnitas.sh` | Bootstrap: `archetype/` → tu repo |

**No copies este repo entero.** Usa el script para generar solo lo que necesita tu proyecto.

## El estándar en una frase

Todo contexto operativo — reglas, memoria, specs — vive en `.agents/`. Si no está ahí, el agente no lo asume.

## Bootstrap

```bash
git clone https://github.com/shellaquiles/KARNITAS.git
./KARNITAS/scripts/init-karnitas.sh /ruta/a/mi-proyecto
```

En tu proyecto:

1. Editar `.agents/core/constraints.md` (stack y prohibiciones)
2. Editar `.agents/governance/architecture.md`
3. Crear la primera spec:

```bash
mkdir -p .agents/specs/001-mi-feature
cp .agents/specs/_templates/spec-template.md .agents/specs/001-mi-feature/spec.md
```

## Estructura del arquetipo (`.agents/`)

```
.agents/
├── index.json           # Leer primero
├── core/
│   ├── constraints.md   # always_load
│   └── directives.md    # always_load
├── knowledge/
│   ├── sdd.md           # SDD + EARS (solo si hay feature)
│   └── domain.md
├── governance/
│   ├── architecture.md
│   └── security.md
├── specs/_templates/
├── memory/
│   ├── ADRs/
│   └── known_issues.md
└── evaluation.md
```

## SDD

```
Constitution → Specify → Clarify → Plan → Tasks → Implement → Iterate
```

Detalle: [`archetype/.agents/knowledge/sdd.md`](archetype/.agents/knowledge/sdd.md)

## Protocolo

**READ → LOAD → VALIDATE → RECALL → EXECUTE**

Entrada para agentes: [`archetype/AGENTS.md`](archetype/AGENTS.md)

## Principios

- Una SSOT: `.agents/`
- `always_load` mínimo (2 archivos en `core/`)
- Spec antes que código
- Fallo seguro sin contexto
- Agnóstico a IDE y LLM

## Contribuir

[CONTRIBUTING.md](CONTRIBUTING.md)
