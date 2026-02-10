// ========================================
// Programmazione ed Algoritmica
// ========================================

#import "template.typ": *

#set document(
  title: "Programmazione ed Algoritmica",
  author: "Diego Stefanini",
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 9pt, style: "italic")
      Programmazione ed Algoritmica #h(1fr) A.A. 2025-2026
      #v(-3pt)
      #line(length: 100%, stroke: 0.4pt)
    ]
  },
  footer: context {
    set text(size: 9pt)
    h(1fr)
    counter(page).display("1")
    h(1fr)
  },
)

#set text(font: "New Computer Modern", size: 11pt, lang: "it")
#set par(justify: true, leading: 0.65em)
#set heading(numbering: "1.1")

// Stile heading livello 1 (capitoli)
#show heading.where(level: 1): it => {
  pagebreak(weak: true)
  reset-counters()
  v(0.5em)
  text(size: 16pt, weight: "bold")[#it]
  v(0.3em)
}

// Stile heading livello 2 (sezioni)
#show heading.where(level: 2): it => {
  v(0.8em)
  it
  v(0.3em)
}

// ========================================
// Pagina titolo
// ========================================

#page(
  margin: (top: 0cm, bottom: 0cm, left: 0cm, right: 0cm),
  header: none,
  footer: none,
)[
  #align(center)[
    #v(6cm)

    #text(size: 28pt, weight: "bold")[Programmazione ed Algoritmica]

    #v(0.8cm)

    #line(length: 30%, stroke: 1pt + luma(120))

    #v(0.8cm)

    #text(size: 13pt, fill: luma(80))[
      Appunti del corso di Laurea in Informatica
    ]

    #v(3cm)

    #text(size: 13pt)[Diego Stefanini]

    #v(0.3cm)

    #text(size: 12pt, fill: luma(80))[cc. Davide Paolocchi]

    #v(1.5cm)

    #text(size: 11pt)[Anno Accademico 2025--2026]

    #v(1fr)

    #text(size: 10pt, fill: luma(120))[
      Università degli Studi di Pisa
    ]

    #v(2cm)
  ]
]

// ========================================
// Indice
// ========================================

#{
  set text(size: 10pt)
  set par(leading: 0.5em)

  outline(
    title: [#text(size: 14pt, weight: "bold")[Indice]],
    indent: 1em,
    depth: 2,
  )
}

// ========================================
// CAPITOLO 1 - INTRODUZIONE
// ========================================

= Introduzione

#include "algoritmica/introduzione.typ"
#include "programmazione/introduzione.typ"

// ========================================
// CAPITOLO 2 - LINGUAGGI FORMALI E GRAMMATICHE
// ========================================

= Linguaggi Formali e Grammatiche

#include "programmazione/alfabeti_stringhe_linguaggi.typ"
#include "programmazione/ling_gen_derivazioni.typ"
#include "programmazione/derivcan_alberi.typ"

// ========================================
// CAPITOLO 3 - SEMANTICA OPERAZIONALE
// ========================================

= Semantica Operazionale

#include "programmazione/inferenza_sislogici.typ"
#include "programmazione/MiniMao.typ"

// ========================================
// CAPITOLO 4 - SISTEMI DI TIPI, FUNZIONI E RICORSIONE
// ========================================

= Sistemi di Tipi, Funzioni e Ricorsione

#include "programmazione/Mao.typ"

// ========================================
// CAPITOLO 5 - COMPLESSITÀ COMPUTAZIONALE
// ========================================

= Complessità Computazionale

#include "algoritmica/complessita_in_tempo.typ"

// ========================================
// CAPITOLO 6 - DIVIDE ET IMPERA
// ========================================

= Divide et Impera

#include "algoritmica/divide_et_impera.typ"

// ========================================
// CAPITOLO 7 - ALGORITMI DI ORDINAMENTO
// ========================================

= Algoritmi di Ordinamento

#include "algoritmica/ordinamenti_elementari.typ"
#include "algoritmica/quicksort.typ"
#include "algoritmica/heap.typ"
#include "algoritmica/ordinamenti_lineari.typ"

// ========================================
// CAPITOLO 8 - STRUTTURE DATI
// ========================================

= Strutture Dati

#include "algoritmica/strutture_dati.typ"
#include "algoritmica/alberi_binari.typ"
