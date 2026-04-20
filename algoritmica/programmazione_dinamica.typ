#import "../template.typ": *

== Introduzione alla Programmazione Dinamica

La *programmazione dinamica* (PD) è un paradigma algoritmico per la soluzione di problemi di *ottimizzazione*. Nasce dall'osservazione che molti problemi ricorsivi ricalcolano le stesse soluzioni più volte: la PD evita questo spreco memorizzando i risultati già ottenuti.

#nota(titolo: "PD, Divide et Impera e Greedy a confronto")[
  Questi tre paradigmi risolvono problemi scomponendoli in sotto-problemi, ma differiscono in modo cruciale:

  - *Divide et Impera:* i sotto-problemi sono *indipendenti* (non si sovrappongono). Ogni sotto-problema si risolve una sola volta perché nessun altro sotto-problema lo richiede. Esempio: MergeSort divide l'array in due metà che non condividono elementi.

  - *Programmazione Dinamica:* i sotto-problemi si *sovrappongono* (gli stessi sotto-problemi vengono richiesti più volte da sotto-problemi diversi). La PD li risolve una sola volta e memorizza i risultati in una tabella. Esempio: Fibonacci ricorsivo ricalcola $"Fib"(k)$ esponenzialmente molte volte.

  - *Greedy:* ad ogni passo si fa la scelta *localmente ottima*, senza mai riconsiderarla. Funziona solo quando la scelta locale è anche globalmente ottima.
]

Due proprietà devono essere soddisfatte perché la PD sia applicabile:

+ *Sottostruttura ottima:* la soluzione ottima del problema contiene al suo interno le soluzioni ottime dei sotto-problemi. In altre parole, se sappiamo risolvere in modo ottimo i "pezzi più piccoli", possiamo combinarli per ottenere la soluzione ottima del problema grande.

+ *Ripetizione dei sotto-problemi:* l'albero delle chiamate ricorsive risolve più volte lo stesso sotto-problema. È proprio questa ripetizione che rende la ricorsione pura inefficiente e la PD vantaggiosa.

=== Struttura di un algoritmo PD (stile bottom-up)

#nota(titolo: "Top-down vs bottom-up")[
  Esistono due modi di organizzare il calcolo di un algoritmo PD:
  - *Top-down* (_dall'alto verso il basso_, per memoizzazione): si parte dalla formulazione ricorsiva del problema originale e si scende verso i sotto-problemi più piccoli, memorizzando i risultati in una tabella per non ricalcolarli.
  - *Bottom-up* (_dal basso verso l'alto_, per tabulazione): si parte dai sotto-problemi più piccoli (casi base) e si riempie la tabella in ordine crescente fino al problema originale, senza usare la ricorsione.

  I due approcci hanno lo stesso costo asintotico; il bottom-up è in genere preferibile perché evita l'overhead delle chiamate ricorsive.
]

Un algoritmo PD bottom-up si articola in quattro fasi:

+ *Definizione dei sotto-problemi e dimensionamento della tabella.* Si identificano i sotto-problemi $Pi_i$ e si alloca una struttura (array, matrice) per memorizzare i loro risultati.

+ *Soluzione diretta dei sotto-problemi elementari* (casi base) e memorizzazione del risultato nella tabella.

+ *Definizione della regola ricorsiva di riempimento della tabella*, per ottenere la soluzione di un sotto-problema a partire dalle soluzioni di sotto-problemi già risolti.

+ *Restituzione del risultato* relativo al problema originale (dimensione $n$).

#ricorda[
  *Ricetta pratica per affrontare un problema con PD:*

  + Verificare che il problema abbia *sottostruttura ottima* e *sotto-problemi ripetuti*.
  + Scrivere la *formula ricorsiva* che lega la soluzione di un sotto-problema a quelle più piccole, partendo dalla domanda: _"Qual è l'ultima scelta? Quali sotto-problemi genera?"_
  + Decidere la *struttura della tabella* (array 1D, matrice 2D) e l'*ordine di riempimento* (dai casi base al problema originale).
  + Se serve la soluzione (non solo il valore ottimo), aggiungere una struttura ausiliaria per la *ricostruzione*.
]

#nota[Rispetto alla ricorsione pura, l'approccio bottom-up non ha overhead di chiamate ricorsive e garantisce che ogni sotto-problema sia risolto esattamente una volta.]

== Fibonacci con Programmazione Dinamica

=== Motivazione: il costo della ricorsione naive

L'approccio ricorsivo diretto ha costo esponenziale. La ricorrenza $T(n) = T(n-1) + T(n-2) + O(1)$ ha soluzione $T(n) = O(phi^n)$ con $phi approx 1.618$. Il motivo è la *ripetizione di sotto-problemi*: nell'albero delle chiamate per $n = 5$,

#align(center)[
  ```
              Fib(5)
             /       \
          Fib(4)     Fib(3)†
          /    \      /    \
       Fib(3)† Fib(2)‡ Fib(2)‡ Fib(1)
       /    \
   Fib(2)‡ Fib(1)
  ```
]

$"Fib"(3)$ viene calcolato 2 volte (marcato con †), $"Fib"(2)$ viene calcolato 3 volte (marcato con ‡).

#osservazione[
  Nell'albero qui sopra, i sotto-problemi distinti sono solo 6 ($"Fib"(0), dots, "Fib"(5)$), ma le chiamate ricorsive totali sono 15. Questo rapporto tra sotto-problemi distinti e chiamate totali peggiora drasticamente all'aumentare di $n$: è la *ripetizione dei sotto-problemi* che la PD elimina. Con la PD, ogni sotto-problema viene risolto una sola volta, portando la complessità da $O(phi^n)$ a $Theta(n)$.
]

=== Approccio bottom-up con tabella

#definizione(titolo: "Algoritmo Fib (PD bottom-up)")[
  L'$i$-esimo numero di Fibonacci è calcolato riempiendo un array $F$ di dimensione $n+1$:

  - $Pi_i$: calcolo dell'$i$-esimo numero di Fibonacci, $0 <= i <= n$
  - Tabella PD: array $F$ di dimensione $n+1$
]

#algoritmo(titolo: "Fib(n) — versione con array")[
  ```
  Fib(n) {
      F = nuovo array di dimensione n+1;
      F[0] = 0;
      F[1] = 1;
      for (i = 2; i <= n; i++) {
          F[i] = F[i-1] + F[i-2];
      }
      return F[n];
  }
  ```
]

La complessità è $T(n) = Theta(n)$ (numero di addizioni). Il valore esatto è $F_n tilde 1/sqrt(5) phi^n$ con $phi approx 1.618$ (rapporto aureo).

=== Ottimizzazione dello spazio

Poiché ogni iterazione usa solo i due valori precedenti, è sufficiente mantenere tre variabili:

#algoritmo(titolo: "Fib(n) — versione O(1) spazio")[
  ```
  Fib(n) {
      if (n == 0 || n == 1) return n;
      a = 0;
      b = 1;
      for (i = 2; i <= n; i++) {
          c = a + b;
          a = b;
          b = c;
      }
      return b;
  }
  ```
]

$T(n) = Theta(n)$ addizioni, $S(n) = O(1)$.

=== Algoritmo pseudo-polinomiale

#definizione(titolo: "Algoritmo pseudo-polinomiale")[
  Un algoritmo è *pseudo-polinomiale* se è polinomiale (o lineare) nel *valore* dell'input, ma esponenziale nella *dimensione* della sua rappresentazione binaria.
]

Per Fibonacci: l'istanza è $I = n$, con $|I| = floor(log_2 n) + 1 = Theta(log n)$ bit. Quindi:

$ T(n) = Theta(n) = Theta(2^(log n)) = Theta(2^(|I|)) $

L'algoritmo è lineare nel valore di $n$, ma esponenziale nella dimensione dell'input.

=== Memoizzazione (approccio top-down)

Un'alternativa al bottom-up è la *memoizzazione*: si parte dalla definizione ricorsiva, ma si memorizza ogni risultato in una tabella (inizializzata con un valore sentinella) prima di restituirlo.

#algoritmo(titolo: "Fib-memo(n)")[
  ```
  Fib-memo(n) {
      M = nuovo array di n+1 elementi, tutti -1;
      return Fib-aux(n, M);
  }

  Fib-aux(n, M) {
      if (M[n] != -1) return M[n];
      if (n == 0 || n == 1) { M[n] = n; return n; }
      M[n] = Fib-aux(n-1, M) + Fib-aux(n-2, M);
      return M[n];
  }
  ```
]

$T(n) = Theta(n)$: ogni sotto-problema è risolto una sola volta, le chiamate successive trovano il valore in $O(1)$.

#nota[
  *Bottom-up vs memoizzazione.*
  - *Bottom-up:* riempie la tabella in ordine topologico, nessun overhead di ricorsione, accesso sequenziale alla memoria (cache-friendly). Preferibile quando tutti i sotto-problemi devono essere risolti.
  - *Memoizzazione:* segue l'ordine naturale della ricorsione, risolve solo i sotto-problemi effettivamente raggiungibili (utile con tabelle sparse), ma ha overhead di chiamate ricorsive e rischio di stack overflow per $n$ grande.
]

== Il problema del Taglio delle Corde

=== Definizione del problema

#definizione(titolo: "Taglio delle Corde (Rod Cutting)")[
  Data una corda di acciaio di $n$ cm e un listino prezzi $p_i$ (prezzo di un pezzo di $i$ cm, $1 <= i <= n$), trovare il *ricavo massimo* ottenibile tagliando la corda e vendendo i singoli pezzi.
]

#esempio(titolo: "n = 4")[
  Listino: $p_1 = 1, p_2 = 5, p_3 = 8, p_4 = 9$.

  Una corda di 4 cm ha $2^(n-1) = 8$ tagli possibili. Il ricavo massimo è $r_4 = 10$, ottenuto con due pezzi da 2 cm ($p_2 + p_2 = 5 + 5$).
]

La sottostruttura ottima è: fissato il primo taglio a $i$ cm, il rimanente pezzo di $(n-i)$ cm va tagliato in modo ottimale. Quindi:

$ r_n = max_(1 <= i <= n) {p_i + r_(n-i)} $

con $r_0 = 0$.

#nota[
  *Leggere la formula:* stiamo provando ogni possibile primo taglio ($i = 1, 2, dots, n$ cm) e per ciascuno calcoliamo il ricavo come "prezzo del pezzo tagliato ($p_i$) + ricavo ottimo del pezzo rimanente ($r_(n-i)$)". Il massimo tra tutte queste opzioni è il ricavo ottimo $r_n$. Il caso $i = n$ corrisponde a non tagliare affatto (vendere la corda intera).
]

=== Soluzione ricorsiva

#algoritmo(titolo: "CUT-ROD(p, n)")[
  ```
  CUT-ROD(p, n) {
      // p: array dei prezzi (dim n); n: lunghezza del pezzo da tagliare
      if (n == 0) return 0;
      q = -inf;
      for (i = 1; i <= n; i++) {
          q = max{q, p(i) + CUT-ROD(p, n-i)};
      }
      return q;
  }
  ```
]

==== Analisi della complessità

Sia $T(n)$ il numero di chiamate ricorsive:

$ T(n) = cases(1 & n = 0, 1 + sum_(i=1)^n T(n-i) & n > 0) $

Per sostituzione: $T(n) = 1 + sum_(j=0)^(n-1) T(j)$. Per induzione su $n$ si dimostra $T(n) = 2^n$.

#dimostrazione(stile: "per induzione")[
  *Base:* $n = 0$: $T(0) = 1 = 2^0$. $checkmark$

  *Ipotesi induttiva:* $forall j, 0 <= j < n: T(j) = 2^j$.

  *Passo:*
  $T(n) = 1 + sum_(j=0)^(n-1) T(j) = 1 + sum_(j=0)^(n-1) 2^j = 1 + (2^n - 1)/(2-1) = 2^n$. $checkmark$
]

=== Soluzione con Programmazione Dinamica

Le quattro fasi:

+ $Pi_i$: taglio ottimale di una corda di $i$ cm, $0 <= i <= n$. Tabella PD: array $r$ di dimensione $n+1$.
+ $Pi_0$: $r_0 = 0 arrow.r r[0] = 0$.
+ $r[j] = max_(1 <= i <= j) {p(i) + r[j-i]}$, calcolato per $j = 1, dots, n$.
+ Restituire $r[n]$.

#algoritmo(titolo: "CUT-ROD-PD(p, n)")[
  ```
  CUT-ROD-PD(p, n) {
      r = nuovo array di dimensione n+1;  // O(1)
      r[0] = 0;
      for (j = 1; j <= n; j++) {          // pezzo di corda di j cm
          q = -inf;
          for (i = 1; i <= j; i++) {      // O(j)
              if (q < p(i) + r[j-i]) {
                  q = p(i) + r[j-i];
              }
          }
          r[j] = q;
      }
      return r[n];
  }
  ```
]

$T(n) = Theta(1) + sum_(j=1)^n Theta(j) = Theta(sum_(j=1)^n j) = Theta(n^2)$, $S(n) = Theta(n)$.

#esempio(titolo: "Simulazione con n = 4")[
  $p = [0, 1, 5, 8, 9]$, $r = [0, -, -, -, -]$.

  - $j=1$: un solo taglio possibile, $i=1$: $p(1) + r[0] = 1 + 0 = 1$. $arrow.r r[1] = 1$
  - $j=2$: proviamo $i=1$: $p(1)+r[1] = 1+1 = 2$; $i=2$: $p(2)+r[0] = 5+0 = 5$. Il massimo è 5 (meglio vendere un pezzo da 2 che due da 1). $arrow.r r[2] = 5$
  - $j=3$: proviamo $i=1$: $p(1)+r[2] = 1+5 = 6$; $i=2$: $p(2)+r[1] = 5+1 = 6$; $i=3$: $p(3)+r[0] = 8+0 = 8$. Il massimo è 8 (vendere la corda intera). $arrow.r r[3] = 8$
  - $j=4$: proviamo $i=1$: $p(1)+r[3] = 1+8 = 9$; $i=2$: $p(2)+r[2] = 5+5 = 10$; $i=3$: $p(3)+r[1] = 8+1 = 9$; $i=4$: $p(4)+r[0] = 9+0 = 9$. Il massimo è 10 (due pezzi da 2). $arrow.r r[4] = 10$

  Risultato finale: $r = [0, 1, 5, 8, 10]$.
]

=== Ricostruzione della soluzione

Si aggiunge un array $s$ per memorizzare il primo taglio ottimale per ogni lunghezza:

#algoritmo(titolo: "CUT-ROD-PD con ricostruzione")[
  ```
  CUT-ROD-PD(p, n) {
      r = nuovo array di dimensione n+1;
      s = nuovo array di dimensione n    // [1..n]
      r[0] = 0;
      for (j = 1; j <= n; j++) {
          q = -inf;
          for (i = 1; i <= j; i++) {
              if (q < p(i) + r[j-i]) {
                  q = p(i) + r[j-i];
                  s[j] = i;
              }
          }
          r[j] = q;
      }
      return s, r;
  }
  ```
]

#algoritmo(titolo: "PRINT-CUT-ROD(p, n)")[
  ```
  PRINT-CUT-ROD(p, n) {
      (r, s) = CUT-ROD-PD(p, n);
      ricavo = r[n];
      while (n > 0) {
          print s[n];
          n = n - s[n];
      }
      print "ricavo massimo: " ricavo;
  }
  ```
]

#esempio(titolo: "Ricostruzione per n = 4")[
  $s = [0, 1, 2, 3, 2]$. Esecuzione di PRINT-CUT-ROD:
  - stampa $s[4] = 2$, $n := 4-2 = 2$
  - stampa $s[2] = 2$, $n := 2-2 = 0$
  - fine

  Il taglio ottimale è: due pezzi da 2 cm, ricavo = 10.
]

== Longest Common Subsequence (LCS)

La *Longest Common Subsequence* (sottosequenza comune massima) è un problema classico con importanti applicazioni pratiche: gli strumenti `diff` per confrontare file, l'allineamento di sequenze DNA in bioinformatica e il rilevamento di plagio lo usano come componente fondamentale.

=== Definizioni

#definizione(titolo: "Sottosequenza")[
  $Z$ è una *sottosequenza* di $X = x_1 x_2 dots x_m$ se $Z$ si ottiene da $X$ cancellando zero o più caratteri (non necessariamente consecutivi, ma mantenendo l'ordine).

  $X$ di lunghezza $m$ ha $2^m$ sottosequenze.
]

#esempio[
  $X = $ SPIEGARE. Sono sottosequenze di $X$: SPIA, SPIE, SPIARE, PERE, SPG, $dots$

  I caratteri non devono essere consecutivi, ma devono mantenere l'ordine relativo.
]

#attenzione[
  Non confondere *sottosequenza* con *sottostringa*:
  - *Sottostringa:* i caratteri devono essere *consecutivi*. Ad esempio, PIEG è sottostringa di SPIEGARE.
  - *Sottosequenza:* i caratteri mantengono l'ordine ma possono *non essere consecutivi*. Ad esempio, SPIARE è sottosequenza di SPIEGARE (si salta la G), ma non è una sottostringa.

  Un anagramma (stessi caratteri in ordine diverso) *non* è una sottosequenza.
]

#definizione(titolo: "Sottosequenza Comune Massima (LCS)")[
  Date due sequenze $X$ di $m$ caratteri e $Y$ di $n$ caratteri, una *sottosequenza comune* (CS) è una sequenza $Z$ che è contemporaneamente sottosequenza di $X$ e di $Y$.

  Una *sottosequenza comune massima* (LCS) è una CS di lunghezza massima.
]

#esempio[
  $X = $ SPIEGARE, $Y = $ OSPITARE.

  $Z = $ SPIARE è una LCS di $X$ e $Y$ (lunghezza 6).
]

Il problema con forza bruta richiede di enumerare tutte le $2^m$ sottosequenze di $X$ e verificare ciascuna come sottosequenza di $Y$: $T(n,m) = O(2^m dot n)$.

=== Sottostruttura ottima

Denotiamo con $X_i = x_1 x_2 dots x_i$ l'$i$-esimo *prefisso* di $X$ ($0 <= i <= m$, con $X_0 = epsilon$, la stringa vuota).

I sotto-problemi sono: $Pi_(i,j) = |"LCS"(X_i, Y_j)|$, con $0 <= i <= m$, $0 <= j <= n$. Si usa una matrice $c$ di dimensione $(m+1) times (n+1)$, dove $c[i,j] = |"LCS"(X_i, Y_j)|$.

Per ricavare la formula ricorsiva, ragioniamo sugli ultimi caratteri dei prefissi $X_i$ e $Y_j$.

#nota(titolo: "Intuizione: cosa succede con gli ultimi caratteri?")[
  Supponiamo di conoscere una LCS $Z$ di $X_i$ e $Y_j$. Confrontiamo $x_i$ con $y_j$:

  - *Se $x_i = y_j$ (match):* questo carattere comune _deve_ far parte della LCS. Lo "consumiamo" e cerchiamo la LCS dei prefissi accorciati $X_(i-1)$ e $Y_(j-1)$. La lunghezza è $c[i-1,j-1] + 1$.

  - *Se $x_i eq.not y_j$ (mismatch):* almeno uno dei due ultimi caratteri _non_ è nella LCS. Proviamo due strade: (a) scartare $x_i$ e cercare LCS di $X_(i-1)$ e $Y_j$; oppure (b) scartare $y_j$ e cercare LCS di $X_i$ e $Y_(j-1)$. Prendiamo la più lunga: $max(c[i-1,j], c[i,j-1])$.

  - *Se $i = 0$ o $j = 0$ (caso base):* una delle due sequenze è vuota, quindi non esistono sottosequenze comuni: $c[i,j] = 0$.

  Questo ragionamento ci permette di ridurre il problema a sotto-problemi più piccoli — esattamente la struttura che serve alla PD.
]

Il seguente teorema formalizza questa intuizione.

#teorema(titolo: "Sottostruttura ottima di LCS")[
  Siano $X = x_1 dots x_m$ e $Y = y_1 dots y_n$, e sia $Z = z_1 dots z_k$ una LCS di $X$ e $Y$:

  + Se $x_m = y_n$, allora $z_k = x_m = y_n$ e $Z_(k-1)$ è una LCS di $X_(m-1)$ e $Y_(n-1)$.
  + Se $x_m eq.not y_n$ e $z_k eq.not x_m$, allora $Z$ è una LCS di $X_(m-1)$ e $Y$.
  + Se $x_m eq.not y_n$ e $z_k eq.not y_n$, allora $Z$ è una LCS di $X$ e $Y_(n-1)$.

  In sintesi: una LCS di due sequenze contiene come prefisso una LCS dei loro prefissi.
]

#dimostrazione(stile: "per assurdo")[
  *Caso 1* ($x_m = y_n$): supponiamo per assurdo $z_k eq.not x_m$. Allora $W = Z x_m$ è CS di $X$ e $Y$ con $|W| = k+1 > k$, contraddizione con $Z in "LCS"$.

  Per dimostrare che $Z_(k-1)$ è LCS di $X_(m-1)$ e $Y_(n-1)$: per assurdo, esiste $W$ CS di $X_(m-1)$ e $Y_(n-1)$ con $|W| > k-1$, cioè $|W| >= k$. Allora $W x_m$ è CS di $X$ e $Y$ con $|W x_m| >= k+1$, contraddizione.

  *Caso 2* ($x_m eq.not y_n$, $z_k eq.not x_m$): $Z$ non usa $x_m$, quindi è CS di $X_(m-1)$ e $Y$. Per assurdo, se non fosse LCS esisterebbe $W$, CS di $X_(m-1)$ e $Y$, con $|W| > k$; ma $W$ è anche CS di $X$ e $Y$, contraddizione.

  *Caso 3*: analogo al Caso 2.
]

=== Formula ricorsiva e algoritmo PD

Dal teorema si ricava direttamente la formula ricorsiva per il riempimento della tabella:

$
c[i,j] = cases(
  0 & "se" i = 0 "o" j = 0,
  c[i-1, j-1] + 1 & "se" x_i = y_j", " i","j > 0,
  max(c[i-1","j]", " c[i","j-1]) & "se" x_i eq.not y_j", " i","j > 0,
)
$

#nota(titolo: "Collegamento formula — teorema")[
  Ogni riga della formula corrisponde a un caso del ragionamento:

  - *$c[i,j] = 0$* (caso base): una delle due sequenze è vuota — non esistono sottosequenze comuni.
  - *$c[i-1,j-1]+1$* (Caso 1 — match): gli ultimi caratteri coincidono e fanno parte della LCS. Li consumiamo e aggiungiamo 1 alla LCS dei prefissi accorciati.
  - *$max(c[i-1,j], c[i,j-1])$* (Casi 2 e 3 — mismatch): uno dei due ultimi caratteri non è nella LCS. Proviamo a scartarli uno alla volta e prendiamo il risultato migliore.
]

La soluzione ricorsiva diretta è inefficiente perché i sotto-problemi non sono indipendenti: $"LCS"(X_(m-1), Y)$ e $"LCS"(X, Y_(n-1))$ condividono il sotto-problema $"LCS"(X_(m-1), Y_(n-1))$. Con la PD bottom-up, ogni sotto-problema è risolto esattamente una volta.

#algoritmo(titolo: "LCS-length(X, Y, m, n)")[
  ```
  LCS-length(X, Y, m, n) {
      c = nuova matrice (m+1)×(n+1);
      for (i = 0; i <= m; i++) { c[i,0] = 0; }
      for (j = 1; j <= n; j++) { c[0,j] = 0; }
      for (i = 1; i <= m; i++) {
          for (j = 1; j <= n; j++) {
              if (X[i] == Y[j]) {
                  c[i,j] = c[i-1, j-1] + 1;
              } else {
                  c[i,j] = c[i-1, j];
                  if (c[i,j-1] > c[i,j]) {
                      c[i,j] = c[i,j-1];
                  }
              }
          }
      }
      print c[m,n];
      return c;
  }
  ```
]

$T(n,m) = Theta(m dot n)$, $S(n,m) = Theta(m dot n)$.

=== Riempimento della matrice passo per passo

Per capire concretamente come funziona l'algoritmo, riempiamo la matrice per un esempio piccolo, spiegando la decisione presa in ogni cella.

#esempio(titolo: "X = CASA, Y = COSA — riempimento passo per passo")[
  $m = 4$, $n = 4$. La matrice $c$ ha dimensione $5 times 5$.

  *Fase 2 — casi base:* la riga 0 e la colonna 0 sono tutte zero (una delle due sequenze è vuota).

  *Fase 3 — riempimento riga per riga:*

  *Riga $i=1$ ($x_1 = $ C):* per ogni colonna, confrontiamo C con il carattere corrispondente di $Y$:
  - $c[1,1]$: C $=$ C $arrow.r$ *match* $arrow.r$ $c[0,0]+1 = 0+1 = 1$
  - $c[1,2]$: C $eq.not$ O $arrow.r$ *mismatch* $arrow.r$ $max(c[0,2], c[1,1]) = max(0, 1) = 1$
  - $c[1,3]$: C $eq.not$ S $arrow.r$ *mismatch* $arrow.r$ $max(c[0,3], c[1,2]) = max(0, 1) = 1$
  - $c[1,4]$: C $eq.not$ A $arrow.r$ *mismatch* $arrow.r$ $max(c[0,4], c[1,3]) = max(0, 1) = 1$

  *Riga $i=2$ ($x_2 = $ A):*
  - $c[2,1]$: A $eq.not$ C $arrow.r$ $max(c[1,1], c[2,0]) = max(1, 0) = 1$
  - $c[2,2]$: A $eq.not$ O $arrow.r$ $max(c[1,2], c[2,1]) = max(1, 1) = 1$
  - $c[2,3]$: A $eq.not$ S $arrow.r$ $max(c[1,3], c[2,2]) = max(1, 1) = 1$
  - $c[2,4]$: A $=$ A $arrow.r$ *match* $arrow.r$ $c[1,3]+1 = 1+1 = 2$

  *Riga $i=3$ ($x_3 = $ S):*
  - $c[3,1]$: S $eq.not$ C $arrow.r$ $max(c[2,1], c[3,0]) = max(1, 0) = 1$
  - $c[3,2]$: S $eq.not$ O $arrow.r$ $max(c[2,2], c[3,1]) = max(1, 1) = 1$
  - $c[3,3]$: S $=$ S $arrow.r$ *match* $arrow.r$ $c[2,2]+1 = 1+1 = 2$
  - $c[3,4]$: S $eq.not$ A $arrow.r$ $max(c[2,4], c[3,3]) = max(2, 2) = 2$

  *Riga $i=4$ ($x_4 = $ A):*
  - $c[4,1]$: A $eq.not$ C $arrow.r$ $max(c[3,1], c[4,0]) = max(1, 0) = 1$
  - $c[4,2]$: A $eq.not$ O $arrow.r$ $max(c[3,2], c[4,1]) = max(1, 1) = 1$
  - $c[4,3]$: A $eq.not$ S $arrow.r$ $max(c[3,3], c[4,2]) = max(2, 1) = 2$
  - $c[4,4]$: A $=$ A $arrow.r$ *match* $arrow.r$ $c[3,3]+1 = 2+1 = 3$

  *Matrice completa:*

  #table(
    columns: 6,
    align: center,
    stroke: 0.5pt,
    [], [$epsilon$], [C], [O], [S], [A],
    [$epsilon$], [0], [0], [0], [0], [0],
    [C], [0], [1], [1], [1], [1],
    [A], [0], [1], [1], [1], [2],
    [S], [0], [1], [1], [2], [2],
    [A], [0], [1], [1], [2], [3],
  )

  *Risultato:* $c[4,4] = 3$, quindi $|"LCS"("CASA", "COSA")| = 3$.
]

=== Ricostruzione della LCS

Per ottenere la LCS stessa (non solo la sua lunghezza), si "risale" la matrice dalla cella $c[m,n]$ fino a raggiungere una riga o colonna zero. Ad ogni cella, la decisione è:

- Se $x_i = y_j$ (*match*): il carattere fa parte della LCS. Ci si sposta in *diagonale* verso $c[i-1,j-1]$.
- Se $x_i eq.not y_j$ (*mismatch*): ci si sposta verso la cella con il valore *maggiore* tra $c[i-1,j]$ (sopra) e $c[i,j-1]$ (sinistra). In caso di parità, si va sopra.

#nota(titolo: "Le tre direzioni nella matrice")[
  Ogni cella della matrice è stata calcolata guardando al massimo tre celle vicine. La ricostruzione percorre il cammino inverso:

  - *Diagonale* ($arrow.tl$) — match: il carattere fa parte della LCS, entrambi gli indici decrescono.
  - *Su* ($arrow.t$) — mismatch: il valore viene dalla riga sopra, $x_i$ non è nella LCS, solo $i$ decresce.
  - *Sinistra* ($arrow.l$) — mismatch: il valore viene dalla colonna a sinistra, $y_j$ non è nella LCS, solo $j$ decresce.
]

#algoritmo(titolo: "PRINT-LCS(c, X, Y, i, j)")[
  ```
  PRINT-LCS(c, X, Y, i, j) {
      // Prima chiamata: PRINT-LCS(c, X, Y, m, n)
      if (i == 0 || j == 0) return;
      if (X[i] == Y[j]) {    // match → diagonale
          PRINT-LCS(c, X, Y, i-1, j-1);
          print X[i];
      } else {           // mismatch → su o sinistra
          if (c[i-1, j] >= c[i, j-1]) {
              PRINT-LCS(c, X, Y, i-1, j);
          } else {
              PRINT-LCS(c, X, Y, i, j-1);
          }
      }
  }
  ```
]

Ad ogni chiamata $i$ oppure $j$ (o entrambi) decrescono: $T(n,m) = O(n+m)$.

#esempio(titolo: "Ricostruzione per X = CASA, Y = COSA")[
  Partiamo dalla cella $c[4,4] = 3$ e risaliamo:

  + $c[4,4]$: $x_4 =$ A, $y_4 =$ A $arrow.r$ *match* ($arrow.tl$). Il carattere A è nella LCS. Vai a $c[3,3]$.
  + $c[3,3]$: $x_3 =$ S, $y_3 =$ S $arrow.r$ *match* ($arrow.tl$). Il carattere S è nella LCS. Vai a $c[2,2]$.
  + $c[2,2]$: $x_2 =$ A, $y_2 =$ O $arrow.r$ *mismatch*. $c[1,2] = 1 >= c[2,1] = 1$ $arrow.r$ vai *su* ($arrow.t$) a $c[1,2]$.
  + $c[1,2]$: $x_1 =$ C, $y_2 =$ O $arrow.r$ *mismatch*. $c[0,2] = 0 < c[1,1] = 1$ $arrow.r$ vai a *sinistra* ($arrow.l$) a $c[1,1]$.
  + $c[1,1]$: $x_1 =$ C, $y_1 =$ C $arrow.r$ *match* ($arrow.tl$). Il carattere C è nella LCS. Vai a $c[0,0]$.
  + $c[0,0]$: $i = 0$, stop.

  Caratteri raccolti (nell'ordine della ricorsione): C, S, A. *LCS = CSA*, lunghezza 3. $checkmark$
]

=== Ulteriori esempi

#esempio(titolo: "X = PICCOLA, Y = PIANTA")[
  Tabella $c$ ($8 times 7$). Il valore finale è $c[7,6] = 3$, quindi $|"LCS"| = 3$. Una LCS è PIA.

  #table(
    columns: 8,
    align: center,
    stroke: 0.5pt,
    [], [$epsilon$], [P], [I], [A], [N], [T], [A],
    [$epsilon$], [0], [0], [0], [0], [0], [0], [0],
    [P], [0], [1], [1], [1], [1], [1], [1],
    [I], [0], [1], [2], [2], [2], [2], [2],
    [C], [0], [1], [2], [2], [2], [2], [2],
    [C], [0], [1], [2], [2], [2], [2], [2],
    [O], [0], [1], [2], [2], [2], [2], [2],
    [L], [0], [1], [2], [2], [2], [2], [2],
    [A], [0], [1], [2], [3], [3], [3], [3],
  )
]

#esempio(titolo: "X = RISTOTTO, Y = RISTORO")[
  RISTOTTO ha $m=8$ caratteri, RISTORO ha $n=7$. Tabella $c$ di dimensione $9 times 8$.
  Il valore finale $c[8,7] = 6$: una LCS è RISTOO (R, I, S, T, O, O).

  #table(
    columns: 9,
    align: center,
    stroke: 0.5pt,
    [], [$epsilon$], [R], [I], [S], [T], [O], [R], [O],
    [$epsilon$], [0], [0], [0], [0], [0], [0], [0], [0],
    [R],     [0], [1], [1], [1], [1], [1], [1], [1],
    [I],     [0], [1], [2], [2], [2], [2], [2], [2],
    [S],     [0], [1], [2], [3], [3], [3], [3], [3],
    [T],     [0], [1], [2], [3], [4], [4], [4], [4],
    [O],     [0], [1], [2], [3], [4], [5], [5], [5],
    [T],     [0], [1], [2], [3], [4], [5], [5], [5],
    [T],     [0], [1], [2], [3], [4], [5], [5], [5],
    [O],     [0], [1], [2], [3], [4], [5], [5], [6],
  )
]

== Partizione di un Insieme di Interi

=== Definizione del problema

#definizione(titolo: "Problema della Partizione")[
  Dato un insieme $A = {a_1, a_2, dots, a_n}$ di interi positivi con somma $"somma"(A) = sum_(i=1)^n a_i = 2s$, stabilire se esiste un sottoinsieme $A' subset.eq A$ tale che $"somma"(A') = s$.
]

#esempio[
  $A = {1, 3, 7, 5, 4}$, $"somma"(A) = 20$, $s = 10$.
  $A' = {3, 7}$ ha somma 10. $checkmark$

  $A = {2, 2, 7, 7, 2}$, $"somma"(A) = 20$, $s = 10$.
  Nessun sottoinsieme ha somma 10. $times$
]

La forza bruta genera tutti i $2^n$ sottoinsiemi: $T(n) = O(n dot 2^n)$.

=== Soluzione con Programmazione Dinamica

I sotto-problemi sono: $Pi_(i,j)$: esiste $A' subset.eq {a_1, dots, a_i}$ tale che $"somma"(A') = j$? Con $0 <= i <= n$, $0 <= j <= s$.

Tabella PD: matrice booleana $p$ di dimensione $(n+1) times (s+1)$:
$p[i,j] = "true"$ se esiste $A' subset.eq {a_1, dots, a_i}$ con $"somma"(A') = j$.

#nota(titolo: "Leggere la tabella")[
  $p[i,j]$ risponde alla domanda: *"Posso ottenere la somma $j$ usando solo i primi $i$ elementi di $A$?"*

  Ad esempio, $p[3,7] = "true"$ significa: "Sì, esiste un sottoinsieme di $\{a_1, a_2, a_3\}$ la cui somma è 7." La risposta al problema originale è nella cella $p[n,s]$.
]

*Fase 2 — sotto-problemi elementari* ($i = 0$, nessun elemento):
- $p[0,0] = "true"$ (sottoinsieme vuoto ha somma 0)
- $p[0,j] = "false"$ per $1 <= j <= s$ (senza elementi, non posso ottenere somma positiva)

*Fase 3 — regola ricorsiva* per $Pi_(i,j)$ con $i >= 1$:

#nota(titolo: "Intuizione: prendere o non prendere")[
  Per ogni elemento $a_i$ abbiamo esattamente *due scelte*:

  - *Non prendo $a_i$*: la somma $j$ deve essere raggiungibile con i soli primi $i-1$ elementi, cioè $p[i-1,j] = "true"$.
  - *Prendo $a_i$*: la somma rimanente $j - a_i$ deve essere raggiungibile con i primi $i-1$ elementi, cioè $p[i-1, j - a_i] = "true"$. Questa opzione è disponibile solo se $a_i <= j$.

  Basta che *una* delle due scelte funzioni per avere $p[i,j] = "true"$.
]

Formalmente:
- Se $a_i > j$: non posso prendere $a_i$ (è troppo grande), quindi $p[i,j] = p[i-1,j]$.
- Se $a_i <= j$: $p[i,j] = "true"$ se e solo se $p[i-1,j] = "true"$ (non prendo $a_i$) oppure $p[i-1, j - a_i] = "true"$ (prendo $a_i$).

#algoritmo(titolo: "Partizione(a)")[
  ```
  Partizione(a) {
      // a: array di n elementi interi positivi
      somma = 0;
      for (i = 0; i < n; i++) { somma = somma + a[i]; }
      if (somma % 2 == 1) return FALSE;
      s = somma/2;
      p = nuova matrice (n+1)×(s+1);
      for (i = 0; i <= n; i++) { p[i,0] = true; }
      // tutto il resto della matrice si inizializza a false
      for (i = 0; i <= n; i++) {
          for (j = 1; j <= s; j++) { p[i,j] = false; }
      }
      for (i = 1; i <= n; i++) {
          for (j = 1; j <= s; j++) {
              if (p[i-1, j] == true) { p[i,j] = true; }
              else if (a[i-1] <= j && p[i-1, j-a[i-1]] == true) {
                  p[i,j] = true;
              }
          }
      }
      print p[n,s];
      return p;
  }
  ```
]

$T(n,s) = Theta(n dot s)$: polinomiale in $n$ e nel *valore* di $s$, ma esponenziale nella *dimensione* di $s$ (algoritmo *pseudo-polinomiale*).

=== Ricostruzione del sottoinsieme

#algoritmo(titolo: "Sottoinsieme(a, p, n, s)")[
  ```
  Sottoinsieme(a, p, n, s) {
      if (p[n,s] == true) {
          i = n;
          j = s;
          while (i > 0) {
              if (p[i-1, j] == false) {  // prendo a[i]
                  print a[i-1];
                  j = j - a[i-1];
              }
              i--;
          }
      } else {
          print "non esiste sottoinsieme di somma s";
      }
  }
  ```
]

$T(n) = O(n)$.

#esempio(titolo: "A = {2, 4, 1, 3}, s = 5 — riempimento e ricostruzione")[
  $n = 4$, $"somma"(A) = 10 = 2s$.

  *Riempimento passo per passo (prime righe):*

  *Riga $i=0$ (nessun elemento):* $p[0,0] = T$, tutto il resto $F$. Senza elementi, posso fare solo somma 0.

  *Riga $i=1$ ($a_1 = 2$):* per ogni $j$, posso non prendere 2 (guardo sopra: $p[0,j]$) o prendere 2 (guardo $p[0,j-2]$):
  - $j=1$: $p[0,1]=F$ e $2 > 1$ (non posso prendere 2) $arrow.r$ $F$
  - $j=2$: $p[0,2]=F$ ma $p[0,0]=T$ (prendo il 2) $arrow.r$ $T$
  - $j=3,4,5$: nessuna opzione funziona $arrow.r$ $F$

  *Riga $i=2$ ($a_2 = 4$):* con gli elementi ${2, 4}$:
  - $j=2$: $p[1,2]=T$ (non prendo 4) $arrow.r$ $T$
  - $j=4$: $p[1,4]=F$ ma $p[1,0]=T$ (prendo 4) $arrow.r$ $T$
  - il resto: $F$

  *Righe $i=3$ ($a_3 = 1$) e $i=4$ ($a_4 = 3$):* proseguendo con la stessa logica.

  La tabella $p$ completa, di dimensione $5 times 6$:

  #table(
    columns: 7,
    align: center,
    stroke: 0.5pt,
    [], [0], [1], [2], [3], [4], [5],
    [$epsilon$], [T], [F], [F], [F], [F], [F],
    [2], [T], [F], [T], [F], [F], [F],
    [4], [T], [F], [T], [F], [T], [F],
    [1], [T], [T], [T], [T], [T], [T],
    [3], [T], [T], [T], [T], [T], [T],
  )

  $p[4,5] = "true"$: esiste il sottoinsieme.

  *Ricostruzione* (traccia di Sottoinsieme):
  - $i=4, j=5$: $p[3,5]=T$ $arrow.r$ non prendo $a_4=3$. $i=3$.
  - $i=3, j=5$: $p[2,5]=F$ $arrow.r$ prendo $a_3=1$. $j=4$. $i=2$.
  - $i=2, j=4$: $p[1,4]=F$ $arrow.r$ prendo $a_2=4$. $j=0$. $i=1$.
  - $i=1, j=0$: $p[0,0]=T$ $arrow.r$ non prendo. Fine.

  $A' = {1, 4}$, somma $= 5$. $checkmark$
]

== Riepilogo

#ricorda[
  *Confronto tra i problemi PD visti in questo capitolo:*

  #table(
    columns: 4,
    align: (left, center, center, left),
    stroke: 0.5pt,
    [*Problema*], [*Forza bruta*], [*PD*], [*Tabella*],
    [Fibonacci], [$O(phi^n)$], [$Theta(n)$], [Array 1D, $n+1$],
    [Taglio Corde], [$O(2^n)$], [$Theta(n^2)$], [Array 1D, $n+1$],
    [LCS], [$O(n dot 2^m)$], [$Theta(m dot n)$], [Matrice $(m+1) times (n+1)$],
    [Partizione], [$O(n dot 2^n)$], [$Theta(n dot s)$#super[$ast$]], [Matrice $(n+1) times (s+1)$],
  )

  #super[$ast$] Pseudo-polinomiale: polinomiale nel valore di $s$, esponenziale nella sua rappresentazione binaria.

  *Come affrontare un nuovo problema PD:*
  + Chiedersi: _"Qual è l'ultima scelta/decisione?"_ Questo rivela i sotto-problemi.
  + Verificare *sottostruttura ottima*: la soluzione ottima si compone di soluzioni ottime dei sotto-problemi.
  + Verificare *sotto-problemi ripetuti*: la ricorsione ricalcola gli stessi sotto-problemi.
  + Scrivere la *formula ricorsiva* e identificare i *casi base*.
  + Scegliere la *tabella* e l'*ordine di riempimento* (dai casi base al problema originale).
  + Se serve, aggiungere una struttura ausiliaria per la *ricostruzione* della soluzione.
]
