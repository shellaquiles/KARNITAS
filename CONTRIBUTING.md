# Contribuir

## Estructura

| Cambio | Dónde |
|--------|-------|
| Plantilla de proyecto | `archetype/` |
| Documentación del estándar | `README.md` |
| Bootstrap | `scripts/init-karnitas.sh` |

## Reglas

1. El arquetipo debe quedar **autocontenido** — sin referencias a historial del repo estándar
2. Una guía SDD: `archetype/.agents/knowledge/sdd.md`
3. `always_load` solo `core/constraints.md` + `core/directives.md`
4. Sin archivos vacíos ni duplicación entre README, AGENTS.md y sdd.md

## Verificar

```bash
./scripts/init-karnitas.sh /tmp/karnitas-test
test -f /tmp/karnitas-test/.agents/index.json
```
