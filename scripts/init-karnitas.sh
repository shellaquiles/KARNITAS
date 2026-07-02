#!/usr/bin/env bash
#
# init-karnitas.sh — Bootstrap de un proyecto con el arquetipo KARNITAS
#
# Copia la plantilla desde archetype/ al directorio destino, personaliza el
# nombre del proyecto y, opcionalmente, instala adaptadores delgados por IDE/LLM.
#
# El contenido semántico (skills SDD, specs, governance) vive en .agents/ (SSOT).
# Los adaptadores solo enrutan cada herramienta hacia .agents/ — no lo duplican.
#
# Requisitos: bash 4+, mkdir, cp o rsync (opcional), sed (opcional, para nombre)
#
# Uso:
#   ./scripts/init-karnitas.sh [TARGET] [opciones]
#
# Documentación completa: scripts/README.md
#
set -euo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
readonly ARCHETYPE="$REPO_ROOT/archetype"
readonly ADAPTERS_SRC="$ARCHETYPE/adapters"

# Adaptadores soportados (orden de instalación con --adapter all)
readonly ADAPTER_IDS=(cursor copilot claude aider continue)

TARGET="."
ADAPTER="all"
DRY_RUN=0
VERBOSE=0

# ---------------------------------------------------------------------------
# Salida
# ---------------------------------------------------------------------------

log() {
  printf '%s\n' "$*"
}

log_verbose() {
  [[ "$VERBOSE" -eq 1 ]] && printf '  → %s\n' "$*" || true
}

log_warn() {
  printf 'aviso: %s\n' "$*" >&2
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

usage() {
  cat <<EOF
${SCRIPT_NAME} — Inicializa un proyecto con el arquetipo KARNITAS (nivel 5)

Uso:
  ${SCRIPT_NAME} [TARGET] [opciones]

Argumentos:
  TARGET              Directorio destino (default: directorio actual)

Opciones:
  --adapter IDE       Instalar adaptador IDE/LLM (default: all)
  --dry-run           Mostrar acciones sin escribir archivos
  -v, --verbose       Detalle de cada paso
  -h, --help          Esta ayuda

Valores de --adapter:
  all                 Todos los adaptadores (Cursor, Copilot, Claude, Aider, Continue)
  none                Solo arquetipo + AGENTS.md (sin archivos específicos de IDE)
  cursor              .cursor/rules/karnitas.mdc
  copilot             copilot-instructions.md
  claude              CLAUDE.md
  aider               .aider.conf.yml
  continue            .continue/config.json

Ejemplos:
  ${SCRIPT_NAME} .
  ${SCRIPT_NAME} ./mi-app --adapter cursor
  ${SCRIPT_NAME} /tmp/prototype --adapter none --verbose
  ${SCRIPT_NAME} . --adapter all --dry-run

Qué copia el arquetipo:
  .agents/            SSOT: core, skills SDD, specs, agents, workflows, tools
  AGENTS.md           Entrypoint común para cualquier agente
  adapters/           Plantillas de adaptadores (referencia; algunas se instalan aparte)
  README.md           Guía rápida del proyecto generado

Próximos pasos tras ejecutar: ver scripts/README.md § «Después del bootstrap»
EOF
}

# ---------------------------------------------------------------------------
# Validación
# ---------------------------------------------------------------------------

preflight() {
  [[ -d "$ARCHETYPE" ]] || die "No se encuentra el arquetipo en: $ARCHETYPE"
  [[ -f "$ARCHETYPE/.agents/index.json" ]] || die "Arquetipo inválido: falta .agents/index.json"
  [[ -d "$ADAPTERS_SRC" ]] || die "Arquetipo inválido: falta adapters/"

  case "$ADAPTER" in
    all|none|cursor|copilot|claude|aider|continue) ;;
    *) die "Adaptador inválido: '$ADAPTER'. Usa --help para ver valores válidos." ;;
  esac
}

resolve_target() {
  mkdir -p "$TARGET"
  TARGET="$(cd "$TARGET" && pwd)"
  NAME="$(basename "$TARGET")"

  if [[ "$TARGET" == "/" ]]; then
    die "Refusing to bootstrap filesystem root."
  fi

  if [[ -n "$(ls -A "$TARGET" 2>/dev/null || true)" ]] && [[ ! -f "$TARGET/.agents/index.json" ]]; then
    log_warn "El destino no está vacío: $TARGET"
    log_warn "Se fusionará contenido del arquetipo con lo existente."
  fi
}

# ---------------------------------------------------------------------------
# Acciones
# ---------------------------------------------------------------------------

run() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log_verbose "[dry-run] $*"
  else
    log_verbose "$*"
    "$@"
  fi
}

copy_archetype() {
  log "Copiando arquetipo KARNITAS…"
  log_verbose "origen:  $ARCHETYPE/"
  log_verbose "destino: $TARGET/"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log_verbose "[dry-run] rsync/cp archetype → target"
    return
  fi

  if command -v rsync &>/dev/null; then
    rsync -a --exclude='.git' "$ARCHETYPE/" "$TARGET/"
  else
    cp -r "$ARCHETYPE/." "$TARGET/"
  fi

  mkdir -p "$TARGET/.agents/runtime/logs"
  touch "$TARGET/.agents/runtime/logs/.gitkeep"
}

personalize_project_name() {
  log_verbose "Personalizando nombre del proyecto: $NAME"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log_verbose "[dry-run] sed nombre-del-proyecto → $NAME"
    return
  fi

  if ! command -v sed &>/dev/null; then
    log_warn "sed no disponible; deja placeholders nombre-del-proyecto / {{PROJECT_NAME}} sin reemplazar."
    return
  fi

  local files=(
    "$TARGET/.agents/index.json"
    "$TARGET/README.md"
  )
  for f in "${files[@]}"; do
    [[ -f "$f" ]] || continue
    sed -i "s/nombre-del-proyecto/$NAME/g; s/{{PROJECT_NAME}}/$NAME/g" "$f" 2>/dev/null || true
  done
}

adapter_dest() {
  local id="$1"
  case "$id" in
    cursor)   echo ".cursor/rules/karnitas.mdc" ;;
    copilot)  echo "copilot-instructions.md" ;;
    claude)   echo "CLAUDE.md" ;;
    aider)    echo ".aider.conf.yml" ;;
    continue) echo ".continue/config.json" ;;
  esac
}

install_adapter() {
  local id="$1"
  local src dest

  case "$id" in
    cursor)
      src="$ADAPTERS_SRC/cursor/rules/karnitas.mdc"
      if [[ "$DRY_RUN" -eq 1 ]]; then
        log_verbose "[dry-run] mkdir .cursor/rules && cp karnitas.mdc"
      else
        mkdir -p "$TARGET/.cursor/rules"
        cp "$src" "$TARGET/.cursor/rules/karnitas.mdc"
      fi
      ;;
    copilot)
      src="$ADAPTERS_SRC/copilot/copilot-instructions.md"
      run cp "$src" "$TARGET/copilot-instructions.md"
      ;;
    claude)
      src="$ADAPTERS_SRC/claude/CLAUDE.md"
      run cp "$src" "$TARGET/CLAUDE.md"
      ;;
    aider)
      src="$ADAPTERS_SRC/aider/.aider.conf.yml"
      run cp "$src" "$TARGET/.aider.conf.yml"
      ;;
    continue)
      src="$ADAPTERS_SRC/continue/config.json"
      if [[ "$DRY_RUN" -eq 1 ]]; then
        log_verbose "[dry-run] mkdir .continue && cp config.json"
      else
        mkdir -p "$TARGET/.continue"
        cp "$src" "$TARGET/.continue/config.json"
      fi
      ;;
    *)
      die "Adaptador interno desconocido: $id"
      ;;
  esac

  log_verbose "adaptador '$id' → $(adapter_dest "$id")"
}

install_adapters() {
  case "$ADAPTER" in
    none)
      log_verbose "Sin adaptadores IDE (--adapter none)"
      return
      ;;
    all)
      log "Instalando adaptadores IDE/LLM (all)…"
      local id
      for id in "${ADAPTER_IDS[@]}"; do
        install_adapter "$id"
      done
      ;;
    *)
      log "Instalando adaptador: $ADAPTER…"
      install_adapter "$ADAPTER"
      ;;
  esac
}

print_success() {
  log ""
  log "╔══════════════════════════════════════════════════════════════╗"
  log "║  KARNITAS bootstrap OK                                       ║"
  log "╚══════════════════════════════════════════════════════════════╝"
  log ""
  log "  Proyecto:  $NAME"
  log "  Ruta:      $TARGET"
  log "  Adaptador: $ADAPTER"
  log ""
  log "  Estructura principal:"
  log "    .agents/index.json     — mapa de contexto (leer primero)"
  log "    .agents/core/          — constraints + directives (always_load)"
  log "    .agents/skills/        — fases SDD (SSOT, no duplicar en IDE)"
  log "    AGENTS.md              — entrypoint para agentes"
  log ""

  if [[ "$ADAPTER" != "none" ]]; then
    log "  Adaptadores instalados → enrutan a .agents/ (ver adapters/README.md):"
    local id
    for id in "${ADAPTER_IDS[@]}"; do
      if [[ "$ADAPTER" == "all" || "$ADAPTER" == "$id" ]]; then
        log "    • $(adapter_dest "$id")"
      fi
    done
    log ""
  fi

  log "  Próximos pasos:"
  log "    1. Editar .agents/core/constraints.md     (stack, prohibiciones)"
  log "    2. Editar .agents/governance/architecture.md"
  log "    3. Primera feature SDD:"
  log "         mkdir -p .agents/specs/001-mi-feature"
  log "         cp .agents/specs/_templates/spec-template.md \\"
  log "            .agents/specs/001-mi-feature/spec.md"
  log "    4. Tras aprobar spec → plan con skills/sdd_plan.md"
  log ""
  log "  Documentación: scripts/README.md · estándar: README.md del repo KARNITAS"
  log ""

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log_warn "Modo --dry-run: no se escribió ningún archivo."
  fi
}

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------

while [[ $# -gt 0 ]]; do
  case "$1" in
    --adapter)
      ADAPTER="${2:?Falta valor para --adapter}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -v|--verbose)
      VERBOSE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      die "Opción desconocida: $1 (usa --help)"
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

preflight
resolve_target
copy_archetype
personalize_project_name
install_adapters
print_success
