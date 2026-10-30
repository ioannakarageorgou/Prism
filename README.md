# Prism 🎡

A tiny particle project I built in a day to play with SwiftUI's Canvas API.
Touch the screen and glowing particles bloom around your finger. Tap for
a burst. Turn on symmetry and things get unexpectedly pretty.

---

## Demo

![Demo](https://github.com/user-attachments/assets/caeebf54-67f5-4b52-915b-8c46bc95f3a8)

---

## What it does

- Paint: drag to leave trails of glowing particles
- Burst: tap anywhere to send particles flying
- Three palettes: Crystal, Neon, Aurora
- Kaleidoscope: 6-way symmetry, because why not
- Liquid Glass bar: palette picker and clear, using iOS 26 `.glassEffect()`

---

## How it works

Each particle stores its birth position, velocity, and birth time — never
its current position. Every frame the renderer asks *"where are you now?"*
and calculates it: `position = start + velocity × age`. Simple, and it means
the Canvas is purely read-only with no update loop needed.

The kaleidoscope is just a drawing trick — the particle system doesn't know
about it. The Canvas mirrors each draw point into 6 positions using polar
coordinate math before painting.

Glow comes from drawing two circles per particle: a large soft radial gradient
halo, then a bright core on top. `.blendMode = .plusLighter` makes overlapping
particles add up like real light.

---

## Stack

SwiftUI Canvas + TimelineView, no dependencies, no backend, no Metal.


*Built for fun with SwiftUI.*
