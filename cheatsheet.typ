// ============================================================
// CHEAT SHEET — Programmazione ed Algoritmica
// 4ª Prova in Itinere
// ============================================================

#set page(
  paper: "a4",
  margin: (x: 1cm, y: 1cm),
  columns: 2,
)

#set text(font: "Roboto", size: 8pt)
#set par(justify: true, leading: 0.4em, spacing: 0.5em)

#show heading.where(level: 1): it => {
  set text(size: 10pt, weight: "bold")
  block(
    width: 100%,
    stroke: (bottom: 1pt + black),
    inset: (bottom: 2pt),
    above: 8pt,
    below: 4pt,
  )[#it.body]
}

#show heading.where(level: 2): it => {
  set text(size: 8.5pt, weight: "bold")
  block(above: 5pt, below: 2pt)[#it.body]
}

#show heading.where(level: 3): it => {
  set text(size: 8pt, weight: "bold", style: "italic")
  block(above: 4pt, below: 1pt)[#it.body]
}

#let box-rule(body) = block(
  width: 100%,
  stroke: 0.5pt + black,
  inset: 4pt,
  radius: 2pt,
  above: 3pt,
  below: 3pt,
  body
)

#let kw(body) = text(weight: "bold")[#body]
#let alg(body) = text(font: "Source Code Pro", size: 7pt)[#raw(body)]

// ============================================================
// INTESTAZIONE
// ============================================================

#align(center)[
  #text(size: 11pt, weight: "bold")[Cheat Sheet — Programmazione ed Algoritmica]
  #linebreak()
  #text(size: 8pt, fill: gray)[4ª Prova in Itinere · Diego Stefanini]
]

#v(4pt)
#line(length: 100%, stroke: 0.5pt + black)
#v(2pt)

// ============================================================
// SEZIONE 1: PROGRAMMAZIONE DINAMICA
// ============================================================

= Programmazione Dinamica

== Quando si applica

#box-rule[
  Due condizioni devono valere contemporaneamente:
  - *Sovrapposizione dei sotto-problemi:* la ricorsione naturale ricalcola più volte gli stessi sotto-problemi.
  - *Sottostruttura ottima:* la soluzione ottima del problema si costruisce da soluzioni ottime di sotto-problemi.
]

*PD vs Divide et Impera:* D\&I suddivide in sotto-problemi *indipendenti*; PD sfrutta invece la *sovrapposizione* memorizzando i risultati.

*PD vs Greedy:* Greedy fa scelte localmente ottime senza tornare indietro; PD esplora tutte le scelte tramite la ricorrenza e sceglie la migliore.

== Due approcci equivalenti

- *Top-down (memoization):* ricorsione + tabella di cache. Scrivi direttamente la ricorrenza, ricordando ciò che hai già calcolato.
- *Bottom-up (tabulation):* ciclo iterativo che riempie la tabella nell'ordine giusto (dai casi base verso il problema completo). Di solito più efficiente in pratica.

== Schema generale di risoluzione

#box-rule[
  + *Definisci* $"DP"[dots]$: cosa rappresenta ciascuna cella (soluzione ottima/booleana di quale sotto-problema).
  + *Ricorrenza:* esprimi $"DP"[dots]$ in funzione di celle "più piccole".
  + *Casi base:* celle risolvibili direttamente senza ricorrenza.
  + *Ordine di riempimento:* tale che quando calcoli una cella i suoi dipendenti sono già pronti.
  + *Estrai la risposta* dalla cella finale.
  + *Ricostruzione (opzionale):* tabella ausiliaria $"pred"[dots]$ che registra la scelta vincente in ogni cella; risali dalla cella finale seguendo la catena.
]

== Taglio della Corda (Rod Cutting) — $Theta(n^2)$

Asta di lunghezza $n$, prezzi $p[1..n]$ per pezzi interi. Massimizzare il ricavo.

*Ricorrenza:* $r[0] = 0$, $r[j] = max_(1 <= i <= j) (p[i] + r[j - i])$.

#alg("extendedBottomUpCutRod(p, n):
  r[0] = 0
  for j = 1 to n:
    q = -infinity
    for i = 1 to j:
      if q < p[i] + r[j-i]:
        q = p[i] + r[j-i]; s[j] = i
    r[j] = q
  return r, s")

*Ricostruzione:* stampa $s[n]$, poi passa a $n - s[n]$, ripeti finché resto = 0.

#alg("printCutRod(p, n):
  (r, s) = extendedBottomUpCutRod(p, n)
  while n > 0:
    print s[n]
    n = n - s[n]")

*Complessità:* tempo $Theta(n^2)$, spazio $Theta(n)$.

== Sottosequenza Comune Più Lunga (LCS) — $Theta(m n)$

Date $X[1..m]$ e $Y[1..n]$, trovare la più lunga sequenza $Z$ che sia sottosequenza di entrambe.

*Ricorrenza:* $c[i,j]$ = lunghezza LCS di $X[1..i]$ e $Y[1..j]$.
$ c[i,j] = cases(
  0 &"se " i = 0 "o " j = 0,
  c[i-1, j-1] + 1 &"se " X[i] = Y[j],
  max(c[i-1, j], c[i, j-1]) &"altrimenti"
) $

#alg("lcsLength(X, Y):
  m = X.length; n = Y.length
  for i = 0 to m: c[i][0] = 0
  for j = 0 to n: c[0][j] = 0
  for i = 1 to m:
    for j = 1 to n:
      if X[i] == Y[j]:
        c[i][j] = c[i-1][j-1] + 1
        b[i][j] = \"DIAG\"
      elif c[i-1][j] >= c[i][j-1]:
        c[i][j] = c[i-1][j]; b[i][j] = \"UP\"
      else:
        c[i][j] = c[i][j-1]; b[i][j] = \"LEFT\"
  return c, b")

*Ricostruzione* (percorso a ritroso in $b$ da $(m, n)$):
#alg("printLCS(b, X, i, j):
  if i == 0 || j == 0: return
  if b[i][j] == \"DIAG\":
    printLCS(b, X, i-1, j-1); print X[i]
  elif b[i][j] == \"UP\":
    printLCS(b, X, i-1, j)
  else:
    printLCS(b, X, i, j-1)")

*Complessità:* tempo $Theta(m n)$, spazio $Theta(m n)$ (riducibile a $Theta(min(m,n))$ se non serve ricostruire).

== Cammini su Griglia — Conteggio

Scacchiera $n times n$, mosse giù o destra, contare i cammini da $(0,0)$ a $(n-1, n-1)$.

*Ricorrenza:* $"DP"[i][j] = "DP"[i-1][j] + "DP"[i][j-1]$.
*Casi base:* $"DP"[0][j] = 1$, $"DP"[i][0] = 1$ (un unico cammino sulla frontiera).

#alg("countPaths(n):
  for j = 0 to n-1: DP[0][j] = 1
  for i = 0 to n-1: DP[i][0] = 1
  for i = 1 to n-1:
    for j = 1 to n-1:
      DP[i][j] = DP[i-1][j] + DP[i][j-1]
  return DP[n-1][n-1]")

*Complessità:* tempo e spazio $Theta(n^2)$. (Formula chiusa: $binom(2n-2, n-1)$.)

== Cammini su Griglia — Valore Massimo

Stessa griglia, ogni casella ha valore $c[i][j]$. Trovare il cammino con somma massima.

*Ricorrenza:* $"DP"[i][j] = c[i][j] + max("DP"[i-1][j],  "DP"[i][j-1])$.
*Casi base:* $"DP"[0][0] = c[0][0]$; prima riga/colonna = somme cumulative.

#alg("maxPath(C, n):
  DP[0][0] = C[0][0]
  for j = 1 to n-1: DP[0][j] = DP[0][j-1] + C[0][j]
  for i = 1 to n-1: DP[i][0] = DP[i-1][0] + C[i][0]
  for i = 1 to n-1:
    for j = 1 to n-1:
      DP[i][j] = C[i][j] + max(DP[i-1][j], DP[i][j-1])
  return DP[n-1][n-1]")

*Complessità:* tempo e spazio $Theta(n^2)$.

== Longest Increasing Subsequence (LIS) — $O(n^2)$

Array $L[0..n-1]$ di interi distinti. Trovare la più lunga sottosequenza strettamente crescente.

*Ricorrenza* (definizione "termina in $i$"): $"LIS"[i] = 1 + max{"LIS"[j] : j < i, L[j] < L[i]}$, oppure $1$ se nessun $j$ soddisfa la condizione.

#alg("lisLength(L, n):
  for i = 0 to n-1:
    LIS[i] = 1; pred[i] = -1
    for j = 0 to i-1:
      if L[j] < L[i] && LIS[j] + 1 > LIS[i]:
        LIS[i] = LIS[j] + 1; pred[i] = j
  return max(LIS[0..n-1])")

*Ricostruzione:* trova $i^*$ che massimizza $"LIS"[i]$; segui $"pred"[i^*]$ a ritroso. Inverti la sequenza.

*Complessità:* tempo $Theta(n^2)$, spazio $Theta(n)$. (Versione $O(n log n)$ esiste ma non è PD.)

== Partition (Subset Sum) — $O(n s)$

Dato $A = {a_1, dots, a_n}$ di interi positivi con somma $2s$, esiste $A' subset.eq A$ con somma $s$?

*Ricorrenza:* $"DP"[i][j]$ = vero sse esiste sottoinsieme dei primi $i$ elementi con somma $j$.
$ "DP"[i][j] = cases(
  "vero" &"se " j = 0,
  "falso" &"se " i = 0 "e " j > 0,
  "DP"[i-1][j] &"se " a_i > j,
  "DP"[i-1][j] or "DP"[i-1][j - a_i] &"altrimenti"
) $

#alg("partition(A, n):
  totale = sum(A)
  if totale is odd: return false
  s = totale / 2
  for i = 0 to n: DP[i][0] = true
  for j = 1 to s: DP[0][j] = false
  for i = 1 to n:
    for j = 1 to s:
      if A[i] > j: DP[i][j] = DP[i-1][j]
      else: DP[i][j] = DP[i-1][j] OR DP[i-1][j - A[i]]
  return DP[n][s]")

#box-rule[
  *Complessità:* tempo e spazio $O(n s)$ — *pseudo-polinomiale*: dipende dal *valore* di $s$, non dal numero di bit necessari a rappresentarlo. Partition è NP-completo: se $s$ cresce esponenzialmente nei bit dell'input, l'algoritmo non è trattabile.
]

== Checklist d'esame (PD)

#box-rule[
  + Enuncia $"DP"[dots]$ a parole (non solo in formule).
  + Scrivi la ricorrenza con tutti i casi (inclusi quelli di frontiera).
  + Specifica esplicitamente i casi base.
  + Giustifica l'ordine dei cicli.
  + Mostra il contenuto della tabella su un esempio piccolo.
  + Analizza tempo e spazio.
  + Se il problema chiede la soluzione ottima e non solo il valore, mostra la tabella $"pred"$ e il procedimento di ricostruzione.
]
