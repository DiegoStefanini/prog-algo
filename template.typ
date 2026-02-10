// ========================================
// Template - Stile accademico
// ========================================

// Contatori per numerazione (resettati per capitolo)
#let definition-counter = counter("definition")
#let theorem-counter = counter("theorem")
#let lemma-counter = counter("lemma")
#let corollary-counter = counter("corollary")
#let example-counter = counter("example")

// Sfondo per codice
#let code-bg = rgb("#f5f5f5")

// ========================================
// Definizione
// ========================================
#let definition(title: none, body) = {
  v(0.5em)
  definition-counter.step()
  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em, right: 0.5em),
    stroke: (left: 2pt + luma(160)),
  )[
    #set text(size: 10pt)
    #set par(justify: true)
    #context {
      let ch = counter(heading).get().first()
      let n = definition-counter.get().first()
      text(weight: "bold")[Definizione #ch.#n#if title != none [ -- #title].]
    } #body
  ]
  v(0.5em)
}

// ========================================
// Teorema
// ========================================
#let theorem(title: none, body) = {
  v(0.5em)
  theorem-counter.step()
  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em, right: 0.5em),
    stroke: (left: 2pt + luma(160)),
  )[
    #set text(size: 10pt)
    #set par(justify: true)
    #context {
      let ch = counter(heading).get().first()
      let n = theorem-counter.get().first()
      text(weight: "bold")[Teorema #ch.#n#if title != none [ -- #title].]
    } #body
  ]
  v(0.5em)
}

// ========================================
// Lemma
// ========================================
#let lemma(title: none, body) = {
  v(0.5em)
  lemma-counter.step()
  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em, right: 0.5em),
    stroke: (left: 2pt + luma(160)),
  )[
    #set text(size: 10pt)
    #set par(justify: true)
    #context {
      let ch = counter(heading).get().first()
      let n = lemma-counter.get().first()
      text(weight: "bold")[Lemma #ch.#n#if title != none [ -- #title].]
    } #body
  ]
  v(0.5em)
}

// ========================================
// Corollario
// ========================================
#let corollary(title: none, body) = {
  v(0.5em)
  corollary-counter.step()
  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em, right: 0.5em),
    stroke: (left: 2pt + luma(160)),
  )[
    #set text(size: 10pt)
    #set par(justify: true)
    #context {
      let ch = counter(heading).get().first()
      let n = corollary-counter.get().first()
      text(weight: "bold")[Corollario #ch.#n#if title != none [ -- #title].]
    } #body
  ]
  v(0.5em)
}

// ========================================
// Esempio
// ========================================
#let example(title: none, body) = {
  v(0.5em)
  example-counter.step()
  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em, right: 0.5em),
    stroke: (left: 2pt + luma(160)),
  )[
    #set text(size: 10pt)
    #set par(justify: true)
    #context {
      let ch = counter(heading).get().first()
      let n = example-counter.get().first()
      text(weight: "bold")[Esempio #ch.#n#if title != none [ -- #title].]
    } #body
  ]
  v(0.5em)
}

// ========================================
// Nota (senza numerazione)
// ========================================
#let note(title: none, body) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em, right: 0.5em),
    stroke: (left: 1.5pt + luma(180)),
  )[
    #set text(size: 10pt)
    #set par(justify: true)
    *Nota#if title != none [ -- #title].* #body
  ]
  v(0.5em)
}

// ========================================
// Osservazione (senza numerazione)
// ========================================
#let observation(body) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em, right: 0.5em),
    stroke: (left: 1.5pt + luma(180)),
  )[
    #set text(size: 10pt)
    #set par(justify: true)
    *Osservazione.* #body
  ]
  v(0.5em)
}

// ========================================
// Dimostrazione
// ========================================
#let demonstration(body) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.5em, bottom: 0.5em, right: 0.5em),
  )[
    #set text(size: 10pt)
    #set par(justify: true)
    _Dimostrazione._ #body #h(1fr) $square.filled$
  ]
  v(0.5em)
}

// ========================================
// Algoritmo/Codice (box grigio chiaro)
// ========================================
#let algorithm(title: none, body) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (x: 1em, y: 0.8em),
    fill: code-bg,
    stroke: 1pt + luma(200),
    radius: 3pt,
  )[
    #if title != none [
      #text(size: 9pt, weight: "bold")[#title]
      #v(0.3em)
    ]
    #set text(size: 9.5pt, font: "Consolas")
    #set par(justify: false, leading: 0.6em)
    #body
  ]
  v(0.5em)
}

// ========================================
// Codice inline
// ========================================
#let code(body) = {
  box(
    fill: code-bg,
    inset: (x: 0.3em, y: 0.1em),
    radius: 2pt,
  )[#text(size: 9.5pt, font: "Consolas")[#body]]
}

// ========================================
// Nota a margine
// ========================================
#let margin-note(body) = {
  place(
    right,
    dx: 2.8cm,
    block(
      width: 2.5cm,
      inset: 0.3em,
    )[
      #set text(size: 8pt, fill: luma(100))
      #set par(justify: false, leading: 0.5em)
      #body
    ]
  )
}

// ========================================
// Concetto chiave (box sobrio)
// ========================================
#let keypoint(body) = {
  v(0.3em)
  block(
    width: 100%,
    inset: 0.6em,
    fill: luma(245),
    stroke: 1pt + luma(200),
    radius: 3pt,
  )[
    #set text(size: 9.5pt)
    #set par(justify: true)
    #body
  ]
  v(0.3em)
}

// ========================================
// Reset contatori per capitolo
// ========================================
#let reset-counters() = {
  definition-counter.update(0)
  theorem-counter.update(0)
  lemma-counter.update(0)
  corollary-counter.update(0)
  example-counter.update(0)
}
