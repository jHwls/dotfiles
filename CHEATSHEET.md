# Chezmoi

## Commands

### Inspecting state

See what's managed and how it differs from what's on disk.

- `chezmoi status` — show which managed files differ between the source and home directory.
- `chezmoi managed` — list every file chezmoi manages in home directory.
- `chezmoi diff <path>` — line-by-line diff for a managed file.
- `chezmoi cat <path>` — render a managed file and print the result without writing it anywhere.
- `chezmoi source-path [path]` — print the source directory, or the source file backing a given target path.

### Updating the source from home (home → source)

Pull live changes back into the source dir so they can be committed.

- `chezmoi add <path>` — copy into the source dir & manage.
- `chezmoi re-add <path>` — update the source from the current live file.
- `chezmoi edit <path>` — open the source of a managed file in editor.

### Applying source to home (source → home)

Push source changes out to the live filesystem.

- `chezmoi apply [path...]` — write source changes out to home directory; omit paths to apply everything.

### Working in the source repo

Drop into the source dir or run git against it without leaving the current shell.

- `chezmoi cd` — open a subshell in the source directory.
- `chezmoi git -- <args>` — run git inside the source directory (put `--` before any git flags).

### Config & meta

Regenerate config from templates and check the install.

- `chezmoi init` — regenerate `~/.config/chezmoi/chezmoi.toml` from `.chezmoi.toml.tmpl` (run after editing the config template).
- `chezmoi --version` — print the installed chezmoi version.

## Auto-commit & auto-push

chezmoi can commit (and push) source-dir changes for you with an auto-generated
message. Set under `[git]` in `.chezmoi.toml.tmpl`, then run `chezmoi init` to
regenerate the real config.

- `autoCommit = true` — after any chezmoi-made change to the source dir, commit it with a generated message (`Add dot_x` / `Update dot_x` / `Remove dot_x`). No template needed.
- `autoPush = true` — also `git push` after committing (implies `autoCommit`). Avoid on public repos that may hold secrets.
- `autoAdd = true` — stage changes into the source state automatically.
- `commitMessageTemplate = "<go-template>"` — override the generated message with your own string.
- `commitMessageTemplateFile = "<path>"` — same, read from a file relative to the source dir.

Triggers on `chezmoi add`, `re-add`, `edit`, `update` — anything that writes the
source dir. Not on `chezmoi apply` (that writes home, not source).

Message templates iterate `.chezmoi.status` (`.Ordinary`, `.RenamedOrCopied`,
`.Unmerged`, `.Untracked`); each entry exposes `.X`, `.Y`, `.Path`, `.OrigPath`.

Example `[git]` block for `.chezmoi.toml.tmpl`:

```toml
[git]
    autoCommit = true
    autoPush = true
```
