# GPS Daily Intelligence Brief

**Brand idea:** Before you need it. / 在您需要之前。

Daily intelligence digest serving TSMC Global Physical Security (GPS) — ~450 security managers across 9 operating regions. Covers six monitoring domains: AI fluency, AI applications, GPS-relevant technology, regulation, society/resilience, and semiconductor infrastructure.

---

## What this repo is

A daily-archive of the GPS Intelligence Brief. The brief is auto-generated each weekday morning at **08:00 Asia/Taipei** by a Python pipeline that:

1. Fetches 5 RSS feeds (Focus Taiwan, VentureBeat AI, Tom's Hardware, The Verge, TechCrunch)
2. Filters and formats items for the LLM
3. Calls Claude Sonnet 4.5 with the GPS monitoring framework system prompt
4. Builds bilingual (zh-TW / en) HTML using the canonical brand template
5. Sends to subscribers via Gmail
6. **Commits a snapshot to this repo** (this step)

---

## Structure

```
GPS-Daily-Intelligence-Brief/
├── README.md                          (this file)
├── index.html                         (auto-redirect to latest issue)
├── daily/
│   ├── 2026-05-27.html               (Issue 147)
│   ├── 2026-05-28.html               (Issue 148)
│   └── ...
├── archive/
│   └── index.html                    (browsable issue list)
├── assets/
│   └── style.css                     (shared CSS extracts, if any)
└── .github/
    └── workflows/
        └── deploy-pages.yml          (GitHub Pages auto-deploy)
```

---

## Live URL

**Latest issue:** https://rockie-9.github.io/GPS-Daily-Intelligence-Brief/

**Specific issue:** `https://rockie-9.github.io/GPS-Daily-Intelligence-Brief/daily/YYYY-MM-DD.html`

**Archive index:** https://rockie-9.github.io/GPS-Daily-Intelligence-Brief/archive/

---

## Brand framework

| Layer | Value |
|---|---|
| Brand idea | "Before you need it." / 在您需要之前。 |
| Positioning | Considerate Partner / 體貼的夥伴 |
| Year 1 (2026) | Trust / 建立信任 |
| Year 2 (2027) | Reach / 守護的延伸 |
| Year 3 (2028) | Anticipation / 事前設計 |
| Five Pillars | Designed Safety / Journey Protection / Family Extension / Living Culture / Responsible Technology |

---

## Reading the brief

Each issue is self-contained HTML. Open in any browser. Top-right corner has a language toggle [中文 | EN] — the brief defaults to Traditional Chinese.

Modules in order:
1. **Hero** — issue number, date, posture (ATTEND / HOLD / READY / ALERT)
2. **Today's thesis** — overarching pattern across stories
3. **Lead Signal** — single highest-confidence story with bullets, lens, cascade sentence, sources
4. **Signal Board** — 4 tiles (HIGH / MED / WATCH) for at-a-glance scanning
5. **Story Cards** — 5 in-depth stories (some highlighted as dark cards)
6. **Pillar Spotlight** — today's pillar with People / Process / Technology actions
7. **Technical Radar** — 5 areas under continued observation
8. **Resilience Calendar** — upcoming windows (weather, holidays, regulatory dates)
9. **Today's Action** — single concrete this-day step
10. **This Week's Conversation** — Section Head 1:1 prompt
11. **Configuration & Feedback** — preference hub + 3 feedback channels
12. **Footer** — meta and attribution

---

## Subscribing

Production subscription is managed via the automation pipeline's recipient list. To add or change recipients, edit the `.env` file on the production machine (Rockie's Windows workstation).

---

## Maintained by

GPS Strategy & Transformation team
Last code update: 2026-05-27
