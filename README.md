# 🎾 Tennis Round-Robin Manager

A self-contained web app for managing a local tennis round-robin competition. Supports multiple scorecards, live score entry with tennis set validation, and real-time sync across all users via Supabase.

-----

## Features

- **Round-robin scorecard** — full grid showing every match, set scores, and sets-won totals
- **Multiple scorecards** — run several groups simultaneously, each with their own tab
- **Tennis score validation** — set scores are validated against real tennis rules (including tiebreaks)
- **Live sync** — all users see the same data in real time via Supabase
- **Access control** — public viewing for anyone, score entry behind a user code, admin panel behind a separate admin code
- **Persistent authentication** — users and admins only need to enter their code once per device

-----

## Setup

### 1. Supabase (database)

Create a free account at [supabase.com](https://supabase.com) and start a new project.

In the **SQL Editor**, run the contents of [`setup.sql`](./setup.sql) to create the required table and access policies.

Then go to **Project Settings → API** and copy your:

- **Project URL** (e.g. `https://xxxx.supabase.co`)
- **Anon public key** (starts with `eyJ…`)

### 2. Hosting (GitHub Pages)

1. Create a new GitHub repository
1. Upload the following files to the root of the repo:
- `tennis-competition.html` → rename to `index.html`
- `config.json`
- `setup.sql` (reference only — not served to users)
1. Go to **Settings → Pages**, set the source to your main branch, and save
1. Your app will be live at `https://yourusername.github.io/your-repo-name`

### Configuration file

Database credentials are stored in `config.json` in the repo root:

```json
{
  "supabase_url": "https://your-project.supabase.co",
  "supabase_anon_key": "eyJ..."
}
```

To point the app at a different Supabase database, just update this file — no changes to `index.html` needed. The HTML file contains hardcoded fallback credentials, so the app still works even if `config.json` is missing.

**Credential priority (highest to lowest):**

1. Manual override set via the Admin panel (stored in browser localStorage)
1. `config.json` in the repo root
1. Hardcoded fallback in `index.html`

-----

## First-time configuration

Open your hosted app and click **Admin** in the top right. On first access, no code is required.

### Connect Supabase

In the **Supabase Connection** section, paste your Project URL and Anon Public Key, then click **Save & Test**. A success message confirms the connection.

### Set access codes

In the **Access Codes** section:

- **User code** — share this with anyone who should be able to enter scores
- **Admin code** — keep this private; it unlocks the admin panel

Codes are stored as SHA-256 hashes in Supabase — the plaintext is never saved to any server.

Use the **Copy user code to clipboard** button to easily share the user code.

-----

## Usage

### Viewing scores

Anyone can open the app URL and view all scorecards with no login required.

### Entering scores

1. Click any cell on the scorecard
1. First-time users will be prompted to paste the user code (once per device)
1. Enter the set scores (e.g. `6` / `3` for a 6–3 set) — up to 3 sets per match
1. A live preview shows the result; invalid set scores are highlighted
1. Click **Save Score**

### Admin panel

Click **Admin** and enter your admin code (once per device). From here you can:

- Configure the Supabase connection
- Set or update access codes
- Add or remove scorecards
- Rename scorecards
- Add or remove players
- Edit any score directly
- Clear all scores for a scorecard
- Delete a scorecard

-----

## Access control summary

|Action                |Requirement                 |
|----------------------|----------------------------|
|View scorecards       |None — open to all          |
|Enter / edit scores   |User code (once per device) |
|Access admin panel    |Admin code (once per device)|
|Admin code also grants|Score entry access          |

-----

## Tennis scoring rules

The app validates set scores against standard tennis rules:

- A player must win at least 6 games
- The winner must lead by at least 2 games
- **Exception:** a 7–6 score is valid (tiebreak)
- Valid examples: `6-0`, `6-4`, `7-5`, `7-6`
- Invalid examples: `5-3`, `6-5`, `8-6`

-----

## Tech stack

- **Frontend** — plain HTML, CSS, and JavaScript (no framework, no build step)
- **Database** — [Supabase](https://supabase.com) (Postgres with REST API)
- **Hosting** — GitHub Pages (or any static file host)
- **Authentication** — SHA-256 hashed access codes via the Web Crypto API

-----

## Local development

No build step required. Just open `index.html` directly in a browser. Without Supabase configured, the app runs entirely from `localStorage`.