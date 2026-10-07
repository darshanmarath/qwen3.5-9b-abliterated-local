# Athena's voice

Voice has three separate jobs. Each has its own tool, and each has a
different answer to "where does the audio go?"

| Job | Tool | Where it runs | Set up by |
| --- | --- | --- | --- |
| The designer talks to Athena | Wispr Flow | Cloud | Install the app; nothing on Athena's side |
| Interview recordings become transcripts | whisper.cpp | This Mac | [`transcribe.sh`](transcribe.sh) |
| Athena speaks in the designer's voice | F5-TTS (MLX) | This Mac | [`speak.sh`](speak.sh) |
| The same voice, hosted, for videos and demos | Higgsfield | Cloud | Recorded in Higgsfield's own voice recorder |

## 1. Talking to Athena: Wispr Flow

Wispr Flow is a dictation app. Hold its hotkey, speak, and it types into
whatever window is in front, including the terminal Codex runs in. Athena
receives ordinary text and needs no changes.

Wispr Flow sends audio to its own servers. That is fine for instructions
("draft the invites for the people marked to invite"). **Do not dictate a
participant's name, email or answers.** Type those, or point Athena at the
file.

## 2. Interview transcripts: whisper.cpp

Recordings of participants are participant data, so they are transcribed
on this Mac and never uploaded. This keeps the promise in
[`../study/consent.md`](../study/consent.md).

One-time setup:

```bash
brew install whisper-cpp ffmpeg
mkdir -p ~/Models/whisper
curl -L -o ~/Models/whisper/ggml-large-v3-turbo.bin \
  https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-large-v3-turbo.bin
```

Then, for each interview:

```bash
./transcribe.sh ~/Desktop/interview-p03.m4a P03
```

The transcript lands in `../study/private/transcripts/P03.txt`. Whisper
does not label who is speaking, so the transcript is one stream of text.
The interviewer skill files it from there.

Record only with the participant's spoken consent. Delete the recording
once the transcript is checked.

## 3. Athena speaks in your voice: F5-TTS

F5-TTS copies a voice from a 5 to 10 second clip plus the exact words
spoken in it. It runs on Apple Silicon through MLX.

1. Record the reference line in [`sample-script.md`](sample-script.md).
2. One-time setup:
   ```bash
   brew install ffmpeg
   python3 -m venv ~/.venvs/athena-voice
   ~/.venvs/athena-voice/bin/pip install f5-tts-mlx
   ```
3. Convert the recording: `./speak.sh --prep private/ref.m4a`
4. Speak: `./speak.sh "Three invites are ready for you to read."`

The first run downloads the voice model. If memory is tight while the Qwen
model is also loaded, stop `llama-server` first, or add `--q 4` to the
last line of `speak.sh` to use a smaller version of the voice model.

Athena can run `speak.sh` itself to read a report aloud when asked.

## 4. The hosted copy: Higgsfield

A second copy of the voice lives in Higgsfield, for narrating case-study
videos and demos. It is made in Higgsfield's own recorder, from the longer
passage in [`sample-script.md`](sample-script.md). Speech generated there
costs credits, so the Higgsfield skill's "ask before you spend" rule
applies.

## Rules for the voice

- The voice belongs to the designer. Athena uses it only when the designer
  asks, and only to speak to the designer or to narrate the designer's own
  work.
- Athena never uses the voice to speak to a participant, a client or
  anyone else as if the designer were talking live.
- Anything published with the cloned voice says it is a synthetic voice.
- The voice sample stays in `private/`, which is never committed.
- Participant recordings and transcripts never go to Wispr Flow,
  Higgsfield or any other online service.
