#import "../template.typ": *

== Cammini minimi da sorgente unica

Il problema dei *cammini minimi da sorgente unica* si pone su grafi *pesati*: dato $G = (V,E)$ e una sorgente $s in V$, si vuole determinare un cammino di peso minimo da $s$ a ciascun vertice $v in V$.

Applicazioni tipiche sono il *routing su rete* (instradamento di pacchetti su internet, navigatori satellitari): si opera sulla base di algoritmi per la ricerca di cammini minimi. Per grafi *non pesati* il problema si risolve con $"BFS"(G,s)$.

=== Grafi pesati

#definizione(titolo: "Grafo pesato e peso di un cammino")[
  Dato $G = (V, E)$, una *funzione peso* è una funzione $omega : E arrow RR$ che associa a ciascun arco un peso (costi, perdite, distanze: quantità che occorre minimizzare).

  Il *peso di un cammino* $p = chevron.l v_0, v_1, dots, v_k chevron.r$ è:
  $ omega(p) = sum_(i=1)^k omega(v_(i-1), v_i) $

  Il *peso di un cammino minimo* da $u$ a $v$ è:
  $ delta(u,v) = cases(min{omega(p) : u attach(arrow.squiggly, t: p) v} & "se esiste un cammino " u arrow.squiggly v, +infinity & "altrimenti") $

  Un *cammino minimo* da $u$ a $v$ è un cammino $p$ di peso $omega(p) = delta(u,v)$.
]

=== Varianti del problema

- *Cammini minimi con sorgente unica* $s in V$: cammino di peso minimo dal vertice $s$ a ciascun vertice $v in V$.
- *Cammini minimi con destinazione unica* $t in V$: cammino di peso minimo da ciascun vertice $v in V$ al vertice $t$. Invertendo la direzione degli archi, si riconduce al caso precedente.
- *Cammino minimo per una coppia di vertici*: cammino minimo da $u$ a $v$ fissati. Si risolve con il problema della sorgente unica scegliendo $s = u$ (asintoticamente, al caso pessimo, stesso costo di algoritmi specifici).
- *Cammini minimi tra tutte le coppie di vertici*: si può risolvere iterando l'algoritmo con sorgente unica scegliendo ogni vertice come sorgente (esistono metodi più efficienti).

=== Proprietà dei cammini minimi

#lemma(titolo: "Sottostruttura ottima dei cammini minimi")[
  Dato un grafo orientato pesato $G = (V,E)$ con funzione peso $omega : E arrow RR$, sia $p = chevron.l v_1, v_2, dots, v_k chevron.r$ un cammino minimo $v_1 arrow.squiggly v_k$ e, per $1 <= i <= j <= k$, sia $p_(i j) = chevron.l v_i, v_(i+1), dots, v_j chevron.r$ il sottocammino di $p$ da $v_i$ a $v_j$. Allora $p_(i j)$ è un cammino minimo da $v_i$ a $v_j$.

  _I sottocammini di cammini minimi sono cammini minimi._
]

#dimostrazione[
  Scomponiamo $p$ come $v_1 attach(arrow.squiggly, t: p_(1 i)) v_i attach(arrow.squiggly, t: p_(i j)) v_j attach(arrow.squiggly, t: p_(j k)) v_k$, da cui:
  $ omega(p) = omega(p_(1 i)) + omega(p_(i j)) + omega(p_(j k)) $
  Per assurdo, esista un cammino $p'_(i j)$ da $v_i$ a $v_j$ con $omega(p'_(i j)) < omega(p_(i j))$. Allora il cammino $p'$ ottenuto sostituendo $p_(i j)$ con $p'_(i j)$ avrebbe peso:
  $ omega(p') = omega(p_(1 i)) + omega(p'_(i j)) + omega(p_(j k)) < omega(p) $
  che contraddice la minimalità di $p$.
]

=== Archi di peso negativo e cicli di peso negativo

In alcuni problemi di cammini minimi possono presentarsi archi con peso negativo. Se il grafo $G$ *non* contiene cicli di peso negativo raggiungibili da $s$, allora $delta(s,v)$ resta ben definito per ogni $v in V$ (anche se può avere valore negativo).

Se invece esiste un ciclo di peso negativo raggiungibile da $s$ e, da un vertice del ciclo, si raggiunge $v$, allora $delta(s,v)$ *non* è ben definito: percorrendo il ciclo un numero arbitrario di volte si ottengono cammini di peso arbitrariamente piccolo. In questo caso si pone per convenzione $delta(s,v) = -infinity$.

#osservazione[
  *I cammini minimi sono sempre cammini semplici*, privi di cicli:
  - se il ciclo ha peso $> 0$, eliminandolo dal cammino se ne ottiene uno di peso minore;
  - se il ciclo ha peso $0$, possiamo eliminarlo e ottenere un cammino semplice con lo stesso peso;
  - un ciclo di peso $< 0$ non può comparire in un cammino minimo (altrimenti $delta$ non sarebbe definito).

  Un cammino semplice contiene al più $|V|$ vertici, e dunque $|V| - 1$ archi.

  I cammini minimi si rappresentano con l'attributo $pi$ (predecessore): la catena dei predecessori a partire da $v$ descrive all'indietro il cammino minimo da $s$ a $v$, e può essere stampato con PRINT-PATH.
]

L'*algoritmo di Dijkstra* assume che tutti i pesi siano non negativi ($omega(u,v) >= 0$). L'*algoritmo di Bellman-Ford* (non trattato qui) gestisce il caso generale con archi di peso negativo, rilevando inoltre l'eventuale presenza di cicli di peso negativo raggiungibili dalla sorgente.

=== Disuguaglianza triangolare pesata

#lemma(titolo: "Disuguaglianza triangolare [CLRS: Lemma 24.10]")[
  Sia $G = (V,E)$ un grafo orientato pesato con funzione peso $omega$ e sorgente $s in V$. Per ogni arco $(u,v) in E$:
  $ delta(s,v) <= delta(s,u) + omega(u,v) $
]

#dimostrazione[
  Se $u$ è raggiungibile da $s$, estendendo un cammino minimo $s arrow.squiggly u$ con l'arco $(u,v)$ si ottiene un cammino da $s$ a $v$ di peso $delta(s,u) + omega(u,v)$: non può essere più corto del cammino minimo $s arrow.squiggly v$. Se $u$ non è raggiungibile, $delta(s,u) = +infinity$ e la disuguaglianza è banalmente vera.
]

#nota[
  È la versione pesata del Lemma 22.1 visto per BFS: qui al posto di "$+1$" (lunghezza dell'arco non pesato) compare il peso $omega(u,v)$.
]

=== Inizializzazione e rilassamento

Gli algoritmi per cammini minimi mantengono per ogni vertice $v$ due attributi:

- la *stima* $v.d$: è il peso del miglior cammino da $s$ a $v$ *trovato finora* dall'algoritmo. È solo un numero, non un cammino: rappresenta "quanto costa, al meglio delle nostre conoscenze attuali, andare da $s$ a $v$". Parte da $+infinity$ (all'inizio non si conosce alcun cammino verso $v$, tranne $s.d = 0$) e *cala monotonamente* man mano che l'algoritmo scopre cammini migliori, fino a coincidere con la distanza vera $delta(s,v)$ al termine. Si chiama "stima" proprio perché, finché l'algoritmo non è terminato, $v.d$ è solo un'approssimazione di $delta(s,v)$; più precisamente vale sempre l'invariante
  $ v.d >= delta(s,v) $
  ovvero $v.d$ è un *limite superiore* per la distanza vera (mai sotto, può solo scendere verso il valore corretto).

- il *predecessore* $v.pi$: il vertice che precede $v$ nel cammino di peso $v.d$ trovato finora. Serve a ricostruire il cammino effettivo (non solo il suo costo) seguendo all'indietro la catena dei $pi$ a partire da $v$.

Entrambi gli attributi vengono inizializzati da $"INITIALIZE-SINGLE-SOURCE"$ e modificati esclusivamente dal *rilassamento* di un arco.

#algoritmo(titolo: "INITIALIZE-SINGLE-SOURCE(G, s)")[
  ```
  INITIALIZE-SINGLE-SOURCE(G, s) {
      for (v in V) {
          v.d = +∞;
          v.π = NIL;
      }
      s.d = 0;
  }
  ```
]

#algoritmo(titolo: "Relax(u, v, ω)")[
  ```
  RELAX(u, v, ω) {
      if (v.d > u.d + ω(u, v)) {
          v.d = u.d + ω(u, v);
          v.π = u;
      }
  }
  ```
]

Il rilassamento di $(u,v)$ *verifica* se, passando da $u$, si può migliorare la stima corrente di $v$; in caso affermativo aggiorna $v.d$ e $v.pi$. Costo: $O(1)$.

#nota[
  Il termine "rilassamento" è tradizionale: l'operazione riduce un limite superiore, quindi "rilassa" il vincolo $v.d <= u.d + omega(u,v)$ (che deve valere all'ottimo per la disuguaglianza triangolare).
]

== Algoritmo di Dijkstra

L'*algoritmo di Dijkstra* risolve il problema dei cammini minimi da sorgente unica in un grafo orientato pesato $G = (V,E)$ con pesi *non negativi*: $forall (u,v) in E, omega(u,v) >= 0$.

Per ogni vertice $v in V$ mantiene due attributi:
- $v.pi$: predecessore di $v$ nell'albero dei cammini minimi;
- $v.d$: *stima del cammino minimo*, ovvero un *limite superiore* per $delta(s,v)$, inizializzato a $+infinity$ (vale sempre $v.d >= delta(s,v)$).

Tutti i vertici sono inseriti in una *coda di MIN-priorità* $"PQ"$ con priorità $v.d$.

#nota(titolo: "Coda di MIN-priorità")[
  Una _coda di MIN-priorità_ è una struttura dati che mantiene un insieme di elementi, ciascuno con una *chiave* (o priorità), e supporta tre operazioni fondamentali:
  - `INSERT(PQ, x)`: inserisce l'elemento $x$ con la sua chiave corrente;
  - `EXTRACT-MIN(PQ)`: rimuove e restituisce l'elemento con chiave *minima*;
  - `DECREASE-KEY(PQ, x, k)`: diminuisce la chiave dell'elemento $x$ a $k$ (solo se $k$ è minore della chiave attuale).

  In Dijkstra la chiave di $v$ è la stima $v.d$: `EXTRACT-MIN` restituisce il vertice con la minor stima corrente di cammino minimo. L'implementazione tipica è un *MIN-heap binario* (tipicamente trattato nel capitolo sugli heap).
]

L'algoritmo seleziona ripetutamente il vertice $u$ con la minor stima del cammino minimo (estraendolo da $"PQ"$) ed esamina gli archi uscenti da $u$: per ogni $v in "Adj"[u]$, controlla se passando da $u$ si trova un cammino meno costoso da $s$ a $v$; in tal caso aggiorna $v.d$ e $v.pi$ (*rilassamento* dell'arco $(u,v)$).

#algoritmo(titolo: "Dijkstra(G, ω, s)")[
  ```
  DIJKSTRA(G, ω, s) {    // ω: funzione peso, s: sorgente
      INITIALIZE-SINGLE-SOURCE(G, s);
      PQ = nuova coda di MIN-priorità;
      for (v in V)
          INSERT(PQ, v);                  // priorità: v.d
      while (PQ ≠ ∅) {
          u = EXTRACT-MIN(PQ);
          for (v in Adj[u]) {              // rilassamento degli archi
              if (v.d > u.d + ω(u, v)) {   // RELAX(u, v, ω)
                  v.d = u.d + ω(u, v);
                  v.π = u;
                  DECREASE-KEY(PQ, v, v.d);
              }
          }
      }
  }
  ```
]

#osservazione[
  Rispetto al $"RELAX"$ astratto, qui il test e l'aggiornamento sono esplicitati perché quando si abbassa $v.d$ occorre invocare $"DECREASE-KEY"$ sulla coda di priorità — altrimenti $"PQ"$ non manterrebbe la proprietà di heap.
]

=== Simulazione

#esempio(titolo: "Esecuzione di Dijkstra su grafo pesato")[
  Grafo orientato $G$ con $V = \{s, t, x, y, z\}$ e archi pesati:
  $omega(s,t) = 10, omega(s,y) = 5, omega(t,x) = 1, omega(t,y) = 2,$ \
  $omega(y,t) = 3, omega(y,x) = 9, omega(y,z) = 2, omega(x,z) = 4,$ \
  $omega(z,s) = 7, omega(z,x) = 6$.

  Dopo l'inizializzazione, $s.d = 0$ e tutti gli altri vertici hanno $d = +infinity$. Ad ogni iterazione si estrae da $"PQ"$ il vertice con stima minima e si rilassano gli archi uscenti. La tabella mostra le stime *dopo* il rilassamento e sottolinea il prossimo vertice che verrà estratto da $"PQ"$.

  #table(
    columns: (auto, auto, auto, auto, auto, auto, auto),
    align: (center, center, center, center, center, center, center),
    stroke: 0.5pt,
    [*Iter.*], [*$u$ estratto*], [$s.d$], [$t.d$], [$x.d$], [$y.d$], [$z.d$],
    [0 (init)], [—], [$underline(0)$], [$infinity$], [$infinity$], [$infinity$], [$infinity$],
    [1], [$s$], [0], [10], [$infinity$], [$underline(5)$], [$infinity$],
    [2], [$y$], [0], [8], [14], [5], [$underline(7)$],
    [3], [$z$], [0], [$underline(8)$], [13], [5], [7],
    [4], [$t$], [0], [8], [$underline(9)$], [5], [7],
    [5], [$x$], [0], [8], [9], [5], [7],
  )

  *Distanze finali:* $s.d = 0, t.d = 8, x.d = 9, y.d = 5, z.d = 7$.

  *Predecessori:* $t.pi = y$ (cammino $s arrow y arrow t$), $x.pi = t$ ($s arrow y arrow t arrow x$), $y.pi = s$, $z.pi = y$ ($s arrow y arrow z$).

  Si noti che all'iterazione 2, rilassando gli archi uscenti da $y$, la stima di $t$ scende da $10$ a $5 + 3 = 8$: il cammino $s arrow y arrow t$ è migliore dell'arco diretto $s arrow t$.
]

=== Correttezza

#teorema(titolo: "Correttezza dell'algoritmo di Dijkstra")[
  L'algoritmo di Dijkstra, eseguito su un grafo orientato pesato $G = (V,E)$ con funzione peso non negativa $omega$ e sorgente $s$, termina con $v.d = delta(s,v)$ per ogni $v in V$.
]

#dimostrazione(stile: "sketch")[
  *(1) Per ogni vertice $v in V$ vale $v.d >= delta(s,v)$.*

  - All'inizio $v.d = +infinity >= delta(s,v)$.
  - $v.d$ viene aggiornato solo dal rilassamento, che pone $v.d$ uguale al peso di un qualche cammino $s arrow.squiggly v$, che è certamente $>= delta(s,v)$.
  - Sulla sorgente si pone $s.d = 0 = delta(s,s)$, e non viene più aggiornato.

  *(2) Per induzione sul numero di vertici estratti da $"PQ"$.* Sia $S$ l'insieme dei vertici già estratti da $"PQ"$.

  _Ipotesi induttiva:_ per ogni $v in S$, $v.d = delta(s,v)$.

  _Base:_ $S = {s}$ e $s.d = 0 = delta(s,s)$. ✓

  _Passo:_ sia $v$ il prossimo vertice estratto da $"PQ"$ e inserito in $S$. Sia $P$ un cammino $s arrow.squiggly v$ di peso minimo, e sia $(x, y) in E$ il primo arco di $P$ che esce da $S$: $x in S$ e $y$ è ancora in $"PQ"$ ($s$ può coincidere con $x$, e $y$ può coincidere con $v$).

  Mostriamo che $y.d = delta(s,y)$: quando $x$ è stato estratto da $"PQ"$, l'arco $(x,y)$ è stato rilassato, dunque per ipotesi induttiva su $x$ e per la sottostruttura ottima:
  $ y.d <= x.d + omega(x,y) = delta(s,x) + omega(x,y) = delta(s,y) $
  Combinando con il punto (1), $y.d = delta(s,y)$.

  Ora, essendo $y$ sul cammino minimo $P$ prima di $v$ e i pesi non negativi:
  $ v.d >= delta(s,v) >= delta(s,y) = y.d >= v.d $
  dove l'ultima disuguaglianza vale perché $v$ è stato estratto prima di $y$ da $"PQ"$ (scelta del minimo). Dunque $v.d = delta(s,v)$.

  Al termine dell'algoritmo $"PQ" = emptyset$ e $S = V$: per ogni $v in V$, $v.d = delta(s,v)$.
]

=== Analisi di complessità

Il tempo di esecuzione dipende dall'implementazione della coda di MIN-priorità. In generale:
$ T(|V|, |E|) = O(|V| dot "costo"("EXTRACT-MIN") + |E| dot "costo"("DECREASE-KEY")) $

- Si eseguono $|V|$ operazioni $"EXTRACT-MIN"$.
- La lista di adiacenza di ciascun vertice viene esaminata esattamente una volta: $|E|$ iterazioni del ciclo `for`, con al più $|E|$ chiamate di $"DECREASE-KEY"$.
- La costruzione di $"PQ"$ richiede $Theta(|V|)$ (ogni inserzione costa $O(1)$: solo due valori, $0$ e $+infinity$).

#table(
  columns: (auto, auto, auto, auto),
  align: (left, center, center, center),
  stroke: 0.5pt,
  [*Implementazione di PQ*], [`EXTRACT-MIN`], [`DECREASE-KEY`], [*Totale*],
  [Array indicizzato sui vertici], [$O(|V|)$], [$O(1)$], [$O(|V|^2)$],
  [MIN-heap binario], [$O(log |V|)$], [$O(log |V|)$], [$O((|V| + |E|) log |V|)$],
)

#osservazione[
  - *Array*: si ispeziona l'intero array per trovare il vertice con stima minima. Costo complessivo $Theta(|V|) + O(|V|^2 + |E|) = O(|V|^2)$. Preferibile per grafi *densi*.
  - *MIN-heap binario*: la costruzione di $"PQ"$ richiede $Theta(|V|)$. Costo complessivo $Theta(|V|) + O(|V| log |V| + |E| log |V|) = O((|V| + |E|) log |V|)$. Preferibile per grafi *sparsi*.

  Per implementare $"DECREASE-KEY"$ in $O(log|V|)$ con lo heap binario, occorre trovare $v$ in $"PQ"$ in tempo costante: i vertici devono mantenere un riferimento alla posizione del corrispondente elemento nell'heap (e viceversa).
]

=== Esempio di implementazione di DECREASE-KEY

Per ogni $v in V$, $v."pos"$ è la posizione del vertice $v$ in $"PQ"$. $"PQ"$ è un array di coppie $("stima", "vertice")$, dove `stima` è il valore della stima di cammino minimo e `vertice` è il riferimento al vertice.

#algoritmo(titolo: "DECREASE-KEY(PQ, v, dnew)")[
  ```
  DECREASE-KEY(PQ, v, dnew) {
      if (dnew ≥ v.d)
          error "la nuova stima non è minore della precedente";
      i = v.pos;                    // posizione di v in PQ
      PQ[i].stima = dnew;           // PQ è uno heap tranne in posizione i
      while (i > 1 && PQ[i].stima < PQ[Parent(i)].stima) {
          Scambia(PQ, i, Parent(i));
          i = Parent(i);
      }
  }
  ```
]

#algoritmo(titolo: "Scambia(PQ, i, j)")[
  ```
  SCAMBIA(PQ, i, j) {
      tmp = PQ[i];
      PQ[i] = PQ[j];
      PQ[j] = tmp;
      (PQ[i].vertice).pos = i;    // aggiorna i riferimenti
      (PQ[j].vertice).pos = j;
  }

  PARENT(i) { return ⌊i/2⌋; }
  ```
]

La $"DECREASE-KEY"$ costa $O(log|V|)$ (risalita nello heap); `Scambia` e `Parent` costano $O(1)$.
