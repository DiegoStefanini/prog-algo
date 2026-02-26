// ============================================================
// CHEAT SHEET — Programmazione ed Algoritmica
// 3ª Prova in Itinere — 13 marzo 2026
// ============================================================

#set page(
  paper: "a4",
  margin: (x: 1cm, y: 1cm),
  columns: 2,
)

#set text(font: "New Computer Modern", size: 8pt)
#set par(justify: true, leading: 0.4em, spacing: 0.5em)

#show heading.where(level: 1): it => {
  set text(size: 10pt, weight: "bold")
  block(
    width: 100%,
    stroke: (bottom: 1pt + black),
    inset: (bottom: 2pt),
    above: 8pt,
    below: 4pt,
  )[#it.body]
}

#show heading.where(level: 2): it => {
  set text(size: 8.5pt, weight: "bold")
  block(above: 5pt, below: 2pt)[#it.body]
}

#show heading.where(level: 3): it => {
  set text(size: 8pt, weight: "bold", style: "italic")
  block(above: 4pt, below: 1pt)[#it.body]
}

#let box-rule(body) = block(
  width: 100%,
  stroke: 0.5pt + black,
  inset: 4pt,
  radius: 2pt,
  above: 3pt,
  below: 3pt,
  body
)

#let kw(body) = text(weight: "bold")[#body]
#let alg(body) = text(font: "New Computer Modern", size: 7pt)[#raw(body)]

// ============================================================
// INTESTAZIONE
// ============================================================

#align(center)[
  #text(size: 11pt, weight: "bold")[Cheat Sheet — Programmazione ed Algoritmica]
  #linebreak()
  #text(size: 8pt, fill: gray)[3ª Prova in Itinere · 13 marzo 2026 · Diego Stefanini]
]

#v(4pt)
#line(length: 100%, stroke: 0.5pt + black)
#v(2pt)

// ============================================================
// SEZIONE 1: HEAP E HEAPSORT
// ============================================================

= Heap e HeapSort

== Definizioni

#kw[Heap binario:] albero binario *quasi completo* (tutti i livelli pieni tranne l'ultimo, riempito da sx a dx) con proprietà di heap:
- *Max-Heap:* $A["Parent"(i)] >= A[i]$ per ogni nodo $i$
- *Min-Heap:* $A["Parent"(i)] <= A[i]$ per ogni nodo $i$

#box-rule[
  *Proprietà strutturali (max-heap $A[1..n]$):*
  - Massimo in $A[1]$
  - Altezza: $h = floor(log_2 n) = Theta(log n)$
  - Foglie: posizioni $floor(n\/2)+1, ..., n$
  - Nodi ad altezza $h'$: al più $ceil(n \/ 2^(h'+1))$
]

== Rappresentazione come array

Radice in $A[1]$. Per il nodo in posizione $i$:
$ "Parent"(i) = floor(i / 2) quad "Left"(i) = 2i quad "Right"(i) = 2i + 1 $

Attributi: $A."length"$ (dimensione array), $A."heap-size"$ (elementi validi dell'heap).

== Max-Heapify — $O(log n)$

Ripristina proprietà max-heap nel sottoalbero radicato in $i$, assumendo che i sottoalberi figli siano già max-heap. Confronta $A[i]$ con i figli, scambia col maggiore, ricorre verso il basso (_sift-down_).

#alg("maxHeapify(A, i, heapsize):
  l = left(i), r = right(i), largest = i
  if l <= heapsize && A[l] > A[i]: largest = l
  if r <= heapsize && A[r] > A[largest]: largest = r
  if largest != i:
    swap(A[i], A[largest])
    maxHeapify(A, largest, heapsize)")

*Complessità:* $O(h)$ dove $h$ è altezza del nodo. Ricorrenza: $T(n) <= T(2n\/3) + Theta(1) => O(log n)$.

*Correttezza:* induzione sull'altezza $h$. Base ($h=0$): foglia, nulla da fare. Passo: se $"largest" = i$ ok; altrimenti dopo lo scambio il sottoalbero violante ha altezza $h-1$, per ipotesi induttiva la ricorsione corregge.

== Build-Max-Heap — $Theta(n)$

Trasforma array arbitrario in max-heap. Applica Max-Heapify dal basso verso l'alto, partendo da $floor(n\/2)$ (le foglie sono già heap banali).

#alg("buildMaxHeap(A, n):
  heapsize = n
  for i = n/2 downto 1:
    maxHeapify(A, i, heapsize)")

*Invariante:* all'inizio di ogni iterazione, ogni nodo $j in {i+1, ..., n}$ è radice di un max-heap.

#box-rule[
  *Analisi complessità:*
  - Ingenua: $O(n) times O(log n) = O(n log n)$ (non stretta)
  - Stretta: $sum_(h'=0)^(floor(log n)) ceil(n\/2^(h'+1)) dot O(h') = O(n sum h'\/2^(h')) = O(2n) = Theta(n)$
  - Intuizione: la maggior parte dei nodi ha altezza piccola ($n\/2$ foglie, $n\/4$ altezza 1, ...)
]

== HeapSort — $Theta(n log n)$

+ `buildMaxHeap(A, n)` — massimo in $A[1]$
+ Scambia $A[1]$ con $A["heapsize"]$, decrementa heapsize
+ `maxHeapify(A, 1, heapsize)` per ripristinare
+ Ripeti finché heapsize $= 1$

#alg("heapsort(A, n):
  buildMaxHeap(A, n)
  heapsize = n
  for i = n downto 2:
    swap(A[1], A[i])
    heapsize = heapsize - 1
    maxHeapify(A, 1, heapsize)")

*Invariante:* all'inizio di ogni iterazione: $A[1..i]$ è max-heap con gli $i$ elementi più piccoli; $A[i+1..n]$ contiene gli $n-i$ più grandi, ordinati.

#box-rule[
  *Complessità:* $Theta(n) + (n-1) dot O(log n) = Theta(n log n)$ (pessimo, ottimo, medio)\
  *In-place:* sì (memoria $O(1)$ extra) · *Stabile:* no
]

== Code di priorità (max)

Operazioni: `Maximum`, `Extract-Max`, `Increase-Key`, `Insert`.

#box-rule[
  *Complessità con max-heap:*
  #table(
    columns: 2, align: (left, center), stroke: none,
    [`Maximum(A)`], [$O(1)$ — restituisce $A[1]$],
    [`ExtractMax(A)`], [$O(log n)$ — swap $A[1] arrow.l.r A[n]$, heapify],
    [`IncreaseKey(A,i,k)`], [$O(log n)$ — sift-up],
    [`Insert(A,k)`], [$O(log n)$ — aggiungi $-infinity$, increase-key],
  )
]

*Extract-Max:* salva $A[1]$, poni $A[1] := A["heapsize"]$, decrementa heapsize, `maxHeapify(A, 1, heapsize)`.

*Increase-Key (sift-up):* poni $A[i] := k$, risali scambiando con il padre finché $A["Parent"(i)] >= A[i]$.

#alg("heapIncreaseKey(A, i, key):
  A[i] = key
  while i > 1 && A[parent(i)] < A[i]:
    swap(A[i], A[parent(i)])
    i = parent(i)")

*Invariante Increase-Key:* l'array soddisfa la proprietà max-heap con al più una violazione in $(A[i], A["Parent"(i)])$.

*Insert:* $"heapsize" := "heapsize" + 1$, $A["heapsize"] := -infinity$, `heapIncreaseKey(A, heapsize, key)`.

// ============================================================
// SEZIONE 2: LISTE, PILE, CODE, ALBERI BINARI
// ============================================================

= Liste, Pile, Code, Alberi Binari

== Array

Memorizzazione contigua, accesso diretto per indice in $O(1)$.
$ "indirizzo"(A[i]) = "indirizzo"(A[1]) + (i-1) dot "dim. elemento" $

#box-rule[
  #table(
    columns: 2, align: (left, center), stroke: none,
    [`Access(A,i)`], [$O(1)$],
    [`Search(A,x)`], [$O(n)$ — scansione lineare],
    [`Insert(A,i,x)`], [$O(n)$ — shift elementi a dx],
    [`Delete(A,i)`], [$O(n)$ — shift elementi a sx],
  )
  Insert in coda: $O(1)$ se c'è spazio.
]

== Liste concatenate

Nodi collegati da puntatori, non contigui in memoria.
- *Semplice:* `key`, `next` · *Doppia:* `key`, `next`, `prev`

=== Operazioni (lista doppia con `L.head`)

*Ricerca* — $O(n)$: scorri da `L.head` fino a trovare chiave $k$ o `NIL`.

#alg("listSearch(L, k):
  x = L.head
  while x != NIL && x.key != k:
    x = x.next
  return x")

*Inserimento in testa* — $O(1)$:
#alg("listInsert(L, x):
  x.next = L.head
  if L.head != NIL: L.head.prev = x
  L.head = x; x.prev = NIL")

*Cancellazione (dato il puntatore)* — $O(1)$:
#alg("listDelete(L, x):
  if x.prev != NIL: x.prev.next = x.next
  else: L.head = x.next
  if x.next != NIL: x.next.prev = x.prev")

=== Varianti
- *Circolare:* ultimo nodo punta al primo
- *Con sentinella* (`L.nil`): nodo fittizio, elimina tutti i casi limite. `L.nil.next` = testa, `L.nil.prev` = coda. Lista vuota: `L.nil.next == L.nil`.

Con sentinella, cancellazione diventa solo: `x.prev.next = x.next; x.next.prev = x.prev`

#box-rule[
  *Array vs Lista:*
  #table(
    columns: 3, align: (left, center, center), stroke: none,
    [*Operazione*], [*Array*], [*Lista*],
    [Accesso indice], [$O(1)$], [$O(n)$],
    [Ricerca], [$O(n)$], [$O(n)$],
    [Insert in testa], [$O(n)$], [$O(1)$],
    [Delete (dato ptr)], [$O(n)$], [$O(1)$],
    [Località cache], [Alta], [Scarsa],
  )
]

== Pile (Stack) — LIFO

Ultimo inserito, primo rimosso. Operazioni su *cima* (top).

#box-rule[
  `Push(S,x)` $O(1)$ · `Pop(S)` $O(1)$ · `Top(S)` $O(1)$ · `IsEmpty(S)` $O(1)$
]

*Su array* $S[1..n]$ con `S.top` (vuota se `S.top == 0`):

#alg("push(S, x):
  S.top = S.top + 1; S[S.top] = x
pop(S):
  S.top = S.top - 1; return S[S.top + 1]")

*Su lista:* Push = insert in testa, Pop = delete in testa.

*Applicazioni:* call stack, backtracking, bilanciamento parentesi, undo/redo, valutazione espressioni postfisse.

== Code (Queue) — FIFO

Primo inserito, primo rimosso. Enqueue in coda, Dequeue in testa.

#box-rule[
  `Enqueue(Q,x)` $O(1)$ · `Dequeue(Q)` $O(1)$ · `Front(Q)` $O(1)$ · `IsEmpty(Q)` $O(1)$
]

*Array circolare* $Q[1..n]$ con `Q.head`, `Q.tail`:
- Vuota: `Q.head == Q.tail`
- Piena: `(Q.tail mod n) + 1 == Q.head`
- Capacità effettiva: $n-1$ (una cella sacrificata per distinguere vuota/piena)
- Avanzamento: $i := (i mod n) + 1$

#alg("enqueue(Q, x):
  Q[Q.tail] = x
  Q.tail = (Q.tail mod Q.length) + 1
dequeue(Q):
  x = Q[Q.head]
  Q.head = (Q.head mod Q.length) + 1
  return x")

*Applicazioni:* scheduling round-robin, buffer I/O, BFS, gestione richieste.

== Deque (Double-Ended Queue)

Generalizza pila e coda: inserimenti e rimozioni da *entrambe* le estremità. Tutte le operazioni $O(1)$.

== Alberi binari — Definizioni

*Albero binario:* vuoto ($"NIL"$) oppure nodo con `key`, `left`, `right`, `parent`.

*Terminologia:*
- *Radice:* nodo senza padre ($T."root"$)
- *Foglia:* nodo con entrambi i figli $= "NIL"$
- *Profondità:* \#archi dalla radice al nodo
- *Altezza nodo:* \#archi nel cammino più lungo verso una foglia
- *Altezza albero:* altezza della radice

#box-rule[
  *Proprietà:* albero binario di altezza $h$:
  - Max nodi: $2^(h+1) - 1$ · Max foglie: $2^h$
  - Se $n$ nodi: $h >= ceil(log_2(n+1)) - 1$
  - *Completo:* $2^(h+1)-1$ nodi · *Degenere:* $h+1$ nodi (= lista)
]

*Figlio sx - Fratello dx:* rappresenta alberi con \#figli arbitrario usando 2 puntatori: `left-child` (primo figlio), `right-sibling` (fratello destro).

== Visite — $Theta(n)$

*Inorder* (sx, radice, dx): $T(n) = T(k) + T(n-k-1) + d = Theta(n)$

#alg("inorderTreeWalk(x):
  if x != NIL:
    inorderTreeWalk(x.left)
    visita(x)
    inorderTreeWalk(x.right)")

*Preorder* (radice, sx, dx) · *Postorder* (sx, dx, radice): stessa struttura, cambia posizione di `visita(x)`.

// ============================================================
// SEZIONE 3: DIZIONARI — ABR E TABELLE HASH
// ============================================================

= Dizionari: ABR e Tabelle Hash

== Insieme dinamico e Dizionario

*Insieme dinamico:* collezione modificabile con operazioni Search, Min, Max, Successor, Predecessor, Insert, Delete.

*Dizionario:* ADT con Search, Insert, Delete. Se supporta anche Min/Max/Succ/Pred: *dizionario ordinato*.

== ABR (Albero Binario di Ricerca)

#box-rule[
  *Proprietà BST:* per ogni nodo $x$:
  - ogni $y$ nel sottoalbero sx: $y."key" < x."key"$
  - ogni $y$ nel sottoalbero dx: $y."key" >= x."key"$

  Proprietà *globale*, non solo rispetto ai figli diretti.
]

*Visita inorder di un BST* $arrow.r$ chiavi in ordine non decrescente.

=== Operazioni — tutte $O(h)$

*Ricerca:*
#alg("treeSearch(x, k):
  while x != NIL && k != x.key:
    if k < x.key: x = x.left
    else: x = x.right
  return x")

*Minimo / Massimo:*
#alg("treeMinimum(x):          treeMaximum(x):
  while x.left != NIL:      while x.right != NIL:
    x = x.left                 x = x.right
  return x                   return x")

*Successore:* (1) se $x$ ha figlio dx: minimo del sottoalbero dx. (2) altrimenti: risali finché non sei un figlio sx.

#alg("treeSuccessor(x):
  if x.right != NIL: return treeMinimum(x.right)
  y = x.parent
  while y != NIL && x == y.right:
    x = y; y = y.parent
  return y")

*Predecessore:* simmetrico (massimo sottoalbero sx, oppure risali finché sei figlio dx).

=== Inserimento — $O(h)$

Scendi dalla radice confrontando le chiavi. Il trailing pointer $y$ tiene traccia del padre. Il nuovo nodo diventa foglia.

#alg("treeInsert(T, z):
  y = NIL; x = T.root
  while x != NIL:
    y = x
    if z.key < x.key: x = x.left
    else: x = x.right
  z.parent = y
  if y == NIL: T.root = z
  elif z.key < y.key: y.left = z
  else: y.right = z
  z.left = NIL; z.right = NIL")

=== Cancellazione — $O(h)$

Tre casi:
+ *$z$ foglia:* rimuovi aggiornando puntatore del padre
+ *$z$ ha 1 figlio:* collega figlio direttamente al padre di $z$
+ *$z$ ha 2 figli:* sostituisci $z$ con il suo successore $y$ (minimo sottoalbero dx, che non ha figlio sx)

*Transplant* (ausiliaria): sostituisce sottoalbero radicato in $u$ con sottoalbero radicato in $v$.

#alg("transplant(T, u, v):
  if u.parent == NIL: T.root = v
  elif u == u.parent.left: u.parent.left = v
  else: u.parent.right = v
  if v != NIL: v.parent = u.parent")

#alg("treeDelete(T, z):
  if z.left == NIL: transplant(T, z, z.right)
  elif z.right == NIL: transplant(T, z, z.left)
  else:
    y = treeMinimum(z.right)  // successore
    if y.parent != z:
      transplant(T, y, y.right)
      y.right = z.right; y.right.parent = y
    transplant(T, z, y)
    y.left = z.left; y.left.parent = y")

=== Complessità BST

#box-rule[
  #table(
    columns: 3, align: (left, center, center), stroke: none,
    [*Caso*], [*Altezza $h$*], [*Operazioni*],
    [Peggiore (degenere)], [$n - 1$], [$O(n)$],
    [Migliore (bilanciato)], [$Theta(log n)$], [$O(log n)$],
    [Medio (casuale)], [$O(log n)$], [$O(log n)$],
  )
  Per $O(log n)$ garantito nel caso pessimo: AVL, Red-Black Tree (rotazioni).
]

== Tabelle Hash

=== Indirizzamento diretto

Universo $U = {0, ..., m-1}$ piccolo $arrow.r$ array $T[0..m-1]$ dove $T[k]$ contiene l'elemento con chiave $k$.

Search, Insert, Delete: tutte $O(1)$. Spazio: $O(|U|)$ (sprecato se $n << |U|$).

=== Tavola hash con concatenamento

*Funzione hash:* $h: U arrow.r {0, ..., m-1}$, con $m << |U|$.

*Collisione:* $k_1 eq.not k_2$ ma $h(k_1) = h(k_2)$ (inevitabile se $|U| > m$).

*Concatenamento:* ogni cella $T[j]$ contiene una lista concatenata di tutti gli elementi con hash $j$.

- *Insert:* in testa alla lista $T[h(k)]$ — $O(1)$
- *Search:* scansione della lista $T[h(k)]$
- *Delete:* rimuovi dalla lista (con lista doppia: $O(1)$)

=== Analisi

#box-rule[
  *Fattore di carico:* $alpha = n\/m$ (media elementi per cella)

  *Ipotesi hashing uniforme semplice:* ogni chiave ha uguale probabilità di essere mappata in ciascuna delle $m$ celle.

  *Caso pessimo:* tutte le $n$ chiavi nella stessa cella $arrow.r Theta(n)$

  *Caso medio (hashing uniforme):*
  - Ricerca senza successo: $Theta(1 + alpha)$
  - Ricerca con successo: $Theta(1 + alpha)$

  Se $n = O(m)$ allora $alpha = O(1)$ e tutte le operazioni sono $O(1)$ in media.
]

=== Metodo della divisione

$ h(k) = k mod m $

*Scelta di $m$:*
- *Evitare* $m = 2^p$: hash dipende solo dagli ultimi $p$ bit
- *Evitare* $m = 2^p - 1$: permutazioni di stringhe danno stesso hash
- *Buona scelta:* numero primo non vicino a potenze di 2

Chiavi non numeriche $arrow.r$ convertire in $NN$ (es. stringa in base 128 tramite codici ASCII).

=== Confronto realizzazioni di dizionario

#box-rule[
  #table(
    columns: 4, align: (left, center, center, center), stroke: none,
    [*Op.*], [*Indir. dir.*], [*Hash (medio)*], [*ABR (caso peg.)*],
    [Search], [$O(1)$], [$O(1+alpha)$], [$O(h)$],
    [Insert], [$O(1)$], [$O(1)$], [$O(h)$],
    [Delete], [$O(1)$], [$O(1)$], [$O(h)$],
    [Min/Max], [$O(m)$], [---], [$O(h)$],
    [Succ/Pred], [$O(m)$], [---], [$O(h)$],
    [Spazio], [$O(|U|)$], [$O(m+n)$], [$O(n)$],
  )
  Hash: migliore per Search/Insert/Delete, ma no Min/Max/Succ/Pred.\
  ABR: migliore per dizionario *ordinato*.
]

// ============================================================
// SEZIONE 4: PROBLEM SOLVING SU ALBERI E ARRAY
// ============================================================

= Problem Solving: Alberi e Array

== Pattern ricorsivi su alberi binari

Struttura base: se nodo è NIL $arrow.r$ caso base; altrimenti elabora ricorsivamente figli e combina risultati.

=== Altezza di un albero

#alg("int treeHeight(Node x):
  if x == NIL: return -1
  lh = treeHeight(x.left)
  rh = treeHeight(x.right)
  return 1 + max(lh, rh)")

Complessità: $Theta(n)$ — visita ogni nodo una volta.

=== Contare i nodi

#alg("int countNodes(Node x):
  if x == NIL: return 0
  return 1 + countNodes(x.left) + countNodes(x.right)")

=== Contare le foglie

#alg("int countLeaves(Node x):
  if x == NIL: return 0
  if x.left == NIL && x.right == NIL: return 1
  return countLeaves(x.left) + countLeaves(x.right)")

=== Verifica proprietà BST

Non basta confrontare con i figli diretti: servono limiti globali.

#alg("bool isBST(Node x, int min, int max):
  if x == NIL: return true
  if x.key < min || x.key > max: return false
  return isBST(x.left, min, x.key - 1)
      && isBST(x.right, x.key, max)")

Chiamata iniziale: `isBST(T.root, -∞, +∞)`. Complessità: $O(n)$.

== Pattern su array

=== Ricerca lineare e sentinella

Ricerca base: $O(n)$. Con sentinella ($A[n+1] := k$) si elimina il controllo sul bound, riducendo il fattore costante.

=== Due puntatori (two pointers)

Utile per array ordinati o per trovare coppie con proprietà.

#alg("// Coppia con somma target in array ordinato
bool twoSum(int[] A, int n, int target):
  i = 1; j = n
  while i < j:
    s = A[i] + A[j]
    if s == target: return true
    elif s < target: i = i + 1
    else: j = j - 1
  return false")

Complessità: $O(n)$.

=== Ricerca binaria — $O(log n)$

Prerequisito: array ordinato. Dimezza lo spazio di ricerca ad ogni passo.

#alg("int binarySearch(int[] A, int lo, int hi, int k):
  while lo <= hi:
    mid = (lo + hi) / 2
    if A[mid] == k: return mid
    elif A[mid] < k: lo = mid + 1
    else: hi = mid - 1
  return -1  // non trovato")

Ricorrenza: $T(n) = T(n\/2) + O(1) = O(log n)$.

== Complessità algoritmi ricorsivi

=== Master Theorem

Per ricorrenze $T(n) = a T(n\/b) + f(n)$ con $a >= 1, b > 1$:

#box-rule[
  Sia $c_"crit" = log_b a$:
  + Se $f(n) = O(n^(c_"crit" - epsilon))$ per $epsilon > 0$: $T(n) = Theta(n^(c_"crit"))$
  + Se $f(n) = Theta(n^(c_"crit"))$: $T(n) = Theta(n^(c_"crit") log n)$
  + Se $f(n) = Omega(n^(c_"crit" + epsilon))$ e $a f(n\/b) <= c f(n)$: $T(n) = Theta(f(n))$
]

*Esempi:*
- $T(n) = 2T(n\/2) + Theta(n)$: caso 2, $c_"crit" = 1$ $arrow.r Theta(n log n)$ (MergeSort)
- $T(n) = T(n\/2) + Theta(1)$: caso 2, $c_"crit" = 0$ $arrow.r Theta(log n)$ (Ricerca binaria)
- $T(n) = 2T(n\/2) + Theta(1)$: caso 1, $c_"crit" = 1$ $arrow.r Theta(n)$
- $T(n) = 4T(n\/2) + Theta(n)$: caso 1, $c_"crit" = 2$ $arrow.r Theta(n^2)$

=== Albero di ricorsione (metodo iterativo)

Espandere la ricorrenza fino al caso base, sommare i costi per livello. Utile quando il Master Theorem non si applica.

== Strategie generali

#box-rule[
  + *Identifica la ricorrenza:* numero chiamate ricorsive ($a$), dimensione sottoproblemi ($n\/b$), costo combinazione ($f(n)$)
  + *Per alberi:* pensa alla struttura ricorsiva — caso base (NIL/foglia), combina risultati figli
  + *Per array:* considera approcci in-place (due puntatori, partizione), oppure divide-et-impera
  + *Verifica correttezza:* invariante di ciclo (inizializzazione, mantenimento, terminazione) o induzione
  + *Complessità:* Master Theorem per D&I, somma costi per iterativi
]
