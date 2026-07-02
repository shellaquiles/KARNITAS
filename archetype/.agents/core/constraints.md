# Restricciones

Completar al iniciar. Si no está aquí, el agente no lo asume.

## Stack

| Área | Tecnología |
|------|------------|
| Lenguaje | _definir_ |
| Framework | _definir_ |
| Datos | _definir_ |

## Prohibido

- Dependencias no listadas arriba o en `governance/`
- Secretos o PII en `.agents/`
- Código de feature sin `specs/NNN-nombre/spec.md` aprobada
- Contradecir `memory/ADRs/`

## Reglas

- Cambio de comportamiento → actualizar spec en el mismo PR
- Cambio arquitectónico → ADR
- Bug recurrente resuelto → `memory/known_issues.md`
- Nueva dependencia → documentar en `governance/` antes de merge

## Fallo seguro

Sin contexto suficiente → detenerse. No inventar stack ni APIs.
