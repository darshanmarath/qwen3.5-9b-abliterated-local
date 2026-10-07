# Voice sample script

Read this aloud in a quiet room, at your normal pace, about a hand's width
from the microphone. Do not perform it. Talk the way you talk in a meeting.

## Part 1: the reference line

The local voice model uses only this line. It needs 5 to 10 seconds, and it
needs the exact words, so read it as written.

> Hi, I'm Darshan. I design products where people and AI have to understand
> each other, and I like to keep things clear, calm and honest.

## Part 2: the longer sample

For a hosted voice, which benefits from more material. Carry straight on.

> When I start a project, I ask what the person is trying to get done, and
> what gets in their way. Sometimes the answer is a screen. Often it is a
> sentence. Does this make sense? Is it too much? What would you cut first?
> I would rather ship something small that people trust than something big
> that they have to double-check. Numbers help: three interviews, fifteen
> responses, two weeks. Then I write down what I found, and what I still
> do not know.

## Recording it on a Mac

1. Open QuickTime Player. File, New Audio Recording.
2. Record Part 1 on its own. Save it as `ref.m4a`.
3. Move it to `athena/voice/private/`. That folder is never committed.
4. Run `./speak.sh --prep private/ref.m4a` to convert it.
