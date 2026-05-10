# K.A.R.N.I.T.A.S.
## Kernel Agentic Runtime Network for Intelligent Tasks & Automation Systems

**Un estándar abierto para la gestión de contexto, memoria y automatización de agentes en equipos de desarrollo multidisciplinarios.**

| Campo            | Valor                                                                 |
| ---------------- | --------------------------------------------------------------------- |
| **Versión**      | 1.0.0                                                                 |
| **Estado**       | RFC — Request for Comments (Propuesta Abierta)                        |
| **Licencia**     | MIT                                                                   |
| **Audiencia**    | Equipos de desarrollo, DevOps, Data, diseño y cualquier rol que use agentes de IA |
| **Compatibilidad** | Agnóstico — funciona con cualquier IDE, agente, LLM o proveedor    |
| **Repositorio**  | github.com/tu-org/karnitas *(pendiente)*                              |

---

## Tabla de Contenido

1. [¿Qué es KARNITAS?](#1-qué-es-karnitas)
2. [El Problema](#2-el-problema)
3. [Principios de Diseño](#3-principios-de-diseño)
4. [Alcance y Límites](#4-alcance-y-límites)
5. [Arquitectura del Directorio `.agents/`](#5-arquitectura-del-directorio-agents)
6. [Componentes y Responsabilidades](#6-componentes-y-responsabilidades)
7. [Política Anti-Alucinación](#7-política-anti-alucinación)
8. [Protocolo de Inicialización para Agentes](#8-protocolo-de-inicialización-para-agentes)
9. [Modelo de Madurez](#9-modelo-de-madurez)
10. [Métricas y Riesgos](#10-métricas-y-riesgos)
11. [Adopción Gradual](#11-adopción-gradual)
12. [Compatibilidad y Ecosistema](#12-compatibilidad-y-ecosistema)
13. [Contribuir](#13-contribuir)
14. [Conclusión](#14-conclusión)

---

## 1. ¿Qué es KARNITAS?

KARNITAS es una propuesta open source que define **cómo estructurar el contexto operativo dentro de un repositorio** para que cualquier agente de IA —independientemente del IDE, LLM o proveedor— pueda colaborar de forma coherente, segura y sin alucinaciones junto a equipos humanos multidisciplinarios.

La idea central es simple: añadir un directorio `.agents/` a la raíz del repositorio que funcione como la **única fuente de verdad compartida** entre humanos y agentes. Ahí viven las reglas, restricciones, memoria histórica y contexto operativo del proyecto.

KARNITAS **no es un framework, no es una librería y no es una plataforma**. Es una convención de estructura de archivos y un conjunto de prácticas, adoptable de forma incremental, que cualquier equipo puede implementar hoy mismo con sus herramientas actuales.

### ¿Para quién es?

- Equipos que usan **múltiples agentes o IDEs** en paralelo (Cursor, Copilot, Claude, Aider, Continue, etc.)
- Equipos **multidisciplinarios** donde no todos los miembros son ingenieros de software (diseño, datos, producto, DevOps)
- Proyectos que quieren **consistencia entre agentes** sin depender del prompting manual de cada persona
- Cualquier equipo que haya experimentado que un agente sugirió algo que ya habían descartado hace tres meses

---

## 2. El Problema

Cuando múltiples personas y múltiples agentes trabajan sobre el mismo repositorio sin un contexto compartido, aparecen problemas predecibles:

| Problema                             | Lo que ocurre en la práctica                                                                                       |
| ------------------------------------ | ------------------------------------------------------------------------------------------------------------------ |
| **Alucinaciones técnicas**           | El agente sugiere librerías, patrones o servicios que el equipo decidió no usar, sin saber que esa decisión existe. |
| **Pérdida de memoria histórica**     | Un bug corregido hace dos meses vuelve a aparecer porque ningún agente sabe que ya fue resuelto.                   |
| **Inconsistencia entre agentes**     | Cursor sugiere una cosa, Copilot otra, Claude una tercera — sobre el mismo problema.                               |
| **Dependencia del prompting manual** | La calidad del output del agente depende de cuánto contexto escriba cada persona en su prompt.                     |
| **Stack desviado**                   | El agente propone dependencias no aprobadas o servicios que el equipo no puede o no quiere usar.                   |
| **Conocimiento tribal**              | Solo quien lleva más tiempo en el proyecto sabe qué decisiones se tomaron y por qué.                               |

Estos problemas se amplifican en equipos multidisciplinarios donde el contexto técnico no es uniforme, y en proyectos con múltiples agentes activos simultáneamente.

**KARNITAS resuelve esto haciendo el contexto explícito, versionado y consumible por cualquier agente.**

---

## 3. Principios de Diseño

Estos principios guían todas las decisiones de KARNITAS. Si una implementación los contradice, probablemente está mal aplicada.

### Única Fuente de Verdad (SSOT)

Todo contexto relevante para la operación del proyecto —reglas, restricciones, decisiones, memoria— debe vivir en un único lugar. Si está en dos sitios, con el tiempo estarán en desacuerdo.

### Economía de Tokens

Los agentes deben cargar solo el contexto necesario para cada tarea. No todo `.agents/` para cada consulta — solo lo relevante. Esto reduce costos, mejora la calidad de las respuestas y permite escalar sin gastar de más.

### Restricciones Explícitas, No Supuestas

Un agente nunca debe adivinar qué librerías están permitidas, qué arquitectura sigue el proyecto o qué convenciones usa el equipo. Si no está escrito en `.agents/`, no existe para el agente.

### Memoria Persistente

Las decisiones técnicas y los errores históricos deben sobrevivir a las rotaciones del equipo y a las sesiones del agente. El conocimiento institucional no puede depender de que alguien recuerde mencionarlo en el prompt.

### Humanos al Volante

Los agentes son copilots, no conductores. KARNITAS nunca reemplaza la revisión humana, la toma de decisiones ni el criterio del equipo. Acelera el trabajo; no lo sustituye.

### Agnóstico por Diseño

KARNITAS funciona con cualquier combinación de:

- **IDEs:** Cursor, VS Code, JetBrains, Neovim, Zed, etc.
- **Agentes:** Claude, Copilot, Aider, Continue, Cody, etc.
- **LLMs:** GPT-4, Claude, Gemini, Llama, Mistral, etc.
- **Lenguajes y stacks:** sin restricción

El formato de los archivos es Markdown, YAML y JSON — legibles por humanos y por máquinas, sin dependencias de herramientas propietarias.

---

## 4. Alcance y Límites

| ✅ KARNITAS sirve para                                                   | ❌ KARNITAS no es para                                              |
| ------------------------------------------------------------------------ | -------------------------------------------------------------------- |
| Dar contexto estructurado a cualquier agente de IA                       | Reemplazar la documentación técnica del proyecto                    |
| Persistir decisiones arquitectónicas y su justificación                  | Guardar secretos, credenciales o variables de entorno               |
| Evitar que los agentes repitan errores históricos                        | Sustituir revisiones de código o aprobaciones humanas               |
| Unificar el comportamiento de múltiples agentes en paralelo              | Ser un sistema de logs o registro operativo en tiempo real          |
| Escalar hacia automatización multi-agente                                | Imponer un proveedor, modelo o herramienta específica               |
| Proyectos de cualquier tamaño, desde un side project hasta equipos grandes | Ser la única documentación del proyecto                          |

---

## 5. Arquitectura del Directorio `.agents/`

El estándar se implementa añadiendo el directorio `.agents/` a la raíz del repositorio. Esta es la estructura completa — **no es obligatorio implementar todo desde el día uno**; ver [Adopción Gradual](#11-adopción-gradual).

```text
.agents/
├── index.json               # Punto de entrada: mapa de todo lo que hay en .agents/
├── core/
│   ├── principles.md        # Qué valores y criterios guían el proyecto
│   ├── directives.md        # Reglas de comportamiento para los agentes
│   └── constraints.md       # Lo que nunca debe hacerse (anti-alucinaciones)
├── governance/
│   ├── architecture/        # Decisiones y patrones de diseño aprobados
│   ├── coding_standards/    # Estilo de código, linters, convenciones
│   ├── security/            # Políticas de seguridad del proyecto
│   └── compliance/          # Restricciones legales o regulatorias (si aplica)
├── knowledge/
│   ├── glossary.md          # Glosario: términos que todos deben entender igual
│   ├── business_rules.md    # Reglas de negocio o lógica central del proyecto
│   └── domain/              # Documentación específica por área o módulo
├── agents/                  # (Opcional) Definiciones para sistemas multi-agente
│   ├── backend_agent.yaml
│   ├── data_agent.yaml
│   └── frontend_agent.yaml
├── tools/
│   ├── mcp_servers.json     # Conexiones Model Context Protocol disponibles
│   └── openapi_specs/       # Contratos de APIs que el agente puede usar
├── skills/
│   ├── refactor_code.md     # Instrucciones reutilizables para tareas específicas
│   └── deploy_service.md
├── workflows/
│   ├── deployment.yaml      # Secuencias de pasos automatizados
│   └── incident_response.yaml
├── evaluation/
│   ├── smoke_tests.md       # Cómo validar que el agente respeta las reglas
│   └── evals/               # Casos de prueba para detectar alucinaciones
├── memory/
│   ├── ADRs/                # Architecture Decision Records: qué se decidió y por qué
│   ├── known_issues.md      # Errores ya resueltos que el agente no debe repetir
│   └── incident_patterns.md # Patrones de incidentes recurrentes
└── runtime/
    └── logs/                # ⚠️ Solo ejecución local — agregar a .gitignore
```

### El archivo `index.json`

Es la pieza más importante. Todo agente que implemente KARNITAS debe leer este archivo primero. Funciona como un mapa que le dice al agente qué existe en `.agents/` y qué debe cargar según la tarea que va a ejecutar.

```json
{
  "version": "1.0.0",
  "project": "nombre-del-proyecto",
  "description": "Descripción breve del proyecto y su propósito",
  "always_load": [
    "core/constraints.md",
    "core/directives.md"
  ],
  "context_map": {
    "backend":  ["governance/architecture/", "knowledge/domain/backend.md"],
    "frontend": ["governance/coding_standards/", "knowledge/domain/frontend.md"],
    "data":     ["knowledge/domain/data.md", "tools/openapi_specs/"],
    "devops":   ["workflows/deployment.yaml", "governance/security/"]
  },
  "memory": {
    "known_issues": "memory/known_issues.md",
    "decisions":    "memory/ADRs/"
  }
}
```

---

## 6. Componentes y Responsabilidades

| Componente        | Responsabilidad                                                                                                                                                    |
| ----------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **index.json**    | Mapa de navegación. El agente lo lee primero para saber qué cargar según la tarea. Evita cargar contexto innecesario.                                             |
| **core/**         | Las reglas que siempre aplican, sin excepción. Lo que el agente nunca debe hacer y los principios que siempre debe respetar.                                      |
| **governance/**   | Estándares técnicos del proyecto: arquitectura acordada, estilo de código, políticas de seguridad. El agente los consulta antes de proponer cambios.              |
| **knowledge/**    | El dominio del proyecto: glosario, reglas de negocio, documentación por área. Ideal para RAG o búsqueda semántica.                                               |
| **memory/**       | Memoria a largo plazo. Los ADRs explican *por qué* se tomó cada decisión. `known_issues.md` lista los errores ya resueltos que no deben repetirse.               |
| **evaluation/**   | Cómo saber si el agente está funcionando bien. Smoke tests y casos de evaluación para detectar cuando un agente ignora las reglas.                               |
| **agents/**       | (Opcional) Para proyectos con múltiples agentes especializados: define qué puede hacer cada uno y cómo se comunican entre sí.                                    |
| **tools/**        | Herramientas externas que el agente puede invocar: servidores MCP, APIs documentadas con OpenAPI.                                                                |
| **skills/**       | Instrucciones paso a paso para tareas comunes y reutilizables. Equivalente a macros para el agente.                                                              |
| **workflows/**    | Orquestación de tareas multi-paso: despliegues, respuesta a incidentes, pipelines de revisión automatizada.                                                      |
| **runtime/logs/** | ⚠️ Solo para uso local durante ejecución. **Nunca versionar.** Agregar a `.gitignore`.                                                                           |

---

## 7. Política Anti-Alucinación

El principal valor de KARNITAS es reducir las alucinaciones de los agentes dándoles contexto explícito. Estas son las reglas que lo hacen posible:

### Lo que el agente no debe hacer sin contexto explícito

1. Sugerir instalar librerías o dependencias que no estén documentadas en `.agents/`.
2. Proponer cambios de arquitectura que contradigan lo definido en `governance/architecture/`.
3. Reabrir decisiones que ya están registradas como ADR en `memory/ADRs/`.
4. Generar código de infraestructura fuera del stack definido por el equipo.

### Regla de Fallo Seguro

> Cuando un agente no tiene suficiente contexto para completar una tarea de forma segura, debe detenerse y comunicarlo en lugar de asumir o inventar.
>
> Respuesta esperada: *"No tengo suficiente contexto para continuar. Revisa `.agents/` o proporciona más información antes de continuar."*

### KARNITAS en el flujo de Pull Requests

Convenciones recomendadas para el equipo:

- Cambios arquitectónicos → actualizar el ADR correspondiente en `memory/ADRs/`.
- Bug resuelto que ya había ocurrido → documentar en `memory/known_issues.md`.
- Nueva dependencia o herramienta → reflejarla en `governance/` antes de mergear.

> ⚠️ **Nunca en `.agents/`:** secretos, tokens, credenciales, claves privadas ni datos personales (PII). Para eso existen `.env`, gestores de secretos y herramientas dedicadas.

---

## 8. Protocolo de Inicialización para Agentes

Cualquier agente que implemente KARNITAS sigue este ciclo al comenzar una sesión o tarea:

1. **READ** — Leer `index.json` para entender qué contexto existe y qué es relevante para la tarea actual.
2. **LOAD** — Cargar siempre `core/constraints.md` y `core/directives.md`. Luego, solo el contexto relevante según `context_map`.
3. **VALIDATE** — Contrastar la solicitud del usuario con las restricciones definidas en `governance/`.
4. **RECALL** — Consultar `memory/known_issues.md` para verificar si la tarea involucra algo que ya fue problemático antes.
5. **EXECUTE** — Generar la respuesta o el código respetando todo lo cargado en los pasos anteriores.

Este protocolo puede implementarse como:
- Un **system prompt** en cualquier cliente de LLM
- Una **regla de proyecto** en Cursor (`.cursorrules`)
- **Custom instructions** en Claude Projects
- Un archivo de configuración en Aider, Continue, Cody u otro agente compatible

---

## 9. Modelo de Madurez

KARNITAS no es todo o nada. La adopción es incremental:

| Nivel | Nombre                      | Qué tiene el equipo                                                                                                           |
| ----- | --------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| **1** | **Ad-hoc**                  | Sin `.agents/`. Cada persona prompta a su manera. Los agentes no comparten contexto.                                          |
| **2** | **Contexto Básico**         | `index.json` + `core/`. Los agentes tienen reglas mínimas y restricciones claras.                                            |
| **3** | **Contexto Gobernado**      | Se añade `governance/`, `knowledge/` y `memory/`. Los agentes conocen el stack, el dominio y los errores pasados.             |
| **4** | **Contexto Operativo**      | Se añaden `skills/` y `workflows/`. Los agentes pueden ejecutar tareas compuestas de forma consistente.                      |
| **5** | **Multi-Agente Coordinado** | Se añade `agents/` y `evaluation/`. Múltiples agentes especializados colaboran con handoffs definidos y evaluación continua.  |

> Recomendación: **empezar por el nivel 2**. Un `index.json` bien escrito y un `core/constraints.md` honesto aportan valor inmediato con mínimo esfuerzo.

---

## 10. Métricas y Riesgos

### ¿Cómo saber si KARNITAS está funcionando?

No hay métricas obligatorias — cada equipo elige las suyas. Estas son las más útiles en la práctica:

| Métrica                             | Señal positiva                                                                                   |
| ----------------------------------- | ------------------------------------------------------------------------------------------------ |
| **Repetición de errores**           | Disminuye: los agentes consultan `known_issues.md` antes de proponer soluciones.                |
| **Consistencia entre agentes**      | Aumenta: diferentes agentes responden de forma equivalente al mismo problema.                   |
| **Tiempo de onboarding**            | Disminuye: nuevos miembros (humanos y agentes) entienden el proyecto más rápido.                |
| **Propuestas fuera del stack**      | Disminuye: los agentes respetan las restricciones definidas en `governance/`.                   |
| **Calidad de PRs generados por IA** | Aumenta: menos ciclos de revisión, menos correcciones por decisiones ya tomadas.               |

### Riesgos conocidos y cómo mitigarlos

| Riesgo                              | Mitigación                                                                                              |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------- |
| **`.agents/` queda desactualizado** | Hacerlo parte del definition of done: cualquier cambio relevante actualiza `.agents/` en el mismo PR.  |
| **Costo excesivo de tokens**        | Usar `index.json` para cargar solo el contexto necesario por tarea, no todo el directorio.             |
| **El equipo no lo adopta**          | Empezar con el nivel 2 y dejar que el valor se demuestre solo antes de añadir más estructura.          |
| **Reglas contradictorias**          | Revisar `.agents/` periódicamente como parte de la deuda técnica del equipo.                           |
| **Filtración de datos sensibles**   | Nunca almacenar secretos en `.agents/`. Revisión obligatoria antes de hacer el directorio público.     |

---

## 11. Adopción Gradual

La forma más práctica de implementar KARNITAS en un proyecto existente:

| Fase       | Nombre        | Cuándo     | Qué hacer                                                                                                                              |
| ---------- | ------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| **Fase 1** | Fundación     | Semana 1   | Crear `index.json` y `core/constraints.md`. Documentar qué NO debe hacer el agente en este proyecto.                                 |
| **Fase 2** | Contexto      | Semanas 2–4 | Añadir `governance/` con el stack actual y `memory/known_issues.md` con los bugs más frecuentes del proyecto.                        |
| **Fase 3** | Conocimiento  | Mes 2      | Añadir `knowledge/glossary.md` y `knowledge/business_rules.md`. Empezar a registrar ADRs en `memory/ADRs/`.                          |
| **Fase 4** | Operaciones   | Mes 2–3    | Añadir `skills/` para las tareas más repetitivas y `workflows/` para los procesos que ya existen pero están en la cabeza de alguien.  |
| **Fase 5** | Multi-Agente  | Cuando se necesite | Definir `agents/` y `evaluation/`. Integrar evaluaciones en CI/CD.                                                         |

### Script de inicio rápido

```bash
# Inicializar KARNITAS en un proyecto existente
mkdir -p .agents/core .agents/memory/ADRs .agents/governance
touch .agents/index.json
touch .agents/core/constraints.md
touch .agents/core/directives.md
touch .agents/memory/known_issues.md
echo "runtime/logs/" >> .gitignore
```

---

## 12. Compatibilidad y Ecosistema

KARNITAS está diseñado para funcionar con las herramientas que el equipo ya usa:

### IDEs y editores

| Herramienta       | Cómo integrar KARNITAS                                                        |
| ----------------- | ----------------------------------------------------------------------------- |
| **Cursor**        | Referenciar `.agents/` desde `.cursorrules` o reglas de proyecto              |
| **VS Code**       | Configurar en Continue, Copilot o cualquier extensión de agente compatible    |
| **JetBrains**     | Referenciar desde la configuración del asistente AI del IDE                  |
| **Zed**           | Integrable como contexto de sesión del asistente integrado                   |
| **Neovim / Vim**  | Pasar archivos de `core/` como contexto a cualquier plugin de LLM            |

### Agentes y asistentes

| Agente                  | Cómo integrar KARNITAS                                                               |
| ----------------------- | ------------------------------------------------------------------------------------ |
| **Claude Projects**     | Cargar `core/` como instrucciones del proyecto                                       |
| **GitHub Copilot**      | Referenciar desde `copilot-instructions.md` apuntando a `.agents/`                 |
| **Aider**               | Pasar archivos de `.agents/` como contexto con `--read`                             |
| **Continue**            | Configurar `.agents/` como fuente de contexto adicional                             |
| **Cody (Sourcegraph)**  | Integrable como fuente de contexto empresarial                                      |
| **Cualquier agente**    | Incluir el contenido de `core/` en el system prompt del agente                      |

### Model Context Protocol (MCP)

KARNITAS es compatible con MCP. El archivo `tools/mcp_servers.json` declara qué servidores MCP están disponibles en el proyecto y bajo qué condiciones invocarlos, permitiendo que cualquier agente compatible con MCP los descubra automáticamente.

---

## 13. Contribuir

KARNITAS es una propuesta abierta, pensada para evolucionar con la comunidad.

### Formas de contribuir

- **Reportar problemas** — si algo en la especificación es ambiguo, incompleto o incorrecto
- **Proponer extensiones** — casos de uso no cubiertos, nuevos tipos de archivos, convenciones adicionales
- **Compartir implementaciones** — cómo tu equipo adaptó KARNITAS a su contexto específico
- **Mejorar la documentación** — traducciones, ejemplos, guías por stack o disciplina
- **Construir integraciones** — plugins, plantillas, scripts de inicialización para herramientas específicas

### Principios para contribuciones

- Mantener el estándar **agnóstico**: ninguna contribución debe acoplar KARNITAS a una herramienta específica
- Preferir **convención sobre configuración**: menos archivos de setup, más claridad en los existentes
- Documentar el **razonamiento**: los cambios a la especificación deben incluir el "por qué"

---

## 14. Conclusión

Los agentes de IA ya son parte del flujo de trabajo de los equipos de desarrollo. El problema no es si usarlos, sino cómo hacerlo de forma que el equipo mantenga el control, la consistencia y la memoria institucional del proyecto.

KARNITAS propone una respuesta práctica y simple: **estructurar el contexto dentro del repositorio**, donde ya vive el código, de forma que sea accesible para humanos y agentes por igual.

No requiere infraestructura nueva. No requiere aprender otra herramienta. Requiere que el equipo tome decisiones explícitas sobre cómo trabaja, las documente en `.agents/`, y las mantenga actualizadas como parte del trabajo normal.

> **KARNITAS no te dice cómo programar. Te ayuda a que todos en tu equipo — humanos y agentes — programen de la misma manera.**

---

*MIT License · K.A.R.N.I.T.A.S. v1.0.0 · Contribuciones bienvenidas*
