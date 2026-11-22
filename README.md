# Hearts: Card Game (MobilityWare Style)

A modern, high-fidelity web implementation of the classic **Hearts** card game, inspired by the polish, responsive feedback, and strategic depth of MobilityWare's beloved mobile edition.

![Hearts Game](https://img.shields.io/badge/Status-Complete-emerald)
![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Mobile%20%7C%20PWA-blue)
![Zero Dependencies](https://img.shields.io/badge/Dependencies-Zero%20(Pure%20Vanilla%20%2B%20Web%20Audio)-purple)

---

## 🌟 Key Features

### 1. Authentic MobilityWare Feel
- **Casino Felt Surfaces**: Choose between Classic Green Felt, Midnight Navy, Royale Crimson, and Rich Wood.
- **Razor-Sharp SVG Playing Cards**: All 52 card faces and customizable card backs (Sapphire, Ruby Diamond, Sovereign Gold, Slate) are rendered using scalable vector graphics for retina display clarity.
- **Special Queen of Spades Styling**: Visual danger alert badge, gold frame, and distinct audio cues when the Queen is played.
- **Card Interaction**: Fluid fanning in hand, hover card lift, selected card elevation for passing, and active glowing indicators on legal moves.

### 2. Rules Variants & Engine
- **Classic Hearts**:
  - Rotating passing cycle: Round 1 (Left), Round 2 (Right), Round 3 (Across), Round 4 (Hold / No passing).
- **Triple Pass Hearts (3x Passing Mode) ⭐**:
  - Every round kicks off with **3 sequential passing stages** before trick 1:
    1. **Stage 1**: Pass 3 cards to the **Left**.
    2. **Stage 2**: Receive 3 cards, integrate them, and pass 3 cards to the player **in Front (Across)**.
    3. **Stage 3**: Receive 3 cards, integrate them, and pass 3 cards to the **Right**.
  - Players can even pass cards they received in an earlier stage!
- **Strict Trick Rules**:
  - Two of Clubs (2♣) must lead the first trick.
  - Mandatory suit following.
  - First trick protection (no penalty points on trick 1 unless player holds only points).
  - Hearts cannot be led until Hearts have been broken.
  - Highest card of led suit wins the trick.
- **Shooting the Moon**:
  - Taking all 13 Hearts + Queen of Spades triggers a triumphant celebration modal, fanfare music, giving 0 points to shooter and +26 penalty points to all opponents!

### 3. Player Modes & Adaptive AI
- **🌐 Online Multiplayer (Play with Friends Anywhere!) ⭐**:
  - **Private Rooms & Password Protection**: Create a custom room code (e.g. `HEARTS-7X9K`) with a required password to keep unwanted guests out.
  - **1-Click Shareable Direct Invite Link**: Copy the generated link (`...?room=HEARTS-7X9K&pwd=...`) and send it to your friend via Discord, WhatsApp, or text. Opening the link automatically connects them directly to your room!
  - **Host-Authoritative WebRTC Synchronization**: Powered by peer-to-peer WebRTC DataChannels (via PeerJS with public STUN servers) for zero-latency, private hands (opponents cannot cheat), and smooth gameplay across cities or countries.
  - **Mixed Human & AI Table Support**: Play 1v1 with your friend while smart AI bots fill the remaining 2 seats, or invite up to 4 human friends!
  - **Real-Time Emotes & Chat**: Express reactions with floating speech bubbles (👍, 😂, 💔, 😱, 🌕, 👑) and quick in-game messages.
- **Single-Player vs 3 Intelligent AI Bots**:
  - **Dynamic Passing Tactics**: Bots no longer predictably pass the same cards. Hand evaluation includes randomized personality jitter, suit voiding priority, and protected Queen retention.
  - **Bot Moon Shooting Ambition**: When dealt strong powerhouse hands (multiple Aces/Kings, long high hearts, spade honors), bots boldly attempt to Shoot the Moon! They retain all boss cards and pass low off-suit junk to their neighbors.
  - **Memory Tracking of Passed Cards**: Bots remember the exact 3 cards they passed and to which opponent. They exploit this knowledge during play (e.g., under-dropping the Queen of Spades onto a recipient who plays their passed Ace or King of Spades!).
  - **Coordinated Moon Defense**: When a player is running away with all points, bots immediately detect the Moon threat and alter their play: deliberately winning tricks to intercept points and break the moon, or discarding hearts onto winning defenders.
- **Pass & Play / Local Multiplayer**: Play with 2 to 4 human players sharing the same screen, complete with a private **"Pass Device & Reveal Hand"** curtain between turns!

### 4. Player Aids & Quality of Life
- **💡 Tactical Hints**: Analyzes the board and explains *why* a particular card is recommended (e.g. ducking under points or dumping high honors).
- **↺ Undo Last Trick**: Rewind a mistake in single-player mode.
- **📊 Scoreboard Ledger**: Complete round-by-round breakdown and cumulative totals.
- **🏆 Career Statistics**: Tracks games played, victories, win percentage, moon shots, and match history in `localStorage`.
- **🔊 Procedural Web Audio Engine**: Realistic card dealing flicks, card snaps, passes, trick gathers, Queen alerts, and victory fanfares generated via the Web Audio API with zero external audio assets!

---

## 🚀 Quick Start

### Option A: Direct Browser Launch (No server required!)
Simply open `index.html` in your favorite web browser (Google Chrome, Microsoft Edge, Safari, Firefox):
```
file:///C:/Users/roman/.gemini/antigravity/scratch/hearts-card-game/index.html
```

### Option B: Local PowerShell Server
Run the included PowerShell script to host the game on `http://localhost:8080`:
```powershell
powershell -ExecutionPolicy Bypass -File .\run-server.ps1
```

### Option C: Online Multiplayer with Remote Friends (Zero-Config Tunnel)
To play with a friend living away from you, run the online sharing helper in PowerShell:
```powershell
powershell -ExecutionPolicy Bypass -File .\share-online.ps1
```
This automatically starts the server and provides a public HTTPS link (e.g. `https://xyz.a.pinggy.link`) that you can send to your friend anywhere in the world! You can also drag-and-drop the project folder to [Netlify Drop](https://app.netlify.com/drop) or GitHub Pages for free 24/7 web hosting.

---

## 📁 Project Architecture

```
hearts-card-game/
├── index.html              # Main game layout, header controls, and modal dialogs
├── css/
│   └── styles.css          # Casino aesthetics, animations, card fanning, and responsiveness
├── js/
│   ├── audio.js            # Procedural Web Audio synthesizer (zero external mp3/wav files)
│   ├── cards.js            # Card & Deck models, Fisher-Yates shuffle, SVG vector cards
│   ├── rules.js            # Official Hearts rules, legal move checks, scoring, and Moon logic
│   ├── ai.js               # Bot heuristics, void tracking, ducking, discarding, and hint engine
│   ├── stats.js            # Persistent settings and career statistics via LocalStorage
│   ├── game.js             # Core state machine (Dealing, Passing, Playing 13 tricks, Scoring)
│   ├── ui.js               # DOM manipulation, card animations, modals, and user input
│   └── app.js              # Application bootstrapper
├── run-server.ps1          # Lightweight built-in local web server
└── README.md               # Documentation
```
