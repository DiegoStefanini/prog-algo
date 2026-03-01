// ============================================================
// TEMPLATE DISPENSE UNIVERSITARIE - PROGRAMMAZIONE ED ALGORITMICA
// Stile con box colorati e filetti laterali
// Numerazione unificata: Capitolo.Sezione.Numero
// ============================================================

#import "@preview/cetz:0.3.4"

// Contatore unico per tutti i blocchi numerati (Cap.Sez.Num)
#let contatore-blocco = counter("blocco")

// Helper: incrementa il contatore e restituisce il numero formattato
#let _prossimo-numero() = {
  contatore-blocco.step()
  context {
    let h = counter(heading).get()
    let b = contatore-blocco.get().first()
    let ch = h.at(0, default: 0)
    let sec = h.at(1, default: 0)
    [#ch.#sec.#b]
  }
}

// Configurazione documento
#let conf(doc) = {
  set document(title: "Programmazione ed Algoritmica", author: "Diego Stefanini")

  set page(
    paper: "a4",
    margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2cm),
    numbering: "1",
    header: context {
      if counter(page).get().first() > 1 {
        set text(size: 9pt, fill: gray)
        [Programmazione ed Algoritmica — Dispense #h(1fr) #counter(page).display()]
      }
    },
  )

  set text(font: "New Computer Modern", size: 11pt, lang: "it")
  set par(justify: true, leading: 0.65em, first-line-indent: 1em)
  set heading(numbering: "1.1.")
  set math.equation(numbering: "(1)")
  set list(indent: 1em, body-indent: 0.5em)
  set enum(indent: 1em, body-indent: 0.5em)

  // Code blocks con sfondo e syntax highlighting (non spezzabili tra pagine)
  show raw.where(block: true): it => {
    v(0.4em)
    block(
      width: 100%,
      fill: rgb("#1e1e2e"),
      inset: (x: 1.2em, y: 1em),
      radius: 6pt,
      breakable: false,
    )[
      #set text(size: 9.5pt, font: "Source Code Pro", fill: rgb("#cdd6f4"))
      #set par(justify: false, leading: 0.6em)
      #it
    ]
    v(0.4em)
  }

  // Code inline con sfondo
  show raw.where(block: false): it => {
    box(
      fill: rgb("#e8edf4"),
      inset: (x: 0.35em, y: 0.15em),
      outset: (y: 0.15em),
      radius: 3pt,
    )[#text(size: 9.5pt, font: "Source Code Pro", fill: rgb("#1e1e2e"))[#it]]
  }

  show heading: set text(rgb("#003366"))

  // Capitoli: stile "CAPITOLO N" con linee colorate
  show heading.where(level: 1): it => {
    contatore-blocco.update(0)
    pagebreak()
    v(2cm)
    align(center)[
      #line(length: 60%, stroke: 0.4pt + rgb("#003366"))
      #v(0.8cm)
      #text(size: 11pt, tracking: 0.2em, fill: rgb("#003366"))[CAPITOLO #context counter(heading).display("1")]
      #v(0.4cm)
      #text(size: 22pt, weight: "bold", fill: rgb("#003366"))[#it.body]
      #v(0.8cm)
      #line(length: 60%, stroke: 0.4pt + rgb("#003366"))
    ]
    v(1cm)
  }

  // Sezioni: reset contatore blocchi
  show heading.where(level: 2): it => {
    contatore-blocco.update(0)
    v(0.5cm)
    block(breakable: false)[
      #set text(size: 12pt, weight: "bold")
      #it
      #v(0.2cm)
    ]
  }

  // Sotto-sezioni
  show heading.where(level: 3): it => {
    v(0.3cm)
    block(breakable: false)[
      #set text(size: 11pt, weight: "bold")
      #it
      #v(0.1cm)
    ]
  }

  // Sotto-sotto-sezioni
  show heading.where(level: 4): it => {
    v(0.2cm)
    block(breakable: false)[
      #set text(size: 11pt, weight: "bold", style: "italic")
      #it
      #v(0.1cm)
    ]
  }

  // Indice: capitoli in grassetto
  show outline.entry.where(level: 1): it => {
    v(0.3em, weak: true)
    strong(it)
  }

  doc
}

// ============================================================
// AMBIENTI TEORICI (box colorati con filetti laterali)
// ============================================================

// Definizione — box blu
#let definizione(corpo, titolo: none) = {
  v(1em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#003366")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#f4f7fb"),
    radius: (right: 4pt),
  )[
    *#smallcaps[Definizione] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #corpo
  ]
  v(1em)
}

// Teorema — box viola
#let teorema(corpo, titolo: none) = {
  v(1em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#5b2c6f")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#f8f4fc"),
    radius: (right: 4pt),
  )[
    *#smallcaps[Teorema] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #emph(corpo)
  ]
  v(1em)
}

// Lemma — box viola chiaro
#let lemma(corpo, titolo: none) = {
  v(1em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#7d3c98")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#faf5fe"),
    radius: (right: 4pt),
  )[
    *#smallcaps[Lemma] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #emph(corpo)
  ]
  v(1em)
}

// Corollario — box viola chiaro
#let corollario(corpo, titolo: none) = {
  v(1em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#7d3c98")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#faf5fe"),
    radius: (right: 4pt),
  )[
    *#smallcaps[Corollario] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #emph(corpo)
  ]
  v(1em)
}

// Proposizione — box viola chiaro
#let proposizione(corpo, titolo: none) = {
  v(1em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#7d3c98")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#faf5fe"),
    radius: (right: 4pt),
  )[
    *#smallcaps[Proposizione] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #emph(corpo)
  ]
  v(1em)
}

// ============================================================
// AMBIENTI DI SUPPORTO (box colorati)
// ============================================================

// Dimostrazione — box tratteggiato grigio, corpo 10pt
#let dimostrazione(corpo, stile: none) = {
  v(0.8em)
  rect(
    width: 100%,
    stroke: (left: 3pt + rgb("#95a5a6")),
    inset: (x: 1.2em, y: 0.8em),
    fill: rgb("#fafafa"),
    radius: (right: 4pt),
  )[
    #set text(size: 10pt)
    #if stile != none {
      [_*Dimostrazione (#stile).*_]
    } else {
      [_*Dimostrazione.*_]
    }
    #[ ] #corpo
    #h(1fr) $square.stroked$
  ]
  v(0.8em)
}

// Esempio — box arancione
#let esempio(corpo, titolo: none) = {
  v(1em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#e67e22")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#fffaf5"),
    radius: (right: 4pt),
  )[
    *#smallcaps[Esempio] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #corpo
  ]
  v(1em)
}

// Osservazione — box grigio
#let osservazione(corpo) = {
  v(1em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#7f8c8d")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#fdfdfd"),
    radius: (right: 4pt),
  )[
    *#smallcaps[Osservazione] #_prossimo-numero().* #corpo
  ]
  v(1em)
}

// Esercizio — box verde
#let esercizio(corpo, tipo: none) = {
  v(1em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#27ae60")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#f0faf4"),
    radius: (right: 4pt),
  )[
    #if tipo != none {
      [*#smallcaps[Esercizio] #_prossimo-numero() — #tipo.*]
    } else {
      [*#smallcaps[Esercizio] #_prossimo-numero().*]
    }
    #[ ] #corpo
  ]
  v(1em)
}

// Nota — box azzurro chiaro
#let nota(corpo, titolo: none) = {
  v(0.8em)
  rect(
    width: 100%,
    stroke: (left: 3pt + rgb("#3498db")),
    inset: (x: 1.2em, y: 0.8em),
    fill: rgb("#f5faff"),
    radius: (right: 4pt),
  )[
    #if titolo != none {
      [_*Nota (#titolo).*_]
    } else {
      [_*Nota.*_]
    }
    #[ ] #corpo
  ]
  v(0.8em)
}

// Attenzione — box rosso
#let attenzione(corpo) = {
  v(0.8em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#e74c3c")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#fdf2f2"),
    radius: (right: 4pt),
  )[
    *Attenzione:* #corpo
  ]
  v(0.8em)
}

// Da ricordare — box teal
#let ricorda(corpo) = {
  v(0.8em)
  rect(
    width: 100%,
    stroke: (left: 4pt + rgb("#16a085")),
    inset: (x: 1.2em, y: 1em),
    fill: rgb("#f0faf8"),
    radius: (right: 4pt),
  )[
    *Da ricordare.* #corpo
  ]
  v(0.8em)
}

// ============================================================
// AMBIENTI SPECIFICI PER PROGRAMMAZIONE
// ============================================================

// Sfondo per codice
#let code-bg = rgb("#f5f5f5")

// Algoritmo/Pseudocodice (box grigio chiaro)
#let algoritmo(corpo, titolo: none) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (x: 1em, y: 0.8em),
    fill: code-bg,
    stroke: 1pt + luma(200),
    radius: 3pt,
  )[
    #if titolo != none [
      #text(size: 9pt, weight: "bold")[#titolo]
      #v(0.3em)
    ]
    #set text(size: 9.5pt, font: "Source Code Pro")
    #set par(justify: false, leading: 0.6em)
    #corpo
  ]
  v(0.5em)
}

// Codice inline
#let codice(corpo) = {
  box(
    fill: code-bg,
    inset: (x: 0.3em, y: 0.1em),
    radius: 2pt,
  )[#text(size: 9.5pt, font: "Source Code Pro")[#corpo]]
}

// ============================================================
// HELPER DIAGRAMMI CON CETZ
// ============================================================

/// Visualizzazione array con indici sotto ogni cella.
/// - valori: array di valori da mostrare
/// - evidenzia: array di indici (1-based) da evidenziare con sfondo grigio
/// - inizio: indice del primo elemento (default 1)
#let array-viz(valori, evidenzia: (), inizio: 1) = {
  let n = valori.len()
  let cella = 0.8
  let altezza = 0.7
  align(center, cetz.canvas({
    import cetz.draw: *
    for i in range(n) {
      let x = float(i) * cella
      let riempi = if (i + inizio) in evidenzia { luma(220) } else { white }
      rect((x, 0), (x + cella, altezza), fill: riempi, stroke: 0.5pt + black)
      content((x + cella / 2, altezza / 2), text(size: 9pt)[#valori.at(i)])
      content((x + cella / 2, -0.3), text(size: 7pt, fill: luma(100))[#(i + inizio)])
    }
  }))
}

/// Albero binario generico con posizionamento manuale.
/// - nodi: array di (etichetta, x, y) per ogni nodo
/// - archi: array di (indice_da, indice_a) con indici in nodi
#let albero-binario(nodi, archi) = {
  let raggio = 0.35
  align(center, cetz.canvas({
    import cetz.draw: *
    // Archi (dietro i nodi)
    for (da, a) in archi {
      let (_, dx, dy) = nodi.at(da)
      let (_, ax, ay) = nodi.at(a)
      line((dx, dy), (ax, ay), stroke: 0.5pt + luma(120))
    }
    // Nodi (sopra gli archi)
    for (etichetta, x, y) in nodi {
      circle((x, y), radius: raggio, fill: white, stroke: 0.5pt + black)
      content((x, y), text(size: 9pt)[#etichetta])
    }
  }))
}

/// Visualizzazione heap: albero binario + array sottostante.
/// - valori: array (0-based) dei valori; l'indice heap è 1-based.
#let heap-viz(valori) = {
  let n = valori.len()
  if n == 0 { return }
  let livelli = calc.floor(calc.log(n, base: 2)) + 1
  let larghezza = float(calc.pow(2, livelli - 1)) * 1.4
  let raggio = 0.35
  let spaziatura-y = 1.3

  // Posizione nodo i (1-based)
  let nodo-pos = (i) => {
    let liv = calc.floor(calc.log(i, base: 2))
    let pos = i - calc.pow(2, liv)
    let nodi-liv = calc.pow(2, liv)
    let x = (float(pos) + 0.5) / float(nodi-liv) * larghezza
    let y = -float(liv) * spaziatura-y
    (x, y)
  }

  align(center, cetz.canvas({
    import cetz.draw: *

    // Archi
    for i in range(1, n + 1) {
      let (px, py) = nodo-pos(i)
      let sin = 2 * i
      let des = 2 * i + 1
      if sin <= n {
        let (cx, cy) = nodo-pos(sin)
        line((px, py), (cx, cy), stroke: 0.5pt + luma(120))
      }
      if des <= n {
        let (cx, cy) = nodo-pos(des)
        line((px, py), (cx, cy), stroke: 0.5pt + luma(120))
      }
    }

    // Nodi
    for i in range(1, n + 1) {
      let (x, y) = nodo-pos(i)
      circle((x, y), radius: raggio, fill: white, stroke: 0.5pt + black)
      content((x, y), text(size: 9pt)[#valori.at(i - 1)])
    }

    // Array sotto l'albero
    let cella = 0.8
    let array-y = -float(livelli) * spaziatura-y - 0.3
    let offset-x = (larghezza - float(n) * cella) / 2.0
    for i in range(n) {
      let x = offset-x + float(i) * cella
      rect((x, array-y - 0.7), (x + cella, array-y), fill: white, stroke: 0.5pt + black)
      content((x + cella / 2, array-y - 0.35), text(size: 8pt)[#valori.at(i)])
      content((x + cella / 2, array-y - 1.0), text(size: 7pt, fill: luma(100))[#(i + 1)])
    }
  }))
}

// ============================================================
// ALIAS PER RETROCOMPATIBILITA
// ============================================================
#let definition(body, title: none) = definizione(body, titolo: title)
#let theorem(body, title: none) = teorema(body, titolo: title)
#let example(body, title: none) = esempio(body, titolo: title)
#let note(body, title: none) = nota(body, titolo: title)
#let observation(body) = osservazione(body)
#let demonstration(body) = dimostrazione(body)
#let algorithm(body, title: none) = algoritmo(body, titolo: title)
#let code(body) = codice(body)
#let keypoint(body) = ricorda(body)
#let corollary(body, title: none) = corollario(body, titolo: title)
