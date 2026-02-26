// ============================================================
// TEMPLATE DISPENSE UNIVERSITARIE - PROGRAMMAZIONE ED ALGORITMICA
// Stile con filetti laterali, small caps, note a margine
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

  // Capitoli: stile "CAPITOLO N" con linee sottili
  show heading.where(level: 1): it => {
    contatore-blocco.update(0)
    pagebreak()
    v(2cm)
    align(center)[
      #line(length: 60%, stroke: 0.4pt + black)
      #v(0.8cm)
      #text(size: 11pt, tracking: 0.2em, fill: luma(80))[CAPITOLO #context counter(heading).display("1")]
      #v(0.4cm)
      #text(size: 22pt, weight: "bold")[#it.body]
      #v(0.8cm)
      #line(length: 60%, stroke: 0.4pt + black)
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
// AMBIENTI TEORICI (con filetti laterali e small caps)
// ============================================================

// Definizione — filetto sinistro 2.5pt nero
#let definizione(corpo, titolo: none) = {
  v(0.8em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.4em, bottom: 0.4em, right: 0.2em),
    stroke: (left: 2.5pt + black),
  )[
    *#smallcaps[Definizione] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #corpo
  ]
  v(0.5em)
}

// Teorema — filetto sinistro 2pt grigio scuro
#let teorema(corpo, titolo: none) = {
  v(0.8em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.4em, bottom: 0.4em, right: 0.2em),
    stroke: (left: 2pt + luma(80)),
  )[
    *#smallcaps[Teorema] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #emph(corpo)
  ]
  v(0.5em)
}

// Lemma — filetto sinistro 2pt grigio scuro
#let lemma(corpo, titolo: none) = {
  v(0.8em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.4em, bottom: 0.4em, right: 0.2em),
    stroke: (left: 2pt + luma(80)),
  )[
    *#smallcaps[Lemma] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #emph(corpo)
  ]
  v(0.5em)
}

// Corollario — filetto sinistro 2pt grigio scuro
#let corollario(corpo, titolo: none) = {
  v(0.8em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.4em, bottom: 0.4em, right: 0.2em),
    stroke: (left: 2pt + luma(80)),
  )[
    *#smallcaps[Corollario] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #emph(corpo)
  ]
  v(0.5em)
}

// Proposizione — filetto sinistro 2pt grigio scuro
#let proposizione(corpo, titolo: none) = {
  v(0.8em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.4em, bottom: 0.4em, right: 0.2em),
    stroke: (left: 2pt + luma(80)),
  )[
    *#smallcaps[Proposizione] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #emph(corpo)
  ]
  v(0.5em)
}

// ============================================================
// AMBIENTI DI SUPPORTO
// ============================================================

// Dimostrazione — filetto sinistro tratteggiato, corpo 10pt
#let dimostrazione(corpo, stile: none) = {
  v(0.6em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.3em, bottom: 0.3em, right: 0.2em),
    stroke: (left: stroke(thickness: 1pt, paint: luma(180), dash: "dashed")),
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
  v(0.5em)
}

// Esempio — filetto sinistro grigio medio
#let esempio(corpo, titolo: none) = {
  v(0.8em)
  block(
    width: 100%,
    inset: (left: 1.2em, top: 0.4em, bottom: 0.4em, right: 0.2em),
    stroke: (left: 1.5pt + luma(150)),
  )[
    *#smallcaps[Esempio] #_prossimo-numero()#if titolo != none and titolo != "" [ (#titolo)].* #corpo
  ]
  v(0.5em)
}

// Osservazione — indent leggero, nessun filetto
#let osservazione(corpo) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (left: 0.8em, top: 0.2em, bottom: 0.2em),
  )[
    *#smallcaps[Osservazione] #_prossimo-numero().* #corpo
  ]
  v(0.4em)
}

// Esercizio — filetto sinistro nero
#let esercizio(corpo, tipo: none) = {
  v(0.8em)
  block(
    width: 100%,
    inset: (left: 1em, top: 0.4em, bottom: 0.4em, right: 0.2em),
    stroke: (left: 1.5pt + black),
  )[
    #if tipo != none {
      [*#smallcaps[Esercizio] #_prossimo-numero() — #tipo.*]
    } else {
      [*#smallcaps[Esercizio] #_prossimo-numero().*]
    }
    #[ ] #corpo
  ]
  v(0.5em)
}

// Nota — indent leggero, nessun filetto
#let nota(corpo, titolo: none) = {
  v(0.4em)
  block(
    width: 100%,
    inset: (left: 0.8em, top: 0.2em, bottom: 0.2em),
  )[
    #if titolo != none {
      [_*Nota (#titolo).*_]
    } else {
      [_*Nota.*_]
    }
    #[ ] #corpo
  ]
  v(0.3em)
}

// Attenzione — indent leggero, nessun filetto
#let attenzione(corpo) = {
  v(0.4em)
  block(
    width: 100%,
    inset: (left: 0.8em, top: 0.2em, bottom: 0.2em),
  )[
    *Attenzione:* #corpo
  ]
  v(0.3em)
}

// Da ricordare
#let ricorda(corpo) = {
  v(0.5em)
  block(
    width: 100%,
    inset: (left: 0.8em, top: 0.2em, bottom: 0.2em),
  )[
    *Da ricordare.* #corpo
  ]
  v(0.4em)
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
