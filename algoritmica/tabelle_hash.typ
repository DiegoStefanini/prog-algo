#import "../template.typ": *

== Tabelle Hash

Le tabelle hash sono una realizzazione concreta del tipo di dato astratto *dizionario* che, sotto ipotesi ragionevoli, garantisce un tempo medio $O(1)$ per le operazioni fondamentali. Mentre gli ABR (Alberi Binari di Ricerca) richiedono un tempo $O(h)$ proporzionale all'altezza, le tabelle hash sfruttano un accesso diretto tramite una funzione che calcola la posizione dell'elemento a partire dalla chiave.

In questo capitolo presentiamo tre realizzazioni di dizionario con complessità crescente: le tavole a indirizzamento diretto (semplici ma con limitazioni di spazio), le tavole hash con concatenamento (pratiche ed efficienti in media), e le funzioni hash con il metodo della divisione.

=== Tavole a indirizzamento diretto

L'*indirizzamento diretto* è la tecnica più semplice: se l'universo delle chiavi è piccolo, possiamo usare un array in cui ogni posizione corrisponde a una chiave.

#definizione(titolo: "Tavola a indirizzamento diretto")[
  Sia $U = {0, 1, ..., m - 1}$ l'universo delle chiavi. Una *tavola a indirizzamento diretto* è un array $T[0 .. m-1]$ dove ogni posizione $T[k]$ corrisponde alla chiave $k$. Se l'insieme non contiene un elemento con chiave $k$, allora $T[k] = "NIL"$.
]

Le operazioni di dizionario sono immediate:

#algoritmo(titolo: "Operazioni su tavola a indirizzamento diretto")[
  Direct-Address-Search(T, k)
      return T[k]

  Direct-Address-Insert(T, x)
      T[x.key] = x

  Direct-Address-Delete(T, x)
      T[x.key] = NIL
]

#teorema(titolo: "Complessità dell'indirizzamento diretto")[
  In una tavola a indirizzamento diretto, le operazioni Search, Insert e Delete richiedono ciascuna tempo $O(1)$.
]

#dimostrazione[
  Ogni operazione accede a una singola cella dell'array tramite indice diretto, senza alcuna ricerca. L'accesso a un array per indice richiede tempo costante nel modello RAM.
]

#esempio(titolo: "Indirizzamento diretto")[
  Consideriamo l'universo $U = {0, 1, ..., 9}$ e l'insieme $K = {2, 3, 5, 8}$ di chiavi effettive. La tavola $T$ ha 10 celle, di cui solo 4 contengono elementi:

  #align(center)[
    #table(
      columns: (auto, auto),
      align: (center, center),
      [*Indice*], [*Contenuto*],
      [0], [NIL],
      [1], [NIL],
      [2], [elemento con chiave 2],
      [3], [elemento con chiave 3],
      [4], [NIL],
      [5], [elemento con chiave 5],
      [6], [NIL],
      [7], [NIL],
      [8], [elemento con chiave 8],
      [9], [NIL],
    )
  ]

  Le 6 celle vuote rappresentano spazio sprecato.
]

#osservazione[
  L'indirizzamento diretto è efficiente in tempo ma costoso in spazio: richiede un array di dimensione $|U|$, indipendentemente dal numero $n$ di chiavi effettivamente memorizzate. Se l'universo $U$ è molto grande (ad esempio, tutte le possibili stringhe di 20 caratteri), la tavola diventa impraticabile.
]

=== Tavole hash

Quando l'universo delle chiavi $U$ è troppo grande per l'indirizzamento diretto, si ricorre alle *tavole hash*: strutture che usano un array di dimensione $m$ molto più piccola di $|U|$, calcolando la posizione di ogni elemento tramite una funzione.

#definizione(titolo: "Funzione hash")[
  Una *funzione hash* è una funzione $h : U -> {0, 1, ..., m - 1}$ che associa a ogni chiave $k$ dell'universo una posizione (detta *valore hash*) nella tavola $T[0 .. m - 1]$. Diciamo che $k$ viene *mappata* nella cella $h(k)$.
]

#definizione(titolo: "Tavola hash")[
  Una *tavola hash* è un array $T[0 .. m - 1]$ di dimensione $m$ in cui un elemento con chiave $k$ è memorizzato nella posizione $h(k)$, dove $h$ è una funzione hash. La dimensione $m$ è generalmente molto più piccola di $|U|$.
]

==== Collisioni

Poiché $|U| > m$, la funzione $h$ non può essere iniettiva: esistono necessariamente chiavi distinte $k_1 eq.not k_2$ tali che $h(k_1) = h(k_2)$.

#definizione(titolo: "Collisione")[
  Una *collisione* si verifica quando due chiavi distinte $k_1$ e $k_2$ hanno lo stesso valore hash: $h(k_1) = h(k_2)$.
]

Anche una funzione hash ben progettata non può evitare completamente le collisioni. Occorre quindi un meccanismo per gestirle. La tecnica più semplice è il *concatenamento*.

==== Risoluzione delle collisioni mediante concatenamento

#definizione(titolo: "Concatenamento")[
  Nel *concatenamento* (o _chaining_ o _liste di trabocco_), ogni cella $T[j]$ della tavola hash contiene un puntatore alla testa di una lista concatenata di tutti gli elementi la cui chiave ha valore hash $j$. Se nessun elemento è mappato nella cella $j$, allora $T[j] = "NIL"$.
]

Le operazioni di dizionario con concatenamento sono le seguenti:

#algoritmo(titolo: "Operazioni su tavola hash con concatenamento")[
  Chained-Hash-Insert(T, x)
      inserisci x in testa alla lista T[h(x.key)]

  Chained-Hash-Search(T, k)
      ricerca un elemento con chiave k nella lista T[h(k)]

  Chained-Hash-Delete(T, x)
      cancella x dalla lista T[h(x.key)]
]

#osservazione[
  L'inserimento in testa ha costo $O(1)$ (assumendo che l'elemento da inserire non sia già presente). La ricerca richiede di scorrere la lista nella cella $T[h(k)]$: il tempo è proporzionale alla lunghezza di tale lista. La cancellazione, se le liste sono doppiamente concatenate, ha costo $O(1)$; con liste singolarmente concatenate, ha lo stesso costo della ricerca.
]

#esempio(titolo: "Tavola hash con concatenamento")[
  Sia $m = 9$ e $h(k) = k mod 9$. Inseriamo nell'ordine le chiavi 5, 28, 19, 15, 20, 33, 12, 17, 10.

  #align(center)[
    #table(
      columns: (auto, auto),
      align: (center, left),
      [*Cella*], [*Lista*],
      [0], [$emptyset$],
      [1], [28 $arrow.r$ 19 $arrow.r$ 10 $arrow.r$ NIL],
      [2], [20 $arrow.r$ NIL],
      [3], [12 $arrow.r$ NIL],
      [4], [$emptyset$],
      [5], [5 $arrow.r$ NIL],
      [6], [33 $arrow.r$ 15 $arrow.r$ NIL],
      [7], [$emptyset$],
      [8], [17 $arrow.r$ NIL],
    )
  ]

  Ad esempio, $h(28) = 28 mod 9 = 1$ e $h(19) = 19 mod 9 = 1$: le chiavi 28 e 19 collidono nella cella 1. L'inserimento in testa fa sì che 19 preceda 28 nella lista (ma l'ordine dipende dalla sequenza degli inserimenti, non dal valore delle chiavi).
]

==== Analisi dell'hashing con concatenamento

L'analisi delle prestazioni richiede un'ipotesi sul comportamento della funzione hash.

#definizione(titolo: "Fattore di carico")[
  Data una tavola hash $T$ con $m$ celle in cui sono memorizzati $n$ elementi, il *fattore di carico* è il rapporto $alpha = n / m$. Il fattore $alpha$ rappresenta il numero medio di elementi per cella.
]

Il fattore di carico $alpha$ può essere minore, uguale o maggiore di 1. Se $alpha$ è piccolo, la maggior parte delle liste è corta; se $alpha$ è grande, le liste tendono ad allungarsi.

#definizione(titolo: "Hashing uniforme semplice")[
  L'ipotesi di *hashing uniforme semplice* richiede che qualsiasi chiave abbia la stessa probabilità di essere mappata in una qualsiasi delle $m$ celle, indipendentemente dalla cella in cui sono mappate le altre chiavi. Indicando con $n_j$ la lunghezza della lista $T[j]$, il numero totale di elementi è:

  $ n = n_0 + n_1 + dots.c + n_(m-1) $

  e il valore atteso della lunghezza di ciascuna lista è $E[n_j] = alpha = n / m$.
]

Sotto questa ipotesi, possiamo analizzare il tempo medio di ricerca.

*Caso pessimo.* Nel caso pessimo, tutte le $n$ chiavi sono mappate nella stessa cella, producendo una lista di lunghezza $n$. La ricerca richiede $Theta(n)$, non meglio di una lista concatenata semplice. Per questo le tavole hash non si usano quando servono garanzie sul caso pessimo.

*Caso medio.* Il caso medio è molto più favorevole:

#teorema(titolo: "Ricerca senza successo")[
  In una tavola hash con concatenamento, nell'ipotesi di hashing uniforme semplice, una ricerca senza successo richiede un tempo medio $Theta(1 + alpha)$.
]

#dimostrazione[
  Una chiave $k$ non presente nella tavola viene mappata nella cella $h(k)$. Per l'ipotesi di hashing uniforme semplice, la lista in questa cella ha lunghezza attesa $alpha$. La ricerca senza successo esamina tutti gli elementi della lista (per verificare che nessuno abbia chiave $k$), impiegando un tempo proporzionale alla lunghezza della lista. Aggiungendo il tempo $O(1)$ per calcolare $h(k)$, si ottiene un tempo totale di $Theta(1 + alpha)$.
]

#teorema(titolo: "Ricerca con successo")[
  In una tavola hash con concatenamento, nell'ipotesi di hashing uniforme semplice, una ricerca con successo richiede un tempo medio $Theta(1 + alpha)$.
]

#dimostrazione[
  Supponiamo che l'elemento cercato sia uno qualsiasi degli $n$ elementi memorizzati, ciascuno con la stessa probabilità $1/n$. Il numero di elementi esaminati durante la ricerca di un elemento $x_i$ (l'$i$-esimo inserito) è 1 più il numero di elementi inseriti dopo $x_i$ nella stessa cella. Per l'hashing uniforme semplice, la probabilità che due chiavi collidano è $1/m$. Il numero atteso di elementi esaminati in una ricerca con successo è:

  $ 1/n sum_(i=1)^n (1 + sum_(j=i+1)^n 1/m) = 1 + 1/(n m) sum_(i=1)^n (n - i) = 1 + (n-1)/(2m) = 1 + alpha/2 - alpha/(2n) $

  Aggiungendo il tempo $O(1)$ per calcolare la funzione hash, il tempo totale è $Theta(1 + alpha)$.
]

#osservazione[
  Il significato pratico di questa analisi è il seguente: se il numero di celle $m$ è proporzionale al numero di elementi $n$, cioè $n = O(m)$, allora $alpha = n/m = O(1)$ e tutte le operazioni di dizionario richiedono in media tempo $O(1)$.
]

#esempio(titolo: "Scelta della dimensione della tavola")[
  Se prevediamo di memorizzare circa $n = 1000$ elementi e vogliamo che ogni ricerca esamini in media al più 3 elementi, dobbiamo scegliere $m$ in modo che $alpha = n/m <= 3$. Quindi $m >= 1000/3 approx 334$. In pratica, si sceglie $m$ come un numero primo vicino a 334, ad esempio $m = 337$.
]

=== Funzioni hash

La qualità di una tavola hash dipende fortemente dalla scelta della funzione hash. Una funzione hash ideale soddisfa (approssimativamente) l'ipotesi di hashing uniforme semplice, distribuendo le chiavi il più uniformemente possibile tra le $m$ celle.

#osservazione[
  Purtroppo, raramente è nota la distribuzione di probabilità con cui le chiavi vengono estratte, e le chiavi potrebbero non essere generate in modo indipendente. Nella pratica si usano tecniche euristiche: un buon approccio consiste nel derivare il valore hash in modo che sia indipendente da qualsiasi regolarità presente nei dati. Ad esempio, il metodo della divisione calcola il valore hash come il resto della divisione fra la chiave e un numero primo scelto opportunamente, in modo da non essere correlato a regolarità nella distribuzione delle chiavi.
]

==== Interpretare le chiavi come numeri naturali

La maggior parte delle funzioni hash assume che l'universo delle chiavi sia un sottoinsieme di $NN$. Se le chiavi non sono numeri naturali, occorre prima convertirle in numeri.

#esempio(titolo: "Conversione di stringhe in numeri")[
  L'identificatore `pt` può essere interpretato come la coppia di interi $(112, 116)$ (codici ASCII di `p` e `t`). Usando la base 128 (dimensione dell'alfabeto ASCII), otteniamo il numero naturale:

  $ 112 dot 128 + 116 = 14452 $

  In questo modo, qualsiasi stringa può essere trasformata in un numero naturale su cui applicare una funzione hash.
]

==== Il metodo della divisione

Il metodo della divisione è lo schema più semplice e diffuso per costruire funzioni hash.

#definizione(titolo: "Metodo della divisione")[
  Nel *metodo della divisione*, la funzione hash è definita come:

  $ h(k) = k mod m $

  dove $m$ è la dimensione della tavola. La chiave $k$ viene mappata nella cella corrispondente al resto della divisione di $k$ per $m$.
]

Il metodo è molto veloce: richiede una sola operazione di modulo.

#esempio(titolo: "Metodo della divisione")[
  Con $m = 12$ e $k = 100$:

  $ h(100) = 100 mod 12 = 4 $

  La chiave 100 viene mappata nella cella 4.
]

#esempio(titolo: "Applicazione completa")[
  Consideriamo una tavola hash di dimensione $m = 13$ e le chiavi $K = {5, 18, 27, 44, 31, 79, 55}$.

  #align(center)[
    #table(
      columns: (auto, auto, auto),
      align: (center, center, center),
      [*Chiave $k$*], [*$k mod 13$*], [*Cella*],
      [5], [$5 mod 13 = 5$], [5],
      [18], [$18 mod 13 = 5$], [5],
      [27], [$27 mod 13 = 1$], [1],
      [44], [$44 mod 13 = 5$], [5],
      [31], [$31 mod 13 = 5$], [5],
      [79], [$79 mod 13 = 1$], [1],
      [55], [$55 mod 13 = 3$], [3],
    )
  ]

  Le chiavi 5, 18, 44, 31 collidono tutte nella cella 5 (formando una lista di 4 elementi), mentre 27 e 79 collidono nella cella 1. La cella 3 contiene solo la chiave 55.
]

La scelta di $m$ è cruciale per l'efficienza della funzione hash.

#nota(titolo: "Scelta di $m$ nel metodo della divisione")[
  - *Evitare potenze di 2*: se $m = 2^p$, allora $h(k) = k mod 2^p$ dipende solo dai $p$ bit meno significativi della chiave, ignorando i bit più significativi. A meno che non sia noto che tutte le configurazioni dei bit meno significativi siano equiprobabili, questa scelta introduce un bias sistematico.
  - *Evitare $m = 2^p - 1$*: se le chiavi sono stringhe di caratteri in base $2^p$, la permutazione dei caratteri non cambia il valore hash, causando collisioni sistematiche.
  - *Buona scelta*: un numero primo non troppo vicino a una potenza di 2. Ad esempio, per memorizzare circa 2000 stringhe e tollerare in media 3 confronti per ricerca, si sceglie $m approx 2000 / 3 approx 701$. Il numero 701 è primo e non è vicino a nessuna potenza di 2, quindi è una buona scelta.
]

=== Indirizzamento aperto

Nell'*indirizzamento aperto* (o _open addressing_) tutti gli elementi sono memorizzati direttamente nella tavola $T$, senza liste esterne. Ogni cella contiene al più un elemento: se si verifica una collisione, si cercano celle alternative all'interno della tavola stessa.

#definizione(titolo: "Indirizzamento aperto")[
  Nell'*indirizzamento aperto*, la tavola hash $T[0 .. m - 1]$ contiene direttamente le chiavi (oppure NIL per le celle vuote). Il fattore di carico soddisfa sempre $alpha = n / m <= 1$. Quando si deve inserire una chiave $k$ e la cella $h(k)$ è già occupata, si esaminano altre celle secondo una *sequenza di ispezione* determinata dalla chiave.
]

==== Sequenza di ispezione

Per gestire le collisioni, si associa a ogni chiave $k$ una sequenza di posizioni da esaminare.

#definizione(titolo: "Sequenza di ispezione")[
  Una funzione di ispezione è una funzione $h : U times {0, 1, ..., m-1} arrow.r {0, 1, ..., m-1}$ tale che per ogni chiave $k$, la sequenza $chevron.l h(k, 0), h(k, 1), ..., h(k, m-1) chevron.r$ sia una permutazione di ${0, 1, ..., m-1}$. In questo modo, ogni cella della tavola viene esaminata esattamente una volta.
]

==== Operazioni di dizionario

Nell'indirizzamento aperto, le operazioni di dizionario esaminano le celle nell'ordine dettato dalla sequenza di ispezione. Consideriamo prima il caso senza cancellazioni: ogni cella di $T$ contiene una chiave oppure NIL (cella vuota).

#algoritmo(titolo: "Insert (senza cancellazioni)")[
  Insert(T, k)
      i := 0;
      while (i < m) {
          j := h(k, i);
          if (T[j] == NIL) {
              T[j] := k;
              return j;
          }
          else i := i + 1;
      }
      error "overflow della tabella"
]

#algoritmo(titolo: "Search (senza cancellazioni)")[
  Search(T, k)
      i := 0;
      while (i < m) {
          j := h(k, i);
          if (T[j] == k) return j;    // chiave trovata
          if (T[j] == NIL) return -1;  // chiave assente
          i := i + 1;
      }
      return -1;    // chiave assente, tabella piena
]

#osservazione[
  La Search si ferma quando trova la chiave cercata oppure quando incontra una cella vuota (NIL). L'idea chiave è: se la cella è vuota, l'algoritmo di Insert avrebbe inserito la chiave $k$ proprio in quella cella (se fosse stata presente), quindi $k$ non può trovarsi oltre.
]

==== Cancellazione con flag DELETED

La cancellazione nell'indirizzamento aperto non può semplicemente porre NIL nella cella, perché ciò interromperebbe le sequenze di ispezione delle chiavi inserite successivamente.

#definizione(titolo: "Cancellazione logica")[
  La cancellazione avviene in modo *logico*: la cella dell'elemento cancellato viene marcata con un valore speciale *DELETED* (diverso da NIL e da qualsiasi chiave). Una cella DELETED:
  - nella *Insert* viene trattata come libera (vi si può inserire una nuova chiave);
  - nella *Search* viene trattata come occupata (la ricerca prosegue oltre).
]

#algoritmo(titolo: "Insert (con cancellazioni)")[
  Insert(T, k)
      i := 0;
      while (i < m) {
          j := h(k, i);
          if (T[j] == NIL or T[j] == DELETED) {
              T[j] := k;
              return j;
          }
          else i := i + 1;
      }
      error "overflow della tabella"
]

#osservazione[
  L'algoritmo di Search non cambia: le celle DELETED vengono semplicemente "scavalcate" durante la ricerca, come se fossero occupate da una chiave diversa da quella cercata. Tuttavia, l'uso di DELETED degrada le prestazioni della ricerca, perché il tempo non dipende più solo dal fattore di carico $alpha$ ma anche dal numero di celle marcate DELETED.
]

==== Analisi della complessità

L'analisi al caso medio richiede tre ipotesi:

+ $alpha < 1$ (la tavola non è completamente piena);
+ non ci sono cancellazioni;
+ vale l'ipotesi di *hashing uniforme*:

#definizione(titolo: "Hashing uniforme")[
  L'ipotesi di *hashing uniforme* richiede che, per ogni chiave $k$, ognuna delle $m!$ permutazioni di ${0, 1, ..., m - 1}$ sia equiprobabile come sequenza di ispezione di $k$. Questa è un'ipotesi più forte dell'hashing uniforme semplice (che riguarda solo la prima posizione).
]

*Caso ottimo:* $T(n, m) = O(1)$ --- la prima ispezione trova la cella vuota o la chiave cercata.

*Caso pessimo:* $T(n, m) = Theta(n)$ --- tutte le chiavi collidono, si esamina l'intera tavola.

*Caso medio:* l'analisi si differenzia per ricerca senza successo e con successo.

#teorema(titolo: "Ricerca senza successo")[
  Nelle ipotesi (1), (2), (3) sopra, il numero atteso di ispezioni in una ricerca senza successo è al più $ frac(1, 1 - alpha) $.
]

#dimostrazione[
  Calcoliamo la probabilità di eseguire almeno $i$ ispezioni:
  - Probabilità di almeno 1 ispezione: 1 (si esamina sempre la prima cella).
  - Probabilità di almeno 2 ispezioni (la prima cella è occupata): $n / m = alpha$.
  - Probabilità di almeno 3 ispezioni (le prime due occupate): $frac(n, m) dot frac(n-1, m-1) < alpha^2$.
  - In generale, la probabilità di almeno $i + 1$ ispezioni è al più $alpha^i$.

  Il numero atteso di ispezioni è:
  $ sum_(i=0)^(infinity) alpha^i = frac(1, 1 - alpha) $

  dove si usa la convergenza della serie geometrica per $alpha < 1$.
]

#teorema(titolo: "Ricerca con successo")[
  Nelle ipotesi (1), (2), (3) sopra, il numero atteso di ispezioni in una ricerca con successo è al più $ frac(1, alpha) ln frac(1, 1 - alpha) $.
]

#dimostrazione[
  La ricerca di una chiave $k$ presente nella tavola percorre le stesse posizioni esaminate quando $k$ è stata inserita. Se $k$ è stata la $(i+1)$-esima chiave inserita, al momento dell'inserimento il fattore di carico era $i/m$, e il numero atteso di ispezioni era al più $frac(1, 1 - i slash m) = frac(m, m - i)$.

  Il numero atteso di ispezioni, mediato su tutte le $n$ chiavi presenti:
  $ frac(1, n) sum_(i=0)^(n-1) frac(m, m - i) = frac(m, n) sum_(i=0)^(n-1) frac(1, m - i) < frac(1, alpha) ln frac(1, 1 - alpha) $

  dove l'ultimo passaggio segue dall'approssimazione della somma con un integrale.
]

#teorema(titolo: "Inserimento")[
  Nelle ipotesi (1), (2), (3), il numero atteso di ispezioni per un inserimento è al più $frac(1, 1 - alpha)$, lo stesso della ricerca senza successo.
]

#dimostrazione[
  L'inserimento di una chiave $k$ esamina le stesse celle che esaminerebbe una ricerca senza successo di $k$ (cercando la prima cella vuota).
]

#esempio(titolo: "Prestazioni al variare di $alpha$")[
  La tabella mostra il numero atteso di ispezioni per vari valori di $alpha$:

  #align(center)[
    #table(
      columns: (auto, auto, auto, auto),
      align: (center, center, center, center),
      [$alpha$], [Occupazione], [Ricerca senza successo ($frac(1, 1-alpha)$)], [Ricerca con successo ($frac(1, alpha) ln frac(1, 1-alpha)$)],
      [$1 slash 10$], [10%], [1.11], [1.05],
      [$1 slash 2$], [50%], [2], [1.38],
      [$9 slash 10$], [90%], [10], [2.55],
    )
  ]

  Con una tavola piena al 50% ($alpha = 1/2$), una ricerca senza successo esamina in media solo 2 celle: prestazioni eccellenti.
]

==== Ispezione lineare

Il metodo più semplice per calcolare la sequenza di ispezione è l'*ispezione lineare* (o _linear probing_).

#definizione(titolo: "Ispezione lineare")[
  Nell'*ispezione lineare*, data una funzione hash ausiliaria $h' : U arrow.r {0, 1, ..., m-1}$, la funzione di ispezione è:

  $ h(k, i) = (h'(k) + i) mod m $

  La sequenza di ispezione parte dalla posizione $h'(k)$ e procede ciclicamente: $chevron.l h'(k), h'(k) + 1, h'(k) + 2, ..., 0, 1, ..., h'(k) - 1 chevron.r$.
]

#esempio(titolo: "Ispezione lineare")[
  Con $m = 7$ e $h'(k) = k mod 7$, la sequenza di ispezione per la chiave $k = 9$ è:
  - $h'(9) = 9 mod 7 = 2$
  - Sequenza: $chevron.l 2, 3, 4, 5, 6, 0, 1 chevron.r$

  Il punto di partenza dipende dalla chiave (tramite $h'(k)$), ma il passo di ispezione è costante ($+1$).
]

#osservazione[
  L'ispezione lineare è facile da implementare ma presenta un problema noto come *addensamento primario* (o _clustering primario_): si formano lunghe file di celle occupate (blocchi contigui), che aumentano il tempo medio di ricerca. Metodi come l'*ispezione quadratica* e il *doppio hash* riducono questo fenomeno.
]

==== Ispezione quadratica

L'*ispezione quadratica* (o _quadratic probing_) usa una funzione hash della forma:

$ h(k, i) = (h'(k) + c_1 i + c_2 i^2) mod m $

dove $h'$ è una funzione hash ausiliaria, $c_1$ e $c_2 eq.not 0$ sono costanti ausiliarie e $i = 0, 1, ..., m-1$. La posizione iniziale di ispezione è $T[h'(k)]$; le successive posizioni sono scostate di quantità dipendenti da un polinomio di secondo grado in $i$.

#osservazione[
  Questo metodo funziona molto meglio dell'ispezione lineare, ma per poter esaminare l'intera tavola i valori di $c_1, c_2$ e $m$ devono soddisfare particolari restrizioni. Inoltre, se due chiavi hanno la stessa posizione iniziale di ispezione, esse avranno la medesima sequenza di ispezione. Questa proprietà crea una forma meno grave di clustering detta *addensamento secondario*.
]

==== Doppio hash

Il doppio hash è la tecnica più efficace per l'indirizzamento aperto, in quanto produce sequenze di ispezione che approssimano meglio l'hashing uniforme.

#definizione(titolo: "Doppio hash")[
  Nel *doppio hash*, date due funzioni hash ausiliarie $h_1$ e $h_2$, la funzione di ispezione è:

  $ h(k, i) = (h_1(k) + i dot h_2(k)) mod m $

  Sia il punto di partenza ($h_1(k)$) sia il passo ($h_2(k)$) dipendono dalla chiave. Si richiede che $h_2(k)$ sia coprimo con $m$ per garantire che la sequenza sia una permutazione completa.
]

#nota(titolo: "Scelta tipica per il doppio hash")[
  Una scelta comune è $m$ primo con $h_1(k) = k mod m$ e $h_2(k) = 1 + (k mod (m-1))$. Il valore $h_2(k)$ è sempre compreso tra 1 e $m-1$ ed è automaticamente coprimo con $m$ (poiché $m$ è primo).
]

#esempio(titolo: "Doppio hash")[
  Con $m = 13$, $h_1(k) = k mod 13$ e $h_2(k) = 1 + (k mod 12)$, inseriamo le chiavi 10, 24, 33:
  - $k = 10$: $h_1(10) = 10$, cella 10 libera $arrow.r$ inserito in posizione 10.
  - $k = 24$: $h_1(24) = 11$, cella 11 libera $arrow.r$ inserito in posizione 11.
  - $k = 33$: $h_1(33) = 7$, cella 7 libera $arrow.r$ inserito in posizione 7.
  - $k = 27$: $h_1(27) = 1$, cella 1 libera $arrow.r$ inserito in posizione 1.
  - $k = 14$: $h_1(14) = 1$, collisione! $h_2(14) = 1 + 14 mod 12 = 3$. Provo $h(14,1) = (1 + 3) mod 13 = 4$, cella 4 libera $arrow.r$ inserito in posizione 4.
]

=== Confronto tra realizzazioni di dizionario

Per concludere, confrontiamo le quattro realizzazioni di dizionario studiate.

#align(center)[
  #table(
    columns: (auto, auto, auto, auto, auto),
    align: (center, center, center, center, center),
    [*Operazione*], [*Indir. diretto*], [*Hash + concat. (medio)*], [*Hash aperto (medio)*], [*ABR (peggiore)*],
    [Search], [$O(1)$], [$O(1 + alpha)$], [$O(frac(1, 1 - alpha))$], [$O(h)$],
    [Insert], [$O(1)$], [$O(1)$], [$O(frac(1, 1 - alpha))$], [$O(h)$],
    [Delete], [$O(1)$], [$O(1)$], [$O(frac(1, 1 - alpha))$#super[\*]], [$O(h)$],
    [Min/Max], [$O(m)$], [---], [---], [$O(h)$],
    [Succ/Pred], [$O(m)$], [---], [---], [$O(h)$],
    [Spazio], [$O(|U|)$], [$O(m + n)$], [$O(m)$], [$O(n)$],
  )
]

#super[\*] Con flag DELETED; degrada con molte cancellazioni.

#osservazione[
  Le tavole hash offrono il miglior tempo medio per le operazioni fondamentali (Search, Insert, Delete), ma non supportano efficientemente le operazioni di Minimum, Maximum, Successor e Predecessor. L'indirizzamento aperto ha il vantaggio di non usare puntatori (migliore uso della cache), ma richiede $alpha < 1$ e la cancellazione è problematica. Il concatenamento è più flessibile ($alpha$ può superare 1) e gestisce le cancellazioni in modo naturale. La tavola a indirizzamento diretto è praticabile solo quando l'universo delle chiavi è piccolo.
]
