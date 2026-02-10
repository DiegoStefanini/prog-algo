#import "../template.typ": *

Le grammatiche formali, introdotte nel capitolo precedente, possono essere lette in due modi complementari. Questa doppia lettura è alla base della semantica formale dei linguaggi di programmazione.

#definition(title: "Lettura generativa e lettura induttiva")[
  Data una produzione come $S ::= a b | a S b$, possiamo interpretarla in due modi:
  - *Lettura generativa (produttiva)*: la grammatica è vista come un insieme di regole di riscrittura. La produzione si legge da sinistra verso destra: ogni volta che incontro il simbolo $S$, posso rimpiazzarlo con $a b$ oppure con $a S b$. Questa lettura descrive come _generare_ stringhe.
  - *Lettura induttiva (costruttiva)*: la grammatica è una definizione induttiva. La produzione si legge da destra verso sinistra: la clausola $S ::= a b$ afferma che $a b in L(S)$ (caso base), mentre $S ::= a S b$ afferma che se $w in L(S)$ allora anche $a w b in L(S)$ (passo induttivo). Questa lettura descrive come _costruire_ l'insieme delle stringhe valide.
]

La lettura induttiva è particolarmente importante perché ci permette di utilizzare le *regole di inferenza* per definire la semantica di un linguaggio di programmazione in modo rigoroso.

== Regole di inferenza

Per definire la semantica del linguaggio MAO utilizzeremo le regole di inferenza, uno strumento formale che permette di derivare nuovi giudizi (conclusioni) a partire da giudizi già noti (premesse).

#definition(title: "Regola di inferenza")[
  Una regola di inferenza ha la seguente forma: date premesse $p_1, ..., p_n$ e una conclusione $q$, scriviamo:

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 5pt)[$p_1 space ... space p_n$] \
    $q$ #h(1cm) (Nome-Regola)
  ]

  La regola si legge: "se tutte le premesse $p_1, ..., p_n$ sono vere, allora si può trarre la conclusione $q$".
]

Quando le premesse sono vuote, la regola si chiama #underline[assioma]: una verità che vale senza bisogno di giustificazione.

#definition(title: "Assioma")[
  Un assioma è una regola di inferenza senza premesse:

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 5pt)[$ $] \
    $q$ #h(1cm) (Nome-Assioma)
  ]

  L'assioma afferma che $q$ è vero incondizionatamente.
]

=== Produzioni come regole di inferenza

Le produzioni di una grammatica possono essere viste come regole di inferenza. Consideriamo una grammatica per le espressioni aritmetiche con le produzioni:

$"Exp" ::= "Exp" + "Pro" | "Pro"$ #h(1cm) $"Pro" ::= "Pro" times "Cifra" | "Cifra"$ #h(1cm) $"Cifra" ::= 0 | 1 | ... | 9$

Ogni produzione corrisponde a una regola di inferenza letta induttivamente:

#align(center)[
  #grid(
    columns: (auto, auto),
    column-gutter: 2cm,
    row-gutter: 0.6cm,
    align: center,
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$y in L("Exp")$ #h(0.5cm) $z in L("Pro")$] \
      $y + z in L("Exp")$ #h(0.5cm) (Exp-Sum)
    ],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$z in L("Pro")$] \
      $z in L("Exp")$ #h(0.5cm) (Exp-Pro)
    ],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$z in L("Pro")$ #h(0.5cm) $c in L("Cifra")$] \
      $z times c in L("Pro")$ #h(0.5cm) (Pro-Mul)
    ],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$c in L("Cifra")$] \
      $c in L("Pro")$ #h(0.5cm) (Pro-Cifra)
    ],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
      $5 in L("Cifra")$ #h(0.5cm) (Cifra-5)
    ],
  )
]

Ad esempio, la regola (Exp-Sum) si legge: "se $y$ è un'espressione e $z$ è un prodotto, allora $y + z$ è un'espressione". La regola (Cifra-5) è un assioma: 5 è una cifra senza bisogno di ulteriori giustificazioni.

== Sistemi logici

#definition(title: "Sistema logico")[
  Un *sistema logico* è un insieme di regole di inferenza (e assiomi) che possono essere applicate per dimostrare la validità di formule, dette _giudizi_. Fissato un sistema logico, diciamo che un giudizio $q$ è *derivabile* se esiste una sequenza di applicazioni di regole che lo dimostra.
]

#example(title: "Derivazione in un sistema logico")[
  Consideriamo il sistema logico associato alla grammatica delle espressioni aritmetiche mostrata sopra. Vogliamo mostrare che $2 times 3$ è un'espressione valida, cioè che $2 times 3 in L("Exp")$.

  Per farlo, costruiamo una derivazione applicando le regole dal basso verso l'alto:
  + $2 in L("Cifra")$ per l'assioma (Cifra-2), e quindi $2 in L("Pro")$ per (Pro-Cifra)
  + $3 in L("Cifra")$ per l'assioma (Cifra-3)
  + Da $2 in L("Pro")$ e $3 in L("Cifra")$, otteniamo $2 times 3 in L("Pro")$ per la regola (Pro-Mul)
  + Da $2 times 3 in L("Pro")$, otteniamo $2 times 3 in L("Exp")$ per la regola (Exp-Pro)
]

=== Derivazione

#definition(title: "Derivazione")[
  Una *derivazione* nel sistema logico è una sequenza di passaggi che, partendo dagli assiomi e applicando le regole di inferenza, giustifica una certa conclusione. Si scrive $d tack q$ e si legge "la derivazione $d$ dimostra il giudizio $q$", oppure "$d$ è una derivazione per $q$".
]

Le derivazioni sono definite ricorsivamente:
- *Caso base*: ogni assioma del sistema logico è una derivazione per la sua conclusione $q$.
- *Passo induttivo*: se esiste una regola

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$p_1 space ... space p_n$] \
    $q$
  ]

  del sistema logico, e le premesse sono derivabili ($d_1 tack p_1, ..., d_n tack p_n$), allora la composizione delle sotto-derivazioni è una derivazione per $q$.

#example(title: "Derivazione per $2 times 3 in L(\"Exp\")$")[
  Rappresentiamo la derivazione come albero di regole applicate (le foglie sono assiomi):

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[
      #grid(
        columns: (auto, auto),
        column-gutter: 0.5cm,
        align: center + bottom,
        [
          #box(stroke: (bottom: 1pt), inset: 3pt)[
            #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
            $2 in L("Cifra")$
          ] \
          $2 in L("Pro")$
        ],
        [
          #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
          $3 in L("Cifra")$
        ],
      )
    ] \
    $2 times 3 in L("Pro")$
  ]

  Da questa derivazione, applicando (Exp-Pro), concludiamo $2 times 3 in L("Exp")$.
]

=== Alberi di derivazione

Le derivazioni formano naturalmente una *struttura ad albero*, anche se in questo caso la radice (la conclusione finale) è posta verso il basso, e le foglie (gli assiomi) sono in alto. Ogni nodo interno corrisponde all'applicazione di una regola, e i suoi figli sono le sotto-derivazioni delle premesse.

#note[
  Non confondere gli alberi di derivazione della semantica (che crescono verso il basso con la conclusione in fondo) con gli alberi di derivazione delle grammatiche (capitolo 2), che hanno la radice in alto.
]

=== Grammatiche come sistemi logici

Possiamo formalizzare il legame tra grammatiche e sistemi logici. Invece di usare rappresentazioni grafiche colorate, introduciamo le formule $x in L(X)$, con il significato che "la stringa $x$ appartiene al linguaggio generato dal non-terminale $X$".

Ad ogni produzione della grammatica della forma $X ::= omega_0 X_1 omega_1 X_2 omega_2 ... X_n omega_n$ (dove $omega_i in T^*$ sono stringhe di terminali e $X_i in N$ sono non-terminali) associamo una regola di inferenza:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$x_1 in L(X_1)$ #h(0.3cm) $x_2 in L(X_2)$ #h(0.3cm) $...$ #h(0.3cm) $x_n in L(X_n)$] \
  $omega_0 x_1 omega_1 x_2 omega_2 ... x_n omega_n in L(X)$
]

=== Valutazione di espressioni

I sistemi logici permettono non solo di stabilire se una stringa appartiene a un linguaggio, ma anche di assegnare un *significato* (valore) alle espressioni, seguendone la struttura grammaticale.

#example(title: "Grammatica ambigua delle espressioni")[
  Riprendiamo la grammatica ambigua delle espressioni con sole cifre:

  $E ::= 0 | 1 | 2 | ... | 9 | E + E | E times E$

  Per ogni espressione $w$ definiamo un predicato di valutazione $w arrow.b.double v$, che si legge "il termine $w$ ha valore $v$".
]

Definiamo le regole di valutazione come segue. Per le cifre abbiamo assiomi (una per ciascuna cifra da 0 a 9):

#align(center)[
  #grid(
    columns: (auto, auto, auto, auto),
    column-gutter: 1cm,
    align: center,
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
      $0 arrow.b.double 0$ #h(0.5cm) (Val-0)
    ],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
      $1 arrow.b.double 1$ #h(0.5cm) (Val-1)
    ],
    [$...$],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
      $9 arrow.b.double 9$ #h(0.5cm) (Val-9)
    ],
  )
]

Per le operazioni abbiamo regole con premesse:

#align(center)[
  #grid(
    columns: (auto, auto),
    column-gutter: 1.5cm,
    align: center,
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$x_1 arrow.b.double n_1$ #h(0.5cm) $x_2 arrow.b.double n_2$ #h(0.5cm) $n = n_1 + n_2$] \
      $x_1 + x_2 arrow.b.double n$ #h(0.5cm) (Val-Sum)
    ],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$x_1 arrow.b.double n_1$ #h(0.5cm) $x_2 arrow.b.double n_2$ #h(0.5cm) $n = n_1 times n_2$] \
      $x_1 times x_2 arrow.b.double n$ #h(0.5cm) (Val-Mul)
    ],
  )
]

#example(title: "Derivazione della valutazione di $1 + (3 times 2)$")[
  Vogliamo derivare $1 + (3 times 2) arrow.b.double 7$. Costruiamo l'albero di derivazione:

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[
      #grid(
        columns: (auto, auto, auto),
        column-gutter: 0.4cm,
        align: center + bottom,
        [
          #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
          $1 arrow.b.double 1$
        ],
        [
          #box(stroke: (bottom: 1pt), inset: 3pt)[
            #grid(
              columns: (auto, auto, auto),
              column-gutter: 0.3cm,
              align: center + bottom,
              [
                #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
                $3 arrow.b.double 3$
              ],
              [
                #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
                $2 arrow.b.double 2$
              ],
              [$6 = 3 times 2$],
            )
          ] \
          $3 times 2 arrow.b.double 6$
        ],
        [$7 = 1 + 6$],
      )
    ] \
    $1 + (3 times 2) arrow.b.double 7$
  ]

  La derivazione procede come segue:
  + Per l'assioma (Val-1): $1 arrow.b.double 1$
  + Per l'assioma (Val-3): $3 arrow.b.double 3$ e per (Val-2): $2 arrow.b.double 2$
  + Per la regola (Val-Mul): poiché $3 arrow.b.double 3$ e $2 arrow.b.double 2$ e $6 = 3 times 2$, concludiamo $3 times 2 arrow.b.double 6$
  + Per la regola (Val-Sum): poiché $1 arrow.b.double 1$ e $3 times 2 arrow.b.double 6$ e $7 = 1 + 6$, concludiamo $1 + (3 times 2) arrow.b.double 7$
]

== Induzione

#definition[
  L'*induzione* è un principio fondamentale che permette di trattare insiemi infiniti di oggetti attraverso un numero finito di regole o casi.
]

Il principio di induzione ha tre aspetti fondamentali:
- *Costruzione*: permette di costruire un insieme infinito di oggetti mediante un numero finito di regole (ad esempio, l'insieme dei numeri naturali si definisce con due regole: 0 è un naturale, e se $n$ è un naturale allora $n+1$ è un naturale).
- *Definizione di funzioni*: permette di definire il comportamento di una funzione su un insieme infinito, descrivendo solo un numero finito di casi.
- *Dimostrazione*: permette di dimostrare che una proprietà vale per tutti gli elementi di un insieme infinito, esaminando un numero finito di casi.

=== Induzione matematica

L'induzione matematica permette di dimostrare che una proprietà $P(n)$ vale per tutti i numeri naturali $n >= n_0$.

#definition(title: "Principio di induzione matematica")[
  Per dimostrare $P(n)$ per ogni $n >= n_0$:
  - *Caso base*: dimostrare che $P(n_0)$ vale.
  - *Passo induttivo*: preso un generico $n >= n_0$, assumendo che $P(n)$ sia vera (*ipotesi induttiva*), dimostrare che $P(n+1)$ è vera.
]

#example(title: "Somma dei primi $n$ naturali positivi")[
  Dimostriamo che per ogni naturale positivo $n$:
  $ 1 + 2 + 3 + ... + n = frac(n(n + 1), 2) $

  *Caso base* ($n = 1$): $1 = frac(1 dot 2, 2) = 1$. Verificato.

  *Passo induttivo*: assumiamo che la formula valga per $n$ (ipotesi induttiva):
  $ 1 + 2 + 3 + ... + n = frac(n(n + 1), 2) $
  Dimostriamo che vale per $n + 1$:
  $ 1 + 2 + ... + n + (n + 1) = frac(n(n + 1), 2) + (n + 1) = frac(n(n + 1) + 2(n + 1), 2) = frac((n + 1)(n + 2), 2) $
  L'ultimo passaggio si ottiene raccogliendo $(n + 1)$ a fattor comune. La formula è quindi dimostrata per $n + 1$.
]

=== Induzione strutturale

L'induzione strutturale estende il principio di induzione matematica alle stringhe di un linguaggio generato da una grammatica. Invece di indurre sui numeri naturali, si induce sulla struttura delle stringhe.

#definition(title: "Principio di induzione strutturale")[
  Per dimostrare una proprietà $P(w)$ per tutte le stringhe $w in L(S)$ generate da una grammatica:
  - *Casi base*: dimostrare $P(omega)$ per le stringhe $omega in T^*$ che compaiono nella parte destra delle produzioni _atomiche_ (cioè produzioni della forma $X ::= omega$ senza non-terminali a destra).
  - *Casi induttivi*: per ogni produzione non atomica della forma $X ::= omega_0 Y_1 omega_1 ... Y_n omega_n$, assumendo che $P(s_1), ..., P(s_n)$ valgano per le stringhe $s_i$ generate dai non-terminali $Y_i$ (ipotesi induttiva), dimostrare che $P(omega_0 s_1 omega_1 ... s_n omega_n)$ vale.
]

=== Induzione sulle derivazioni

L'induzione sulle derivazioni permette di dimostrare proprietà valide per tutti i giudizi derivabili in un sistema logico. A differenza dell'induzione strutturale (che lavora sulla struttura delle stringhe), qui si lavora sulla *struttura delle derivazioni* stesse.

#definition(title: "Principio di induzione sulle derivazioni")[
  Sia $cal(S)$ un sistema logico e $P$ una proprietà sui giudizi. Per dimostrare che $P(J)$ vale per ogni giudizio $J$ derivabile in $cal(S)$:

  *Casi base (assiomi):* Per ogni assioma
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
    $q$
  ]
  del sistema, dimostrare che $P(q)$ vale.

  *Casi induttivi (regole):* Per ogni regola
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$p_1 space ... space p_n$] \
    $q$
  ]
  del sistema, assumendo che $P(p_1), ..., P(p_n)$ valgano (*ipotesi induttiva*), dimostrare che $P(q)$ vale.
]

#note(title: "Intuizione")[
  L'induzione sulle derivazioni riflette il modo in cui i giudizi vengono costruiti: partendo dagli assiomi (verità di base) e applicando regole di inferenza. Se una proprietà vale per le "fondamenta" (assiomi) e si "propaga" attraverso le regole, allora vale per tutto ciò che è derivabile.
]

#example(title: "Applicazione: correttezza della valutazione")[
  Consideriamo il sistema logico per la valutazione di espressioni aritmetiche con le regole:

  #align(center)[
    #grid(
      columns: (auto, auto),
      column-gutter: 1.5cm,
      align: center,
      [
        #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
        $n arrow.b.double n$ #h(0.5cm) (Val-Num)
      ],
      [
        #box(stroke: (bottom: 1pt), inset: 3pt)[$e_1 arrow.b.double v_1$ #h(0.3cm) $e_2 arrow.b.double v_2$] \
        $e_1 + e_2 arrow.b.double v_1 + v_2$ #h(0.5cm) (Val-Sum)
      ],
    )
  ]

  Vogliamo dimostrare: "Se $e arrow.b.double v$ è derivabile, allora $v$ è un numero intero".

  *Caso base (Val-Num):* $n arrow.b.double n$. Il valore $n$ è un numero intero per definizione.

  *Caso induttivo (Val-Sum):* Assumiamo (ipotesi induttiva) che $v_1$ e $v_2$ siano interi. Allora $v_1 + v_2$ è la somma di due interi, quindi è un intero.
]

#example(title: "Confronto dei tre tipi di induzione")[
  #table(
    columns: (1fr, 1fr, 1fr),
    align: (left, left, left),
    table.header(
      [*Induzione matematica*],
      [*Induzione strutturale*],
      [*Induzione sulle derivazioni*]
    ),
    [Sui numeri naturali $bb(N)$],
    [Sulle stringhe di $L(G)$],
    [Sui giudizi derivabili],
    [Caso base: $n = 0$],
    [Caso base: produzioni atomiche],
    [Caso base: assiomi],
    [Passo: $n arrow.r n+1$],
    [Passo: produzioni ricorsive],
    [Passo: regole di inferenza],
    [Esempio: somma dei primi $n$],
    [Esempio: $\#_a(w) = \#_b(w)$],
    [Esempio: correttezza semantica],
  )
]

Questa tecnica sarà fondamentale per dimostrare proprietà della semantica di MAO, come ad esempio:
- *Determinismo*: se $chevron.l e, rho, sigma chevron.r arrow.b.double v_1$ e $chevron.l e, rho, sigma chevron.r arrow.b.double v_2$, allora $v_1 = v_2$
- *Type soundness*: se un'espressione è ben tipata, la sua valutazione non produce errori di tipo

#note(title: "Anticipazione: regole di tipo per gli operatori di confronto")[
  Il sistema di tipi formale di MAO (presentato nel capitolo dedicato al linguaggio MAO completo) include una regola *T-Cop* per gli operatori di confronto ($<, <=, >, >=, ==, !=$). In tale regola, gli operandi sono vincolati ad avere tipo `int`. Si osservi tuttavia che, a livello semantico, gli operatori di uguaglianza `==` e disuguaglianza `!=` sono definiti anche su operandi booleani (come indicato nella tabella degli operatori di MiniMao). Questa discrepanza è una scelta progettuale comune nei linguaggi didattici: il type checker può essere reso più permissivo estendendo T-Cop con una seconda variante che ammetta operandi di tipo `bool` per `==` e `!=`. Per i dettagli completi si rimanda alla sezione sulle regole di type checking nel capitolo su MAO.
]

== Esercizi: Dimostrazioni Induttive su Grammatiche

In questa sezione vengono presentati esercizi di dimostrazione per induzione strutturale su grammatiche context-free. Per ogni esercizio si richiede di dimostrare una proprietà valida per tutte le stringhe del linguaggio generato.

=== Esercizio 1: Bilanciamento di $a$ e $b$

#example(title: "Grammatica")[
  Data la grammatica:
  $ S ::= a S b | a b $

  Dimostrare per induzione strutturale che ogni stringa $w in L(S)$ soddisfa $\#_a (w) = \#_b (w)$, dove $\#_a (w)$ indica il numero di occorrenze del simbolo $a$ nella stringa $w$.
]

#demonstration[
  Procediamo per induzione strutturale sulla derivazione di $w$.

  *Caso base:* $S arrow.r a b$

  La stringa generata è $w = a b$. Contiamo le occorrenze:
  - $\#_a (a b) = 1$
  - $\#_b (a b) = 1$

  Quindi $\#_a (w) = \#_b (w) = 1$. #sym.checkmark

  *Caso induttivo:* $S arrow.r a S b$

  Assumiamo per ipotesi induttiva che la stringa $w'$ generata da $S$ soddisfi $\#_a (w') = \#_b (w') = k$ per qualche $k >= 1$.

  La nuova stringa è $w = a w' b$. Contiamo le occorrenze:
  - $\#_a (a w' b) = 1 + \#_a (w') = 1 + k$
  - $\#_b (a w' b) = \#_b (w') + 1 = k + 1$

  Quindi $\#_a (w) = \#_b (w) = k + 1$. #sym.checkmark
]

#example(title: "Alberi di derivazione")[
  Mostriamo gli alberi di derivazione per alcune stringhe del linguaggio:

  *Stringa $a b$* (caso base):
  ```
      S
     / \
    a   b
  ```

  *Stringa $a a b b$* (una applicazione della regola ricorsiva):
  ```
        S
      / | \
     a  S  b
       / \
      a   b
  ```

  *Stringa $a a a b b b$* (due applicazioni della regola ricorsiva):
  ```
          S
        / | \
       a  S  b
        / | \
       a  S  b
         / \
        a   b
  ```
]

#note[
  Il linguaggio $L(S) = \{a^n b^n | n >= 1\}$ è l'esempio classico di linguaggio context-free non regolare. La proprietà dimostrata ($\#_a = \#_b$) è necessaria ma non sufficiente per caratterizzare il linguaggio (ad esempio $a b a b$ ha lo stesso numero di $a$ e $b$ ma non appartiene a $L(S)$).
]

=== Esercizio 2: Stringhe con esattamente una $c$

#example(title: "Grammatica")[
  Data la grammatica:
  $ S ::= b S a | a S b | c $

  Dimostrare per induzione strutturale che ogni stringa $w in L(S)$ soddisfa:
  + $\#_c (w) = 1$ (esattamente una occorrenza di $c$)
  + $\#_a (w) = \#_b (w)$ (stesso numero di $a$ e $b$)
]

#demonstration[
  Procediamo per induzione strutturale sulla derivazione di $w$.

  *Caso base:* $S arrow.r c$

  La stringa generata è $w = c$. Verifichiamo:
  - $\#_c (c) = 1$ #sym.checkmark
  - $\#_a (c) = 0 = \#_b (c)$ #sym.checkmark

  *Caso induttivo 1:* $S arrow.r b S a$

  Assumiamo per ipotesi induttiva che la stringa $w'$ generata da $S$ soddisfi $\#_c (w') = 1$ e $\#_a (w') = \#_b (w') = k$ per qualche $k >= 0$.

  La nuova stringa è $w = b w' a$. Verifichiamo:
  - $\#_c (b w' a) = \#_c (w') = 1$ #sym.checkmark
  - $\#_a (b w' a) = \#_a (w') + 1 = k + 1$
  - $\#_b (b w' a) = 1 + \#_b (w') = 1 + k = k + 1$

  Quindi $\#_a (w) = \#_b (w) = k + 1$. #sym.checkmark

  *Caso induttivo 2:* $S arrow.r a S b$

  Assumiamo per ipotesi induttiva che la stringa $w'$ generata da $S$ soddisfi $\#_c (w') = 1$ e $\#_a (w') = \#_b (w') = k$ per qualche $k >= 0$.

  La nuova stringa è $w = a w' b$. Verifichiamo:
  - $\#_c (a w' b) = \#_c (w') = 1$ #sym.checkmark
  - $\#_a (a w' b) = 1 + \#_a (w') = 1 + k$
  - $\#_b (a w' b) = \#_b (w') + 1 = k + 1$

  Quindi $\#_a (w) = \#_b (w) = k + 1$. #sym.checkmark
]

#example(title: "Alberi di derivazione")[
  Mostriamo gli alberi di derivazione per alcune stringhe del linguaggio:

  *Stringa $c$* (caso base):
  ```
    S
    |
    c
  ```

  *Stringa $b c a$* (regola $b S a$):
  ```
      S
    / | \
   b  S  a
      |
      c
  ```

  *Stringa $a c b$* (regola $a S b$):
  ```
      S
    / | \
   a  S  b
      |
      c
  ```

  *Stringa $a b c a b$* (composizione di regole):
  ```
          S
        / | \
       a  S  b
        / | \
       b  S  a
          |
          c
  ```
  Derivazione: $S arrow.r a S b arrow.r a b S a b arrow.r a b c a b$
]

#note[
  Questa grammatica genera il linguaggio delle stringhe palindrome? No! Ad esempio $a b c b a$ non è generabile. La grammatica genera stringhe dove $c$ è sempre al centro, ma le $a$ e $b$ a sinistra e destra di $c$ non sono necessariamente simmetriche.
]

=== Esercizio 3: Almeno una $a$

#example(title: "Grammatica")[
  Data la grammatica:
  $ S ::= S a | S b | a $

  Dimostrare per induzione strutturale che ogni stringa $w in L(S)$ soddisfa $\#_a (w) >= 1$.
]

#demonstration[
  Procediamo per induzione strutturale sulla derivazione di $w$.

  *Caso base:* $S arrow.r a$

  La stringa generata è $w = a$. Verifichiamo:
  - $\#_a (a) = 1 >= 1$ #sym.checkmark

  *Caso induttivo 1:* $S arrow.r S a$

  Assumiamo per ipotesi induttiva che la stringa $w'$ generata da $S$ soddisfi $\#_a (w') >= 1$.

  La nuova stringa è $w = w' a$. Verifichiamo:
  - $\#_a (w' a) = \#_a (w') + 1 >= 1 + 1 = 2 >= 1$ #sym.checkmark

  *Caso induttivo 2:* $S arrow.r S b$

  Assumiamo per ipotesi induttiva che la stringa $w'$ generata da $S$ soddisfi $\#_a (w') >= 1$.

  La nuova stringa è $w = w' b$. Verifichiamo:
  - $\#_a (w' b) = \#_a (w') >= 1$ #sym.checkmark

  (Aggiungere una $b$ non cambia il numero di $a$, che rimane almeno 1.)
]

#example(title: "Alberi di derivazione")[
  Mostriamo gli alberi di derivazione per alcune stringhe del linguaggio:

  *Stringa $a$* (caso base):
  ```
    S
    |
    a
  ```

  *Stringa $a b$*:
  ```
      S
     / \
    S   b
    |
    a
  ```

  *Stringa $a a$*:
  ```
      S
     / \
    S   a
    |
    a
  ```

  *Stringa $a b a b$*:
  ```
            S
           / \
          S   b
         / \
        S   a
       / \
      S   b
      |
      a
  ```
  Derivazione: $S arrow.r S b arrow.r S a b arrow.r S b a b arrow.r a b a b$
]

#note[
  Questa grammatica genera il linguaggio $L(S) = \{a\} dot (a | b)^*$, cioè tutte le stringhe su $\{a, b\}$ che iniziano con $a$. La proprietà dimostrata ($\#_a >= 1$) è una conseguenza immediata di questa caratterizzazione: ogni stringa inizia con almeno una $a$.
]

=== Osservazioni metodologiche

#note(title: "Schema generale per l'induzione strutturale")[
  Per dimostrare una proprietà $P(w)$ per tutte le stringhe $w in L(S)$:

  + *Identificare i casi base*: produzioni della forma $X ::= omega$ dove $omega in T^*$ (solo terminali)

  + *Identificare i casi induttivi*: produzioni della forma $X ::= alpha_1 Y_1 alpha_2 Y_2 ... Y_n alpha_(n+1)$ dove $Y_i$ sono non-terminali

  + *Per ogni caso base*: verificare direttamente che $P(omega)$ vale

  + *Per ogni caso induttivo*: assumere che $P(w_i)$ valga per le stringhe $w_i$ generate dai non-terminali $Y_i$ (ipotesi induttiva), e dimostrare che $P(alpha_1 w_1 alpha_2 w_2 ... w_n alpha_(n+1))$ vale
]
