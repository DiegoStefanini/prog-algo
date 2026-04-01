#import "../template.typ": *

== Visita di un grafo

Una *visita* (o *attraversamento*) di un grafo è l'esame sistematico di tutti i suoi vertici e archi. Può essere:
- *completa*: visita tutto il grafo (se connesso);
- *parziale*: visita solo la componente (fortemente) connessa raggiungibile dalla sorgente.

Le due strategie principali sono:

- *BFS* — Breadth First Search (visita in *ampiezza*): generalizza la visita per livelli di un albero. Scopre i vertici in ordine di distanza crescente dalla sorgente.
- *DFS* — Depth First Search (visita in *profondità*): generalizza la visita radice-foglie di un albero. Esplora il più lontano possibile prima di tornare indietro.

== Visita in Ampiezza (BFS)

=== Struttura e proprietà

#definizione(titolo: "BFS(G, s)")[
  La *visita in ampiezza* prende in input:
  - $G = (V,E)$: grafo rappresentato con liste di adiacenza
  - $s in V$: vertice *sorgente*

  L'algoritmo scopre tutti i vertici raggiungibili da $s$ in ordine di distanza crescente, usando una *coda* (FIFO). Al termine, $v.d = delta(s,v)$ per ogni vertice raggiungibile.
]

Per ogni vertice $v in V$ si mantengono tre attributi:
- $v.d$: distanza da $s$ (inizializzata a $+infinity$; al termine vale $delta(s,v)$)
- $v."color"$: colore che indica lo stato di elaborazione
- $v.Pi$: predecessore di $v$ nell'albero BFS

I colori hanno il seguente significato:

#table(
  columns: (auto, 1fr),
  stroke: 0.5pt,
  [*Colore*], [*Significato*],
  [B (Bianco)], [$v$ non è stato ancora scoperto],
  [G (Grigio)], [$v$ è stato scoperto (è nella coda)],
  [N (Nero)], [tutti gli archi uscenti da $v$ sono stati esaminati ($v$ è uscito dalla coda)],
)

#algoritmo(titolo: "BFS(G, s)")[
  ```
  BFS(G, s) {
      for (v in V \ {s}) {          // inizializzazione
          v.color = B;
          v.d = +inf;
          v.π = NIL;
      }
      s.color = G;
      s.d = 0;
      s.π = NIL;
      Q = coda vuota;
      enqueue(Q, s);
      while (Q non è vuota) {
          u = dequeue(Q);
          for (v in Adj[u]) {
              if (v.color == B) {    // v non ancora scoperto
                  v.color = G;
                  v.d = u.d + 1;
                  v.π = u;
                  enqueue(Q, v);
              }
          }
          u.color = N;
      }
  }
  ```
]

=== Correttezza e complessità

#teorema(titolo: "Correttezza di BFS")[
  Al termine di $"BFS"(G, s)$, per ogni vertice $v in V$ raggiungibile da $s$, vale $v.d = delta(s, v)$.
]

*Complessità:* ogni vertice viene accodato e rimosso dalla coda al più una volta: costo $O(n)$. Per ogni vertice rimosso si esaminano tutti gli archi della sua lista di adiacenza. Poiché la somma delle lunghezze di tutte le liste è $Theta(m)$ (grafi non orientati) o $Theta(m)$ (orientati), il costo totale è:

$ T(n,m) = O(n + m) $

=== Albero BFS

#definizione(titolo: "Albero BFS")[
  Al termine di BFS, il sottografo dei predecessori $G_Pi = (V_Pi, E_Pi)$ con $V_Pi = \{v : v.Pi eq.not "NIL"\} union \{s\}$ e $E_Pi = \{(v.Pi, v) : v in V_Pi \\ \{s\}\}$ è un *albero BFS* radicato in $s$.

  L'albero BFS contiene tutti i cammini minimi da $s$ ai vertici raggiungibili.
]

#esempio(titolo: "BFS(G, 1) su grafo con due componenti connesse")[
  Grafo con 11 vertici: la componente di 1 contiene $\{1,2,3,4,5,6,7,8\}$, la componente isolata contiene $\{9,10,11\}$.

  Evoluzione della coda $Q$ durante BFS(G, 1):
  $Q: 1 arrow.r 2, 3, 4, 6 arrow.r 3, 4, 6 arrow.r 4, 6 arrow.r 6, 5, 7 arrow.r 5, 7 arrow.r 7, 8 arrow.r 8 arrow.r emptyset$

  Distanze calcolate: $1.d=0$, $2.d=1$, $3.d=1$, $4.d=1$, $6.d=1$, $5.d=2$, $7.d=2$, $8.d=2$.

  I vertici 9, 10, 11 restano bianchi con $d = +infinity$ (non raggiungibili da 1).

  Albero BFS radicato in 1:
  - livello 0: $\{1\}$
  - livello 1: $\{2, 3, 4, 6\}$
  - livello 2: $\{5, 7, 8\}$
]

#osservazione[
  BFS calcola la distanza da $s$ a *tutti* i vertici raggiungibili in una sola visita. Se il grafo non è connesso, BFS esplora solo la componente connessa di $s$. Per visitare l'intero grafo non connesso, è necessario avviare BFS da ogni vertice non ancora scoperto.
]

=== Correttezza formale di BFS

La correttezza di BFS si dimostra con una serie di lemmi [CLRS: 22.2].

#lemma(titolo: "Triangolare")[
  Sia $G = (V,E)$ un grafo orientato o non orientato e $s in V$. Per ogni arco $(u,v) in E$:
  $ delta(s,v) <= delta(s,u) + 1 $
]

#dimostrazione[
  Se $u$ è raggiungibile da $s$, lo è anche $v$: il cammino minimo da $s$ a $v$ non può essere più lungo di quello da $s$ a $u$ seguito dall'arco $(u,v)$. Se $u$ non è raggiungibile, $delta(s,u) = +infinity$ e la disuguaglianza è banalmente soddisfatta.
]

#lemma(titolo: "Limite superiore")[
  Al termine di $"BFS"(G,s)$, per ogni vertice $v in V$: $v.d >= delta(s,v)$.
]

#dimostrazione(stile: "per induzione")[
  *Ipotesi induttiva:* $v.d >= delta(s,v)$ per ogni $v in V$, dopo ogni operazione ENQUEUE.

  *Base:* dopo la prima ENQUEUE, $s.d = 0 = delta(s,s)$ e $v.d = +infinity >= delta(s,v)$ per ogni $v eq.not s$. ✓

  *Passo:* sia $v$ un vertice bianco scoperto da $u$. L'algoritmo pone $v.d = u.d + 1$. Per ipotesi induttiva $u.d >= delta(s,u)$, dunque:
  $ v.d = u.d + 1 >= delta(s,u) + 1 >= delta(s,v) $
  dove l'ultima disuguaglianza segue dal Lemma Triangolare. Il valore $v.d$ non cambierà più. ✓
]

#lemma(titolo: "Proprietà della coda")[
  Durante l'esecuzione di BFS, se $Q = [v_1, v_2, dots, v_r]$ con $v_1$ in testa, allora:
  - $v_r .d <= v_1 .d + 1$
  - $v_i .d <= v_(i+1) .d$ per $i = 1, 2, dots, r-1$

  In ogni istante la coda contiene al più due valori distinti di distanza.
]

#corollario(titolo: "Monotonia delle distanze in coda")[
  Se il vertice $v_i$ è inserito nella coda prima di $v_j$, allora $v_i .d <= v_j .d$ al momento dell'inserimento di $v_j$.
]

#teorema(titolo: "Correttezza di BFS [CLRS: Teo. 22.5]")[
  Sia $G = (V,E)$ e $s in V$. BFS scopre tutti i vertici raggiungibili da $s$ e, al termine, $v.d = delta(s,v)$ per ogni $v in V$. Inoltre, per ogni $v eq.not s$ raggiungibile, uno dei cammini minimi da $s$ a $v$ è un cammino minimo da $s$ a $v.Pi$ seguito dall'arco $(v.Pi, v)$.
]

#dimostrazione(stile: "per assurdo")[
  Supponiamo per assurdo che esista $v$ con $v.d eq.not delta(s,v)$. Dal Lemma del Limite Superiore, $v.d > delta(s,v)$ (non può essere minore). Sia $v$ il vertice con il minimo $delta(s,v)$ che riceve un valore errato. Sia $u$ il predecessore immediato di $v$ in un cammino minimo da $s$: $delta(s,v) = delta(s,u) + 1$. Poiché $delta(s,u) < delta(s,v)$, si ha $u.d = delta(s,u)$ (per come abbiamo scelto $v$). Dunque:
  $ v.d > delta(s,v) = delta(s,u) + 1 = u.d + 1 $
  Consideriamo il momento in cui $u$ viene estratto da $Q$. Il vertice $v$ può essere:
  - *Bianco*: allora l'algoritmo impone $v.d = u.d + 1$. Contraddizione.
  - *Nero*: $v$ era già in coda prima di $u$, quindi per il Corollario $v.d <= u.d$. Contraddizione.
  - *Grigio*: $v$ è stato scoperto da un vertice $w$ estratto prima di $u$, con $v.d = w.d + 1 <= u.d + 1$. Contraddizione.

  In tutti i casi si raggiunge una contraddizione: $v.d = delta(s,v)$. ✓
]

=== PRINT-PATH

Dopo aver eseguito $"BFS"(G,s)$, è possibile stampare un cammino minimo da $s$ a qualsiasi vertice $v$ raggiungibile tramite la procedura ricorsiva PRINT-PATH [CLRS: p. 503].

#algoritmo(titolo: "PRINT-PATH(G, s, v)")[
  ```
  PRINT-PATH(G, s, v) {
      // da chiamare dopo BFS(G, s)
      if (v == s)
          print s;
      else if (v.π == NIL)
          print "v non è raggiungibile da s";
      else {
          PRINT-PATH(G, s, v.π);
          print v;
      }
  }
  ```
]

$T(|V|, |E|) = cases(Theta(1) & "se" s arrow.squiggly v "non esiste", Theta(delta(s\,v)) & "se" s arrow.squiggly v "esiste")$

poiché ogni chiamata ricorsiva riguarda un cammino con un vertice in meno: la profondità della ricorsione è $delta(s,v)$.

=== Applicazioni della BFS

#osservazione[
  BFS si può applicare anche a grafi il cui insieme di vertici non è noto a priori (ad esempio, grafi dinamici). In tal caso si sostituiscono i colori con un *dizionario* $D$ dei vertici già visitati. Il costo dipende dalle operazioni sul dizionario: con tabelle hash il caso medio è $Theta(n_s + m_s)$, dove $n_s = |V_s|$ e $m_s = |E_s|$ sono i vertici e gli archi raggiungibili da $s$.
]

#esempio(titolo: "Connessività e componenti connesse")[
  Per verificare se un grafo non orientato $G$ è connesso:
  ```
  Connesso(G) {
      scegli un vertice s in V;
      BFS(G, s);
      for (v in V)
          if (v.color == B) return FALSE;
      return TRUE;
  }
  ```
  $T(|V|, |E|) = Theta(|V| + |E|)$.

  Per contare le componenti connesse si esegue BFS sull'intero grafo riavviandola da ogni vertice non ancora scoperto:
  ```
  BFS(G) {
      for (v in V) { v.color = B; }
      cc = 0;
      for (v in V) {
          if (v.color == B) {
              cc++;
              BFSmod(G, v);    // BFS senza π e d; colora solo
          }
      }
      return cc;
  }
  ```
  Al termine, $cc$ è il numero di componenti connesse. $T(|V|, |E|) = Theta(|V| + |E|)$.
]

== Visita in Profondità (DFS)

La *visita in profondità* (Depth-First Search, DFS) esplora il grafo seguendo i percorsi più profondi possibili prima di fare *backtrack*. A differenza della BFS (che usa una coda e una sorgente fissa), la DFS:
- esplora *tutto il grafo* (non solo la componente di una sorgente);
- produce una *foresta DF* (più alberi, non uno solo);
- assegna a ogni vertice due *timestamp*: $v.d$ (scoperta) e $v.f$ (fine ispezione).

=== Algoritmo

Per ogni vertice $v in V$ si mantengono:
- $v."color" in {B, G, N}$: stato di visita (bianco, grigio, nero)
- $v.Pi$: predecessore nella foresta DF
- $v.d$: tempo di scoperta
- $v.f$: tempo di completamento

I timestamp sono interi in $[1, 2|V|]$ con $v.d < v.f$.

#algoritmo(titolo: "DFS(G)")[
  ```
  DFS(G) {
      for (u in V) {
          u.color = B;
          u.π = NIL;
      }
      time = 0;
      for (u in V) {
          if (u.color == B)
              DFS-VISIT(G, u);
      }
  }
  ```
]

#algoritmo(titolo: "DFS-VISIT(G, u)")[
  ```
  DFS-VISIT(G, u) {
      time = time + 1;
      u.d = time;          // u scoperto
      u.color = G;
      for (v in Adj[u]) {
          if (v.color == B) {
              v.π = u;
              DFS-VISIT(G, v);
          }
      }
      u.color = N;
      time = time + 1;
      u.f = time;          // u completato
  }
  ```
]

Ogni volta che si chiama `DFS-VISIT(u)` nella procedura principale, $u$ diventa la radice di un nuovo albero della foresta DF.

=== Complessità

Ogni vertice viene colorato di grigio esattamente una volta (la prima istruzione di DFS-VISIT colora grigio): DFS-VISIT è chiamata esattamente una volta per vertice.

- Cicli di inizializzazione e for principale: $Theta(|V|)$
- Corpo di DFS-VISIT: per ogni vertice $u$, si esaminano $|"Adj"[u]|$ vicini; la somma è $Theta(|E|)$

$ T(|V|, |E|) = Theta(|V| + |E|) $

=== Foresta DF e struttura di parentesi

#definizione(titolo: "Foresta DF")[
  Il *sottografo dei predecessori* $G_Pi = (V_Pi, E_Pi)$ con $V_Pi = V$ e $E_Pi = {(v.Pi, v) : v in V,\ v.Pi eq.not "NIL"}$ è la *foresta DF* (depth-first forest). Ogni albero della foresta è un *albero DF* (depth-first tree).
]

#osservazione[
  $u = v.Pi$ se e solo se DFS-VISIT$(v)$ è stata chiamata durante l'ispezione della lista di adiacenza di $u$. Il vertice $v$ è discendente di $u$ nella foresta DF se e solo se $v$ è stato scoperto mentre $u$ era grigio.
]

I timestamp hanno una struttura di *parentesi*: se rappresentiamo la scoperta di $u$ con $(u$ e il suo completamento con $u)$, la storia della visita forma un'espressione con parentesi correttamente annidate.

#teorema(titolo: "Teorema delle Parentesi [CLRS: Teo. 22.7]")[
  In qualsiasi DFS di $G$ (orientato o non orientato), per ogni coppia $u, v in V$ vale esattamente una delle tre condizioni:
  + $[u.d, u.f]$ e $[v.d, v.f]$ sono *disgiunti*: $u$ e $v$ non sono discendenti l'uno dell'altro.
  + $[v.d, v.f] subset [u.d, u.f]$: $v$ è *discendente* di $u$ in un albero DF.
  + $[u.d, u.f] subset [v.d, v.f]$: $u$ è *discendente* di $v$ in un albero DF.
]

#dimostrazione[
  Supponiamo $u.d < v.d$ (l'altro caso è simmetrico).

  *Caso 1: $u.f < v.d$*. Gli intervalli sono disgiunti ($u.d < u.f < v.d < v.f$). Poiché nessuno dei due è stato scoperto mentre l'altro era grigio, non c'è relazione di discendenza.

  *Caso 2: $u.f > v.d$*. Il vertice $v$ è stato scoperto mentre $u$ era grigio, quindi $v$ è discendente di $u$. Poiché $v$ è stato scoperto dopo $u$, tutti i suoi archi vengono ispezionati e la sua visita completata prima di $u$: $v.d < v.f < u.f$, e quindi $[v.d, v.f] subset [u.d, u.f]$.
]

#corollario(titolo: "Annidamento degli intervalli [CLRS: Cor. 22.8]")[
  Il vertice $v$ è un discendente proprio di $u$ nella foresta DF se e solo se:
  $ u.d < v.d < v.f < u.f $
]

=== Teorema del Cammino Bianco

#teorema(titolo: "Teorema del Cammino Bianco [CLRS: Teo. 22.9]")[
  Nella foresta DF di $G$, il vertice $v$ è un discendente di $u$ se e solo se, al tempo $u.d$ in cui $u$ viene scoperto, il vertice $v$ è raggiungibile da $u$ lungo un cammino composto esclusivamente da vertici *bianchi*.
]

#dimostrazione[
  $arrow.double.r$) Se $v = u$: il cammino contiene solo $u$, bianco al tempo $u.d$. Se $v$ è discendente proprio di $u$: per il Corollario, $u.d < v.d$, quindi $v$ è bianco al tempo $u.d$. Tutti i vertici sul cammino unico da $u$ a $v$ nella foresta DF sono bianchi al tempo $u.d$ (scoperti dopo $u$).

  $arrow.double.l$) Per assurdo: esiste cammino bianco da $u$ a $v$ al tempo $u.d$, ma $v$ non diventa discendente di $u$. Sia $v$ il vertice più vicino a $u$ lungo il cammino che non diventa discendente. Sia $w$ il suo predecessore sul cammino ($w$ è discendente di $u$, quindi $w.f <= u.f$). Poiché $v in "Adj"[w]$ e $v$ è bianco al tempo $u.d < w.d$, la visita di $w$ scopre $v$: $v$ diventa discendente di $w$ e quindi di $u$. Contraddizione.
]

=== Classificazione degli archi

La DFS classifica ogni arco $(u,v)$ in base al colore di $v$ quando l'arco viene ispezionato per la prima volta [CLRS: p. 509]:

#table(
  columns: (auto, auto, auto),
  align: (left, left, left),
  stroke: 0.5pt,
  [*Tipo*], [*Condizione (colore di $v$)*], [*Descrizione*],
  [Arco d'albero], [$v$ è *Bianco*], [$(u,v) in E_Pi$; $v$ scoperto esaminando $(u,v)$],
  [Arco all'indietro], [$v$ è *Grigio*], [$v$ è antenato di $u$ nella foresta DF],
  [Arco in avanti], [$v$ è *Nero*, $u.d < v.d$], [$v$ è discendente non diretto di $u$],
  [Arco trasversale], [$v$ è *Nero*, $u.d > v.d$], [$u$ e $v$ non sono in relazione di discendenza],
)

#osservazione[
  *Caratterizzazione tramite timestamp:*
  - Arco d'albero o in avanti: $u.d < v.d < v.f < u.f$
  - Arco all'indietro: $v.d <= u.d < u.f <= v.f$
  - Arco trasversale: $v.d < v.f < u.d < u.f$
]

#teorema(titolo: "Archi nei grafi non orientati [CLRS: Teo. 22.10]")[
  In una DFS di un grafo *non orientato* $G$, ogni arco è un arco d'albero o un arco all'indietro. Non esistono archi in avanti né archi trasversali.
]

#dimostrazione[
  Sia $(u,v) in E$ con $u.d < v.d$ (senza perdita di generalità). Il vertice $v$ è nella lista di adiacenza di $u$, quindi viene scoperto e completato mentre $u$ è grigio: $[v.d, v.f] subset [u.d, u.f]$.

  *Caso 1*: $(u,v)$ viene ispezionato per la prima volta da $u$ verso $v$. Allora $v$ è bianco (non ancora scoperto, poiché avremmo già visto l'arco da $v$ verso $u$): arco d'albero.

  *Caso 2*: $(u,v)$ viene ispezionato per la prima volta da $v$ verso $u$. Allora $u$ è grigio (ancora in visita): arco all'indietro.
]

=== Grafi ciclici e archi all'indietro

#lemma(titolo: "Aciclicità e archi all'indietro [CLRS: Lemma 22.11]")[
  Un grafo orientato $G$ è *aciclico* se e solo se una DFS di $G$ non genera archi all'indietro.
]

#dimostrazione[
  $arrow.double.r$) Se $(u,v)$ è un arco all'indietro, $v$ è antenato di $u$: esiste cammino $v arrow.squiggly u$, e l'arco $(u,v)$ forma un ciclo.

  $arrow.double.l$) Se $G$ contiene un ciclo $c$, sia $v$ il primo vertice scoperto in $c$ e $(u,v)$ l'arco che lo precede. Al tempo $v.d$, tutti i vertici di $c$ sono bianchi, quindi esiste cammino bianco da $v$ a $u$. Per il Teorema del Cammino Bianco, $u$ diventa discendente di $v$, e $(u,v)$ è un arco all'indietro.
]
