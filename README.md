# pelagos-tui

Terminal UI for the [pelagos](https://github.com/skeptomai/pelagos) container runtime.

**Status: Pre-implementation.** The architecture is defined; extraction from
[pelagos-mac](https://github.com/skeptomai/pelagos-mac) is in progress.
See [docs/EPIC-pelagos-tui.md](https://github.com/skeptomai/pelagos-mac/blob/main/docs/EPIC-pelagos-tui.md)
in the pelagos-mac repo for the full design.

---

## What This Is

pelagos-tui is the terminal user interface for pelagos — a Ratatui-based
interactive UI for managing container images and running containers. It is
intentionally separate from both the runtime (pelagos) and the macOS VM
layer (pelagos-mac), because user experience is neither the runtime's
concern nor Mac-specific.

---

## Platform Support

| Platform | Transport | Status |
|---|---|---|
| macOS (Apple Silicon) | vsock → pelagos-guest → VM | Extraction in progress |
| Linux (aarch64, x86_64) | subprocess → pelagos binary | Planned |

---

## Architecture

pelagos-tui depends on a `PelagosClient` trait defined in the pelagos crate.
Platform-specific code provides the concrete implementation:

```
pelagos-tui
  └── PelagosClient (trait, in pelagos)
        ├── MacPelagosClient  (in pelagos-mac)
        │     vsock → pelagos-guest → VM → pelagos binary
        └── SubprocessClient  (in pelagos or pelagos-tui)
              pelagos CLI with --format json
```

The TUI has no knowledge of transports, sockets, or VM lifecycle. It calls
the client trait and renders what comes back.

---

## Related Repositories

| Repo | Role |
|---|---|
| [pelagos](https://github.com/skeptomai/pelagos) | Linux container runtime; defines `PelagosClient` trait |
| [pelagos-mac](https://github.com/skeptomai/pelagos-mac) | macOS VM layer; provides `MacPelagosClient` impl; currently hosts the TUI (being extracted) |

---

## License

Apache License, Version 2.0. See [LICENSE](LICENSE).
