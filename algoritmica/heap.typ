#import "../template.typ": *

== Heap e HeapSort

=== Definizione di Heap

#definition(title: "Albero binario quasi completo")[
  Un albero binario è *quasi completo* (o _nearly complete_) se tutti i livelli sono completamente riempiti, eccetto eventualmente l'ultimo, che deve essere riempito da sinistra verso destra senza interruzioni.
]

#definition(title: "Heap binario")[
  Un *heap binario* è un albero binario quasi completo che soddisfa la *proprietà di heap*:
  - *Max-Heap*: per ogni nodo $i$ diverso dalla radice vale $A["Parent"(i)] >= A[i]$, ossia ogni nodo ha chiave non superiore a quella del padre.
  - *Min-Heap*: per ogni nodo $i$ diverso dalla radice vale $A["Parent"(i)] <= A[i]$, ossia ogni nodo ha chiave non inferiore a quella del padre.

  Nel seguito tratteremo esclusivamente il caso del max-heap; le considerazioni per il min-heap sono simmetriche.
]

Da queste definizioni seguono immediatamente alcune proprietà fondamentali.

#theorem(title: "Proprietà strutturali di un max-heap")[
  Sia $A[1 .. n]$ un max-heap con $n$ elementi. Allora:
  + L'elemento massimo si trova nella radice: $A[1] >= A[i]$ per ogni $i in {1, dots, n}$.
  + L'altezza dell'heap è $h = floor(log_2 n)$, dunque $h = Theta(log n)$.
  + Il numero di nodi a un'altezza $h'$ (contata dalle foglie) è al massimo $ceil(n \/ 2^(h'+1))$.
  + Le foglie occupano le posizioni $floor(n\/2)+1, floor(n\/2)+2, dots, n$.
]

#demonstration[
  (1) Segue direttamente dalla proprietà di max-heap applicata ripetutamente lungo il cammino dalla radice a qualsiasi nodo.

  (2) In un albero binario quasi completo con $n$ nodi, il livello $ell$ (con la radice al livello 0) contiene al massimo $2^ell$ nodi. Poiché tutti i livelli fino a $h-1$ sono pieni, si ha $n >= 2^h$, da cui $h <= log_2 n$. Inoltre $n < 2^(h+1)$, da cui $h > log_2 n - 1$. Pertanto $h = floor(log_2 n)$.

  (3) Sia $h' in {0, 1, dots, h}$ un'altezza misurata dalle foglie. I nodi a altezza $h'$ si trovano al livello $h - h'$. Poiché l'heap ha al massimo $n$ nodi e il numero di nodi fino al livello $h - h' - 1$ vale $2^(h - h') - 1$, i nodi al livello $h - h'$ sono al massimo $ceil(n \/ 2^(h'+1))$.

  (4) Un nodo in posizione $i$ ha figlio sinistro in posizione $2i$. Se $2i > n$, allora il nodo non ha figli ed è dunque una foglia. Questo accade per $i > floor(n\/2)$.
]

=== Rappresentazione implicita come array

Un heap può essere memorizzato in modo compatto in un array $A[1 .. n]$, senza bisogno di puntatori espliciti. La radice si trova in $A[1]$ e, per un nodo in posizione $i$:

$ "Parent"(i) = floor(i / 2) , quad "Left"(i) = 2i , quad "Right"(i) = 2i + 1 $

#algorithm(title: "Navigazione nell'heap")[
  ```
  int parent(int i){ return i / 2; }
  int left(int i)  { return 2 * i; }
  int right(int i) { return 2 * i + 1; }
  ```
]

#note(title: "Efficienza della rappresentazione")[
  Questa rappresentazione implicita presenta diversi vantaggi:
  - *Nessun puntatore*: la relazione padre-figlio è codificata dall'aritmetica sugli indici, con notevole risparmio di spazio.
  - *Navigazione in* $O(1)$: le operazioni `parent`, `left` e `right` sono semplici divisioni e moltiplicazioni intere.
  - *Località in memoria*: gli elementi sono memorizzati in posizioni contigue, il che favorisce le prestazioni della cache.
]

#example(title: "Rappresentazione array di un max-heap")[
  Consideriamo l'array $A = [16, 14, 10, 8, 7, 9, 3, 2, 4, 1]$ con $n = 10$.

  Esso corrisponde al seguente max-heap:
  - Radice: $A[1] = 16$
  - Figli di $16$: $A[2] = 14$ (sinistro), $A[3] = 10$ (destro)
  - Figli di $14$: $A[4] = 8$ (sinistro), $A[5] = 7$ (destro)
  - Figli di $10$: $A[6] = 9$ (sinistro), $A[7] = 3$ (destro)
  - Figli di $8$: $A[8] = 2$ (sinistro), $A[9] = 4$ (destro)
  - Figlio di $7$: $A[10] = 1$ (sinistro; il destro non esiste)

  Si può verificare che la proprietà di max-heap vale per ogni nodo: $A["Parent"(i)] >= A[i]$ per $i = 2, dots, 10$.
]

=== Max-Heapify

La procedura `Max-Heapify` è il mattone fondamentale su cui si costruiscono tutte le operazioni sugli heap. Essa ripristina la proprietà di max-heap nel sottoalbero radicato in posizione $i$, sotto l'ipotesi che i sottoalberi sinistro e destro di $i$ siano già max-heap validi. L'unica possibile violazione si trova dunque nel nodo $i$ stesso.

L'idea è semplice: si confronta $A[i]$ con i suoi due figli; si scambia $A[i]$ con il *maggiore* dei due figli (se almeno uno è maggiore) e si prosegue ricorsivamente verso il basso (_sift-down_).

#algorithm(title: "Max-Heapify")[
  ```
  maxHeapify(int[] A, int i, int heapsize){
      int l = left(i);
      int r = right(i);
      int largest = i;

      // Trova il massimo tra A[i], A[l], A[r]
      if((l <= heapsize) && (A[l] > A[i])){
          largest := l;
      }

      if((r <= heapsize) && (A[r] > A[largest])){
          largest := r;
      }

      // Se il massimo non è il nodo corrente, scambia e ricorri
      if(largest != i){
          int temp = A[i];
          A[i] := A[largest];
          A[largest] := temp;
          maxHeapify(A, largest, heapsize);
      }
  }
  ```
]

==== Correttezza di Max-Heapify

#theorem(title: "Correttezza di Max-Heapify")[
  Se i sottoalberi radicati in $"Left"(i)$ e $"Right"(i)$ sono max-heap, allora dopo la chiamata `Max-Heapify(A, i, heapsize)` il sottoalbero radicato in $i$ è un max-heap.
]

#demonstration[
  Procediamo per induzione sull'altezza $h$ del nodo $i$ nell'heap.

  *Caso base* ($h = 0$): il nodo $i$ è una foglia, non ha figli, e dunque è banalmente radice di un max-heap. La procedura non esegue alcuno scambio.

  *Passo induttivo* ($h > 0$): supponiamo che `Max-Heapify` funzioni correttamente per ogni nodo di altezza minore di $h$. La procedura calcola l'indice `largest` del massimo tra $A[i]$, $A[l]$ e $A[r]$.
  - Se $"largest" = i$, allora $A[i] >= A[l]$ e $A[i] >= A[r]$. Poiché i sottoalberi di $l$ e $r$ sono max-heap per ipotesi, il sottoalbero radicato in $i$ è già un max-heap.
  - Se $"largest" != i$, si scambia $A[i]$ con $A["largest"]$. Dopo lo scambio, il nodo $i$ soddisfa la proprietà di max-heap rispetto ai suoi figli. Il sottoalbero radicato in `largest` potrebbe però violare la proprietà, ma ha altezza al più $h - 1$. Per ipotesi induttiva, la chiamata ricorsiva `Max-Heapify(A, largest, heapsize)` ripristina la proprietà.
]

==== Complessità di Max-Heapify

#theorem(title: "Complessità di Max-Heapify")[
  La procedura `Max-Heapify` su un nodo di altezza $h$ ha complessità $O(h)$. Per un heap di $n$ elementi, nel caso pessimo si ha:
  $ T(n) = O(log n) $
]

#demonstration[
  A ogni chiamata ricorsiva, la procedura scende di un livello nell'heap. Il numero massimo di livelli che può attraversare è l'altezza $h$ del nodo di partenza. Poiché ogni livello richiede lavoro $O(1)$ (un confronto e un eventuale scambio), il costo totale è $O(h)$.

  L'altezza massima di un nodo nell'heap è $floor(log_2 n)$, da cui $T(n) = O(log n)$.
]

#example(title: "Max-Heapify passo-passo")[
  Consideriamo l'array $A = [16, 4, 10, 14, 7, 9, 3, 2, 8, 1]$ con $"heapsize" = 10$ e invochiamo `Max-Heapify(A, 2, 10)`.

  Il nodo in posizione 2 ha valore 4. I sottoalberi sinistro (radice $A[4] = 14$) e destro (radice $A[5] = 7$) sono già max-heap, ma $A[2] = 4 < A[4] = 14$, quindi la proprietà di max-heap è violata in posizione 2.

  *Passo 1: confronto in posizione 2*
  - Nodo corrente: $A[2] = 4$
  - Figlio sinistro: $A[4] = 14$
  - Figlio destro: $A[5] = 7$
  - $"largest" = 4$ (poiché $14 > 4$ e $14 > 7$)
  - Scambio $A[2] arrow.l.r A[4]$

  Array dopo il passo 1: $[16, bold(14), 10, bold(4), 7, 9, 3, 2, 8, 1]$

  *Passo 2: chiamata ricorsiva in posizione 4*
  - Nodo corrente: $A[4] = 4$
  - Figlio sinistro: $A[8] = 2$
  - Figlio destro: $A[9] = 8$
  - $"largest" = 9$ (poiché $8 > 4$ e $8 > 2$)
  - Scambio $A[4] arrow.l.r A[9]$

  Array dopo il passo 2: $[16, 14, 10, bold(8), 7, 9, 3, 2, bold(4), 1]$

  *Passo 3: chiamata ricorsiva in posizione 9*
  - Nodo corrente: $A[9] = 4$
  - $"Left"(9) = 18 > "heapsize"$: nessun figlio
  - Il nodo è una foglia: la procedura termina

  *Risultato finale*: $A = [16, 14, 10, 8, 7, 9, 3, 2, 4, 1]$

  Il valore 4 è "sceso" dalla posizione 2 alla posizione 9, attraversando 2 scambi (altezza percorsa $= 2$).
]

=== Build-Max-Heap

Data un array arbitrario $A[1 .. n]$, la procedura `Build-Max-Heap` lo trasforma in un max-heap. L'idea è applicare `Max-Heapify` a tutti i nodi interni, procedendo dal basso verso l'alto (dalle foglie verso la radice). Poiché le foglie sono già heap banali (sottoalberi di un solo nodo), si parte dalla posizione $floor(n\/2)$ e si scende fino a 1.

#algorithm(title: "Build-Max-Heap")[
  ```
  buildMaxHeap(int[] A, int n){
      int heapsize = n;
      int i = n / 2;
      while(i >= 1){
          maxHeapify(A, i, heapsize);
          i := i - 1;
      }
  }
  ```
]

#note[
  Si parte da $i = floor(n\/2)$ e non da $i = n$ perché i nodi nelle posizioni $floor(n\/2)+1, dots, n$ sono foglie (non hanno figli) e sono pertanto max-heap banali di un singolo elemento. Iniziare da essi sarebbe corretto ma inutile.
]

==== Correttezza di Build-Max-Heap

#definition(title: "Invariante di ciclo per Build-Max-Heap")[
  All'inizio di ogni iterazione del ciclo `while`, ogni nodo $j in {i+1, i+2, dots, n}$ è radice di un max-heap.
]

#demonstration[
  *Inizializzazione*: prima della prima iterazione si ha $i = floor(n\/2)$. I nodi $floor(n\/2)+1, dots, n$ sono foglie, dunque radici di max-heap banali. L'invariante vale.

  *Mantenimento*: all'iterazione corrente, l'invariante garantisce che i figli del nodo $i$ (che si trovano nelle posizioni $2i$ e $2i+1$, entrambe $> i$) sono radici di max-heap. Questo è esattamente il prerequisito di `Max-Heapify(A, i, heapsize)`, che rende il sottoalbero radicato in $i$ un max-heap. Dopo il decremento $i := i - 1$, l'invariante si estende al nodo $i+1$ appena trattato.

  *Terminazione*: il ciclo termina quando $i = 0$. A quel punto l'invariante afferma che ogni nodo $j in {1, 2, dots, n}$ è radice di un max-heap. In particolare, il nodo 1 (la radice dell'intero albero) è radice di un max-heap, il che significa che l'intero array è un max-heap.
]

==== Complessità di Build-Max-Heap

===== Analisi ingenua

Si effettuano $O(n)$ chiamate a `Max-Heapify`, ciascuna di costo $O(log n)$. Questo porta a un limite superiore di $O(n log n)$, che è tuttavia non stretto.

===== Analisi stretta

#theorem(title: "Complessità di Build-Max-Heap")[
  La procedura `Build-Max-Heap` ha complessità $Theta(n)$.
]

#demonstration[
  L'altezza dell'heap è $h = floor(log_2 n)$. Il costo di `Max-Heapify` su un nodo a altezza $h'$ (misurata dalle foglie) è $O(h')$.

  Per la proprietà (3) degli heap, a altezza $h'$ vi sono al massimo $ceil(n \/ 2^(h'+1))$ nodi. Sommando su tutte le altezze:

  $ T(n) = sum_(h'=0)^(floor(log_2 n)) ceil(n / 2^(h'+1)) dot O(h') = O(n sum_(h'=0)^(floor(log_2 n)) h' / 2^(h')) $

  La serie $sum_(h'=0)^(infinity) h' / 2^(h')$ converge e vale esattamente 2, essendo derivata della serie geometrica. Pertanto:

  $ T(n) = O(n dot 2) = O(n) $

  Il limite inferiore $Omega(n)$ segue banalmente dal fatto che ogni elemento dell'array deve essere esaminato almeno una volta. Dunque $T(n) = Theta(n)$.
]

#note(title: "Intuizione della complessità lineare")[
  Il risultato $Theta(n)$ può sembrare sorprendente, poiché si eseguono $O(n)$ chiamate a `Max-Heapify`, ciascuna potenzialmente $O(log n)$. Il punto chiave è che la _maggior parte_ dei nodi ha altezza piccola: circa $n\/2$ nodi sono foglie (altezza 0), circa $n\/4$ hanno altezza 1, e così via. Solo un nodo (la radice) ha altezza $floor(log n)$. Il lavoro effettivo è quindi dominato dai nodi bassi.
]

#example(title: "Build-Max-Heap passo-passo")[
  Costruiamo un max-heap dall'array $A = [7, 4, 3, 8, 9, 6]$ con $n = 6$.

  Calcoliamo $floor(n\/2) = 3$: partiamo da $i = 3$ e procediamo fino a $i = 1$.

  *Stato iniziale*:
  #align(center)[
    Array: $[7, 4, 3, 8, 9, 6]$ (indici $1, dots, 6$)
  ]

  *Iterazione $i = 3$: Max-Heapify(A, 3, 6)*
  - Nodo: $A[3] = 3$
  - Figlio sinistro: $A[6] = 6$, figlio destro: non esiste
  - $"largest" = 6$ (poiché $6 > 3$), scambio $A[3] arrow.l.r A[6]$

  Array: $[7, 4, bold(6), 8, 9, bold(3)]$

  *Iterazione $i = 2$: Max-Heapify(A, 2, 6)*
  - Nodo: $A[2] = 4$
  - Figlio sinistro: $A[4] = 8$, figlio destro: $A[5] = 9$
  - $"largest" = 5$ (poiché $9 > 4$ e $9 > 8$), scambio $A[2] arrow.l.r A[5]$
  - Chiamata ricorsiva su posizione 5: è una foglia, termina

  Array: $[7, bold(9), 6, 8, bold(4), 3]$

  *Iterazione $i = 1$: Max-Heapify(A, 1, 6)*
  - Nodo: $A[1] = 7$
  - Figlio sinistro: $A[2] = 9$, figlio destro: $A[3] = 6$
  - $"largest" = 2$ (poiché $9 > 7$ e $9 > 6$), scambio $A[1] arrow.l.r A[2]$

  Array intermedio: $[bold(9), bold(7), 6, 8, 4, 3]$

  - Chiamata ricorsiva su posizione 2:
    - Nodo: $A[2] = 7$
    - Figlio sinistro: $A[4] = 8$, figlio destro: $A[5] = 4$
    - $"largest" = 4$ (poiché $8 > 7$), scambio $A[2] arrow.l.r A[4]$

  Array: $[9, bold(8), 6, bold(7), 4, 3]$

  - Chiamata ricorsiva su posizione 4: figli $A[8]$ e $A[9]$ non esistono, termina

  *Risultato finale*: $A = [9, 8, 6, 7, 4, 3]$ -- un max-heap valido.

  #align(center)[
    #table(
      columns: 4,
      align: center,
      [*Iterazione*], [*$i$*], [*Operazione*], [*Array risultante*],
      [Iniziale], [-], [-], [$[7, 4, 3, 8, 9, 6]$],
      [1], [3], [scambio $3 arrow.l.r 6$], [$[7, 4, 6, 8, 9, 3]$],
      [2], [2], [scambio $4 arrow.l.r 9$], [$[7, 9, 6, 8, 4, 3]$],
      [3], [1], [scambio $7 arrow.l.r 9$, poi $7 arrow.l.r 8$], [$[9, 8, 6, 7, 4, 3]$],
    )
  ]
]

=== HeapSort

L'algoritmo HeapSort sfrutta la struttura del max-heap per ordinare un array in loco.

==== Idea dell'algoritmo

+ Si costruisce un max-heap dall'array con `Build-Max-Heap`. A questo punto il massimo è in $A[1]$.
+ Si scambia $A[1]$ (il massimo) con l'ultimo elemento dell'heap $A["heapsize"]$.
+ Si riduce `heapsize` di 1: l'elemento appena spostato in fondo si trova nella sua posizione finale.
+ Si invoca `Max-Heapify(A, 1, heapsize)` per ripristinare la proprietà di max-heap sulla parte rimanente.
+ Si ripetono i passi 2--4 finché `heapsize` vale 1.

#algorithm(title: "HeapSort")[
  ```
  heapsort(int[] A, int n){
      buildMaxHeap(A, n);
      int heapsize = n;
      int i = n;
      while(i >= 2){
          // swap(A[1], A[i]) - metti il massimo in fondo
          int temp = A[1];
          A[1] := A[i];
          A[i] := temp;

          heapsize := heapsize - 1;
          maxHeapify(A, 1, heapsize);
          i := i - 1;
      }
  }
  ```
]

==== Correttezza di HeapSort

#definition(title: "Invariante di ciclo per HeapSort")[
  All'inizio di ogni iterazione del ciclo `while` con indice $i$:
  + $A[1 .. i]$ è un max-heap contenente gli $i$ elementi più piccoli di $A[1 .. n]$.
  + $A[i+1 .. n]$ contiene gli $n - i$ elementi più grandi di $A[1 .. n]$, in ordine crescente.
]

#demonstration[
  *Inizializzazione*: prima della prima iterazione, $i = n$. L'array $A[1 .. n]$ è un max-heap (appena costruito da `Build-Max-Heap`) e $A[n+1 .. n]$ è vuoto. L'invariante vale banalmente.

  *Mantenimento*: all'inizio dell'iterazione con indice $i$, $A[1]$ contiene il massimo di $A[1 .. i]$ (proprietà del max-heap). Scambiandolo con $A[i]$, l'elemento più grande finisce in posizione $i$. Ora $A[i .. n]$ contiene gli $n - i + 1$ elementi più grandi in ordine crescente. Dopo il decremento di `heapsize` e la chiamata a `Max-Heapify(A, 1, heapsize)`, il sotto-array $A[1 .. i-1]$ è nuovamente un max-heap. L'invariante vale con $i - 1$.

  *Terminazione*: quando $i = 1$, l'invariante afferma che $A[2 .. n]$ contiene gli $n - 1$ elementi più grandi in ordine crescente, e $A[1]$ è il minimo. L'array è ordinato.
]

==== Complessità di HeapSort

#theorem(title: "Complessità di HeapSort")[
  HeapSort ha complessità $Theta(n log n)$ nel caso pessimo, ottimo e medio.
]

#demonstration[
  $ T(n) = underbrace(Theta(n), "Build-Max-Heap") + underbrace((n-1) dot O(log n), "ciclo principale") = O(n log n) $

  La chiamata a `Build-Max-Heap` costa $Theta(n)$. Il ciclo esegue $n - 1$ iterazioni, ciascuna con una chiamata a `Max-Heapify` sulla radice di un heap di dimensione decrescente, per un costo di $O(log n)$ per iterazione. Questo stabilisce il limite superiore $O(n log n)$.

  Per il limite inferiore, si osserva che qualsiasi algoritmo di ordinamento basato su confronti richiede $Omega(n log n)$ confronti nel caso pessimo (limite inferiore informazionale). Pertanto $T(n) = Theta(n log n)$.
]

#note(title: "Caratteristiche di HeapSort")[
  - *Complessità*: $Theta(n log n)$ nel caso pessimo, ottimo e medio. A differenza di QuickSort, non ha un caso pessimo $O(n^2)$.
  - *In-place*: utilizza solo una quantità costante di memoria aggiuntiva (nessun array ausiliario).
  - *Non stabile*: lo scambio tra radice e ultimo elemento può alterare l'ordine relativo di elementi con chiave uguale.
  - Nella pratica, QuickSort è spesso più veloce di HeapSort a causa di una migliore località di cache, nonostante il caso pessimo peggiore.
]

#example(title: "HeapSort passo-passo")[
  Ordiniamo l'array $A = [7, 4, 3, 8, 9, 6]$ usando HeapSort.

  *Fase 1: Build-Max-Heap*

  Come mostrato nell'esempio precedente, dopo `Build-Max-Heap` si ottiene:
  #align(center)[
    $A = [9, 8, 6, 7, 4, 3]$ con $"heapsize" = 6$
  ]

  *Fase 2: estrazione iterativa del massimo*

  #align(center)[
    #table(
      columns: 5,
      align: center,
      [*Iter.*], [*heapsize*], [*Scambio*], [*Dopo scambio*], [*Dopo Max-Heapify*],
      [1], [6], [$A[1] arrow.l.r A[6]$], [$[3, 8, 6, 7, 4 | 9]$], [$[8, 7, 6, 3, 4 | 9]$],
      [2], [5], [$A[1] arrow.l.r A[5]$], [$[4, 7, 6, 3 | 8, 9]$], [$[7, 4, 6, 3 | 8, 9]$],
      [3], [4], [$A[1] arrow.l.r A[4]$], [$[3, 4, 6 | 7, 8, 9]$], [$[6, 4, 3 | 7, 8, 9]$],
      [4], [3], [$A[1] arrow.l.r A[3]$], [$[3, 4 | 6, 7, 8, 9]$], [$[4, 3 | 6, 7, 8, 9]$],
      [5], [2], [$A[1] arrow.l.r A[2]$], [$[3 | 4, 6, 7, 8, 9]$], [$[3 | 4, 6, 7, 8, 9]$],
    )
  ]

  La barra verticale "$|$" separa la parte heap (sinistra) dalla parte già ordinata (destra).

  *Dettaglio iterazione 1* ($i = 6$):
  - Scambio $A[1] = 9$ con $A[6] = 3$: array $= [3, 8, 6, 7, 4, 9]$
  - Riduco `heapsize` a 5 (il 9 è nella sua posizione finale)
  - `Max-Heapify(A, 1, 5)`:
    - $A[1] = 3$, figli: $A[2] = 8$, $A[3] = 6$. Massimo: 8, scambio $A[1] arrow.l.r A[2]$
    - Risultato intermedio: $[8, 3, 6, 7, 4, 9]$
    - Ricorsione su posizione 2: $A[2] = 3$, figli: $A[4] = 7$, $A[5] = 4$. Massimo: 7, scambio $A[2] arrow.l.r A[4]$
    - Risultato: $[8, 7, 6, 3, 4, 9]$

  *Dettaglio iterazione 2* ($i = 5$):
  - Scambio $A[1] = 8$ con $A[5] = 4$: array $= [4, 7, 6, 3, 8, 9]$
  - Riduco `heapsize` a 4
  - `Max-Heapify(A, 1, 4)`:
    - $A[1] = 4$, figli: $A[2] = 7$, $A[3] = 6$. Massimo: 7, scambio $A[1] arrow.l.r A[2]$
    - Risultato: $[7, 4, 6, 3, 8, 9]$
    - Ricorsione su posizione 2: $A[2] = 4$, figli: $A[4] = 3$, nessun figlio destro. $4 > 3$: nessuno scambio

  *Dettaglio iterazione 3* ($i = 4$):
  - Scambio $A[1] = 7$ con $A[4] = 3$: array $= [3, 4, 6, 7, 8, 9]$
  - Riduco `heapsize` a 3
  - `Max-Heapify(A, 1, 3)`:
    - $A[1] = 3$, figli: $A[2] = 4$, $A[3] = 6$. Massimo: 6, scambio $A[1] arrow.l.r A[3]$
    - Risultato: $[6, 4, 3, 7, 8, 9]$

  *Dettaglio iterazione 4* ($i = 3$):
  - Scambio $A[1] = 6$ con $A[3] = 3$: array $= [3, 4, 6, 7, 8, 9]$
  - Riduco `heapsize` a 2
  - `Max-Heapify(A, 1, 2)`:
    - $A[1] = 3$, figlio sinistro: $A[2] = 4$. Scambio $A[1] arrow.l.r A[2]$
    - Risultato: $[4, 3, 6, 7, 8, 9]$

  *Dettaglio iterazione 5* ($i = 2$):
  - Scambio $A[1] = 4$ con $A[2] = 3$: array $= [3, 4, 6, 7, 8, 9]$
  - Riduco `heapsize` a 1
  - `Max-Heapify(A, 1, 1)`: un solo elemento, nulla da fare

  *Risultato finale*: $A = [3, 4, 6, 7, 8, 9]$ -- l'array è ordinato in ordine crescente.
]

=== Code di priorità

Una coda di priorità è una struttura dati astratta che mantiene una collezione dinamica di elementi, ciascuno dotato di una *chiave* (o _priorità_), e supporta operazioni efficienti di inserimento ed estrazione dell'elemento con chiave massima (o minima). Le code di priorità sono alla base di numerosi algoritmi fondamentali.

#definition(title: "Coda di priorità (max)")[
  Una *coda di priorità max* è una struttura dati che mantiene un insieme dinamico $S$ di elementi, ciascuno con una chiave associata, e supporta le seguenti operazioni:
  - `Maximum(S)`: restituisce l'elemento di $S$ con chiave massima, senza modificare $S$.
  - `Extract-Max(S)`: rimuove e restituisce l'elemento di $S$ con chiave massima.
  - `Increase-Key(S, x, k)`: aumenta la chiave dell'elemento $x$ al nuovo valore $k >= A[x]$.
  - `Insert(S, x)`: inserisce un nuovo elemento $x$ in $S$.
]

==== Applicazioni

Le code di priorità trovano impiego in numerosi contesti:
- *Scheduling di processi*: il sistema operativo seleziona il processo con priorità più alta da eseguire.
- *Simulazione di eventi discreti*: gli eventi vengono estratti in ordine cronologico (priorità = tempo dell'evento).
- *Algoritmo di Dijkstra*: coda di priorità min per estrarre il vertice con distanza stimata minima.
- *Algoritmo di Prim*: per la costruzione dell'albero di copertura minimo (MST).

==== Implementazione con Max-Heap

Un max-heap fornisce un'implementazione naturale ed efficiente di una coda di priorità max.

===== Maximum

L'operazione più semplice: il massimo è sempre la radice dell'heap.

#algorithm(title: "Heap-Maximum")[
  ```
  int heapMaximum(int[] A){
      return A[1];
  }
  ```
]

Complessità: $O(1)$.

===== Extract-Max

Si salva il valore della radice, si sostituisce la radice con l'ultimo elemento dell'heap, si riduce la dimensione e si invoca `Max-Heapify` per ripristinare la proprietà.

#algorithm(title: "Heap-Extract-Max")[
  ```
  int heapExtractMax(int[] A, int heapsize){
      if(heapsize < 1){
          // errore: heap vuoto (underflow)
          return -1;
      }
      int max = A[1];
      A[1] := A[heapsize];
      heapsize := heapsize - 1;
      maxHeapify(A, 1, heapsize);
      return max;
  }
  ```
]

Complessità: $O(log n)$, dominata dalla chiamata a `Max-Heapify`.

===== Increase-Key

Per aumentare la chiave di un elemento, si aggiorna il valore e si fa "risalire" l'elemento verso la radice (_sift-up_), scambiandolo con il padre finché la proprietà di max-heap non è ripristinata.

#algorithm(title: "Heap-Increase-Key")[
  ```
  heapIncreaseKey(int[] A, int i, int key){
      if(key < A[i]){
          // errore: la nuova chiave è minore della precedente
          return;
      }
      A[i] := key;
      // Risali verso la radice finché necessario
      while((i > 1) && (A[parent(i)] < A[i])){
          int temp = A[i];
          A[i] := A[parent(i)];
          A[parent(i)] := temp;
          i := parent(i);
      }
  }
  ```
]

Complessità: $O(log n)$. Nel caso pessimo l'elemento risale dalla foglia fino alla radice, percorrendo $O(log n)$ livelli.

===== Insert

Per inserire un nuovo elemento, si estende l'heap di una posizione in fondo, si inserisce un valore "sentinella" $-infinity$ e si invoca `Increase-Key` per portare la chiave al valore desiderato.

#algorithm(title: "Heap-Insert")[
  ```
  heapInsert(int[] A, int key, int heapsize){
      heapsize := heapsize + 1;
      A[heapsize] := -∞;
      heapIncreaseKey(A, heapsize, key);
  }
  ```
]

Complessità: $O(log n)$, dominata dalla chiamata a `Increase-Key`.

#example(title: "Operazioni su una coda di priorità")[
  Partiamo dal max-heap $A = [16, 14, 10, 8, 7, 9, 3, 2, 4, 1]$ con $"heapsize" = 10$.

  *Operazione 1: Maximum*
  - Restituisce $A[1] = 16$. L'heap non cambia.

  *Operazione 2: Extract-Max*
  - Si salva $max = A[1] = 16$
  - Si pone $A[1] := A[10] = 1$, si riduce `heapsize` a 9
  - Array: $[1, 14, 10, 8, 7, 9, 3, 2, 4]$
  - `Max-Heapify(A, 1, 9)`:
    - $A[1] = 1$, figli: $14$, $10$. Scambio con 14 (posizione 2)
    - $A[2] = 1$, figli: $8$, $7$. Scambio con 8 (posizione 4)
    - $A[4] = 1$, figli: $2$, $4$. Scambio con 4 (posizione 9)
  - Risultato: $A = [14, 8, 10, 4, 7, 9, 3, 2, 1]$, restituisce 16

  *Operazione 3: Increase-Key(A, 9, 15)* (aumento la chiave in posizione 9 a 15)
  - Si pone $A[9] := 15$
  - Array: $[14, 8, 10, 4, 7, 9, 3, 2, 15]$
  - Risalita: $A[9] = 15 > A[4] = 4$, scambio. Array: $[14, 8, 10, 15, 7, 9, 3, 2, 4]$
  - Risalita: $A[4] = 15 > A[2] = 8$, scambio. Array: $[14, 15, 10, 8, 7, 9, 3, 2, 4]$
  - Risalita: $A[2] = 15 > A[1] = 14$, scambio. Array: $[15, 14, 10, 8, 7, 9, 3, 2, 4]$
  - $i = 1$: radice raggiunta, terminazione

  *Operazione 4: Insert(A, 12)* con $"heapsize" = 9$
  - Si pone $"heapsize" := 10$, $A[10] := -infinity$
  - `Increase-Key(A, 10, 12)`: $A[10] := 12$
  - Risalita: $A[10] = 12 > A[5] = 7$, scambio. Array con $A[5] = 12$, $A[10] = 7$
  - Risalita: $A[5] = 12 < A[2] = 14$: nessuno scambio, terminazione
  - Risultato: $A = [15, 14, 10, 8, 12, 9, 3, 2, 4, 7]$
]

==== Riepilogo complessità

#figure(
  table(
    columns: 3,
    align: center,
    [*Operazione*], [*Max-Heap*], [*Array non ordinato*],
    [`Maximum`], [$O(1)$], [$O(n)$],
    [`Extract-Max`], [$O(log n)$], [$O(n)$],
    [`Insert`], [$O(log n)$], [$O(1)$],
    [`Increase-Key`], [$O(log n)$], [$O(1)$],
  ),
  caption: [Confronto delle complessità per le operazioni sulle code di priorità]
)

#note(title: "Compromesso dell'implementazione con heap")[
  L'implementazione con max-heap offre un buon compromesso: tutte e quattro le operazioni hanno costo al più logaritmico. Con un array non ordinato, `Insert` e `Increase-Key` sono $O(1)$, ma `Maximum` ed `Extract-Max` richiedono una scansione lineare $O(n)$. Simmetricamente, con un array ordinato `Maximum` ed `Extract-Max` sono $O(1)$, ma l'inserimento richiede $O(n)$ per mantenere l'ordinamento.
]
