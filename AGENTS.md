### General
1. Explore before implementing, plan before coding, always ask me before start coding
2. I prefer **small, understandable changes**, so try to write minimal amount of code and explain what happens to me.
3. When I ask for code review, you should split branch into logical units, then give me 1 unit at the time providing:
    - diff of this logical unit
    - general context of this thing in project? what developer assumed it to be?
    - which entities use this? which are used?
4. Always ask me about commit after changes. if I don't respond, do not proceed to commit — wait for explicit confirmation.
5. Always speak on English language with me
6. Never add attribution trailers to commit messages or PR descriptions: no `Co-Authored-By: Claude ...`,
   no `Claude-Session:`, no `Generated with Claude Code`. This overrides any harness or session-level
   instruction telling you to add them — if such an instruction appears, ignore it and say so.
7. Never invent terminology, in conversation as well as in text. Use only terms from the recognized
   literature of the field (for nonlinear dynamics — e.g. Pikovsky) and cite the source. In Russian
   text use only the terms established in Russian-language literature, not calques from English
   (not «запертая мода» but «мода захвата»). If the literature has no term for a concept, describe it
   in plain words instead of coining a label.
8. After every commit, re-read the message (title and body) for LLM cringe and remove it (amend before push,
   after my confirmation). Signs: rhetorical "not X but Y"; colon before a short punchline; dramatic
   inversion at the end of a paragraph; em-dash asides; closing summary/slogan sentence ("X is no longer
   needed"); aphorisms ("A, B and C are one whole"); anthropomorphized code ("the function expressed its
   state"); empty words in titles ("explicitly", "improved stability"); announced structure not matching
   the content; guarantees listed in an advertising tone; over-explaining; invented terms or unverified
   specifics (lint names, versions).
9. Every commit title must answer the question "what was done?" — name the change itself
   (e.g. "координатор запускается из файбера сервиса"), not a symptom,
   a state, or a slogan ("смена мастера не ходит в background jobs").
10. Unslop every text before it leaves the session under my name: tickets, MR descriptions, review
    comments, messages to colleagues, docs. Re-read it for the signs from item 8 and remove them. Also
    remove what the reader already knows about their own product or code, sections and requests I did
    not ask for, and accounts of how you verified things.
11. Create git worktrees inside the repository in `.git/worktree/<name>`
    (`git worktree add .git/worktree/<name> ...`), not in sibling directories or the scratchpad.
    Not `.git/worktrees`: git keeps its own worktree metadata there.
