#import "../template.typ": *

== Modello di calcolo e costo computazionale

In questo capitolo introduciamo gli strumenti fondamentali per analizzare l'efficienza degli algoritmi. Dato un problema computazionale, esistono in generale molteplici algoritmi che lo risolvono: il nostro obiettivo è confrontarli in modo rigoroso, determinando quale sia il più efficiente in termini di risorse utilizzate. Per fare ciò, abbiamo bisogno di un modello di calcolo di riferimento e di un linguaggio matematico per esprimere il costo degli algoritmi.

=== Modello di calcolo RAM

Per poter contare le operazioni eseguite da un algoritmo, occorre fissare un modello di calcolo. Il modello adottato nel corso è il *modello RAM* (Random Access Machine), che formalizza un calcolatore idealizzato.

#definition(title: "Modello RAM a costo unitario")[
  Nel modello RAM a costo unitario, le seguenti operazioni hanno ciascuna costo costante (pari a 1):
  - *Operazioni aritmetiche*: $+, -, times, div, %$
  - *Operazioni di confronto*: $<, >, <=, >=, ==, !=$
  - *Operazioni logiche*: $and, or, not$
  - *Operazioni di trasferimento*: lettura e scrittura in memoria, assegnamento
  - *Operazioni di controllo*: `return`, chiamata a funzione, salto condizionale
  La memoria è ad accesso casuale: l'accesso a qualsiasi cella ha costo costante, indipendentemente dal suo indirizzo.
]

#note[
  Il modello RAM a costo unitario è una semplificazione: in un calcolatore reale, il costo di un'operazione può dipendere dalla dimensione degli operandi (ad esempio, moltiplicare due numeri di 1000 cifre è più costoso che moltiplicare due numeri di una cifra). Tuttavia, per gli scopi del corso, questa approssimazione è adeguata e consente di concentrarsi sugli aspetti strutturali degli algoritmi.
]

=== Costo computazionale di un algoritmo

Dato un algoritmo $A$ e un input di dimensione $n$, definiamo il *costo computazionale* come la quantità di risorse richieste dalla sua esecuzione.

#definition(title: "Costo in tempo")[
  Il *costo in tempo* $T_A (n)$ di un algoritmo $A$ è il numero di operazioni elementari (passi) che $A$ esegue su un input di dimensione $n$ nel modello RAM.
]

#definition(title: "Costo in spazio")[
  Il *costo in spazio* $S_A (n)$ di un algoritmo $A$ è il numero di celle di memoria utilizzate durante l'esecuzione di $A$ su un input di dimensione $n$, incluse quelle occupate dall'input stesso.
]

In generale, il costo in tempo di un algoritmo non dipende solo dalla dimensione dell'input, ma anche dalla specifica istanza. Per questo si distinguono tre casi.

#definition(title: "Caso ottimo, pessimo e medio")[
  Sia $I_n$ l'insieme di tutte le istanze di dimensione $n$ per un dato problema. Il costo in tempo di un algoritmo $A$ si descrive come:
  - *Caso ottimo*: $T_A^"best" (n) = min_(I in I_n) T_A (I)$ -- il minimo numero di operazioni su tutte le istanze di dimensione $n$.
  - *Caso pessimo*: $T_A^"worst" (n) = max_(I in I_n) T_A (I)$ -- il massimo numero di operazioni su tutte le istanze di dimensione $n$.
  - *Caso medio*: $T_A^"avg" (n) = sum_(I in I_n) P(I) dot T_A (I)$ -- il costo atteso, dove $P(I)$ è la probabilità dell'istanza $I$.
]

Nell'analisi degli algoritmi ci concentreremo principalmente sul *caso pessimo*, poiché fornisce una garanzia sul costo massimo. Il caso medio è spesso più informativo nella pratica, ma richiede ipotesi sulla distribuzione degli input.

A parità di complessità in tempo, si cerca di minimizzare anche la complessità in spazio.

=== Esempio: Minimo in un vettore

Consideriamo il problema di trovare il valore minimo in un array.

*Input*: array $A[1..n]$ di interi. \
*Output*: il valore minimo $m$ tale che $m = A[i]$ per qualche $i in {1, ..., n}$ e $m <= A[j]$ per ogni $j in {1, ..., n}$.

#algorithm(title: "Minimo di un array")[
  ```
  int min(int[] A, int n){
      int min = A[1];
      int i = 2;
      while(i <= n){
          if(A[i] < min){
              min := A[i];
          }
          i := i + 1;
      }
      return min;
  }
  ```
]

*Analisi del costo.* Tutte le operazioni nel corpo del ciclo (`if`, confronto, eventuale assegnamento, incremento) hanno costo costante nel modello RAM. Il ciclo `while` viene eseguito esattamente $n - 1$ volte, indipendentemente dai valori contenuti nell'array. Il costo totale è quindi:

$ T(n) = c_1 + (n - 1) dot c_2 + c_3 $

dove $c_1, c_3$ sono costanti per le operazioni fuori dal ciclo e $c_2$ è il costo costante di ciascuna iterazione. La complessità in tempo è *lineare* nella dimensione $n$ dell'input. Si noti che in questo caso il costo non dipende dalla specifica istanza: caso ottimo, pessimo e medio coincidono.

=== Esempio: Ricerca di un elemento

Consideriamo il problema della ricerca lineare (o sequenziale).

*Input*: array $A[1..n]$ di interi, intero $k$. \
*Output*: il minimo indice $i$ tale che $A[i] = k$, oppure $-1$ se $k in.not A$.

#algorithm(title: "Ricerca lineare (CercaK)")[
  ```
  int cercaK(int[] A, int n, int k){
      int i = 1;
      bool trovato = false;
      while((!trovato) && (i <= n)){
          if(A[i] == k){
              trovato := true;
          } else {
              i := i + 1;
          }
      }
      if(trovato){
          return i;
      } else {
          return -1;
      }
  }
  ```
]

*Analisi del costo.* A differenza dell'esempio precedente, il numero di iterazioni dipende dalla posizione di $k$ nell'array:

- *Caso ottimo*: $A[1] = k$, il ciclo esegue una sola iterazione. Il costo è $T^"best"(n) = Theta(1)$ (costante).
- *Caso pessimo*: $k in.not A$, il ciclo scorre l'intero array senza trovare $k$. Il costo è $T^"worst"(n) = Theta(n)$ (lineare).
- *Caso medio*: assumendo che $k$ sia presente e che ciascuna posizione sia equiprobabile, il numero medio di confronti è $(n+1)/2$, dunque $T^"avg"(n) = Theta(n)$.

Questo esempio mostra come lo stesso algoritmo possa avere costi significativamente diversi a seconda dell'istanza, motivando la distinzione tra caso ottimo e pessimo.

=== Complessità asintotica

L'obiettivo dell'analisi di complessità non è calcolare il numero esatto di operazioni, ma determinare *l'ordine di grandezza* della funzione di costo $T(n)$ al crescere di $n$. Si trascurano:
- le *costanti moltiplicative*, che dipendono dal modello di calcolo e dall'implementazione;
- i *termini di ordine inferiore*, che diventano trascurabili per $n$ grande.

#example(title: "Complessità lineare")[
  $ T(n) = 3n + 2 $
  Il termine dominante è $3n$. Trascurando la costante moltiplicativa 3 e il termine di ordine inferiore 2, si conclude che $T(n)$ ha ordine di grandezza *lineare*.
]

#example(title: "Complessità quadratica")[
  $ T(n) = 8n^2 + log n + 4 $
  Il termine dominante è $8n^2$. I termini $log n$ e $4$ sono di ordine inferiore e vengono trascurati. La complessità è *quadratica*.
]

Per formalizzare queste nozioni, introduciamo la *notazione asintotica*.

=== Notazione $Theta$ -- Limite asintotico stretto

#definition(title: [$Theta$ (Theta)])[
  Sia $g(n)$ una funzione. L'insieme $Theta(g(n))$ è definito come:
  $ Theta(g(n)) = {f(n) mid(|) exists c_1, c_2, n_0 > 0 : forall n >= n_0, quad 0 <= c_1 dot g(n) <= f(n) <= c_2 dot g(n)} $

  Se $f(n) in Theta(g(n))$, si dice che $g(n)$ è un *limite asintotico stretto* per $f(n)$.
]

Si scrive $f(n) = Theta(g(n))$ (con abuso di notazione, poiché $Theta(g(n))$ è un insieme).

#figure(
  image("../images/big_theta.jpg", width: 25%),
  caption: [Rappresentazione grafica di $Theta(g(n))$: per $n >= n_0$, la funzione $f(n)$ è compresa tra $c_1 dot g(n)$ e $c_2 dot g(n)$.]
)

Intuitivamente, $f(n) = Theta(g(n))$ significa che, per $n$ sufficientemente grande, $f(n)$ cresce *allo stesso ritmo* di $g(n)$, a meno di costanti moltiplicative.

=== Notazione $O$ -- Limite asintotico superiore

#definition(title: [$O$ (O grande)])[
  Sia $g(n)$ una funzione. L'insieme $O(g(n))$ è definito come:
  $ O(g(n)) = {f(n) mid(|) exists c, n_0 > 0 : forall n >= n_0, quad 0 <= f(n) <= c dot g(n)} $

  Se $f(n) in O(g(n))$, si dice che $g(n)$ è un *limite asintotico superiore* per $f(n)$.
]

Si scrive $f(n) = O(g(n))$.

#figure(
  image("../images/big_o.jpg", width: 25%),
  caption: [Rappresentazione grafica di $O(g(n))$: per $n >= n_0$, la funzione $f(n)$ non supera $c dot g(n)$.]
)

La notazione $O$ fornisce un *maggiorante* alla crescita di $f(n)$. Si utilizza tipicamente per esprimere il costo nel caso pessimo.

=== Notazione $Omega$ -- Limite asintotico inferiore

#definition(title: [$Omega$ (Omega grande)])[
  Sia $g(n)$ una funzione. L'insieme $Omega(g(n))$ è definito come:
  $ Omega(g(n)) = {f(n) mid(|) exists c, n_0 > 0 : forall n >= n_0, quad 0 <= c dot g(n) <= f(n)} $

  Se $f(n) in Omega(g(n))$, si dice che $g(n)$ è un *limite asintotico inferiore* per $f(n)$.
]

Si scrive $f(n) = Omega(g(n))$.

#figure(
  image("../images/big_omega.jpg", width: 25%),
  caption: [Rappresentazione grafica di $Omega(g(n))$: per $n >= n_0$, la funzione $f(n)$ è sempre almeno $c dot g(n)$.]
)

La notazione $Omega$ fornisce un *minorante* alla crescita di $f(n)$. Si utilizza tipicamente per esprimere il costo nel caso ottimo o per dimostrare limiti inferiori.

=== Relazione tra le notazioni

#theorem(title: "Relazione tra " + $Theta$+ ", " + $O$ + " e " + $Omega$)[
  Per ogni coppia di funzioni $f(n)$ e $g(n)$:
  $ f(n) = Theta(g(n)) quad arrow.l.r.double quad f(n) = O(g(n)) #h(0.3em) and #h(0.3em) f(n) = Omega(g(n)) $
]

#demonstration[
  ($arrow.double$) Se $f(n) = Theta(g(n))$, allora esistono $c_1, c_2, n_0 > 0$ tali che per ogni $n >= n_0$:
  $ c_1 dot g(n) <= f(n) <= c_2 dot g(n) $
  La disuguaglianza $f(n) <= c_2 dot g(n)$ implica $f(n) = O(g(n))$ con $c = c_2$. La disuguaglianza $c_1 dot g(n) <= f(n)$ implica $f(n) = Omega(g(n))$ con $c = c_1$.

  ($arrow.l.double$) Se $f(n) = O(g(n))$, esiste $c_2, n_1 > 0$ con $f(n) <= c_2 dot g(n)$ per $n >= n_1$. Se $f(n) = Omega(g(n))$, esiste $c_1, n_2 > 0$ con $c_1 dot g(n) <= f(n)$ per $n >= n_2$. Prendendo $n_0 = max(n_1, n_2)$, entrambe le disuguaglianze valgono simultaneamente per $n >= n_0$, ovvero $f(n) = Theta(g(n))$.
]

=== Proprietà della notazione asintotica

Le notazioni $Theta$, $O$ e $Omega$ godono di proprietà algebriche che ne facilitano l'uso. Per ciascuna proprietà riportiamo la formulazione e, ove opportuno, una giustificazione intuitiva.

#theorem(title: "Transitività")[
  Se $f(n) = Theta(g(n))$ e $g(n) = Theta(h(n))$, allora $f(n) = Theta(h(n))$.

  Analogamente per $O$ e $Omega$:
  - $f(n) = O(g(n)) and g(n) = O(h(n)) arrow.double f(n) = O(h(n))$
  - $f(n) = Omega(g(n)) and g(n) = Omega(h(n)) arrow.double f(n) = Omega(h(n))$
]

#demonstration[
  Dimostriamo il caso $O$. Per ipotesi, esistono $c_1, n_1$ con $f(n) <= c_1 dot g(n)$ per $n >= n_1$, e $c_2, n_2$ con $g(n) <= c_2 dot h(n)$ per $n >= n_2$. Per $n >= max(n_1, n_2)$:
  $ f(n) <= c_1 dot g(n) <= c_1 dot c_2 dot h(n) $
  Ponendo $c = c_1 dot c_2$ e $n_0 = max(n_1, n_2)$, si ha $f(n) = O(h(n))$. Le dimostrazioni per $Omega$ e $Theta$ sono analoghe.
]

#theorem(title: "Riflessività")[
  Per ogni funzione $f(n)$:
  $ f(n) = Theta(f(n)) , quad f(n) = O(f(n)) , quad f(n) = Omega(f(n)) $
]

Basta prendere $c_1 = c_2 = c = 1$ e $n_0 = 1$ nelle rispettive definizioni.

#theorem(title: "Simmetria")[
  $ f(n) = Theta(g(n)) arrow.l.r.double g(n) = Theta(f(n)) $

  La simmetria vale *solo* per $Theta$. Non vale per $O$ e $Omega$.
]

#theorem(title: "Simmetria trasposta")[
  $ f(n) = O(g(n)) arrow.l.r.double g(n) = Omega(f(n)) $

  Intuitivamente: dire che $f$ cresce al più come $g$ equivale a dire che $g$ cresce almeno come $f$.
]

#note(title: "Analogia con le relazioni d'ordine")[
  Le notazioni asintotiche si possono interpretare come relazioni d'ordine tra funzioni:
  - $f(n) = O(g(n))$ corrisponde a $f lt.eq g$ (informalmente)
  - $f(n) = Omega(g(n))$ corrisponde a $f gt.eq g$
  - $f(n) = Theta(g(n))$ corrisponde a $f approx g$

  Le proprietà di transitività, riflessività e simmetria ricalcano quelle delle relazioni $<=$, $>=$ e $=$.
]

=== Esercizi sulla notazione asintotica

#example(title: "Dimostrare che " + $3n^2 - 2n - 1 in Theta(n^2)$)[
  Dobbiamo trovare costanti $c_1, c_2 > 0$ e $n_0 >= 1$ tali che:
  $ forall n >= n_0: quad c_1 dot n^2 <= 3n^2 - 2n - 1 <= c_2 dot n^2 $

  *Limite superiore* ($O$): Dimostriamo che $3n^2 - 2n - 1 <= c_2 dot n^2$.

  Per $n >= 1$: $quad 3n^2 - 2n - 1 <= 3n^2$

  Quindi con $c_2 = 3$ il limite superiore è verificato per ogni $n >= 1$.

  *Limite inferiore* ($Omega$): Dimostriamo che $c_1 dot n^2 <= 3n^2 - 2n - 1$.

  Riscriviamo: $quad 3n^2 - 2n - 1 >= c_1 dot n^2$

  Dividendo per $n^2$ (per $n >= 1$): $quad 3 - frac(2, n) - frac(1, n^2) >= c_1$

  Per $n >= 2$:
  - $frac(2, n) <= 1$
  - $frac(1, n^2) <= frac(1, 4)$

  Quindi: $quad 3 - 1 - frac(1, 4) = frac(7, 4) >= c_1$

  Scegliendo $c_1 = 1$, verifichiamo per $n = 2$:
  $ 3(4) - 2(2) - 1 = 12 - 4 - 1 = 7 >= 1 dot 4 = 4 quad checkmark $

  *Conclusione*: Con $c_1 = 1$, $c_2 = 3$, $n_0 = 2$ abbiamo dimostrato che:
  $ 3n^2 - 2n - 1 in Theta(n^2) $
]

#example(title: "Dimostrare che " + $5n + 3 in O(n)$)[
  Dobbiamo trovare $c > 0$ e $n_0 >= 1$ tali che $5n + 3 <= c dot n$ per ogni $n >= n_0$.

  Per $n >= 1$: $quad 5n + 3 <= 5n + 3n = 8n$ (poiché $3 <= 3n$ per $n >= 1$).

  Dunque con $c = 8$ e $n_0 = 1$ la disuguaglianza è verificata. Si ha $5n + 3 in O(n)$.
]

#example(title: "Dimostrare che " + $n^2 in.not O(n)$)[
  Per assurdo, supponiamo $n^2 in O(n)$. Allora esistono $c, n_0 > 0$ tali che $n^2 <= c dot n$ per ogni $n >= n_0$, cioè $n <= c$ per ogni $n >= n_0$. Ma questo è impossibile, perché $n$ cresce senza limite. Contraddizione.
]

#example(title: "Ordinamento per crescita asintotica")[
  Ordinare le seguenti funzioni in ordine crescente di crescita asintotica:
  $ 2, quad log n, quad (log n)^2, quad sqrt(n), quad n, quad n log n, quad n (log n)^2, quad n^2, quad 2^n, quad 3^n, quad n! $

  *Soluzione*:

  $ 2 prec log n prec (log n)^2 prec sqrt(n) prec n prec n log n prec n (log n)^2 prec n^2 prec 2^n prec 3^n prec n! $

  Dove $f prec g$ significa $f(n) = o(g(n))$, ovvero $lim_(n -> infinity) f(n) / g(n) = 0$.

  *Classificazione per famiglie di crescita*:
  - *Costanti*: $2 = Theta(1)$
  - *Logaritmiche*: $log n$
  - *Polilogaritmiche*: $(log n)^2$
  - *Sublineari*: $sqrt(n) = n^(1\/2)$
  - *Lineari*: $n$
  - *Linearitmiche*: $n log n$
  - *Superlinearitmiche*: $n (log n)^2$
  - *Polinomiali*: $n^2$
  - *Esponenziali*: $2^n prec 3^n$ (base maggiore $arrow.double$ crescita più rapida)
  - *Fattoriali*: $n!$ (cresce più rapidamente di qualsiasi $c^n$ con $c$ costante)

  #note[
    La notazione $log^2 n$ si intende come $(log n)^2$, non come $log(log n)$. Per evitare ambiguità, in queste dispense si usa sempre la scrittura estesa $(log n)^2$.
  ]
]

== Limiti inferiori alla difficoltà di un problema

La notazione asintotica ci consente di classificare la complessità dei singoli algoritmi. Un'ulteriore domanda fondamentale è: dato un problema, qual è il minimo costo necessario per risolverlo? Per rispondere, occorre stabilire dei *limiti inferiori*, cioè delle soglie al di sotto delle quali nessun algoritmo può scendere.

#definition(title: "Difficoltà di un problema")[
  Dato un problema $pi$, la *difficoltà* di $pi$ è la complessità al caso pessimo del miglior algoritmo che risolve $pi$, espressa in funzione della dimensione dell'input e in termini asintotici. Un algoritmo che risolve $pi$ con complessità $T(n)$ fornisce un *limite superiore* alla difficoltà di $pi$.
]

#definition(title: "Limite inferiore")[
  Una funzione $L(n)$ è un *limite inferiore* per il problema $pi$ se, per ogni algoritmo $A$ che risolve $pi$, la complessità al caso pessimo di $A$ soddisfa $T_A(n) in Omega(L(n))$.

  In altre parole, $L(n)$ è il numero minimo di operazioni necessarie per risolvere $pi$ al caso peggiore.
]

#note(title: "Algoritmo ottimo")[
  Un algoritmo è *ottimo* per il problema $pi$ se la sua complessità al caso pessimo coincide (asintoticamente) con il limite inferiore. In tal caso il limite inferiore è detto *stretto*.
]

Esistono tre criteri principali per stabilire limiti inferiori.

=== Criterio della dimensione dell'input

Se la soluzione di un problema richiede necessariamente l'esame di tutti i dati in input, allora la dimensione dell'input $n$ è un limite inferiore:
$ L(n) = Omega(n) $

#example(title: "Ricerca del massimo")[
  La ricerca del massimo in un vettore non ordinato deve necessariamente esaminare tutti gli $n$ elementi: un elemento non esaminato potrebbe essere il massimo. Dunque $L(n) = Omega(n)$.

  Poiché l'algoritmo di scansione lineare ha complessità $Theta(n)$, il limite inferiore è stretto e l'algoritmo è *ottimo*.
]

=== Criterio dell'albero di decisione

Questo criterio si applica a problemi risolvibili attraverso una sequenza di *decisioni binarie* (tipicamente confronti tra valori) che via via riducono lo spazio delle soluzioni possibili.

#definition(title: "Albero di decisione")[
  Un *albero di decisione* per un problema $pi$ è un albero binario in cui:
  - ogni *nodo interno* rappresenta un confronto (decisione);
  - ogni *foglia* rappresenta una possibile soluzione;
  - ogni *percorso radice-foglia* corrisponde a una possibile esecuzione dell'algoritmo.
]

Il *caso pessimo* di un algoritmo basato su confronti corrisponde alla lunghezza del percorso più lungo dalla radice a una foglia, ossia all'*altezza* dell'albero di decisione.

#definition(title: "Altezza di un albero")[
  L'altezza di un albero è la lunghezza (in numero di archi) del più lungo percorso dalla radice ad una foglia.
]

#theorem(title: "Limite inferiore dall'albero di decisione")[
  Se $"SOL"(n)$ è il numero di soluzioni possibili per un'istanza di dimensione $n$ del problema $pi$, allora ogni albero di decisione per $pi$ ha almeno $"SOL"(n)$ foglie. Poiché un albero binario con $F$ foglie ha altezza almeno $log_2 F$, si ha:
  $ L(n) = Omega(log_2("SOL"(n))) $
]

#demonstration[
  Un albero binario di altezza $h$ ha al massimo $2^h$ foglie. L'albero di decisione deve avere almeno $"SOL"(n)$ foglie (una per ogni soluzione possibile). Dunque $2^h >= "SOL"(n)$, da cui $h >= log_2("SOL"(n))$.
]

#note(title: "Percorsi nell'albero di decisione")[
  In un albero di decisione, il percorso più breve dalla radice a una foglia corrisponde al *caso ottimo*, mentre il percorso più lungo corrisponde al *caso pessimo*. Un *albero bilanciato* è un albero in cui il caso ottimo e il caso pessimo differiscono al più di una costante.
]

#definition(title: "Albero bilanciato")[
  Un albero si dice *bilanciato* se, per ogni nodo, le altezze dei suoi sottoalberi differiscono al più di una costante. Come conseguenza, un albero bilanciato con $n$ nodi ha altezza $Theta(log n)$.
]

#note(title: "Algoritmo ottimo per problemi basati su confronti")[
  L'algoritmo ottimo al caso pessimo è quello che minimizza l'altezza dell'albero di decisione. Questo corrisponde a un albero bilanciato, con altezza $Theta(log("SOL"(n)))$.
]

=== Criterio degli eventi contabili

Se la soluzione di un problema richiede che un certo *evento* si ripeta un numero minimo di volte, e ogni occorrenza ha un certo costo, allora si ottiene un limite inferiore:
$ L(n) = ("numero minimo di ripetizioni dell'evento") times ("costo per evento") $

#example(title: "Ordinamento per confronti")[
  Nell'ordinamento per confronti, l'evento elementare è il *confronto* tra due elementi (costo $Theta(1)$). Le soluzioni possibili sono le $n!$ permutazioni dell'array. Dall'albero di decisione:
  $ L(n) = Omega(log_2(n!)) = Omega(n log n) $
  dove l'ultima uguaglianza segue dall'approssimazione di Stirling: $log(n!) = Theta(n log n)$.

  Poiché il Merge Sort ha complessità $Theta(n log n)$, esso è un algoritmo *ottimo* per l'ordinamento basato su confronti.
]
