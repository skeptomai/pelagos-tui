# pelagos-tui Quickstart

## Prerequisites

- [pelagos](https://github.com/pelagos-containers/pelagos) built and on `$PATH`
- Rust toolchain (stable)

## Build and Install

```bash
git clone https://github.com/pelagos-containers/pelagos-tui
cd pelagos-tui
./scripts/install.sh          # installs to /usr/local/bin
# or: ./scripts/install.sh ~/bin  for a custom directory
```

The script builds a release binary and installs it. It uses sudo only for
the copy step if you are not root.

---

## Linux Manual Testing

### 1. Verify `pelagos subscribe` works

In one terminal:

```bash
pelagos subscribe
```

You should immediately see a snapshot line on stdout:

```json
{"type":"snapshot","containers":[],"vm_running":true}
```

Leave this running. In a second terminal:

```bash
pelagos run --detach --name test1 alpine /bin/sleep 60
```

The subscribe terminal should print within 250ms:

```json
{"type":"container_started","container":{"name":"test1","status":"running",...}}
```

Stop the container:

```bash
pelagos stop test1
```

Subscribe should print:

```json
{"type":"container_exited","name":"test1","exit_code":0}
```

Ctrl-C to exit subscribe. Clean up:

```bash
pelagos rm -f test1
```

### 2. Run the TUI

```bash
pelagos-tui
```

Expected:
- TUI opens in the alternate screen
- Container list shows running containers (empty if none are running)
- Press `a` to toggle showing stopped containers
- Start a container in another terminal — the TUI updates within ~250ms
- Stop a container — the TUI reflects the exit within ~250ms

### Key bindings

| Key | Action |
|-----|--------|
| `a` | Toggle show all / running only |
| `Enter` | Inspect selected container |
| `s` | Stop container |
| `r` | Restart container |
| `d` | Remove container |
| `i` | Image management screen |
| `q` / `Esc` | Quit / back |

### 3. Things to verify on Linux

- [ ] `pelagos subscribe` emits valid NDJSON with no `--profile` argument error
- [ ] TUI launches without errors
- [ ] Container list populates correctly
- [ ] Starting a container updates the TUI in real time
- [ ] Stopping a container updates the TUI in real time
- [ ] `a` toggle shows/hides exited containers
- [ ] Inspect overlay shows container details
- [ ] `q` exits cleanly (terminal is restored)

---

## Rootless vs Root

pelagos is rootless-first. Both modes work:

```bash
# Rootless (recommended)
pelagos run --detach alpine /bin/sleep 60

# Root
sudo pelagos run --detach alpine /bin/sleep 60
```

pelagos-tui reads state from the same XDG directories pelagos writes to, so
it works in whichever mode you run pelagos.

---

## Troubleshooting

**TUI shows no containers even though containers are running**

Check that `pelagos ps` works from the same shell. The TUI uses `pelagos subscribe`
which reads the same state directory. If `pelagos ps` returns nothing, the runtime
state dir may be in a different location (check `$XDG_RUNTIME_DIR`).

**`pelagos subscribe` exits immediately**

Check that the pelagos binary on your PATH is the version that includes the
`subscribe` subcommand:

```bash
pelagos subscribe --help
```

If you see "unrecognized subcommand", rebuild pelagos from the current main branch.

**TUI crashes or leaves terminal in bad state**

Run `reset` to restore your terminal. File an issue with the panic message if
you have one.
