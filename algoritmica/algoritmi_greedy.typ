#import "../template.typ": *

== Strategia Greedy

Gli *algoritmi greedy* (o *avidi*) costruiscono una soluzione facendo, ad ogni passo, la scelta che sembra *localmente migliore*, senza mai tornare indietro a riconsiderarla. La speranza è che una sequenza di scelte localmente ottime conduca a una soluzione globalmente ottima. Diversamente dalla programmazione dinamica, che esplora *tutte* le decisioni rilevanti memorizzando i risultati, un algoritmo greedy fa una sola scelta ad ogni passo: per questo è tipicamente più veloce, ma applicabile solo quando il problema soddisfa proprietà specifiche.

=== Quando funziona la strategia greedy

Perché un algoritmo greedy produca una soluzione ottima, il problema deve godere di due proprietà:

#ricorda[
  *Proprietà di scelta greedy.* Esiste una scelta locale (un "primo passo") che fa parte di *almeno una* soluzione globalmente ottima. Questa proprietà permette di compiere la scelta senza riconsiderarla: la soluzione ottima del sotto-problema rimanente, combinata con la scelta greedy, dà una soluzione ottima del problema originale.

  *Sottostruttura ottima.* La soluzione ottima del problema contiene al suo interno la soluzione ottima dei sotto-problemi (proprietà condivisa con la PD).
]

La differenza chiave rispetto alla PD è che, in un algoritmo greedy, *non occorre esplorare tutte le possibili scelte iniziali*: si dimostra a priori (con un argomento di scambio o di scelta) che la scelta greedy è sicuramente parte di una soluzione ottima.

=== Schema di un algoritmo greedy

Un algoritmo greedy si articola tipicamente in tre fasi:

+ *Ordinamento o organizzazione degli elementi* secondo un criterio (peso, valore, scadenza, rapporto, ecc.).
+ *Iterazione*: a ogni passo si seleziona l'elemento "migliore" rispetto al criterio, lo si aggiunge alla soluzione se ammissibile, e si aggiorna lo stato.
+ *Terminazione*: l'algoritmo si arresta quando non ci sono più elementi da considerare o un vincolo è saturato.

#attenzione[
  La parte difficile non è scrivere l'algoritmo, ma *dimostrare* che è ottimo. Per molti problemi un approccio greedy intuitivo dà soluzioni sub-ottime: è essenziale verificare la proprietà di scelta greedy prima di affidarsi a questa strategia.
]

== Il problema dello Zaino Frazionario

Il problema dello *zaino frazionario* è una variante dello zaino 0-1 in cui è ammesso prendere *frazioni* arbitrarie di ciascun oggetto. Sorprendentemente, questa modifica apparentemente innocua trasforma il problema da NP-difficile (nella versione 0-1, di fatto pseudo-polinomiale) a uno risolvibile in tempo $O(n log n)$ con un algoritmo greedy.

=== Definizione del problema

#definizione(titolo: "Zaino Frazionario (Fractional Knapsack)")[
  Dati $n$ oggetti, ciascuno con peso $p_i > 0$ e valore $v_i > 0$ ($i = 1, dots, n$), e una *capacità* $W > 0$, trovare frazioni $x_1, dots, x_n in [0, 1]$ che *massimizzino* il valore totale
  $ sum_(i=1)^n x_i v_i $
  sotto il vincolo di peso
  $ sum_(i=1)^n x_i p_i <= W. $
  Diversamente dallo Zaino 0-1, ogni $x_i$ può assumere qualsiasi valore reale in $[0, 1]$: un oggetto può essere preso interamente, parzialmente o non preso.
]

#esempio(titolo: "Differenza con lo Zaino 0-1")[
  Zaino di capacità $W = 50$. Tre oggetti con pesi $(10, 20, 30)$ e valori $(60, 100, 120)$.

  - *Zaino 0-1*: la soluzione ottima prende gli oggetti 1 e 2 (peso $30$, valore $160$) oppure 1 e 3 (peso $40$, valore $180$), o 2 e 3 (peso $50$, valore $220$). L'ottimo è ${2, 3}$ con valore $220$.
  - *Zaino frazionario*: con la stessa istanza si può fare meglio prendendo per intero gli oggetti 1 e 2 (peso $30$, valore $160$) e una frazione $2/3$ dell'oggetto 3 (peso $20$, valore $80$), per un totale di valore $240 > 220$.
]

=== Strategia greedy: rapporto valore/peso

L'idea greedy è ordinare gli oggetti per *rapporto valore/peso decrescente* e prenderli, uno alla volta, nell'ordine: ogni oggetto viene preso interamente finché c'è spazio sufficiente; quando non c'è più spazio per un oggetto intero, si prende la frazione che esaurisce esattamente la capacità rimasta.

#nota(titolo: [Perché il rapporto $v_i \/ p_i$?])[
  Il rapporto $r_i = v_i / p_i$ misura quanto valore ogni unità di peso porta. Se vogliamo massimizzare il valore totale rispettando un budget di peso, conviene "comprare" prima il valore più conveniente per unità di peso. La possibilità di prendere frazioni garantisce che possiamo riempire esattamente la capacità.
]

=== Algoritmo

#algoritmo(titolo: "Fractional-Knapsack(p, v, n, W)")[
  ```
  Fractional-Knapsack(p, v, n, W) {
      // p, v: array dei pesi e dei valori; n: numero oggetti; W: capacità
      // Calcola i rapporti r[i] = v[i]/p[i]
      r = nuovo array di dimensione n;
      for (i = 1; i <= n; i++) { r[i] = v[i] / p[i]; }
      // Ordina gli indici 1..n per r decrescente
      ordina-indici-per-r-decrescente(r, ind);
      x = nuovo array di dimensione n inizializzato a 0;
      peso-corrente = 0;
      i = 1;
      while (i <= n && peso-corrente < W) {
          j = ind[i];
          if (peso-corrente + p[j] <= W) {
              x[j] = 1;
              peso-corrente := peso-corrente + p[j];
          } else {
              x[j] = (W - peso-corrente) / p[j];
              peso-corrente := W;
          }
          i := i + 1;
      }
      return x;
  }
  ```
]

*Complessità*: l'ordinamento per rapporto decrescente costa $Theta(n log n)$. Il ciclo while esegue al più $n$ iterazioni a costo $Theta(1)$ ciascuna, $Theta(n)$ totale. Il costo dominante è l'ordinamento:

$ T(n) = Theta(n log n). $

=== Correttezza

#teorema(titolo: "Ottimalità dell'algoritmo greedy per lo zaino frazionario")[
  L'algoritmo Fractional-Knapsack restituisce una soluzione ottima per il problema dello zaino frazionario.
]

#dimostrazione(stile: "argomento di scambio")[
  Senza perdita di generalità, supponiamo gli oggetti già ordinati per rapporto decrescente: $r_1 >= r_2 >= dots.c >= r_n$ con $r_i = v_i / p_i$. Sia $X = (x_1, dots, x_n)$ la soluzione prodotta dall'algoritmo greedy e $Y = (y_1, dots, y_n)$ una qualunque soluzione ottima.

  Se $X = Y$ non c'è nulla da dimostrare. Altrimenti sia $k$ il *primo indice* in cui differiscono. Poiché l'algoritmo greedy massimizza la frazione di $k$ data la capacità rimanente, deve essere $x_k > y_k$ (greedy è almeno aggressivo come $Y$ sull'oggetto migliore disponibile a quel passo).

  *Idea dello scambio.* Aumentiamo $y_k$ di una quantità $delta = x_k - y_k > 0$. Per mantenere il vincolo di peso, dobbiamo ridurre la quantità presa di oggetti successivi (con $j > k$) per un peso totale di $delta dot p_k$. La variazione di valore prodotta dallo scambio è:
  $ Delta v = delta dot v_k - sum_(j > k) (delta_j dot v_j) $
  dove $delta_j$ sono le riduzioni applicate a $y_j$ (con $sum_j delta_j dot p_j = delta dot p_k$). Poiché $r_j <= r_k$ per $j > k$:
  $ sum_(j > k) delta_j dot v_j = sum_(j > k) delta_j p_j dot r_j <= r_k sum_(j > k) delta_j p_j = r_k dot delta p_k = delta dot v_k. $
  Quindi $Delta v >= 0$: la nuova soluzione $Y'$ ha valore $>= $ valore di $Y$, ed è ottima. Iterando l'argomento, si trasforma $Y$ in $X$ senza decrementare mai il valore: dunque $X$ è ottima.
]

=== Esempio passo-passo

#esempio(titolo: "Risoluzione passo-passo")[
  $W = 50$. Oggetti:

  #table(
    columns: 5,
    align: (center, center, center, center, center),
    stroke: 0.5pt,
    [*$i$*], [*$p_i$*], [*$v_i$*], [*$r_i = v_i \/ p_i$*], [*posizione (ordinata)*],
    [1], [10], [60], [6], [1],
    [2], [20], [100], [5], [2],
    [3], [30], [120], [4], [3],
  )

  Gli oggetti sono già ordinati per rapporto decrescente: $r_1 = 6, r_2 = 5, r_3 = 4$.

  *Iterazioni:*
  - $i = 1$ (oggetto 1, $p_1 = 10$): peso corrente $0$, $0 + 10 = 10 <= 50$ → $x_1 = 1$, peso $= 10$.
  - $i = 2$ (oggetto 2, $p_2 = 20$): $10 + 20 = 30 <= 50$ → $x_2 = 1$, peso $= 30$.
  - $i = 3$ (oggetto 3, $p_3 = 30$): $30 + 30 = 60 > 50$ → $x_3 = (50 - 30)/30 = 2/3$, peso $= 50$.
  - Ciclo terminato.

  *Soluzione*: $x = (1, 1, 2/3)$. Valore totale:
  $ sum_(i=1)^3 x_i v_i = 1 dot 60 + 1 dot 100 + (2/3) dot 120 = 60 + 100 + 80 = 240. $
]

=== Lo Zaino 0-1 non ammette soluzione greedy ottima

#attenzione[
  La strategia "ordina per $v_i / p_i$ decrescente e prendi gli oggetti finché entrano" *non funziona per lo Zaino 0-1*. Il vincolo $x_i in {0, 1}$ rompe la proprietà di scelta greedy.
]

#esempio(titolo: "Controesempio per Zaino 0-1")[
  Tre oggetti con $(p, v) = ((10, 60), (20, 100), (30, 120))$ e $W = 50$.

  Rapporti: $6, 5, 4$. La strategia greedy prende oggetto 1 (peso $10$) e oggetto 2 (peso $30$), per un valore totale di $160$. Non c'è spazio per l'oggetto 3 (peso $30$, ma capacità rimanente $20$).

  *Soluzione ottima per 0-1*: prendere oggetto 2 e oggetto 3 (peso $50$, valore $220$), oppure oggetto 1 e oggetto 3 (peso $40$, valore $180$). L'ottimo è $220$, *strettamente maggiore* di $160$.

  Per lo Zaino 0-1 la programmazione dinamica resta indispensabile.
]

#ricorda[
  *Confronto Zaino frazionario vs Zaino 0-1:*

  #table(
    columns: 3,
    align: (left, center, center),
    stroke: 0.5pt,
    [*Aspetto*], [*Frazionario*], [*0-1*],
    [Vincolo su $x_i$], [$x_i in [0, 1]$], [$x_i in {0, 1}$],
    [Strategia], [greedy: rapporto $v_i \/ p_i$ decrescente], [PD bottom-up],
    [Complessità], [$O(n log n)$], [$Theta(n W)$ pseudo-polinomiale],
    [Proprietà di scelta greedy], [vale], [non vale],
  )
]
