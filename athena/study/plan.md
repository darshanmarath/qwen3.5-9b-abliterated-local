# Study 1 — What would designers hand to a research agent?

Status: proposed. Nothing has been sent and no data has been collected.

## Why this study

Athena is built to take routine research work off a designer. Before
building more of it, find out which work people would actually hand over,
and where they want to stay in control. The participants are the people
Athena is for, so the study tests the product's premise with its own users.

## Research questions

1. Which research tasks would designers and researchers hand to an agent?
2. Which tasks would they never hand over, and why?
3. At which points do they want to approve before the agent acts?
4. Does it matter to them that the model runs on their own computer?

## Who

Product designers, UX designers and UX researchers who have run at least
one piece of user research in the last twelve months.

- Survey: 15 to 20 people.
- Interviews: 5 of the survey respondents who agree to a follow-up.

## How

| Step | What happens | Who does it |
| --- | --- | --- |
| 1 | Review the survey and consent text | Designer |
| 2 | Put the survey into a form tool | Designer |
| 3 | List people to invite in `private/participants.csv` | Designer |
| 4 | Draft invites | Athena, recruiter |
| 5 | Read, edit and send invites | Designer |
| 6 | Draft one reminder after five days | Athena, recruiter |
| 7 | File responses by participant id | Athena, interviewer |
| 8 | Run five 20-minute interviews | Designer |
| 9 | Propose themes with counts and quotes | Athena, synthesist |
| 10 | Check the themes against the raw responses | Designer |
| 11 | Write up findings | Designer |

Two weeks from first invite to synthesis.

## Measuring Athena itself

The study doubles as a test of the agent. Record, per task:

- minutes spent with Athena, and an honest estimate without it
- how many of Athena's drafts were sent unchanged, edited or thrown away
- how many of Athena's themes survived the check in step 10
- every time a rule in `AGENTS.md` was broken

These are the numbers the case study will report.

## Data handling

- Collect the minimum: name and email for contact, and the answers.
- Everything about real people stays in `athena/study/private/`, on this
  computer, outside git.
- Responses are filed under an id, not a name.
- The model reading the responses runs locally. Responses are not pasted
  into any online AI tool.
- Anyone can withdraw. Their rows and files are deleted on request.
- Delete names and emails when the study closes. Keep the id-only responses.

Participants are likely to be in the EU, so GDPR applies to names, emails
and answers. This plan is a starting point, not legal advice. Check the
consent text and the form tool's data location before sending.
