# DESIGN.md

> Style direction for Habit Tracker HiveDB, grounded in the official brand logo identity (`assets/habit.png`).

## Identity & Character
- **Product:** Habit Tracker HiveDB
- **Brand Essence:** Purposeful, energetic, disciplined, and reliable routine building.
- **Brand Roots:** Derived directly from the official logo (`assets/habit.png`): Cobalt Blue (`#174E8F`), Electric Azure (`#0371FD`), and Warm Tangerine Orange (`#FF6502`).
- **Dial:** ENERGY 2 / RHYTHM 2 / MOTION 1

---

## Palette (2 Core + 1 Deliberate Accent, Antislop R-01 & R-29)

### Dark Mode (Default)
- **Base Ground:** `#0C1424` (Deep Midnight Navy - grounding surface inspired by the logo's deep undertones)
- **Card Surfaces:** `#152238` (Rich Navy Slate - clearly separated without muddy opacity)
- **Elevated Surfaces:** `#1C2D4A` (Hover, input background, and active container state)
- **Borders:** `#243754` (Crisp 1px boundary)
- **Primary Text:** `#F8FAFC` (17.59:1 WCAG AA/AAA pass)
- **Secondary Text:** `#A0ABBA` (6.85:1 WCAG AA pass)
- **Brand Primary (Identity):** `#174E8F` / `#0371FD` (Official Logo Cobalt & Azure)
- **Deliberate Accent (Streak & Completion):** `#FB923C` / `#EA580C` / `#C2410C` (Warm Logo Tangerine - used strictly for streaks, completed habit badge, and key CTAs)

### Light Mode
- **Base Ground:** `#F8FAFC` (Slate 50)
- **Card Surfaces:** `#FFFFFF`
- **Elevated Surfaces:** `#F1F5F9`
- **Borders:** `#E2E8F0`
- **Primary Text:** `#0F172A` (17.85:1 WCAG AA pass)
- **Secondary Text:** `#475569` (7.58:1 WCAG AA pass)
- **Brand Primary:** `#174E8F` (8.32:1 WCAG AA pass with white text)
- **Deliberate Accent:** `#C2410C` (5.18:1 WCAG AA pass with white text)

---

## Radius Scale (Intentional Hierarchy, Antislop R-11)
- **Cards & Habit Items:** 16px (friendly container)
- **Buttons & Interactive Controls:** 12px (clear affordance)
- **Inputs & Fields:** 10px
- **No uniform pill shapes everywhere.**

---

## Activity Heatmap Progression (Logo Cobalt-to-Azure Scale)
- Follows the logo's blue spectrum from deep navy foundation to bright energetic azure, celebrating consistency without visual slop.

---

## Antislop Compliance Checklist
- [x] **R-01 (Color with Purpose):** Cobalt and Tangerine are derived from the real product asset (`assets/habit.png`), not AI-default neon gradients or random purple.
- [x] **R-25 (Contrast Standard):** All pairings mathematically verified with `contrast-check.py` to meet WCAG AA (>= 4.5:1 for body text).
- [x] **R-29 (Color Discipline):** Restricted to 2-3 core colors (Navy/Slate, Cobalt) + 1 accent (Tangerine).
- [x] **R-34 (Dual Themes):** Fully functional in both Dark and Light modes.
- [x] **C-1 & C-3 (Craftsmanship & Content):** Responsive centering (`maxContentWidth: 640px`) on Web Chrome, purposeful empty states, zero dead controls.
