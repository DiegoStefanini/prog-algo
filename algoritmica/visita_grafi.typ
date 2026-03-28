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
