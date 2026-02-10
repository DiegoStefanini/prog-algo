#import "../template.typ": *

== Insertion Sort

L'Insertion Sort è un algoritmo di ordinamento iterativo. L'idea è quella di mantenere una porzione iniziale dell'array già ordinata e, ad ogni passo, inserire il prossimo elemento nella posizione corretta all'interno di tale porzione.

*Input*: array $A[1..n]$ di interi. \
*Output*: $A$ ordinato in modo non decrescente: $A[1] <= A[2] <= dots <= A[n]$.

#algorithm(title: "InsertionSort")[
  ```
  insertionSort(int[] A, int n){
      int j = 2;
      while(j <= n){
          int k = A[j];
          int i = j - 1;
          while((i > 0) && (A[i] > k)){
              A[i + 1] := A[i];
              i := i - 1;
          }
          A[i + 1] := k;
          j := j + 1;
      }
  }
  ```
]

*Funzionamento.* All'iterazione $j$-esima del ciclo esterno, l'elemento $A[j]$ viene salvato in una variabile $k$ (la _chiave_). Il ciclo interno scorre il sottoarray $A[1..j-1]$ da destra verso sinistra, spostando a destra tutti gli elementi maggiori di $k$. Quando si trova la posizione corretta (un elemento minore o uguale a $k$, oppure l'inizio dell'array), la chiave viene inserita.

#example(title: "Esecuzione di Insertion Sort")[
  Sia $A = [5, 2, 4, 6, 1, 3]$ con $n = 6$.

  - *$j = 2$*: chiave $k = 2$. Confronto con $A[1] = 5 > 2$: sposto $5$ a destra. Raggiunto l'inizio dell'array: inserisco $k$. \
    $A = [2, 5, 4, 6, 1, 3]$
  - *$j = 3$*: chiave $k = 4$. Confronto con $A[2] = 5 > 4$: sposto $5$. Confronto con $A[1] = 2 <= 4$: stop. Inserisco $k$. \
    $A = [2, 4, 5, 6, 1, 3]$
  - *$j = 4$*: chiave $k = 6$. Confronto con $A[3] = 5 <= 6$: stop. Nessuno spostamento. \
    $A = [2, 4, 5, 6, 1, 3]$
  - *$j = 5$*: chiave $k = 1$. Sposto $6, 5, 4, 2$ (tutti maggiori di $1$). Raggiunto l'inizio: inserisco $k$. \
    $A = [1, 2, 4, 5, 6, 3]$
  - *$j = 6$*: chiave $k = 3$. Sposto $6, 5, 4$. Confronto con $A[2] = 2 <= 3$: stop. Inserisco $k$. \
    $A = [1, 2, 3, 4, 5, 6]$
]

=== Dimostrazione di correttezza con invariante di ciclo

Per dimostrare che l'Insertion Sort produce effettivamente un array ordinato, utilizziamo la tecnica dell'*invariante di ciclo*.

*Invariante*: All'inizio dell'iterazione $j$-esima del ciclo esterno, il sottoarray $A[1..j-1]$ contiene gli stessi elementi che erano in $A[1..j-1]$ prima dell'esecuzione dell'algoritmo, disposti in ordine non decrescente.

#demonstration[
  *Inizializzazione* ($j = 2$): \
  Prima della prima iterazione, il sottoarray $A[1..1]$ contiene un solo elemento. Un singolo elemento è banalmente ordinato, e coincide con l'elemento originale. L'invariante è verificato.

  *Mantenimento*: Supponiamo che l'invariante sia vero all'inizio dell'iterazione $j$-esima, ovvero $A[1..j-1]$ è ordinato e contiene gli elementi originali. Il corpo del ciclo:
  + Salva $A[j]$ nella variabile $k$.
  + Il ciclo interno sposta a destra gli elementi di $A[1..j-1]$ che sono maggiori di $k$, preservando il loro ordine relativo.
  + Inserisce $k$ nella posizione corretta, cioè immediatamente dopo l'ultimo elemento $<= k$.

  Al termine, $A[1..j]$ contiene tutti gli elementi originali di $A[1..j]$ ed è ordinato. L'invariante vale quindi per $j + 1$.

  *Terminazione* ($j = n + 1$): \
  Il ciclo termina quando $j = n + 1$. Per l'invariante, $A[1..n]$ contiene gli elementi originali in ordine non decrescente. Questo è esattamente la specifica dell'output desiderato.
]

=== Analisi della complessità

Sia $d_j$ il numero di volte in cui il ciclo interno viene eseguito (con guardia vera) per un dato valore di $j$. Al variare di $j$ da 2 a $n$, il numero totale di confronti è:

$ C(n) = sum_(j=2)^n d_j $

- *Caso ottimo*: l'array è già ordinato. Per ogni $j$, la condizione $A[i] > k$ è subito falsa, dunque $d_j = 0$ spostamenti vengono effettuati. Tuttavia, anche quando $d_j = 0$, si esegue comunque un confronto: il test di guardia del ciclo interno ($A[i] > k$) che risulta immediatamente falso. Per questo il costo per ogni $j$ è di 1 confronto. Il numero totale di confronti è:
  $ C(n) = sum_(j=2)^n 1 = n - 1 = Theta(n) $
  La complessità è *lineare*.

- *Caso pessimo*: l'array è ordinato in ordine decrescente. Per ogni $j$, tutti gli elementi di $A[1..j-1]$ sono maggiori della chiave, e il ciclo interno esegue $j - 1$ spostamenti. Il numero totale di confronti è:
  $ C(n) = sum_(j=2)^n (j - 1) = sum_(k=1)^(n-1) k = frac(n(n-1), 2) = Theta(n^2) $
  La complessità è *quadratica*.

In sintesi:
- *Caso ottimo*: $T(n) = Theta(n)$ -- lineare
- *Caso pessimo*: $T(n) = Theta(n^2)$ -- quadratico

L'Insertion Sort è dunque un algoritmo efficiente su array quasi ordinati, ma inadeguato per array in ordine inverso o casuale di grandi dimensioni.

== Selection Sort

Il Selection Sort è un algoritmo di ordinamento iterativo basato su un'idea diversa dall'Insertion Sort: ad ogni passo, si seleziona il minimo tra gli elementi non ancora ordinati e lo si colloca nella posizione corretta tramite uno scambio.

*Input*: array $A[1..n]$ di interi. \
*Output*: $A$ ordinato in modo non decrescente: $A[1] <= A[2] <= dots <= A[n]$.

#algorithm(title: "SelectionSort")[
  ```
  selectionSort(int[] A, int n){
      int i = 1;
      while(i <= n - 1){
          int min = i;
          int j = i + 1;
          while(j <= n){
              if(A[j] < A[min]){
                  min := j;
              }
              j := j + 1;
          }
          // swap(A[i], A[min])
          int temp = A[i];
          A[i] := A[min];
          A[min] := temp;
          i := i + 1;
      }
  }
  ```
]

*Funzionamento.* All'iterazione $i$-esima del ciclo esterno, il ciclo interno cerca l'indice dell'elemento minimo nel sottoarray $A[i..n]$. Una volta trovato, l'elemento minimo viene scambiato con $A[i]$. Dopo questa operazione, $A[1..i]$ contiene gli $i$ elementi più piccoli dell'array, in ordine non decrescente.

#example(title: "Esecuzione di Selection Sort")[
  Sia $A = [5, 2, 4, 6, 1, 3]$ con $n = 6$.

  - *$i = 1$*: cerco il minimo in $A[1..6]$. Minimo: $A[5] = 1$. Scambio $A[1]$ con $A[5]$. \
    $A = [1, 2, 4, 6, 5, 3]$
  - *$i = 2$*: cerco il minimo in $A[2..6]$. Minimo: $A[2] = 2$. Scambio $A[2]$ con se stesso. \
    $A = [1, 2, 4, 6, 5, 3]$
  - *$i = 3$*: cerco il minimo in $A[3..6]$. Minimo: $A[6] = 3$. Scambio $A[3]$ con $A[6]$. \
    $A = [1, 2, 3, 6, 5, 4]$
  - *$i = 4$*: cerco il minimo in $A[4..6]$. Minimo: $A[6] = 4$. Scambio $A[4]$ con $A[6]$. \
    $A = [1, 2, 3, 4, 5, 6]$
  - *$i = 5$*: cerco il minimo in $A[5..6]$. Minimo: $A[5] = 5$. Scambio $A[5]$ con se stesso. \
    $A = [1, 2, 3, 4, 5, 6]$
]

#note(title: "Invariante del ciclo interno del Selection Sort")[
  Il ciclo interno del Selection Sort mantiene la seguente invariante: all'inizio dell'iterazione $j$-esima del ciclo interno, $A["min"]$ è il minimo di $A[i..j-1]$. Questo garantisce che, al termine del ciclo interno (quando $j = n + 1$), $A["min"]$ sia effettivamente il minimo dell'intero sottoarray $A[i..n]$.
]

=== Dimostrazione di correttezza con invariante di ciclo

*Invariante*: All'inizio dell'iterazione $i$-esima del ciclo esterno:
+ Il sottoarray $A[1..i-1]$ è ordinato in modo non decrescente.
+ Ogni elemento di $A[1..i-1]$ è minore o uguale ad ogni elemento di $A[i..n]$.

#demonstration[
  *Inizializzazione* ($i = 1$): \
  Il sottoarray $A[1..0]$ è vuoto. Entrambe le condizioni dell'invariante sono banalmente verificate (proprietà dell'insieme vuoto).

  *Mantenimento*: Supponiamo l'invariante vero per $i$. Dimostriamo che vale per $i + 1$.
  - Il ciclo interno esamina $A[i], A[i+1], ..., A[n]$ e individua l'indice $"min"$ dell'elemento minimo in questo sottoarray.
  - Lo scambio tra $A[i]$ e $A["min"]$ colloca in posizione $i$ il più piccolo elemento di $A[i..n]$.
  - Per l'ipotesi induttiva (condizione 2), tutti gli elementi di $A[1..i-1]$ sono $<=$ ad ogni elemento di $A[i..n]$, e in particolare $<= A[i]$ dopo lo scambio.
  - Dunque $A[1..i]$ è ordinato e contiene gli $i$ elementi più piccoli dell'array.
  - Ogni elemento di $A[i+1..n]$ è $>= A[i]$ (perché $A[i]$ era il minimo di $A[i..n]$).
  L'invariante vale per $i + 1$.

  *Terminazione* ($i = n$): \
  Per l'invariante, $A[1..n-1]$ è ordinato e contiene gli $n - 1$ elementi più piccoli. L'unico elemento rimasto, $A[n]$, è necessariamente il più grande. L'intero array è ordinato.
]

=== Analisi della complessità

Il ciclo interno, per un dato valore di $i$, esegue esattamente $n - i$ confronti. Il numero totale di confronti è:

$ C(n) = sum_(i=1)^(n-1) (n - i) = (n-1) + (n-2) + dots + 1 = sum_(k=1)^(n-1) k = frac(n(n-1), 2) = Theta(n^2) $

A differenza dell'Insertion Sort, il Selection Sort esegue sempre $Theta(n^2)$ confronti, *indipendentemente dall'input*. Il caso ottimo, pessimo e medio coincidono:

$ T(n) = Theta(n^2) $

#note(title: "Confronto tra Insertion Sort e Selection Sort")[
  - L'Insertion Sort ha complessità $Theta(n)$ nel caso ottimo (array ordinato) e $Theta(n^2)$ nel caso pessimo.
  - Il Selection Sort ha complessità $Theta(n^2)$ in tutti i casi.
  - L'Insertion Sort è quindi preferibile quando l'input può essere parzialmente ordinato.
  - Il Selection Sort ha il vantaggio di eseguire al più $n - 1$ scambi (utile quando le operazioni di scrittura sono costose).
]

#note(title: "Stabilità degli algoritmi di ordinamento")[
  Un algoritmo di ordinamento si dice *stabile* se preserva l'ordine relativo degli elementi con la stessa chiave.

  - *Insertion Sort è stabile*: il ciclo interno si arresta quando incontra un elemento $<= k$ (la condizione è $A[i] > k$, strettamente maggiore). Pertanto, elementi uguali alla chiave non vengono spostati e mantengono la loro posizione relativa originale.
  - *Selection Sort non è stabile*: lo scambio tra $A[i]$ e $A["min"]$ può alterare l'ordine relativo di elementi uguali. Ad esempio, con $A = [2_a, 2_b, 1]$, alla prima iterazione si scambia $2_a$ con $1$, ottenendo $[1, 2_b, 2_a]$: l'ordine relativo di $2_a$ e $2_b$ è invertito.
]

== Invariante di ciclo: schema generale

La tecnica dell'invariante di ciclo è uno strumento fondamentale per dimostrare la *correttezza* degli algoritmi iterativi. Formalizziamo la sua struttura.

#definition(title: "Invariante di ciclo")[
  Un *invariante di ciclo* è una proprietà logica $P$ tale che:
  + *Inizializzazione*: $P$ è vera prima della prima iterazione del ciclo.
  + *Mantenimento*: se $P$ è vera all'inizio di un'iterazione, allora è vera anche all'inizio dell'iterazione successiva.
  + *Terminazione*: quando il ciclo termina, l'invariante $P$, combinata con la condizione di uscita dal ciclo, implica la correttezza dell'algoritmo.
]

#note(title: "Analogia con l'induzione matematica")[
  La struttura della dimostrazione con invariante di ciclo ricalca il *principio di induzione*:
  - L'inizializzazione corrisponde al *caso base*.
  - Il mantenimento corrisponde al *passo induttivo*.
  - La terminazione sfrutta il fatto che il ciclo ha un numero finito di iterazioni (analogamente alla buona fondatezza dell'induzione sui naturali).
]

#note(title: "Schema pratico per le dimostrazioni")[
  Per dimostrare la correttezza di un algoritmo iterativo con invariante di ciclo:
  + *Identificare l'invariante*: determinare quale proprietà rimane vera ad ogni iterazione.
  + *Inizializzazione*: verificare che l'invariante valga prima della prima iterazione.
  + *Mantenimento*: assumere che l'invariante valga all'iterazione $k$ e dimostrare che vale per $k+1$.
  + *Terminazione*: combinare l'invariante con la condizione di uscita dal ciclo per dedurre la correttezza del risultato.
]
