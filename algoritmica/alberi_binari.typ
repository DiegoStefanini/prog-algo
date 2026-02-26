#import "../template.typ": *

== Insiemi dinamici e Dizionari

Molti algoritmi richiedono la capacità di memorizzare un insieme di dati che viene modificato nel tempo: si inseriscono nuovi elementi, se ne cancellano altri, si effettuano ricerche. Un tale insieme prende il nome di *insieme dinamico*.

#definition(title: "Insieme dinamico")[
  Un *insieme dinamico* è una struttura dati che mantiene un insieme $S$ di elementi, ciascuno identificato da una *chiave*, e supporta operazioni di modifica e di interrogazione. Le operazioni fondamentali sono:
  - *Operazioni di ricerca* (query):
    - `Search(S, k)`: dato un insieme $S$ e una chiave $k$, restituisce un puntatore $x$ a un elemento in $S$ tale che $x."key" = k$, oppure $"NIL"$ se tale elemento non esiste
    - `Minimum(S)`: restituisce l'elemento di $S$ con la chiave più piccola
    - `Maximum(S)`: restituisce l'elemento di $S$ con la chiave più grande
    - `Successor(S, x)`: restituisce l'elemento di $S$ con la più piccola chiave maggiore di $x."key"$, oppure $"NIL"$ se $x$ ha la chiave massima
    - `Predecessor(S, x)`: restituisce l'elemento di $S$ con la più grande chiave minore di $x."key"$, oppure $"NIL"$ se $x$ ha la chiave minima
  - *Operazioni di modifica*:
    - `Insert(S, x)`: aggiunge l'elemento $x$ all'insieme $S$
    - `Delete(S, x)`: rimuove l'elemento $x$ dall'insieme $S$
]

#definition(title: "Dizionario")[
  Un *dizionario* è un tipo di dato astratto (ADT) che supporta le operazioni `Search`, `Insert` e `Delete`. Quando un insieme dinamico supporta anche `Minimum`, `Maximum`, `Successor` e `Predecessor`, si parla spesso di *dizionario ordinato*.
]

#observation[
  La scelta della struttura dati concreta per implementare un dizionario ha un impatto diretto sulle prestazioni: ad esempio, una lista concatenata non ordinata permette inserimento in $O(1)$ ma ricerca in $O(n)$, mentre un albero binario di ricerca bilanciato garantisce tutte le operazioni in $O(log n)$. La scelta migliore dipende dalla frequenza relativa delle diverse operazioni.
]

== Alberi Binari

=== Definizione e terminologia

#definition(title: "Albero binario")[
  Un *albero binario* è una struttura dati definita ricorsivamente come:
  - l'*albero vuoto* (indicato con $"NIL"$), oppure
  - un *nodo* $x$ che contiene una chiave $x."key"$ e due puntatori a sottoalberi binari: il *figlio sinistro* $x."left"$ e il *figlio destro* $x."right"$.
]

#definition(title: "Terminologia")[
  Dato un albero binario $T$:
  - *Radice*: l'unico nodo senza padre, indicato con $T."root"$
  - *Foglia*: un nodo con entrambi i figli uguali a $"NIL"$
  - *Nodo interno*: un nodo con almeno un figlio diverso da $"NIL"$
  - *Profondità* di un nodo: il numero di archi dal nodo alla radice (la radice ha profondità 0)
  - *Altezza* di un nodo: il numero di archi nel cammino più lungo dal nodo a una foglia
  - *Altezza dell'albero*: l'altezza della radice, indicata con $h$
  - *Livello* $k$: l'insieme dei nodi a profondità $k$
  - *Padre* di un nodo $x$: il nodo $y$ tale che $y."left" = x$ oppure $y."right" = x$
]

=== Rappresentazione di un nodo

Ogni nodo di un albero binario contiene:
- `key`: il dato memorizzato
- `left`: puntatore al figlio sinistro (oppure $"NIL"$)
- `right`: puntatore al figlio destro (oppure $"NIL"$)
- `parent`: puntatore al nodo padre (oppure $"NIL"$ per la radice)

#algorithm(title: "Struttura Nodo")[
  ```
  // Struttura Nodo (albero binario)
  // key    : dato
  // left   : puntatore al figlio sinistro
  // right  : puntatore al figlio destro
  // parent : puntatore al padre
  ```
]

=== Rappresentazione di alberi con numero arbitrario di figli

Negli alberi binari ogni nodo ha al più due figli, ma in molte applicazioni occorre rappresentare alberi in cui ogni nodo può avere un numero arbitrario di figli ($k$-ari o generici). Una soluzione diretta richiederebbe di memorizzare in ogni nodo un array di puntatori ai figli, ma questo è inefficiente se il numero di figli varia molto da nodo a nodo.

#definition(title: "Rappresentazione figlio sinistro - fratello destro")[
  La rappresentazione *figlio sinistro - fratello destro* (left-child, right-sibling) consente di rappresentare un albero con numero arbitrario di figli utilizzando solo due puntatori per nodo:
  - `left-child`: puntatore al *primo figlio* (il figlio più a sinistra) del nodo
  - `right-sibling`: puntatore al *fratello destro* del nodo, cioè il nodo immediatamente a destra con lo stesso padre
  - `parent`: puntatore al nodo padre (opzionale)

  Se un nodo non ha figli, `left-child` vale $"NIL"$. Se un nodo è l'ultimo figlio del padre, `right-sibling` vale $"NIL"$.
]

#example(title: "Albero generico e rappresentazione figlio-fratello")[
  Consideriamo un albero in cui la radice $A$ ha tre figli $B, C, D$; il nodo $B$ ha due figli $E, F$; il nodo $D$ ha un figlio $G$.

  L'albero originale (a sinistra) e la sua rappresentazione figlio-fratello come albero binario (a destra):

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align(center)[
      _Albero originale_
      #albero-binario(
        (("A", 0, 0), ("B", -1.5, -1.3), ("C", 0, -1.3), ("D", 1.5, -1.3), ("E", -2.2, -2.6), ("F", -0.8, -2.6), ("G", 1.5, -2.6)),
        ((0, 1), (0, 2), (0, 3), (1, 4), (1, 5), (3, 6)),
      )
    ],
    align(center)[
      _Figlio sx - Fratello dx_
      #albero-binario(
        (("A", 0, 0), ("B", -1.2, -1.3), ("E", -2.2, -2.6), ("C", 0.2, -2.6), ("F", -1.2, -3.9), ("D", 1.6, -3.9), ("G", 0.6, -5.2)),
        ((0, 1), (1, 2), (1, 3), (2, 4), (3, 5), (5, 6)),
      )
    ],
  )

  Nella rappresentazione figlio sinistro - fratello destro:
  - $A$: `left-child` $= B$, `right-sibling` $= "NIL"$
  - $B$: `left-child` $= E$, `right-sibling` $= C$
  - $C$: `left-child` $= "NIL"$, `right-sibling` $= D$
  - $D$: `left-child` $= G$, `right-sibling` $= "NIL"$
  - $E$: `left-child` $= "NIL"$, `right-sibling` $= F$
  - $F$: `left-child` $= "NIL"$, `right-sibling` $= "NIL"$
  - $G$: `left-child` $= "NIL"$, `right-sibling` $= "NIL"$
]

#observation[
  Questa rappresentazione è particolarmente efficiente perché utilizza $O(n)$ spazio totale (due puntatori per nodo), indipendentemente dal grado massimo dell'albero. In pratica, trasforma un albero generico in un albero binario dove il figlio sinistro corrisponde al primo figlio e il figlio destro corrisponde al fratello successivo.
]

=== Proprietà degli alberi binari

#theorem(title: "Relazione nodi-altezza")[
  Sia $T$ un albero binario di altezza $h$. Allora:
  - $T$ ha al massimo $2^(h+1) - 1$ nodi
  - $T$ ha al massimo $2^h$ foglie
  - Se $T$ ha $n$ nodi, allora $h >= ceil(log_2(n+1)) - 1$
]

#demonstration[
  Per induzione sull'altezza $h$.

  *Caso base* ($h = 0$): l'albero ha un solo nodo (la radice, che è anche foglia). Si ha $2^(0+1) - 1 = 1$ nodo e $2^0 = 1$ foglia.

  *Passo induttivo*: supponiamo la tesi vera per altezza $h - 1$. Un albero di altezza $h$ ha una radice con due sottoalberi di altezza al più $h - 1$. Per ipotesi induttiva, ciascun sottoalbero ha al più $2^h - 1$ nodi, quindi il totale è al più $1 + 2(2^h - 1) = 2^(h+1) - 1$.

  Per la terza proprietà: da $n <= 2^(h+1) - 1$ si ottiene $h >= ceil(log_2(n+1)) - 1$.
]

#observation[
  Un albero binario *completo* (ogni nodo interno ha esattamente due figli e tutte le foglie sono allo stesso livello) di altezza $h$ ha esattamente $2^(h+1) - 1$ nodi. Un albero binario *degenere* (ogni nodo interno ha esattamente un figlio) di altezza $h$ ha esattamente $h + 1$ nodi ed è equivalente a una lista concatenata.
]

=== Visite di un albero binario

Le visite (o attraversamenti) di un albero binario permettono di esaminare tutti i nodi in un ordine specifico. Le tre visite fondamentali si distinguono per il momento in cui viene visitata la radice rispetto ai sottoalberi.

==== Visita in ordine (inorder)

La visita *inorder* visita prima il sottoalbero sinistro, poi la radice, poi il sottoalbero destro.

#algorithm(title: "inorderTreeWalk")[
  ```
  inorderTreeWalk(Node x){
      if(x != NIL){
          inorderTreeWalk(x.left);
          // visita x (es. stampa x.key)
          inorderTreeWalk(x.right);
      }
  }
  ```
]

==== Visita anticipata (preorder)

La visita *preorder* visita prima la radice, poi il sottoalbero sinistro, poi il destro.

#algorithm(title: "preorderTreeWalk")[
  ```
  preorderTreeWalk(Node x){
      if(x != NIL){
          // visita x (es. stampa x.key)
          preorderTreeWalk(x.left);
          preorderTreeWalk(x.right);
      }
  }
  ```
]

==== Visita posticipata (postorder)

La visita *postorder* visita prima il sottoalbero sinistro, poi il destro, poi la radice.

#algorithm(title: "postorderTreeWalk")[
  ```
  postorderTreeWalk(Node x){
      if(x != NIL){
          postorderTreeWalk(x.left);
          postorderTreeWalk(x.right);
          // visita x (es. stampa x.key)
      }
  }
  ```
]

#example(title: "Visite di un albero")[
  Consideriamo il seguente albero binario:
  #align(center)[
    #text(size: 10pt)[
      ```
              8
            /   \
           3     10
          / \      \
         1   6      14
            / \    /
           4   7  13
      ```
    ]
  ]

  Le tre visite producono:
  - *Inorder*: $1, 3, 4, 6, 7, 8, 10, 13, 14$
  - *Preorder*: $8, 3, 1, 6, 4, 7, 10, 14, 13$
  - *Postorder*: $1, 4, 7, 6, 3, 13, 14, 10, 8$
]

#theorem(title: "Complessità delle visite")[
  Ciascuna delle tre visite di un albero binario con $n$ nodi ha complessità $Theta(n)$.
]

#demonstration[
  Sia $T(n)$ il tempo per visitare un albero con $n$ nodi. Se l'albero è vuoto, $T(0) = c$ per una costante $c > 0$. Altrimenti, se il sottoalbero sinistro ha $k$ nodi e il destro ne ha $n - k - 1$:
  $ T(n) = T(k) + T(n - k - 1) + d $
  dove $d$ è il costo costante per visitare il nodo corrente. Per sostituzione si dimostra che $T(n) = (c + d) n + c = Theta(n)$.
]

== Alberi Binari di Ricerca (BST)

=== Proprietà BST

#definition(title: "Albero binario di ricerca")[
  Un *albero binario di ricerca* (BST, Binary Search Tree) è un albero binario in cui per ogni nodo $x$ vale la seguente proprietà:
  - per ogni nodo $y$ nel sottoalbero sinistro di $x$: $y."key" < x."key"$
  - per ogni nodo $y$ nel sottoalbero destro di $x$: $y."key" >= x."key"$

  In altre parole, le chiavi strettamente minori si trovano nel sottoalbero sinistro, mentre le chiavi uguali o maggiori si trovano nel sottoalbero destro.
]

#note[
  La proprietà BST è una proprietà *globale*: non basta che ogni nodo sia maggiore del figlio sinistro e minore del figlio destro; occorre che la relazione valga rispetto a *tutti* i nodi dei rispettivi sottoalberi.
]

#theorem(title: "Visita inorder e ordinamento")[
  La visita inorder di un BST produce le chiavi in ordine non decrescente.
]

#demonstration[
  Per induzione sulla struttura dell'albero. Se l'albero è vuoto, la sequenza è vuota (ordinata per definizione). Altrimenti, per ipotesi induttiva, la visita inorder del sottoalbero sinistro produce le chiavi del sottoalbero sinistro in ordine. Per la proprietà BST, tutte queste chiavi sono $< x."key"$. Analogamente, la visita inorder del sottoalbero destro produce chiavi $>= x."key"$ in ordine. La concatenazione (sottoalbero sinistro, radice, sottoalbero destro) è dunque ordinata.
]

=== Operazioni fondamentali

Tutte le operazioni fondamentali su un BST hanno complessità $O(h)$, dove $h$ è l'altezza dell'albero.

==== Ricerca

#definition(title: "Ricerca in un BST")[
  Data una chiave $k$ e un BST $T$, l'operazione `Search(T, k)` restituisce un puntatore al nodo con chiave $k$, oppure $"NIL"$ se la chiave non è presente.
]

*Versione ricorsiva:*
#algorithm(title: "treeSearch")[
  ```
  Node treeSearch(Node x, int k){
      if((x == NIL) || (k == x.key)){
          return x;
      }
      if(k < x.key){
          return treeSearch(x.left, k);
      } else {
          return treeSearch(x.right, k);
      }
  }
  ```
]

*Versione iterativa:*
#algorithm(title: "iterativeTreeSearch")[
  ```
  Node iterativeTreeSearch(Node x, int k){
      while((x != NIL) && (k != x.key)){
          if(k < x.key){
              x := x.left;
          } else {
              x := x.right;
          }
      }
      return x;
  }
  ```
]

#note[
  La versione iterativa è generalmente preferita perché evita il costo dell'overhead delle chiamate ricorsive ed è più efficiente in termini di spazio (non usa lo stack di ricorsione).
]

*Complessità:* $O(h)$, dove $h$ è l'altezza dell'albero. Ad ogni passo scendiamo di un livello, quindi il numero massimo di confronti è $h + 1$.

==== Minimo e Massimo

#definition(title: "Minimo e Massimo")[
  In un BST, il *minimo* è il nodo raggiunto seguendo sempre il figlio sinistro a partire dalla radice. Il *massimo* è il nodo raggiunto seguendo sempre il figlio destro.
]

#algorithm(title: "treeMinimum / treeMaximum")[
  ```
  Node treeMinimum(Node x){
      while(x.left != NIL){
          x := x.left;
      }
      return x;
  }

  Node treeMaximum(Node x){
      while(x.right != NIL){
          x := x.right;
      }
      return x;
  }
  ```
]

*Complessità:* $O(h)$ per entrambe le operazioni.

#observation[
  La correttezza segue direttamente dalla proprietà BST: tutte le chiavi nel sottoalbero sinistro sono strettamente minori della radice, e tutte le chiavi nel sottoalbero destro sono maggiori o uguali.
]

==== Successore e Predecessore

#definition(title: "Successore")[
  Il *successore* di un nodo $x$ in un BST è il nodo con la più piccola chiave maggiore di $x."key"$, cioè il nodo che segue $x$ nella visita inorder.
]

Si distinguono due casi:
1. Se $x$ ha un figlio destro, il successore è il *minimo del sottoalbero destro*.
2. Se $x$ non ha figlio destro, il successore è il *primo antenato* di $x$ il cui figlio sinistro è anch'esso antenato di $x$ (cioè risaliamo finché non siamo un figlio sinistro).

#algorithm(title: "treeSuccessor")[
  ```
  Node treeSuccessor(Node x){
      if(x.right != NIL){
          return treeMinimum(x.right);
      }
      Node y = x.parent;
      while((y != NIL) && (x == y.right)){
          x := y;
          y := y.parent;
      }
      return y;
  }
  ```
]

*Predecessore:* simmetricamente, il predecessore è il massimo del sottoalbero sinistro (se esiste), altrimenti il primo antenato di cui $x$ è nel sottoalbero destro.

#algorithm(title: "treePredecessor")[
  ```
  Node treePredecessor(Node x){
      if(x.left != NIL){
          return treeMaximum(x.left);
      }
      Node y = x.parent;
      while((y != NIL) && (x == y.left)){
          x := y;
          y := y.parent;
      }
      return y;
  }
  ```
]

*Complessità:* $O(h)$ per entrambe le operazioni, poiché si percorre al più un cammino dalla radice a una foglia.

==== Inserimento

#definition(title: "Inserimento in un BST")[
  L'operazione `Insert(T, z)` inserisce un nuovo nodo $z$ nel BST $T$ mantenendo la proprietà BST. Il nodo viene inserito come *foglia* nella posizione corretta.
]

#algorithm(title: "treeInsert")[
  ```
  treeInsert(Tree T, Node z){
      Node y = NIL;
      Node x = T.root;
      while(x != NIL){
          y := x;
          if(z.key < x.key){
              x := x.left;
          } else {
              x := x.right;
          }
      }
      z.parent := y;
      if(y == NIL){
          T.root := z;         // l'albero era vuoto
      } else {
          if(z.key < y.key){
              y.left := z;
          } else {
              y.right := z;
          }
      }
      z.left := NIL;
      z.right := NIL;
  }
  ```
]

#note[
  La variabile $y$ mantiene il puntatore al *padre* del nodo corrente $x$ (tecnica detta "trailing pointer"). Quando $x$ diventa $"NIL"$, $y$ è il nodo a cui agganciare il nuovo nodo $z$. Si noti che le chiavi uguali vengono inserite nel sottoalbero destro, coerentemente con la proprietà BST adottata.
]

*Complessità:* $O(h)$, poiché scendiamo dalla radice fino a una posizione vuota.

#example(title: "Inserimento in un BST")[
  Inseriamo la chiave $6$ nel seguente BST. L'algoritmo scende dalla radice confrontando $6$ con ogni nodo: $6 < 8$ (sinistra), $6 > 4$ (destra), $6 > 5$ (destra). Il nodo viene inserito come figlio destro di $5$.

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align(center)[
      _Prima_
      #albero-binario(
        (([8], 0, 0), ([4], -1.2, -1.3), ([12], 1.2, -1.3), ([2], -2, -2.6), ([5], -0.4, -2.6), ([10], 0.4, -2.6), ([14], 2, -2.6)),
        ((0, 1), (0, 2), (1, 3), (1, 4), (2, 5), (2, 6)),
      )
    ],
    align(center)[
      _Dopo Insert(T, 6)_
      #albero-binario(
        (([8], 0, 0), ([4], -1.2, -1.3), ([12], 1.2, -1.3), ([2], -2, -2.6), ([5], -0.4, -2.6), ([10], 0.4, -2.6), ([14], 2, -2.6), ([6], 0.4, -3.9)),
        ((0, 1), (0, 2), (1, 3), (1, 4), (2, 5), (2, 6), (4, 7)),
      )
    ],
  )
]

==== Cancellazione

La cancellazione è l'operazione più complessa su un BST. Si distinguono tre casi in base alla struttura del nodo $z$ da eliminare.

#definition(title: "Cancellazione da un BST")[
  L'operazione `Delete(T, z)` rimuove il nodo $z$ dal BST $T$ mantenendo la proprietà BST.
]

*Caso 1 -- $z$ non ha figli (foglia):* si rimuove $z$ semplicemente aggiornando il puntatore del padre.

*Caso 2 -- $z$ ha un solo figlio:* si elimina $z$ e si collega il figlio direttamente al padre di $z$.

*Caso 3 -- $z$ ha due figli:* si sostituisce $z$ con il suo *successore* $y$ (il minimo del sottoalbero destro di $z$). Siccome $y$ non ha figlio sinistro (altrimenti non sarebbe il minimo), si ricade nel Caso 1 o 2 per rimuovere $y$ dalla sua posizione originale.

Per semplificare il codice, definiamo una procedura ausiliaria che sostituisce un sottoalbero con un altro:

#algorithm(title: "transplant")[
  ```
  transplant(Tree T, Node u, Node v){
      if(u.parent == NIL){
          T.root := v;
      } else {
          if(u == u.parent.left){
              u.parent.left := v;
          } else {
              u.parent.right := v;
          }
      }
      if(v != NIL){
          v.parent := u.parent;
      }
  }
  ```
]

Utilizzando `transplant`, la cancellazione è:

#algorithm(title: "treeDelete")[
  ```
  treeDelete(Tree T, Node z){
      if(z.left == NIL){
          // Caso 1 o 2: nessun figlio sinistro
          transplant(T, z, z.right);
      } else {
          if(z.right == NIL){
              // Caso 2: solo figlio sinistro
              transplant(T, z, z.left);
          } else {
              // Caso 3: due figli
              Node y = treeMinimum(z.right);
              if(y.parent != z){
                  transplant(T, y, y.right);
                  y.right := z.right;
                  y.right.parent := y;
              }
              transplant(T, z, y);
              y.left := z.left;
              y.left.parent := y;
          }
      }
  }
  ```
]

*Complessità:* $O(h)$, poiché `treeMinimum` richiede $O(h)$ nel caso peggiore e `transplant` richiede $O(1)$ (solo operazioni di puntatori).

#observation[
  La correttezza della procedura `treeDelete` si basa sul fatto che, nel Caso 3, il successore $y$ di $z$ (il minimo del sottoalbero destro) non ha figlio sinistro. Sostituendo $z$ con $y$ e spostando i sottoalberi in modo appropriato, la proprietà BST è preservata: tutte le chiavi nel nuovo sottoalbero sinistro di $y$ erano nel sottoalbero sinistro di $z$ (dunque minori di $y."key"$), e tutte le chiavi nel nuovo sottoalbero destro di $y$ erano nel sottoalbero destro di $z$ escluso $y$ (dunque maggiori o uguali a $y."key"$).
]

#example(title: "Cancellazione da un BST — Caso 3")[
  Cancelliamo il nodo con chiave $8$ (la radice) dal BST. Poiché $8$ ha due figli, troviamo il suo successore: il minimo del sottoalbero destro è $10$. Sostituiamo $8$ con $10$ e rimuoviamo $10$ dalla posizione originale (Caso 1, foglia).

  #grid(
    columns: (1fr, 1fr),
    column-gutter: 1em,
    align(center)[
      _Prima: Delete(T, 8)_
      #albero-binario(
        (([8], 0, 0), ([4], -1.2, -1.3), ([12], 1.2, -1.3), ([2], -2, -2.6), ([5], -0.4, -2.6), ([10], 0.4, -2.6), ([14], 2, -2.6)),
        ((0, 1), (0, 2), (1, 3), (1, 4), (2, 5), (2, 6)),
      )
    ],
    align(center)[
      _Dopo: 10 sostituisce 8_
      #albero-binario(
        (([10], 0, 0), ([4], -1.2, -1.3), ([12], 1.2, -1.3), ([2], -2, -2.6), ([5], -0.4, -2.6), ([14], 1.2, -2.6)),
        ((0, 1), (0, 2), (1, 3), (1, 4), (2, 5)),
      )
    ],
  )
]

=== Analisi della complessità

Le prestazioni di un BST dipendono criticamente dalla sua altezza $h$.

#theorem(title: "Complessità delle operazioni su BST")[
  Su un albero binario di ricerca di altezza $h$, le operazioni Search, Minimum, Maximum, Successor, Predecessor, Insert e Delete possono essere eseguite ciascuna in tempo $O(h)$.
]

#demonstration[
  Ciascuna delle operazioni di query (Search, Minimum, Maximum, Successor, Predecessor) percorre al più un cammino dalla radice a una foglia oppure da un nodo alla radice, visitando al più $h + 1$ nodi e spendendo tempo $O(1)$ per ciascuno.

  Per Insert: la procedura `treeInsert` scende dalla radice fino a trovare una posizione $"NIL"$ dove agganciare il nuovo nodo, percorrendo al più $h + 1$ nodi.

  Per Delete: la procedura `treeDelete` richiede al più una chiamata a `treeMinimum` (che costa $O(h)$) e un numero costante di operazioni `transplant` (ciascuna in $O(1)$). Il costo totale è $O(h)$.
]

#figure(
  table(
    columns: 3,
    [*Operazione*], [*Complessità*], [*Descrizione*],
    [`Search(T, k)`], [$O(h)$], [Ricerca di una chiave],
    [`Minimum(T)`], [$O(h)$], [Chiave minima],
    [`Maximum(T)`], [$O(h)$], [Chiave massima],
    [`Successor(x)`], [$O(h)$], [Successore di un nodo],
    [`Predecessor(x)`], [$O(h)$], [Predecessore di un nodo],
    [`Insert(T, z)`], [$O(h)$], [Inserimento di un nodo],
    [`Delete(T, z)`], [$O(h)$], [Cancellazione di un nodo],
  ),
  caption: [Complessità delle operazioni su BST in funzione dell'altezza $h$]
)

==== Caso peggiore

Se le chiavi vengono inserite in ordine crescente (o decrescente), il BST degenera in una lista concatenata. In questo caso $h = n - 1$ e tutte le operazioni hanno complessità $O(n)$.

#example(title: "BST degenere")[
  Inserendo le chiavi $1, 2, 3, 4, 5$ in quest'ordine si ottiene:
  #align(center)[
    #text(size: 10pt)[
      ```
      1
       \
        2
         \
          3
           \
            4
             \
              5
      ```
    ]
  ]
  L'altezza è $h = 4 = n - 1$, e la ricerca di $5$ richiede 5 confronti.
]

==== Caso migliore

Se l'albero è *bilanciato* (i sottoalberi sinistro e destro di ogni nodo differiscono in altezza di al più 1), allora $h = Theta(log n)$ e tutte le operazioni hanno complessità $O(log n)$.

==== Caso medio

#theorem(title: "Altezza media di un BST")[
  L'altezza attesa di un BST costruito inserendo $n$ chiavi distinte in ordine casuale uniformemente distribuito è $O(log n)$.
]

#note[
  La dimostrazione completa di questo risultato richiede strumenti probabilistici avanzati. L'idea chiave è che un inserimento casuale produce una struttura analoga a quella del QuickSort randomizzato: la radice partiziona le chiavi e la profondità attesa è logaritmica.
]

Riassumendo:

#figure(
  table(
    columns: 3,
    [*Caso*], [*Altezza $h$*], [*Complessità operazioni*],
    [Peggiore (degenere)], [$n - 1$], [$O(n)$],
    [Migliore (bilanciato)], [$Theta(log n)$], [$O(log n)$],
    [Medio (casuale)], [$O(log n)$], [$O(log n)$],
  ),
  caption: [Altezza e complessità nei diversi casi]
)

=== Esempio completo

Mostriamo passo per passo la costruzione di un BST e le operazioni su di esso.

#example(title: "Costruzione di un BST")[
  Inseriamo le chiavi $8, 3, 10, 1, 6, 14, 4, 7, 13$ in quest'ordine.

  *Passo 1* -- Inserimento di $8$ (radice):
  #align(center)[#text(size: 10pt)[```
    8
  ```]]

  *Passo 2* -- Inserimento di $3$ ($3 < 8$, va a sinistra):
  #align(center)[#text(size: 10pt)[```
      8
     /
    3
  ```]]

  *Passo 3* -- Inserimento di $10$ ($10 >= 8$, va a destra):
  #align(center)[#text(size: 10pt)[```
      8
     / \
    3   10
  ```]]

  *Passo 4* -- Inserimento di $1$ ($1 < 8$, $1 < 3$, va a sinistra di $3$):
  #align(center)[#text(size: 10pt)[```
        8
       / \
      3   10
     /
    1
  ```]]

  *Passo 5* -- Inserimento di $6$ ($6 < 8$, $6 >= 3$, va a destra di $3$):
  #align(center)[#text(size: 10pt)[```
        8
       / \
      3   10
     / \
    1   6
  ```]]

  *Passo 6* -- Inserimento di $14$ ($14 >= 8$, $14 >= 10$, va a destra di $10$):
  #align(center)[#text(size: 10pt)[```
          8
        /   \
       3     10
      / \      \
     1   6      14
  ```]]

  *Passo 7* -- Inserimento di $4$ ($4 < 8$, $4 >= 3$, $4 < 6$, va a sinistra di $6$):
  #align(center)[#text(size: 10pt)[```
          8
        /   \
       3     10
      / \      \
     1   6      14
        /
       4
  ```]]

  *Passo 8* -- Inserimento di $7$ ($7 < 8$, $7 >= 3$, $7 >= 6$, va a destra di $6$):
  #align(center)[#text(size: 10pt)[```
          8
        /   \
       3     10
      / \      \
     1   6      14
        / \
       4   7
  ```]]

  *Passo 9* -- Inserimento di $13$ ($13 >= 8$, $13 >= 10$, $13 < 14$, va a sinistra di $14$):
  #align(center)[#text(size: 10pt)[```
          8
        /   \
       3     10
      / \      \
     1   6      14
        / \    /
       4   7  13
  ```]]
]

#example(title: "Operazioni sul BST")[
  Sull'albero costruito nell'esempio precedente eseguiamo le seguenti operazioni.

  *Ricerca di $6$:* $8 arrow.r 3 arrow.r 6$ (trovato dopo 3 confronti).

  *Ricerca di $5$:* $8 arrow.r 3 arrow.r 6 arrow.r 4 arrow.r "NIL"$ (non trovato, 4 confronti).

  *Minimo:* $8 arrow.r 3 arrow.r 1$ (il minimo è $1$).

  *Massimo:* $8 arrow.r 10 arrow.r 14$ (il massimo è $14$).

  *Successore di $6$:* il nodo $6$ ha un figlio destro ($7$), quindi il successore è il minimo del sottoalbero destro, cioè $7$.

  *Successore di $7$:* il nodo $7$ non ha figlio destro, risaliamo: $7 arrow.r 6$ (eravamo a destra), $6 arrow.r 3$ (eravamo a destra), $3 arrow.r 8$ (eravamo a sinistra, ci fermiamo). Il successore è $8$.

  *Predecessore di $10$:* il nodo $10$ non ha figlio sinistro, risaliamo: $10 arrow.r 8$ (eravamo a destra, ci fermiamo). Il predecessore è $8$.
]

#example(title: "Cancellazione dal BST")[
  Partiamo dall'albero completo e mostriamo i tre casi di cancellazione.

  *Caso 1 -- Cancellazione di $4$ (foglia):* si rimuove il nodo e si imposta il figlio sinistro di $6$ a $"NIL"$.
  #align(center)[#text(size: 10pt)[```
          8
        /   \
       3     10
      / \      \
     1   6      14
          \    /
           7  13
  ```]]

  *Caso 2 -- Cancellazione di $14$ (un solo figlio):* si sostituisce $14$ con il suo unico figlio $13$.
  #align(center)[#text(size: 10pt)[```
          8
        /   \
       3     10
      / \      \
     1   6      13
          \
           7
  ```]]

  *Caso 3 -- Cancellazione di $3$ (due figli):* il successore di $3$ è $6$ (minimo del sottoalbero destro). Si sostituisce $3$ con $6$:
  #align(center)[#text(size: 10pt)[```
          8
        /   \
       6     10
      / \      \
     1   7      13
  ```]]
  La proprietà BST è mantenuta: $1 < 6 < 7 < 8 < 10 < 13$.
]

#note[
  Per ottenere BST con altezza garantita $O(log n)$ nel caso peggiore, si utilizzano alberi bilanciati come gli *AVL* o i *Red-Black Tree*. Queste strutture aggiungono operazioni di *rotazione* dopo inserimenti e cancellazioni per mantenere il bilanciamento, garantendo complessità $O(log n)$ per tutte le operazioni.
]
