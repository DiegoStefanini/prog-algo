#import "../template.typ": *

== Alfabeti, Stringhe e Linguaggi

=== Alfabeto

#definition(title: "Alfabeto")[
  Un *alfabeto* $A$ è un insieme #underline[finito] e non vuoto di simboli. I singoli elementi dell'alfabeto sono chiamati *simboli* o *caratteri*.
]

#example(title: "Alfabeti comuni")[
  - Alfabeto latino minuscolo: $A_1 = {a, b, c, d, ..., z}$
  - Alfabeto binario: $A_2 = {0, 1}$
  - Alfabeto di un linguaggio di programmazione: $A_3 = {a, ..., z, 0, ..., 9, +, -, times, ...}$
]

=== Stringa

#definition(title: "Stringa")[
  Una *stringa* (o *parola*) su un alfabeto $A$ è una sequenza finita di simboli appartenenti ad $A$. Formalmente, dati $a_1, a_2, ..., a_n in A$ con $n >= 0$, la sequenza $a_1 a_2 dots.c a_n$ è una stringa su $A$.
]

==== Lunghezza di una stringa

#definition(title: "Lunghezza")[
  La *lunghezza* di una stringa $s = a_1 a_2 dots.c a_n$ è il numero naturale $n$ di simboli che la compongono e si denota con $|s|$.
]

#definition(title: "Stringa vuota")[
  Se $n = 0$ la stringa è detta *stringa vuota* e si denota con $epsilon$. Si ha $|epsilon| = 0$.
]

#example(title: "Lunghezze di stringhe")[
  Sull'alfabeto $A = {a, b, f, z}$: \
  $|a b f b z| = 5$ \
  $|a a a| = 3$ \
  $|epsilon| = 0$
]

=== Operazioni sulle stringhe

==== Concatenazione

#definition(title: "Concatenazione")[
  Date due stringhe $s = a_1 dots.c a_n$ e $t = b_1 dots.c b_m$ su un alfabeto $A$, la *concatenazione* di $s$ e $t$ è la stringa $s dot t = a_1 dots.c a_n b_1 dots.c b_m$. Si ha $|s dot t| = |s| + |t|$.

  La stringa vuota $epsilon$ è l'*elemento neutro* della concatenazione: per ogni stringa $s$, $s dot epsilon = epsilon dot s = s$.
]

#example(title: "Concatenazione")[
  Sull'alfabeto $A = {a, b, c}$: \
  $a b dot c a = a b c a$ \
  $a b dot epsilon = a b$
]

=== Insiemi di stringhe di lunghezza fissata

#definition(title: [Insieme $A^n$])[
  Dato un alfabeto $A$ e un numero naturale $n >= 0$, definiamo $A^n$ come l'insieme di tutte e sole le stringhe su $A$ che hanno lunghezza esattamente $n$.
]

#example(title: [Stringhe su $A = {0, 1}$])[
  $A^0 = {epsilon}$ \
  $A^1 = {0, 1}$ \
  $A^2 = {0 0, 0 1, 1 0, 1 1}$ \
  $A^3 = {0 0 0, 0 0 1, 0 1 0, 0 1 1, 1 0 0, 1 0 1, 1 1 0, 1 1 1}$

  In generale, se $|A| = k$, allora $|A^n| = k^n$.
]

=== Chiusura di Kleene

#definition(title: [Chiusura di Kleene $A^*$])[
  Dato un alfabeto $A$, la *chiusura di Kleene* (o *chiusura riflessiva e transitiva*) $A^*$ è l'insieme di tutte le stringhe su $A$, inclusa la stringa vuota:
  $ A^* = union.big_(n >= 0) A^n = A^0 union A^1 union A^2 union A^3 union dots.c = {epsilon} union A union A^2 union A^3 union dots.c $
]

#note(title: [Cardinalità di $A^*$])[
  Se $A$ non è vuoto, $A^*$ è un insieme *infinito numerabile*: contiene infinite stringhe, ma è possibile elencarle tutte (ad esempio ordinandole per lunghezza crescente e, a parità di lunghezza, in ordine lessicografico).
]

#definition(title: [Chiusura positiva $A^+$])[
  La *chiusura positiva* $A^+$ è l'insieme di tutte le stringhe non vuote su $A$:
  $ A^+ = union.big_(n >= 1) A^n = A^* without {epsilon} $
]

== Linguaggi formali

#definition(title: "Linguaggio formale")[
  Un *linguaggio formale* $L$ su un alfabeto $A$ è un qualunque sottoinsieme di $A^*$:
  $ L subset.eq A^* $
]

#note(title: "Linguaggi particolari")[
  - Il *linguaggio vuoto* $emptyset$ non contiene alcuna stringa (attenzione: $emptyset eq.not {epsilon}$).
  - Il *linguaggio universale* $A^*$ contiene tutte le possibili stringhe su $A$.
  - Il linguaggio ${epsilon}$ contiene solo la stringa vuota.
]

#example(title: "Linguaggi sull'alfabeto binario")[
  Sull'alfabeto $A = {0, 1}$:
  - $L_1 = {0, 1, 0 0, 1 1}$ è un linguaggio finito.
  - $L_2 = {0^n 1^n | n >= 1} = {0 1, 0 0 1 1, 0 0 0 1 1 1, ...}$ è un linguaggio infinito. Contiene le stringhe formate da $n$ zeri seguiti da $n$ uni, con $n >= 1$.
]

=== Descrizione dei linguaggi

Descrivere un linguaggio di programmazione significa specificare l'insieme delle stringhe ben formate (i *programmi*) del linguaggio. Poiché i programmi ammissibili sono tipicamente infiniti, non è possibile elencarli uno per uno: servono meccanismi finiti per descrivere insiemi infiniti.

Esistono due approcci fondamentali:
- *Metodo generativo*: si definisce una *grammatica* che genera tutte e sole le stringhe del linguaggio, partendo da un simbolo iniziale e applicando regole di riscrittura.
- *Metodo riconoscitivo*: si definisce un *automa* che, data una stringa, decide se essa appartiene o meno al linguaggio.

In questo capitolo ci concentriamo sul metodo generativo.

== Grammatiche formali

#definition(title: "Grammatica formale")[
  Una *grammatica formale* è una tripla $G = (T, N, P)$ dove:
  - $T$ è un insieme finito di simboli *terminali* (l'alfabeto del linguaggio).
  - $N$ è un insieme finito di simboli *non terminali* (anche detti *categorie sintattiche* o *variabili*), con $T inter N = emptyset$.
  - $P$ è un insieme finito di *produzioni* (o *regole di riscrittura*).

  Posto $S = T union N$ l'insieme di tutti i simboli, ogni produzione ha la forma:
  $ alpha ::= beta quad "con" alpha in S^* N S^* "e" beta in S^* $
  dove $alpha$ è detta *parte sinistra* e $beta$ è detta *parte destra*. La condizione $alpha in S^* N S^*$ impone che la parte sinistra contenga *almeno un non terminale*.
]

#note(title: "Simbolo iniziale")[
  In molte formulazioni la grammatica è definita come una quadrupla $G = (T, N, S_0, P)$, dove $S_0 in N$ è un *simbolo iniziale* (o *assioma*) distinto. Il linguaggio generato dalla grammatica è il linguaggio del simbolo $S_0$. Nella formulazione a tripla, il simbolo iniziale è indicato implicitamente come il primo non terminale delle produzioni.
]

#example(title: "Grammatica per stringhe di parentesi bilanciate")[
  $T = {(, )}$, $N = {"Par"}$, con produzioni: \
  Par $::= epsilon$ \
  Par $::=$ ( Par ) \
  Par $::=$ Par Par

  Questa grammatica genera tutte le stringhe di parentesi bilanciate: $epsilon$, $(space)$, $(()space)$, $(space)(space)$, $(()())$, ...
]

== Gerarchia di Chomsky

Le grammatiche formali si classificano in base alla forma delle loro produzioni. La *gerarchia di Chomsky* definisce quattro classi, ognuna contenuta nella precedente.

#align(center)[
  #block(
    width: 65%,
    inset: 15pt,
    stroke: 1pt + gray,
    radius: 5pt,
  )[
    #align(center)[
      #block(fill: rgb("#BBDEFB"), inset: 10pt, radius: 5pt, width: 100%)[
        *Tipo 0 -- Generali (ricorsivamente enumerabili)*
        #block(fill: rgb("#FFCDD2"), inset: 10pt, radius: 5pt, width: 85%)[
          *Tipo 1 -- Dipendenti dal contesto (monotone)*
          #block(fill: rgb("#C8E6C9"), inset: 10pt, radius: 5pt, width: 85%)[
            *Tipo 2 -- Libere dal contesto*
            #block(fill: rgb("#FFF9C4"), inset: 10pt, radius: 5pt, width: 85%)[
              *Tipo 3 -- Regolari*
            ]
          ]
        ]
      ]
    ]
  ]
]

#definition(title: "Tipo 0 -- Grammatiche generali")[
  Le produzioni hanno la forma $alpha ::= beta$ con $alpha in S^* N S^*$ e $beta in S^*$, senza alcuna restrizione ulteriore. I linguaggi generati sono detti *ricorsivamente enumerabili* e sono riconosciuti dalle macchine di Turing.
]

#definition(title: "Tipo 1 -- Grammatiche dipendenti dal contesto")[
  Le produzioni hanno la forma $alpha ::= beta$ con il vincolo $|alpha| <= |beta|$ (le produzioni non possono accorciare la stringa). Si ammette l'eccezione $S_0 ::= epsilon$ solo se $S_0$ non compare nella parte destra di alcuna produzione.

  I linguaggi generati sono detti *dipendenti dal contesto* e sono riconosciuti dagli automi lineari limitati.
]

#definition(title: "Tipo 2 -- Grammatiche libere dal contesto (context-free)")[
  Le produzioni hanno la forma $X ::= beta$ dove $X in N$ è un singolo non terminale e $beta in S^*$. La riscrittura di $X$ non dipende dal contesto in cui $X$ appare.

  I linguaggi generati sono detti *liberi dal contesto* (context-free) e sono riconosciuti dagli automi a pila.
]

#note(title: "Importanza delle grammatiche libere dal contesto")[
  La maggior parte dei linguaggi di programmazione ha una *sintassi* descrivibile con grammatiche libere dal contesto (tipo 2). Questo è il tipo di grammatica su cui ci concentreremo nel corso.
]

#definition(title: "Tipo 3 -- Grammatiche regolari")[
  Le produzioni hanno una delle seguenti forme:
  - $X ::= a Y$ oppure $X ::= a$ (*regolari a destra*), oppure
  - $X ::= Y a$ oppure $X ::= a$ (*regolari a sinistra*)

  dove $X, Y in N$ e $a in T$. I linguaggi generati sono detti *regolari* e sono riconosciuti dagli automi a stati finiti. Possono anche essere descritti da *espressioni regolari*.
]

== Backus-Naur Form (BNF)

La *Backus-Naur Form* (BNF) è una notazione compatta per scrivere grammatiche libere dal contesto. Le convenzioni sono:
- I non terminali sono racchiusi tra parentesi angolari $chevron.l dots.c chevron.r$ oppure scritti con iniziale maiuscola.
- Il simbolo $::=$ separa la parte sinistra dalla parte destra.
- Il simbolo $|$ separa le alternative: tutte le produzioni con lo stesso non terminale a sinistra vengono raggruppate in una sola riga.

#example(title: "Grammatica per indicazioni stradali in BNF")[
  $chevron.l "Direzione" chevron.r ::=$ sinistra $|$ destra \
  $chevron.l "Consiglio" chevron.r ::=$ svolta a $chevron.l "Direzione" chevron.r$ $|$ prosegui dritto \
  $chevron.l "Percorso" chevron.r ::=$ $chevron.l "Consiglio" chevron.r$ $|$ $chevron.l "Consiglio" chevron.r$, poi $chevron.l "Percorso" chevron.r$

  Questa grammatica genera frasi come: "svolta a sinistra, poi prosegui dritto".
]

=== Espressioni aritmetiche in BNF

#example(title: "Grammatica per le espressioni aritmetiche")[
  Dato l'alfabeto dei terminali $T = {0, 1, 2, ..., 9, +, times}$, definiamo la grammatica $G = (T, N, P)$ con $N = {"Cifra", "Num", "Op", "Esp"}$ e le produzioni:

  Cifra $::=$ 0 $|$ 1 $|$ 2 $|$ ... $|$ 9 \
  Num $::=$ Cifra $|$ Num Cifra \
  Op $::=$ $+$ $|$ $times$ \
  Esp $::=$ Num $|$ Esp Op Esp

  Ogni produzione definisce come costruire espressioni valide:
  - *Cifra* genera una singola cifra decimale.
  - *Num* genera un numero naturale come sequenza di cifre (definizione ricorsiva).
  - *Op* genera un operatore aritmetico.
  - *Esp* genera un'espressione: un numero oppure due espressioni collegate da un operatore.
]

#note[
  Il non terminale Esp è la categoria sintattica principale: il linguaggio delle espressioni aritmetiche è $L("Esp")$. Vedremo nel prossimo paragrafo come formalizzare il concetto di "linguaggio generato da un non terminale".
]
