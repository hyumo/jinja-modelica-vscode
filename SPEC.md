# jinja-modelica-vscode — Build Spec

## Goal
A minimal VSCode extension that provides **syntax highlighting only** for `*.mo.jinja2`, `*.mo.j2`, and `*.mo.jinja` files. These are Jinja2 templates that generate Modelica code. The highlighting should layer both syntaxes: Jinja2 delimiters (`{{ }}`, `{% %}`, `{# #}`) highlighted on top of Modelica syntax everywhere else.

No LSP, no linter, no TypeScript, no runtime dependencies.

---

## Final File Structure

```
jinja-modelica-vscode/
├── syntaxes/
│   └── jinja-modelica.tmLanguage.json
├── package.json
├── language-configuration.json
├── CHANGELOG.md
├── README.md
└── .vscodeignore
```

---

## File Specifications

### `package.json`

- `name`: `jinja-modelica`
- `displayName`: `Jinja Modelica`
- `description`: `Jinja2 + Modelica syntax highlighting for .mo.jinja2 templates`
- `version`: `0.1.0`
- `publisher`: `YOUR_PUBLISHER_ID` (placeholder, user will replace)
- `license`: `MIT`
- `engines.vscode`: `^1.85.0`
- `categories`: `["Programming Languages"]`
- `keywords`: `["modelica", "jinja", "jinja2", "template", "mo"]`
- No `main` entry — this is a grammar-only extension, no activation needed
- `repository`: placeholder `https://github.com/YOUR_ORG/jinja-modelica-vscode`
- `contributes.languages`: register language id `jinja-modelica` with extensions `.mo.jinja2`, `.mo.j2`, `.mo.jinja` and aliases `["Jinja Modelica", "jinja-mo"]`, pointing to `language-configuration.json`
- `contributes.grammars`: register grammar for `jinja-modelica` with scopeName `source.jinja.modelica`, path `./syntaxes/jinja-modelica.tmLanguage.json`, and `embeddedLanguages` mapping `source.modelica` → `modelica`
- `devDependencies`: only `@vscode/vsce`
- `scripts`: `"package": "vsce package"`

### `syntaxes/jinja-modelica.tmLanguage.json`

A TextMate grammar that layers Jinja2 on top of Modelica. Patterns in priority order:

1. **`jinja-comment`**: matches `{# ... #}`, scope `comment.block.jinja`
2. **`jinja-tag`**: matches `{%- ... -%}` / `{% ... %}`, scope `meta.tag.jinja`, punctuation scoped as `punctuation.definition.tag.jinja`, inner content includes `source.python`
3. **`jinja-variable`**: matches `{{- ... -}}` / `{{ ... }}`, scope `meta.variable.jinja`, punctuation scoped as `punctuation.definition.variable.jinja`, inner content includes `source.python`
4. **`modelica-body`**: fallthrough that includes `source.modelica`

All patterns support the optional `-` whitespace-control modifier on Jinja delimiters.

### `language-configuration.json`

Standard configuration for Modelica-like syntax:
- Line comment: `//`
- Block comment: `/* */`
- Brackets: `[]`, `()`, `{}`
- Auto-closing pairs for `"`, `'`, `(`, `[`, `{`

### `.vscodeignore`

Exclude from the packaged `.vsix`:
```
.vscode/**
.gitignore
*.md (except README.md)
```
Keep: `syntaxes/`, `package.json`, `README.md`, `language-configuration.json`

### `README.md`

Include:
- What the extension does
- Supported file extensions: `.mo.jinja2`, `.mo.j2`, `.mo.jinja`
- Prerequisites: a Modelica syntax extension must also be installed for the embedded Modelica highlighting to work. Recommended: [SimplyDanny.modelica](https://marketplace.visualstudio.com/items?itemName=SimplyDanny.modelica) or [JamesGoppert.rumoca-modelica](https://marketplace.visualstudio.com/items?itemName=JamesGoppert.rumoca-modelica)
- Manual file association fallback in `settings.json` if needed:
  ```json
  { "files.associations": { "*.mo.jinja2": "jinja-modelica" } }
  ```

### `CHANGELOG.md`

Standard format, single entry:
```
## [0.1.0] - initial release
- Jinja2 + Modelica dual syntax highlighting
- Supports .mo.jinja2, .mo.j2, .mo.jinja
```

---

## How to Build and Publish

### Local install for testing
```bash
npm install        # installs vsce only
vsce package       # produces jinja-modelica-0.1.0.vsix
code --install-extension jinja-modelica-0.1.0.vsix
```

### Publish to VS Code Marketplace
1. Create a publisher at https://marketplace.visualstudio.com/manage
2. Replace `YOUR_PUBLISHER_ID` in `package.json` with your publisher name
3. Generate a Personal Access Token (PAT) from Azure DevOps with Marketplace scope
4. Run:
```bash
vsce login YOUR_PUBLISHER_ID
vsce publish
```

### Optional: GitHub Actions auto-publish on tag
Create `.github/workflows/publish.yml`:
```yaml
name: Publish
on:
  push:
    tags: ['v*']
jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: '20' }
      - run: npm ci
      - run: npx vsce publish -p ${{ secrets.VSCE_PAT }}
```
Add `VSCE_PAT` as a GitHub Actions secret.

---

## Notes for Implementation

- The grammar depends on `source.modelica` being available from another installed extension. If it isn't installed, Modelica tokens simply won't be colored — the extension won't error.
- The grammar similarly depends on `source.python` for Jinja expression content. This is available by default in VSCode (Python extension ships it).
- Do NOT add a `main` field to `package.json` — grammar-only extensions need no entry point and no activation event.
- The `.vsix` should be only a few KB.
