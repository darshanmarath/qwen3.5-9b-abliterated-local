# Athena

Athena is a UX research and design agent that runs on the local
Qwen3.5 9B Abliterated model in this repo. It does the routine work of a
small UX team: drafting participant emails, writing surveys, sorting
responses into themes, finding UI references, working in Figma and
generating visuals. A person approves every message and every conclusion.

## How it is built

| Layer | What | Where |
| --- | --- | --- |
| Model | Qwen3.5 9B Abliterated (GGUF), served by `llama-server` | [`../run.sh`](../run.sh) |
| Runner | Codex CLI, pointed at the local server | [`codex-config.toml`](codex-config.toml) |
| Instructions | Who Athena is, how it works, its rules | [`AGENTS.md`](AGENTS.md) |
| Roles | One step-by-step skill per job | [`skills/`](skills) |
| Tools | Mobbin, Figma and Higgsfield, over MCP | [`codex-config.toml`](codex-config.toml) |
| Study | The first research study Athena supports | [`study/`](study) |
| Voice | Dictation in, local transcription, speech out in the designer's own voice | [`voice/`](voice) |

**Format versus engine.** The agent definition and the skills follow the
conventions Claude uses: a markdown file with `name` and `description`
frontmatter, where the description says when to use it. Codex reads the same
skill format. The engine is the local Qwen model, not Claude, and Athena is
instructed to say so.

**One model, one voice at a time.** The council is not six programs. It is
one small model that speaks as one voice, finishes, then speaks as the next.
Narrow, ordered steps are what a 9B model can follow.

## The council

Six voices with Greek names. One speaks at a time, each in its own tone.
The rules for how they talk are in [`AGENTS.md`](AGENTS.md) and
[`athena-council`](skills/athena-council/SKILL.md).

| Voice | Job | Tone | Never does |
| --- | --- | --- | --- |
| Athena | Leads, offers options, asks questions | Calm, curious | Gives one answer dressed as a choice |
| Hermes | Recruiter ([skill](skills/athena-recruiter/SKILL.md)) | Quick, warm | Sends an email |
| Clio | Interviewer ([skill](skills/athena-interviewer/SKILL.md)) | Careful, exact | Writes an answer for someone |
| Apollo | Synthesist ([skill](skills/athena-synthesist/SKILL.md)) | Clear, analytical | Recommends a design |
| Hephaestus | Designer ([Mobbin](skills/athena-mobbin-research/SKILL.md), [Figma](skills/athena-figma-design/SKILL.md), [Higgsfield](skills/athena-higgsfield-media/SKILL.md)) | Practical | Spends or edits without a yes |
| Gaia | Reviews every suggestion ([skill](skills/athena-gaia/SKILL.md)) | Steady, kind | Drops an idea without a reason |

Athena also keeps a [notebook](notebook.md) of what she learns about the
designer, and may ask one question per reply about anything she is curious
about.

## Files

| File | Purpose |
| --- | --- |
| [`AGENTS.md`](AGENTS.md) | Athena's instructions, in the file name Codex loads |
| [`athena.md`](athena.md) | The same instructions as a Claude-format agent definition, with `name`, `description` and `tools` |
| [`skills/`](skills) | The eight skills: six role playbooks, Gaia's review, and the council |
| [`notebook.md`](notebook.md) | What Athena has learned about the designer |
| [`space/`](space) | A local page for talking with the council, over an ambient video |
| [`codex-config.toml`](codex-config.toml) | The Codex profile and the three tool connections |
| [`study/plan.md`](study/plan.md) | Study 1: questions, participants, steps, data handling |
| [`study/consent.md`](study/consent.md) | The consent text |
| [`study/survey.md`](study/survey.md) | The ten-question survey |
| [`study/interview-guide.md`](study/interview-guide.md) | The 20-minute interview script |
| [`study/invite-email.md`](study/invite-email.md) | The invite template |
| [`voice/README.md`](voice/README.md) | How Athena listens and speaks, and where the audio goes |
| [`voice/transcribe.sh`](voice/transcribe.sh) | Transcribes an interview recording on this Mac |
| [`voice/speak.sh`](voice/speak.sh) | Speaks text in the designer's cloned voice, on this Mac |
| [`voice/sample-script.md`](voice/sample-script.md) | What to read when recording the voice sample |

`AGENTS.md` and `athena.md` share one body. Change both together.

## Email

Athena does not connect to an inbox. The recruiter writes each email as a
file in `study/private/outbox/`. The designer copies it into their own
email, edits it and sends it. Replies are pasted back for the interviewer
to file. This keeps a small model with no built-in refusals away from the
send button, and keeps the inbox out of its reach.

## Participant data

Everything about real people lives in `study/private/`. That folder is in
`.gitignore`, so it never reaches GitHub. Responses are filed under ids
(P01, P02), not names. The model reading them runs on this computer.
Figma, Higgsfield and Mobbin are online services, so Athena is told never
to put names, emails or raw responses into them.

## Set up

The quick way, from the repo root: `./athena/install.sh`. It does steps 2
and 3 below, backs up anything it replaces, and lists what is still
missing. It is safe to run again.

By hand:

1. Start the model: `../run.sh`
2. Install the instructions and skills:
   ```bash
   mkdir -p ~/.codex ~/.agents/skills
   cp AGENTS.md ~/.codex/AGENTS.md
   cp -R skills/athena-* ~/.agents/skills/
   ```
   `~/.codex/AGENTS.md` applies to every Codex session. To keep Athena to
   one project, copy `AGENTS.md` into that project's root folder instead.
3. Append `codex-config.toml` to `~/.codex/config.toml`.
4. Sign in to each tool once. Each opens a browser window:
   ```bash
   codex mcp login mobbin
   codex mcp login figma
   codex mcp login higgsfield
   ```
5. From this repo's root, start Athena: `codex --profile athena`
6. Inside Codex, run `/mcp` and check the three servers and their tools are
   listed. If a tool name differs from the one in `codex-config.toml` or in
   a skill, correct it in both places.

## Limits

- **Small model.** A 9B model follows short, ordered steps and loses track
  on long, open tasks. Give Athena one role and one job at a time.
- **Context.** 32,768 tokens holds the instructions, the tool definitions
  and the conversation. Twenty long responses will not fit at once, which
  is why the synthesist reads one response at a time. With memory to
  spare, start the server with `CTX_SIZE=65536 ../run.sh` and set
  `model_context_window` to match.
- **No built-in refusals.** The model is abliterated, so the rules in
  `AGENTS.md` are the only guardrails.
- **Untested.** These documents describe the intended setup. Whether the
  model follows them is what Study 1 measures.
