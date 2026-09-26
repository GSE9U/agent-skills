# agent-skills

Mis skills para Claude Code, Codex y Hermes, en una sola carpeta. Las tres herramientas usan el mismo formato `SKILL.md` ([agentskills.io](https://agentskills.io)), así que una misma skill sirve para las tres.

## Instalar en un equipo

```bash
git clone https://github.com/GSE9U/agent-skills.git ~/agent-skills
cd ~/agent-skills
./install.sh                 # macOS / Linux / WSL
# Windows (PowerShell):  powershell -ExecutionPolicy Bypass -File .\install.ps1
```

El script enlaza cada skill en:

- `~/.agents/skills/`: aquí la lee Codex.
- `~/.claude/skills/`: aquí la lee Claude Code.

Solo crea enlaces. Si ya tienes una skill tuya con el mismo nombre, la deja como está.

Hermes necesita una sola línea en `~/.hermes/config.yaml`:

```yaml
skills:
  external_dirs:
    - ~/.agents/skills
```

Orca no necesita nada: lanza Claude Code y Codex en el mismo equipo, así que las skills ya les llegan.

Para actualizar un equipo: `git pull && ./install.sh`.

## Qué hay dentro

Las que tienen ✋ solo se ejecutan cuando las llamas tú (`/nombre` en Claude Code, `$nombre` en Codex). Las demás el agente las usa solo cuando le parece que tocan.

**Planificar**
| Skill | Para qué |
|---|---|
| `grill-me` ✋ | Te acribilla a preguntas hasta que el plan no tiene huecos |
| `grill-with-docs` ✋ | Igual, pero va apuntando el vocabulario y las decisiones en `CONTEXT.md` y ADRs |
| `grilling` | La parte común de las dos anteriores (no la borres) |
| `domain-modeling` | Mantiene el glosario del proyecto y las decisiones de arquitectura |
| `to-spec` ✋ | Convierte la conversación en un spec (necesita `setup-matt-pocock-skills`) |
| `prototype` | Hace prototipos de usar y tirar para resolver dudas de diseño |

**Construir**
| Skill | Para qué |
|---|---|
| `implement` ✋ | Implementa un spec con TDD y lo revisa al terminar |
| `tdd` | Ciclo rojo, verde y refactor |
| `diagnosing-bugs` | Depura con un orden fijo: reproducir, acotar, formular hipótesis y arreglar |
| `codebase-design` | Módulos profundos con interfaces pequeñas |
| `create-cli` | Diseña herramientas de terminal: flags, ayuda, errores |
| `resolving-merge-conflicts` | Resuelve conflictos trozo a trozo según lo que buscaba cada cambio (útil al fusionar worktrees de Orca) |

**Revisar**
| Skill | Para qué |
|---|---|
| `code-review` | Revisa en paralelo si el código cumple el estilo del repo y si hace lo que pedía el spec |
| `thermo-nuclear-code-quality-review` ✋ | Revisión de mantenibilidad sin piedad |

**Front / UI**
| Skill | Para qué |
|---|---|
| `make-interfaces-feel-better` | Tipografía, superficies, iconos, animaciones y rendimiento |
| `emil-design-eng` | La filosofía de Emil Kowalski sobre pulir interfaces |
| `review-animations` ✋ | Revisa animaciones contra unos estándares |
| `animation-vocabulary` | Pones en palabras "ese efecto que rebota" y te dice cómo se llama |
| `pick-ui-library` ✋ | Qué librería usar para cada cosa (toasts, gráficos, drag and drop…) |

**Otras**
| Skill | Para qué |
|---|---|
| `handoff` ✋ | Resume la sesión en un documento para seguir en otro agente o en otro equipo |
| `setup-matt-pocock-skills` ✋ | Hay que ejecutarla una vez en cada repo antes de usar `to-spec`, `implement` o `code-review` |

## Primera vez en un proyecto

Ejecuta `/setup-matt-pocock-skills`. Cuando te pregunte por el issue tracker:

- **Local markdown**: los issues y specs se guardan como archivos en `.scratch/`. Es lo mejor mientras no tengas GitHub.
- **GitLab**: si el repo está en GitLab.
- **GitHub**: para los repos del trabajo.

## Añadir tus propias skills

Crea la carpeta `skills/<nombre>/SKILL.md`, ejecuta `./install.sh` y haz commit. La skill `skill-creator` de Anthropic te ayuda a escribirlas y a probarlas.

## Actualizar las de terceros

```bash
./scripts/sync-upstream.sh   # vuelve a bajar las que aparecen en scripts/sources.txt
git diff                     # revisa qué ha cambiado ANTES de hacer commit
```

Para añadir o quitar una skill de terceros, edita `scripts/sources.txt`. De dónde viene cada una y en qué commit está en [`SOURCES.md`](SOURCES.md). Todas tienen licencia MIT y las licencias están en `LICENSES/`.

## Notas

- Claude Code trae un `/code-review` propio. Si te molesta que se pisen, renombra la carpeta y el `name:` de la skill (por ejemplo, `review-two-axis`) y cambia la referencia en `implement/SKILL.md`.
- Las skills de trabajo que dependan de un repo concreto van en el `.agents/skills/` de ese repo, no aquí.
