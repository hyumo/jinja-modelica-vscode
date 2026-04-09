# Jinja Modelica

Syntax highlighting for Jinja2 templates that generate Modelica code.

## Features

Layers Jinja2 delimiter highlighting on top of Modelica syntax:
- `{{ ... }}` — variable expressions
- `{% ... %}` — tags / control flow
- `{# ... #}` — comments

## Supported File Extensions

| Extension | Example |
|---|---|
| `.mo.jinja2` | `model.mo.jinja2` |
| `.mo.j2` | `model.mo.j2` |
| `.mo.jinja` | `model.mo.jinja` |

## Prerequisites

This extension depends on an external Modelica grammar for the embedded Modelica highlighting. Install one of:

- [SimplyDanny.modelica](https://marketplace.visualstudio.com/items?itemName=SimplyDanny.modelica)
- [JamesGoppert.rumoca-modelica](https://marketplace.visualstudio.com/items?itemName=JamesGoppert.rumoca-modelica)

If neither is installed, Jinja2 delimiters will still be highlighted — only the Modelica tokens outside them won't be colored.

Python syntax (used for Jinja2 expression content) is provided by VS Code's built-in Python extension.

## Development

### Run locally (no build step)

1. Open this repo in VS Code: `code .`
2. Press `F5` (or `Fn+F5` on Mac) — launches an Extension Development Host window with the extension loaded from source
3. Open any `.mo.jinja2` file in that window to test highlighting

To iterate: edit the grammar in `syntaxes/jinja-modelica.tmLanguage.json`, then in the dev host window run `Ctrl+Shift+P` → **Developer: Reload Window**.

### Inspect token scopes

Place the cursor on any token and run `Ctrl+Shift+P` → **Developer: Inspect Editor Tokens and Scopes** to verify which TextMate scopes are applied.

### Build a .vsix for local install

```bash
npm install
npm run package
code --install-extension jinja-modelica-0.1.0.vsix
```

## Manual File Association

If VS Code doesn't automatically recognize your files, add this to your `settings.json`:

```json
{
  "files.associations": {
    "*.mo.jinja2": "jinja-modelica",
    "*.mo.j2": "jinja-modelica",
    "*.mo.jinja": "jinja-modelica"
  }
}
```

## Publisher

https://marketplace.visualstudio.com/manage/publishers/hyumo
