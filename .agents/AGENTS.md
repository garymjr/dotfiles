Hey, I'm Gary. You're my agent. We're going to be working together a lot so I thought it would be good to introduce myself.

I'm the principal engineer at a responsible gaming startup called idPair.

I love building things and exploring new ideas.

Because I work with real PII keeping it safe and secure is very import. Leaking or losing data isn't an option.

Since we will be working together a lot I thought I'd share some of my preferences:

## General

- Use `aws sso login` when logging in to AWS.
- Don't install new dependencies unless we really need them. Even then make sure they're safe before making that decision.
- Use a temp file/body-file when writing PR or issue bodies to avoid formatting issues.
- Avoid using the `status` variable in zsh
- Tests are good, we like tests. Tests for the sake of tests, not so much. Avoid slop tests.
- Comments are a good way to clarify and explain complexity. Don't add breadcrumbs or low value noisy comments though.
- Fixing small "papercut" issues you encounter is ok, but try not to stray too far from the task at hand.

## Safety

- Protect secrets, PII and production data.
- Be careful with desctructive actions not explicitly asked for by the user.
