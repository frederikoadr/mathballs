# MathBalls  🎮➗✖️

Having Quickmafs? Play MathBalls and challenge your balls 🗿

An educational **Roblox mini-game** that turns math practice into a **fun survival challenge**.  
Players must solve math problems under time pressure — stand on the correct answer tile to survive, or fall when the wrong tiles drop!  

This project was built to explore **gamified learning** and how interactive environments can make studying more engaging.

---

## 📌 Project Overview
- **Objective**: Make math practice more exciting through a game format.  
- **Gameplay**:
  - A random math question is shown every round.
  - Players have 15 seconds to move onto the correct answer tile.
  - Wrong tiles rotate and fall, eliminating players standing on them.
  - Surviving players continue to the next round.
- **Learning Focus**: Encourages focus, accuracy, and speed in solving math problems.

---

## ⚙️ Technologies Used
- **Platform**: Roblox Studio  
- **Language**: Lua  
- **Frameworks/Tools**:
  - [Rojo](https://rojo.space/) → sync scripts between local project and Roblox Studio  
  - **Roblox APIs**: TweenService, SurfaceGui, Leaderstats, Player service  
- **Reasoning**:  
  - Roblox Studio is accessible and multiplayer-ready.  
  - Lua provides seamless integration with Roblox.  
  - Rojo enables proper source control and collaborative workflows.  

---

## ✨ Features
- **Math Survival Gameplay**: Wrong tiles collapse each round.  
- **Timer & Pressure**: 15s countdown adds urgency.  
- **Leaderboard**:
  - **Streak** → current consecutive correct answers.  
  - **MaxStreak** → best performance.  
- **Fair Play**: Each player spawns riding their own ball for balance.  
- **Tile Reset**: Fallen tiles respawn for the next round.  

---

## 🚀 Installation & Setup

### 1. Requirements
- [Roblox Studio](https://create.roblox.com/)  
- [Rojo](https://rojo.space/) v7+  
- Git (optional, for source control)  

### 2. Clone Project
```bash
git clone https://github.com/frederikoadr/mathballs.git
cd mathballs
