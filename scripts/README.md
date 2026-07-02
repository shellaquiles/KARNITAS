# Scripts KARNITAS

Utilidades del repositorio estándar. No forman parte del arquetipo copiado al proyecto destino (salvo que copies este directorio manualmente).

## `init-karnitas.sh`

Bootstrap de un **proyecto nuevo** (o existente) con el arquetipo KARNITAS nivel 5: `.agents/`, SDD multi-agente, adaptadores IDE y `AGENTS.md`.

### Requisitos

| Herramienta | Obligatorio | Uso |
|-------------|-------------|-----|
| `bash` 4+ | Sí | Ejecución |
| `mkdir`, `cp` | Sí | Copia del arquetipo |
| `rsync` | No | Copia más eficiente si está instalado |
| `sed` | No | Sustituye `nombre-del-proyecto` / `{{PROJECT_NAME}}` |

### Uso rápido

```bash
# Desde una copia local del repo KARNITAS
./scripts/init-karnitas.sh /ruta/a/mi-proyecto

# Directorio actual, solo Cursor
./scripts/init-karnitas.sh . --adapter cursor

# Ver qué haría sin escribir
./scripts/init-karnitas.sh ./demo --dry-run -v
```

### Opciones

| Opción | Default | Descripción |
|--------|---------|-------------|
| `TARGET` | `.` | Carpeta donde se materializa el proyecto |
| `--adapter IDE` | `all` | Adaptador a instalar (ver tabla abajo) |
| `--dry-run` | off | Simula el bootstrap |
| `-v`, `--verbose` | off | Muestra cada paso |
| `-h`, `--help` | — | Ayuda en terminal |

### Adaptadores (`--adapter`)

Los adaptadores son **entrypoints delgados**: indican a cada IDE/LLM cómo cargar `.agents/`. No contienen skills ni specs duplicadas.

| Valor | Archivo generado | Herramienta |
|-------|------------------|-------------|
| `cursor` | `.cursor/rules/karnitas.mdc` | Cursor |
| `copilot` | `copilot-instructions.md` | GitHub Copilot |
| `claude` | `CLAUDE.md` | Claude Code / Projects |
| `aider` | `.aider.conf.yml` | Aider |
| `continue` | `.continue/config.json` | Continue |
| `all` | Todos los anteriores | Equipos multi-IDE |
| `none` | Ninguno | Solo `AGENTS.md` + `.agents/` |

Plantillas fuente: [`archetype/adapters/`](../archetype/adapters/README.md).

### Qué hace el script (orden)

1. **Valida** que exista `archetype/` con `.agents/index.json` y `adapters/`.
2. **Resuelve** el directorio destino (crea si no existe; avisa si no está vacío).
3. **Copia** todo `archetype/` → destino (`rsync` o `cp`; excluye `.git`).
4. **Crea** `.agents/runtime/logs/.gitkeep` para logs locales del agente.
5. **Personaliza** el nombre del proyecto en `index.json` y `README.md`.
6. **Instala** el adaptador elegido en la ruta que espera cada IDE.
7. **Imprime** resumen y próximos pasos.

### Después del bootstrap

En el proyecto generado:

```bash
cd /ruta/a/mi-proyecto

# 1. Reglas innegociables del stack
$EDITOR .agents/core/constraints.md

# 2. Arquitectura y límites
$EDITOR .agents/governance/architecture.md

# 3. Primera feature (SDD)
mkdir -p .agents/specs/001-mi-feature
cp .agents/specs/_templates/spec-template.md .agents/specs/001-mi-feature/spec.md

# 4. Tras revisión humana de la spec
cp .agents/specs/_templates/plan-template.md .agents/specs/001-mi-feature/plan.md
# Seguir skills/sdd_plan.md y workflows/spec_driven.yaml
```

Flujo multi-agente: **specifier** → **planner** → **implementer** (`agents/`).

### Comportamiento en destinos no vacíos

Si `TARGET` ya tiene archivos y **no** es un proyecto KARNITAS previo (sin `.agents/index.json`), el script **fusiona** el arquetipo con lo existente y muestra un aviso. Revisa conflictos manualmente antes de commitear.

Para actualizar un proyecto KARNITAS ya inicializado, prefiere merge selectivo o volver a ejecutar sobre una copia limpia — este script no es un migrador de versiones.

### Ejemplos por escenario

**Equipo solo Cursor**

```bash
./scripts/init-karnitas.sh ~/code/api --adapter cursor
```

**Repo existente, añadir KARNITAS sin tocar IDE**

```bash
cd ~/code/legacy-app
/path/to/KARNITAS/scripts/init-karnitas.sh . --adapter none
```

**Probar en /tmp**

```bash
./scripts/init-karnitas.sh /tmp/karnitas-demo -v
ls /tmp/karnitas-demo/.agents/
```

**CI / documentación**

```bash
./scripts/init-karnitas.sh /tmp/check --dry-run --adapter all
```

### Solución de problemas

| Síntoma | Causa probable | Acción |
|---------|----------------|--------|
| `No se encuentra el arquetipo` | Script movido fuera del repo | Ejecutar desde clone de KARNITAS; `archetype/` debe estar junto a `scripts/` |
| Placeholders sin reemplazar | Sin `sed` | Editar a mano `index.json` / `README.md` |
| Regla Cursor no aplica | Adaptador no instalado | `./scripts/init-karnitas.sh . --adapter cursor` |
| Conflicto de archivos | Destino no vacío | Revisar diff; resolver antes de commit |

### Relación con el estándar

- **SSOT del proyecto:** `.agents/` (copiado por este script).
- **SSOT del proceso SDD:** `.agents/skills/` — nunca duplicar en adaptadores IDE.
- **Documentación del estándar:** [`README.md`](../README.md) en la raíz del repo KARNITAS.
