# K.A.R.N.I.T.A.S.

## Kernel Agentic Runtime Network for Intelligent Tasks & Automation Systems

**Un estándar abierto para la gestión de contexto, memoria y automatización de agentes en equipos de desarrollo multidisciplinarios.**

| Campo | Valor |
|-------|-------|
| **Versión** | 1.0.1 |
| **Estado** | RFC — Request for Comments |
| **Licencia** | MIT |
| **Audiencia** | Desarrollo, DevOps, Data, diseño y cualquier rol que use agentes de IA |
| **Compatibilidad** | Agnóstico — cualquier IDE, agente, LLM o proveedor |
| **Repositorio** | [github.com/shellaquiles/KARNITAS](https://github.com/shellaquiles/KARNITAS) |

---

## Tabla de contenido

1. [¿Qué es KARNITAS?](#1-qué-es-karnitas)
2. [El problema](#2-el-problema)
3. [Principios de diseño](#3-principios-de-diseño)
4. [Alcance y límites](#4-alcance-y-límites)
5. [Arquitectura `.agents/`](#5-arquitectura-agents)
6. [SDD integrado](#6-sdd-integrado)
7. [Política anti-alucinación](#7-política-anti-alucinación)
8. [Protocolo para agentes](#8-protocolo-para-agentes)
9. [Modelo de madurez](#9-modelo-de-madurez)
10. [Adopción gradual](#10-adopción-gradual)
11. [Compatibilidad](#11-compatibilidad)
12. [Usar este repositorio](#12-usar-este-repositorio)
13. [Contribuir](#13-contribuir)

---

## 1. ¿Qué es KARNITAS?

KARNITAS define **cómo estructurar el contexto operativo dentro de un repositorio** para que cualquier agente de IA —independientemente del IDE, LLM o proveedor— colabore de forma coherente, segura y predecible junto a equipos humanos.

La idea central: un directorio `.agents/` en la raíz del proyecto como **única fuente de verdad (SSOT)** compartida entre humanos y agentes. Ahí viven reglas, restricciones, memoria histórica, governance y —con SDD integrado— las especificaciones de cada feature.

KARNITAS **no es un framework, no es una librería y no es una plataforma**. Es una convención de archivos (Markdown, JSON) y prácticas adoptables de forma incremental con las herramientas que ya usas.

### ¿Para quién es?

- Equipos con **múltiples agentes o IDEs** en paralelo (Cursor, Copilot, Claude, Aider, Continue…)
- Equipos **multidisciplinarios** (producto, diseño, datos, DevOps, ingeniería)
- Proyectos que buscan **consistencia entre agentes** sin depender del prompting manual de cada persona
- Quienes han visto a un agente proponer algo que el equipo **ya había descartado** hace meses

---

## 2. El problema

| Problema | En la práctica |
|----------|----------------|
| **Alucinaciones técnicas** | El agente sugiere librerías o patrones que el equipo decidió no usar |
| **Pérdida de memoria** | Un bug resuelto vuelve a aparecer en otra sesión |
| **Inconsistencia entre agentes** | Cursor, Copilot y Claude proponen cosas distintas sobre el mismo tema |
| **Prompting manual** | La calidad depende de cuánto contexto escriba cada persona |
| **Stack desviado** | Dependencias o servicios no aprobados aparecen en PRs |
| **Conocimiento tribal** | Solo quien lleva más tiempo sabe por qué se decidió así |

**KARNITAS resuelve esto haciendo el contexto explícito, versionado en git y consumible por cualquier agente.**

---

## 3. Principios de diseño

### Única fuente de verdad

Todo contexto relevante —reglas, restricciones, decisiones, specs— vive en `.agents/`. Si está en dos sitios, con el tiempo divergen.

### Economía de tokens

Cargar solo lo necesario por tarea. `index.json` define qué leer siempre (`always_load`) y qué cargar bajo demanda (`context_map`). No todo `.agents/` en cada consulta.

### Restricciones explícitas

El agente no adivina stack, arquitectura ni convenciones. **Si no está en `.agents/`, no existe para el agente.**

### Memoria persistente

Decisiones (ADRs) y errores resueltos (`known_issues.md`) sobreviven a rotaciones de equipo y sesiones del agente.

### Spec antes que código

SDD integrado: la especificación es el artefacto primario; el código es su expresión.

### Humanos al volante

Los agentes aceleran; no sustituyen revisión humana ni criterio del equipo.

### Agnóstico por diseño

Funciona con cualquier IDE, agente, LLM, lenguaje y stack. Sin dependencias propietarias.

---

## 4. Alcance y límites

| KARNITAS sirve para | KARNITAS no es para |
|---------------------|---------------------|
| Contexto estructurado para agentes de IA | Reemplazar documentación técnica completa |
| Persistir decisiones y su justificación (ADRs) | Guardar secretos, credenciales o PII |
| Evitar repetir errores históricos | Sustituir code review o aprobaciones humanas |
| Unificar comportamiento de múltiples agentes | Sistema de logs en tiempo real |
| Escalar hacia automatización multi-agente | Imponer un proveedor o modelo específico |
| Proyectos de cualquier tamaño | La única documentación del proyecto |

---

## 5. Arquitectura `.agents/`

Se añade `.agents/` a la raíz del repositorio del **proyecto** (no hace falta implementar todo el primer día; ver [adopción gradual](#10-adopción-gradual)).

### Estructura del arquetipo (nivel 4)

Incluida en [`archetype/`](archetype/):

```
.agents/
├── index.json              # Punto de entrada — leer primero
├── core/
│   ├── constraints.md      # Stack, prohibiciones (always_load)
│   └── directives.md       # Protocolo (always_load)
├── knowledge/
│   ├── sdd.md              # SDD + EARS + fases
│   └── domain.md           # Dominio y reglas de negocio
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

### Extensiones opcionales (nivel 5)

Según madurez del equipo: `skills/`, `workflows/`, `tools/` (MCP, OpenAPI), `agents/` (multi-agente).

### `index.json`

Todo agente compatible lee este archivo primero. Define:

- **`always_load`** — Contexto mínimo en cada sesión (en el arquetipo: 2 archivos en `core/`)
- **`context_map`** — Qué cargar según el tipo de tarea (`sdd`, `governance`, `memory`…)
- **`sdd`** — Rutas de plantillas y fases del flujo spec-driven

Ejemplo (arquetipo):

```json
{
  "schema": "karnitas/1",
  "project": "nombre-del-proyecto",
  "root": ".agents/",
  "always_load": ["core/constraints.md", "core/directives.md"],
  "context_map": {
    "sdd": ["knowledge/sdd.md"],
    "feature": ["specs/{id}/"],
    "governance": ["governance/"],
    "memory": ["memory/"]
  }
}
```

### Componentes

| Ruta | Responsabilidad |
|------|-----------------|
| `index.json` | Mapa de navegación y carga selectiva |
| `core/` | Reglas que siempre aplican |
| `knowledge/` | Dominio del proyecto y guía SDD |
| `governance/` | Arquitectura, seguridad, estándares |
| `specs/` | Especificaciones SDD por feature |
| `memory/` | ADRs y errores ya resueltos |
| `evaluation/` | Cómo validar que el agente respeta las reglas |

---

## 6. SDD integrado

**Spec-Driven Development** no es un estándar aparte: es el método de trabajo dentro de KARNITAS. La spec es el artefacto primario; código y tests se derivan de ella. Todo vive en `.agents/specs/`.

### Ciclo de trabajo

```
Constitution → Specify → Clarify → Plan → Tasks → Implement → Iterate
```

| Fase | Output | Checkpoint humano |
|------|--------|-------------------|
| 0 Constitution | `core/` completo | Equipo alineado en reglas |
| 1 Specify | `specs/NNN/spec.md` | Revisar spec |
| 2 Clarify | spec sin ambigüedades | Sin bloqueos abiertos |
| 3 Plan | `plan.md` | Revisar arquitectura |
| 4 Tasks | `tasks.md` (1–4h/tarea) | Orden lógico |
| 5 Implement | código + tests | Criterios EARS cumplidos |
| 6 Iterate | spec actualizada primero | Revisión humana |

### EARS (criterios de aceptación)

Patrones para requisitos testeables sin ambigüedad:

- **Ubiquitous:** El sistema shall [comportamiento permanente].
- **Event:** WHEN [evento] THE sistema SHALL [respuesta].
- **State:** WHILE [estado] THE sistema SHALL [comportamiento].
- **Unwanted:** IF [condición] THEN THE sistema SHALL [respuesta].
- **Optional:** WHERE [feature] THE sistema SHALL [comportamiento].

Guía operativa completa: [`archetype/.agents/knowledge/sdd.md`](archetype/.agents/knowledge/sdd.md)

---

## 7. Política anti-alucinación

### Sin contexto explícito, el agente no debe:

1. Instalar dependencias no documentadas en `governance/` o `constraints.md`
2. Contradecir `governance/architecture.md` o ADRs en `memory/ADRs/`
3. Reabrir decisiones ya registradas
4. Implementar features significativas sin spec en `specs/`

### Regla de fallo seguro

> Sin contexto suficiente, detenerse y comunicarlo. No asumir ni inventar.

### En pull requests

- Cambio arquitectónico → ADR en `memory/ADRs/`
- Bug recurrente resuelto → `memory/known_issues.md`
- Nueva dependencia → `governance/` antes de mergear
- Cambio funcional → spec actualizada en el mismo PR

**Nunca en `.agents/`:** secretos, tokens, credenciales ni PII.

---

## 8. Protocolo para agentes

**READ → LOAD → VALIDATE → RECALL → EXECUTE**

1. **READ** — `index.json` y, si aplica, `specs/<feature>/spec.md`
2. **LOAD** — `always_load` + entradas de `context_map` según la tarea
3. **VALIDATE** — Contrastar con `constraints.md` y `governance/`
4. **RECALL** — Consultar `memory/known_issues.md` y ADRs
5. **EXECUTE** — Respetar spec, plan y tasks

Entrada rápida para herramientas: [`archetype/AGENTS.md`](archetype/AGENTS.md) en la raíz del proyecto generado.

### Integración por herramienta

| Herramienta | Cómo |
|-------------|------|
| **Cursor** | `AGENTS.md` + reglas que apunten a `.agents/core/` |
| **Copilot** | `copilot-instructions.md` → `.agents/` |
| **Claude Code / Projects** | Cargar `core/` como instrucciones |
| **Aider** | `--read .agents/core/constraints.md` |
| **Continue / Cody** | `.agents/` como contexto adicional |

---

## 9. Modelo de madurez

| Nivel | Nombre | Contenido |
|-------|--------|-----------|
| 1 | Ad-hoc | Sin `.agents/` |
| 2 | Contexto básico | `index.json` + `core/` |
| 3 | Contexto gobernado | + `governance/`, `knowledge/`, `memory/` |
| 4 | Contexto operativo | + `specs/` (SDD), `evaluation/` |
| 5 | Multi-agente | + `skills/`, `workflows/`, `tools/`, `agents/` |

El [arquetipo](archetype/) incluido en este repo cubre **nivel 4**.

---

## 10. Adopción gradual

| Fase | Cuándo | Qué hacer |
|------|--------|-----------|
| 1 Fundación | Día 1 | `init-karnitas.sh` → completar `core/constraints.md` |
| 2 Contexto | Semana 1 | `governance/`, `memory/known_issues.md` |
| 3 Conocimiento | Semana 2–4 | `knowledge/domain.md`, primeros ADRs |
| 4 SDD | Cuando haya features | `specs/001-…/spec.md` con plantillas |
| 5 Operaciones | Según necesidad | skills, workflows, multi-agente |

---

## 11. Compatibilidad

KARNITAS usa Markdown y JSON — legible por humanos y máquinas, sin runtime obligatorio.

Compatible con **Model Context Protocol (MCP)**: declarar servidores en `tools/mcp_servers.json` cuando el proyecto lo requiera (nivel 5).

---

## 12. Usar este repositorio

Este repo contiene el **estándar** (este README) y el **arquetipo** (plantilla para proyectos).

| Ruta | Propósito |
|------|-----------|
| `README.md` | Documentación del estándar KARNITAS |
| `archetype/` | Plantilla copiada a tu proyecto |
| `scripts/init-karnitas.sh` | Bootstrap |

**No clones este repo como base de tu aplicación.** Genera tu proyecto con el script:

```bash
git clone https://github.com/shellaquiles/KARNITAS.git
./KARNITAS/scripts/init-karnitas.sh /ruta/a/mi-proyecto
cd /ruta/a/mi-proyecto
```

### Primeros pasos en tu proyecto

1. Editar `.agents/core/constraints.md` — stack y prohibiciones
2. Editar `.agents/governance/architecture.md`
3. Crear la primera feature:

```bash
mkdir -p .agents/specs/001-mi-feature
cp .agents/specs/_templates/spec-template.md .agents/specs/001-mi-feature/spec.md
```

---

## 13. Contribuir

KARNITAS es una propuesta abierta. Ver [CONTRIBUTING.md](CONTRIBUTING.md).

- Reportar ambigüedades en la especificación
- Proponer extensiones **agnósticas** (sin acoplar a un vendor)
- Compartir cómo tu equipo adaptó KARNITAS a su contexto

---

> **KARNITAS no te dice cómo programar. Te ayuda a que todos en tu equipo — humanos y agentes — trabajen con el mismo contexto.**

_MIT License · K.A.R.N.I.T.A.S. v1.0.1_
