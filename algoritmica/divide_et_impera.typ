#import "../template.typ": *

== Il paradigma Divide et Impera

Il *Divide et Impera* (dal latino _divide et impera_) è uno dei paradigmi algoritmici fondamentali. Alla base della sua struttura vi sono tre fasi:

+ *Divide*: si suddivide il problema originale in due o più sotto-problemi _dello stesso tipo_, ciascuno operante su un sottoinsieme dei dati originali. La dimensione di ciascun sotto-problema è strettamente minore di quella del problema di partenza.

+ *Impera* (conquista): si risolvono i sotto-problemi in modo ricorsivo, applicando la stessa tecnica. Quando la dimensione del sotto-problema raggiunge un caso base (dimensione sufficientemente piccola), lo si risolve direttamente.

+ *Combina*: si fondono le soluzioni dei sotto-problemi per costruire la soluzione del problema originale.

#figure(
  image("../images/divide_et_impera.png", width: 50%),
)

La struttura generale di un algoritmo Divide et Impera è la seguente:

#algorithm(title: "Schema generale Divide et Impera")[
  ```
  soluzione DivideEtImpera(problema P) {
      if (P è un caso base) {
          return risolviDirettamente(P);
      }
      dividi P in sotto-problemi P1, P2, ..., Pa;
      soluzione s1 = DivideEtImpera(P1);
      soluzione s2 = DivideEtImpera(P2);
      ...
      soluzione sa = DivideEtImpera(Pa);
      return combina(s1, s2, ..., sa);
  }
  ```
]

La complessità di un algoritmo Divide et Impera è descritta da una *relazione di ricorrenza* della forma:
$ T(n) = underbrace(a, "num. sotto-problemi") dot T(n\/b) + underbrace(f(n), "costo divide + combina") $
dove $a >= 1$ è il numero di sotto-problemi, $b > 1$ è il fattore di riduzione, e $f(n)$ rappresenta il costo delle fasi di divisione e combinazione.

== Ricerca Binaria

La ricerca binaria è un algoritmo classico di tipo Divide et Impera per cercare un elemento $k$ in un array $A[p..r]$ *ordinato*. L'idea è la seguente: si confronta $k$ con l'elemento centrale dell'array; se $k$ è uguale all'elemento centrale, la ricerca termina; altrimenti si prosegue ricorsivamente nella metà sinistra (se $k$ è minore) o nella metà destra (se $k$ è maggiore).

=== Implementazione e complessità

*Input*: array ordinato $A[p..r]$ di interi, elemento $k$ da cercare. \
*Output*: indice $i$ tale che $A[i] = k$, oppure $-1$ se $k$ non è presente.

#algorithm(title: "Ricerca Binaria")[
  ```
  int binarySearch(int[] A, int p, int r, int k){
      if(p > r){
          return -1;
      }
      if(p == r){
          if(A[p] == k){
              return p;
          } else {
              return -1;
          }
      }
      int q = (p + r) / 2;
      if(A[q] == k){
          return q;
      }
      if(A[q] > k){
          return binarySearch(A, p, q - 1, k);
      } else {
          return binarySearch(A, q + 1, r, k);
      }
  }
  ```
]

Analizziamo la complessità. Sia $n = r - p + 1$ la dimensione del sotto-array corrente:
- *Divide*: il calcolo del punto medio $q$ costa $Theta(1)$.
- *Impera*: si effettua *una sola* chiamata ricorsiva su un sotto-array di dimensione al più $n\/2$.
- *Combina*: il risultato della chiamata ricorsiva è già la risposta, quindi il costo di combinazione è $Theta(1)$.

La relazione di ricorrenza è:
$ T(n) = cases(
  Theta(1) & "se" n <= 1,
  T(n\/2) + Theta(1) & "se" n >= 2
) $

dove $f(n) = D(n) + C(n) = Theta(1)$ (costo di divide + combina).

#theorem(title: "Complessità della Ricerca Binaria")[
  La ricerca binaria su un array ordinato di $n$ elementi ha complessità nel caso pessimo $Theta(log n)$ e nel caso ottimo $Theta(1)$ (quando l'elemento cercato si trova esattamente nella posizione centrale al primo confronto).
]

=== Correttezza

La correttezza di un algoritmo Divide et Impera si dimostra tipicamente per *induzione forte* sulla dimensione $n$ del problema.

- *Caso base* ($n <= 1$): se $p > r$ l'array è vuoto e si restituisce $-1$; se $p = r$ si confronta direttamente $A[p]$ con $k$. In entrambi i casi l'algoritmo è corretto.

- *Passo induttivo*: si assume, per *ipotesi induttiva*, che l'algoritmo sia corretto per ogni input di dimensione $n' < n$ (con $n' >= 0$). Si deve dimostrare che è corretto per input di dimensione $n$. Poiché l'array è ordinato, dopo il confronto con $A[q]$:
  - se $A[q] = k$, l'indice $q$ è restituito correttamente;
  - se $A[q] > k$, allora $k$ può trovarsi solo in $A[p..q-1]$ (dimensione $< n$), e per ipotesi induttiva la chiamata ricorsiva restituisce il risultato corretto;
  - se $A[q] < k$, il ragionamento è simmetrico su $A[q+1..r]$.

=== Varianti della Ricerca Binaria

La ricerca binaria standard trova _una_ occorrenza di un elemento, ma non garantisce quale (prima, ultima, o una qualsiasi). Le seguenti varianti permettono di trovare specificamente la prima o l'ultima occorrenza.

==== Ricerca Binaria Sinistra

Trova la *prima occorrenza* (più a sinistra) di un elemento $k$ in un array ordinato.

#algorithm(title: "Ricerca Binaria Sinistra")[
  ```
  int ricercaBinariaSx(int[] a, int sx, int dx, int k) {
      if (sx > dx) {
          return -1;
      }
      int cx = (sx + dx) / 2;
      if (a[cx] == k and (cx == sx or a[cx - 1] != k)) {
          return cx;
      }
      if (a[cx] >= k) {
          return ricercaBinariaSx(a, sx, cx - 1, k);
      } else {
          return ricercaBinariaSx(a, cx + 1, dx, k);
      }
  }
  ```
]

*Idea*: quando troviamo $k$ in posizione $"cx"$, verifichiamo se è la prima occorrenza controllando che:
- $"cx" = "sx"$ (siamo al bordo sinistro del sotto-array), oppure
- $a["cx" - 1] != k$ (l'elemento precedente è diverso da $k$).

Se la condizione non è soddisfatta, $k$ compare anche a sinistra di $"cx"$, quindi si prosegue la ricerca nella metà sinistra. La complessità resta $O(log n)$.

==== Ricerca Binaria Destra

Trova l'*ultima occorrenza* (più a destra) di un elemento $k$ in un array ordinato.

#algorithm(title: "Ricerca Binaria Destra")[
  ```
  int ricercaBinariaDx(int[] a, int sx, int dx, int k) {
      if (sx > dx) {
          return -1;
      }
      int cx = (sx + dx) / 2;
      if (a[cx] == k and (cx == dx or a[cx + 1] != k)) {
          return cx;
      }
      if (a[cx] <= k) {
          return ricercaBinariaDx(a, cx + 1, dx, k);
      } else {
          return ricercaBinariaDx(a, sx, cx - 1, k);
      }
  }
  ```
]

*Idea*: simmetricamente alla variante sinistra, quando troviamo $k$ in posizione $"cx"$, verifichiamo se è l'ultima occorrenza controllando che:
- $"cx" = "dx"$ (siamo al bordo destro del sotto-array), oppure
- $a["cx" + 1] != k$ (l'elemento successivo è diverso da $k$).

Se la condizione non è soddisfatta, si prosegue nella metà destra. La complessità resta $O(log n)$.

==== Conta Occorrenze

Combinando le due varianti si può contare il numero di occorrenze di $k$ in un array ordinato in tempo $Theta(log n)$.

#algorithm(title: "Conta Occorrenze")[
  ```
  int contaOccorrenze(int[] a, int n, int k) {
      int prima = ricercaBinariaSx(a, 0, n - 1, k);
      if (prima == -1) {
          return 0;
      }
      int ultima = ricercaBinariaDx(a, 0, n - 1, k);
      return ultima - prima + 1;
  }
  ```
]

#note(title: "Complessità di contaOccorrenze")[
  Si eseguono al massimo due ricerche binarie, ciascuna con complessità $O(log n)$: la complessità totale è quindi $Theta(log n)$. Un approccio lineare che scorre l'intero array richiederebbe $Theta(n)$, dunque le varianti della ricerca binaria offrono un miglioramento significativo per array di grandi dimensioni.
]

== Merge Sort

Il Merge Sort è un algoritmo di ordinamento basato sul paradigma Divide et Impera. L'idea è la seguente:

+ *Divide*: si divide l'array $A[p..r]$ in due metà $A[p..q]$ e $A[q+1..r]$, dove $q = floor((p + r) \/ 2)$.
+ *Impera*: si ordinano ricorsivamente le due metà.
+ *Combina*: si fondono (_merge_) le due metà ordinate in un unico array ordinato.

=== Implementazione

#algorithm(title: "Merge Sort")[
  ```
  mergeSort(int[] A, int p, int r){        // -- T(n)
      if(p < r){                           // -- Theta(1)
          int q = (p + r) / 2;             // divide -- Theta(1)
          mergeSort(A, p, q);              // impera -- T(n/2)
          mergeSort(A, q + 1, r);          // impera -- T(n/2)
          merge(A, p, q, r);               // combina -- Theta(n)
      }
  }
  ```
]

#figure(
  image("../images/merge_sort.png", width: 30%),
)

La procedura `merge` fonde due sotto-array ordinati $A[p..q]$ e $A[q+1..r]$ in un unico sotto-array ordinato $A[p..r]$, utilizzando due array ausiliari $L$ e $R$.

#algorithm(title: "Procedura Merge")[
  ```
  merge(int[] A, int p, int q, int r){
      int n1 = q - p + 1;
      int n2 = r - q;
      int[] L = new int[n1 + 1];
      int[] R = new int[n2 + 1];

      int i = 1;
      while(i <= n1){
          L[i] := A[p + i - 1];
          i := i + 1;
      }
      int j = 1;
      while(j <= n2){
          R[j] := A[q + j];
          j := j + 1;
      }
      L[n1 + 1] := +∞;
      R[n2 + 1] := +∞;

      i := 1;
      j := 1;
      int k = p;
      while(k <= r){
          if(L[i] <= R[j]){
              A[k] := L[i];
              i := i + 1;
          } else {
              A[k] := R[j];
              j := j + 1;
          }
          k := k + 1;
      }
  }
  ```
]

#note(title: "Funzionamento di Merge")[
  La procedura `merge` utilizza due *sentinelle* $+infinity$ alla fine degli array ausiliari $L$ e $R$: quando un array ausiliario è stato completamente percorso, la sentinella garantisce che il confronto selezioni sempre l'elemento dall'altro array, senza necessità di controlli aggiuntivi sugli indici. Ogni iterazione del ciclo `while` copia esattamente un elemento in $A$, per un totale di $n_1 + n_2 = r - p + 1$ iterazioni. La complessità di `merge` è dunque $Theta(n)$.
]

=== Correttezza di Merge

La correttezza della procedura `merge` si dimostra tramite la seguente *invariante di ciclo* sul ciclo `while(k <= r)`:

*Invariante:* all'inizio di ogni iterazione del ciclo, il sotto-array $A[p..k-1]$ contiene i $k - p$ elementi più piccoli di $L[1..n_1+1]$ e $R[1..n_2+1]$, ordinati. Inoltre, $L[i]$ e $R[j]$ sono i più piccoli elementi dei rispettivi array che non sono ancora stati copiati in $A$.

- *Inizializzazione:* prima della prima iterazione, $k = p$ e il sotto-array $A[p..k-1]$ è vuoto. Si ha $i = 1$ e $j = 1$, dunque $L[1]$ e $R[1]$ sono i più piccoli elementi non ancora copiati.

- *Conservazione:* supponiamo che l'invariante sia vera all'inizio di un'iterazione. Se $L[i] <= R[j]$, allora $L[i]$ è il più piccolo elemento non ancora copiato in $A$; viene posto in $A[k]$ e $i$ viene incrementato. Il sotto-array $A[p..k]$ contiene ora i $k - p + 1$ elementi più piccoli, ordinati. Il caso $L[i] > R[j]$ è simmetrico. In entrambi i casi, incrementando $k$ si ripristina l'invariante.

- *Conclusione:* alla terminazione, $k = r + 1$. Per l'invariante, il sotto-array $A[p..r]$ contiene gli $r - p + 1$ elementi di $L$ e $R$ in ordine, escluse le sentinelle. Dunque la procedura `merge` è corretta.

=== Relazione di ricorrenza e complessità

La relazione di ricorrenza del Merge Sort è:
$ T(n) = cases(
  Theta(1) & "se" n = 1,
  2T(n\/2) + Theta(n) & "se" n > 1
) $

Per comprendere intuitivamente la complessità, si può analizzare l'*albero di ricorsione*: a ciascun livello $i$ dell'albero vi sono $2^i$ sotto-problemi, ciascuno di dimensione $n \/ 2^i$. Il costo al livello $i$ è $2^i dot c dot (n \/ 2^i) = c dot n = Theta(n)$. L'albero ha $log_2 n$ livelli, dunque il costo totale è $Theta(n log n)$.

#figure(
  image("../images/albero_ricorsione_merge_sort.png", width: 25%),
)

#figure(
  image("../images/chiamate_ricorsive_albero_ms.png", width: 30%),
)

#theorem(title: "Complessità del Merge Sort")[
  La complessità in tempo del Merge Sort è $Theta(n log n)$ in *tutti i casi* (ottimo, medio, pessimo). La complessità in spazio è $O(n)$, dovuta agli array ausiliari utilizzati dalla procedura `merge`.
]

#note(title: "Relazione di ricorrenza vs. complessità")[
  La *relazione di ricorrenza* è la definizione matematica del costo di un algoritmo ricorsivo in funzione dell'input: descrive $T(n)$ in termini di $T$ applicata a sotto-problemi più piccoli. La *complessità* è il risultato della risoluzione di tale relazione, espressa in notazione asintotica.
]

== Relazioni di ricorrenza

Le relazioni di ricorrenza sono lo strumento matematico per descrivere la complessità $T(n)$ di algoritmi ricorsivi. Distinguiamo due forme principali.

=== Relazioni bilanciate

Una relazione di ricorrenza si dice *bilanciata* quando i sotto-problemi hanno tutti la stessa dimensione:
$ T(n) = cases(
  Theta(1) & "se" n <= n_0,
  underbrace(a, "sotto-problemi") dot T(n\/b) + underbrace(f(n), "forzante") & "se" n > n_0
) $
dove $a in bb(N)^+$ (numero di sotto-problemi), $b > 1, b in bb(Q)$ (fattore di riduzione), e $f(n)$ è il termine *forzante* che rappresenta il costo delle fasi di divisione e combinazione.

La ricerca binaria ($a=1$, $b=2$, $f(n)=Theta(1)$) e il Merge Sort ($a=2$, $b=2$, $f(n)=Theta(n)$) sono esempi di relazioni bilanciate.

=== Relazioni di ordine $k$

Una relazione è di *ordine $k$* quando $T(n)$ dipende dai $k$ valori precedenti:
$ T(n) = cases(
  Theta(1) & "se" n <= n_0,
  alpha_1 T(n-1) + alpha_2 T(n-2) + dots.c + alpha_k T(n-k) + f(n) & "se" n > n_0
) $

Queste relazioni si risolvono con il *metodo dell'equazione caratteristica*. L'idea è la seguente: per la parte omogenea (cioè con $f(n) = 0$), si cerca una soluzione della forma $T(n) = x^n$. Sostituendo nella ricorrenza si ottiene:
$ x^n = alpha_1 x^(n-1) + alpha_2 x^(n-2) + dots.c + alpha_k x^(n-k) $
Dividendo per $x^(n-k)$ si ricava l'*equazione caratteristica*:
$ x^k - alpha_1 x^(k-1) - alpha_2 x^(k-2) - dots.c - alpha_k = 0 $
Se le $k$ radici $x_1, x_2, ..., x_k$ sono distinte, la soluzione generale è:
$ T(n) = c_1 x_1^n + c_2 x_2^n + dots.c + c_k x_k^n $
dove le costanti $c_1, ..., c_k$ si determinano dalle condizioni iniziali. Dal punto di vista asintotico, il termine dominante è quello con la radice di modulo massimo.

#example(title: "Fibonacci come relazione di ordine 2")[
  La successione di Fibonacci soddisfa $T(n) = T(n-1) + T(n-2)$, con $alpha_1 = 1$ e $alpha_2 = 1$.

  L'equazione caratteristica è:
  $ x^2 - x - 1 = 0 $
  Le radici sono:
  $ phi = frac(1 + sqrt(5), 2) approx 1.618 #h(2em) hat(phi) = frac(1 - sqrt(5), 2) approx -0.618 $
  La soluzione generale è $T(n) = c_1 phi^n + c_2 hat(phi)^n$. Poiché $|hat(phi)| < 1$, il termine $hat(phi)^n -> 0$ e il termine dominante è $phi^n$, da cui:
  $ T(n) = Theta(phi^n) approx Theta(1.618^n) $
  La complessità della successione di Fibonacci è dunque *esponenziale*.
]

=== Metodi di risoluzione

Esistono quattro metodi principali per risolvere le relazioni di ricorrenza:
+ *Metodo iterativo*: si espande (srotola) la ricorrenza fino a raggiungere i casi base, poi si somma il lavoro a tutti i livelli.
+ *Metodo di sostituzione*: si ipotizza una soluzione e la si dimostra per induzione.
+ *Albero di ricorsione*: ausilio grafico che rappresenta i costi ai vari livelli della ricorsione; spesso usato per formulare un'ipotesi da verificare col metodo di sostituzione.
+ *Master Theorem*: formula chiusa applicabile alle relazioni bilanciate (vedi sezione successiva).

#example(title: "Metodo di sostituzione: MergeSort")[
  Il metodo di sostituzione consiste in due passi: (1) si *ipotizza* la forma della soluzione, (2) si usa l'*induzione matematica* per dimostrare che l'ipotesi è corretta e per trovare le costanti.

  Consideriamo la ricorrenza $T(n) = 2T(n\/2) + n$. Ipotizziamo che $T(n) = O(n log n)$, cioè che esista una costante $c > 0$ tale che $T(n) <= c dot n dot log n$ per ogni $n >= n_0$.

  *Passo induttivo:* supponiamo $T(n\/2) <= c dot (n\/2) dot log(n\/2)$ (ipotesi induttiva). Sostituendo nella ricorrenza:
  $ T(n) &<= 2 dot c dot (n\/2) dot log(n\/2) + n \
         &= c dot n dot log(n\/2) + n \
         &= c dot n dot log n - c dot n dot log 2 + n \
         &= c dot n dot log n - c dot n + n \
         &<= c dot n dot log n $
  dove l'ultima disuguaglianza vale per $c >= 1$.

  *Caso base:* per $n = 1$ si ha $T(1) = Theta(1)$, e dobbiamo verificare $T(1) <= c dot 1 dot log 1 = 0$, che non è soddisfatta. Tuttavia, possiamo scegliere $n_0 = 2$ come caso base: la condizione al contorno non influisce sul comportamento asintotico, purché la costante $c$ sia sufficientemente grande. In particolare, basta scegliere $c >= T(2) \/ (2 dot log 2)$.

  Si conclude che $T(n) = O(n log n)$.
]

#note(title: "Insidie del metodo di sostituzione")[
  Il metodo di sostituzione richiede di ipotizzare la forma esatta della soluzione, e un'ipotesi troppo debole (per esempio $T(n) <= c dot n$) o un errore nel trattamento dei termini di ordine inferiore possono far fallire la dimostrazione. È fondamentale che l'ipotesi induttiva sia applicata _esattamente_ nella stessa forma in cui si vuole dimostrare il risultato.
]

#example(title: "Metodo iterativo: MergeSort")[
  Consideriamo la ricorrenza del MergeSort: $T(n) = 2T(n\/2) + n$ (con $T(1) = Theta(1)$).

  Si *srotola* (unrolling) la ricorrenza sostituendo ripetutamente la definizione di $T$:
  $ T(n) &= 2T(n\/2) + n \
         &= 2[2T(n\/4) + n\/2] + n = 4T(n\/4) + 2n \
         &= 4[2T(n\/8) + n\/4] + 2n = 8T(n\/8) + 3n \
         &= dots.c \
         &= 2^k T(n\/2^k) + k n $

  Il processo termina quando il sotto-problema raggiunge il caso base, cioè quando $n\/2^k = 1$, ovvero $k = log_2 n$. Sostituendo:
  $ T(n) = 2^(log_2 n) dot T(1) + n log_2 n = n dot Theta(1) + n log n = Theta(n log n) $

  Il risultato coincide con quello ottenuto tramite il Master Theorem.
]

=== Metodo dell'albero di ricorsione

In un *albero di ricorsione* ogni nodo rappresenta il costo di un singolo sotto-problema nell'insieme delle chiamate ricorsive di funzione. Sommiamo i costi all'interno di ogni livello dell'albero per ottenere un insieme di costi per livello; poi sommiamo tutti i costi per livello per determinare il costo totale di tutti i livelli della ricorsione.

L'albero di ricorsione è particolarmente efficace in due situazioni:
+ quando si desidera una comprensione *visiva* della distribuzione del costo tra i livelli della ricorsione;
+ quando la ricorrenza non è nella forma standard $T(n) = a T(n\/b) + f(n)$ e il Master Theorem non è applicabile (ad esempio ricorrenze con sotto-problemi di dimensioni diverse).

Il metodo si articola in tre passi:
+ *Costruire l'albero*: la radice contiene il costo della forzante $f(n)$; ogni nodo genera tanti figli quante sono le chiamate ricorsive, ciascuno col costo del sotto-problema corrispondente.
+ *Sommare per livello*: si calcola il costo totale di ogni livello dell'albero.
+ *Sommare i livelli*: si sommano i costi di tutti i livelli, ottenendo una formula (spesso una serie geometrica) che fornisce un'ipotesi per $T(n)$.

L'ipotesi ottenuta dall'albero di ricorsione può essere usata direttamente come soluzione (quando i calcoli sono esatti), oppure può essere verificata rigorosamente col metodo di sostituzione.

#example(title: "Albero di ricorsione: ricorrenza bilanciata")[
  L'albero di ricorsione è particolarmente utile per formulare un'ipotesi sulla soluzione di ricorrenze per le quali il Master Theorem non è immediatamente applicabile, o per le quali si desidera una comprensione visiva del costo.

  Consideriamo la ricorrenza $T(n) = 3T(n\/4) + c n^2$.

  Si costruisce l'albero ponendo alla radice il costo $c n^2$. Ogni nodo genera 3 figli, ciascuno con un sotto-problema di dimensione $n\/4$:

  #align(center, cetz.canvas({
    import cetz.draw: *

    // Livello 0: radice
    circle((0, 0), radius: 0.45, fill: white, stroke: 0.5pt + black)
    content((0, 0), text(size: 8pt)[$c n^2$])
    content((4, 0), text(size: 8pt, fill: luma(80))[$c n^2$])

    // Livello 1: 3 nodi
    for (i, xpos) in ((-2.5, 0, 2.5)).enumerate() {
      circle((xpos, -1.5), radius: 0.4, fill: white, stroke: 0.5pt + black)
      content((xpos, -1.5), text(size: 7pt)[$c(n\/4)^2$])
      line((0, -0.45), (xpos, -1.1), stroke: 0.5pt + luma(120))
    }
    content((4.5, -1.5), text(size: 8pt, fill: luma(80))[$(3\/16) c n^2$])

    // Livello 2: 9 nodi (mostriamo 3 gruppi da 3 con punti)
    let x2-offsets = (-3.5, -2.5, -1.5, -0.8, 0, 0.8, 1.5, 2.5, 3.5)
    for (i, xpos) in x2-offsets.enumerate() {
      circle((xpos, -3.0), radius: 0.3, fill: white, stroke: 0.5pt + black)
      content((xpos, -3.0), text(size: 5pt)[$c(n\/16)^2$])
      // archi dal livello 1
      let parent-x = if i < 3 { -2.5 } else if i < 6 { 0 } else { 2.5 }
      line((parent-x, -1.9), (xpos, -2.7), stroke: 0.4pt + luma(140))
    }
    content((4.5, -3.0), text(size: 8pt, fill: luma(80))[$(3\/16)^2 c n^2$])

    // Punti verticali per livelli intermedi
    for xpos in (-2.5, 0, 2.5) {
      content((xpos, -4.0), text(size: 12pt, fill: luma(120))[$dots.v$])
    }

    // Foglie
    content((0, -5.0), text(size: 8pt, fill: luma(80))[$n^(log_4 3)$ foglie, costo $Theta(1)$ ciascuna])

    // Etichetta livelli
    content((-5, 0), text(size: 7pt, fill: luma(100))[Liv. 0])
    content((-5, -1.5), text(size: 7pt, fill: luma(100))[Liv. 1])
    content((-5, -3.0), text(size: 7pt, fill: luma(100))[Liv. 2])
    content((-5, -5.0), text(size: 7pt, fill: luma(100))[Liv. $log_4 n$])
  }))

  - *Livello 0* (radice): un nodo con costo $c n^2$. Costo totale: $c n^2$.
  - *Livello 1*: 3 nodi, ciascuno con costo $c(n\/4)^2 = c n^2\/16$. Costo totale: $3 dot c n^2 \/ 16 = (3\/16) dot c n^2$.
  - *Livello 2*: $3^2 = 9$ nodi, ciascuno con costo $c(n\/16)^2 = c n^2 \/ 256$. Costo totale: $9 dot c n^2 \/ 256 = (3\/16)^2 dot c n^2$.
  - *Livello $i$*: $3^i$ nodi, ciascuno con costo $c(n\/4^i)^2$. Costo totale: $(3\/16)^i dot c n^2$.

  L'albero ha $log_4 n$ livelli (i sotto-problemi raggiungono dimensione 1 quando $n\/4^i = 1$). Le foglie al livello $log_4 n$ sono $3^(log_4 n) = n^(log_4 3)$, ciascuna con costo $Theta(1)$.

  Il costo totale è la somma su tutti i livelli:
  $ T(n) = sum_(i=0)^(log_4 n - 1) (3\/16)^i dot c n^2 + Theta(n^(log_4 3)) $

  Poiché $3\/16 < 1$, la serie geometrica converge:
  $ sum_(i=0)^(infinity) (3\/16)^i = frac(1, 1 - 3\/16) = 16\/13 $

  Dunque il costo dei nodi interni è limitato superiormente da $(16\/13) dot c n^2 = O(n^2)$. Poiché $log_4 3 approx 0.793 < 2$, il costo delle foglie $Theta(n^(log_4 3))$ è di ordine inferiore. Si ottiene $T(n) = Theta(n^2)$.

  Questa ipotesi può essere verificata rigorosamente con il metodo di sostituzione, oppure confermata direttamente applicando il Master Theorem (Caso 3, con $a = 3$, $b = 4$, $f(n) = c n^2$, $c_("crit") = log_4 3 approx 0.793$).
]

#example(title: "Albero di ricorsione: ricorrenza con sotto-problemi di dimensioni diverse")[
  Consideriamo la ricorrenza $T(n) = T(n\/3) + T(2n\/3) + c n$, dove $c > 0$ è una costante. Questa ricorrenza *non* ha la forma standard $a T(n\/b) + f(n)$ perché i due sotto-problemi hanno dimensioni diverse ($n\/3$ e $2n\/3$), quindi il Master Theorem non è direttamente applicabile. L'albero di ricorsione è lo strumento ideale.

  Costruiamo l'albero. La radice ha costo $c n$. Il figlio sinistro ha costo $c(n\/3)$ e il figlio destro ha costo $c(2n\/3)$:

  #align(center, cetz.canvas({
    import cetz.draw: *

    // Livello 0: radice
    circle((0, 0), radius: 0.5, fill: white, stroke: 0.5pt + black)
    content((0, 0), text(size: 8pt)[$c n$])
    content((5, 0), text(size: 8pt, fill: luma(80))[$c n$])

    // Livello 1: 2 nodi
    circle((-2.5, -1.5), radius: 0.45, fill: white, stroke: 0.5pt + black)
    content((-2.5, -1.5), text(size: 7pt)[$c(n\/3)$])
    circle((2.5, -1.5), radius: 0.45, fill: white, stroke: 0.5pt + black)
    content((2.5, -1.5), text(size: 7pt)[$c(2n\/3)$])
    line((0, -0.5), (-2.5, -1.05), stroke: 0.5pt + luma(120))
    line((0, -0.5), (2.5, -1.05), stroke: 0.5pt + luma(120))
    content((5.5, -1.5), text(size: 8pt, fill: luma(80))[$c n$])

    // Livello 2: 4 nodi
    let l2-data = ((-4, $c(n\/9)$), (-1.5, $c(2n\/9)$), (1, $c(2n\/9)$), (4, $c(4n\/9)$))
    for (xpos, label) in l2-data {
      circle((xpos, -3.0), radius: 0.4, fill: white, stroke: 0.5pt + black)
      content((xpos, -3.0), text(size: 6pt)[#label])
    }
    line((-2.5, -1.95), (-4, -2.6), stroke: 0.4pt + luma(140))
    line((-2.5, -1.95), (-1.5, -2.6), stroke: 0.4pt + luma(140))
    line((2.5, -1.95), (1, -2.6), stroke: 0.4pt + luma(140))
    line((2.5, -1.95), (4, -2.6), stroke: 0.4pt + luma(140))
    content((5.5, -3.0), text(size: 8pt, fill: luma(80))[$c n$])

    // Punti verticali
    for xpos in (-2.5, 2.5) {
      content((xpos, -4.0), text(size: 12pt, fill: luma(120))[$dots.v$])
    }

    // Altezza
    content((-5.5, -1.5), text(size: 7pt, fill: luma(100))[$log_(3\/2) n$])

    // Totale
    content((5.5, -4.5), text(size: 8pt, fill: luma(80))[Totale: $O(n log n)$])
  }))

  *Analisi per livello.* Al livello 0 il costo è $c n$. Al livello 1 il costo è $c(n\/3) + c(2n\/3) = c n$. Al livello 2, sommando i quattro nodi: $c(n\/9) + c(2n\/9) + c(2n\/9) + c(4n\/9) = c n$. Ogni livello contribuisce esattamente $c n$ al costo totale.

  *Altezza dell'albero.* Il cammino più lungo dalla radice a una foglia è quello che segue sempre il figlio destro (sotto-problema di dimensione $2n\/3$): $n -> (2\/3)n -> (2\/3)^2 n -> dots.c -> 1$. Poiché $(2\/3)^k n = 1$ quando $k = log_(3\/2) n$, l'altezza dell'albero è $log_(3\/2) n$.

  Non tutti i livelli dell'albero contribuiscono con costo esattamente $c n$: i livelli più bassi hanno meno nodi, poiché il ramo sinistro ($n\/3$) raggiunge le foglie prima del ramo destro ($2n\/3$). Tuttavia, poiché il costo per livello è *al più* $c n$ e ci sono $log_(3\/2) n$ livelli, possiamo concludere:
  $ T(n) = O(n log_(3\/2) n) = O(n log n) $
  dove l'ultimo passaggio segue dal fatto che $log_(3\/2) n = (log n) \/ (log 3\/2) = Theta(log n)$.

  *Verifica con il metodo di sostituzione.* Dimostriamo che $T(n) <= d n log n$ per un'opportuna costante $d > 0$. Per $d >= c \/ (log 3 - 2\/3)$, si ha:
  $ T(n) &<= T(n\/3) + T(2n\/3) + c n \
         &<= d(n\/3) log(n\/3) + d(2n\/3) log(2n\/3) + c n \
         &= d(n\/3)(log n - log 3) + d(2n\/3)(log n - log(3\/2)) + c n \
         &= d n log n - d n (1\/3 dot log 3 + 2\/3 dot log(3\/2)) + c n \
         &<= d n log n $
  dove l'ultima disuguaglianza vale scegliendo $d$ sufficientemente grande affinché $d(1\/3 dot log 3 + 2\/3 dot log(3\/2)) >= c$, che è sempre possibile poiché la quantità tra parentesi è una costante positiva.
]

#note(title: "Quando usare l'albero di ricorsione")[
  L'albero di ricorsione è il metodo di elezione quando:
  - i sotto-problemi hanno *dimensioni diverse* (es. $T(n) = T(n\/3) + T(2n\/3) + c n$), rendendo inapplicabile il Master Theorem;
  - si desidera *intuire* la soluzione prima di dimostrarla formalmente;
  - si vuole capire *quale parte domina* il costo: le foglie (ricorsione pesante) o la radice (forzante pesante).
  Per ricorrenze bilanciate nella forma $T(n) = a T(n\/b) + f(n)$, il Master Theorem è più rapido e diretto.
]

== Master Theorem

Il Master Theorem fornisce una soluzione in forma chiusa per le relazioni di ricorrenza bilanciate.

#theorem(title: "Master Theorem")[
  Sia data la relazione di ricorrenza:
  $ T(n) = a T(n\/b) + f(n) $
  con $a >= 1$, $b > 1$ e $f(n) > 0$ definitivamente. Sia $c_("crit") = log_b a$. Allora:

  + *Caso 1* -- $f(n)$ cresce più lentamente di $n^(c_("crit"))$:\
    Se $exists epsilon > 0 : f(n) = O(n^(log_b a - epsilon))$, allora $T(n) = Theta(n^(log_b a))$.

  + *Caso 2* -- $f(n)$ cresce come $n^(c_("crit"))$ (a meno di fattori logaritmici):\
    Se $f(n) = Theta(n^(log_b a))$, allora $T(n) = Theta(n^(log_b a) dot log n)$.

  + *Caso 3* -- $f(n)$ cresce più velocemente di $n^(c_("crit"))$:\
    Se $exists epsilon > 0 : f(n) = Omega(n^(log_b a + epsilon))$ e inoltre $exists c < 1 : a dot f(n\/b) <= c dot f(n)$ (condizione di regolarità), allora $T(n) = Theta(f(n))$.
]

#demonstration[
  La dimostrazione si basa sull'analisi dell'*albero di ricorsione*. Consideriamo la ricorrenza $T(n) = a T(n\/b) + f(n)$.

  *Struttura dell'albero.* L'albero di ricorsione ha:
  - *Radice* con costo $f(n)$.
  - Ogni nodo interno ha esattamente $a$ figli.
  - Al livello $i$, ci sono $a^i$ nodi, ciascuno con un sotto-problema di dimensione $n\/b^i$.
  - Il costo al livello $i$ è $a^i dot f(n\/b^i)$.
  - L'albero ha $log_b n$ livelli (il sotto-problema raggiunge dimensione 1 quando $n\/b^i = 1$, cioè $i = log_b n$).
  - Le foglie sono $a^(log_b n) = n^(log_b a)$, ciascuna con costo $Theta(1)$.

  *Costo totale.* Il costo complessivo è la somma su tutti i livelli:
  $ T(n) = underbrace(n^(log_b a) dot Theta(1), "foglie") + underbrace(sum_(i=0)^(log_b n - 1) a^i dot f(n\/b^i), "nodi interni") $

  Poniamo $g(n) = sum_(i=0)^(log_b n - 1) a^i dot f(n\/b^i)$. Il comportamento di $g(n)$ dipende dal confronto tra $f(n)$ e $n^(log_b a)$:

  *Caso 1* ($f(n) = O(n^(log_b a - epsilon))$): la somma $g(n)$ è dominata dalle foglie. Intuitivamente, scendendo nell'albero il costo per livello *cresce* (il fattore $a^i$ cresce più velocemente di quanto $f(n\/b^i)$ diminuisca). Il costo delle foglie $n^(log_b a)$ domina la somma, e si ottiene $T(n) = Theta(n^(log_b a))$.

  *Caso 2* ($f(n) = Theta(n^(log_b a))$): ogni livello contribuisce approssimativamente lo stesso costo. Infatti:
  $ a^i dot f(n\/b^i) = a^i dot Theta((n\/b^i)^(log_b a)) = a^i dot Theta(n^(log_b a) \/ a^i) = Theta(n^(log_b a)) $
  Ci sono $log_b n$ livelli, ciascuno di costo $Theta(n^(log_b a))$, dunque $T(n) = Theta(n^(log_b a) dot log n)$.

  *Caso 3* ($f(n) = Omega(n^(log_b a + epsilon))$ con condizione di regolarità): la somma $g(n)$ è dominata dalla radice. Scendendo nell'albero il costo per livello *decresce* geometricamente (la condizione di regolarità $a dot f(n\/b) <= c dot f(n)$ garantisce che $a^i dot f(n\/b^i) <= c^i dot f(n)$). La serie geometrica converge e si ottiene $T(n) = Theta(f(n))$.
]

#note(title: "Caso 2 generalizzato")[
  Il secondo caso ammette una formulazione più generale:
  $ exists k >= 0 : f(n) = Theta(n^(log_b a) dot log^k n) arrow.double T(n) = Theta(n^(log_b a) dot log^(k+1) n) $
  Il caso standard corrisponde a $k = 0$.
]

#note(title: "Interpretazione intuitiva")[
  Il Master Theorem confronta il lavoro svolto dalla forzante $f(n)$ con il costo intrinseco della ricorsione, misurato da $n^(log_b a)$:
  - *Caso 1*: la ricorsione domina: il costo totale è determinato dal numero di foglie dell'albero di ricorsione.
  - *Caso 2*: forzante e ricorsione contribuiscono in modo bilanciato: il costo è amplificato da un fattore $log n$ (uno per livello dell'albero).
  - *Caso 3*: la forzante domina: il costo totale è determinato dal lavoro alla radice dell'albero.
]

=== Come applicare il Master Theorem

#note(title: "Procedimento")[
  + Identificare i parametri $a$, $b$ e $f(n)$.
  + Calcolare l'*esponente critico* $c_("crit") = log_b a$.
  + Confrontare la crescita di $f(n)$ con $n^(c_("crit"))$:
    - se $f(n)$ cresce *polinomialmente più lentamente* di $n^(c_("crit"))$ $arrow.double$ Caso 1;
    - se $f(n)$ cresce *allo stesso modo* (a meno di fattori logaritmici) $arrow.double$ Caso 2;
    - se $f(n)$ cresce *polinomialmente più velocemente* di $n^(c_("crit"))$ $arrow.double$ Caso 3 (verificare la condizione di regolarità).
]

=== Esempi di applicazione

#example(title: "Caso 2: Ricerca Binaria")[
  $T(n) = T(n\/2) + Theta(1)$

  Parametri: $a = 1$, $b = 2$, $f(n) = Theta(1)$.

  Esponente critico: $c_("crit") = log_2 1 = 0$, dunque $n^(c_("crit")) = n^0 = 1$.

  Confronto: $f(n) = Theta(1) = Theta(n^0) = Theta(n^(log_b a))$.

  $arrow.double$ *Caso 2*: $T(n) = Theta(n^0 dot log n) = Theta(log n)$.
]

#example(title: "Caso 2: Merge Sort")[
  $T(n) = 2T(n\/2) + Theta(n)$

  Parametri: $a = 2$, $b = 2$, $f(n) = Theta(n)$.

  Esponente critico: $c_("crit") = log_2 2 = 1$, dunque $n^(c_("crit")) = n$.

  Confronto: $f(n) = Theta(n) = Theta(n^(log_b a))$.

  $arrow.double$ *Caso 2*: $T(n) = Theta(n dot log n)$.
]

#example(title: "Caso 1: Algoritmo ipotetico")[
  $T(n) = 4T(n\/2) + n$

  Parametri: $a = 4$, $b = 2$, $f(n) = n$.

  Esponente critico: $c_("crit") = log_2 4 = 2$, dunque $n^(c_("crit")) = n^2$.

  Confronto: $f(n) = n = O(n^(2 - epsilon))$ con $epsilon = 1$. La forzante cresce più lentamente di $n^2$.

  $arrow.double$ *Caso 1*: $T(n) = Theta(n^2)$.

  Interpretazione: il costo è dominato dalle $4^(log_2 n) = n^2$ foglie dell'albero di ricorsione.
]

#example(title: "Caso 3: Algoritmo ipotetico")[
  $T(n) = T(n\/2) + n$

  Parametri: $a = 1$, $b = 2$, $f(n) = n$.

  Esponente critico: $c_("crit") = log_2 1 = 0$, dunque $n^(c_("crit")) = 1$.

  Confronto: $f(n) = n = Omega(n^(0 + epsilon))$ con $epsilon = 1$. La forzante cresce più velocemente di $n^0 = 1$.

  Verifica condizione di regolarità: $a dot f(n\/b) = 1 dot n\/2 = n\/2 <= c dot n$ con $c = 1\/2 < 1$. #sym.checkmark

  $arrow.double$ *Caso 3*: $T(n) = Theta(n)$.

  Interpretazione: il costo è dominato dal lavoro alla radice.
]

#example(title: "Caso non coperto dal Master Theorem")[
  $T(n) = 2T(n\/2) + n log n$

  Parametri: $a = 2$, $b = 2$, $f(n) = n log n$.

  Esponente critico: $c_("crit") = log_2 2 = 1$, dunque $n^(c_("crit")) = n$.

  Si ha $f(n) = n log n$, che cresce più di $n$ ma *non polinomialmente* più di $n$ (non esiste $epsilon > 0$ tale che $n log n = Omega(n^(1+epsilon))$). Non si applica il Caso 3.

  Tuttavia, applicando il *Caso 2 generalizzato* con $k = 1$: $f(n) = Theta(n dot log^1 n)$, si ottiene $T(n) = Theta(n dot log^2 n)$.
]

