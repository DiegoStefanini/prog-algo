#import "../template.typ": *

== Definizione di Grafo

#definizione(titolo: "Grafo")[
  Un *grafo* $G = (V, E)$ è una coppia di insiemi finiti:
  - $V$: insieme dei *vertici* (o nodi), che rappresentano oggetti;
  - $E subset.eq V times V$: insieme degli *archi* (coppie di nodi), che rappresentano relazioni tra oggetti.

  I grafi si dividono in:
  - *non orientati*: $E$ è un insieme di coppie _non ordinate_;
  - *orientati* (o diretti): $E$ è un insieme di coppie _ordinate_.

  La *dimensione* del grafo è $|V| + |E| = n + m$, con $n = |V|$ (*ordine*) e $m = |E|$.
]

#nota[Per grafi non orientati vale $0 <= m <= binom(n, 2) = n(n-1)/2$; per grafi orientati $0 <= m <= n(n-1)$.]

Si distinguono:
- *Grafo sparso*: $m = O(n)$
- *Grafo denso*: $m = Theta(n^2)$

== Grafi non orientati

=== Grado, cammino, ciclo

#definizione(titolo: "Grado di un vertice")[
  Il *grado* di un vertice $v$ è $delta(v) = $ numero di archi incidenti su $v$.
  Un vertice è *isolato* se $delta(v) = 0$.
]

Vale la seguente proprietà:
$ sum_(v in V) delta(v) = 2|E| = 2m $
poiché ogni arco contribuisce per un fattore 2 (incrementa il grado dei due estremi).

#definizione(titolo: "Cammino")[
  Un *cammino* da $u$ a $v$ in $G$ è una sequenza di vertici $x_0, x_1, dots, x_k$ tale che:
  - $x_0 = u$, $x_k = v$
  - $forall i,\ 1 <= i <= k:\ (x_(i-1), x_i) in E$

  La *lunghezza* del cammino è $k$ (numero di archi). Un cammino è *semplice* se tutti i vertici sono distinti. Un *ciclo* è un cammino che torna al vertice di partenza ($x_k = u$).
]

#definizione(titolo: "Distanza e cammino minimo")[
  La *distanza* $delta(u,v)$ tra due vertici è il numero minimo di archi da percorrere per spostarsi da $u$ a $v$. Un *cammino minimo* è un cammino semplice di lunghezza $delta(u,v)$.
]

#esempio[
  Grafo con $V = {1,2,3,4,5,6,7}$, $E = {(1,2),(1,3),(1,4),(2,3),(2,4),(3,4),(3,5),(3,6),(5,6)}$.

  - $delta(1,5) = 2$: cammino $chevron.l 1, 3, 5 chevron.r$
  - $chevron.l 1, 4, 2, 3, 5 chevron.r$: cammino di lunghezza 4, non minimo
  - $chevron.l 3, 6, 5, 3 chevron.r$: ciclo
  - $chevron.l 1, 2, 4, 1, 3 chevron.r$: non è un cammino semplice (il vertice 1 appare due volte)
  - $sum_(v in V) delta(v) = 18 = 2 dot 9$
]

=== Grafo completo, connesso, sottografo

#definizione(titolo: "Grafo completo (Clique)")[
  Un grafo è *completo* (o *clique*) se ogni coppia di vertici distinti è adiacente:
  $forall u, v in V,\ u eq.not v:\ (u,v) in E$. In un grafo completo $m = binom(n,2)$.
]

#definizione(titolo: "Grafo connesso")[
  Un grafo è *connesso* se ogni coppia di vertici è connessa, cioè per ogni $u, v in V$ esiste un cammino da $u$ a $v$ ($delta(u,v) < +infinity$).

  In un grafo connesso, da ogni vertice è possibile raggiungere tutti gli altri.
]

#definizione(titolo: "Sottografo")[
  $G' = (V', E')$ è un *sottografo* di $G = (V, E)$ se $V' subset.eq V$ e $E' subset.eq V' times V'$, $E' subset.eq E$.
]

#definizione(titolo: "Componente connessa")[
  Una *componente connessa* di $G$ è un sottografo $G'$ di $G$ che è connesso e *massimale* (non può essere esteso: non esistono altri nodi in $G$ connessi ai nodi di $G'$).

  Le componenti connesse sono le classi di equivalenza della relazione "è raggiungibile da".
  Un grafo connesso è composto da una sola componente connessa.
]

== Grafi orientati

=== Grado, cammino orientato, connessione forte

#definizione(titolo: "Grafi orientati")[
  In un *grafo orientato* $G = (V, E)$, l'arco $(u,v) in E$ è *diretto* da $u$ a $v$: può essere percorso solo in quella direzione. Si noti che $(u,v) eq.not (v,u)$.

  Per ogni vertice $v in V$:
  - *grado uscente* $delta_u(v)$ = numero di archi che escono da $v$
  - *grado entrante* $delta_e(v)$ = numero di archi che entrano in $v$
  - $delta(v) = delta_u(v) + delta_e(v)$

  Vale: $sum_(v in V) delta_e(v) = sum_(v in V) delta_u(v) = m$.

  Per grafi orientati: $0 <= m <= n(n-1)$.
]

#definizione(titolo: "Cammino orientato e ciclo orientato")[
  Un *cammino orientato* $u arrow.squiggly v$ è un cammino i cui archi sono orientati nel verso corretto: $forall i,\ 1 <= i <= k:\ (x_(i-1), x_i) in E$.

  Un *ciclo orientato* è un cammino orientato che torna al vertice di partenza.
]

#definizione(titolo: "Connessione forte")[
  Due vertici $u, v in V$ sono *fortemente connessi* se esistono sia un cammino orientato $u arrow.squiggly v$ sia uno $v arrow.squiggly u$ (sono *mutuamente raggiungibili*).

  Un grafo orientato è *fortemente connesso* se ogni coppia ordinata di nodi è fortemente connessa.
]

#definizione(titolo: "Componenti fortemente connesse")[
  Le *componenti fortemente connesse* di un grafo orientato sono i sottografi fortemente connessi e massimali. Sono le classi di equivalenza della relazione "sono mutuamente raggiungibili".
]

#esempio[
  Grafo orientato con $V = {1,2,3,4}$, archi $(1,2),(2,4),(4,3),(3,2),(1,3)$:
  - $chevron.l 2,4,3,2 chevron.r$ è un ciclo orientato
  - $chevron.l 1,2,4,3 chevron.r$ è un cammino orientato
  - I vertici 2, 3, 4 sono fortemente connessi (componente $\{2,3,4\}$)
  - Il vertice 1 non è fortemente connesso agli altri (non esiste cammino verso 1)
]

=== Grafi aciclici, alberi, foreste

#definizione(titolo: "Grafo aciclico")[
  Un grafo (orientato o non orientato) è *aciclico* se non contiene cicli.
]

#definizione(titolo: "Albero")[
  Un *albero* è un grafo non orientato, connesso e aciclico. Equivalentemente:
  - grafo non orientato, connesso, con $|E| = |V| - 1$
  - grafo non orientato, aciclico, con $|E| = |V| - 1$
]

#definizione(titolo: "Foresta")[
  Una *foresta* è un grafo non orientato e aciclico le cui componenti connesse sono alberi.
]

== Rappresentazione dei grafi in memoria

=== Matrice di adiacenza

#definizione(titolo: "Matrice di adiacenza")[
  Dato $G = (V,E)$ con $|V| = n$, la *matrice di adiacenza* è una matrice $A$ di dimensione $n times n$ con valori in $\{0,1\}$:
  $ A[i,j] = cases(1 & "(i,j)" in E, 0 & "(i,j)" in.not E) $

  Per grafi non orientati, $A$ è simmetrica ($A[i,j] = A[j,i]$).
]

Costo in spazio: $S(n,m) = Theta(n^2)$. Va bene per grafi densi; inefficiente per grafi sparsi.

#table(
  columns: (auto, auto, auto),
  align: (left, center, left),
  stroke: 0.5pt,
  [*Operazione*], [*Costo*], [*Note*],
  [`adiacenti(u, v)`], [$O(1)$], [return $A[u,v]$],
  [`grado(u)`], [$Theta(n)$], [scorrere la riga $u$ di $A$],
  [`aggiungiArco(u, v)`], [$O(1)$], [$A[u,v] = 1$ (e $A[v,u] = 1$ se non orientato)],
  [`rimuoviArco(u, v)`], [$O(1)$], [$A[u,v] = 0$ (e $A[v,u] = 0$ se non orientato)],
)

=== Liste di adiacenza

#definizione(titolo: "Liste di adiacenza")[
  La rappresentazione con *liste di adiacenza* associa ad ogni vertice $u$ la lista $"Adj"[u]$ dei vertici adiacenti:
  $ "Adj"[u] = cases("NIL" & delta(u) = 0, "lista dei vertici" v "t.c." (u,v) in E & "altrimenti") $
  $"Adj"$ è un array di $n = |V|$ liste.
]

Costo in spazio: $S(n,m) = Theta(n+m)$ (lineare nella dimensione del grafo).

Per grafi non orientati: $sum_(v in V) |"Adj"[v]| = 2|E|$ (ogni arco è rappresentato due volte).

Per grafi orientati: $sum_(v in V) |"Adj"[v]| = |E|$ (ogni arco è rappresentato una sola volta).

#table(
  columns: (auto, auto, auto),
  align: (left, center, left),
  stroke: 0.5pt,
  [*Operazione*], [*Costo*], [*Note*],
  [`adiacenti(u, v)`], [$O(delta(u))$], [cercare $v$ nella lista $"Adj"[u]$],
  [`grado(u)`], [$Theta(delta(u))$], [lunghezza di $"Adj"[u]$],
  [`aggiungiArco(u, v)`], [$O(1)$], [liste non ordinate],
  [`rimuoviArco(u, v)`], [$O(delta(u)+delta(v))$], [eliminare $v$ da $"Adj"[u]$ e $u$ da $"Adj"[v]$],
)

#osservazione[
  Per grafi sparsi ($m = O(n)$), le liste di adiacenza usano $Theta(n)$ spazio contro $Theta(n^2)$ della matrice. Lo svantaggio è che determinare se $(u,v) in E$ richiede $O(delta(u))$ invece di $O(1)$.
]

#ricorda[
  La scelta della rappresentazione dipende dalla densità del grafo e dalle operazioni richieste:
  - *Matrice di adiacenza*: adiacenza in $O(1)$, ma spazio $Theta(n^2)$. Preferibile per grafi densi.
  - *Liste di adiacenza*: spazio $Theta(n+m)$, adiacenza in $O(delta(u))$. Preferibile per grafi sparsi.
]
