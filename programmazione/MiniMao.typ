#import "../template.typ": *

== MiniMao

In questo capitolo introduciamo *MiniMao*, una versione ristretta del linguaggio MAO. L'obiettivo è definire formalmente la _sintassi_ (quali programmi sono corretti) e la _semantica operazionale_ (come i programmi vengono eseguiti) utilizzando i sistemi logici introdotti nella sezione precedente.

=== Variabili, ambiente e memoria

La programmazione consiste nell'ideare uno o più algoritmi che risolvano un problema, valutarne l'efficacia e codificarli in un linguaggio eseguibile da un calcolatore. Un programma è una sequenza di istruzioni che indicano al calcolatore le operazioni da eseguire. Come istruzione elementare consideriamo la possibilità di memorizzare il risultato di un calcolo. Per riferirsi a questi valori si utilizzano nomi simbolici detti #underline[nomi di variabile].

#note(title: "Equazioni vs assegnamenti")[
  Equazioni matematiche e assegnamenti sono due concetti profondamente diversi. Consideriamo $n = n^2 - 2$:
  - Se interpretato come *equazione matematica*, cerchiamo il valore di $n$ che verifica l'uguaglianza: le soluzioni sono $n in {2, -1}$.
  - Se interpretato come *assegnamento*, il significato è operazionale: se $n$ attualmente vale 5, dopo l'assegnamento $n$ assume il valore $5^2 - 2 = 23$.

  Per evitare ambiguità, MAO usa simboli diversi: `=` per la dichiarazione e `:=` per l'assegnamento.
]

==== Concetto di variabile

Una variabile in MAO è modellata come una "scatola" dotata di un *nome* (l'identificatore), un *tipo* (che determina quali valori può contenere) e un *valore corrente* (il contenuto della scatola). La dichiarazione crea la variabile e le assegna un valore iniziale:

```
int eta = 15;
```

Successivamente, il valore può cambiare tramite assegnamento (si noti l'uso di `:=`):

```
eta := 16;
```

==== Stato del programma

Durante l'esecuzione di un programma possono esistere molte variabili, ciascuna con il proprio valore. Lo #underline[stato] del programma è l'insieme di tutte le variabili e dei loro valori in un dato istante dell'esecuzione.

#example[
  Uno stato con tre variabili:
  ```
  {eta = 16, studente = true, nome = "Jacob"}
  ```
]

=== Sintassi di MiniMao

Introduciamo ora la sintassi di MiniMao, la versione ristretta del linguaggio MAO. Prima definiamo la sintassi usando grammatiche formali; in un secondo momento definiremo la semantica utilizzando sistemi logici.

Le *categorie sintattiche* di MiniMao sono:

#definition(title: "Categorie sintattiche")[
  - *Valori (V)*: dati elementari come numeri interi o booleani
  - *Identificatori (Id)*: simboli per riferirsi a variabili
  - *Espressioni (E)*: combinano valori, identificatori e operatori per produrre nuovi valori
  - *Tipi (T)*: indicano l'insieme dei valori ammissibili per una variabile
  - *Comandi (C)*: descrivono le azioni da eseguire (modificano lo stato)
]

#definition(title: "Valori V")[
  Inizialmente consideriamo solo programmi che manipolano valori interi ($bb(Z)$) e booleani ($bb(B)$):
  $ V ::= n | "true" | "false" $
  dove $n$ indica un qualsiasi numero intero.
]

#definition(title: "Identificatori Id")[
  Gli identificatori sono nomi simbolici che permettono al programmatore di riferirsi in modo chiaro e univoco a variabili. In MAO sono stringhe alfanumeriche che possono contenere il carattere underscore (\_).

  #example[
    `mio_id1`, `x`, `eta`, `contatore`
  ]
]

#note[
  Alcune parole chiave del linguaggio (come `if`, `while`, `int`, `bool`, `true`, `false`, `skip`) sono riservate e non possono essere usate come identificatori.
]

#definition(title: "Espressioni E")[
  Le espressioni combinano valori, identificatori e operatori per produrre un nuovo valore (intero o booleano): \
  $E ::= V | "Id" | E space "bop" space E | "uop" space E | (E)$

  dove `bop` indica un operatore binario e `uop` un operatore unario.
]

#definition(title: "Operatori binari")[
  Gli operatori binari prendono due operandi e producono un risultato:
]

#figure(
  table(
    columns: 4,
    [*Simbolo*], [*Nome*], [*Tipo operandi*], [*Tipo risultato*],
    [$+$], [addizione], [$bb(Z) times bb(Z)$], [$bb(Z)$],
    [$-$], [sottrazione], [$bb(Z) times bb(Z)$], [$bb(Z)$],
    [$times$], [moltiplicazione], [$bb(Z) times bb(Z)$], [$bb(Z)$],
    [$div$], [divisione intera], [$bb(Z) times bb(Z)_(eq.not 0)$], [$bb(Z)$],
    [$mod$], [resto (modulo)], [$bb(Z) times bb(Z)_(eq.not 0)$], [$bb(Z)$],
    [$<$], [minore], [$bb(Z) times bb(Z)$], [$bb(B)$],
    [$<=$], [minore o uguale], [$bb(Z) times bb(Z)$], [$bb(B)$],
    [$>$], [maggiore], [$bb(Z) times bb(Z)$], [$bb(B)$],
    [$>=$], [maggiore o uguale], [$bb(Z) times bb(Z)$], [$bb(B)$],
    [$==$], [uguaglianza], [$bb(Z) times bb(Z)$ o $bb(B) times bb(B)$], [$bb(B)$],
    [$!=$], [disuguaglianza], [$bb(Z) times bb(Z)$ o $bb(B) times bb(B)$], [$bb(B)$],
    [$and$], [and logico], [$bb(B) times bb(B)$], [$bb(B)$],
    [$or$], [or logico], [$bb(B) times bb(B)$], [$bb(B)$],
  ),
  caption: [Operatori binari in MiniMao]
)

#note[
  La divisione intera $div$ e il modulo $mod$ richiedono che il secondo operando sia diverso da zero; l'applicazione a zero produce un errore.
]

#definition(title: "Operatori unari")[
  Gli operatori unari prendono un solo operando:
]

#figure(
  table(
    columns: 4,
    [*Simbolo*], [*Nome*], [*Tipo operando*], [*Tipo risultato*],
    [$-$], [negazione aritmetica], [$bb(Z)$], [$bb(Z)$],
    [$not$], [negazione logica], [$bb(B)$], [$bb(B)$],
  ),
  caption: [Operatori unari in MiniMao]
)

#definition(title: "Tipi T")[
  Un tipo può essere un tipo base o un tipo composto. Per ogni tipo base assumiamo un valore di default (0 per interi e `false` per booleani): \
  $T ::= T_b | T_c$ \
  dove $T_b in {"int", "bool"}$ sono tipi base.

  _Nota_: i tipi composti $T_c$ (ad esempio i tipi array $T[]$) verranno introdotti nel capitolo su MAO. In MiniMao si utilizzano esclusivamente i tipi base $T_b$.
]

#definition(title: "Comandi C")[
  I comandi descrivono le azioni che il programma deve eseguire: \
  $C ::= "skip"; | T space "Id" = E; | "Id" := E; | C C | {C} | "if"(E){C} "else" {C} | "while"(E){C}$

  In dettaglio:
  - `skip;` -- comando vuoto (non fa nulla)
  - `T Id = E;` -- dichiarazione di variabile con inizializzazione
  - `Id := E;` -- assegnamento a variabile esistente
  - `C C` -- composizione sequenziale di due comandi
  - `{C}` -- blocco (introduce uno scope)
  - `if(E){C}else{C}` -- comando condizionale
  - `while(E){C}` -- ciclo iterativo
]

#example(title: "Programma in MiniMao")[
  ```
  int x = 1;
  int n = 0;
  while(x <= y) {
      x := x * 2;
      n := n + 1;
  }
  ```
  Si noti l'uso di `=` per dichiarare variabili e `:=` per gli assegnamenti.
]

== Semantica di MiniMao

La sintassi ci dice _quali_ programmi sono corretti; la *semantica* ci dice _cosa fanno_. La semantica è lo strumento che ci permette di ragionare formalmente sul comportamento di un programma e quindi di studiare proprietà come correttezza, equivalenza, terminazione e divergenza.

#definition(title: "Semantica operazionale")[
  La *semantica operazionale* descrive il comportamento di un programma in termini dei passi che un'opportuna #underline[macchina astratta] compie per eseguirlo.
]

#definition(title: "Macchina astratta")[
  Una *macchina astratta* è una macchina semplificata ideale il cui stato è dato da due componenti: l'*ambiente* $rho$ e la *memoria* $sigma$.
]

=== Ambiente e memoria

L'*ambiente* $rho: bb(I) arrow.r.hook bb(L)$ è una funzione parziale che associa identificatori a locazioni di memoria. Risponde alla domanda: "dove si trova la variabile $x$?"

La *memoria* $sigma: bb(L) arrow.r.hook bb(V)$ è una funzione parziale che associa locazioni a valori. Risponde alla domanda: "che valore contiene la locazione $l$?"

Per leggere il valore di una variabile $x$ servono due passi: prima si cerca la locazione $l = rho(x)$, poi si legge il valore $v = sigma(l)$.

#example(title: "Ambiente e memoria")[
  Con due variabili `eta` e `studente`:

  $rho("eta") = l_0, space rho("studente") = l_1$ #h(1cm) $sigma(l_0) = 15, space sigma(l_1) = "true"$

  La variabile `eta` si trova nella locazione $l_0$, che contiene il valore 15; la variabile `studente` si trova in $l_1$, che contiene `true`.
]

#note[
  Una funzione è _parziale_ quando potrebbe non essere definita per tutti gli argomenti del dominio. Ad esempio, $rho("z")$ non è definita se la variabile `z` non è stata dichiarata.
]

=== Stato del programma

Uno *stato* della macchina astratta è una coppia ambiente-memoria $s = (rho, sigma)$.

Quando le funzioni parziali sono definite su un numero finito di argomenti, le rappresentiamo elencando tutte le associazioni argomento-valore:
$ rho = [x |-> l_1, y |-> l_2], space sigma = [l_1 |-> 15, l_2 |-> "true"] $

La notazione $rho[x |-> l]$ indica l'ambiente ottenuto da $rho$ aggiungendo (o sovrascrivendo) l'associazione $x |-> l$. Analogamente $sigma[l |-> v]$ per la memoria.

=== Predicati semantici

Per definire la semantica dei programmi abbiamo bisogno di specificare formalmente come si valutano le espressioni e come si eseguono i comandi. Introduciamo due famiglie di _giudizi_ (predicati semantici):

#definition(title: "Giudizio di valutazione delle espressioni")[
  $chevron.l E, rho, sigma chevron.r arrow.b.double v$

  Si legge: "l'espressione $E$, nello stato $(rho, sigma)$, ha valore $v$". L'espressione viene valutata ma lo stato *non cambia* (espressioni pure).
]

#definition(title: "Giudizio di esecuzione dei comandi")[
  $chevron.l C, rho, sigma chevron.r arrow.r chevron.l rho', sigma' chevron.r$

  Si legge: "l'esecuzione del comando $C$ nello stato iniziale $(rho, sigma)$ termina producendo lo stato finale $(rho', sigma')$". Il comando può modificare sia l'ambiente (aggiungendo nuove variabili) che la memoria (cambiando valori).
]

=== Espressioni pure e con effetti collaterali

Le espressioni #underline[con effetti collaterali] sono espressioni la cui valutazione può comportare modifiche alla memoria (come allocazione o modifica di celle). In tal caso la valutazione si esprime come $chevron.l E, rho, sigma chevron.r arrow.b.double chevron.l v, sigma' chevron.r$.

Le espressioni *pure* non alterano lo stato: la valutazione produce un valore ma lascia ambiente e memoria invariati. MiniMao ammette solo espressioni pure, il che semplifica notevolmente le regole semantiche.

=== Regole semantiche per le espressioni

Le regole seguenti definiscono formalmente come valutare ciascun tipo di espressione. Per ogni regola, le premesse (sopra la linea) specificano le condizioni necessarie, e la conclusione (sotto la linea) specifica il risultato della valutazione.

==== Valori letterali

I valori letterali (numeri e booleani) si valutano a se stessi. Sono assiomi perché non richiedono premesse:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
  $chevron.l n, rho, sigma chevron.r arrow.b.double n$ #h(1cm) (Val-Int)
]

#align(center)[
  #grid(
    columns: (auto, auto),
    column-gutter: 2cm,
    align: center,
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
      $chevron.l "true", rho, sigma chevron.r arrow.b.double "true"$ #h(1cm) (Val-True)
    ],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
      $chevron.l "false", rho, sigma chevron.r arrow.b.double "false"$ #h(1cm) (Val-False)
    ],
  )
]

#note[
  Nelle regole (Val-Int), (Val-True), (Val-False), l'ambiente $rho$ e la memoria $sigma$ compaiono ma non vengono utilizzati. Il valore di un letterale non dipende dallo stato.
]

==== Variabili

Per valutare una variabile si effettua una doppia ricerca: prima nell'ambiente (per trovare la locazione), poi nella memoria (per trovare il valore):

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$rho("Id") = l$ #h(0.5cm) $sigma(l) = v$] \
  $chevron.l "Id", rho, sigma chevron.r arrow.b.double v$ #h(1cm) (Val-Var)
]

La regola (Val-Var) ha due premesse: $rho("Id") = l$ (l'identificatore è associato alla locazione $l$ nell'ambiente) e $sigma(l) = v$ (la locazione $l$ contiene il valore $v$ nella memoria).

==== Operatori binari e unari

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E_1, rho, sigma chevron.r arrow.b.double v_1$ #h(0.3cm) $chevron.l E_2, rho, sigma chevron.r arrow.b.double v_2$ #h(0.3cm) $v = v_1 "bop" v_2$] \
  $chevron.l E_1 "bop" E_2, rho, sigma chevron.r arrow.b.double v$ #h(1cm) (Val-Bop)
]

La regola (Val-Bop) si legge: "per valutare $E_1 "bop" E_2$, si valutano prima $E_1$ e $E_2$ separatamente (ottenendo $v_1$ e $v_2$), poi si applica l'operatore `bop` ai risultati".

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double v'$ #h(0.5cm) $v = "uop" v'$] \
  $chevron.l "uop" E, rho, sigma chevron.r arrow.b.double v$ #h(1cm) (Val-Uop)
]

La regola (Val-Uop) è analoga ma con un solo operando.

==== Espressioni parentesizzate

#note(title: "Parentesi nelle espressioni")[
  La grammatica delle espressioni include la produzione $(E)$, che permette di racchiudere un'espressione tra parentesi tonde. Tuttavia *non è necessaria una regola semantica separata* per le espressioni parentesizzate: le parentesi servono esclusivamente a disambiguare l'ordine di valutazione a livello sintattico (ad esempio, per forzare $(a + b) * c$ invece di $a + (b * c)$). Una volta costruito l'albero sintattico, la struttura delle sotto-espressioni è completamente determinata e le parentesi non influiscono sulla valutazione. In altre parole, valutare $(E)$ equivale esattamente a valutare $E$: le regole (Val-Bop) e (Val-Uop) si applicano direttamente alla struttura dell'espressione contenuta.
]

== Regole semantiche per i comandi

I comandi, a differenza delle espressioni, *modificano lo stato*. Le regole seguenti descrivono come ciascun tipo di comando trasforma la coppia $(rho, sigma)$.

=== Dichiarazione, assegnamento e sequenza

Per comprendere le regole formali, descriviamo prima informalmente ciascuna operazione.

*Dichiarazione* (`T Id = E;`): per eseguire una dichiarazione nello stato $(rho, sigma)$ si deve:
+ Valutare l'espressione $E$ nello stato corrente, ottenendo il valore $v$.
+ Trovare una locazione di memoria $l$ non ancora usata ($l in.not "dom"(sigma)$).
+ Estendere la memoria $sigma$ con l'associazione $l |-> v$.
+ Estendere l'ambiente $rho$ con l'associazione $"Id" |-> l$.

*Assegnamento* (`Id := E;`): per eseguire un assegnamento nello stato $(rho, sigma)$ si deve:
+ Valutare l'espressione $E$ nello stato corrente, ottenendo il valore $v$.
+ Individuare la locazione $l$ che l'ambiente $rho$ associa all'identificatore $"Id"$.
+ Aggiornare la memoria $sigma$ con l'associazione $l |-> v$ (il vecchio valore viene sovrascritto).
+ L'ambiente rimane invariato (non si creano nuove variabili).

*Composizione sequenziale* (`C1 C2`): per eseguire due comandi in sequenza:
+ Eseguire $C_1$ nello stato $(rho, sigma)$, ottenendo lo stato $(rho_1, sigma_1)$.
+ Eseguire $C_2$ nello stato $(rho_1, sigma_1)$, ottenendo lo stato finale $(rho_2, sigma_2)$.

=== Skip

Il comando `skip;` non modifica lo stato: è un assioma (nessuna premessa).

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
  $chevron.l "skip";, rho, sigma chevron.r arrow.r chevron.l rho, sigma chevron.r$ #h(1cm) (Cmd-Skip)
]

=== Dichiarazione

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double v$ #h(0.3cm) $l in.not "dom"(sigma)$] \
  $chevron.l T space "Id" = E;, rho, sigma chevron.r arrow.r chevron.l rho["Id" |-> l], sigma[l |-> v] chevron.r$ #h(0.5cm) (Cmd-Decl)
]

La regola (Cmd-Decl) modifica *sia* l'ambiente (aggiungendo $"Id" |-> l$) *sia* la memoria (aggiungendo $l |-> v$). La premessa $l in.not "dom"(sigma)$ garantisce che la locazione scelta sia fresca (non già in uso).

=== Assegnamento

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double v$ #h(0.3cm) $rho("Id") = l$] \
  $chevron.l "Id" := E;, rho, sigma chevron.r arrow.r chevron.l rho, sigma[l |-> v] chevron.r$ #h(0.5cm) (Cmd-Assign)
]

La regola (Cmd-Assign) modifica *solo* la memoria (aggiornando il valore nella locazione $l$). L'ambiente rimane invariato: $rho$ compare identico nello stato iniziale e finale.

=== Sequenza

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l C_1, rho, sigma chevron.r arrow.r chevron.l rho_1, sigma_1 chevron.r$ #h(0.3cm) $chevron.l C_2, rho_1, sigma_1 chevron.r arrow.r chevron.l rho_2, sigma_2 chevron.r$] \
  $chevron.l C_1 C_2, rho, sigma chevron.r arrow.r chevron.l rho_2, sigma_2 chevron.r$ #h(0.5cm) (Cmd-Seq)
]

La regola (Cmd-Seq) mostra chiaramente il "passaggio di stato": lo stato prodotto da $C_1$ diventa lo stato iniziale di $C_2$.

=== Sviluppo sequenziale

Le derivazioni ad albero possono diventare complesse e difficili da leggere per programmi con molti comandi. Lo *sviluppo sequenziale* è una notazione alternativa più compatta che descrive l'esecuzione come una sequenza di stati, uno per ogni comando eseguito.

#definition(title: "Sviluppo sequenziale")[
  Lo sviluppo sequenziale rappresenta l'esecuzione di un programma come una sequenza verticale che alterna stati e comandi:

  #align(center)[
    $chevron.l C, rho_0, sigma_0 chevron.r$ \
    $arrow.b$ \
    $chevron.l rho_1, sigma_1 chevron.r$ (dopo primo comando) \
    $arrow.b$ \
    $chevron.l rho_2, sigma_2 chevron.r$ (dopo secondo comando) \
    $...$ \
    $arrow.b$ \
    $chevron.l rho_n, sigma_n chevron.r$ (stato finale)
  ]
]

*Notazione semplificata*: invece di scrivere la configurazione completa con ambiente e memoria separati, spesso "fondiamo" le due componenti e scriviamo lo stato come un insieme di associazioni variabile $|->$ valore:
$ {x |-> v_1, y |-> v_2, ...} $
Questa notazione nasconde le locazioni di memoria e si legge: "la variabile $x$ ha valore $v_1$, la variabile $y$ ha valore $v_2$, ...".

#example(title: "Derivazione vs sviluppo sequenziale")[
  Consideriamo `C1 = y := x;` e `C2 = x := y;` con stato iniziale $rho = [x |-> l_1, y |-> l_2]$, $sigma = [l_1 |-> 5, l_2 |-> 3]$.

  *Come derivazione* (albero): l'albero di derivazione ha struttura annidata e richiede di leggere dal basso verso l'alto.

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[
      #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l x, rho, sigma chevron.r arrow.b.double 5$] \
      $chevron.l y := x;, rho, sigma chevron.r arrow.r chevron.l rho, sigma[l_2 |-> 5] chevron.r$
      #h(0.5cm)
      #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l y, rho, sigma' chevron.r arrow.b.double 5$] \
      $chevron.l x := y;, rho, sigma' chevron.r arrow.r chevron.l rho, sigma'[l_1 |-> 5] chevron.r$
    ] \
    $chevron.l "y:=x; x:=y;", rho, sigma chevron.r arrow.r chevron.l rho, sigma'' chevron.r$
  ]

  *Come sviluppo sequenziale* (lineare): molto più leggibile.
  #align(center)[
    ${x |-> 5, y |-> 3}$ \
    $arrow.b$ `y := x;` \
    ${x |-> 5, y |-> 5}$ \
    $arrow.b$ `x := y;` \
    ${x |-> 5, y |-> 5}$
  ]

  Si noti che il programma *non scambia* i valori di $x$ e $y$: dopo `y := x;`, entrambe le variabili valgono 5, quindi `x := y;` assegna 5 a $x$ (che già vale 5).
]

#example(title: "Sviluppo sequenziale completo")[
  Consideriamo il programma:
  ```
  int x = 3;
  int y = 0;
  y := x + 1;
  x := y * 2;
  ```

  Stato iniziale: $rho_0 = emptyset$, $sigma_0 = emptyset$

  *Passo 1*: `int x = 3;` (regola Cmd-Decl)
  - Valuto l'espressione: $chevron.l 3, rho_0, sigma_0 chevron.r arrow.b.double 3$
  - Alloco una nuova locazione: $l_1 in.not "dom"(sigma_0)$
  - Estendo ambiente: $rho_1 = rho_0[x |-> l_1] = [x |-> l_1]$
  - Estendo memoria: $sigma_1 = sigma_0[l_1 |-> 3] = [l_1 |-> 3]$

  *Passo 2*: `int y = 0;` (regola Cmd-Decl)
  - Valuto: $chevron.l 0, rho_1, sigma_1 chevron.r arrow.b.double 0$
  - Alloco: $l_2 in.not "dom"(sigma_1)$
  - $rho_2 = rho_1[y |-> l_2] = [x |-> l_1, y |-> l_2]$
  - $sigma_2 = sigma_1[l_2 |-> 0] = [l_1 |-> 3, l_2 |-> 0]$

  *Passo 3*: `y := x + 1;` (regola Cmd-Assign)
  - Valuto $x + 1$: $chevron.l x + 1, rho_2, sigma_2 chevron.r arrow.b.double 3 + 1 = 4$
  - Trovo la locazione di $y$: $rho_2(y) = l_2$
  - Aggiorno memoria: $sigma_3 = sigma_2[l_2 |-> 4] = [l_1 |-> 3, l_2 |-> 4]$
  - L'ambiente resta: $rho_3 = rho_2$

  *Passo 4*: `x := y * 2;` (regola Cmd-Assign)
  - Valuto $y * 2$: $chevron.l y * 2, rho_3, sigma_3 chevron.r arrow.b.double 4 * 2 = 8$
  - Trovo la locazione di $x$: $rho_3(x) = l_1$
  - Aggiorno memoria: $sigma_4 = sigma_3[l_1 |-> 8] = [l_1 |-> 8, l_2 |-> 4]$

  *Stato finale*: $rho_4 = [x |-> l_1, y |-> l_2]$, $sigma_4 = [l_1 |-> 8, l_2 |-> 4]$

  Quindi $x = 8$ e $y = 4$.
]

=== Blocchi e scoping

==== Il blocco {C}

Un *blocco* è un comando racchiuso tra parentesi graffe `{C}`. Tutte le variabili dichiarate all'interno del blocco sono visibili solo al suo interno. Lo #underline[scope] (ambito di visibilità) di una variabile definisce la porzione di codice nella quale la variabile può essere dichiarata, letta o modificata.

In MAO una variabile dichiarata all'interno di un blocco è visibile:
- In tutti i comandi successivi alla dichiarazione, nello stesso blocco.
- All'interno dei blocchi annidati.

All'uscita dal blocco, le variabili dichiarate al suo interno cessano di essere visibili.

==== Shadowing

È possibile dichiarare una variabile all'interno di un blocco con lo stesso nome di una variabile già dichiarata in un blocco esterno. In questo caso la variabile interna *nasconde* (shadow) quella esterna: all'interno del blocco, il nome si riferisce alla nuova variabile; all'uscita dal blocco, il nome torna a riferirsi alla variabile originale.

=== Blocco

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l C, rho, sigma chevron.r arrow.r chevron.l rho', sigma' chevron.r$] \
  $chevron.l {C}, rho, sigma chevron.r arrow.r chevron.l rho, sigma' chevron.r$ #h(0.5cm) (Cmd-Block)
]

#note(title: "Semantica del blocco")[
  La regola (Cmd-Block) è cruciale: lo stato finale del blocco ha l'*ambiente originale* $rho$ (non $rho'$), ma la *memoria modificata* $sigma'$. Questo significa che:
  - Le variabili dichiarate nel blocco vengono "dimenticate" (l'ambiente torna quello di prima).
  - Le modifiche alla memoria persistono (se il blocco ha modificato il valore di una variabile esterna, la modifica rimane).
  - Le locazioni allocate nel blocco restano in memoria ma diventano inaccessibili (nessun nome punta più ad esse).
]

=== Comando condizionale (if-then-else)

I comandi condizionali servono per prendere decisioni durante l'esecuzione. L'espressione $E$ (detta *guardia*) viene valutata: se produce `true`, si esegue il ramo "then" ($C_1$); se produce `false`, si esegue il ramo "else" ($C_2$).

```
if (E) {C1} else {C2}
```

#example(title: "Comando condizionale in MAO")[
  ```
  if (piove) {
      ombrello := true;
  } else {
      ombrello := false;
  }
  ```
]

Le regole semantiche distinguono i due casi:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double "true"$ #h(0.3cm) $chevron.l C_1, rho, sigma chevron.r arrow.r chevron.l rho', sigma' chevron.r$] \
  $chevron.l "if"(E){C_1}"else"{C_2}, rho, sigma chevron.r arrow.r chevron.l rho, sigma' chevron.r$ #h(0.3cm) (Cmd-IfTrue)
]

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double "false"$ #h(0.3cm) $chevron.l C_2, rho, sigma chevron.r arrow.r chevron.l rho', sigma' chevron.r$] \
  $chevron.l "if"(E){C_1}"else"{C_2}, rho, sigma chevron.r arrow.r chevron.l rho, sigma' chevron.r$ #h(0.3cm) (Cmd-IfFalse)
]

=== Comando if-then (senza else)

Il comando `if(E){C}` senza ramo `else` si esprime in MAO come un `if-else` con `skip;` nel ramo falso:

```
if (E) {C1} else {skip;}
```

#example(title: "Comando condizionale senza else")[
  ```
  if (piove) {
      ombrello := true;
  }
  ```
  Equivale a: `if (piove) { ombrello := true; } else { skip; }`
]

#note[
  Le parentesi tonde e graffe svolgono due compiti distinti: le parentesi tonde `()` delimitano la guardia e fissano l'ordine di valutazione nelle espressioni; le parentesi graffe `{}` delimitano un blocco di comandi e introducono uno scope.
]

#example(title: "Sviluppo sequenziale con condizionale")[
  Consideriamo:
  ```
  int a = 5;
  int b = 3;
  int max = 0;
  if(a > b){
      max := a;
  } else {
      max := b;
  }
  ```

  Dopo le dichiarazioni: $rho = [a |-> l_1, b |-> l_2, "max" |-> l_3]$, $sigma = [l_1 |-> 5, l_2 |-> 3, l_3 |-> 0]$

  *Valutazione della guardia*:
  $chevron.l a > b, rho, sigma chevron.r arrow.b.double chevron.l 5 > 3 chevron.r arrow.b.double "true"$

  Poiché la guardia è vera, si applica (Cmd-IfTrue) e si esegue il ramo `then`:

  *Esecuzione* `max := a;`:
  - Valuto $a$: $sigma(rho(a)) = sigma(l_1) = 5$
  - Aggiorno: $sigma' = sigma[l_3 |-> 5] = [l_1 |-> 5, l_2 |-> 3, l_3 |-> 5]$

  *Stato finale*: $"max" = 5$, che è corretto poiché $max(5, 3) = 5$.
]

=== Cicli

==== Comando iterativo (while)

Il ciclo `while` ripete l'esecuzione di un corpo di comandi finché la guardia è vera. È l'unico costrutto iterativo presente in MAO.

```
while (E) {C}
```

L'espressione $E$ è una guardia booleana: se vale `true`, viene eseguito il corpo $C$ e poi si ripete il controllo della guardia; se vale `false`, il ciclo termina e l'esecuzione prosegue con il comando successivo.

#example(title: "Comando iterativo in MAO")[
  ```
  while(cioccolatini > 0) {
      cioccolatini := cioccolatini - 1;
  }
  ```
]

==== Semantica del while

Il while richiede due regole: una per il caso in cui la guardia è falsa (il ciclo termina) e una per il caso in cui è vera (il ciclo prosegue).

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double "false"$] \
  $chevron.l "while"(E){C}, rho, sigma chevron.r arrow.r chevron.l rho, sigma chevron.r$ #h(0.5cm) (Cmd-WhileFalse)
]

Se la guardia è falsa, il ciclo termina immediatamente: lo stato non cambia.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double "true"$ #h(0.2cm) $chevron.l C, rho, sigma chevron.r arrow.r chevron.l rho', sigma' chevron.r$ #h(0.2cm) $chevron.l "while"(E){C}, rho, sigma' chevron.r arrow.r chevron.l rho, sigma'' chevron.r$] \
  $chevron.l "while"(E){C}, rho, sigma chevron.r arrow.r chevron.l rho, sigma'' chevron.r$ #h(0.3cm) (Cmd-WhileTrue)
]

#note(title: "Ricorsività della regola WhileTrue")[
  La regola (Cmd-WhileTrue) è *ricorsiva*: tra le premesse compare di nuovo il giudizio `while(E){C}`, ma con la memoria aggiornata $sigma'$ e l'ambiente originale $rho$ (le parentesi graffe ripristinano lo scope, come in Cmd-Block). Il ciclo viene quindi "srotolato" un passo alla volta: si esegue il corpo una volta, e poi si riesegue l'intero while sullo stato risultante.
]

== Riepilogo ed esempi

#figure(
  table(
    columns: 2,
    [*Comando*], [*Regole*],
    [`skip;`], [(Cmd-Skip)],
    [`T Id = E;`], [(Cmd-Decl)],
    [`Id := E;`], [(Cmd-Assign)],
    [`C1 C2`], [(Cmd-Seq)],
    [`{C}`], [(Cmd-Block)],
    [`if(E){C1}else{C2}`], [(Cmd-IfTrue), (Cmd-IfFalse)],
    [`while(E){C}`], [(Cmd-WhileFalse), (Cmd-WhileTrue)],
  ),
  caption: [Riepilogo delle regole semantiche di MiniMao]
)

=== Esempi di sviluppo sequenziale

==== Ciclo while: somma dei primi $n$

#example(title: "Sviluppo sequenziale con ciclo while")[
  Consideriamo:
  ```
  int n = 3;
  int s = 0;
  while(n > 0){
      s := s + n;
      n := n - 1;
  }
  ```

  Stato iniziale dopo le dichiarazioni: $rho = [n |-> l_1, s |-> l_2]$, $sigma_0 = [l_1 |-> 3, l_2 |-> 0]$

  *Iterazione 1* (regola Cmd-WhileTrue):
  - Guardia: $chevron.l n > 0, rho, sigma_0 chevron.r arrow.b.double 3 > 0 = "true"$
  - `s := s + n;`: $s = 0 + 3 = 3$ --- $sigma_1 = [l_1 |-> 3, l_2 |-> 3]$
  - `n := n - 1;`: $n = 3 - 1 = 2$ --- $sigma_1' = [l_1 |-> 2, l_2 |-> 3]$

  *Iterazione 2* (regola Cmd-WhileTrue):
  - Guardia: $2 > 0 = "true"$
  - `s := s + n;`: $s = 3 + 2 = 5$ --- $sigma_2 = [l_1 |-> 2, l_2 |-> 5]$
  - `n := n - 1;`: $n = 2 - 1 = 1$ --- $sigma_2' = [l_1 |-> 1, l_2 |-> 5]$

  *Iterazione 3* (regola Cmd-WhileTrue):
  - Guardia: $1 > 0 = "true"$
  - `s := s + n;`: $s = 5 + 1 = 6$ --- $sigma_3 = [l_1 |-> 1, l_2 |-> 6]$
  - `n := n - 1;`: $n = 1 - 1 = 0$ --- $sigma_3' = [l_1 |-> 0, l_2 |-> 6]$

  *Uscita dal ciclo* (regola Cmd-WhileFalse):
  - Guardia: $0 > 0 = "false"$ --- il ciclo termina

  *Stato finale*: $n = 0$, $s = 6$ (somma dei primi 3 naturali: $3 + 2 + 1 = 6$).
]

==== Ciclo while: calcolo del fattoriale

#example(title: "Sviluppo sequenziale: calcolo del fattoriale")[
  Consideriamo il programma che calcola il fattoriale di 4:
  ```
  int n = 4;
  int f = 1;
  while (n > 0) {
    f := f * n;
    n := n - 1;
  }
  ```

  *Stato iniziale* dopo le dichiarazioni:
  - $rho = [n |-> l_n, f |-> l_f]$
  - $sigma_0 = [l_n |-> 4, l_f |-> 1]$

  *Iterazione 1*:
  - Guardia: $chevron.l n > 0, rho, sigma_0 chevron.r arrow.b.double 4 > 0 = "true"$
  - `f := f * n;`: $chevron.l f * n, rho, sigma_0 chevron.r arrow.b.double 1 times 4 = 4$
    - $sigma_0' = sigma_0[l_f |-> 4] = [l_n |-> 4, l_f |-> 4]$
  - `n := n - 1;`: $chevron.l n - 1, rho, sigma_0' chevron.r arrow.b.double 4 - 1 = 3$
    - $sigma_1 = sigma_0'[l_n |-> 3] = [l_n |-> 3, l_f |-> 4]$

  *Iterazione 2*:
  - Guardia: $chevron.l n > 0, rho, sigma_1 chevron.r arrow.b.double 3 > 0 = "true"$
  - `f := f * n;`: $chevron.l f * n, rho, sigma_1 chevron.r arrow.b.double 4 times 3 = 12$
    - $sigma_1' = sigma_1[l_f |-> 12] = [l_n |-> 3, l_f |-> 12]$
  - `n := n - 1;`: $chevron.l n - 1, rho, sigma_1' chevron.r arrow.b.double 3 - 1 = 2$
    - $sigma_2 = sigma_1'[l_n |-> 2] = [l_n |-> 2, l_f |-> 12]$

  *Iterazione 3*:
  - Guardia: $chevron.l n > 0, rho, sigma_2 chevron.r arrow.b.double 2 > 0 = "true"$
  - `f := f * n;`: $chevron.l f * n, rho, sigma_2 chevron.r arrow.b.double 12 times 2 = 24$
    - $sigma_2' = sigma_2[l_f |-> 24] = [l_n |-> 2, l_f |-> 24]$
  - `n := n - 1;`: $chevron.l n - 1, rho, sigma_2' chevron.r arrow.b.double 2 - 1 = 1$
    - $sigma_3 = sigma_2'[l_n |-> 1] = [l_n |-> 1, l_f |-> 24]$

  *Iterazione 4*:
  - Guardia: $chevron.l n > 0, rho, sigma_3 chevron.r arrow.b.double 1 > 0 = "true"$
  - `f := f * n;`: $chevron.l f * n, rho, sigma_3 chevron.r arrow.b.double 24 times 1 = 24$
    - $sigma_3' = sigma_3[l_f |-> 24] = [l_n |-> 1, l_f |-> 24]$
  - `n := n - 1;`: $chevron.l n - 1, rho, sigma_3' chevron.r arrow.b.double 1 - 1 = 0$
    - $sigma_4 = sigma_3'[l_n |-> 0] = [l_n |-> 0, l_f |-> 24]$

  *Uscita dal ciclo*:
  - Guardia: $chevron.l n > 0, rho, sigma_4 chevron.r arrow.b.double 0 > 0 = "false"$ --- il ciclo termina

  *Riepilogo delle iterazioni*:
  #figure(
    table(
      columns: 4,
      [*Iterazione*], [*n*], [*f*], [*Guardia*],
      [Inizio], [4], [1], [-],
      [1], [3], [4], [true],
      [2], [2], [12], [true],
      [3], [1], [24], [true],
      [4], [0], [24], [true],
      [Fine], [0], [24], [false],
    ),
    caption: [Evoluzione dello stato nel calcolo di 4!]
  )

  *Stato finale*: $n = 0$, $f = 24$ (infatti $4! = 4 times 3 times 2 times 1 = 24$).
]

==== Blocchi e shadowing

#example(title: "Sviluppo sequenziale: blocchi e shadowing")[
  Consideriamo il programma che illustra lo shadowing delle variabili:
  ```
  int x = 10;
  {
    int x = 5;
    x := x + 1;
  }
  x := x * 2;
  ```

  *Stato iniziale*: $rho_0 = emptyset$, $sigma_0 = emptyset$

  *Passo 1*: `int x = 10;` (dichiarazione esterna)
  - Valuto: $chevron.l 10, rho_0, sigma_0 chevron.r arrow.b.double 10$
  - Alloco nuova locazione: $l_1 in.not "dom"(sigma_0)$
  - $rho_1 = [x |-> l_1]$
  - $sigma_1 = [l_1 |-> 10]$

  *Passo 2*: Ingresso nel blocco `{ ... }`
  - L'ambiente corrente è: $rho_1 = [x |-> l_1]$
  - La memoria corrente è: $sigma_1 = [l_1 |-> 10]$

  *Passo 2a*: `int x = 5;` (dichiarazione interna --- shadowing)
  - Valuto: $chevron.l 5, rho_1, sigma_1 chevron.r arrow.b.double 5$
  - Alloco *nuova* locazione: $l_2 in.not "dom"(sigma_1)$
  - $rho_2 = rho_1[x |-> l_2] = [x |-> l_2]$ (la nuova $x$ *nasconde* quella esterna)
  - $sigma_2 = sigma_1[l_2 |-> 5] = [l_1 |-> 10, l_2 |-> 5]$

  #note[
    Ora esistono *due* locazioni: $l_1$ (la $x$ esterna, valore 10) e $l_2$ (la $x$ interna, valore 5). L'ambiente $rho_2$ "vede" solo $l_2$ perché il binding $x |-> l_2$ ha sostituito $x |-> l_1$.
  ]

  *Passo 2b*: `x := x + 1;` (assegnamento alla $x$ interna)
  - Valuto $x + 1$: $chevron.l x + 1, rho_2, sigma_2 chevron.r$
    - $rho_2(x) = l_2$, $sigma_2(l_2) = 5$
    - $5 + 1 = 6$
  - Aggiorno: $sigma_3 = sigma_2[l_2 |-> 6] = [l_1 |-> 10, l_2 |-> 6]$

  *Passo 3*: Uscita dal blocco (regola Cmd-Block)
  - L'ambiente torna a $rho_1 = [x |-> l_1]$
  - La memoria *rimane* $sigma_3 = [l_1 |-> 10, l_2 |-> 6]$

  #note[
    Dopo l'uscita dal blocco, la variabile $x$ si riferisce di nuovo a $l_1$ (che contiene ancora 10). La locazione $l_2$ esiste ancora in memoria ma non è più accessibile tramite nessun nome.
  ]

  *Passo 4*: `x := x * 2;` (assegnamento alla $x$ esterna)
  - Valuto $x * 2$: $chevron.l x * 2, rho_1, sigma_3 chevron.r$
    - $rho_1(x) = l_1$, $sigma_3(l_1) = 10$
    - $10 times 2 = 20$
  - Aggiorno: $sigma_4 = sigma_3[l_1 |-> 20] = [l_1 |-> 20, l_2 |-> 6]$

  *Stato finale*:
  - $rho_"fin" = [x |-> l_1]$
  - $sigma_"fin" = [l_1 |-> 20, l_2 |-> 6]$
  - La variabile $x$ (esterna) vale 20

  *Riepilogo dell'evoluzione degli ambienti*:
  #figure(
    table(
      columns: 3,
      [*Punto*], [*Ambiente* $rho$], [*$x$ punta a*],
      [Dopo `int x = 10;`], [$[x |-> l_1]$], [$l_1$ (valore 10)],
      [Dentro blocco, dopo `int x = 5;`], [$[x |-> l_2]$], [$l_2$ (valore 5)],
      [Dentro blocco, dopo `x := x + 1;`], [$[x |-> l_2]$], [$l_2$ (valore 6)],
      [Dopo uscita dal blocco], [$[x |-> l_1]$], [$l_1$ (valore 10)],
      [Dopo `x := x * 2;`], [$[x |-> l_1]$], [$l_1$ (valore 20)],
    ),
    caption: [Evoluzione dell'ambiente con shadowing]
  )
]

==== Condizionali: calcolo del massimo

#example(title: "Sviluppo sequenziale: condizionali annidati (calcolo del massimo)")[
  Consideriamo il programma che trova il massimo tra tre numeri:
  ```
  int a = 7;
  int b = 3;
  int c = 5;
  int max = a;
  if (b > max) { max := b; }
  if (c > max) { max := c; }
  ```

  *Stato iniziale*: $rho_0 = emptyset$, $sigma_0 = emptyset$

  *Passo 1--4*: Dichiarazioni
  - `int a = 7;`: alloco $l_a$, $rho_1 = [a |-> l_a]$, $sigma_1 = [l_a |-> 7]$
  - `int b = 3;`: alloco $l_b$, $rho_2 = [a |-> l_a, b |-> l_b]$, $sigma_2 = [l_a |-> 7, l_b |-> 3]$
  - `int c = 5;`: alloco $l_c$, $rho_3 = [a |-> l_a, b |-> l_b, c |-> l_c]$, $sigma_3 = [l_a |-> 7, l_b |-> 3, l_c |-> 5]$
  - `int max = a;`: valuto $a$ (= 7), alloco $l_m$
    - $rho_4 = [a |-> l_a, b |-> l_b, c |-> l_c, "max" |-> l_m]$
    - $sigma_4 = [l_a |-> 7, l_b |-> 3, l_c |-> 5, l_m |-> 7]$

  *Stato dopo le dichiarazioni*:
  #align(center)[
    ${a |-> 7, b |-> 3, c |-> 5, "max" |-> 7}$
  ]

  *Passo 5*: Primo condizionale `if (b > max) { max := b; }`
  - Valuto la guardia: $chevron.l b > "max", rho_4, sigma_4 chevron.r$
    - $sigma_4(rho_4(b)) = sigma_4(l_b) = 3$
    - $sigma_4(rho_4("max")) = sigma_4(l_m) = 7$
    - $3 > 7 = "false"$
  - Poiché la guardia è falsa, applichiamo (Cmd-IfFalse) con il ramo else implicito `skip;`
  - Lo stato *non cambia*: $sigma_5 = sigma_4$

  #align(center)[
    ${a |-> 7, b |-> 3, c |-> 5, "max" |-> 7}$ (invariato)
  ]

  *Passo 6*: Secondo condizionale `if (c > max) { max := c; }`
  - Valuto la guardia: $chevron.l c > "max", rho_4, sigma_5 chevron.r$
    - $sigma_5(rho_4(c)) = sigma_5(l_c) = 5$
    - $sigma_5(rho_4("max")) = sigma_5(l_m) = 7$
    - $5 > 7 = "false"$
  - Poiché la guardia è falsa, applichiamo (Cmd-IfFalse)
  - Lo stato *non cambia*: $sigma_6 = sigma_5$

  *Stato finale*:
  #align(center)[
    ${a |-> 7, b |-> 3, c |-> 5, "max" |-> 7}$
  ]

  Il risultato è corretto: $"max" = 7 = max(7, 3, 5)$.

  ---

  *Variante*: Consideriamo lo stesso programma con valori diversi: $a = 2$, $b = 8$, $c = 5$

  Dopo le dichiarazioni: ${a |-> 2, b |-> 8, c |-> 5, "max" |-> 2}$

  *Primo condizionale* `if (b > max) { max := b; }`:
  - Guardia: $8 > 2 = "true"$
  - Eseguo `max := b;`: $"max" = 8$
  - Stato: ${a |-> 2, b |-> 8, c |-> 5, "max" |-> 8}$

  *Secondo condizionale* `if (c > max) { max := c; }`:
  - Guardia: $5 > 8 = "false"$
  - Stato invariato: ${a |-> 2, b |-> 8, c |-> 5, "max" |-> 8}$

  Risultato: $"max" = 8 = max(2, 8, 5)$.

  ---

  *Altra variante*: $a = 2$, $b = 3$, $c = 9$

  Dopo le dichiarazioni: ${a |-> 2, b |-> 3, c |-> 9, "max" |-> 2}$

  *Primo condizionale*:
  - Guardia: $3 > 2 = "true"$
  - Eseguo `max := b;`: $"max" = 3$
  - Stato: ${a |-> 2, b |-> 3, c |-> 9, "max" |-> 3}$

  *Secondo condizionale*:
  - Guardia: $9 > 3 = "true"$
  - Eseguo `max := c;`: $"max" = 9$
  - Stato: ${a |-> 2, b |-> 3, c |-> 9, "max" |-> 9}$

  Risultato: $"max" = 9 = max(2, 3, 9)$.
]

== Terminazione e divergenza

Con l'introduzione dei cicli, i programmi possono non terminare mai. Questa distinzione tra terminazione e divergenza è fondamentale nello studio dei linguaggi di programmazione.

#definition(title: "Terminazione")[
  La *terminazione* è la proprietà di un programma che garantisce il completamento della sua esecuzione in tempo finito, producendo uno stato finale.

  Condizioni *sufficienti* (ma non necessarie) per la terminazione di un ciclo `while(E){C}` sono:
  - La guardia $E$ contiene almeno una variabile.
  - Il corpo $C$ contiene almeno un assegnamento che modifica quella variabile.
  - Le modifiche successive portano la guardia a diventare falsa in un numero finito di passi.

  Queste condizioni sono euristiche utili per verificare la terminazione, ma non sono necessarie: ad esempio, `while(false){C}` termina immediatamente indipendentemente dal corpo, anche se la guardia non contiene variabili.
]

#definition(title: "Divergenza")[
  La *divergenza* si verifica quando un programma (o un ciclo) non termina mai, continuando a eseguire istruzioni indefinitamente. In questo caso non si produce nessuno stato finale.
]

#example(title: "Programma divergente")[
  ```
  int x = 1;
  while(x > 0){
      x := x + 1;
  }
  ```
  La guardia $x > 0$ è sempre vera (poiché $x$ cresce ad ogni iterazione), quindi il ciclo non termina mai.
]

#note[
  Non esiste un algoritmo che, dato un programma arbitrario, sia in grado di decidere se esso termina o meno. Questo risultato fondamentale è noto come *indecidibilità del problema della terminazione* (Halting Problem, Turing 1936).
]

=== Costrutti iterativi alternativi

In MAO è presente solamente il costrutto iterativo `while`, ma i linguaggi di programmazione comuni offrono diversi costrutti iterativi. Tutti questi costrutti possono essere espressi usando un ciclo `while`.

==== Ciclo for

Il ciclo `for` è un costrutto particolarmente compatto: in una sola riga è possibile leggere l'inizializzazione, la condizione di terminazione e l'aggiornamento.

#example(title: "for in JavaScript")[
  ```javascript
  let somma = 0;
  for (let i = 1; i < n; i = i + 1) {
      somma = somma + i;
  }
  ```

  Questo ciclo è equivalente al seguente codice MAO:
  ```
  int somma = 0;
  int i = 1;
  while(i < n) {
      somma := somma + i;
      i := i + 1;
  }
  ```
]

==== Ciclo do-while

Il ciclo `do-while` si utilizza quando il corpo deve essere eseguito almeno una volta, senza controllare preventivamente la condizione.

#example(title: "do-while in JavaScript")[
  ```javascript
  let eta;
  do {
      eta = parseInt(prompt("Anni?"));
  } while(eta < 0);
  ```

  In MAO, il `do-while` può essere simulato eseguendo il corpo una volta prima del `while`:
  ```
  int eta = -1;
  eta := /* leggi input */;
  while(eta < 0) {
      eta := /* leggi input */;
  }
  ```
]
