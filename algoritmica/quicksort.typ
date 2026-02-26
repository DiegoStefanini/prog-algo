#import "../template.typ": *

== QuickSort

Il *QuickSort* è un algoritmo di ordinamento basato sul paradigma Divide et Impera, inventato da Tony Hoare nel 1960. È uno degli algoritmi di ordinamento più utilizzati nella pratica grazie alla sua eccellente efficienza nel caso medio e al basso overhead di memoria, poiché opera *in loco* (in-place) senza richiedere array ausiliari.

L'idea chiave consiste nello scegliere un elemento detto *pivot* e nel partizionare l'array in due sottoinsiemi:
- tutti gli elementi $<= $ pivot finiscono nella parte sinistra
- tutti gli elementi $>$ pivot finiscono nella parte destra

Successivamente si ordina ricorsivamente ciascuna delle due parti. A differenza del MergeSort, il lavoro principale avviene nella fase di *divide* (la procedura Partition), mentre la fase di *combine* è banale: una volta che le due parti sono ordinate, l'intero array è automaticamente ordinato.

=== Algoritmo

#algorithm(title: "QuickSort")[
  ```
  quickSort(int[] A, int p, int r){
      if(p < r){
          int q = partition(A, p, r);   // divide
          quickSort(A, p, q - 1);       // impera (parte sinistra)
          quickSort(A, q + 1, r);       // impera (parte destra)
      }
  }
  ```
]

La chiamata iniziale è `quickSort(A, 1, n)` dove $n$ è la lunghezza dell'array. Il caso base ($p >= r$) corrisponde ad un sotto-array di zero o un elemento, che è già ordinato per definizione.

=== Procedura Partition

La procedura Partition riorganizza il sotto-array $A[p..r]$ *in loco* e restituisce un indice $q$ tale che:
- $A[q]$ contiene il pivot nella sua posizione finale
- ogni elemento in $A[p..q-1]$ è $<= A[q]$
- ogni elemento in $A[q+1..r]$ è $> A[q]$

Il pivot viene scelto come l'ultimo elemento $A[r]$. Si mantiene un indice $i$ che delimita il confine della regione degli elementi $<= x$: tutti gli elementi in $A[p..i]$ sono $<= x$ e tutti quelli in $A[i+1..j-1]$ sono $> x$.

#algorithm(title: "Partition")[
  ```
  int partition(int[] A, int p, int r){
      int x = A[r];              // pivot (ultimo elemento)
      int i = p - 1;             // bordo della partizione sinistra
      int j = p;
      while(j <= r - 1){
          if(A[j] <= x){
              i := i + 1;
              // swap A[i] e A[j]
              int temp = A[i];
              A[i] := A[j];
              A[j] := temp;
          }
          j := j + 1;
      }
      // swap A[i+1] e A[r]: colloca il pivot nella posizione finale
      int temp = A[i + 1];
      A[i + 1] := A[r];
      A[r] := temp;
      return i + 1;
  }
  ```
]

#example(title: "Esecuzione di Partition")[
  Consideriamo $A = chevron.l 2, 8, 7, 1, 3, 5, 6, 4 chevron.r$ con $p = 1$ e $r = 8$.
  Il pivot è $x = A[8] = 4$.

  #table(
    columns: 3,
    align: (center, center, left),
    [*j*], [*i*], [*Stato di A*],
    [1], [0], [$chevron.l 2, 8, 7, 1, 3, 5, 6, 4 chevron.r$ -- $A[1]=2 <= 4$: $i:=1$, swap],
    [2], [1], [$chevron.l 2, 8, 7, 1, 3, 5, 6, 4 chevron.r$ -- $A[2]=8 > 4$: nessuno swap],
    [3], [1], [$chevron.l 2, 8, 7, 1, 3, 5, 6, 4 chevron.r$ -- $A[3]=7 > 4$: nessuno swap],
    [4], [1], [$chevron.l 2, 1, 7, 8, 3, 5, 6, 4 chevron.r$ -- $A[4]=1 <= 4$: $i:=2$, swap],
    [5], [2], [$chevron.l 2, 1, 3, 8, 7, 5, 6, 4 chevron.r$ -- $A[5]=3 <= 4$: $i:=3$, swap],
    [6], [3], [$chevron.l 2, 1, 3, 8, 7, 5, 6, 4 chevron.r$ -- $A[6]=5 > 4$: nessuno swap],
    [7], [3], [$chevron.l 2, 1, 3, 8, 7, 5, 6, 4 chevron.r$ -- $A[7]=6 > 4$: nessuno swap],
  )

  Al termine del ciclo, $i = 3$. Si esegue lo swap di $A[4]$ con $A[8]$ (il pivot):
  $ A = chevron.l 2, 1, 3, bold(4), 7, 5, 6, 8 chevron.r $
  Partition restituisce $q = 4$. Il pivot 4 è nella sua posizione finale; tutti gli elementi a sinistra sono $<= 4$ e tutti quelli a destra sono $> 4$.
]

=== Invariante di Partition

#definition(title: "Invariante del ciclo while in Partition")[
  All'inizio di ogni iterazione del ciclo `while`, per l'indice corrente $j$:
  + Per ogni $k in [p, i]$: $A[k] <= x$ (regione degli elementi piccoli)
  + Per ogni $k in [i+1, j-1]$: $A[k] > x$ (regione degli elementi grandi)
  + $A[r] = x$ (il pivot rimane in posizione $r$)
]

=== Correttezza di Partition

#demonstration[
  La dimostrazione procede verificando le tre proprietà dell'invariante (inizializzazione, conservazione, terminazione).

  *Inizializzazione* ($j = p$): le regioni $A[p..i]$ e $A[i+1..j-1]$ sono vuote (poiché $i = p - 1$ e $j - 1 = p - 1$), quindi l'invariante è banalmente soddisfatto. Il pivot $A[r] = x$ è al suo posto.

  *Conservazione*: supponiamo che l'invariante valga all'inizio dell'iterazione $j$-esima. Due casi:
  - Se $A[j] > x$: si incrementa solo $j$. L'elemento $A[j]$ entra nella regione $A[i+1..j-1]$ degli elementi $> x$, preservando l'invariante.
  - Se $A[j] <= x$: si incrementa $i$ e si scambia $A[i]$ con $A[j]$. L'elemento che era in $A[i]$ (che era $> x$) va in posizione $j$, estendendo la regione $> x$; l'elemento $A[j] <= x$ va in posizione $i$, estendendo la regione $<= x$.

  *Terminazione* ($j = r$): l'invariante garantisce che $A[p..i]$ contiene elementi $<= x$ e $A[i+1..r-1]$ contiene elementi $> x$. Lo swap finale di $A[i+1]$ con $A[r]$ posiziona il pivot in $A[i+1]$, ottenendo la partizione corretta.
]

=== Complessità di Partition

La procedura Partition esegue un singolo scorrimento dell'array da $p$ a $r-1$, effettuando un confronto per ogni elemento. Pertanto la sua complessità è:
$ T_("partition")(n) = Theta(n) $
dove $n = r - p + 1$ è il numero di elementi nel sotto-array.

== Analisi di complessità di QuickSort

La complessità di QuickSort dipende interamente dal bilanciamento delle partizioni prodotte dalla scelta del pivot. La relazione di ricorrenza generale è:
$ T(n) = T(q - 1) + T(n - q) + Theta(n) $
dove $q$ è l'indice restituito da Partition: la partizione sinistra $A[p..q-1]$ contiene $q - 1$ elementi e quella destra $A[q+1..r]$ ne contiene $n - q$.

=== Caso pessimo -- $Theta(n^2)$

Il caso pessimo si verifica quando le partizioni sono *massimamente sbilanciate* ad ogni chiamata ricorsiva: una partizione contiene $n - 1$ elementi e l'altra $0$. Questo accade, ad esempio, quando l'array è già ordinato (o ordinato in modo decrescente) e il pivot è sempre l'ultimo (o il primo) elemento.

La ricorrenza diventa:
$ T(n) = T(n-1) + T(0) + Theta(n) = T(n-1) + Theta(n) $

Svolgendo per sostituzione:
$ T(n) = sum_(k=1)^n Theta(k) = Theta(n^2) $

==== Dimostrazione formale: $T(n) = O(n^2)$ per sostituzione

Per dimostrare rigorosamente il limite superiore, si osserva che nel caso pessimo la ricorrenza è:
$ T(n) = max_(0 <= q <= n-1) (T(q) + T(n - q - 1)) + Theta(n) $
dove $q$ varia da $0$ a $n - 1$ perché Partition genera due sottoproblemi con dimensione totale $n - 1$.

Supponiamo $T(n) <= c n^2$ per qualche costante $c > 0$. Sostituendo nella ricorrenza:
$ T(n) <= max_(0 <= q <= n-1) (c q^2 + c(n - q - 1)^2) + Theta(n) $

L'espressione $q^2 + (n - q - 1)^2$ raggiunge il massimo agli estremi dell'intervallo $[0, n-1]$ (la derivata seconda rispetto a $q$ è positiva, quindi il punto critico è un minimo). Il massimo è $(n - 1)^2 <= n^2 - 2n + 1$. Riprendendo:
$ T(n) <= c n^2 - c(2n - 1) + Theta(n) <= c n^2 $
purché $c$ sia sufficientemente grande da far prevalere $c(2n - 1)$ sul termine $Theta(n)$.

Analogamente si dimostra $T(n) = Omega(n^2)$ nel caso sbilanciato, quindi $T(n) = Theta(n^2)$ nel caso pessimo.

#note(title: "Worst case uguale a Insertion Sort")[
  Nel caso pessimo, QuickSort ha la stessa complessità $Theta(n^2)$ di Insertion Sort e Selection Sort. Tuttavia, questo caso è raro in pratica e può essere evitato con la randomizzazione del pivot.
]

=== Caso ottimo -- $Theta(n log n)$

Il caso ottimo si verifica quando il pivot divide sempre l'array in due parti di *uguale dimensione* (o con al più un elemento di differenza):

$ T(n) = 2T(n/2) + Theta(n) $

Per il Master Theorem (caso 2 con $a = 2$, $b = 2$, $f(n) = Theta(n) = Theta(n^(log_b a))$):
$ T(n) = Theta(n log n) $

=== Caso medio -- $Theta(n log n)$

#theorem(title: "Complessità nel caso medio di QuickSort")[
  Se tutte le permutazioni dell'input sono equiprobabili, la complessità attesa di QuickSort è $Theta(n log n)$.
]

L'intuizione fondamentale è che anche partizioni *moderatamente sbilanciate* producono un albero di ricorsione di altezza $O(log n)$. Ad esempio, anche con uno split costante 9:1 (ogni partizione divide gli elementi in proporzione 90%-10%), la ricorrenza:
$ T(n) = T(9n\/10) + T(n\/10) + Theta(n) $
si risolve comunque in $Theta(n log n)$, poiché l'altezza dell'albero di ricorsione è $log_(10\/9) n = O(log n)$.

Nella pratica, è estremamente improbabile che il pivot produca sempre partizioni degeneri. Il mix di "buone" e "cattive" partizioni che si presenta nel caso medio produce comunque un comportamento $Theta(n log n)$.

#observation[
  *Partizioni buone e cattive alternate.* Supponiamo che le partizioni buone e cattive si alternino nei livelli dell'albero di ricorsione. Una partizione "cattiva" nella radice produce sottoproblemi di dimensione $0$ e $n - 1$ con costo $Theta(n)$; al livello successivo, una partizione "buona" divide $n - 1$ in $(n-1)/2 - 1$ e $(n-1)/2$ con costo $Theta(n - 1)$. Il costo combinato dei due livelli è $Theta(n) + Theta(n - 1) = Theta(n)$, lo stesso costo di un singolo livello con partizione bilanciata che produce due sottoproblemi di dimensione $(n-1)/2$. Quindi il costo della partizione cattiva viene *assorbito* da quello della partizione buona, e il tempo complessivo resta $O(n log n)$.
]

== QuickSort Randomizzato

Per eliminare la dipendenza dal caso peggiore su input particolari (ad esempio, array già ordinati), si può *randomizzare la scelta del pivot*. Invece di scegliere sempre l'ultimo elemento, si sceglie un elemento casuale uniforme nell'intervallo $[p, r]$ e lo si scambia con $A[r]$ prima di chiamare Partition.

#algorithm(title: "Randomized Partition e Randomized QuickSort")[
  ```
  int randomizedPartition(int[] A, int p, int r){
      int i = random(p, r);       // indice casuale uniforme in [p, r]
      // swap A[i] e A[r]
      int temp = A[i];
      A[i] := A[r];
      A[r] := temp;
      return partition(A, p, r);
  }

  randomizedQuickSort(int[] A, int p, int r){
      if(p < r){
          int q = randomizedPartition(A, p, r);
          randomizedQuickSort(A, p, q - 1);
          randomizedQuickSort(A, q + 1, r);
      }
  }
  ```
]

#note(title: "Vantaggi della randomizzazione")[
  Con la randomizzazione, nessun input specifico può causare sistematicamente il caso pessimo. La complessità $Theta(n^2)$ è ancora teoricamente possibile, ma la probabilità che si verifichi è trascurabile. Il tempo di esecuzione *atteso* è $O(n log n)$ *per qualunque input*.
]

=== Analisi del numero atteso di confronti

Il tempo di esecuzione di QuickSort è dominato dal tempo impiegato nella procedura Partition. Ogni volta che viene chiamata Partition, viene selezionato un pivot che non sarà più incluso nelle successive chiamate ricorsive. Quindi ci possono essere al massimo $n$ chiamate di Partition durante l'intera esecuzione dell'algoritmo. Ogni chiamata di Partition svolge una quantità costante di lavoro più un tempo proporzionale al numero di confronti effettuati nel ciclo.

#lemma(titolo: "Tempo di esecuzione e confronti")[
  Sia $X$ il numero totale di confronti svolti in tutte le chiamate di Partition durante l'esecuzione di QuickSort su un array di $n$ elementi. Allora il tempo di esecuzione di QuickSort è $O(n + X)$.
]

#demonstration[
  L'algoritmo effettua al massimo $n$ chiamate di Partition, ciascuna delle quali svolge una quantità costante di lavoro e poi esegue il ciclo un certo numero di volte. Ogni iterazione del ciclo effettua esattamente un confronto. Sommando il lavoro costante ($O(n)$ in totale) e i confronti ($X$ in totale), il tempo complessivo è $O(n + X)$.
]

Per analizzare formalmente il caso medio, si conta dunque il *numero atteso di confronti* eseguiti dall'algoritmo.

Siano $z_1, z_2, ..., z_n$ gli elementi di $A$ in ordine crescente di valore. Definiamo la variabile aleatoria indicatrice:
$ X_(i j) = cases(
  1 & "se" z_i "e" z_j "vengono confrontati durante l'esecuzione",
  0 & "altrimenti"
) $

Il numero totale di confronti è:
$ X = sum_(i=1)^(n-1) sum_(j=i+1)^n X_(i j) $

#theorem(title: "Probabilità di confronto tra due elementi")[
  $ P(X_(i j) = 1) = frac(2, j - i + 1) $

  *Giustificazione.* Consideriamo l'insieme $Z_(i j) = {z_i, z_(i+1), ..., z_j}$ di cardinalità $j - i + 1$. Gli elementi $z_i$ e $z_j$ vengono confrontati se e solo se uno dei due è il *primo* elemento di $Z_(i j)$ ad essere scelto come pivot (in una qualche chiamata ricorsiva). Se venisse scelto come pivot un qualunque elemento $z_k$ con $i < k < j$, allora $z_i$ e $z_j$ finirebbero in partizioni diverse e non sarebbero mai confrontati tra loro. Poiché ogni elemento di $Z_(i j)$ ha la stessa probabilità di essere scelto per primo come pivot, la probabilità cercata è $2 / (j - i + 1)$.
]

Applicando la linearità del valore atteso:
$ E[X] = sum_(i=1)^(n-1) sum_(j=i+1)^n frac(2, j-i+1) $

Con la sostituzione $k = j - i$:
$ E[X] = sum_(i=1)^(n-1) sum_(k=1)^(n-i) frac(2, k+1) < sum_(i=1)^(n-1) sum_(k=1)^(n) frac(2, k) = 2(n-1) H_n = O(n log n) $

dove $H_n = sum_(k=1)^n 1/k = Theta(log n)$ è il numero armonico $n$-esimo.

== Confronto degli algoritmi di ordinamento

#figure(
  table(
    columns: 6,
    align: (left, center, center, center, center, center),
    [*Algoritmo*], [*Caso ottimo*], [*Caso medio*], [*Caso pessimo*], [*Atteso*], [*In-place*],
    [Insertion Sort], [$Theta(n)$], [$Theta(n^2)$], [$Theta(n^2)$], [--], [Si],
    [Selection Sort], [$Theta(n^2)$], [$Theta(n^2)$], [$Theta(n^2)$], [--], [Si],
    [Merge Sort], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n log n)$], [--], [No],
    [QuickSort], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n^2)$], [--], [Si],
    [QuickSort Rand.], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n^2)$], [$Theta(n log n)$], [Si],
  ),
  caption: [Confronto delle complessità in tempo degli algoritmi di ordinamento basati su confronti. La colonna "Atteso" indica la complessità attesa del QuickSort Randomizzato: il caso pessimo deterministico resta $Theta(n^2)$ ma si verifica con probabilità trascurabile.]
)
