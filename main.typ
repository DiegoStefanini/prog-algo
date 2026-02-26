// ============================================================
// PROGRAMMAZIONE ED ALGORITMICA - DISPENSE COMPLETE
// ============================================================

#import "template.typ": *

#show: conf

// ============================================================
// COPERTINA
// ============================================================
#set page(numbering: none)

#v(2cm)

#align(center)[
  #text(size: 14pt, tracking: 0.3em)[UNIVERSITÀ DI PISA]

  #v(0.3cm)

  #text(size: 11pt)[Dipartimento di Informatica]

  #v(0.2cm)

  #text(size: 11pt)[Corso di Laurea in Informatica]
]

#v(2cm)

#align(center)[
  #block(
    width: 80%,
    stroke: (y: 1pt + black),
    inset: (y: 15pt),
  )[
    #set par(justify: false, leading: 0.5em)
    #text(size: 28pt, weight: "bold")[Programmazione \ ed Algoritmica]

    #v(0.5cm)

    #text(size: 14pt)[Dispense per il Corso di Laurea in Informatica]
  ]
]

#v(2cm)

#align(center)[
  #grid(
    columns: 2,
    column-gutter: 3cm,
    row-gutter: 0.8cm,
    align: (right, left),
    [#text(weight: "bold")[Docente:]], [Prof.ssa Anna Bernasconi],
    [#text(weight: "bold")[Autore:]], [Diego Stefanini],
    [#text(weight: "bold")[cc:]], [Davide Paolocchi],
  )
]

#v(1fr)

#align(center)[
  #line(length: 30%, stroke: 0.5pt + gray)

  #v(0.5cm)

  #text(size: 11pt)[Anno Accademico 2025/2026]

  #v(0.3cm)

  #text(size: 9pt, fill: gray)[
    Ultima revisione: #datetime.today().display("[day]/[month]/[year]")
  ]
]

#v(1cm)

// ============================================================
// PREFAZIONE
// ============================================================
#pagebreak()
#set page(numbering: "i")

#align(center)[
  #text(size: 16pt, weight: "bold")[Prefazione]
]

#v(0.5cm)

Queste dispense raccolgono gli argomenti del corso di Programmazione ed Algoritmica. Il testo copre sia la parte algoritmica --- complessità, ordinamento, strutture dati --- sia la parte di linguaggi di programmazione --- grammatiche formali, semantica operazionale, sistemi di tipi. L'obiettivo è fornire un riferimento auto-consistente per lo studio autonomo.

#v(0.3cm)

*Struttura del testo.* I primi quattro capitoli trattano i fondamenti dei linguaggi di programmazione: dalla definizione formale della sintassi tramite grammatiche, alla semantica operazionale dei programmi, fino ai sistemi di tipi e alle funzioni ricorsive. I capitoli successivi sviluppano la parte algoritmica: complessità computazionale, tecniche di progettazione (divide et impera), algoritmi di ordinamento e strutture dati fondamentali.

#v(0.3cm)

*Convenzioni tipografiche.* I *termini definiti per la prima volta* sono indicati in grassetto all'interno delle definizioni. Gli _enunciati di teoremi e proposizioni_ sono in corsivo. Le dimostrazioni si concludono con il simbolo $square.stroked$. Lo pseudocodice è presentato nella sintassi del linguaggio MAO, con `=` per le dichiarazioni e `:=` per gli assegnamenti.

// ============================================================
// INDICE
// ============================================================
#pagebreak()

#v(2cm)
#align(center)[
  #line(length: 70%, stroke: 0.5pt + black)
  #v(0.5cm)
  #text(size: 22pt, weight: "bold")[Indice]
  #v(0.5cm)
]
#v(0.5cm)
#outline(title: none, indent: 1.5em, depth: 2)

// ============================================================
// CONTENUTO
// ============================================================
#pagebreak()
#set page(numbering: "1")
#counter(page).update(1)

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
#include "algoritmica/tabelle_hash.typ"
