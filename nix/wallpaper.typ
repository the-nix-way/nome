// A Determinate-branded hexagonal lattice grown from a hash of the flake revision: every commit gets its own wallpaper.

#let seed-hex = sys.inputs.seed
#let label = sys.inputs.label
#let width-px = int(sys.inputs.width)
#let height-px = int(sys.inputs.height)

#let bg = rgb(sys.inputs.bg)
#let muted = rgb(sys.inputs.muted)
#let accents = sys.inputs.accents.split(",").map(rgb)

// One px per 0.5pt, compiled at 144 ppi
#let w = width-px * 0.5pt
#let h = height-px * 0.5pt

#set page(width: w, height: h, margin: 0pt, fill: bg)
#set text(font: "JetBrains Mono", fill: muted, size: 11pt)

// Deterministic PRNG (LCG, 31-bit modulus) seeded from the hash
#let hex-value(s) = s.clusters().fold(0, (acc, c) => calc.rem(acc * 16 + "0123456789abcdef".position(c), 2147483647))
#let step(x) = calc.rem(x * 48271, 2147483647)
#let to-unit(x) = x / 2147483647

#let seed = calc.max(1, hex-value(seed-hex))

// Pointy-top hex lattice
#let size = 34.0
#let dx = size * calc.sqrt(3)
#let dy = size * 1.5
#let cols = int(w / 1pt / dx) + 3
#let rows = int(h / 1pt / dy) + 3

// The logo sits in the middle of the screen, inside a zone that the lattice fades out around
#let logo-width = 760.0
#let logo-height = logo-width * 70 / 260
#let centre-x = w / 1pt / 2
#let centre-y = h / 1pt / 2
#let logo-distance(x, y) = {
  let over-x = calc.max(0.0, calc.abs(x - centre-x) - logo-width / 2)
  let over-y = calc.max(0.0, calc.abs(y - centre-y) - logo-height / 2)
  calc.sqrt(over-x * over-x + over-y * over-y)
}
#let clear-radius = 60.0
#let fade-radius = 300.0

// Colour follows the logo's own diagonal: first accent at the top right, last at the bottom left
#let ramp(x, y) = {
  let diagonal = ((w / 1pt - x) / (w / 1pt) + y / (h / 1pt)) / 2
  // Attractors never reach the corners, so pull the ends of the ramp inward
  let t = calc.clamp((diagonal - 0.2) / 0.6, 0.0, 1.0)
  let position = t * (accents.len() - 1)
  let i = calc.min(calc.floor(position), accents.len() - 2)
  let f = position - i
  color.mix((accents.at(i), (1 - f) * 100%), (accents.at(i + 1), f * 100%))
}

// One attractor per quadrant, placed by the seed, so that the whole ramp always shows up
#let attractors = {
  let state = seed
  let out = ()
  for (qx, qy) in ((1, 0), (0, 0), (1, 1), (0, 1)) {
    state = step(step(state))
    let x = (qx + 0.15 + to-unit(state) * 0.7) / 2 * w / 1pt
    state = step(step(state))
    let y = (qy + 0.15 + to-unit(state) * 0.7) / 2 * h / 1pt
    state = step(step(state))
    let reach = 700 + to-unit(state) * 500
    out.push((x: x, y: y, reach: reach))
  }
  out
}

#let hex-points(r) = range(6).map(i => {
  let a = 60deg * i + 30deg
  (r * calc.cos(a) * 1pt, r * calc.sin(a) * 1pt)
})

#let cells = {
  let state = step(seed + 7)
  for row in range(-1, rows) {
    for col in range(-1, cols) {
      state = step(state)
      let noise = to-unit(state)
      let cx = col * dx + (if calc.rem(calc.abs(row), 2) == 1 { dx / 2 } else { 0 })
      let cy = row * dy

      // Keep clear of the logo
      let clearance = logo-distance(cx, cy)
      if clearance < clear-radius { continue }
      let calm = calc.min(1.0, (clearance - clear-radius) / fade-radius)

      // Attractors combine into one field, so their pools run into each other
      let dark = 1.0
      for at in attractors {
        let d = calc.sqrt(calc.pow(cx - at.x, 2) + calc.pow(cy - at.y, 2))
        dark = dark * (1.0 - calc.max(0.0, 1.0 - d / at.reach))
      }
      let best = (1.0 - dark) * calm

      // Faint outline everywhere, filled cells only where the field and noise agree
      let lit = best * best * 0.75 + best * noise * 0.25
      let show-fill = noise < best * 1.15
      let fill-opacity = if show-fill { calc.min(0.85, 0.08 + lit * 0.95) } else { 0.0 }
      let inset = if show-fill { size * (0.94 - noise * best * 0.42) } else { size * 0.94 }

      (place(
        dx: cx * 1pt,
        dy: cy * 1pt,
        polygon(
          fill: if show-fill { ramp(cx, cy).transparentize(100% - fill-opacity * 100%) } else { none },
          stroke: 0.5pt + muted.transparentize(if show-fill { 70% } else { 88% }),
          ..hex-points(inset),
        ),
      ),)
    }
  }
}

#for c in cells { c }

// The logo, set flat
#place(
  top + left,
  dx: (centre-x - logo-width / 2) * 1pt,
  dy: (centre-y - logo-height / 2) * 1pt,
  image("detsys-logo.svg", width: logo-width * 1pt),
)

// The stamp
#place(bottom + right, dx: -36pt, dy: -30pt, text(tracking: 0.04em)[#label])
