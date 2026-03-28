#import "../template.typ": *

== Introduzione alla Programmazione Dinamica

La *programmazione dinamica* (PD) è un paradigma algoritmico per la soluzione di problemi di *ottimizzazione*. Nasce dall'osservazione che molti problemi ricorsivi ricalcolano le stesse soluzioni più volte: la PD evita questo spreco memorizzando i risultati già ottenuti.

Due proprietà devono essere soddisfatte:

+ *Sottostruttura ottima:* la soluzione ottima del problema contiene al suo interno le soluzioni ottime dei sotto-problemi.
+ *Ripetizione di sotto-problemi:* l'albero delle chiamate ricorsive risolve più volte lo stesso sotto-problema.

=== Struttura di un algoritmo PD (stile bottom-up)

Un algoritmo PD bottom-up si articola in quattro fasi:

+ *Definizione dei sotto-problemi e dimensionamento della tabella.* Si identificano i sotto-problemi $Pi_i$ e si alloca una struttura (array, matrice) per memorizzare i loro risultati.

+ *Soluzione diretta dei sotto-problemi elementari* e memorizzazione del risultato nella tabella.

+ *Definizione della regola ricorsiva di riempimento della tabella*, per ottenere la soluzione di un sotto-problema a partire dalle soluzioni di sotto-problemi già risolti.

+ *Restituzione del risultato* relativo al problema originale (dimensione $n$).

#nota[Rispetto alla ricorsione pura, l'approccio bottom-up non ha overhead di chiamate ricorsive e garantisce che ogni sotto-problema sia risolto esattamente una volta.]

== Fibonacci con Programmazione Dinamica

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

== Il problema del Taglio delle Corde

=== Definizione del problema

#definizione(titolo: "Taglio delle Corde (Rod Cutting)")[
  Data una corda di acciaio di $n$ cm e un listino prezzi $p_i$ (prezzo di un pezzo di $i$ cm, $1 <= i <= n$), trovare il *ricavo massimo* ottenibile tagliando la corda e vendendo i singoli pezzi.
]

#esempio(titolo: "n = 4")[
  Listino: $p_1 = 1,\ p_2 = 5,\ p_3 = 8,\ p_4 = 9$.

  Una corda di 4 cm ha $2^(n-1) = 8$ tagli possibili. Il ricavo massimo è $r_4 = 10$, ottenuto con due pezzi da 2 cm ($p_2 + p_2 = 5 + 5$).
]

La sottostruttura ottima è: fissato il primo taglio a $i$ cm, il rimanente pezzo di $(n-i)$ cm va tagliato in modo ottimale. Quindi:

$ r_n = max_(1 <= i <= n) {p_i + r_(n-i)} $

con $r_0 = 0$.

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

  *Ipotesi induttiva:* $forall j,\ 0 <= j < n:\ T(j) = 2^j$.

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

  - $j=1$: $r[1] = p(1) + r[0] = 1$
  - $j=2$: $r[2] = max{p(1)+r[1], p(2)+r[0]} = max{2, 5} = 5$
  - $j=3$: $r[3] = max{p(1)+r[2], p(2)+r[1], p(3)+r[0]} = max{6, 6, 8} = 8$
  - $j=4$: $r[4] = max{p(1)+r[3], p(2)+r[2], p(3)+r[1], p(4)+r[0]} = max{9, 10, 9, 9} = 10$
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
      while (n > 0) {
          print s[n];
          n = n - s[n];
      }
      print "ricavo massimo: " r[n];
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

=== Definizione

#definizione(titolo: "Sottosequenza")[
  $Z$ è una *sottosequenza* di $X = x_1 x_2 dots x_m$ se $Z$ si ottiene da $X$ cancellando zero o più caratteri (non necessariamente consecutivi, ma mantenendo l'ordine).

  $X$ di lunghezza $m$ ha $2^m$ sottosequenze.
]

#esempio[
  $X = $ SPIEGARE. Sono sottosequenze di $X$: SPIA, SPIE, SPIARE, PERE, SPG, $dots$

  I caratteri non devono essere consecutivi, ma devono mantenere l'ordine relativo.
]

#definizione(titolo: "Sottosequenza Comune Massima (LCS)")[
  Date due sequenze $X$ di $m$ caratteri e $Y$ di $n$ caratteri, una *sottosequenza comune* (CS) è una sequenza $Z$ che è contemporaneamente sottosequenza di $X$ e di $Y$.

  Una *sottosequenza comune massima* (LCS) è una CS di lunghezza massima.
]

#esempio[
  $X = $ SPIEGARE, $Y = $ OSPITARE.

  $Z = $ SPIARE è una LCS di $X$ e $Y$ (lunghezza 6).
]

Il problema con forza bruta richiede di enumerare tutte le $2^m$ sottosequenze di $X$ e verificare se sono sottosequenze di $Y$: $T(n,m) = O(2^m \cdot n)$.

=== Sottostruttura ottima

Denotiamo con $X_i = x_1 x_2 dots x_i$ l'$i$-esimo *prefisso* di $X$ ($0 <= i <= m$, con $X_0 = epsilon$).

I sotto-problemi sono: $Pi_(i,j) = |"LCS"(X_i, Y_j)|$, con $0 <= i <= m$, $0 <= j <= n$. Si usa una matrice $c$ di dimensione $(m+1) times (n+1)$, con $c[i,j] = |"LCS"(X_i, Y_j)|$.

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

=== Soluzione ricorsiva e algoritmo PD

La soluzione ricorsiva è inefficiente perché i sotto-problemi non sono indipendenti: $"LCS"(X_(m-1), Y)$ e $"LCS"(X, Y_(n-1))$ condividono $"LCS"(X_(m-1), Y_(n-1))$.

La regola ricorsiva di riempimento della tabella è:

$
c[i,j] = cases(
  c[i-1, j-1] + 1 & "se" x_i = y_j", " i","j > 0,
  max(c[i-1,j], c[i,j-1]) & "se" x_i eq.not y_j", " i","j > 0,
  0 & "se" i = 0 "o" j = 0
)
$

#algoritmo(titolo: "LCS-length(X, Y, m, n)")[
  ```
  LCS-length(X, Y, m, n) {
      c = nuova matrice (m+1)×(n+1);
      for (i = 0; i <= m; i++) { c[i,0] = 0; }
      for (j = 1; j <= n; j++) { c[0,j] = 0; }
      for (i = 1; i <= m; i++) {
          for (j = 1; j <= n; j++) {
              if (xi == yj) {
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

#esempio(titolo: "X = PICCOLA, Y = PIANTA")[
  Tabella $c$ (8×7). Il valore finale è $c[7,6] = 3$, quindi $|"LCS"| = 3$. Una LCS è PIA.

  #table(
    columns: 8,
    align: center,
    stroke: 0.5pt,
    [], [$phi$], [P], [I], [A], [N], [T], [A],
    [$phi$], [0], [0], [0], [0], [0], [0], [0],
    [P], [0], [1], [1], [1], [1], [1], [1],
    [I], [0], [1], [2], [2], [2], [2], [2],
    [C], [0], [1], [2], [2], [2], [2], [2],
    [C], [0], [1], [2], [2], [2], [2], [2],
    [O], [0], [1], [2], [2], [2], [2], [2],
    [L], [0], [1], [2], [2], [2], [2], [2],
    [A], [0], [1], [2], [3], [3], [3], [3],
  )
]

=== Ricostruzione della LCS

#algoritmo(titolo: "PRINT-LCS(c, X, Y, i, j)")[
  ```
  PRINT-LCS(c, X, Y, i, j) {
      // Prima chiamata: PRINT-LCS(c, X, Y, m, n)
      if (i == 0 || j == 0) return;
      if (xi == yj) {    // match
          PRINT-LCS(c, X, Y, i-1, j-1);
          print xi;
      } else {           // mismatch
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

#esempio(titolo: "X = RISTOTTO, Y = RISTORO")[
  RISTOTTO ha $m=8$ caratteri, RISTORO ha $n=7$. Tabella $c$ di dimensione $9 times 8$.
  Il valore finale $c[8,7] = 5$: una LCS è RISOO (o RISTO).
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

La forza bruta genera tutti i $2^n$ sottoinsiemi: $T(n) = O(n \cdot 2^n)$.

=== Soluzione con Programmazione Dinamica

I sotto-problemi sono: $Pi_(i,j)$: esiste $A' subset.eq {a_1, dots, a_i}$ tale che $"somma"(A') = j$? Con $0 <= i <= n$, $0 <= j <= s$.

Tabella PD: matrice booleana $p$ di dimensione $(n+1) times (s+1)$:
$p[i,j] = "true"$ se esiste $A' subset.eq {a_1, dots, a_i}$ con $"somma"(A') = j$.

*Fase 2 — sotto-problemi elementari* ($i = 0$, nessun elemento):
- $p[0,0] = "true"$ (sottoinsieme vuoto)
- $p[0,j] = "false"$ per $1 <= j <= s$

*Fase 3 — regola ricorsiva* per $Pi_(i,j)$ con $i >= 1$:
- Se $a_i > j$: non posso prendere $a_i$, quindi $p[i,j] = p[i-1,j]$.
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

#esempio(titolo: "A = {2, 4, 1, 3}, s = 5")[
  $n = 4$, $"somma"(A) = 10 = 2s$.

  La tabella $p$ di dimensione $5 times 6$:

  #table(
    columns: 7,
    align: center,
    stroke: 0.5pt,
    [], [0], [1], [2], [3], [4], [5],
    [$phi$], [T], [F], [F], [F], [F], [F],
    [2], [T], [F], [T], [F], [F], [F],
    [4], [T], [F], [T], [F], [T], [F],
    [1], [T], [T], [T], [T], [T], [T],
    [3], [T], [T], [T], [T], [T], [T],
  )

  $p[4,5] = "true"$: esiste il sottoinsieme. Ricostruzione (traccia Sottoinsieme):
  - $i=4, j=5$: $p[3,5]=T$ → non prendo $a_4=3$. $i=3$.
  - $i=3, j=5$: $p[2,5]=F$ → prendo $a_3=1$. $j=4$. $i=2$.
  - $i=2, j=4$: $p[1,4]=F$ → prendo $a_2=4$. $j=0$. $i=1$.
  - $i=1, j=0$: $p[0,0]=T$ → non prendo. Fine.

  $A' = {1, 4}$, somma $= 5$. $checkmark$
]
