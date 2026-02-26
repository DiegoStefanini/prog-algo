#import "../template.typ": *

== Strutture Dati Lineari

Una *struttura dati* è un modo sistematico di organizzare e memorizzare dati in modo da rendere efficienti le operazioni che si intendono eseguire su di essi. La scelta della struttura dati influenza direttamente la complessità temporale e spaziale degli algoritmi.

Le *strutture dati lineari* organizzano gli elementi in sequenza: ogni elemento (tranne il primo e l'ultimo) ha esattamente un predecessore e un successore. Le strutture che analizziamo in questa sezione sono *array*, *liste concatenate*, *pile* e *code*.

=== Array

#definition(title: "Array")[
  Un *array* è una struttura dati che memorizza una collezione di $n$ elementi dello stesso tipo in $n$ locazioni di memoria *contigue*. Ogni elemento è univocamente identificato da un *indice* intero $i in {1, ..., n}$ e si accede ad esso in tempo costante tramite la formula:

  $ "indirizzo"(A[i]) = "indirizzo"(A[1]) + (i - 1) dot "dimensione elemento" $
]

L'accesso diretto tramite indice e la contiguità in memoria sono le proprietà fondamentali degli array. La contiguità garantisce un'elevata *località spaziale*, che si traduce in un utilizzo efficiente della cache del processore: quando si accede a $A[i]$, gli elementi vicini $A[i+1], A[i+2], ...$ vengono caricati nella stessa linea di cache.

==== Proprietà degli array

- *Accesso diretto* in $O(1)$ tramite indice
- *Dimensione fissa*: stabilita al momento della creazione (in molti linguaggi)
- *Elementi contigui in memoria*: ottimo per accessi sequenziali
- *Tipo omogeneo*: tutti gli elementi hanno lo stesso tipo

==== Operazioni e complessità

#figure(
  table(
    columns: 3,
    align: (left, left, center),
    [*Operazione*], [*Descrizione*], [*Complessità*],
    [`Access(A, i)`], [Restituisce l'elemento in posizione $i$], [$O(1)$],
    [`Search(A, x)`], [Cerca l'elemento $x$ (scansione lineare)], [$O(n)$],
    [`Insert(A, i, x)`], [Inserisce $x$ in posizione $i$, traslando gli elementi successivi], [$O(n)$],
    [`Delete(A, i)`], [Elimina l'elemento in posizione $i$, traslando gli elementi successivi], [$O(n)$],
  ),
  caption: [Operazioni su array e relative complessità nel caso peggiore],
)

#note(title: "Costo dell'inserimento e della cancellazione")[
  L'inserimento di un elemento in posizione $i$ richiede lo spostamento di tutti gli elementi da $A[i]$ a $A[n]$ di una posizione a destra, per fare spazio al nuovo elemento. Analogamente, la cancellazione richiede lo spostamento degli elementi successivi a sinistra per riempire il "buco". Nel caso peggiore (inserimento o cancellazione in testa, $i = 1$) si spostano tutti gli $n$ elementi, da cui la complessità $O(n)$.

  L'inserimento *in coda* (posizione $n + 1$) costa $O(1)$ se c'è spazio disponibile, perché non richiede alcuno spostamento.
]

#example(title: "Inserimento in un array")[
  Dato l'array $A = [3, 7, 12, 5, 9]$ con $n = 5$, inseriamo il valore $8$ in posizione $i = 3$:

  #array-viz((3, 7, 12, 5, 9), evidenzia: (3,), inizio: 1)

  + Spostiamo $A[5]$ in $A[6]$: #array-viz((3, 7, 12, 5, 9, 9), evidenzia: (5, 6), inizio: 1)
  + Spostiamo $A[4]$ in $A[5]$: #array-viz((3, 7, 12, 5, 5, 9), evidenzia: (4, 5), inizio: 1)
  + Spostiamo $A[3]$ in $A[4]$: #array-viz((3, 7, 12, 12, 5, 9), evidenzia: (3, 4), inizio: 1)
  + Scriviamo $A[3] := 8$: #array-viz((3, 7, 8, 12, 5, 9), evidenzia: (3,), inizio: 1)

  Sono stati necessari $n - i + 1 = 3$ spostamenti.
]

=== Liste Concatenate

#definition(title: "Lista concatenata")[
  Una *lista concatenata* (linked list) è una struttura dati in cui gli elementi, detti *nodi*, sono collegati tramite *puntatori*. A differenza degli array, i nodi non occupano locazioni di memoria contigue: ogni nodo può trovarsi in una posizione arbitraria della memoria, e il collegamento tra nodi è realizzato esclusivamente attraverso i puntatori.
]

Il vantaggio principale delle liste rispetto agli array è che inserimenti e cancellazioni possono essere effettuati in tempo $O(1)$ senza spostare altri elementi, purché si disponga del puntatore al punto di inserimento. Lo svantaggio è la perdita dell'accesso diretto: per raggiungere l'$i$-esimo elemento bisogna attraversare $i - 1$ nodi.

==== Lista semplicemente concatenata

In una lista *semplicemente concatenata* ogni nodo contiene due campi:
- `key`: il dato memorizzato nel nodo
- `next`: un puntatore al nodo successivo nella lista (oppure `NIL` se il nodo è l'ultimo)

La lista è accessibile tramite un puntatore `L.head` al primo nodo.

#algorithm(title: "Struttura di un nodo (lista semplice)")[
  ```
  // Nodo di lista semplicemente concatenata
  // key  : dato memorizzato
  // next : puntatore al nodo successivo (NIL se ultimo)
  ```
]

#example(title: "Lista semplicemente concatenata")[
  La lista $chevron.l 3, 7, 12, 5 chevron.r$ è rappresentata come:

  #align(center)[
    #text(size: 10pt)[
    $
    underbrace([3 | dot] -> [7 | dot] -> [12 | dot] -> [5 | \/ ], "L.head")
    $
    ]
  ]

  Il simbolo $\/$ indica il puntatore `NIL`. Ogni nodo contiene il dato e un puntatore al nodo successivo.
]

==== Lista doppiamente concatenata

In una lista *doppiamente concatenata* ogni nodo contiene tre campi:
- `key`: il dato memorizzato
- `next`: puntatore al nodo successivo
- `prev`: puntatore al nodo precedente

#algorithm(title: "Struttura di un nodo (lista doppia)")[
  ```
  // Nodo di lista doppiamente concatenata
  // key  : dato memorizzato
  // next : puntatore al nodo successivo (NIL se ultimo)
  // prev : puntatore al nodo precedente (NIL se primo)
  ```
]

La presenza del puntatore `prev` consente la navigazione in entrambe le direzioni e semplifica l'operazione di cancellazione: dato un puntatore a un nodo $x$, si può rimuoverlo in $O(1)$ senza dover cercare il suo predecessore.

==== Operazioni su liste doppiamente concatenate

Le tre operazioni fondamentali su liste sono la *ricerca*, l'*inserimento* e la *cancellazione*. Presentiamo lo pseudocodice per una lista doppiamente concatenata con puntatore `L.head` alla testa.

===== Ricerca

La ricerca scorre la lista dal primo nodo fino a trovare un nodo con chiave $k$ oppure fino a raggiungere la fine della lista (`NIL`).

#algorithm(title: "List-Search(L, k)")[
  ```
  Node listSearch(List L, int k){
      Node x = L.head;
      while((x != NIL) && (x.key != k)){
          x := x.next;
      }
      return x;
  }
  ```
]

*Complessità:* $O(n)$ nel caso peggiore (elemento non presente o in ultima posizione). Nel caso migliore $O(1)$ (elemento in testa).

===== Inserimento in testa

L'inserimento in testa aggiunge un nuovo nodo $x$ come primo elemento della lista.

#algorithm(title: "List-Insert(L, x)")[
  ```
  listInsert(List L, Node x){
      x.next := L.head;
      if(L.head != NIL){
          L.head.prev := x;
      }
      L.head := x;
      x.prev := NIL;
  }
  ```
]

*Complessità:* $O(1)$, poiché si aggiornano solo un numero costante di puntatori indipendentemente dalla lunghezza della lista.

===== Cancellazione

La cancellazione rimuove un nodo $x$ dalla lista, dato il puntatore a $x$. Si devono aggiornare i puntatori del predecessore e del successore di $x$ affinché si "scavalchi" il nodo rimosso.

#algorithm(title: "List-Delete(L, x)")[
  ```
  listDelete(List L, Node x){
      if(x.prev != NIL){
          x.prev.next := x.next;
      } else {
          L.head := x.next;
      }
      if(x.next != NIL){
          x.next.prev := x.prev;
      }
  }
  ```
]

*Complessità:* $O(1)$ se si dispone già del puntatore al nodo $x$. Se occorre prima cercare $x$ (ad esempio tramite la chiave), la complessità complessiva diventa $O(n)$ a causa della ricerca.

#note(title: "Gestione dei casi limite")[
  Nell'operazione `List-Delete`, il ramo `else` gestisce il caso in cui $x$ è il primo nodo della lista (`x.prev == NIL`): in tal caso occorre aggiornare `L.head`. Analogamente, il secondo `if` gestisce il caso in cui $x$ è l'ultimo nodo. Questa gestione dei casi limite rende il codice più complesso; le *sentinelle* permettono di semplificarlo.
]

==== Varianti delle liste

===== Lista circolare

In una *lista circolare*, l'ultimo nodo punta al primo invece che a `NIL`. In una lista doppiamente concatenata circolare, il `prev` del primo nodo punta all'ultimo e il `next` dell'ultimo punta al primo. Questa struttura è utile quando si vuole poter ciclare sugli elementi senza un punto di inizio/fine esplicito.

===== Lista con sentinella

Una *sentinella* (o nodo fittizio) è un nodo speciale `L.nil` che non contiene dati significativi e funge da "confine" della lista. In una lista doppiamente concatenata con sentinella:

- `L.nil.next` punta al primo elemento della lista (la "testa")
- `L.nil.prev` punta all'ultimo elemento (la "coda")
- Il `prev` del primo elemento punta a `L.nil`
- Il `next` dell'ultimo elemento punta a `L.nil`
- Una lista vuota ha `L.nil.next == L.nil` e `L.nil.prev == L.nil`

La sentinella trasforma la lista in una struttura circolare e *elimina tutti i casi limite* (lista vuota, inserimento/cancellazione in testa o in coda), semplificando notevolmente lo pseudocodice.

#algorithm(title: "Ricerca con sentinella")[
  ```
  Node listSearch'(List L, int k){
      Node x = L.nil.next;
      while((x != L.nil) && (x.key != k)){
          x := x.next;
      }
      return x;
  }
  ```
]

*Complessità:* $O(n)$ nel caso peggiore, come la versione senza sentinella. La differenza è che il ciclo testa `x != L.nil` invece di `x != NIL`.

#algorithm(title: "Inserimento con sentinella")[
  ```
  // Con sentinella: nessun caso speciale necessario
  listInsert'(List L, Node x){
      x.next := L.nil.next;
      L.nil.next.prev := x;
      L.nil.next := x;
      x.prev := L.nil;
  }
  ```
]

*Complessità:* $O(1)$. Non è necessario verificare se la lista è vuota, poiché la sentinella garantisce che `L.nil.next` esista sempre.

#algorithm(title: "Cancellazione con sentinella")[
  ```
  // Con sentinella: nessun caso speciale necessario
  listDelete'(List L, Node x){
      x.prev.next := x.next;
      x.next.prev := x.prev;
  }
  ```
]

#note(title: "Quando usare le sentinelle")[
  Le sentinelle raramente abbassano i limiti asintotici sui tempi delle operazioni, ma possono ridurre i *fattori costanti*. Il vantaggio principale è la *chiarezza del codice*: eliminando le condizioni al contorno, lo pseudocodice risulta più semplice e meno soggetto a errori. Sono utili quando si hanno molte operazioni di inserimento e cancellazione e si vuole ridurre il numero di condizioni da verificare.

  Le sentinelle non dovrebbero essere utilizzate in modo indiscriminato. Se ci sono molte liste piccole, lo spazio extra in memoria utilizzato dalle sentinelle potrebbe costituire un notevole spreco. Si utilizzano le sentinelle soltanto se semplificano davvero il codice.
]

==== Confronto Array vs Liste

#figure(
  table(
    columns: 3,
    align: (left, center, center),
    [*Operazione*], [*Array*], [*Lista concatenata*],
    [Accesso per indice], [$O(1)$], [$O(n)$],
    [Ricerca (non ordinato)], [$O(n)$], [$O(n)$],
    [Inserimento in testa], [$O(n)$], [$O(1)$],
    [Inserimento in coda], [$O(1)$#super[\*]], [$O(1)$#super[\*\*]],
    [Cancellazione (dato il puntatore/indice)], [$O(n)$], [$O(1)$],
    [Uso della memoria], [Compatto, no overhead], [Overhead per puntatori],
    [Località di cache], [Elevata], [Scarsa],
  ),
  caption: [Confronto tra array e lista concatenata. #super[\*] se c'è spazio nell'array. #super[\*\*] se si mantiene un puntatore alla coda.],
)

La scelta tra array e lista dipende dal profilo di utilizzo: se predominano accessi per indice, l'array è preferibile; se predominano inserimenti e cancellazioni in posizioni arbitrarie, la lista concatenata è più efficiente.

=== Pile (Stack)

#definition(title: "Pila")[
  Una *pila* (stack) è una struttura dati con politica di accesso *LIFO* (Last In, First Out): l'ultimo elemento inserito è il primo ad essere rimosso. L'unico elemento accessibile è quello in *cima* (top) alla pila.
]

La pila è un *tipo di dato astratto*: la definizione specifica *cosa* fa (l'interfaccia), non *come* è implementata. Può essere realizzata sia con array che con liste concatenate.

==== Interfaccia

Le operazioni fondamentali su una pila $S$ sono:

- `Push(S, x)`: inserisce l'elemento $x$ in cima alla pila
- `Pop(S)`: rimuove e restituisce l'elemento in cima alla pila. Errore (*underflow*) se la pila è vuota
- `Top(S)`: restituisce l'elemento in cima senza rimuoverlo
- `IsEmpty(S)`: restituisce `true` se la pila è vuota, `false` altrimenti

Tutte le operazioni hanno complessità $O(1)$.

==== Implementazione con array

Si utilizza un array $S[1..n]$ e una variabile `S.top` che indica l'indice dell'elemento in cima. Una pila vuota ha `S.top == 0`.

#algorithm(title: "Pila su array")[
  ```
  bool stackEmpty(Stack S){
      return S.top == 0;
  }

  push(Stack S, int x){
      if(S.top == S.length){
          // error "overflow"
          return;
      }
      S.top := S.top + 1;
      S[S.top] := x;
  }

  int pop(Stack S){
      if(stackEmpty(S)){
          // error "underflow"
          return -1;
      }
      S.top := S.top - 1;
      return S[S.top + 1];
  }

  int top(Stack S){
      if(stackEmpty(S)){
          // error "underflow"
          return -1;
      }
      return S[S.top];
  }
  ```
]

#note(title: "Overflow")[
  Nell'implementazione su array, la dimensione della pila è limitata dalla dimensione dell'array. Se si tenta un `Push` quando `S.top == S.length`, si verifica un errore di *overflow*. Questo problema non si presenta nell'implementazione su lista.
]

==== Implementazione con lista concatenata

La cima della pila corrisponde alla testa della lista. Le operazioni `Push` e `Pop` corrispondono rispettivamente all'inserimento e alla cancellazione in testa.

#algorithm(title: "Pila su lista concatenata")[
  ```
  push(Stack S, Node x){
      x.next := S.head;
      S.head := x;
  }

  Node pop(Stack S){
      if(S.head == NIL){
          // error "underflow"
          return NIL;
      }
      Node x = S.head;
      S.head := S.head.next;
      return x;
  }
  ```
]

#note(title: "Confronto delle due implementazioni")[
  - *Array*: più efficiente in termini di memoria (nessun overhead per puntatori) e migliore località di cache, ma ha dimensione fissa.
  - *Lista*: dimensione dinamica (nessun overflow), ma ogni nodo richiede spazio aggiuntivo per il puntatore `next`.
]

==== Applicazioni delle pile

- *Call stack*: gestione delle chiamate di funzione e dei record di attivazione. Quando una funzione $f$ chiama una funzione $g$, il contesto di $f$ viene salvato sulla pila; al ritorno di $g$, viene ripristinato.
- *Valutazione di espressioni*: conversione e valutazione di espressioni in notazione polacca inversa (postfissa).
- *Algoritmi di backtracking*: esplorazione di spazi di ricerca (es. labirinti, puzzle) dove si "torna indietro" all'ultimo punto di scelta.
- *Undo/Redo*: negli editor di testo, ogni azione viene impilata; l'annullamento corrisponde a un `Pop`.
- *Bilanciamento delle parentesi*: verifica che ogni parentesi aperta abbia la corrispondente chiusa.

#example(title: "Bilanciamento delle parentesi")[
  Per verificare se una stringa di parentesi è correttamente bilanciata, si utilizza una pila: ogni parentesi aperta viene impilata, e per ogni parentesi chiusa si verifica che corrisponda alla parentesi in cima alla pila.

  #algorithm(title: "isBalanced(s, n)")[
    ```
    bool isBalanced(char[] s, int n){
        Stack S = new Stack();
        int i = 0;
        while(i < n){
            char c = s[i];
            if((c == '(') || (c == '[') || (c == '{')){
                push(S, c);
            } else {
                if((c == ')') || (c == ']') || (c == '}')){
                    if(stackEmpty(S)){
                        return false;
                    }
                    char open = pop(S);
                    if(!match(open, c)){
                        return false;
                    }
                }
            }
            i := i + 1;
        }
        return stackEmpty(S);
    }
    ```
  ]

  Ad esempio, sulla stringa `"({[]})"`:
  + Leggiamo `(`: impiliamo $arrow.r$ pila: $chevron.l ( chevron.r$
  + Leggiamo `{`: impiliamo $arrow.r$ pila: $chevron.l (, \{ chevron.r$
  + Leggiamo `[`: impiliamo $arrow.r$ pila: $chevron.l (, \{, [ chevron.r$
  + Leggiamo `]`: `Pop` restituisce `[`, che corrisponde $arrow.r$ pila: $chevron.l (, \{ chevron.r$
  + Leggiamo `}`: `Pop` restituisce `{`, che corrisponde $arrow.r$ pila: $chevron.l ( chevron.r$
  + Leggiamo `)`: `Pop` restituisce `(`, che corrisponde $arrow.r$ pila: $chevron.l chevron.r$ (vuota)
  + Stringa terminata e pila vuota $arrow.r$ *bilanciata*.
]

#example(title: "Esecuzione di Push e Pop")[
  Mostriamo l'evoluzione della pila durante una sequenza di operazioni, usando l'implementazione su array $S[1..6]$ con `S.top` inizialmente a 0:

  #figure(
    table(
      columns: 4,
      align: (left, center, center, center),
      [*Operazione*], [*S.top*], [*Contenuto array*], [*Cima*],
      [`Push(S, 4)`], [$1$], [$[4, -, -, -, -, -]$], [$4$],
      [`Push(S, 7)`], [$2$], [$[4, 7, -, -, -, -]$], [$7$],
      [`Push(S, 2)`], [$3$], [$[4, 7, 2, -, -, -]$], [$2$],
      [`Pop(S)` $arrow.r 2$], [$2$], [$[4, 7, -, -, -, -]$], [$7$],
      [`Push(S, 9)`], [$3$], [$[4, 7, 9, -, -, -]$], [$9$],
      [`Pop(S)` $arrow.r 9$], [$2$], [$[4, 7, -, -, -, -]$], [$7$],
      [`Pop(S)` $arrow.r 7$], [$1$], [$[4, -, -, -, -, -]$], [$4$],
    ),
    caption: [Evoluzione della pila durante operazioni Push e Pop],
  )
]

=== Code (Queue)

#definition(title: "Coda")[
  Una *coda* (queue) è una struttura dati con politica di accesso *FIFO* (First In, First Out): il primo elemento inserito è il primo ad essere rimosso. Gli inserimenti avvengono alla *fine* (tail) e le rimozioni all'*inizio* (head) della coda.
]

==== Interfaccia

Le operazioni fondamentali su una coda $Q$ sono:

- `Enqueue(Q, x)`: inserisce l'elemento $x$ alla fine della coda
- `Dequeue(Q)`: rimuove e restituisce l'elemento all'inizio della coda. Errore (*underflow*) se la coda è vuota
- `Front(Q)`: restituisce l'elemento all'inizio senza rimuoverlo
- `IsEmpty(Q)`: restituisce `true` se la coda è vuota, `false` altrimenti

Tutte le operazioni hanno complessità $O(1)$.

==== Implementazione con array circolare

Un'implementazione ingenua su array (inserimento in coda e rimozione in testa) porterebbe a uno spostamento progressivo degli elementi verso destra, sprecando spazio. La soluzione è l'*array circolare*: si utilizza un array $Q[1..n]$ in cui gli indici "ruotano", tornando alla posizione 1 dopo la posizione $n$.

Si mantengono due indici:
- `Q.head`: posizione del primo elemento (prossimo da rimuovere)
- `Q.tail`: posizione della prossima cella libera (dove inserire il prossimo elemento)

La coda è vuota quando `Q.head == Q.tail`. L'operazione di "avanzamento circolare" dell'indice si esprime come:

$ i := (i mod n) + 1 $

Questo garantisce che dopo la posizione $n$ si torni alla posizione $1$.

#algorithm(title: "Coda su array circolare")[
  ```
  enqueue(Queue Q, int x){
      if(((Q.tail mod Q.length) + 1) == Q.head){
          // error "overflow"
          return;
      }
      Q[Q.tail] := x;
      if(Q.tail == Q.length){
          Q.tail := 1;
      } else {
          Q.tail := Q.tail + 1;
      }
  }

  int dequeue(Queue Q){
      if(Q.head == Q.tail){
          // error "underflow"
          return -1;
      }
      int x = Q[Q.head];
      if(Q.head == Q.length){
          Q.head := 1;
      } else {
          Q.head := Q.head + 1;
      }
      return x;
  }
  ```
]

#note(title: "Capacità effettiva")[
  Con questa implementazione, un array di dimensione $n$ può contenere al massimo $n - 1$ elementi. Si "sacrifica" una posizione per poter distinguere la coda vuota (`Q.head == Q.tail`) dalla coda piena (`(Q.tail mod n) + 1 == Q.head`). Un'alternativa è mantenere un contatore esplicito del numero di elementi.
]

#example(title: "Esecuzione su array circolare")[
  Array $Q[1..5]$, inizialmente `Q.head = Q.tail = 1` (coda vuota):

  #figure(
    table(
      columns: 4,
      align: (left, center, center, center),
      [*Operazione*], [*head*], [*tail*], [*Contenuto*],
      [_(iniziale)_], [$1$], [$1$], [$[-, -, -, -, -]$],
      [`Enqueue(Q, 3)`], [$1$], [$2$], [$[3, -, -, -, -]$],
      [`Enqueue(Q, 7)`], [$1$], [$3$], [$[3, 7, -, -, -]$],
      [`Enqueue(Q, 5)`], [$1$], [$4$], [$[3, 7, 5, -, -]$],
      [`Dequeue(Q)` $arrow.r 3$], [$2$], [$4$], [$[-, 7, 5, -, -]$],
      [`Enqueue(Q, 12)`], [$2$], [$5$], [$[-, 7, 5, 12, -]$],
      [`Enqueue(Q, 1)`], [$2$], [$1$], [$[1, 7, 5, 12, -]$],
      [`Dequeue(Q)` $arrow.r 7$], [$3$], [$1$], [$[1, -, 5, 12, -]$],
    ),
    caption: [Evoluzione della coda su array circolare. Si noti come il tail "ritorna" alla posizione 1 dopo la posizione 5.],
  )
]

==== Implementazione con lista concatenata

Si mantengono due puntatori: `Q.head` al primo elemento e `Q.tail` all'ultimo. L'inserimento avviene in coda (tramite `Q.tail`) e la rimozione in testa (tramite `Q.head`).

#algorithm(title: "Coda su lista concatenata")[
  ```
  enqueue(Queue Q, Node x){
      x.next := NIL;
      if(Q.tail != NIL){
          Q.tail.next := x;
      }
      Q.tail := x;
      if(Q.head == NIL){
          Q.head := x;
      }
  }

  Node dequeue(Queue Q){
      if(Q.head == NIL){
          // error "underflow"
          return NIL;
      }
      Node x = Q.head;
      Q.head := Q.head.next;
      if(Q.head == NIL){
          Q.tail := NIL;
      }
      return x;
  }
  ```
]

#note(title: "Correttezza della coda su lista")[
  Nell'operazione `Enqueue`: se la coda è vuota (`Q.head == NIL`), il nuovo nodo diventa sia la testa che la coda. Altrimenti, si aggiunge il nodo dopo l'attuale coda.

  Nell'operazione `Dequeue`: se dopo la rimozione `Q.head` diventa `NIL`, anche `Q.tail` deve essere posto a `NIL` (la coda è diventata vuota).
]

==== Applicazioni delle code

- *Scheduling di processi*: il sistema operativo gestisce i processi pronti per l'esecuzione in una coda FIFO (round-robin scheduling).
- *Buffer di I/O*: i dati in ingresso e in uscita vengono bufferizzati in code per gestire la differenza di velocità tra produttore e consumatore.
- *Gestione delle richieste*: i web server utilizzano code per servire le richieste dei client nell'ordine di arrivo.
- *BFS (Breadth-First Search)*: l'algoritmo di visita in ampiezza dei grafi utilizza una coda per esplorare i nodi livello per livello.

=== Deque (Double-Ended Queue)

#definition(title: "Deque")[
  Una *deque* (double-ended queue, pronunciato "deck") è una struttura dati che generalizza sia la pila che la coda, permettendo inserimenti e rimozioni da *entrambe* le estremità.
]

==== Interfaccia

- `InsertFront(D, x)`: inserisce $x$ in testa
- `InsertBack(D, x)`: inserisce $x$ in coda
- `RemoveFront(D)`: rimuove e restituisce l'elemento in testa
- `RemoveBack(D)`: rimuove e restituisce l'elemento in coda

Tutte le operazioni hanno complessità $O(1)$.

#note[
  Una deque può simulare sia una pila (usando solo `InsertFront` e `RemoveFront`) che una coda (usando `InsertBack` e `RemoveFront`). Può essere implementata efficientemente con una lista doppiamente concatenata oppure con un array circolare con due indici.
]

== Code con priorità

Le *code con priorità* sono trattate nella sezione dedicata agli Heap nel capitolo Algoritmi di Ordinamento. A differenza delle code FIFO, l'elemento rimosso non è il primo inserito ma quello con *priorità massima* (o minima). Le operazioni `Insert` e `Extract-Max` (o `Extract-Min`) hanno complessità $O(log n)$ quando implementate con un heap binario.

== Riepilogo e confronto

#figure(
  table(
    columns: 5,
    align: (left, center, center, center, center),
    [*Struttura*], [*Politica*], [*Inserimento*], [*Rimozione*], [*Accesso*],
    [Array], [Indice], [$O(n)$], [$O(n)$], [$O(1)$],
    [Lista], [Posizione], [$O(1)$#super[\*]], [$O(1)$#super[\*]], [$O(n)$],
    [Pila], [LIFO], [$O(1)$], [$O(1)$], [$O(1)$#super[\*\*]],
    [Coda], [FIFO], [$O(1)$], [$O(1)$], [$O(1)$#super[\*\*]],
    [Deque], [Doppia], [$O(1)$], [$O(1)$], [$O(1)$#super[\*\*]],
  ),
  caption: [Riepilogo delle complessità. #super[\*] Con puntatore alla posizione. #super[\*\*] Solo all'elemento accessibile (cima o fronte).],
)

#note(title: "Criteri di scelta")[
  La scelta della struttura dati dipende dal tipo di operazioni che l'algoritmo deve eseguire con maggiore frequenza:
  - *Accesso casuale frequente* $arrow.r$ Array
  - *Inserimenti e cancellazioni frequenti in posizioni arbitrarie* $arrow.r$ Lista concatenata
  - *Elaborazione LIFO* (ultimo arrivato, primo servito) $arrow.r$ Pila
  - *Elaborazione FIFO* (primo arrivato, primo servito) $arrow.r$ Coda
  - *Inserimenti/rimozioni da entrambe le estremità* $arrow.r$ Deque
]
