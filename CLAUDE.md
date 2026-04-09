# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A grammar-only VS Code extension — no TypeScript, no activation, no tests. The entire logic lives in `syntaxes/jinja-modelica.tmLanguage.json`.

## Build

```bash
npm install        # installs @vscode/vsce only
npm run package    # produces jinja-modelica-0.1.0.vsix
```

## Architecture

The extension registers a single TextMate grammar (`source.jinja.modelica`) that layers Jinja2 on top of Modelica. Pattern priority in the grammar:

1. `jinja-comment` — `{# #}` → `comment.block.jinja`
2. `jinja-tag` — `{% %}` → `meta.tag.jinja`, inner content delegates to `source.python`
3. `jinja-variable` — `{{ }}` → `meta.variable.jinja`, inner content delegates to `source.python`
4. `modelica-body` — fallthrough, delegates to `source.modelica`

Both `source.modelica` and `source.python` are injected from other installed extensions at runtime — this extension provides no grammar for them.

File associations (`.mo.jinja2`, `.mo.j2`, `.mo.jinja`) are declared in `package.json` under `contributes.languages`. The `language-configuration.json` handles comment tokens and bracket pairs for the editor.

## Testing locally

Launch the Extension Development Host: open the repo in VS Code and press `F5` (or `Fn+F5` on Mac). The `.vscode/launch.json` is already configured. To iterate on the grammar, reload the dev host window with **Developer: Reload Window**. Use **Developer: Inspect Editor Tokens and Scopes** to verify scopes on any token.
