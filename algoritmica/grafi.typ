#import "../template.typ": *

== Definizione di Grafo

#definizione(titolo: "Grafo")[
  Un *grafo* $G = (V, E)$ è una coppia di insiemi finiti:
  - $V$: insieme dei *vertici* (o *nodi*), che rappresentano oggetti;
  - $E subset.eq V times V$: insieme degli *archi* (coppie di nodi), che rappresentano relazioni tra oggetti.

  I grafi si dividono in:
  - *non orientati*: $E$ è un insieme di coppie _non ordinate_ $\{u, v\}$. L'arco può essere percorso in entrambe le direzioni: $(u,v)$ e $(v,u)$ rappresentano lo stesso arco.
  - *orientati* (o *diretti*): $E$ è un insieme di coppie _ordinate_ $(u, v)$. L'arco ha una direzione fissa da $u$ verso $v$: $(u,v)$ e $(v,u)$ sono archi distinti.

  La *dimensione* del grafo è $|V| + |E| = n + m$, con $n = |V|$ (*ordine*) e $m = |E|$.
]

#nota(titolo: "Coppia ordinata vs non ordinata")[
  Una *coppia non ordinata* $\{u,v\}$ è un insieme di due elementi: $\{u,v\} = \{v,u\}$ (l'ordine non conta). Una *coppia ordinata* $(u,v)$ distingue il primo dal secondo elemento: $(u,v) eq.not (v,u)$. Intuitivamente, una strada a doppio senso è un arco non orientato; una strada a senso unico è un arco orientato.
]

#definizione(titolo: "Adiacenza e incidenza")[
  Dato un arco $(u, v) in E$:
  - i vertici $u$ e $v$ sono *adiacenti* (si "vedono" direttamente tramite un arco);
  - l'arco $(u,v)$ è *incidente* sui vertici $u$ e $v$ (li "tocca");
  - $u$ e $v$ sono gli *estremi* dell'arco.

  Nei grafi orientati si specifica inoltre che l'arco $(u,v)$ *esce* da $u$ ed *entra* in $v$.
]

#nota[Per grafi non orientati vale $0 <= m <= binom(n, 2) = n(n-1)/2$ (ogni coppia di vertici può avere al più un arco); per grafi orientati $0 <= m <= n(n-1)$ (ogni coppia ordinata può avere al più un arco, quindi il doppio).]

La *densità* di un grafo misura quanti archi contiene rispetto al massimo teorico. Poiché il numero massimo di archi cresce come $Theta(n^2)$, si distinguono due categorie in base alla *velocità di crescita* di $m$ al crescere di $n$:

- *Grafo sparso*: $m = O(n)$. Il numero di archi cresce _linearmente_ con il numero di vertici. Significa che, in media, ogni vertice è collegato a un numero _costante_ di altri vertici (non dipendente da $n$).

  _Esempi:_
  - Una rete stradale: ogni incrocio ha tipicamente 3-4 strade, indipendentemente da quanti incroci totali ci siano in città.
  - Un social network con le sole "amicizie strette": ogni persona ne ha circa 5-10.
  - Un albero: ha sempre $m = n - 1$ archi, qualunque sia $n$.

- *Grafo denso*: $m = Theta(n^2)$. Il numero di archi cresce _quadraticamente_: ogni vertice è collegato a una _frazione_ di tutti gli altri (ad es. alla metà).

  _Esempio estremo:_ il *grafo completo*, indicato con $K_n$, in cui ogni coppia di vertici distinti è collegata. Ha $m = binom(n,2) = n(n-1)/2 = Theta(n^2)$ archi: è il grafo più denso possibile.

#osservazione[
  La parola _asintotica_ significa: guardiamo come si comporta $m$ quando $n$ diventa grande, non il valore preciso di $m$ per un $n$ fissato. Per questo non esiste una soglia esatta "sotto $k$ archi è sparso, sopra è denso": dipende da come $m$ e $n$ si relazionano al crescere di $n$.

  Per dare un'idea concreta: un grafo con $n = 10$ vertici e $m = 40$ archi è _denso_ (molto vicino al massimo di $binom(10,2) = 45$), mentre $n = 10^6$ vertici con $m = 10^6$ archi è _sparso_ (in media ogni vertice ha un solo arco).
]

La distinzione è importante perché determina *due scelte pratiche*:

+ *Scelta della rappresentazione in memoria*:
  - Per grafi *densi* conviene la *matrice di adiacenza* (una tabella $n times n$): occupa $Theta(n^2)$ celle, che è lo stesso ordine di $m$, quindi nessuno spreco; in compenso permette di verificare in $O(1)$ se due vertici sono adiacenti.
  - Per grafi *sparsi* conviene le *liste di adiacenza* (un array di $n$ liste): occupa $Theta(n + m)$ spazio, che per grafi sparsi equivale a $Theta(n)$ — molto meno di $Theta(n^2)$.

  Entrambe le rappresentazioni sono descritte in dettaglio più avanti.

+ *Scelta dell'algoritmo*: alcuni algoritmi hanno due versioni con costi diversi a seconda di come sono implementate le strutture interne. Ad esempio, l'algoritmo di Dijkstra costa $O(n^2)$ se $"PQ"$ è un array (adatto ai grafi densi) e $O((n + m) log n)$ se $"PQ"$ è un MIN-heap binario (adatto ai grafi sparsi).

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
  - $forall i, 1 <= i <= k: (x_(i-1), x_i) in E$

  La *lunghezza* del cammino è $k$ (numero di archi). Un cammino è *semplice* se tutti i vertici sono distinti. Un *ciclo* è un cammino che torna al vertice di partenza ($x_k = u$).
]

#definizione(titolo: "Distanza e cammino minimo")[
  La *distanza* $delta(u,v)$ tra due vertici è il numero minimo di archi da percorrere per spostarsi da $u$ a $v$:
  $ delta(u,v) = cases("lunghezza minima di un cammino " u arrow.squiggly v & "se esiste un cammino " u arrow.squiggly v, +infinity & "altrimenti") $
  Un *cammino minimo* da $u$ a $v$ è un cammino semplice di lunghezza $delta(u,v)$.
]

#esempio[
  Grafo con $V = {1,2,3,4,5,6,7}$, $E = {(1,2),(1,3),(1,4),(2,3),(2,4),(3,4),(3,5),(3,6),(5,6)}$.

  #align(center, cetz.canvas({
    import cetz.draw: *
    let pos = (
      "1": (0, 2),
      "2": (2, 2),
      "3": (2, 0),
      "4": (0, 0),
      "5": (4, 0),
      "6": (4, 2),
      "7": (6, 1),
    )
    let archi = (("1","2"),("1","3"),("1","4"),("2","3"),("2","4"),("3","4"),("3","5"),("3","6"),("5","6"))
    for (u, v) in archi {
      line(pos.at(u), pos.at(v), stroke: 0.6pt + black)
    }
    for (nome, p) in pos.pairs() {
      circle(p, radius: 0.3, fill: white, stroke: 0.6pt + black)
      content(p, text(size: 9pt)[#nome])
    }
  }))

  - $delta(1,5) = 2$: cammino $chevron.l 1, 3, 5 chevron.r$
  - $chevron.l 1, 4, 2, 3, 5 chevron.r$: cammino di lunghezza 4, non minimo
  - $chevron.l 3, 6, 5, 3 chevron.r$: ciclo
  - $chevron.l 1, 2, 4, 1, 3 chevron.r$: non è un cammino semplice (il vertice 1 appare due volte)
  - $delta(1,7) = +infinity$: il vertice 7 è isolato, non raggiungibile da nessun altro vertice
  - $sum_(v in V) delta(v) = 18 = 2 dot 9$, coerente con $sum_(v in V) delta(v) = 2|E|$
]

=== Grafo completo, connesso, sottografo

#definizione(titolo: "Grafo completo (Clique)")[
  Un grafo è *completo* (o *clique*) se ogni coppia di vertici distinti è adiacente:
  $forall u, v in V, u eq.not v: (u,v) in E$. In un grafo completo $m = binom(n,2)$.
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
  Un *cammino orientato* $u arrow.squiggly v$ è un cammino i cui archi sono orientati nel verso corretto: $forall i, 1 <= i <= k: (x_(i-1), x_i) in E$.

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

#definizione(titolo: "Albero (libero)")[
  Un *albero (libero)* è un grafo non orientato, connesso e aciclico.
]

#teorema(titolo: "Proprietà degli alberi liberi [CLRS: Teo. B.2]")[
  Sia $G = (V,E)$ un grafo non orientato. Le seguenti affermazioni sono equivalenti:
  + $G$ è un albero.
  + Due vertici qualsiasi di $G$ sono collegati da un unico cammino semplice.
  + $G$ è connesso, ma la rimozione di un arco qualsiasi lo disconnette.
  + $G$ è connesso e $|E| = |V| - 1$.
  + $G$ è aciclico e $|E| = |V| - 1$.
  + $G$ è aciclico, ma l'aggiunta di un arco qualsiasi crea un ciclo.
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
  columns: (auto, auto, auto, auto),
  align: (left, left, center, left),
  stroke: 0.5pt,
  [*Operazione*], [*Restituisce*], [*Costo*], [*Come*],
  [`adiacenti(u, v)`], [booleano: `true` se $(u,v) in E$, `false` altrimenti], [$O(1)$], [return $A[u,v]$],
  [`grado(u)`], [intero: numero di archi incidenti su $u$], [$Theta(n)$], [scorrere la riga $u$ di $A$ e contare gli 1],
  [`aggiungiArco(u, v)`], [nulla (effetto: aggiunge l'arco al grafo)], [$O(1)$], [$A[u,v] = 1$ (e $A[v,u] = 1$ se non orientato)],
  [`rimuoviArco(u, v)`], [nulla (effetto: rimuove l'arco dal grafo)], [$O(1)$], [$A[u,v] = 0$ (e $A[v,u] = 0$ se non orientato)],
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
  columns: (auto, auto, auto, auto),
  align: (left, left, center, left),
  stroke: 0.5pt,
  [*Operazione*], [*Restituisce*], [*Costo*], [*Come*],
  [`adiacenti(u, v)`], [booleano: `true` se $(u,v) in E$, `false` altrimenti], [$O(delta(u))$], [cercare $v$ scorrendo la lista $"Adj"[u]$],
  [`grado(u)`], [intero: numero di archi incidenti su $u$], [$Theta(delta(u))$], [calcolare la lunghezza di $"Adj"[u]$],
  [`aggiungiArco(u, v)`], [nulla (effetto: aggiunge l'arco al grafo)], [$O(1)$], [inserire $v$ in $"Adj"[u]$ (e $u$ in $"Adj"[v]$ se non orientato), liste non ordinate],
  [`rimuoviArco(u, v)`], [nulla (effetto: rimuove l'arco dal grafo)], [$O(delta(u)+delta(v))$], [cercare ed eliminare $v$ da $"Adj"[u]$ e $u$ da $"Adj"[v]$],
)

#osservazione[
  Per grafi sparsi ($m = O(n)$), le liste di adiacenza usano $Theta(n)$ spazio contro $Theta(n^2)$ della matrice. Lo svantaggio è che determinare se $(u,v) in E$ richiede $O(delta(u))$ invece di $O(1)$.
]

#ricorda[
  La scelta della rappresentazione dipende dalla densità del grafo e dalle operazioni richieste:
  - *Matrice di adiacenza*: adiacenza in $O(1)$, ma spazio $Theta(n^2)$. Preferibile per grafi densi.
  - *Liste di adiacenza*: spazio $Theta(n+m)$, adiacenza in $O(delta(u))$. Preferibile per grafi sparsi.
]
