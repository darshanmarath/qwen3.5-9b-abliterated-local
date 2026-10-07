# First-encounter test: meeting Athena on the portfolio

Status: built, not yet live. No visitor has seen it.

## What it is

An unmoderated first-impression test, embedded in the Athena case study.
A visitor scrolls into a panel and Athena introduces herself through a
short, pre-written chat. The visitor picks what to ask. Athena then asks one
question back.

## What we want to learn

1. Do people understand what Athena is after her first three lines?
2. Which question do people ask first? (what she does, what she won't do,
   who else is there, why trust her)
3. What would people hand to an agent like her?
4. Does saying "this is a script" up front help or hurt trust?

## What the intro covers, and why

Patterns taken from first-run screens of AI products on Mobbin
(AirOps, Delphi, Basecamp, Devin, Klaviyo):

| Pattern | Where seen | How Athena uses it |
| --- | --- | --- |
| One line of who the agent is, before any input | AirOps | "I'm Athena." then her job in one sentence |
| A disclosure placed where you can't miss it | Klaviyo, Basecamp | Line three says this is a script |
| One action at a time | Delphi | Only the choices for the current step are shown |
| Starter choices instead of an empty box | AirOps, Copilot | Four questions to pick from |
| A short, visible sequence | Devin | Intro, your questions, her question, done |

## How answers are collected

The page stores nothing and sends nothing. At the end the visitor can
choose to email their answer. The email is pre-filled with what they chose
and which questions they asked, and they can edit it before sending.

That means the data is small and self-selected. Treat it as a signal for
the survey, never as a result.

## Method notes

- Sample: whoever emails. Aim to read the first 5 to 8 replies together.
- File each reply under a participant id, like any other response.
- Record: first question asked, answer chosen, anything they added.
- A moderated version is the better test: watch 5 people meet her, with
  the same four questions above as the script.

## What would change the design

- People skip the disclosure line: move it into the panel header.
- Nobody reaches her question: ask it sooner.
- "Why should I trust you?" is the first pick for most of the first 8:
  lead with the limits instead of the job.
