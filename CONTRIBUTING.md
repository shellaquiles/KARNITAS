# Contribuir a KARNITAS

KARNITAS es una propuesta abierta (RFC). Las contribuciones deben mantener el estándar **agnóstico** y **KISS**.

## Qué va dónde

| Cambio | Ubicación |
|--------|-----------|
| Arquetipo bootstrap | `archetype/` |
| Estándar y documentación | `README.md` |
| Script de init | `scripts/init-karnitas.sh` |

No duplicar contenido entre `README.md`, `AGENTS.md` y `knowledge/sdd.md`.

## Principios de contribución

1. **Una SSOT** — Todo contexto de agentes en `.agents/`
2. **Token economy** — `always_load` solo `core/constraints.md` + `core/directives.md`
3. **Una guía SDD** — `knowledge/sdd.md`
4. **Sin stubs vacíos** — Si un archivo no aporta valor, no existe
5. **Documentar el por qué** — ADRs en `memory/ADRs/`

## Proceso

1. Fork del repositorio
2. Rama descriptiva: `feat/`, `fix/`, `docs/`
3. Verificar bootstrap:

```bash
./scripts/init-karnitas.sh /tmp/karnitas-test
test -f /tmp/karnitas-test/.agents/index.json
```

4. Abrir PR con descripción clara del problema y la solución

## Definition of Done (PR al estándar)

- [ ] `init-karnitas.sh` funciona
- [ ] `index.json` válido y rutas existentes
- [ ] Sin referencias rotas en documentación
- [ ] Versiones alineadas en `README.md` y `archetype.json`
