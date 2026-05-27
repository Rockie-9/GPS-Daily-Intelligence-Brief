# GPS Daily Intelligence Brief — GitHub Repo Setup Guide

End-to-end guide to:
1. Create the GitHub repo
2. Upload the starter files
3. Enable GitHub Pages
4. Wire the Python script for daily auto-push

Total time: ~15 minutes.

---

## Step 1 · Create the GitHub repo

1. Go to https://github.com/new
2. **Repository name**: `GPS-Daily-Intelligence-Brief`
3. **Description**: `Daily intelligence brief for TSMC GPS — auto-generated 08:00 Asia/Taipei`
4. **Visibility**: **Public** (required for free GitHub Pages — content is non-confidential editorial)
5. ❌ Do NOT initialize with README, .gitignore, or license (you'll upload the starter set)
6. Click **Create repository**

GitHub will show a "quick setup" page with a HTTPS URL like:
```
https://github.com/Rockie-9/GPS-Daily-Intelligence-Brief.git
```
Copy this URL — you'll need it in Step 3.

---

## Step 2 · Initialize the local repo

On your Windows machine:

```cmd
cd C:\Users\rockie\repos
mkdir GPS-Daily-Intelligence-Brief
cd GPS-Daily-Intelligence-Brief
```

Unzip / copy the starter files into this directory so it looks like:

```
GPS-Daily-Intelligence-Brief\
├── README.md
├── index.html
├── .gitignore
├── archive\
│   └── index.html
├── daily\
│   └── 2026-05-27.html
└── .github\
    └── workflows\
        └── deploy-pages.yml
```

Initialize git:

```cmd
git init
git branch -M main
git add -A
git commit -m "Initial setup · Issue #147"
```

---

## Step 3 · Push to GitHub

Add your remote and push. **PAT discipline applies**: when prompted for password, paste your GitHub Personal Access Token (PAT) — do NOT save it to any file or this conversation.

```cmd
git remote add origin https://github.com/Rockie-9/GPS-Daily-Intelligence-Brief.git
git push -u origin main
```

When prompted:
- Username: `Rockie-9`
- Password: paste PAT, then press Enter

**Important — PAT scope**: For the daily auto-push to work later, your PAT needs `repo` scope (full repo access). Generate at https://github.com/settings/tokens/new with:
- Note: `GPS Brief daily deployment` (or similar)
- Expiration: 30 days (matches your monthly rotation cadence)
- Scopes: ✅ `repo` (all sub-checkboxes)

---

## Step 4 · Enable GitHub Pages

1. Go to your repo: https://github.com/Rockie-9/GPS-Daily-Intelligence-Brief
2. Click **Settings** (top nav)
3. Left sidebar → **Pages**
4. Under **Build and deployment**:
   - Source: **GitHub Actions**
5. Click **Save** if shown
6. Wait 1-2 minutes for the first deployment

The `deploy-pages.yml` workflow in `.github/workflows/` automatically runs on every push to `main`. After the first run:

**Your live URL**: https://rockie-9.github.io/GPS-Daily-Intelligence-Brief/

Visit it and confirm:
- ✅ Lands on a redirect page that auto-forwards to `daily/2026-05-27.html`
- ✅ The brief renders correctly
- ✅ Language toggle works
- ✅ Reaction buttons display as outlined pills (no overflow)

---

## Step 5 · Configure git credential storage (one-time)

So the Python script can `git push` without interactive prompts. Two options:

### Option A · Windows Credential Manager (recommended, easiest)

```cmd
git config --global credential.helper manager
```

The next `git push` you do manually will pop a Windows credential dialog. Enter your PAT once — Windows stores it securely in Credential Manager. After that, the Python script can push silently.

### Option B · Embed PAT in remote URL (less secure but explicit)

```cmd
cd C:\Users\rockie\repos\GPS-Daily-Intelligence-Brief
git remote set-url origin https://Rockie-9:YOUR_PAT_HERE@github.com/Rockie-9/GPS-Daily-Intelligence-Brief.git
```

**Tradeoff**: PAT is in `.git/config` (local file only, not committed). When rotating PAT monthly, you must re-run this command.

---

## Step 6 · Connect the Python script

In your `gps_brief\.env` file, add:

```ini
REPO_PATH=C:\Users\rockie\repos\GPS-Daily-Intelligence-Brief
GIT_USER_NAME=GPS Brief Bot
GIT_USER_EMAIL=gps-brief@noreply.local
```

(Leave `GITHUB_PAT` blank — you've handled credentials via Step 5.)

**Test it**: run the script manually once.

```cmd
cd C:\Users\rockie\scripts\gps_brief
.\venv\Scripts\activate
python gps_brief.py
```

Expected log output:
```
2026-05-28 09:00:00 [INFO] Wrote brief to: C:\Users\rockie\repos\GPS-Daily-Intelligence-Brief\daily\2026-05-28.html
2026-05-28 09:00:01 [INFO] Updated index.html redirect target
2026-05-28 09:00:01 [INFO] Prepended new entry to archive index
2026-05-28 09:00:02 [INFO] Committed: Daily brief: Issue #148 (2026-05-28)
2026-05-28 09:00:04 [INFO] ✓ Pushed to GitHub successfully
```

GitHub Actions will trigger on the push and deploy within 1-2 minutes.

---

## Step 7 · Verify daily flow end-to-end

Tomorrow morning at 08:00, Task Scheduler will trigger the Python script. After it completes:

1. ✅ You receive the brief in Gmail
2. ✅ The new HTML file appears in `daily/2026-05-28.html` in the repo
3. ✅ The live URL https://rockie-9.github.io/GPS-Daily-Intelligence-Brief/ auto-redirects to the new issue
4. ✅ The archive page shows the new entry at top

---

## Troubleshooting

### "Pages not building"
- Settings → Pages → confirm Source is set to "GitHub Actions"
- Actions tab → click latest workflow run → check for errors
- Most common: workflow YAML syntax. The starter file is tested, but if you edited it, re-validate.

### "Git push failed: Permission denied (publickey)"
- You're using SSH but haven't set up SSH keys. Either set up SSH keys (`ssh-keygen` + add to GitHub), or switch the remote to HTTPS:
  ```cmd
  git remote set-url origin https://github.com/Rockie-9/GPS-Daily-Intelligence-Brief.git
  ```

### "Daily push failed but Gmail worked"
- The Python script's repo deployment is best-effort — it logs warnings but doesn't fail the run if git push fails
- Check `logs\gps_brief_*.log` for the warning detail
- Most common: PAT expired (you rotate monthly). Generate a new PAT and update Credential Manager.

### "Index still shows old date"
- Browser cache. Hard refresh (Ctrl+F5).
- If it really hasn't updated: the GitHub Actions workflow may have failed. Check the Actions tab.

### "I want to delete an old issue"
- Manually: delete the file from `daily\YYYY-MM-DD.html`, commit, push. Don't forget to remove the entry from `archive\index.html`.
- Or simpler: the archive is editorial — you can leave old entries; they just become history.

---

## How the auto-deployment works

The Python script's `deploy_to_repo()` function does:

1. Write `daily\YYYY-MM-DD.html` (today's brief)
2. Update root `index.html` to redirect to today's file
3. Prepend a new row to `archive\index.html`
4. `git add -A` + `git commit -m "Daily brief: Issue #NNN"`
5. `git push` (uses Windows Credential Manager for auth)

GitHub Actions then automatically:
1. Detects the push to `main`
2. Runs `deploy-pages.yml`
3. Publishes the static files to GitHub Pages
4. Updates the live URL within ~60-90 seconds

No CI/CD setup needed beyond enabling Pages.

---

## Optional refinements (later iterations)

Once the daily flow is stable for a week or two:

1. **Custom domain**: point `gps-brief.tsmc.local` or a personal domain at the GitHub Pages URL (Settings → Pages → Custom domain)
2. **RSS feed of issues**: generate a simple RSS XML at the repo root listing past 30 issues; people can subscribe via feedreaders
3. **Search across issues**: add a small client-side search using Lunr.js or similar — works without a backend
4. **PDF archive**: per issue, generate a print-friendly PDF using a headless browser and commit that to a `pdf/` directory
5. **Analytics**: GitHub Pages supports Google Analytics or Plausible — useful to see if anyone actually reads the archive

---

🛠 Maintained on the GPS v3.6 brand framework.
Brand idea: 在您需要之前。 / Before you need it.
