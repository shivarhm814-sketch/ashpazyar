# Handoff: آشپزیار (Ashpazyar) — Pantry-to-Recipe Mobile App

## Overview
"آشپزیار" is a Persian-language (Farsi, RTL) mobile app that takes the food a user
already has at home ("pantry"/قفسه) plus an extra-spend budget level, and suggests
real, varied recipes that minimize cost and food waste. Audience: Farsi-speaking
students / young families who care about food budgeting and reducing waste. Tone:
warm, practical, casual — not a luxury cooking app, more like a helpful daily
home-cooking assistant.

## About the Design Files
The bundled file (`Ashpazyar.dc.html`) is a **design reference built in HTML** — an
interactive high-fidelity prototype showing the intended look, copy, and click-through
behavior. It is **not production code to copy directly**. The task is to recreate this
design in the target codebase's existing environment (React Native, Flutter, native
iOS/Android, etc.) using its established component patterns, navigation, and state
management — or, if no mobile stack exists yet, choose the framework best suited to
the project and implement the designs there.

## Fidelity
**High-fidelity.** Colors, typography, spacing, copy, and interaction flow are final —
recreate pixel-close using the codebase's own component/styling system. The device
bezel (Android status bar / gesture nav) in the HTML file is prototyping chrome only —
ignore it; the real app runs full-screen in the OS.

## Global Notes
- **Direction**: entire app is RTL (`dir="rtl"`), Persian (`lang="fa"`) copy throughout.
- **Font**: prototype uses **Vazirmatn** (open-license Google Font) as a stand-in for
  a warmer branded Persian face (client originally referenced Kalameh/IRANSans, which
  aren't freely licensable) — swap in the brand's actual licensed font if available;
  otherwise Vazirmatn (weights 400/500/700/800) is a fine production choice.
- **Signature element**: a row of 7 small "jar" shapes (spice-jar silhouettes) on the
  Pantry screen that visually fill in with color as the user adds pantry items —
  a metaphor for the product itself. A caption under it notes this illustration is a
  placeholder for a future real photo of the user's own pantry/shelf.

## Design Tokens

### Colors
- Page background (behind app / outer): `#EAE0C8`
- App background: `#F5EEDD`
- Card / surface: `#FFFCF4`
- Border / hairline: `#E4D8BC`
- Ink (primary text): `#2B2118`
- Ink soft (secondary text): `#7A6B52`
- Muted label bg: `#9A8B6D` (caption text), `#EFE3CE` (chip/badge bg), `#5B4E38` (chip text)
- **Turmeric (accent 1 — primary CTA / highlights)**: `#D9A404`
- **Tomato (accent 2 — "need to buy" / errors)**: `#B33A1E`, soft `#F6DDD3`, text-on-soft `#7A2C18`
- **Olive (accent 3 — "from pantry" / success / secondary CTA)**: `#4A5D23`, soft `#E1E8CF`, text-on-soft `#3C4C1B`

### Typography
- Font family: Vazirmatn (or brand substitute), fallback Tahoma/sans-serif
- App title / hero: 34px, weight 800
- Screen titles: 19–22px, weight 800
- Card titles: 16–16.5px, weight 700–800
- Body copy: 13.5–15px, weight 400–500, line-height ~1.75–1.9
- Captions / meta: 12–13px

### Spacing / Shape
- Screen horizontal padding: 20px
- Card radius: 14–18px; pill/chip radius: 100px (fully round)
- Primary CTA height: 50–54px, radius 14–16px
- Standard gap between stacked elements: 8–14px

## Screens / Views (in user flow order)

### 1. Login / Sign up
- **Purpose**: minimal auth gate.
- **Layout**: centered column — logo mark (simple jar shape) + app name "آشپزیار" +
  one-line tagline, then a bottom-anchored form: labeled email/phone field, labeled
  password field, primary button, secondary "sign up" text link.
- **Copy**: title "آشپزیار"; tagline "کمترین هزینه، بدون دورریز مواد، غذای جدید از
  همون چیزایی که داری"؛ CTA button "ورود"؛ footer "حساب نداری؟ ثبت‌نام کن".
- **Behavior**: tapping "ورود" navigates to Pantry. No real validation in the prototype.

### 2. Pantry ("قفسه من" — My Pantry)
- **Purpose**: home screen; shows what the user currently has, lets them add items,
  and is the entry point to get recipe suggestions.
- **Layout**: header with title + overflow (⋮) menu button (opens the demo/state menu
  — see below) → signature jar-row visual + caption → scrollable list of pantry item
  rows (icon chip with first letters + name + remove ✕) or an empty state → sticky
  footer with a dashed "add item" row and a solid primary "پیدا کن غذا" (Find Food) button.
- **Empty state**: icon, headline "هنوز چیزی توی قفسه‌ت نیست", supporting copy inviting
  the user to add their first item, CTA "+ افزودن اولین ماده".
- **Behavior**: "پیدا کن غذا" routes to Budget selection if pantry has ≥1 item, or to
  the empty-pantry error screen if pantry is empty (this is the *real* trigger for that
  error state, not just a demo shortcut).

### 3. Add Ingredient (bottom sheet, overlays Pantry)
- **Layout**: modal sheet sliding from bottom over a dimmed backdrop. Drag handle,
  title "چی توی خونه داری؟", text input (RTL, placeholder "مثلا: پیاز، سیب‌زمینی...")
  wired to a live-filtered chip list of suggestions below it, footer with "بستن"
  (close) and a primary "اضافه شد!" (add) button.
- **Behavior**: typing filters the suggestion chip list (case-sensitive substring
  match against a fixed common-pantry-item list, excluding items already added);
  tapping a chip or the add button adds the item to the pantry and clears the field.

### 4. Budget Selection
- **Purpose**: choose how much extra the user is willing to spend on missing items.
- **Layout**: header with back chevron + title "چقدر بودجه‌ی اضافه داری؟", 3 selectable
  cards stacked vertically, sticky footer "ادامه" (Continue) button.
- **Cards** (id / label / one-line description):
  - خیلی کم — «فقط با چیزی که الان توی قفسه‌ته»
  - متوسط — «می‌تونی یکی دو تا ماده‌ی کوچیک هم بخری»
  - بدون محدودیت — «هر چی لازم باشه، بخر»
- **States**: unselected card = 2px border `#E4D8BC`; selected = 2px `#D9A404` border +
  soft shadow + a filled turmeric checkmark badge.
- **Behavior**: "ادامه" is visually disabled (muted colors) until a card is selected;
  once enabled, tapping it starts the Loading flow.

### 5. Loading (AI thinking)
- **Purpose**: bridge state while "AI" computes suggestions (simulated ~2.2s delay).
- **Layout**: centered — 3 small bars in turmeric/tomato/olive pulsing with staggered
  scale/opacity animation, headline "داره توی قفسه‌ت دنبال ایده می‌گرده...", supporting
  copy "چند ثانیه طول می‌کشه...".
- **Behavior**: auto-advances to Results after the delay (or to a retry of Results from
  the Service Error screen).

### 6. Results (recipe suggestions)
- **Layout**: header with back + title "اینا رو می‌تونی بپزی", subcopy, scrollable list
  of recipe cards.
- **Recipe card**: title, optional distinct orange "+N خرید" badge (shown only if the
  recipe needs extra purchases), one-line description, row of 3 neutral badges (approx.
  cost in Toman, cook time, difficulty).
- **Behavior**: tapping a card opens Recipe Detail.

### 7. Recipe Detail
- **Layout**: olive-colored header block (back chevron, title, description, 3 meta
  badges on translucent white chips) followed by a scrollable body: "✓ از قفسه‌ات
  استفاده می‌شه" (from-pantry ingredients, olive-soft chips) section, then — only if
  applicable — "🛒 باید بخری" (to-buy ingredients, tomato-soft chips) section, then a
  numbered step-by-step method list (circular turmeric numeral badges + step text).
- **Sample recipes included** (full real recipes, 3 total): عدسی (lentil soup), کوکو
  سیب‌زمینی (potato kuku), اشکنه گوجه‌فرنگی (tomato eshkeneh) — see the HTML file for
  exact ingredient lists and numbered steps.

### 8. Error — Empty Pantry
- **Trigger**: tapping "پیدا کن غذا" with zero pantry items (real flow, not just a demo
  hook).
- **Layout**: centered icon, headline "قفسه‌ت فعلاً خالیه", explanatory copy, CTA
  "برگرد و یه ماده اضافه کن" which returns to Pantry with the Add Ingredient sheet
  already open.

### 9. Error — Service Failure
- **Trigger**: reachable via the Pantry header's ⋮ demo menu in the prototype (real
  app would trigger this on an actual API failure during the Loading step).
- **Layout**: centered icon, headline "یه مشکلی پیش اومد", copy clarifying it's a
  service issue (not the user's pantry), CTA "تلاش دوباره" (Retry) which re-runs the
  Loading → Results flow.

### Demo/state-preview menu (prototype-only affordance)
The ⋮ icon on the Pantry header opens a small dropdown with shortcuts to preview the
Loading state, the two error states, and a "fill pantry with sample data" convenience
action — **this menu itself is not part of the production app**; it exists only so
every state is reachable for review. Do not implement it; instead wire the Loading and
error screens to real network/API states.

## State Management (for reference)
- Current screen + a simple back-navigation history stack.
- Pantry items: array of strings (ingredient names), add/remove.
- Add-sheet open/closed + current search query (drives filtered suggestion list).
- Selected budget tier.
- Selected recipe id (looked up from a small fixed recipe list in the prototype —
  replace with real API data keyed the same way: title, description, cost/time/
  difficulty labels, fromPantry[], toBuy[], numbered steps[]).
- Loading is a timed transition in the prototype; in production it should resolve on
  the real API response (success → Results, failure → Service Error).

## Logo / Brand Mark
Login screen features an animated logo mark: a circular gradient badge (turmeric →
tomato, `linear-gradient(155deg, #E6B421 0%, #D9A404 42%, #B33A1E 100%)`) containing a
cream-colored cooking pot (olive lid, cream handles), with:
- two steam wisps above the lid that continuously rise and fade (loop ~2.2–2.4s)
- three small flame shapes beneath the pot that flicker independently (staggered
  scale/rotate keyframe loops, ~0.85–1s each) in a turmeric-to-tomato gradient
This is built entirely from simple divs/gradients/box-shadows + CSS keyframe
animations — no image asset. Recreate as a Lottie/native animation or CSS/SVG
equivalent in production; see the `<style>` block in the HTML file for exact
keyframes (`ghafase-flame-a/b/c`, `ghafase-steam-rise/rise2`) and the login screen
markup for exact shape sizes/positions/colors.

## Assets
No external image assets besides the logo above — all visuals (jar signature element,
icons, badges) are built from simple CSS shapes/emoji in the prototype. Replace the
jar illustration with real photography if/when available (see caption copy on the
Pantry screen).

## Files
- `Ashpazyar.dc.html` — the full interactive prototype (all 9 screens + demo menu),
  self-contained. Open directly in a browser to click through the whole flow.
