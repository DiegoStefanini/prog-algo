#import "../template.typ": *

== Il linguaggio MAO e gli array

Il linguaggio MAO estende MiniMao con costrutti fondamentali per la programmazione reale: gli *array*, le *funzioni*, la *ricorsione* e un *sistema di tipi* formale. In questo capitolo si presenta ciascuno di questi aspetti, a partire dalla loro sintassi formale fino alla semantica operazionale e al type checking.

=== Array

#definition(title: "Array -- definizione informale")[
  Un *array* è una struttura dati che permette di trattare in modo efficiente un insieme finito di dati omogenei, cioè tutti dello stesso tipo. Gli elementi sono memorizzati in celle contigue di memoria e sono accessibili tramite un indice posizionale intero.
]

In MAO, gli array si dichiarano specificando il tipo degli elementi seguito da `[]`. Ad esempio, la dichiarazione

#align(center)[
  `int[] voti = [18, 30, 23];`
]

alloca in memoria un blocco contiguo di celle. La prima cella, situata all'_indirizzo base_ $l_b$, contiene la lunghezza dell'array. Le celle successive $l_b + 1, l_b + 2, ...$ contengono i singoli elementi. Per accedere all'elemento in posizione $i$ si usa la notazione $l_b [i]$, che corrisponde all'indirizzo $l_b + 1 + i$.

==== Rappresentazione in memoria

Nella struttura memoria-ambiente di MAO, un array viene rappresentato tramite una catena di indirezione. L'ambiente $rho$ associa il nome della variabile a una locazione $l_x$, e la memoria $sigma$ associa $l_x$ all'indirizzo base $l_b$ dell'array:

#align(center)[
  $rho("voti") = l_x$, $quad sigma(l_x) = l_b$ \
  $sigma(l_b) = 3$ #h(1cm) _(lunghezza)_ \
  $sigma(l_b + 1) = 18$, $quad sigma(l_b + 2) = 30$, $quad sigma(l_b + 3) = 23$
]

Si osservi che la variabile `voti` non contiene direttamente i dati dell'array, ma un _riferimento_ (locazione) all'indirizzo base. Questa scelta progettuale ha conseguenze importanti, come vedremo nella sezione sull'aliasing.

#definition(title: "Array -- definizione formale")[
  Un array è una collezione finita di elementi dello stesso tipo, memorizzati in celle contigue di memoria. Il numero degli elementi è detto #underline[lunghezza dell'array]. Tipo e lunghezza sono fissati al momento della dichiarazione e sono *statici*: non possono essere modificati durante l'esecuzione del programma.
]

Un array permette di trattare come entità atomiche intere collezioni di dati e, al contempo, consente l'accesso ai singoli elementi tramite indici posizionali. Gli indici ammissibili appartengono all'intervallo

#align(center)[
  $[0, "lunghezza")$
]

cioè da $0$ (incluso) a "lunghezza" $- 1$ (incluso). Un accesso con indice fuori da questo intervallo costituisce un errore a tempo di esecuzione.

=== Sintassi degli array

Per ottenere la lunghezza di un array si utilizza il costrutto `.length`, che restituisce un valore intero.

#example(title: "Lunghezza di un array")[
  ```
  int[] voti = [18, 30, 23];

  voti.length = 3
  ```
]

La grammatica di MAO viene estesa con le seguenti produzioni per supportare gli array:

#align(center)[
  $T &::= ... | T[]$ \
  $E &::= ... | "[" S "]" | "new" space T "[" E "]" | E "." "length" | E "[" E "]"$ \
  $S &::= E | E "," S$ \
  $C &::= ... | E "[" E "]" := E$
]

Dove ciascuna produzione ha il seguente significato:
- $T[]$: tipo array di elementi di tipo $T$ (ad esempio `int[]`, `bool[]`)
- $"[" S "]"$: *letterale array*, cioè una lista esplicita di espressioni che definisce i valori iniziali
- $"new" space T "[" E "]"$: *allocazione* di un nuovo array di tipo $T$ con dimensione data dalla valutazione di $E$, con elementi inizializzati ai valori di default
- $E "." "length"$: espressione che restituisce la *lunghezza* dell'array
- $E "[" E "]"$: *accesso* a un singolo elemento dell'array, dove la prima espressione denota l'array e la seconda l'indice
- $E "[" E "]" := E$: *assegnamento* a un elemento dell'array

=== Valori e riferimenti

In MiniMao le celle di memoria contenevano solamente valori interi e booleani. L'ambiente e la memoria erano definiti come:

#align(center)[
  $rho: bb(I) arrow.r.hook bb(L)$ #h(1cm) $sigma: bb(L) arrow.r.hook bb(V)$ dove $bb(V) = bb(Z) union bb(B)$
]

Con l'introduzione degli array in MAO, il dominio dei valori viene esteso per includere anche le _locazioni_ (indirizzi di memoria), poiché una variabile di tipo array contiene un riferimento all'indirizzo base dell'array:

#align(center)[
  $rho: bb(I) arrow.r.hook bb(L)$ #h(1cm) $sigma: bb(L) arrow.r.hook bb(V)$ dove $bb(V) = bb(Z) union bb(B) union bb(L)$
]

Le locazioni che compaiono come valori prendono il nome di *riferimenti*. Un riferimento non è un dato del programma, ma un indirizzo di memoria che permette di accedere indirettamente a una struttura dati.

=== Espressioni pure e con effetti collaterali

#definition(title: "Espressione pura")[
  Un'espressione si dice *pura* se la sua valutazione non modifica lo stato della memoria. Il risultato dipende solo dai valori correnti delle variabili, senza effetti collaterali.
]

In *MiniMao* tutte le espressioni erano pure: la valutazione di un'espressione $E$ produceva un valore $v$ lasciando la memoria $sigma$ invariata. Ciò permetteva di usare la notazione semplificata:

#align(center)[
  $chevron.l E, rho, sigma chevron.r arrow.b.double v$
]

#example(title: "Espressioni pure in MiniMao")[
  Le seguenti espressioni non modificano la memoria:
  - `x + 3` $arrow.r$ legge il valore di $x$, calcola la somma, restituisce un intero
  - `a > b and c` $arrow.r$ legge $a$, $b$, $c$, restituisce un booleano
  - `(x + 1) * (y - 2)` $arrow.r$ solo letture e calcoli aritmetici
]

In *MAO*, con l'introduzione degli array, alcune espressioni possono *allocare nuova memoria*. Queste espressioni producono *effetti collaterali* e restituiscono, oltre al valore, una memoria modificata $sigma'$:

#align(center)[
  $chevron.l E, rho, sigma chevron.r arrow.b.double (v, sigma')$
]

#example(title: "Espressioni con effetti collaterali")[
  Le seguenti espressioni modificano la memoria allocando nuove celle:
  - `new int[5]` $arrow.r$ alloca 6 celle consecutive (1 per la lunghezza + 5 per gli elementi)
  - `[1, 2, 3]` $arrow.r$ alloca 4 celle consecutive (1 per la lunghezza + 3 per i valori)
  - `new bool[n+1]` $arrow.r$ prima valuta l'espressione `n+1`, poi alloca il numero risultante di celle
]

#note(title: "Conseguenza sulla semantica")[
  In MAO la valutazione di _qualsiasi_ espressione restituisce sempre una coppia $(v, sigma')$, anche quando $sigma' = sigma$ (cioè quando l'espressione è pura). Questo garantisce uniformità nella semantica: ogni regola di valutazione segue lo stesso schema, indipendentemente dalla presenza o meno di effetti collaterali.
]

La distinzione tra espressioni pure e non pure ha importanti implicazioni pratiche:
- *Ordine di valutazione*: se due sottoespressioni hanno effetti collaterali, l'ordine in cui vengono valutate può influenzare il risultato finale
- *Ottimizzazioni del compilatore*: il compilatore può riordinare o eliminare espressioni pure senza alterare la semantica del programma, ma non può fare altrettanto con espressioni che hanno effetti collaterali
- *Ragionamento formale*: le espressioni pure sono più semplici da analizzare perché il loro comportamento è completamente determinato dai valori correnti delle variabili

=== Semantica operazionale degli array

Le regole seguenti definiscono la semantica operazionale degli array in stile _big-step_. In ciascuna regola, le premesse (sopra la linea) stabiliscono le condizioni necessarie, e la conclusione (sotto la linea) descrive il risultato della valutazione.

==== Allocazione di un array letterale

Quando si valuta un letterale array $[E_1, ..., E_n]$, si valutano in ordine le $n$ espressioni, ottenendo i valori $v_1, ..., v_n$. Si allocano poi $n+1$ celle consecutive a partire dall'indirizzo base $l_b$: la prima cella memorizza la lunghezza $n$, le successive i valori degli elementi.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E_1, rho, sigma chevron.r arrow.b.double (v_1, sigma_1)$ #h(0.2cm) $...$ #h(0.2cm) $chevron.l E_n, rho, sigma_(n-1) chevron.r arrow.b.double (v_n, sigma_n)$ #h(0.2cm) $l_b, l_b+1, ..., l_b+n in.not "dom"(sigma_n)$] \
  $chevron.l [E_1, ..., E_n], rho, sigma chevron.r arrow.b.double (l_b, sigma_n[l_b |-> n][l_b+1 |-> v_1]...[l_b+n |-> v_n])$ #h(0.2cm) (Array-Lit)
]

#note[
  Si osservi che il valore restituito è l'indirizzo base $l_b$, non l'array stesso. Ciò riflette il fatto che in MAO gli array sono gestiti per riferimento. Inoltre, ogni espressione $E_i$ viene valutata nella memoria $sigma_(i-1)$ risultante dalla valutazione precedente, garantendo la corretta propagazione degli effetti collaterali.
]

==== Allocazione con new

L'espressione `new T[E]` valuta prima $E$ per ottenere la dimensione $n$, poi alloca $n+1$ celle consecutive: la prima per la lunghezza, le restanti inizializzate al valore di default del tipo $T$ (tipicamente $0$ per `int`, `false` per `bool`).

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double (n, sigma')$ #h(0.3cm) $l_b, ..., l_b+n in.not "dom"(sigma')$] \
  $chevron.l "new" T[E], rho, sigma chevron.r arrow.b.double (l_b, sigma'[l_b |-> n][l_b+1 |-> "default"]...[l_b+n |-> "default"])$ #h(0.2cm) (Array-New)
]

==== Lunghezza

L'espressione `E.length` valuta $E$ ottenendo l'indirizzo base $l_b$, quindi legge il valore memorizzato in $l_b$, che per costruzione è la lunghezza dell'array.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double (l_b, sigma')$ #h(0.3cm) $sigma'(l_b) = n$] \
  $chevron.l E."length", rho, sigma chevron.r arrow.b.double (n, sigma')$ #h(0.5cm) (Array-Length)
]

==== Accesso a un elemento

L'espressione $E_1[E_2]$ valuta prima $E_1$ per ottenere l'indirizzo base $l_b$, poi $E_2$ per ottenere l'indice $i$. La premessa $0 <= i < sigma_2(l_b)$ garantisce che l'indice sia nell'intervallo valido. L'elemento cercato si trova all'indirizzo $l_b + 1 + i$ (si aggiunge 1 perché la prima cella contiene la lunghezza).

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E_1, rho, sigma chevron.r arrow.b.double (l_b, sigma_1)$ #h(0.2cm) $chevron.l E_2, rho, sigma_1 chevron.r arrow.b.double (i, sigma_2)$ #h(0.2cm) $0 <= i < sigma_2(l_b)$] \
  $chevron.l E_1[E_2], rho, sigma chevron.r arrow.b.double (sigma_2(l_b + 1 + i), sigma_2)$ #h(0.3cm) (Array-Access)
]

==== Assegnamento in array

Il comando $E_1[E_2] := E_3$ valuta le tre espressioni in ordine: $E_1$ per l'indirizzo base, $E_2$ per l'indice, $E_3$ per il nuovo valore. La premessa $0 <= i < sigma_2(l_b)$ garantisce che l'indice sia nell'intervallo valido, analogamente alla regola (Array-Access). La cella all'indirizzo $l_b + 1 + i$ viene aggiornata con il valore $v$.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E_1, rho, sigma chevron.r arrow.b.double (l_b, sigma_1)$ #h(0.15cm) $chevron.l E_2, rho, sigma_1 chevron.r arrow.b.double (i, sigma_2)$ #h(0.15cm) $chevron.l E_3, rho, sigma_2 chevron.r arrow.b.double (v, sigma_3)$ #h(0.15cm) $0 <= i < sigma_2(l_b)$] \
  $chevron.l E_1[E_2] := E_3;, rho, sigma chevron.r arrow.r chevron.l rho, sigma_3[l_b + 1 + i |-> v] chevron.r$ #h(0.2cm) (Array-Assign)
]

=== Aliasing

#definition(title: "Aliasing")[
  Si ha *aliasing* quando due o più variabili distinte fanno riferimento alla stessa zona di memoria. Poiché in MAO gli array sono gestiti tramite riferimenti (indirizzi base), l'assegnamento di un array a un'altra variabile copia il _riferimento_, non i dati. Di conseguenza, entrambe le variabili puntano allo stesso blocco di memoria.
]

#example(title: "Problema dell'aliasing")[
  Consideriamo il seguente frammento di codice:
  ```
  int[] a = [1, 2, 3];
  int[] b = a;        // b punta allo stesso array di a!
  b[0] := 99;         // modifica anche a[0]!
  ```

  Dopo l'esecuzione, lo stato è il seguente:
  - $rho = [a |-> l_a, b |-> l_b]$
  - $sigma(l_a) = sigma(l_b) = l_("base")$ (stesso indirizzo base!)

  Quindi `a[0]` e `b[0]` accedono alla stessa cella di memoria $l_("base") + 1$. La modifica effettuata tramite `b` è visibile anche tramite `a`, perché non è stata creata una copia indipendente dell'array.
]

#note(title: "Conseguenza sul passaggio di parametri")[
  L'aliasing ha implicazioni dirette sul passaggio di parametri alle funzioni. Quando si passa un array come argomento a una funzione, si passa il suo *riferimento* (indirizzo base). Di conseguenza, eventuali modifiche agli elementi dell'array effettuate nel corpo della funzione si riflettono sull'array originale del chiamante. Questo comportamento è equivalente a un passaggio per _riferimento implicito_.
]

== Analisi statica e sistema di tipi

In un linguaggio di programmazione, le grammatiche definiscono in modo rigoroso le categorie sintattiche delle espressioni e dei comandi. Tuttavia, molti programmi sintatticamente validi possono contenere errori che si manifestano solo a tempo di esecuzione: ad esempio, sommare un intero con un booleano, oppure accedere a un array con un indice di tipo booleano. Per prevenire questa classe di errori si ricorre all'*analisi statica*.

#definition(title: "Analisi statica")[
  L'*analisi statica* consiste nei controlli effettuati sul codice sorgente _senza eseguire il programma_. Il suo scopo è individuare errori e anomalie prima dell'esecuzione, basandosi esclusivamente sulla struttura sintattica e sulle informazioni di tipo.
]

La maggior parte dei linguaggi di programmazione moderni prevede diversi controlli di analisi statica (ad esempio, il controllo di raggiungibilità del codice, l'analisi di variabili non inizializzate, e altri). In MAO ci si limita al #underline[controllo dei tipi (type checking)], che verifica la coerenza tra i tipi dichiarati per le variabili e l'uso che ne viene fatto nelle espressioni e nei comandi.

=== Sistemi di tipi

In MAO il controllo dei tipi avviene in modo formale attraverso #underline[regole di tipo] che stabiliscono le condizioni necessarie affinché un'espressione o un comando vengano considerati #underline[ben tipati]. Il controllo è *composizionale*: le regole di tipo per un costrutto composito sono definite in funzione dei giudizi di tipo sulle sue sottocomponenti. Per poter effettuare questo controllo è necessario conoscere i tipi associati alle variabili che occorrono nelle espressioni e nei comandi; a tal fine si introduce l'_ambiente di tipo_.

=== Ambiente di tipo

#definition(title: "Ambiente di tipo")[
  L'*ambiente di tipo* $Gamma: bb(I) arrow.r.hook bb(T)$ è una funzione parziale che associa a ciascun identificatore nel suo dominio un tipo. La scrittura $Gamma(x) = "int"$ si legge: "nell'ambiente $Gamma$ si assume che la variabile $x$ abbia tipo `int`".
]

Per comodità si scrive $"Id" : T$ in luogo di $Gamma("Id") = T$. Un ambiente di tipo si rappresenta come un insieme di associazioni:
$ Gamma = {"Id"_1 : T_1, "Id"_2 : T_2, ..., "Id"_n : T_n} $

L'ambiente di tipo è un concetto esclusivamente statico: esiste solo a tempo di compilazione e serve al type checker per verificare la correttezza del programma. Non va confuso con l'ambiente $rho$ (che mappa identificatori a locazioni a tempo di esecuzione).

#example(title: "Costruzione di un ambiente di tipo")[
  Dopo le seguenti dichiarazioni:
  ```
  int temp = 2;
  bool y = true;
  ```
  L'ambiente di tipo risultante è $Gamma = {"temp" : "int", y : "bool"}$.
]

=== Variabili libere

Le variabili libere di un'espressione o di un comando sono quelle variabili che vi occorrono senza essere state dichiarate localmente. La loro definizione formale è necessaria per garantire che il type checking possa procedere: ogni variabile libera deve essere presente nell'ambiente di tipo $Gamma$.

==== Variabili libere in un'espressione

Data un'espressione $E in bb(E)$, la funzione $"fv"(.): bb(E) arrow.r cal(P)_("fin")(bb(I))$ restituisce l'insieme finito di tutte le variabili che occorrono in $E$, dette #underline[variabili libere]. La funzione è definita per induzione sulla struttura dell'espressione:

#align(center)[
  $"fv"(n) &= emptyset$ \
  $"fv"("true") &= emptyset$ \
  $"fv"("false") &= emptyset$ \
  $"fv"("Id") &= {"Id"}$ \
  $"fv"(E_1 "bop" E_2) &= "fv"(E_1) union "fv"(E_2)$ \
  $"fv"("uop" E) &= "fv"(E)$ \
  $"fv"((E)) &= "fv"(E)$ \
  $"fv"(E_1[E_2]) &= "fv"(E_1) union "fv"(E_2)$ \
  $"fv"(E."length") &= "fv"(E)$ \
  $"fv"("new" T[E]) &= "fv"(E)$
]

Le costanti (numeriche e booleane) non contengono variabili libere. Un identificatore ha se stesso come unica variabile libera. Per le espressioni composte, le variabili libere sono l'unione delle variabili libere delle sottoespressioni.

#example[
  $"fv"($`x+3`$) = "fv"($`x`$) union "fv"($`3`$) = {$`x`$} union emptyset = {$`x`$}$
]

#example[
  $"fv"($`new int[a.length]`$) = "fv"($`a.length`$) = "fv"($`a`$) = {$`a`$}$
]

#example[
  $"fv"($`x%7 == z*x`$) = "fv"($`x%7`$) union "fv"($`z*x`$) = {$`x`$} union {$`z, x`$} = {$`x, z`$}$
]

==== Variabili libere in un comando

Dato un comando $C in bb(C)$, la funzione $"fv"(.): bb(C) arrow.r cal(P)_("fin")(bb(I))$ restituisce l'insieme di tutte le variabili che occorrono in $C$ senza essere state dichiarate all'interno di $C$ stesso. La definizione per induzione richiede una funzione ausiliaria $"dv"(.): bb(C) arrow.r cal(P)_("fin")(bb(I))$, che restituisce l'insieme delle variabili _introdotte_ da dichiarazioni.

#align(center)[
  $"fv"("skip";) &= emptyset$ \
  $"fv"(T space "Id" = E;) &= "fv"(E)$ \
  $"fv"("Id" := E;) &= {"Id"} union "fv"(E)$ \
  $"fv"(E_1[E_2] := E_3;) &= "fv"(E_1) union "fv"(E_2) union "fv"(E_3)$ \
  $"fv"(C_1 C_2) &= "fv"(C_1) union ("fv"(C_2) backslash "dv"(C_1))$ \
  $"fv"({C}) &= "fv"(C)$ \
  $"fv"("if"(E){C_1}"else"{C_2}) &= "fv"(E) union "fv"(C_1) union "fv"(C_2)$ \
  $"fv"("while"(E){C}) &= "fv"(E) union "fv"(C)$
]

#note[
  Nella regola per la sequenza $C_1 C_2$, le variabili dichiarate in $C_1$ (cioè $"dv"(C_1)$) vengono sottratte dalle variabili libere di $C_2$, perché le dichiarazioni di $C_1$ rendono disponibili quei nomi nel contesto di $C_2$.
]

La funzione $"dv"(C)$ è definita come segue:
#align(center)[
  $"dv"(T space "Id" = E;) &= {"Id"}$ \
  $"dv"(C_1 C_2) &= "dv"(C_1) union "dv"(C_2)$ \
  $"dv"("altri comandi") &= emptyset$
]

=== Giudizi di tipo

I giudizi di tipo sono le asserzioni fondamentali del sistema di tipi. Ve ne sono di due forme, una per le espressioni e una per i comandi.

==== Giudizi di tipo per le espressioni

Dato un ambiente di tipo $Gamma$ e un'espressione $E$ tale che $"fv"(E) subset.eq "dom"(Gamma)$, possiamo derivare un #underline[giudizio di tipo] della forma

#align(center)[
  $Gamma tack E : T$
]

che si legge: "nell'ambiente $Gamma$, l'espressione $E$ è ben tipata e ha tipo $T$". La condizione $"fv"(E) subset.eq "dom"(Gamma)$ garantisce che tutte le variabili che compaiono in $E$ abbiano un tipo noto.

==== Giudizi di tipo per i comandi

Dato un ambiente di tipo $Gamma$ e un comando $C$ tale che $"fv"(C) subset.eq "dom"(Gamma)$, possiamo derivare un giudizio della forma

#align(center)[
  $Gamma tack C : Gamma'$
]

che si legge: "nell'ambiente $Gamma$, il comando $C$ è ben tipato e produce l'ambiente locale $Gamma'$". L'ambiente $Gamma'$ contiene le associazioni introdotte dalle eventuali dichiarazioni presenti in $C$; per i comandi che non dichiarano variabili (come l'assegnamento, il condizionale o il ciclo), si ha $Gamma' = emptyset$.

=== Regole di type checking per le espressioni

Le regole seguenti definiscono come derivare i giudizi di tipo per le espressioni. Ogni regola è presentata in stile _regola di inferenza_: le premesse si trovano sopra la linea orizzontale, la conclusione sotto.

==== Costanti

Una costante intera $n$ ha sempre tipo `int`, indipendentemente dall'ambiente. Le costanti booleane `true` e `false` hanno tipo `bool`. Queste sono regole _assiomatiche_ (senza premesse sostanziali).

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$n in bb(Z)$] \
  $Gamma tack n : "int"$ #h(1cm) (T-Int)
]

#align(center)[
  #grid(
    columns: (auto, auto),
    column-gutter: 2cm,
    align: center,
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
      $Gamma tack "true" : "bool"$ #h(1cm) (T-True)
    ],
    [
      #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
      $Gamma tack "false" : "bool"$ #h(1cm) (T-False)
    ],
  )
]

==== Variabili

Il tipo di un identificatore è quello assegnato dall'ambiente $Gamma$. La premessa richiede che l'identificatore sia presente nel dominio di $Gamma$.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma("Id") = T$] \
  $Gamma tack "Id" : T$ #h(1cm) (T-Var)
]

==== Operatori aritmetici

Gli operatori aritmetici ($+, -, times, div, mod$) richiedono che entrambi gli operandi abbiano tipo `int` e producono un risultato di tipo `int`.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E_1 : "int"$ #h(0.3cm) $Gamma tack E_2 : "int"$] \
  $Gamma tack E_1 "aop" E_2 : "int"$ #h(0.5cm) (T-Aop) dove $"aop" in {+, -, times, div, mod}$
]

==== Operatori di confronto

Gli operatori di confronto di ordinamento ($<, <=, >, >=$) confrontano due espressioni intere e producono un risultato booleano:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E_1 : "int"$ #h(0.3cm) $Gamma tack E_2 : "int"$] \
  $Gamma tack E_1 "cop" E_2 : "bool"$ #h(0.5cm) (T-Cop) dove $"cop" in {<, <=, >, >=}$
]

Gli operatori di uguaglianza e disuguaglianza ($==$, $!=$) accettano operandi dello stesso tipo, sia `int` che `bool`, e producono un risultato booleano. Si richiede che entrambi gli operandi abbiano lo stesso tipo $T in {"int", "bool"}$:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E_1 : T$ #h(0.3cm) $Gamma tack E_2 : T$ #h(0.3cm) $T in {"int", "bool"}$] \
  $Gamma tack E_1 "eop" E_2 : "bool"$ #h(0.5cm) (T-Eop) dove $"eop" in {==, !=}$
]

#note[
  La distinzione tra (T-Cop) e (T-Eop) riflette il fatto che gli operatori di ordinamento hanno senso solo su valori interi (non ha significato confrontare `true < false`), mentre l'uguaglianza e la disuguaglianza sono definite anche per i booleani. Ad esempio, l'espressione `(x > 0) == (y > 0)` è ben tipata: entrambi i lati hanno tipo `bool` e l'operatore `==` accetta operandi booleani.
]

==== Operatori logici

Gli operatori logici binari ($and$, $or$) richiedono operandi booleani e producono un booleano. L'operatore unario $not$ nega un'espressione booleana.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E_1 : "bool"$ #h(0.3cm) $Gamma tack E_2 : "bool"$] \
  $Gamma tack E_1 "lop" E_2 : "bool"$ #h(0.5cm) (T-Lop) dove $"lop" in {and, or}$
]

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E : "bool"$] \
  $Gamma tack not E : "bool"$ #h(1cm) (T-Not)
]

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E : "int"$] \
  $Gamma tack -E : "int"$ #h(1cm) (T-Neg)
]

==== Regole di tipo per gli array

Le seguenti regole gestiscono il type checking dei costrutti relativi agli array.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E : "int"$] \
  $Gamma tack "new" T[E] : T[]$ #h(1cm) (T-NewArray)
]

Un letterale array $[E_1, ..., E_n]$ è ben tipato se tutte le espressioni hanno lo stesso tipo $T$. Il risultato ha tipo $T[]$:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E_1 : T$ #h(0.3cm) $...$ #h(0.3cm) $Gamma tack E_n : T$] \
  $Gamma tack [E_1, ..., E_n] : T[]$ #h(1cm) (T-ArrayLit)
]

#note[
  La regola (T-ArrayLit) garantisce l'omogeneità del tipo degli elementi: un letterale come `[1, 2, 3]` ha tipo `int[]`, mentre `[true, false]` ha tipo `bool[]`. Un letterale misto come `[1, true, 3]` è _mal tipato_ perché non esiste un tipo $T$ tale che tutte le espressioni abbiano tipo $T$.
]

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E : T[]$] \
  $Gamma tack E."length" : "int"$ #h(1cm) (T-Length)
]

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E_1 : T[]$ #h(0.3cm) $Gamma tack E_2 : "int"$] \
  $Gamma tack E_1[E_2] : T$ #h(0.5cm) (T-ArrayAccess)
]

=== Regole di type checking per i comandi

Le regole per i comandi stabiliscono quando un comando è ben tipato e quale ambiente locale $Gamma'$ esso produce.

==== Skip

Il comando `skip` è sempre ben tipato e non introduce nuove variabili.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
  $Gamma tack "skip"; : emptyset$ #h(1cm) (T-Skip)
]

==== Dichiarazione

Una dichiarazione `T Id = E;` è ben tipata se l'espressione $E$ ha tipo $T$. La dichiarazione introduce l'associazione $"Id" : T$ nell'ambiente locale.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E : T$] \
  $Gamma tack T space "Id" = E; : {"Id" : T}$ #h(1cm) (T-Decl)
]

==== Assegnamento

Un assegnamento `Id := E;` è ben tipato se la variabile `Id` è già presente nell'ambiente con tipo $T$ e l'espressione $E$ ha lo stesso tipo $T$. L'assegnamento non introduce nuove variabili.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma("Id") = T$ #h(0.3cm) $Gamma tack E : T$] \
  $Gamma tack "Id" := E; : emptyset$ #h(1cm) (T-Assign)
]

==== Assegnamento in array

L'assegnamento a un elemento di array richiede che $E_1$ abbia tipo $T[]$, che $E_2$ abbia tipo `int` (l'indice) e che $E_3$ abbia tipo $T$ (coerente con il tipo degli elementi).

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E_1 : T[]$ #h(0.3cm) $Gamma tack E_2 : "int"$ #h(0.3cm) $Gamma tack E_3 : T$] \
  $Gamma tack E_1[E_2] := E_3; : emptyset$ #h(0.5cm) (T-ArrayAssign)
]

==== Sequenza

La composizione sequenziale $C_1 C_2$ verifica prima $C_1$ nell'ambiente $Gamma$, ottenendo l'ambiente locale $Gamma_1$. Poi verifica $C_2$ nell'ambiente esteso $Gamma union Gamma_1$, ottenendo $Gamma_2$. L'ambiente locale complessivo è l'unione $Gamma_1 union Gamma_2$.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack C_1 : Gamma_1$ #h(0.3cm) $Gamma union Gamma_1 tack C_2 : Gamma_2$] \
  $Gamma tack C_1 C_2 : Gamma_1 union Gamma_2$ #h(0.5cm) (T-Seq)
]

==== Blocco

Un blocco `{C}` incapsula un comando: le dichiarazioni all'interno del blocco sono _locali_ e non visibili all'esterno. Per questo motivo la regola restituisce l'ambiente vuoto $emptyset$.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack C : Gamma'$] \
  $Gamma tack {C} : emptyset$ #h(1cm) (T-Block)
]

==== Condizionale

Il condizionale richiede che la guardia $E$ sia di tipo `bool` e che entrambi i rami $C_1$ e $C_2$ siano ben tipati. Non introduce nuove variabili nell'ambiente esterno, perché i rami sono racchiusi in blocchi.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E : "bool"$ #h(0.3cm) $Gamma tack C_1 : Gamma_1$ #h(0.3cm) $Gamma tack C_2 : Gamma_2$] \
  $Gamma tack "if"(E){C_1}"else"{C_2} : emptyset$ #h(0.3cm) (T-If)
]

==== Ciclo while

Il ciclo `while` richiede che la guardia $E$ abbia tipo `bool` e che il corpo $C$ sia ben tipato. Come il condizionale, non introduce nuove variabili nell'ambiente esterno.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E : "bool"$ #h(0.3cm) $Gamma tack C : Gamma'$] \
  $Gamma tack "while"(E){C} : emptyset$ #h(0.5cm) (T-While)
]

=== Esempi di derivazioni di tipo

I seguenti esempi illustrano come le regole di type checking vengano applicate per costruire _alberi di derivazione_ che dimostrano la correttezza dei tipi in un programma.

#example(title: "Derivazione di tipo per un'espressione aritmetica")[
  Verifichiamo che l'espressione `x + y * 2` sia ben tipata nell'ambiente $Gamma = {x : "int", y : "int"}$.

  L'albero di derivazione si costruisce dal basso verso l'alto, partendo dalle foglie (assiomi) e applicando le regole fino a raggiungere il giudizio desiderato.

  Prima si verifica la sottoespressione `y * 2`:

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[
      #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma(y) = "int"$] $Gamma tack y : "int"$ #h(0.3cm) (T-Var)
      #h(0.5cm)
      #box(stroke: (bottom: 1pt), inset: 3pt)[$2 in bb(Z)$] $Gamma tack 2 : "int"$ #h(0.3cm) (T-Int)
    ] \
    $Gamma tack y * 2 : "int"$ #h(0.5cm) (T-Aop)
  ]

  Poi si combina con `x`:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[
      $Gamma(x) = "int"$ #h(0.5cm) $Gamma tack y * 2 : "int"$
    ] \
    $Gamma tack x + y * 2 : "int"$ #h(0.5cm) (T-Aop)
  ]

  L'espressione è *ben tipata* con tipo `int`.
]

#example(title: "Derivazione di tipo per una sequenza di comandi")[
  Verifichiamo il seguente frammento:
  ```
  int z = 0;
  z := x + 1;
  ```
  nell'ambiente iniziale $Gamma_0 = {x : "int"}$.

  *Passo 1*: Type checking della dichiarazione `int z = 0;`

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_0 tack 0 : "int"$] \
    $Gamma_0 tack "int" space z = 0; : {z : "int"}$ #h(0.5cm) (T-Decl)
  ]

  Dopo la dichiarazione, l'ambiente viene esteso: $Gamma_1 = Gamma_0 union {z : "int"} = {x : "int", z : "int"}$

  *Passo 2*: Type checking dell'assegnamento `z := x + 1;` nell'ambiente $Gamma_1$

  Prima verifichiamo l'espressione `x + 1`:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_1 tack x : "int"$ #h(0.3cm) $Gamma_1 tack 1 : "int"$] \
    $Gamma_1 tack x + 1 : "int"$ #h(0.5cm) (T-Aop)
  ]

  Poi l'assegnamento, verificando la coerenza dei tipi:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_1(z) = "int"$ #h(0.3cm) $Gamma_1 tack x + 1 : "int"$] \
    $Gamma_1 tack z := x + 1; : emptyset$ #h(0.5cm) (T-Assign)
  ]

  Il comando è *ben tipato*.
]

#example(title: "Errore di tipo")[
  Consideriamo il seguente programma:
  ```
  int x = 5;
  bool y = true;
  x := x + y;  // ERRORE!
  ```

  Con $Gamma = {x : "int", y : "bool"}$, tentiamo di derivare il tipo di `x + y`.
  - $Gamma tack x : "int"$ (corretto per T-Var)
  - $Gamma tack y : "bool"$ (corretto per T-Var)
  - La regola (T-Aop) richiede che *entrambi* gli operandi siano di tipo `int`:

  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E_1 : "int"$ #h(0.5cm) $Gamma tack E_2 : "int"$] \
    $Gamma tack E_1 + E_2 : "int"$
  ]

  Poiché $y$ ha tipo `bool` e non `int`, la premessa $Gamma tack y : "int"$ non è derivabile. La derivazione *fallisce* e il compilatore segnala un errore di tipo. Il programma è *mal tipato*.
]

#example(title: "Type checking di un programma con while")[
  Verifichiamo il type checking del seguente programma completo:
  ```
  int x = 5;
  int y = 6;
  while (x != y) {
    if (x < y) { x := x + 2; }
    else { y := y + 1; }
  }
  ```

  *Passo 1*: Partiamo dall'ambiente vuoto $Gamma_0 = emptyset$.

  *Passo 2*: Type checking di `int x = 5;`
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$5 in bb(Z)$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_0 tack 5 : "int"$] \
    $Gamma_0 tack "int" space x = 5; : {x : "int"}$ #h(0.5cm) (T-Decl)
  ]
  Dopo la dichiarazione: $Gamma_1 = Gamma_0 union {x : "int"} = {x : "int"}$

  *Passo 3*: Type checking di `int y = 6;` nell'ambiente $Gamma_1$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$6 in bb(Z)$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_1 tack 6 : "int"$] \
    $Gamma_1 tack "int" space y = 6; : {y : "int"}$ #h(0.5cm) (T-Decl)
  ]
  Dopo la dichiarazione: $Gamma_2 = Gamma_1 union {y : "int"} = {x : "int", y : "int"}$

  *Passo 4*: Verifica della guardia `x != y` nell'ambiente $Gamma_2$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2(x) = "int"$ #h(0.5cm) $Gamma_2(y) = "int"$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2 tack x : "int"$ #h(0.5cm) $Gamma_2 tack y : "int"$] \
    $Gamma_2 tack x != y : "bool"$ #h(0.5cm) (T-Eop)
  ]

  *Passo 5*: Verifica del ramo then `{ x := x + 2; }`

  Prima l'espressione `x + 2`:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2(x) = "int"$ #h(0.5cm) $2 in bb(Z)$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2 tack x : "int"$ #h(0.5cm) $Gamma_2 tack 2 : "int"$] \
    $Gamma_2 tack x + 2 : "int"$ #h(0.5cm) (T-Aop)
  ]

  Poi l'assegnamento e il blocco:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2(x) = "int"$ #h(0.3cm) $Gamma_2 tack x + 2 : "int"$] \
    $Gamma_2 tack x := x + 2; : emptyset$ #h(0.5cm) (T-Assign)
  ]
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2 tack x := x + 2; : emptyset$] \
    $Gamma_2 tack {x := x + 2;} : emptyset$ #h(0.5cm) (T-Block)
  ]

  *Passo 6*: Verifica del ramo else `{ y := y + 1; }` (procedimento analogo)
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2(y) = "int"$ #h(0.3cm) $Gamma_2 tack y + 1 : "int"$] \
    $Gamma_2 tack y := y + 1; : emptyset$ #h(0.5cm) (T-Assign)
  ]
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2 tack y := y + 1; : emptyset$] \
    $Gamma_2 tack {y := y + 1;} : emptyset$ #h(0.5cm) (T-Block)
  ]

  *Passo 7*: Verifica della guardia `x < y`:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2 tack x : "int"$ #h(0.3cm) $Gamma_2 tack y : "int"$] \
    $Gamma_2 tack x < y : "bool"$ #h(0.5cm) (T-Cop)
  ]

  *Passo 8*: Verifica del condizionale completo:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2 tack x < y : "bool"$ #h(0.2cm) $Gamma_2 tack {x := x + 2;} : emptyset$ #h(0.2cm) $Gamma_2 tack {y := y + 1;} : emptyset$] \
    $Gamma_2 tack "if"(x < y){x := x + 2;}"else"{y := y + 1;} : emptyset$ #h(0.3cm) (T-If)
  ]

  *Passo 9*: Verifica del while completo:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_2 tack x != y : "bool"$ #h(0.3cm) $Gamma_2 tack "if"(x < y){...}"else"{...} : emptyset$] \
    $Gamma_2 tack "while"(x != y){"if"(x < y){x := x + 2;}"else"{y := y + 1;}} : emptyset$ #h(0.3cm) (T-While)
  ]

  *Passo 10*: Verifica della sequenza completa tramite (T-Seq):
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma_0 tack "int" x = 5; : {x : "int"}$ #h(0.2cm) $Gamma_1 tack "int" y = 6; "while"... : {y : "int"}$] \
    $Gamma_0 tack "int" x = 5; "int" y = 6; "while"... : {x : "int", y : "int"}$ #h(0.3cm) (T-Seq)
  ]

  Il programma è *ben tipato*.
]

=== Controllo di tipi e inferenza di tipo

Il sistema di tipi di MAO è un sistema a *controllo di tipi* (type checking): il programmatore dichiara esplicitamente il tipo di ogni variabile e il type checker verifica che l'uso sia coerente con le dichiarazioni. Questa non è l'unica strategia possibile.

Molti linguaggi moderni adottano approcci diversi:
- *Linguaggi senza controllo di tipi* (ad esempio JavaScript): i tipi delle variabili non vengono verificati staticamente; eventuali errori di tipo emergono solo a tempo di esecuzione
- *Linguaggi con inferenza di tipo* (ad esempio Go, Haskell, OCaml): il compilatore _deduce_ automaticamente il tipo di una variabile dal contesto in cui viene usata, senza che il programmatore debba dichiararlo esplicitamente

#example(title: "Inferenza di tipo")[
  In un linguaggio con inferenza di tipo, la dichiarazione
  ```
  x := 5 + 3;
  ```
  permette al compilatore di dedurre che `x` ha tipo `int` dal fatto che `5 + 3` è un'espressione aritmetica il cui risultato è un intero.
]

== Estensioni del linguaggio

=== Tipi base aggiuntivi: char e stringhe

==== Caratteri

Il tipo `char` rappresenta singoli simboli, lettere e altri caratteri alfanumerici. In MAO i caratteri possono essere codificati secondo lo standard `ASCII` o `Unicode`. I caratteri _speciali_ (come il ritorno a capo o la tabulazione) vengono rappresentati tramite _sequenze di escape_, cioè combinazioni di caratteri che iniziano con il backslash.

#example(title: "Dichiarazione di caratteri")[
  ```
  char lettera = 'R';
  char a_capo = '\n';
  ```
  Il valore `'\n'` è la sequenza di escape che rappresenta il carattere di ritorno a capo (_newline_).
]

==== Stringhe

Le stringhe in MAO sono trattate come array di caratteri, ovvero hanno tipo `char[]`. Questa scelta semplifica la semantica: tutte le operazioni sugli array (accesso per indice, `.length`, assegnamento) si applicano direttamente alle stringhe.

#example(title: "Stringhe come array di caratteri")[
  La stringa `"Ciao"` è equivalente all'array:
  ```
  char[] saluto = ['C', 'i', 'a', 'o'];
  ```
  Pertanto `saluto.length` restituisce $4$ e `saluto[0]` restituisce `'C'`.
]

=== Assegnamento multiplo

Molti linguaggi di programmazione permettono di dichiarare o assegnare più variabili contemporaneamente in un unico comando. Questa funzionalità, detta *assegnamento multiplo*, consente di scrivere codice più compatto e, in alcuni casi, di realizzare operazioni altrimenti impossibili con assegnamenti singoli.

#example(title: "Dichiarazione multipla")[
  ```
  let x, y, z = 6, 7, 42;
  ```
  Questa singola istruzione dichiara tre variabili e assegna a ciascuna il valore corrispondente nella lista di destra.
]

L'assegnamento multiplo è particolarmente utile per lo *scambio di variabili* (swap), che con assegnamenti singoli richiederebbe una variabile temporanea:

#algorithm(title: "Swap tramite assegnamento multiplo")[
  ```
  x, y := y, x;
  ```
  Tutte le espressioni a destra vengono valutate _prima_ che qualsiasi assegnamento abbia luogo. Ciò significa che i valori originali di `x` e `y` vengono letti, e solo successivamente scritti nelle posizioni scambiate.
]

==== Sintassi dell'assegnamento multiplo

Si introducono due nuove categorie sintattiche, LHS (_Left-Hand Side_) e RHS (_Right-Hand Side_):

#align(center)[
  $"LHS" &::= "Id" | "Id", "LHS"$ \
  $"RHS" &::= E | E, "RHS"$
]

I comandi atomici vengono generalizzati per includere la forma multipla:

#align(center)[
  $C &::= ... | T space "LHS" = "RHS"; | "LHS" := "RHS";$
]

==== Type checking per l'assegnamento multiplo

Le variabili libere di LHS e RHS sono definite come:
#align(center)[
  $"fv"("Id") = {"Id"}$ #h(1cm) $"fv"("Id", "LHS") = {"Id"} union "fv"("LHS")$ \
  $"fv"(E) = "fv"(E)$ #h(1cm) $"fv"(E, "RHS") = "fv"(E) union "fv"("RHS")$
]

La regola di tipo per l'assegnamento multiplo richiede che ogni espressione $E_i$ abbia un tipo coerente con il tipo della variabile corrispondente $"Id"_i$. Si noti che ciascuna coppia variabile-espressione viene verificata in modo indipendente: variabili diverse possono avere tipi diversi.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma("Id"_i) = T_i$ #h(0.2cm) $Gamma tack E_i : T_i$ #h(0.2cm) per $i = 1..n$] \
  $Gamma tack "Id"_1, ..., "Id"_n := E_1, ..., E_n; : emptyset$ #h(0.3cm) (T-MultiAssign)
]

#note[
  La regola (T-MultiAssign) si applica all'assegnamento di variabili semplici. Per l'assegnamento a elementi di array all'interno di un assegnamento multiplo (ad esempio `a[0], b[1] := 5, 10;`) si applicano le stesse verifiche di tipo della regola (T-ArrayAssign) per ciascuna posizione del lato sinistro che sia un accesso ad array.
]

==== Semantica operazionale dell'assegnamento multiplo

La semantica della dichiarazione multipla prevede la valutazione sequenziale di tutte le espressioni, seguita dall'allocazione simultanea delle variabili:

*Dichiarazione multipla:*
#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E_i, rho, sigma_(i-1) chevron.r arrow.b.double (v_i, sigma_i)$ per $i = 1..n$ #h(0.2cm) $l_1, ..., l_n in.not "dom"(sigma_n)$] \
  $chevron.l T space "Id"_1, ..., "Id"_n = E_1, ..., E_n;, rho, sigma chevron.r arrow.r chevron.l rho["Id"_1 |-> l_1]...["Id"_n |-> l_n], sigma_n[l_1 |-> v_1]...[l_n |-> v_n] chevron.r$
]

*Assegnamento multiplo:*
#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E_i, rho, sigma_(i-1) chevron.r arrow.b.double (v_i, sigma_i)$ per $i = 1..n$ #h(0.2cm) $rho("Id"_i) = l_i$ per $i = 1..n$] \
  $chevron.l "Id"_1, ..., "Id"_n := E_1, ..., E_n;, rho, sigma chevron.r arrow.r chevron.l rho, sigma_n[l_1 |-> v_1]...[l_n |-> v_n] chevron.r$
]

#note(title: "Semantica dello swap")[
  Nell'assegnamento multiplo `x, y := y, x`, la semantica garantisce che tutte le espressioni del lato destro vengano valutate _prima_ di effettuare gli assegnamenti. Questo significa che `y` e `x` vengono letti con i loro valori originali, e solo dopo i risultati vengono scritti nelle locazioni di `x` e `y` rispettivamente. Lo swap avviene correttamente senza bisogno di variabili temporanee.
]

=== Direttiva return

La direttiva `return` permette a un blocco di codice (tipicamente il corpo di una funzione) di restituire un valore al chiamante. Il valore restituito è il risultato della valutazione dell'espressione che segue la parola chiave `return`.

#example(title: "Uso della direttiva return")[
  ```
  { count := count + 1; return count; }
  ```
  Questo blocco incrementa la variabile `count` e restituisce il suo nuovo valore.
]

==== Sintassi

La grammatica dei comandi viene estesa con la produzione:

#align(center)[
  $C ::= ... | "return" E;$
]

==== Variabili libere

Le variabili libere di un comando `return` sono quelle dell'espressione restituita:

#align(center)[
  $"fv"("return" E;) = "fv"(E)$
]

==== Type checking

La regola di tipo verifica che l'espressione restituita sia ben tipata. Il comando `return` non introduce nuove variabili.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma tack E : T$] \
  $Gamma tack "return" E; : emptyset$ #h(1cm) (T-Return)
]

#note[
  In un sistema di tipi completo, il tipo $T$ dell'espressione restituita dovrebbe essere confrontato con il tipo di ritorno dichiarato nella firma della funzione. In MAO questo controllo viene effettuato dalla regola (T-Fun) o (T-RecFun).
]

==== Semantica operazionale

L'esecuzione di `return E;` valuta l'espressione $E$ nello stato corrente e produce una terna $(v, rho, sigma')$ che segnala la terminazione con il valore $v$:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$chevron.l E, rho, sigma chevron.r arrow.b.double (v, sigma')$] \
  $chevron.l "return" E;, rho, sigma chevron.r arrow.r (v, rho, sigma')$ #h(1cm) (Return)
]

==== Propagazione del return nei comandi composti

Quando un comando `return` viene eseguito all'interno di un comando composto (sequenza, condizionale o ciclo), il valore restituito deve *propagarsi verso l'alto* fino al contesto della funzione chiamante. In pratica, l'esecuzione di un `return` interrompe immediatamente l'esecuzione del corpo della funzione e restituisce il valore al chiamante.

Nella semantica big-step di MAO, questa propagazione si realizza nel modo seguente: quando l'esecuzione di un sotto-comando produce una terna $(v, rho, sigma')$ anziché una coppia $(rho', sigma')$, ciò segnala che un `return` è stato eseguito. I comandi composti che lo contengono devono propagare questa terna senza eseguire ulteriori istruzioni.

- *Sequenza*: se nella sequenza $C_1 C_2$ l'esecuzione di $C_1$ produce $(v, rho', sigma')$, allora $C_2$ non viene eseguito e il risultato complessivo è $(v, rho', sigma')$. Se $C_1$ termina normalmente e $C_2$ produce un return, il risultato è quello di $C_2$.
- *Condizionale*: se il ramo selezionato (then o else) produce $(v, rho', sigma')$, questo risultato viene propagato.
- *Ciclo while*: se il corpo del while produce $(v, rho', sigma')$, il ciclo si interrompe e il valore viene propagato.

#note[
  La distinzione tra terminazione normale (coppia $(rho', sigma')$) e terminazione con return (terna $(v, rho', sigma')$) è il meccanismo chiave che permette al `return` di interrompere il flusso di esecuzione e propagare il valore restituito attraverso qualsiasi livello di annidamento fino alla regola (Call).
]

== Funzioni

Le funzioni sono un meccanismo di astrazione fondamentale nella programmazione. Permettono di associare un nome a un frammento di codice parametrico, che calcola un valore a partire da uno o più argomenti. Una volta definita, una funzione può essere _invocata_ (chiamata) più volte con argomenti diversi, favorendo il riuso del codice e la modularità del programma.

Si distinguono due momenti:
- *Definizione della funzione*: si scrive il codice del corpo della funzione, specificando i _parametri formali_ (nomi simbolici che rappresentano gli input)
- *Invocazione (chiamata) della funzione*: si esegue il corpo della funzione con _parametri attuali_ (espressioni concrete i cui valori vengono passati ai parametri formali)

#example(title: "Definizione e invocazione di una funzione")[
  ```
  int max(int a, int b){
      int m = a;
      if (b > m) {
          m := b;
      }
      return m;
  }
  ...
  if (max(x, y) < 10) {
      z := max(x + 2, y * 3);
  } else {
      z := max(x / 10, y - 10);
  }
  ```
  La funzione `max` è definita con due parametri formali `a` e `b`. Viene poi invocata tre volte con parametri attuali diversi.
]

=== Corrispondenza tra parametri formali e attuali

Quando si invoca una funzione, i parametri attuali devono corrispondere ai parametri formali *in numero e in tipo*. La corrispondenza è _posizionale_: il primo parametro attuale viene associato al primo parametro formale, il secondo al secondo, e così via.

=== Passaggio di parametri per valore

Il *passaggio per valore* è la modalità di default in MAO per i tipi scalari (`int`, `bool`, `char`). Ogni parametro formale viene inizializzato con una _copia_ del valore del corrispondente parametro attuale. Di conseguenza, eventuali modifiche ai parametri formali all'interno del corpo della funzione _non influenzano_ i parametri attuali nel contesto del chiamante.

=== Passaggio di parametri per riferimento (array)

Quando un array viene passato come parametro attuale, il valore copiato nel parametro formale è l'_indirizzo base_ $l_b$ dell'array. Si tratta tecnicamente ancora di un passaggio per valore (si copia il riferimento), ma il risultato pratico è un *passaggio per riferimento implicito*: la funzione e il chiamante condividono lo stesso array in memoria, quindi le modifiche agli elementi dell'array effettuate nel corpo della funzione sono visibili anche nel contesto del chiamante.

#note[
  Questa è una conseguenza diretta del meccanismo di aliasing descritto in precedenza. Poiché la variabile di tipo array contiene un riferimento e non i dati stessi, copiare la variabile equivale a creare un alias.
]

=== Sintassi delle funzioni

==== Dichiarazione

La sintassi della dichiarazione di funzione è la seguente:

#align(center)[
  $C ::= ... | T_R space "Id"(T_1 space "Id"_1, ..., T_n space "Id"_n){C}$
]

dove $T_R$ è il *tipo di ritorno* (può essere `void` per funzioni che non restituiscono un valore), $"Id"$ è il nome della funzione, $T_i space "Id"_i$ sono le coppie tipo-nome dei parametri formali, e $C$ è il corpo della funzione.

==== Invocazione

La sintassi della chiamata di funzione è:

#align(center)[
  $E ::= ... | "Id"(E_1, ..., E_n)$
]

dove le espressioni $E_1, ..., E_n$ sono i parametri attuali.

==== Tipo di una funzione

Il tipo di una funzione viene rappresentato come un tipo freccia:

#align(center)[
  $(T_1, ..., T_n) arrow.r T_R$
]

dove $(T_1, ..., T_n)$ sono i tipi dei parametri formali e $T_R$ è il tipo di ritorno.

==== Variabili libere di una funzione

Le variabili libere nel corpo di una funzione escludono i parametri formali, che sono dichiarati nell'intestazione:

#align(center)[
  $"fv"(T_R space "Id"(T_1 space "Id"_1, ..., T_n space "Id"_n){C}) = "fv"(C) backslash {"Id"_1, ..., "Id"_n}$
]

=== Type checking delle funzioni

==== Dichiarazione di funzione

La regola di tipo per la dichiarazione di una funzione verifica che il corpo $C$ sia ben tipato in un ambiente esteso con i parametri formali. La dichiarazione introduce nell'ambiente l'associazione tra il nome della funzione e il suo tipo freccia.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma union {"Id"_1 : T_1, ..., "Id"_n : T_n} tack C : Gamma'$] \
  $Gamma tack T_R space "Id"(T_1 space "Id"_1, ..., T_n space "Id"_n){C} : {"Id" : (T_1, ..., T_n) arrow.r T_R}$ #h(0.5cm) (T-Fun)
]

#note[
  Si osservi che il corpo della funzione viene verificato nell'ambiente $Gamma union {"Id"_1 : T_1, ..., "Id"_n : T_n}$, in cui i parametri formali sono disponibili con i loro tipi dichiarati. L'ambiente $Gamma$ del chiamante resta invariato tranne per l'aggiunta del tipo della funzione.
]

==== Invocazione di funzione

La regola per l'invocazione verifica che la funzione sia presente nell'ambiente con un tipo freccia compatibile e che i tipi dei parametri attuali corrispondano (posizionalmente) ai tipi dei parametri formali.

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma("Id") = (T_1, ..., T_n) arrow.r T_R$ #h(0.3cm) $Gamma tack E_1 : T_1$ #h(0.3cm) $...$ #h(0.3cm) $Gamma tack E_n : T_n$] \
  $Gamma tack "Id"(E_1, ..., E_n) : T_R$ #h(0.5cm) (T-Call)
]

=== Semantica operazionale delle funzioni

==== Dichiarazione di funzione

La dichiarazione di una funzione non esegue il corpo, ma memorizza nell'ambiente una *chiusura* (_closure_), ovvero una terna composta dai nomi dei parametri formali, dal corpo della funzione e dall'ambiente al momento della dichiarazione:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
  $chevron.l T_R space "Id"(T_1 space "Id"_1, ..., T_n space "Id"_n){C}, rho, sigma chevron.r arrow.r chevron.l rho["Id" |-> ("Id"_1, ..., "Id"_n, C, rho)], sigma chevron.r$
]

#note(title: "Chiusura (closure)")[
  La chiusura cattura l'ambiente $rho$ al momento della dichiarazione. Questo è essenziale per lo *scoping statico* (o _lessicale_): quando la funzione verrà invocata, le variabili libere nel corpo saranno risolte nell'ambiente della dichiarazione, non in quello della chiamata. Senza la chiusura, una funzione definita in un certo contesto e chiamata in un altro potrebbe accedere a variabili diverse da quelle previste dal programmatore.
]

==== Chiamata di funzione

La chiamata di funzione si articola nei seguenti passi:
1. Si recupera la chiusura della funzione dall'ambiente del chiamante
2. Si valutano i parametri attuali $E_1, ..., E_n$ da sinistra a destra
3. Si allocano nuove locazioni $l_1, ..., l_n$ per i parametri formali
4. Si costruisce un nuovo ambiente $rho'$ estendendo l'ambiente della chiusura $rho_f$ con le associazioni tra parametri formali e locazioni
5. Si esegue il corpo $C$ nel nuovo ambiente $rho'$
6. Il valore restituito dal `return` diventa il risultato della chiamata

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[
    $rho("Id") = ("Id"_1, ..., "Id"_n, C, rho_f)$ \
    $chevron.l E_i, rho, sigma_(i-1) chevron.r arrow.b.double (v_i, sigma_i)$ per $i = 1..n$ \
    $l_1, ..., l_n in.not "dom"(sigma_n)$ \
    $rho' = rho_f["Id"_1 |-> l_1]...["Id"_n |-> l_n]$ \
    $sigma' = sigma_n[l_1 |-> v_1]...[l_n |-> v_n]$ \
    $chevron.l C, rho', sigma' chevron.r arrow.r (v_r, rho'', sigma'')$
  ] \
  $chevron.l "Id"(E_1, ..., E_n), rho, sigma chevron.r arrow.b.double (v_r, sigma'')$ #h(0.3cm) (Call)
]

#note(title: "Scoping statico")[
  Si osservi che il nuovo ambiente $rho'$ è costruito a partire da $rho_f$ (l'ambiente catturato nella chiusura), *non* da $rho$ (l'ambiente del chiamante). Questo implementa lo scoping statico: le variabili libere nel corpo della funzione vengono risolte nel contesto in cui la funzione è stata _definita_, non in quello in cui viene _chiamata_.
]

== Ricorsione

In molti linguaggi di programmazione è ammessa la possibilità di definire *funzioni ricorsive*, cioè funzioni che invocano se stesse (direttamente o indirettamente) nel proprio corpo. La ricorsione è un meccanismo potente che permette di risolvere problemi definiti in modo induttivo, decomponendoli in sottoproblemi della stessa natura ma di dimensione ridotta.

La chiamata ricorsiva può essere:
- *Diretta*: la funzione $f$ contiene nel proprio corpo una chiamata a $f$ stessa
- *Indiretta*: la funzione $f$ chiama una funzione $g$, che a sua volta chiama $f$ (oppure tramite una catena più lunga di chiamate intermedie)

=== Variabili libere nelle funzioni ricorsive

Per supportare la ricorsione, la definizione di variabili libere di una funzione viene modificata includendo anche il nome della funzione stessa tra le variabili escluse:

#align(center)[
  $"fv"(T_R space "Id"(T_1 space "Id"_1, ..., T_n space "Id"_n){C}) = "fv"(C) backslash {"Id", "Id"_1, ..., "Id"_n}$
]

In questo modo il nome della funzione non è considerato una variabile libera nel corpo, anche se vi compare come chiamata ricorsiva. Senza questa modifica, il type checker richiederebbe che `Id` fosse già presente nell'ambiente $Gamma$ prima della dichiarazione, rendendo impossibile la ricorsione.

=== Type checking delle funzioni ricorsive

La regola di tipo per le funzioni ricorsive differisce da (T-Fun) per il fatto che l'ambiente in cui viene verificato il corpo include anche l'associazione tra il nome della funzione e il suo tipo freccia. Questo permette al type checker di verificare le chiamate ricorsive:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma union {"Id" : (T_1, ..., T_n) arrow.r T_R} union {"Id"_1 : T_1, ..., "Id"_n : T_n} tack C : Gamma'$] \
  $Gamma tack T_R space "Id"(T_1 space "Id"_1, ..., T_n space "Id"_n){C} : {"Id" : (T_1, ..., T_n) arrow.r T_R}$ #h(0.3cm) (T-RecFun)
]

#note(title: "Differenza tra T-Fun e T-RecFun")[
  La differenza chiave è nell'ambiente usato per verificare il corpo $C$. In (T-Fun), l'ambiente è $Gamma union {"Id"_1 : T_1, ..., "Id"_n : T_n}$; in (T-RecFun), è $Gamma union {"Id" : (T_1, ..., T_n) arrow.r T_R} union {"Id"_1 : T_1, ..., "Id"_n : T_n}$. La presenza del binding $"Id" : (T_1, ..., T_n) arrow.r T_R$ permette di verificare le chiamate ricorsive nel corpo della funzione come normali invocazioni tramite la regola (T-Call).
]

=== Semantica operazionale delle funzioni ricorsive

Nella semantica operazionale, la ricorsione funziona perché la chiusura di una funzione ricorsiva include il nome della funzione stessa nell'ambiente catturato. Al momento della dichiarazione, l'ambiente $rho$ viene esteso con il binding della funzione _prima_ di costruire la chiusura:

#align(center)[
  #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
  $chevron.l T_R space "Id"(T_1 space "Id"_1, ..., T_n space "Id"_n){C}, rho, sigma chevron.r arrow.r chevron.l rho', sigma chevron.r$
]

dove $rho' = rho["Id" |-> ("Id"_1, ..., "Id"_n, C, rho')]$

#note(title: "Autoreferenza nella chiusura")[
  Si osservi la natura circolare della definizione: l'ambiente $rho'$ contenuto nella chiusura include il binding di $"Id"$ alla chiusura stessa. Questa autoreferenza è ciò che rende possibile la ricorsione a livello semantico. Quando il corpo $C$ viene eseguito durante una chiamata, il nome della funzione è presente nell'ambiente $rho'$ e punta alla stessa chiusura, permettendo di effettuare chiamate ricorsive. Senza questo meccanismo, il corpo della funzione non troverebbe il binding per $"Id"$ nell'ambiente e la chiamata ricorsiva fallirebbe. La regola (Call) non necessita di modifiche: funziona identicamente per funzioni ricorsive e non ricorsive, perché la ricorsione è interamente gestita dalla struttura della chiusura.
]

=== Esempi completi

#example(title: "Type checking della funzione abs")[
  Verifichiamo che la funzione `abs` (valore assoluto) sia ben tipata:
  ```
  int abs(int n) {
    int m = n;
    if (m < 0) { m := -m; }
    return m;
  }
  ```

  Vogliamo dimostrare: $Gamma tack "abs" : ("int") arrow.r "int"$

  *Passo 1*: Costruzione dell'ambiente per il corpo.

  Secondo la regola (T-Fun), il corpo deve essere verificato nell'ambiente:
  $ Gamma' = Gamma union {n : "int"} $

  *Passo 2*: Type checking di `int m = n;` in $Gamma'$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'(n) = "int"$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma' tack n : "int"$] \
    $Gamma' tack "int" space m = n; : {m : "int"}$ #h(0.5cm) (T-Decl)
  ]

  Ambiente aggiornato: $Gamma'' = Gamma' union {m : "int"} = Gamma union {n : "int", m : "int"}$

  *Passo 3*: Type checking della guardia `m < 0` in $Gamma''$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma''(m) = "int"$ #h(0.5cm) $0 in bb(Z)$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack m : "int"$ #h(0.5cm) $Gamma'' tack 0 : "int"$] \
    $Gamma'' tack m < 0 : "bool"$ #h(0.5cm) (T-Cop)
  ]

  *Passo 4*: Type checking della negazione `-m` in $Gamma''$

  L'operatore unario meno richiede un operando intero e produce un intero:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack m : "int"$] \
    $Gamma'' tack -m : "int"$ #h(0.5cm) (T-Neg)
  ]

  *Passo 5*: Type checking dell'assegnamento `m := -m;` in $Gamma''$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma''(m) = "int"$ #h(0.3cm) $Gamma'' tack -m : "int"$] \
    $Gamma'' tack m := -m; : emptyset$ #h(0.5cm) (T-Assign)
  ]

  *Passo 6*: Type checking del blocco `{ m := -m; }` in $Gamma''$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack m := -m; : emptyset$] \
    $Gamma'' tack {m := -m;} : emptyset$ #h(0.5cm) (T-Block)
  ]

  *Passo 7*: Type checking del condizionale (con else implicito uguale a skip)
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack m < 0 : "bool"$ #h(0.2cm) $Gamma'' tack {m := -m;} : emptyset$ #h(0.2cm) $Gamma'' tack "skip"; : emptyset$] \
    $Gamma'' tack "if"(m < 0){m := -m;} : emptyset$ #h(0.3cm) (T-If)
  ]

  *Passo 8*: Type checking di `return m;` in $Gamma''$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma''(m) = "int"$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack m : "int"$] \
    $Gamma'' tack "return" m; : emptyset$ #h(0.5cm) (T-Return)
  ]

  Il tipo restituito (`int`) corrisponde al tipo di ritorno dichiarato nella firma.

  *Passo 9*: Composizione sequenziale del corpo della funzione
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma' tack "int" m = n; : {m : "int"}$ #h(0.2cm) $Gamma'' tack "if"(...){...} "return" m; : emptyset$] \
    $Gamma' tack "int" m = n; "if"(m < 0){m := -m;} "return" m; : {m : "int"}$ #h(0.2cm) (T-Seq)
  ]

  *Passo 10*: Applicazione della regola (T-Fun)
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma union {n : "int"} tack "int" m = n; "if"(m < 0){m := -m;} "return" m; : {m : "int"}$] \
    $Gamma tack "int" space "abs"("int" space n){...} : {"abs" : ("int") arrow.r "int"}$ #h(0.3cm) (T-Fun)
  ]

  Quindi $Gamma tack "abs" : ("int") arrow.r "int"$ come richiesto.
]

#example(title: "Type checking di una funzione ricorsiva su array")[
  Verifichiamo il type checking della funzione ricorsiva `azzera`, che cerca l'elemento `k` nell'array `a` a partire dalla posizione `p` e, se lo trova, lo sostituisce con $0$:
  ```
  bool azzera(int[] a, int k, int p) {
    bool res = false;
    if ((p >= 0) && (p < a.length)) {
      if (a[p] == k) { a[p] := 0; res := true; }
      res := azzera(a, k, p+1);
    }
    return res;
  }
  ```

  *Passo 1*: Poiché la funzione è ricorsiva, usiamo la regola (T-RecFun).

  L'ambiente per il corpo deve includere il tipo della funzione stessa (per permettere la chiamata ricorsiva) e i parametri formali:
  $ Gamma' = Gamma union {"azzera" : ("int"[], "int", "int") arrow.r "bool"} union {a : "int"[], k : "int", p : "int"} $

  *Passo 2*: Type checking di `bool res = false;` in $Gamma'$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$ $] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma' tack "false" : "bool"$] \
    $Gamma' tack "bool" space "res" = "false"; : {"res" : "bool"}$ #h(0.5cm) (T-Decl)
  ]

  Ambiente aggiornato: $Gamma'' = Gamma' union {"res" : "bool"}$

  *Passo 3*: Type checking della guardia `(p >= 0) && (p < a.length)` in $Gamma''$

  Verifica di `p >= 0`:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma''(p) = "int"$ #h(0.3cm) $0 in bb(Z)$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack p : "int"$ #h(0.3cm) $Gamma'' tack 0 : "int"$] \
    $Gamma'' tack p >= 0 : "bool"$ #h(0.5cm) (T-Cop)
  ]

  Verifica di `a.length`:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma''(a) = "int"[]$] \
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack a : "int"[]$] \
    $Gamma'' tack a."length" : "int"$ #h(0.5cm) (T-Length)
  ]

  Verifica di `p < a.length`:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack p : "int"$ #h(0.3cm) $Gamma'' tack a."length" : "int"$] \
    $Gamma'' tack p < a."length" : "bool"$ #h(0.5cm) (T-Cop)
  ]

  Congiunzione logica:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack p >= 0 : "bool"$ #h(0.3cm) $Gamma'' tack p < a."length" : "bool"$] \
    $Gamma'' tack (p >= 0) and (p < a."length") : "bool"$ #h(0.5cm) (T-Lop)
  ]

  *Passo 4*: Type checking dell'accesso `a[p]` in $Gamma''$
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack a : "int"[]$ #h(0.3cm) $Gamma'' tack p : "int"$] \
    $Gamma'' tack a[p] : "int"$ #h(0.5cm) (T-ArrayAccess)
  ]

  *Passo 5*: Type checking della condizione `a[p] == k`
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack a[p] : "int"$ #h(0.3cm) $Gamma'' tack k : "int"$] \
    $Gamma'' tack a[p] == k : "bool"$ #h(0.5cm) (T-Eop)
  ]

  *Passo 6*: Type checking dell'assegnamento `a[p] := 0;`
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack a : "int"[]$ #h(0.3cm) $Gamma'' tack p : "int"$ #h(0.3cm) $Gamma'' tack 0 : "int"$] \
    $Gamma'' tack a[p] := 0; : emptyset$ #h(0.5cm) (T-ArrayAssign)
  ]

  *Passo 7*: Type checking dell'assegnamento `res := true;`
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma''("res") = "bool"$ #h(0.3cm) $Gamma'' tack "true" : "bool"$] \
    $Gamma'' tack "res" := "true"; : emptyset$ #h(0.5cm) (T-Assign)
  ]

  *Passo 8*: Type checking della chiamata ricorsiva `azzera(a, k, p+1)`

  Prima verifichiamo `p+1`:
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack p : "int"$ #h(0.3cm) $Gamma'' tack 1 : "int"$] \
    $Gamma'' tack p + 1 : "int"$ #h(0.5cm) (T-Aop)
  ]

  Poi la chiamata, usando il tipo di `azzera` presente in $Gamma''$ grazie alla regola (T-RecFun):
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma''("azzera") = ("int"[], "int", "int") arrow.r "bool"$ #h(0.2cm) $Gamma'' tack a : "int"[]$ #h(0.2cm) $Gamma'' tack k : "int"$ #h(0.2cm) $Gamma'' tack p+1 : "int"$] \
    $Gamma'' tack "azzera"(a, k, p+1) : "bool"$ #h(0.3cm) (T-Call)
  ]

  *Passo 9*: Type checking dell'assegnamento `res := azzera(a, k, p+1);`
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma''("res") = "bool"$ #h(0.3cm) $Gamma'' tack "azzera"(a, k, p+1) : "bool"$] \
    $Gamma'' tack "res" := "azzera"(a, k, p+1); : emptyset$ #h(0.5cm) (T-Assign)
  ]

  *Passo 10*: Type checking di `return res;`
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma'' tack "res" : "bool"$] \
    $Gamma'' tack "return" "res"; : emptyset$ #h(0.5cm) (T-Return)
  ]

  Il tipo restituito (`bool`) corrisponde al tipo di ritorno dichiarato nella firma.

  *Passo 11*: Applicazione della regola (T-RecFun)
  #align(center)[
    #box(stroke: (bottom: 1pt), inset: 3pt)[$Gamma union {"azzera" : ("int"[], "int", "int") arrow.r "bool"} union {a : "int"[], k : "int", p : "int"} tack C : Gamma'''$] \
    $Gamma tack "bool" space "azzera"("int"[] space a, "int" space k, "int" space p){C} : {"azzera" : ("int"[], "int", "int") arrow.r "bool"}$
  ]
  dove $C$ rappresenta il corpo completo della funzione.

  La funzione è *ben tipata* e ha tipo $("int"[], "int", "int") arrow.r "bool"$.
]

=== Valori iniziali ammissibili per i parametri

Quando una funzione ricorsiva viene definita per risolvere un problema specifico (ad esempio "controllare se l'array contiene almeno $k$ occorrenze di `'z'`"), il type checking garantisce che la funzione sia *ben tipata*, ma non dice con quali valori i parametri debbano essere inizializzati per ottenere il comportamento desiderato. Questa è una domanda *semantica*, non sintattica, e richiede di ragionare sul significato della funzione.

#note(title: "Determinare i valori iniziali")[
  Per determinare i valori iniziali ammissibili dei parametri di una funzione ricorsiva, si procede così:
  + *Leggere la specifica*: cosa deve fare la funzione? (es. "controllare se gli ultimi $k$ caratteri sono tutti `'z'`")
  + *Identificare il caso base*: quale condizione ferma la ricorsione? (es. un flag booleano `b`, un indice fuori dai limiti)
  + *Ragionare all'indietro*: con quali valori iniziali il caso base viene raggiunto correttamente e il risultato è quello voluto?

  In particolare, se la funzione usa:
  - un *parametro indice* `p` che avanza ad ogni chiamata ricorsiva, il valore iniziale deve corrispondere alla posizione di partenza della scansione (ad esempio `p = 0` per scandire dal primo elemento, oppure `p = a.length - 1` per scandire dall'ultimo);
  - un *parametro flag booleano* `b` che controlla il caso base, il valore iniziale deve essere quello che permette alla ricorsione di procedere (tipicamente `b = false` se il caso base è `if (b) { return b; }`).
]

#example(title: "Valori iniziali per il controllo di caratteri")[
  Consideriamo una funzione ricorsiva:
  ```
  bool f1(char[] a, int k, bool b, int p) {
    bool r = false;
    if (b || p >= a.length || p < 0) {
      r := b;
    } else {
      if (a[p] == 'z') { k := k-1; }
      r := f1(a, k, k<0, p+1);
    }
    return r;
  }
  ```
  La funzione controlla se la stringa `a` contiene strettamente più di `k` caratteri `'z'`. Ad ogni passo incrementa `p` e decrementa `k` quando trova `'z'`. La ricorsione si ferma quando `b` diventa vero (cioè `k < 0`, trovati abbastanza `'z'`) oppure quando `p` esce dai limiti.

  I valori iniziali ammissibili sono: $b = "false"$ (perché con $b = "true"$ la funzione ritornerebbe immediatamente senza scandire) e $p = 0$ (per partire dall'inizio dell'array).
]
