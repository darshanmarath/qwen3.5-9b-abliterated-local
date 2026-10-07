# Qwen3.5 9B Abliterated — local GGUF setup

Run notes, launch script and Codex CLI config for two local GGUF builds of
Qwen3.5 9B Abliterated, served with [llama.cpp](https://github.com/ggml-org/llama.cpp).

**The weights are not in this repository.** They are far above GitHub's
100 MB file limit, so `.gitignore` excludes them. This repo documents how the
models are run and built.

## Models

| File | Precision | Size |
| --- | --- | --- |
| `Qwen3.5-9B-abliterated-Q4_K_M.gguf` | 4-bit (Q4_K_M) | 5.63 GB |
| `Qwen3.5-9B-abliterated-F16.gguf` | 16-bit float (F16) | 17.92 GB |

Details read from the GGUF metadata:

- Name: Qwen3.5 9B Abliterated
- Architecture: `qwen35`
- Base model: [Qwen/Qwen3.5-9B](https://huggingface.co/Qwen/Qwen3.5-9B)
- License: Apache-2.0

Both files are expected in `~/Models`.

## Model in use

`Q4_K_M` is the default in `run.sh`. It is the smaller and faster of the two
and leaves memory free for a large context window. `F16` is the full-precision
build.

## Run

```bash
./run.sh        # Q4_K_M
./run.sh f16    # F16
```

This is equivalent to:

```bash
llama-server \
  -m ~/Models/Qwen3.5-9B-abliterated-Q4_K_M.gguf \
  --alias qwen3.5-9b \
  --ctx-size 32768 \
  --parallel 1 \
  --port 8080 \
  --jinja \
  -ngl 99
```

| Flag | Why |
| --- | --- |
| `--ctx-size 32768` | Coding agents send long instructions and tool definitions; 4096 is too small. |
| `--parallel 1` | More slots split the context window between them. |
| `--jinja` | Uses the model's chat template, needed for tool calling. |
| `--alias qwen3.5-9b` | The model name clients ask for. |
| `-ngl 99` | Offloads all layers to the GPU (Metal on a Mac). |

`MODELS_DIR`, `CTX_SIZE` and `PORT` can be overridden as environment variables.

Check the server is up:

```bash
curl http://127.0.0.1:8080/v1/responses \
  -H "Content-Type: application/json" \
  -d '{"model":"qwen3.5-9b","input":"Say hi"}'
```

## Connect to Codex CLI

Codex talks to custom providers over the Responses API, so llama.cpp needs to
be a 2026 build (`brew upgrade llama.cpp`).

1. Install Codex: `npm install -g @openai/codex`
2. Copy the contents of [`codex/config.toml`](codex/config.toml) into `~/.codex/config.toml`
3. Start the server with `./run.sh`
4. In a project folder, run `codex --profile local`

## Athena

To start everything on a Mac, double-click `Start Athena.command`.

[`athena/`](athena) holds the guiding documents for Athena, a UX research
and design agent that runs on this model. It drafts participant emails,
writes surveys, sorts responses into themes, and works with Mobbin, Figma
and Higgsfield. Start with [`athena/README.md`](athena/README.md).

## What it looks like

**Meet Athena**, the scripted first meeting embedded in the portfolio case
study. A red ring forms around each voice as it speaks.

![Meet Athena panel with rings around the voices that have spoken](docs/images/meet-athena-hero.png)

**Athena's space**, the local page for talking with the council. On your own
machine an ambient video plays behind it; that video is not part of this repo.

![Athena's space: a conversation between Athena, Hermes, Clio and Gaia](docs/images/athena-space.png)

**Character identity chart**, built in Figma. This is the first version, from
before the roles took their Greek names and Gaia joined.

![Athena character identity chart](docs/images/athena-character-chart.png)

**The case study page**, as first drafted in the portfolio.

![The Athena case study page](docs/images/portfolio-case-study.png)

## Build process

_To be added._
