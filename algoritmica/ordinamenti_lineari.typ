#import "../template.typ": *

== Limite inferiore per l'ordinamento basato su confronti

#note[
  La teoria generale dei limiti inferiori alla difficoltà dei problemi (criterio della dimensione dell'input, criterio dell'albero di decisione, criterio degli eventi contabili) è trattata nel capitolo sulla complessità computazionale. In questa sezione applichiamo quei risultati al caso specifico dell'ordinamento.
]

Tutti gli algoritmi di ordinamento studiati finora (Insertion Sort, Selection Sort, MergeSort, QuickSort, HeapSort) si basano esclusivamente su *confronti* tra coppie di elementi per determinare l'ordinamento. Una domanda naturale è: esiste un limite inferiore alla complessità di qualsiasi algoritmo di questo tipo?

#theorem(title: "Limite inferiore per l'ordinamento basato su confronti")[
  Qualsiasi algoritmo di ordinamento basato su confronti richiede $Omega(n log n)$ confronti nel caso pessimo per ordinare $n$ elementi.
]

Per dimostrare questo risultato, si introduce il modello dell'*albero di decisione*.

=== Albero di decisione

#definition(title: "Albero di decisione")[
  Un *albero di decisione* è un albero binario che modella tutti i possibili confronti effettuati da un algoritmo di ordinamento su un input di dimensione $n$. Diversi algoritmi producono alberi di forma diversa, ma la proprietà fondamentale è che l'albero deve avere almeno $n!$ foglie (una per ogni possibile permutazione), e un albero binario di altezza $h$ ha al più $2^h$ foglie:
  - Ogni *nodo interno* rappresenta un confronto del tipo $a_i lt.eq a_j$, dove $i, j$ sono indici degli elementi.
  - Il *sottoalbero sinistro* di un nodo corrisponde all'esecuzione nel caso in cui il confronto dia esito positivo ($a_i lt.eq a_j$).
  - Il *sottoalbero destro* corrisponde al caso in cui il confronto dia esito negativo ($a_i > a_j$).
  - Ogni *foglia* rappresenta una permutazione dell'output, cioè un possibile ordinamento finale degli elementi.

  L'altezza dell'albero corrisponde al numero massimo di confronti effettuati dall'algoritmo nel caso pessimo.
]

=== Dimostrazione del limite inferiore

#demonstration[
  Sia $h$ l'altezza dell'albero di decisione associato a un algoritmo che ordina $n$ elementi.

  *Osservazione 1.* L'algoritmo deve essere in grado di produrre ogni possibile permutazione come output. Poiché un array di $n$ elementi distinti ammette $n!$ permutazioni, l'albero deve avere almeno $n!$ foglie.

  *Osservazione 2.* Un albero binario di altezza $h$ ha al più $2^h$ foglie.

  Combinando le due osservazioni:
  $ 2^h gt.eq n! $
  $ h gt.eq log_2(n!) $

  Applicando l'*approssimazione di Stirling* ($n! approx sqrt(2 pi n) dot (n / e)^n$), si ottiene:
  $ log_2(n!) &= sum_(i=1)^(n) log_2(i) gt.eq sum_(i=ceil(n\/2))^(n) log_2(i) gt.eq n / 2 dot log_2(n / 2) = Omega(n log n) $

  Pertanto:
  $ h = Omega(n log n) $

  Qualsiasi algoritmo basato su confronti deve eseguire almeno $Omega(n log n)$ confronti nel caso pessimo.
]

#note(title: "Conseguenze del limite inferiore")[
  - MergeSort e HeapSort, avendo complessità $Theta(n log n)$ nel caso pessimo, sono *asintoticamente ottimi* tra gli algoritmi basati su confronti.
  - QuickSort ha caso pessimo $O(n^2)$, ma caso medio $O(n log n)$.
  - Per superare la barriera $Omega(n log n)$ è necessario *non basarsi esclusivamente su confronti*, sfruttando informazioni aggiuntive sulla struttura dei dati (ad esempio, il fatto che siano interi in un intervallo limitato).
]

== Ordinamento in tempo lineare

Gli algoritmi presentati di seguito raggiungono complessità lineare o quasi-lineare sfruttando ipotesi aggiuntive sull'input. Non si basano esclusivamente su confronti tra coppie di elementi e quindi non sono soggetti al limite inferiore $Omega(n log n)$.

=== Counting Sort

Il *Counting Sort* è un algoritmo di ordinamento che opera su interi nell'intervallo $[0, k]$. L'idea fondamentale è *contare* il numero di occorrenze di ciascun valore e utilizzare queste informazioni per determinare direttamente la posizione finale di ogni elemento nell'array ordinato.

==== Idea

L'algoritmo si articola in quattro fasi:
+ *Inizializzazione*: si crea un array ausiliario $C[0 dots k]$ inizializzato a zero.
+ *Conteggio*: si scorre l'array di input $A$ e per ogni elemento $A[j]$ si incrementa $C[A[j]]$. Al termine, $C[i]$ contiene il numero di elementi uguali a $i$.
+ *Somme prefisse*: si calcolano le somme prefisse su $C$, cioè $C[i] := C[i] + C[i-1]$. Dopo questa fase, $C[i]$ contiene il numero di elementi $lt.eq i$, e quindi indica la posizione finale dell'ultimo elemento con valore $i$ nell'array ordinato.
+ *Costruzione dell'output*: si scorre $A$ da destra a sinistra. Per ogni elemento $A[j]$, si piazza $A[j]$ nella posizione $C[A[j]]$ dell'array di output $B$, e si decrementa $C[A[j]]$.

==== Algoritmo

#algorithm(title: "Counting Sort")[
```
countingSort(int[] A, int[] B, int n, int k){
    // Fase 1: Inizializzazione di C
    int[] C = new int[k + 1];
    int i = 0;
    while(i <= k){
        C[i] := 0;
        i := i + 1;
    }

    // Fase 2: Conteggio delle occorrenze
    int j = 1;
    while(j <= n){
        C[A[j]] := C[A[j]] + 1;
        j := j + 1;
    }

    // Fase 3: Somme prefisse
    i := 1;
    while(i <= k){
        C[i] := C[i] + C[i - 1];
        i := i + 1;
    }

    // Fase 4: Costruzione dell'output (da destra a sinistra)
    j := n;
    while(j >= 1){
        B[C[A[j]]] := A[j];
        C[A[j]] := C[A[j]] - 1;
        j := j - 1;
    }
}
```
]

==== Esempio passo-passo

#example(title: "Esecuzione di Counting Sort")[
  *Input*: $A = [2, 5, 3, 0, 2, 3, 0, 3]$, con $n = 8$ e $k = 5$.

  *Fase 1 -- Inizializzazione.* Si crea l'array $C$ di dimensione $k + 1 = 6$:
  $ C = [0, 0, 0, 0, 0, 0] quad "(indici" 0, 1, 2, 3, 4, 5")" $

  *Fase 2 -- Conteggio.* Si scorre $A$ da sinistra a destra, incrementando $C[A[j]]$ ad ogni passo:
  #figure(
    table(
      columns: 3,
      [*j*], [*A\[j\]*], [*C dopo l'aggiornamento*],
      [1], [2], [$[0, 0, 1, 0, 0, 0]$],
      [2], [5], [$[0, 0, 1, 0, 0, 1]$],
      [3], [3], [$[0, 0, 1, 1, 0, 1]$],
      [4], [0], [$[1, 0, 1, 1, 0, 1]$],
      [5], [2], [$[1, 0, 2, 1, 0, 1]$],
      [6], [3], [$[1, 0, 2, 2, 0, 1]$],
      [7], [0], [$[2, 0, 2, 2, 0, 1]$],
      [8], [3], [$[2, 0, 2, 3, 0, 1]$],
    )
  )
  Lettura di $C$: ci sono 2 zeri, 0 uni, 2 due, 3 tre, 0 quattro, 1 cinque.

  *Fase 3 -- Somme prefisse.* Si trasforma $C$ in modo che $C[i]$ contenga il numero di elementi $lt.eq i$:
  #figure(
    table(
      columns: 3,
      [*i*], [*Calcolo*], [*C*],
      [0], [invariato], [$[2, 0, 2, 3, 0, 1]$],
      [1], [$C[1] := 0 + 2 = 2$], [$[2, 2, 2, 3, 0, 1]$],
      [2], [$C[2] := 2 + 2 = 4$], [$[2, 2, 4, 3, 0, 1]$],
      [3], [$C[3] := 3 + 4 = 7$], [$[2, 2, 4, 7, 0, 1]$],
      [4], [$C[4] := 0 + 7 = 7$], [$[2, 2, 4, 7, 7, 1]$],
      [5], [$C[5] := 1 + 7 = 8$], [$[2, 2, 4, 7, 7, 8]$],
    )
  )
  Interpretazione: ci sono 2 elementi $lt.eq 0$, 2 elementi $lt.eq 1$, 4 elementi $lt.eq 2$, 7 elementi $lt.eq 3$, 7 elementi $lt.eq 4$, 8 elementi $lt.eq 5$.

  *Fase 4 -- Costruzione dell'output.* Si scorre $A$ *da destra a sinistra*. Per ogni $A[j]$, si inserisce $A[j]$ in posizione $C[A[j]]$ di $B$, poi si decrementa $C[A[j]]$:
  #figure(
    table(
      columns: 5,
      [*j*], [*A\[j\]*], [*C\[A\[j\]\]*], [*Posizionamento*], [*B*],
      [8], [3], [7], [$B[7] := 3$], [$[-, -, -, -, -, -, 3, -]$],
      [7], [0], [2], [$B[2] := 0$], [$[-, 0, -, -, -, -, 3, -]$],
      [6], [3], [6], [$B[6] := 3$], [$[-, 0, -, -, -, 3, 3, -]$],
      [5], [2], [4], [$B[4] := 2$], [$[-, 0, -, 2, -, 3, 3, -]$],
      [4], [0], [1], [$B[1] := 0$], [$[0, 0, -, 2, -, 3, 3, -]$],
      [3], [3], [5], [$B[5] := 3$], [$[0, 0, -, 2, 3, 3, 3, -]$],
      [2], [5], [8], [$B[8] := 5$], [$[0, 0, -, 2, 3, 3, 3, 5]$],
      [1], [2], [3], [$B[3] := 2$], [$[0, 0, 2, 2, 3, 3, 3, 5]$],
    )
  )

  *Output finale*: $B = [0, 0, 2, 2, 3, 3, 3, 5]$.
]

==== Stabilità

#definition(title: "Algoritmo di ordinamento stabile")[
  Un algoritmo di ordinamento è *stabile* se elementi con la stessa chiave di ordinamento mantengono l'ordine relativo che avevano nell'input originale.
]

#note(title: "Stabilità del Counting Sort")[
  Il Counting Sort è *stabile* grazie al fatto che la Fase 4 scorre l'array $A$ *da destra a sinistra*. Consideriamo due elementi $A[i]$ e $A[j]$ con $i < j$ e $A[i] = A[j]$. Poiché $j$ viene elaborato prima di $i$ (si parte da $n$ e si decrementa), $A[j]$ viene posizionato in una posizione più alta (a destra) rispetto ad $A[i]$, preservando così l'ordine relativo originale.

  Questa proprietà è fondamentale per il corretto funzionamento del Radix Sort, che richiede un sotto-algoritmo stabile per l'ordinamento su ogni cifra.
]

==== Complessità

Analizziamo separatamente ciascuna fase:
- *Fase 1* -- Inizializzazione di $C$: $Theta(k)$
- *Fase 2* -- Conteggio degli elementi: $Theta(n)$
- *Fase 3* -- Calcolo delle somme prefisse: $Theta(k)$
- *Fase 4* -- Costruzione dell'output: $Theta(n)$

La complessità totale è quindi:
$ T(n, k) = Theta(n + k) $

#note(title: "Quando il Counting Sort è lineare")[
  Se $k = O(n)$, cioè il range dei valori è proporzionale al numero di elementi, allora la complessità diventa $Theta(n)$: ordinamento in tempo lineare. Tuttavia, se $k >> n$ (ad esempio $k = n^2$), il Counting Sort diventa meno efficiente degli algoritmi basati su confronti.
]

==== Limitazioni

- Gli elementi devono essere *interi non negativi* (o mappabili a tali).
- Il range $[0, k]$ deve essere *noto a priori*.
- Lo *spazio ausiliario* richiesto è $Theta(n + k)$ (per gli array $B$ e $C$), quindi l'algoritmo *non è in-place*.
- Se $k$ è molto grande rispetto a $n$, sia il tempo che lo spazio diventano proibitivi.

=== Radix Sort

Il *Radix Sort* ordina numeri interi (o stringhe) analizzando le singole cifre (o caratteri), dalla meno significativa (LSD, _Least Significant Digit_) alla più significativa (MSD, _Most Significant Digit_).

==== Idea

L'algoritmo esegue $d$ passate sull'array, dove $d$ è il numero di cifre del numero più lungo. Ad ogni passata, si ordina l'array rispetto a una singola cifra utilizzando un algoritmo di ordinamento *stabile* (tipicamente il Counting Sort). L'ordine di elaborazione delle cifre è cruciale: si parte dalla cifra meno significativa e si procede verso quella più significativa.

*Perché dalla meno significativa?* Se si procedesse dalla più significativa alla meno significativa, l'ordinamento sulle cifre successive potrebbe distruggere l'ordine già stabilito. Partendo dalla cifra meno significativa, la stabilità dell'algoritmo ausiliario garantisce che, quando si ordina per la cifra $i$, l'ordine relativo stabilito dalle cifre $1, dots, i-1$ viene preservato tra gli elementi con la stessa cifra $i$.

==== Algoritmo

#algorithm(title: "Radix Sort")[
```
radixSort(int[] A, int d){
    // d = numero di cifre del valore massimo
    int i = 1;
    while(i <= d){
        // Ordina A con un algoritmo stabile sulla cifra i-esima
        stableSort(A, i);
        i := i + 1;
    }
}
```
]

==== Esempio passo-passo

#example(title: "Esecuzione di Radix Sort")[
  *Input*: $A = [329, 457, 657, 839, 436, 720, 355]$, con $d = 3$ cifre (in base 10).

  *Passo 1 -- Ordinamento per UNITÀ* (cifra meno significativa).

  Si estraggono le cifre delle unità e si ordina stabilmente rispetto ad esse:
  #figure(
    table(
      columns: 2,
      [*Numero*], [*Cifra delle unità*],
      [329], [9],
      [457], [7],
      [657], [7],
      [839], [9],
      [436], [6],
      [720], [0],
      [355], [5],
    )
  )
  Risultato dopo ordinamento stabile per unità:
  $ [720, 355, 436, 457, 657, 329, 839] $

  *Passo 2 -- Ordinamento per DECINE.*

  Si estraggono le cifre delle decine dall'array corrente e si ordina stabilmente:
  #figure(
    table(
      columns: 2,
      [*Numero*], [*Cifra delle decine*],
      [720], [2],
      [355], [5],
      [436], [3],
      [457], [5],
      [657], [5],
      [329], [2],
      [839], [3],
    )
  )
  Risultato dopo ordinamento stabile per decine:
  $ [720, 329, 436, 839, 355, 457, 657] $

  Si osservi la stabilità: 720 e 329 hanno entrambi cifra delle decine $= 2$, ma 720 precede 329 perché era già prima nell'array dopo il Passo 1. Analogamente, 355 precede 457 e 657 (tutti con decine $= 5$), coerentemente con l'ordine del passo precedente.

  *Passo 3 -- Ordinamento per CENTINAIA* (cifra più significativa).

  Si estraggono le cifre delle centinaia dall'array corrente e si ordina stabilmente:
  #figure(
    table(
      columns: 2,
      [*Numero*], [*Cifra delle centinaia*],
      [720], [7],
      [329], [3],
      [436], [4],
      [839], [8],
      [355], [3],
      [457], [4],
      [657], [6],
    )
  )
  Risultato dopo ordinamento stabile per centinaia:
  $ [329, 355, 436, 457, 657, 720, 839] $

  L'array è ora completamente ordinato. Si noti che 329 precede 355 (entrambi con centinaia $= 3$) perché dopo il Passo 2 il loro ordine relativo era già corretto ($29 < 55$) e la stabilità lo ha preservato.
]

==== Correttezza

#theorem(title: "Correttezza del Radix Sort")[
  Se l'algoritmo ausiliario è stabile, dopo $i$ iterazioni del Radix Sort gli elementi risultano ordinati rispetto alle ultime $i$ cifre.
]

#demonstration[
  Per *induzione* sul numero di cifre $i$ già elaborate.

  *Caso base* ($i = 1$): dopo la prima iterazione, gli elementi sono ordinati rispetto alla cifra meno significativa (cifra 1), per correttezza dell'algoritmo stabile.

  *Passo induttivo*: supponiamo che dopo $i - 1$ iterazioni gli elementi siano ordinati rispetto alle cifre $1, 2, dots, i - 1$ (ipotesi induttiva). Alla $i$-esima iterazione si ordina rispetto alla cifra $i$ con un algoritmo stabile. Consideriamo due elementi $x$ e $y$:
  - Se la cifra $i$-esima di $x$ è minore di quella di $y$, allora $x$ precede $y$ nell'output (per correttezza dell'ordinamento sulla cifra $i$).
  - Se la cifra $i$-esima di $x$ è maggiore di quella di $y$, allora $y$ precede $x$.
  - Se la cifra $i$-esima di $x$ è uguale a quella di $y$, allora per la *stabilità* dell'algoritmo ausiliario, l'ordine relativo di $x$ e $y$ rimane invariato. Ma per ipotesi induttiva, questo ordine riflette correttamente l'ordinamento rispetto alle cifre $1, dots, i - 1$.

  In tutti i casi, dopo $i$ iterazioni gli elementi sono ordinati rispetto alle cifre $1, 2, dots, i$. Dopo $d$ iterazioni l'array è completamente ordinato.
]

==== Complessità

Se si utilizza il Counting Sort come algoritmo stabile, e i numeri sono rappresentati in base $b$:
- Ogni cifra assume valori in $[0, b - 1]$, quindi il Counting Sort su ciascuna cifra richiede $Theta(n + b)$.
- Il numero di cifre è: $d = ceil(log_b(M + 1))$, dove $M$ è il valore massimo.

La complessità totale è:
$ T(n) = Theta(d (n + b)) $

==== Scelta ottimale della base

#theorem(title: "Scelta ottimale della base per Radix Sort")[
  Dati $n$ numeri interi rappresentabili con $r$ bit (cioè con valori in $[0, 2^r - 1]$), e scegliendo la base $b = 2^s$ con $s = floor(log_2 n)$ (quindi $b approx n$), il Radix Sort ordina in tempo:
  $ T(n) = Theta(r / (log_2 n) dot n) $
  Se $r = O(log n)$ (cioè i valori sono polinomiali in $n$), la complessità diventa $Theta(n)$: ordinamento lineare.
]

#note(title: "Intuizione sulla scelta della base")[
  Scegliere $b = n$ minimizza il prodotto $d dot (n + b)$:
  - Con una base troppo piccola (es. $b = 2$), si hanno molte cifre ($d$ grande) e ogni passata è veloce ($n + 2$), ma il costo totale cresce.
  - Con una base troppo grande (es. $b = n^2$), si hanno poche cifre ma ogni passata richiede $Theta(n + n^2)$.
  - Il bilanciamento ottimale si ottiene con $b approx n$, che dà $d = r \/ log n$ passate ciascuna di costo $Theta(n)$.
]

=== Bucket Sort

Il *Bucket Sort* è un algoritmo di ordinamento che assume che l'input sia *distribuito uniformemente* in un intervallo noto, tipicamente $[0, 1)$.

==== Idea

L'algoritmo sfrutta la distribuzione uniforme dell'input per distribuire gli elementi in $n$ *bucket* (contenitori) di uguale ampiezza. Poiché l'input è distribuito uniformemente, ci si aspetta che ogni bucket contenga pochi elementi, e quindi l'ordinamento interno a ciascun bucket sia rapido.

Le fasi dell'algoritmo sono:
+ *Distribuzione*: si dividono gli $n$ elementi in $n$ bucket. L'elemento $A[i]$ viene assegnato al bucket $floor(n dot A[i])$.
+ *Ordinamento locale*: si ordina ciascun bucket con un algoritmo semplice (ad esempio Insertion Sort).
+ *Concatenazione*: si concatenano i bucket in ordine, ottenendo l'array ordinato.

==== Algoritmo

#algorithm(title: "Bucket Sort")[
```
bucketSort(float[] A, int n){
    // Crea n liste (bucket) vuote
    List[] B = new List[n];

    // Distribuisci gli elementi nei bucket
    int i = 1;
    while(i <= n){
        int idx = floor(n * A[i]);
        insert(B[idx], A[i]);
        i := i + 1;
    }

    // Ordina ogni bucket con Insertion Sort
    i := 0;
    while(i <= n - 1){
        insertionSort(B[i]);
        i := i + 1;
    }

    // Concatena i bucket in ordine
    return concatenate(B[0], B[1], ..., B[n - 1]);
}
```
]

#note[
  Si assume che gli elementi siano numeri reali in $[0, 1)$. Per input in un intervallo arbitrario $[a, b)$, si normalizza: $A[i] := (A[i] - a) / (b - a)$.
]

==== Esempio passo-passo

#example(title: "Esecuzione di Bucket Sort")[
  *Input*: $A = [0.78, 0.17, 0.39, 0.26, 0.72, 0.94, 0.21, 0.12, 0.23, 0.68]$, con $n = 10$.

  *Fase 1 -- Distribuzione.* Ogni elemento $A[i]$ viene assegnato al bucket di indice $floor(10 dot A[i])$:
  #figure(
    table(
      columns: 3,
      [*Elemento*], [*$floor(10 dot A[i])$*], [*Bucket*],
      [0.78], [7], [$B[7]$],
      [0.17], [1], [$B[1]$],
      [0.39], [3], [$B[3]$],
      [0.26], [2], [$B[2]$],
      [0.72], [7], [$B[7]$],
      [0.94], [9], [$B[9]$],
      [0.21], [2], [$B[2]$],
      [0.12], [1], [$B[1]$],
      [0.23], [2], [$B[2]$],
      [0.68], [6], [$B[6]$],
    )
  )

  Contenuto dei bucket dopo la distribuzione:
  - $B[1] = chevron.l 0.17, 0.12 chevron.r$
  - $B[2] = chevron.l 0.26, 0.21, 0.23 chevron.r$
  - $B[3] = chevron.l 0.39 chevron.r$
  - $B[6] = chevron.l 0.68 chevron.r$
  - $B[7] = chevron.l 0.78, 0.72 chevron.r$
  - $B[9] = chevron.l 0.94 chevron.r$
  - (gli altri bucket sono vuoti)

  *Fase 2 -- Ordinamento locale.* Si ordina ogni bucket con Insertion Sort:
  - $B[1] = chevron.l 0.12, 0.17 chevron.r$
  - $B[2] = chevron.l 0.21, 0.23, 0.26 chevron.r$
  - $B[3] = chevron.l 0.39 chevron.r$
  - $B[6] = chevron.l 0.68 chevron.r$
  - $B[7] = chevron.l 0.72, 0.78 chevron.r$
  - $B[9] = chevron.l 0.94 chevron.r$

  *Fase 3 -- Concatenazione.*
  $ B = [0.12, 0.17, 0.21, 0.23, 0.26, 0.39, 0.68, 0.72, 0.78, 0.94] $
]

==== Complessità

#theorem(title: "Complessità del Bucket Sort")[
  - *Caso pessimo*: $Theta(n^2)$. Si verifica quando tutti gli elementi finiscono nello stesso bucket, riducendo l'algoritmo a un Insertion Sort sull'intero array.
  - *Caso medio* (con input distribuito uniformemente in $[0, 1)$): $Theta(n)$.
]

#demonstration[
  Sia $n_i$ il numero di elementi nel bucket $i$. Il tempo totale è:
  $ T(n) = Theta(n) + sum_(i=0)^(n-1) O(n_i^2) $
  dove $Theta(n)$ è il costo della distribuzione e della concatenazione, e $O(n_i^2)$ è il costo dell'Insertion Sort sul bucket $i$.

  Calcoliamo il valore atteso. Se l'input è distribuito uniformemente in $[0, 1)$, ogni elemento finisce nel bucket $i$ con probabilità $1\/n$. Quindi $n_i$ segue una distribuzione binomiale $B(n, 1\/n)$, con $E[n_i] = 1$ e $"Var"(n_i) = 1 - 1\/n$.

  $ E[n_i^2] = "Var"(n_i) + (E[n_i])^2 = (1 - 1 / n) + 1 = 2 - 1 / n $

  Pertanto:
  $ E[T(n)] = Theta(n) + sum_(i=0)^(n-1) O(2 - 1 / n) = Theta(n) + O(n) = Theta(n) $
]

==== Limitazioni

- Richiede l'ipotesi di *distribuzione uniforme* dell'input per garantire complessità media lineare.
- Le prestazioni degradano significativamente con distribuzioni non uniformi (molti elementi nello stesso bucket).
- Richiede *spazio ausiliario* $Theta(n)$ per i bucket.
- L'algoritmo *non è in-place*.

=== Riepilogo degli algoritmi di ordinamento

La tabella seguente riassume le caratteristiche di tutti gli algoritmi di ordinamento studiati.

#figure(
  table(
    columns: 6,
    [*Algoritmo*], [*Caso pessimo*], [*Caso medio*], [*Caso migliore*], [*Stabile?*], [*In-place?*],
    [Insertion Sort], [$Theta(n^2)$], [$Theta(n^2)$], [$Theta(n)$], [Sì], [Sì],
    [Selection Sort], [$Theta(n^2)$], [$Theta(n^2)$], [$Theta(n^2)$], [No], [Sì],
    [MergeSort], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n log n)$], [Sì], [No],
    [QuickSort], [$Theta(n^2)$], [$Theta(n log n)$], [$Theta(n log n)$], [No], [Sì],
    [HeapSort], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n log n)$], [No], [Sì],
    [Counting Sort], [$Theta(n + k)$], [$Theta(n + k)$], [$Theta(n + k)$], [Sì], [No],
    [Radix Sort], [$Theta(d(n + b))$], [$Theta(d(n + b))$], [$Theta(d(n + b))$], [Sì], [No],
    [Bucket Sort], [$Theta(n^2)$], [$Theta(n)$], [$Theta(n)$], [Sì], [No],
  ),
  caption: [Confronto completo degli algoritmi di ordinamento]
)

#note(title: "Guida alla lettura della tabella")[
  - *$k$*: range dei valori nel Counting Sort ($[0, k]$).
  - *$d$*: numero di cifre nel Radix Sort.
  - *$b$*: base di rappresentazione nel Radix Sort (ciascuna cifra in $[0, b-1]$).
  - *Stabile*: un algoritmo è stabile se preserva l'ordine relativo degli elementi con chiave uguale.
  - *In-place*: un algoritmo è in-place se utilizza solo $O(1)$ spazio ausiliario (oltre all'input).
]

#note(title: "Osservazioni finali")[
  - Gli algoritmi *basati su confronti* (Insertion Sort, Selection Sort, MergeSort, QuickSort, HeapSort) hanno un limite inferiore di $Omega(n log n)$ nel caso pessimo. MergeSort e HeapSort raggiungono questo limite e sono quindi asintoticamente ottimi.
  - *Counting Sort, Radix Sort e Bucket Sort* possono raggiungere complessità lineare, ma richiedono ipotesi aggiuntive sull'input: interi in un range limitato per i primi due, distribuzione uniforme per il terzo.
  - *QuickSort*, nonostante il caso pessimo $Theta(n^2)$, è spesso preferito nella pratica per il suo eccellente caso medio e per le costanti moltiplicative basse.
  - La scelta dell'algoritmo dipende dalle *caratteristiche dei dati* (tipo, distribuzione, range), dai *vincoli di spazio*, e dalla necessità di *stabilità*.
]
