# K.A.R.N.I.T.A.S.

**Kernel Agentic Runtime Network for Intelligent Tasks & Automation Systems**

Estándar abierto para gestión de contexto, memoria y automatización de agentes — con **Spec-Driven Development (SDD)** integrado en `.agents/`.

| Campo | Valor |
|-------|-------|
| **Versión** | 1.1.0 |
| **Estado** | RFC — Request for Comments |
| **Licencia** | MIT |
| **Compatibilidad** | Agnóstico: cualquier IDE, agente o LLM |

---

## ¿Qué es KARNITAS?

KARNITAS define **cómo estructurar el contexto operativo** de un repositorio para que humanos y agentes de IA compartan la misma fuente de verdad.

No es un framework ni una plataforma. Es una **convención de archivos** (Markdown, JSON) adoptable de forma incremental.

El directorio `.agents/` concentra reglas, memoria, governance y especificaciones SDD. Si no está escrito ahí, no existe para el agente.

## El problema

| Sin KARNITAS | Con KARNITAS |
|--------------|--------------|
| Cada agente interpreta a su manera | Mismo `index.json` y `core/` |
| Decisiones se pierden entre sesiones | ADRs y `known_issues.md` versionados |
| El agente propone stack no aprobado | `constraints.md` + `governance/` |
| Código sin spec clara | SDD: spec → plan → tasks → código |

## Principios

1. **Única fuente de verdad** — Todo en `.agents/`
2. **Economía de tokens** — `always_load` mínimo; resto bajo demanda
3. **Spec antes que código** — SDD integrado
4. **Humanos al volante** — Agentes aceleran; no deciden solos
5. **Agnóstico** — Sin vendor lock-in

## Estructura del repositorio

```
KARNITAS/
├── README.md                 # Este documento (estándar)
├── CONTRIBUTING.md
├── LICENSE
├── archetype/                # Bootstrap para proyectos nuevos
│   ├── .agents/              # SSOT del proyecto
│   ├── AGENTS.md             # Entrada para Cursor/Copilot/Claude
│   ├── README.md             # README del proyecto generado
│   └── archetype.json
└── scripts/
    └── init-karnitas.sh      # Copia archetype/ a tu proyecto
```

### Dentro de `.agents/`

```
.agents/
├── index.json              # Punto de entrada — leer primero
├── core/
│   ├── constraints.md      # Stack, prohibiciones (always_load)
│   └── directives.md       # Protocolo (always_load)
├── knowledge/
│   ├── sdd.md              # SDD + EARS + fases
│   └── domain.md           # Dominio del negocio
├── governance/
│   ├── architecture.md
│   └── security.md
├── specs/
│   └── _templates/         # spec.md, plan.md, tasks.md
├── memory/
│   ├── ADRs/
│   └── known_issues.md
└── evaluation.md
```

## Inicio rápido

```bash
git clone https://github.com/shellaquiles/KARNITAS.git
./KARNITAS/scripts/init-karnitas.sh /ruta/a/mi-proyecto
cd /ruta/a/mi-proyecto
```

Editar `.agents/core/constraints.md` con el stack del proyecto.

### Primera feature (SDD)

```bash
mkdir -p .agents/specs/001-mi-feature
cp .agents/specs/_templates/spec-template.md .agents/specs/001-mi-feature/spec.md
```

## SDD integrado

Ciclo de trabajo:

```
Constitution → Specify → Clarify → Plan → Tasks → Implement → Iterate
```

| Fase | Artefacto |
|------|-----------|
| 0 Constitution | `core/` completo |
| 1 Specify | `specs/NNN/spec.md` |
| 2 Clarify | spec sin ambigüedades |
| 3 Plan | `plan.md` |
| 4 Tasks | `tasks.md` (1–4h por tarea) |
| 5 Implement | código + tests desde EARS |
| 6 Iterate | spec primero, luego código |

Guía completa: [`archetype/.agents/knowledge/sdd.md`](archetype/.agents/knowledge/sdd.md)

## Protocolo para agentes

**READ → LOAD → VALIDATE → RECALL → EXECUTE**

1. Leer `index.json`
2. Cargar `always_load` (`core/constraints.md`, `core/directives.md`)
3. Cargar contexto de tarea vía `context_map`
4. Validar contra `governance/` y `memory/`
5. Ejecutar respetando spec activa

Entrada rápida: [`archetype/AGENTS.md`](archetype/AGENTS.md)

## Modelo de madurez

| Nivel | Contenido |
|-------|-----------|
| 1 | Sin `.agents/` |
| 2 | `index.json` + `core/` |
| 3 | + `governance/`, `knowledge/`, `memory/` |
| 4 | + `specs/` (SDD) |
| 5 | + `evaluation/`, multi-agente (opcional) |

El arquetipo incluido cubre **nivel 4**.

## Anti-alucinación

- Sin dependencias no documentadas en `governance/`
- Sin contradecir ADRs
- Sin implementar features sin spec
- **Fallo seguro** si falta contexto

## Contribuir

Ver [CONTRIBUTING.md](CONTRIBUTING.md). Issues y PRs bienvenidos.

---

> KARNITAS no te dice cómo programar. Te ayuda a que todos — humanos y agentes — trabajen con el mismo contexto.

_MIT License · v1.1.0_
