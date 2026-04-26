#import "../template.typ": *

== Problemi computazionali, calcolabilità e complessità

In tutto il resto della dispensa abbiamo progettato algoritmi *efficienti*: $O(n log n)$ per l'ordinamento, $O(n)$ per Fibonacci con la programmazione dinamica, $O(n + m)$ per la visita di un grafo. In questo capitolo conclusivo cambiamo prospettiva e ci chiediamo quali siano i *limiti intrinseci* del calcolo: esistono problemi che nessun calcolatore potrà mai risolvere? Esistono problemi risolvibili in linea di principio ma per i quali ogni algoritmo richiede tempo proibitivo nella pratica?

Le risposte affermative a queste domande --- e la loro dimostrazione --- costituiscono i fondamenti di due teorie distinte ma intrecciate: la *teoria della calcolabilità* e la *teoria della complessità*.

#definizione(titolo: "Problema computazionale")[
  Un *problema computazionale* è una funzione matematica che associa ad ogni *istanza* di ingresso un *risultato*. Formalmente, fissati interi $k, j >= 1$, un problema è una funzione

  $ f: NN^k arrow.r NN^j $

  e *risolvere* il problema significa esibire un algoritmo che, su ogni istanza valida, produca in tempo finito il valore corrispondente.
]

I problemi computazionali si classificano gerarchicamente:

#ricorda[
  - *Problemi indecidibili (non calcolabili):* nessun algoritmo può risolverli, nemmeno con tempo e memoria illimitati.
  - *Problemi decidibili (calcolabili):* esiste almeno un algoritmo che li risolve in tempo finito su ogni istanza.
    - *Trattabili:* esiste un algoritmo di costo *polinomiale* nella dimensione dell'istanza ($O(n^k)$).
    - *Intrattabili:* tutti gli algoritmi noti hanno costo *esponenziale* (e in alcuni casi si può dimostrare che è inevitabile).
]

#nota(titolo: "Calcolabilità vs. Complessità")[
  La *calcolabilità* studia il confine fra problemi risolvibili e non risolvibili (qualitativo: _esiste_ un algoritmo?). La *complessità* studia il confine fra problemi facili e difficili all'interno di quelli risolvibili (quantitativo: _quanto costa_ il miglior algoritmo?).
]

== Insiemi numerabili e diagonalizzazione

Per dimostrare l'esistenza di problemi indecidibili, mostreremo che gli *algoritmi* sono enumerabili come $NN$, mentre i *problemi* no. Da qui segue per cardinalità che esistono problemi privi di un corrispondente algoritmo.

=== Insiemi numerabili

#definizione(titolo: "Insiemi equipotenti e numerabili")[
  Due insiemi $A$ e $B$ si dicono *equipotenti* (hanno lo stesso numero di elementi) se esiste una corrispondenza biunivoca $f: A arrow.r B$.

  Un insieme $A$ si dice *numerabile* se esiste una corrispondenza biunivoca con i numeri naturali $NN$, ovvero se i suoi elementi possono essere disposti in una sequenza

  $ a_1, a_2, dots, a_n, dots $

  che li raggiunge tutti.
]

#esempio(titolo: "Insiemi numerabili classici")[
  - $NN$ stesso, banalmente.
  - $ZZ$: si enumera $0, -1, 1, -2, 2, -3, 3, dots$ associando all'intero $k$ il naturale $2k$ se $k >= 0$ e $2|k| - 1$ se $k < 0$ (così $0 arrow.r 0$, $-1 arrow.r 1$, $1 arrow.r 2$, $-2 arrow.r 3$, $dots$).
  - I numeri naturali pari: $0, 2, 4, 6, dots$ con la biiezione $n arrow.l.r.long 2n$.
  - Le coppie $NN times NN$, i numeri razionali $QQ$, e in generale ogni unione numerabile di insiemi numerabili.
]

=== Enumerazione delle sequenze finite

Un punto chiave: l'insieme delle sequenze _finite_ di simboli su un alfabeto _finito_ è numerabile, anche se infinito.

#definizione(titolo: "Ordinamento canonico")[
  Fissato un alfabeto finito $Gamma$ con un ordine totale fra i suoi caratteri (per es. ordine alfabetico), si elencano le sequenze finite su $Gamma$ in *ordine canonico*:
  + per *lunghezza crescente*;
  + a parità di lunghezza, in *ordine alfabetico*.
]

#esempio(titolo: "Ordinamento canonico su Gamma = {a, b, c}")[
  $ a, b, c, " " a a, a b, a c, b a, b b, b c, c a, c b, c c, " " a a a, a a b, dots $

  Ogni sequenza $sigma$ di lunghezza $|sigma| = ell$ appare a una distanza finita dall'inizio, perché prima di lei compaiono al più $|Gamma| + |Gamma|^2 + dots + |Gamma|^ell$ sequenze, che è un numero finito.
]

#osservazione[
  La numerazione funziona perché le sequenze hanno lunghezza _finita_. Per sequenze di lunghezza infinita la numerazione fallisce: questo distinguerà gli oggetti "rappresentabili" (algoritmi) da quelli "infiniti" (alcune funzioni).
]

=== Insiemi non numerabili: la diagonalizzazione di Cantor

Ci sono insiemi i cui elementi non possono essere disposti in alcuna sequenza che li raggiunga tutti. Lo strumento standard per dimostrarlo è il *metodo della diagonale*.

#teorema(titolo: "Cantor")[
  L'insieme $cal(F) = { f " " | " " f: NN arrow.r {0, 1} }$ delle funzioni booleane sui naturali non è numerabile.
]

#dimostrazione(stile: "per assurdo e diagonalizzazione")[
  Supponiamo per assurdo che $cal(F)$ sia numerabile. Allora possiamo disporre le sue funzioni in una sequenza $f_0, f_1, f_2, dots$ e costruire la tabella infinita

  #align(center, table(
    columns: 11,
    align: center,
    stroke: 0.4pt,
    [$x$], [$0$], [$1$], [$2$], [$3$], [$4$], [$5$], [$6$], [$7$], [$8$], [$dots$],
    [$f_0(x)$], [#text(weight: "bold")[1]], [$0$], [$1$], [$0$], [$1$], [$0$], [$0$], [$0$], [$1$], [$dots$],
    [$f_1(x)$], [$0$], [#text(weight: "bold")[0]], [$1$], [$1$], [$0$], [$0$], [$1$], [$1$], [$0$], [$dots$],
    [$f_2(x)$], [$1$], [$1$], [#text(weight: "bold")[0]], [$1$], [$0$], [$1$], [$0$], [$0$], [$1$], [$dots$],
    [$f_3(x)$], [$0$], [$1$], [$1$], [#text(weight: "bold")[0]], [$1$], [$0$], [$1$], [$1$], [$1$], [$dots$],
    [$f_4(x)$], [$1$], [$1$], [$0$], [$0$], [#text(weight: "bold")[1]], [$0$], [$0$], [$0$], [$1$], [$dots$],
    [$dots$], [], [], [], [], [], [], [], [], [], [],
  ))

  Definiamo la funzione $g: NN arrow.r {0, 1}$ "anti-diagonale":

  $ g(x) = cases(1 quad "se" f_x(x) = 0, 0 quad "se" f_x(x) = 1) $

  Per costruzione $g$ differisce da $f_0$ in $0$, da $f_1$ in $1$, da $f_2$ in $2$, e in generale da $f_x$ nel valore $x$. Quindi $g != f_j$ per ogni $j in NN$, ma $g in cal(F)$. Contraddizione: la nostra enumerazione non era totale, quindi $cal(F)$ non è numerabile. #h(1fr)
]

#osservazione[
  L'argomento è robustissimo: per _qualunque_ enumerazione si scelga, la funzione "anti-diagonale" che si costruisce da quella enumerazione è sempre esclusa. Variando la "linea diagonale" (qualsiasi linea che attraversi tutte le righe e tutte le colonne esattamente una volta) si trovano _infinite_ funzioni escluse da ogni enumerazione: $cal(F)$ è strettamente più grande di $NN$.
]

#corollario[
  _Non sono numerabili gli insiemi delle funzioni $f: NN arrow.r NN$, $f: NN arrow.r RR$, $f: RR arrow.r RR$ né, in generale, $f: NN^k arrow.r NN^j$._
]

#dimostrazione(stile: "inclusione")[
  Una funzione $f: NN arrow.r {0, 1}$ è anche una particolare funzione $f: NN arrow.r NN$: se l'insieme più ristretto è non numerabile, a maggior ragione lo sono i suoi sovrainsiemi.
]

== Esistenza di problemi indecidibili

Mettiamo insieme due osservazioni di natura diversa.

#proposizione(titolo: "Numerabilità degli algoritmi")[
  _L'insieme degli algoritmi (in qualunque modello di calcolo ragionevole) è numerabile._
]

#dimostrazione(stile: "rappresentazione")[
  Un algoritmo, una volta fissato un modello di calcolo (Macchina di Turing, RAM, linguaggio C, $dots$), è una *sequenza finita di simboli* di un alfabeto finito (il suo "codice sorgente"). Per la sezione precedente, l'insieme di tali sequenze è numerabile mediante l'ordinamento canonico. #h(1fr)
]

#proposizione(titolo: "Non numerabilità dei problemi")[
  _L'insieme dei problemi computazionali $f: NN^k arrow.r NN^j$ non è numerabile._
]

#dimostrazione(stile: "riduzione a Cantor")[
  Restringendo il codominio a ${0, 1}$ otteniamo le funzioni booleane $f: NN^k arrow.r {0, 1}$, che a loro volta contengono come sotto-insieme proprio le $f: NN arrow.r {0, 1}$ (basta usare una sola variabile). Per il Teorema di Cantor questo sotto-insieme non è numerabile. Un sovrainsieme di un insieme non numerabile non è numerabile, da cui la tesi. #h(1fr)
]

#teorema(titolo: "Esistenza di problemi indecidibili")[
  _Esistono problemi computazionali per i quali non esiste alcun algoritmo di risoluzione._
]

#dimostrazione(stile: "cardinalità")[
  Se ad ogni problema corrispondesse un algoritmo, l'insieme dei problemi risolvibili sarebbe in iniezione con l'insieme degli algoritmi, quindi numerabile. Ma l'insieme dei problemi non lo è. La cardinalità degli algoritmi è strettamente minore di quella dei problemi:

  $ |{"Algoritmi"}| << |{"Problemi"}| $

  Esistono dunque problemi privi di algoritmo. #h(1fr)
]

#attenzione[
  Questa dimostrazione è puramente *esistenziale*: ci dice che ci sono problemi indecidibili, ma non ne esibisce nessuno. Per averne uno concreto serve un argomento costruttivo, fornito da Turing (1936) col problema dell'arresto.
]

== Il problema dell'arresto

Storicamente, il primo esempio esplicito di problema indecidibile è il *problema dell'arresto* (_Halting Problem_) introdotto da Alan Turing nel 1936.

#definizione(titolo: "Problema dell'arresto")[
  Dati un algoritmo $A$ e un'istanza di input $D$, *decidere in tempo finito* se la computazione $A(D)$ termina (si arresta) oppure non termina (entra in un ciclo infinito).
]

#osservazione[
  Si tratta di un *problema decisionale*: la risposta è $1$ ("$A$ su $D$ termina") o $0$ ("$A$ su $D$ non termina"). Per problemi decisionali la calcolabilità prende il nome di *decidibilità*. Inoltre è un problema *meta*: indaga proprietà di un algoritmo, trattandolo come dato di input. Questo è legittimo perché tanto l'algoritmo $A$ quanto il dato $D$ sono sequenze finite di simboli sullo stesso alfabeto.
]

=== Un caso reale: l'algoritmo Goldbach

Per capire perché il problema è non banale, consideriamo:

#algoritmo(titolo: "Goldbach() — cerca un controesempio alla congettura di Goldbach")[
  ```
  Goldbach() {
      n = 2;
      do {
          n = n + 2;
          controesempio = true;
          for (p = 2; p <= n - 2; p = p + 1) {
              q = n - p;
              if (Primo(p) AND Primo(q))
                  controesempio = false;
          }
      } while (NOT controesempio);
      return n;
  }
  ```
]

L'algoritmo cerca il più piccolo intero pari $n >= 4$ che _non_ sia somma di due primi e si arresta non appena lo trova.

#nota(titolo: "Congettura di Goldbach (1742)")[
  _Ogni intero pari $n >= 4$ è esprimibile come somma di due numeri primi._

  La congettura è aperta dal XVIII secolo. Allora:

  - Se la congettura è *falsa*, esiste un controesempio e Goldbach() *si arresta*.
  - Se la congettura è *vera*, non c'è controesempio e Goldbach() *non si arresta*.

  Quindi un ipotetico algoritmo che decide l'arresto risolverebbe immediatamente la congettura --- e in generale qualsiasi congettura aritmetica esprimibile come "esiste un controesempio". Questo è un primo segnale che un tale algoritmo non può esistere.
]

=== Il teorema di Turing

#teorema(titolo: "Turing, 1936 — Indecidibilità dell'arresto")[
  _Non esiste alcun algoritmo che, dato in input un arbitrario algoritmo $A$ e un arbitrario dato $D$, decida in tempo finito se $A(D)$ termina._
]

#dimostrazione(stile: "per assurdo, paradosso di auto-applicazione")[
  Supponiamo per assurdo che esista un algoritmo $"Arresto"$ tale che, su ogni input $(A, D)$,

  $ "Arresto"(A, D) = cases(1 quad "se" A(D) "termina", 0 quad "se" A(D) "non termina") $

  e che $"Arresto"$ termini sempre in tempo finito.

  *Osservazione preliminare.* L'algoritmo $"Arresto"$ non può limitarsi a simulare $A$ su $D$: se $A(D)$ non termina, la simulazione gira all'infinito e $"Arresto"$ non può rispondere $0$ in tempo finito. Deve allora ispezionare il codice di $A$.

  *Costruzione dell'algoritmo paradosso.* Definiamo l'algoritmo

  #algoritmo(titolo: "Paradosso(A) — usa Arresto come oracolo")[
    ```
    Paradosso(A) {
        while (Arresto(A, A) == 1) {
            ; // ciclo vuoto
        }
    }
    ```
  ]

  Notiamo che è legittimo passare $A$ sia come algoritmo sia come dato: entrambi sono sequenze di simboli sullo stesso alfabeto e una stessa stringa può essere interpretata, a seconda del contesto, come codice o come input. L'ispezione di $"Paradosso"$ mostra:

  $ "Paradosso"(A) " termina" arrow.l.r.long "Arresto"(A, A) = 0 arrow.l.r.long A(A) " non termina." $

  *L'auto-applicazione.* Cosa succede se applichiamo $"Paradosso"$ a se stesso? Sostituendo $A = "Paradosso"$:

  $ "Paradosso"("Paradosso") " termina" & arrow.l.r.long "Arresto"("Paradosso", "Paradosso") = 0 \
     & arrow.l.r.long "Paradosso"("Paradosso") " non termina." $

  Cioè $"Paradosso"("Paradosso")$ termina se e solo se non termina: *contraddizione*.

  L'unico modo per uscire dalla contraddizione è negare l'esistenza di $"Paradosso"$, ma poiché $"Paradosso"$ è ottenuto da $"Arresto"$ con una semplice costruzione, deve essere $"Arresto"$ a non esistere. Il problema dell'arresto è dunque indecidibile. #h(1fr)
]

#osservazione[
  La struttura della dimostrazione è ancora una *diagonalizzazione*: l'algoritmo $"Paradosso"$ "fa il contrario" della tabella di tutti gli algoritmi quando applicato a se stesso, esattamente come la $g$ di Cantor faceva il contrario della diagonale di tutte le funzioni.
]

#attenzione[
  Il teorema dice che è indecidibile la coppia $(A, D)$ *arbitraria*, non che sia impossibile decidere la terminazione di un singolo programma fissato. Per esempio l'algoritmo `Primo(p)` (cerca un divisore di $p$ partendo da $2$) termina certamente per ogni $p > 1$, e questo lo possiamo dimostrare.
]

=== Altri problemi indecidibili

Una volta noto un problema indecidibile, se ne ottengono molti altri:

- *Equivalenza di programmi:* dati due algoritmi $A_1, A_2$, decidere se per ogni input producono lo stesso output. Indecidibile.
- *Decimo problema di Hilbert (Matijasevich, 1970):* data un'arbitraria equazione diofantea $p(x_1, dots, x_n) = 0$ (polinomio a coefficienti interi), decidere se ammette soluzioni intere. Indecidibile.

#nota(titolo: "Lezione di Turing")[
  Non esistono algoritmi che decidono il comportamento di altri algoritmi *esaminandoli dall'esterno*, cioè senza ricorrere alla loro simulazione completa. Ogni proprietà non banale del comportamento di un algoritmo arbitrario è indecidibile (Teorema di Rice, esula da questo corso).
]

=== La tesi di Church-Turing

Sembrerebbe che la decidibilità di un problema dipenda dal modello di calcolo (RAM? Macchina di Turing? Linguaggio C? Quantum computer?). Non è così.

#ricorda[
  *Tesi di Church-Turing.* Tutti i ragionevoli modelli di calcolo risolvono esattamente la stessa classe di problemi. Modelli più sofisticati (più istruzioni, più memoria, parallelismo) possono ridurre il *tempo* di esecuzione e rendere la programmazione più ergonomica, ma _non_ ampliano la classe dei problemi decidibili.

  In particolare, la decidibilità è una proprietà del *problema*, non dell'apparato che cerca di risolverlo.
]

== Problemi intrattabili

Esiste un'ulteriore frontiera, _interna_ ai problemi decidibili: i *problemi intrattabili* sono quelli decidibili ma che richiedono tempo esponenziale nella dimensione $n$ dell'istanza --- e dunque sono praticamente irrisolvibili per $n$ già moderato. Vediamo tre classici esempi prima di formalizzare le classi di complessità.

=== Le Torri di Hanoi

#definizione(titolo: "Problema delle Torri di Hanoi")[
  Tre pioli $p$, $t$, $s$ e $n$ dischi di dimensioni decrescenti, inizialmente tutti impilati in $p$ in ordine decrescente (il più grande in basso). Spostare tutti i dischi su $t$ rispettando le regole:
  + si sposta un solo disco alla volta;
  + un disco non può essere posto su uno più piccolo.
]

#algoritmo(titolo: "TorriHanoi(n, p, t, s) — sposta n dischi da p a t usando s come appoggio")[
  ```
  TorriHanoi(n, p, t, s) {
      if (n == 1) print "p -> t";
      else {
          TorriHanoi(n - 1, p, s, t);
          print "p -> t";
          TorriHanoi(n - 1, s, t, p);
      }
  }
  ```
]

Sia $M(n)$ il numero di mosse generate dall'algoritmo. La ricorrenza è

$ M(n) = cases(1 quad & n = 1, 2 M(n-1) + 1 quad & n > 1) $

#teorema[ _$M(n) = 2^n - 1$._ ]

#dimostrazione(stile: "induzione su n")[
  *Base.* $M(1) = 1 = 2^1 - 1$.

  *Ipotesi induttiva.* $M(n - 1) = 2^(n-1) - 1$.

  *Passo.* $M(n) = 2 M(n - 1) + 1 = 2(2^(n-1) - 1) + 1 = 2^n - 2 + 1 = 2^n - 1$. #h(1fr)
]

#esempio(titolo: "L'esponenziale è davvero proibitivo")[
  Per $n = 64$ dischi, anche a una mossa al secondo, $2^(64) - 1 approx 1.8 dot 10^(19)$ secondi $approx 585 dot 10^9$ anni: oltre 40 volte l'età dell'universo. Un computer veloce non aiuta granché: se fa $10^9$ mosse al secondo, servono ancora $approx 585$ anni.
]

Possiamo fare meglio? La risposta è no.

#teorema(titolo: "Limite inferiore per le Torri di Hanoi")[
  _Sia $L(n)$ il numero di mosse necessarie a qualsiasi algoritmo corretto per risolvere il problema. Allora $L(n) >= 2^n - 1$._
]

#dimostrazione(stile: "argomento di necessità")[
  Per spostare il disco più grande dal piolo $p$ al piolo $t$, occorre che (a) i restanti $n - 1$ dischi siano fuori da $p$ e $t$, quindi tutti su $s$, (b) il piolo $t$ sia libero. Quindi prima del singolo spostamento del disco grande dobbiamo aver eseguito $L(n - 1)$ mosse per impilare gli $n - 1$ dischi piccoli su $s$. Dopo lo spostamento dobbiamo eseguire altre $L(n - 1)$ mosse per riportarli sopra il disco grande in $t$. Vale dunque

  $ L(n) >= 2 L(n - 1) + 1 quad "con" L(1) = 1, $

  da cui $L(n) >= 2^n - 1$. Poiché $M(n) = 2^n - 1$, l'algoritmo è ottimo: l'esponenziale è inerente al problema, non all'algoritmo. #h(1fr)
]

#osservazione[
  Hanoi è un problema *intrinsecamente intrattabile*: nessun algoritmo, presente o futuro, potrà mai risolverlo in tempo subesponenziale. Per altri problemi intrattabili, come quelli che vedremo nella prossima sezione, _non sappiamo_ se sia così: forse esistono algoritmi polinomiali che nessuno ha ancora trovato.
]

=== Generazione di tutte le sequenze binarie

Dato un insieme $A = {a_0, dots, a_(n-1)}$, ogni sottoinsieme $S subset.eq A$ è codificato da un array binario $B_S$ di $n$ bit: $B_S [i] = 1$ se $a_i in S$, $B_S [i] = 0$ altrimenti. I sottoinsiemi sono dunque $2^n$, e per generarli tutti basta generare le $2^n$ sequenze binarie di $n$ bit.

#algoritmo(titolo: "GeneraBinarie(B[], i, n) — riempie ricorsivamente B in posizione i")[
  ```
  GeneraBinarie(B, i, n) {
      if (i == n) Elabora(B);
      else {
          B[i] = 0;
          GeneraBinarie(B, i + 1, n);
          B[i] = 1;
          GeneraBinarie(B, i + 1, n);
      }
  }
  // Chiamata iniziale: GeneraBinarie(B, 0, n)
  ```
]

L'albero della ricorsione ha $2^n$ foglie (una per sequenza). Costo: $T(n) = Theta(2^n dot c_("Elabora"))$ dove $c_("Elabora")$ è il costo di trattare ciascuna sequenza prodotta. *L'esponenziale è inevitabile* perché l'output stesso ha dimensione esponenziale.

=== Generazione di tutte le permutazioni

Le permutazioni di un array $P$ di $n$ elementi sono $n!$. L'idea: ogni permutazione si fissa scegliendo l'elemento in posizione $0$ (e ce ne sono $n$ scelte), poi si generano ricorsivamente le permutazioni dei restanti $n - 1$ elementi.

#algoritmo(titolo: "GeneraPermutazioni(P[], i, n)")[
  ```
  GeneraPermutazioni(P, i, n) {
      if (i == n - 1) Elabora(P);
      else {
          for (j = i; j < n; j = j + 1) {
              scambia P[i] e P[j];
              GeneraPermutazioni(P, i + 1, n);
              scambia P[i] e P[j]; // ripristina l'ordine
          }
      }
  }
  // Chiamata iniziale: GeneraPermutazioni(P, 0, n)
  ```
]

Costo: $T(n) = Theta(n! dot c_("Elabora"))$. Anche qui, la dimensione dell'output (numero di permutazioni stampate) è $n!$, quindi l'esponenziale è inerente al problema di enumerazione.

#nota[
  Questi due algoritmi sono usatissimi come "motori di forza bruta" sopra problemi più ricchi: per esempio, per cercare la migliore CLIQUE in un grafo si possono enumerare i $2^n$ sottoinsiemi di vertici e per ciascuno verificare se è una clique. Da qui in poi la domanda interessante è: si può _evitare_ questa enumerazione esaustiva?
]

== Le classi di complessità

Per studiare la difficoltà dei problemi *decidibili* in termini di tempo, è utile separarli in tipologie e poi raggruppare i problemi che richiedono risorse confrontabili.

=== Tipologie di problemi computazionali

#definizione(titolo: "Decisionali, di ricerca, di ottimizzazione")[
  Un problema $Pi$ ha un insieme $cal(I)$ di istanze e un insieme $cal(S)$ di soluzioni.

  - *Decisionale:* $cal(S) = {0, 1}$. Esempi: "$G$ è connesso?", "$p$ è primo?". Le istanze su cui $Pi(x) = 1$ si dicono *positive* (o *accettabili*); quelle su cui $Pi(x) = 0$, *negative*.
  - *Di ricerca:* data $x$, restituire una qualsiasi soluzione $s in cal(S)$ (per es. trovare un cammino fra due vertici).
  - *Di ottimizzazione:* fra tutte le soluzioni ammissibili, restituire quella di costo minimo o di valore massimo (per es. clique di cardinalità massima, cammino minimo).
]

#nota(titolo: "Perché studiare i decisionali")[
  La teoria della complessità si concentra su problemi decisionali per due motivi: (a) la risposta è un singolo bit, quindi tutto il tempo dell'algoritmo è speso nel calcolo e non nella scrittura dell'output; (b) la versione decisionale è un *limite inferiore* alla versione di ottimizzazione: se sappiamo trovare la clique massima in $G$, sappiamo anche rispondere a "$G$ ha una clique di almeno $k$ vertici?". Quindi dimostrare che la versione decisionale è difficile rende difficile anche quella di ottimizzazione.
]

=== Le classi P, PSPACE, EXP

#definizione(titolo: "Classe P")[
  *P* è la classe dei problemi decisionali risolvibili in *tempo polinomiale* nella dimensione $n$ dell'istanza, ossia per i quali esiste un algoritmo di costo $O(n^k)$ con $k$ costante.
]

#definizione(titolo: "Classe PSPACE")[
  *PSPACE* è la classe dei problemi decisionali risolvibili in *spazio polinomiale* nella dimensione $n$ dell'istanza.
]

#definizione(titolo: "Classe EXP (o EXPTIME)")[
  *EXP* è la classe dei problemi decisionali risolvibili in *tempo esponenziale*, ossia $O(2^(n^k))$ per qualche costante $k$.
]

#proposizione(titolo: "Inclusioni fra classi")[
  _Vale la catena di inclusioni $P subset.eq "PSPACE" subset.eq "EXP"$._
]

#dimostrazione(stile: "intuitiva")[
  $P subset.eq "PSPACE"$: in tempo polinomiale si possono visitare al più un numero polinomiale di celle di memoria distinte (in ordine di grandezza). $"PSPACE" subset.eq "EXP"$: con $s(n)$ bit di memoria si hanno al più $2^(s(n))$ configurazioni distinte; un algoritmo che usa spazio polinomiale ha al più $2^("poly"(n))$ configurazioni e termina entro questo numero di passi (altrimenti entrerebbe in ciclo). #h(1fr)
]

#esempio(titolo: "Problemi in P")[
  Ordinamento ($O(n log n)$), ricerca in array/lista/albero, ordinamento topologico di un DAG, connettività di un grafo, ricerca di un ciclo euleriano, test di primalità.
]

#esempio(titolo: "Problemi presumibilmente intrattabili")[
  Per i problemi seguenti conosciamo solo algoritmi esponenziali, ma _nessuno ha mai dimostrato_ che non possa esistere un algoritmo polinomiale.

  *CLIQUE.* Dato un grafo $G = (V, E)$ e un intero $k > 0$, $G$ contiene una clique (sottografo completo) di almeno $k$ nodi? L'algoritmo banale prova tutti i $2^n$ sottoinsiemi di vertici.

  *Cammino Hamiltoniano.* Dato $G = (V, E)$, esiste un cammino semplice che attraversa _tutti_ i vertici esattamente una volta? L'algoritmo banale prova tutte le $n!$ permutazioni dei vertici.

  *SAT (soddisfacibilità booleana).* Data una formula $F$ in *forma normale congiuntiva* (FNC), cioè $F = c_1 and c_2 and dots and c_m$ dove ogni clausola $c_i$ è una disgiunzione (OR) di letterali (variabili o loro negazioni), esiste un'assegnazione di verità alle variabili che rende $F$ vera? Per $n$ variabili, l'algoritmo banale prova tutti i $2^n$ assegnamenti.
]

#esempio(titolo: "Una formula SAT")[
  $V = {x, y, z, w}$, $F = (x or y or z) and (overline(x) or w) and y$. L'assegnazione $x = 1, y = 1, z = 0, w = 1$ rende ogni clausola vera, dunque $F$ è soddisfacibile.
]

== Verifica e classe NP

L'intuizione chiave per definire NP è la differenza fra _trovare_ una soluzione e _verificare_ che una soluzione candidata sia corretta. Spesso le due cose hanno costi radicalmente diversi: trovare i fattori di un intero di 200 cifre è proibitivo, ma se qualcuno ti dà i fattori, moltiplicarli e controllare richiede un microsecondo.

#definizione(titolo: "Certificato")[
  Per un problema decisionale $Pi$ e un'istanza accettabile $x$ (con $Pi(x) = 1$), un *certificato* è un'informazione che permette di verificare in tempo polinomiale che effettivamente $Pi(x) = 1$.
]

#esempio(titolo: "Certificati naturali")[
  - *CLIQUE:* il certificato è il sottoinsieme di $k$ vertici. La verifica controlla in tempo $O(k^2)$ che ogni coppia sia collegata da un arco.
  - *SAT:* il certificato è un'assegnazione $alpha$ alle variabili. La verifica valuta $F$ su $alpha$ in tempo $O(|F|)$.
  - *Cammino Hamiltoniano:* il certificato è una sequenza di vertici. La verifica controlla in $O(n)$ che ogni vertice compaia una volta e che ogni transizione sia un arco.
  - *Fattorizzazione (versione decisionale: $n$ ha un fattore $<= k$?):* il certificato è il fattore $d <= k$. La verifica esegue una sola divisione.
]

#definizione(titolo: "Classe NP")[
  *NP* è la classe dei problemi decisionali per i quali esiste un *algoritmo di verifica* polinomiale, ossia un algoritmo $V(x, c)$ tale che:
  + $V$ termina in tempo $"poly"(|x|)$;
  + $Pi(x) = 1$ se e solo se esiste un certificato $c$ di lunghezza $"poly"(|x|)$ tale che $V(x, c) = 1$.
]

#nota(titolo: "Perché si chiama NP?")[
  *NP* sta per *Nondeterministic Polynomial time*. La definizione equivalente "storica" è: $Pi in "NP"$ se esiste una macchina di Turing _non deterministica_ (capace di "indovinare" la scelta giusta a ogni passo) che lo risolve in tempo polinomiale. Le due definizioni coincidono perché la macchina non deterministica può essere simulata dalla coppia "indovina il certificato + verifica".

  *Attenzione:* NP _non_ significa "non polinomiale".
]

#proposizione[ _$P subset.eq "NP"$._ ]

#dimostrazione(stile: "diretta")[
  Se $Pi in P$, esiste un algoritmo $A$ polinomiale che risolve $Pi$. Definiamo l'algoritmo di verifica $V(x, c) = A(x)$, che ignora il certificato. Questo soddisfa la definizione di NP. #h(1fr)
]

#osservazione[
  *Rapporto P--NP.* P è dunque contenuto in NP. La grande domanda aperta della complessità computazionale è: $P = "NP"$ oppure $P subset.neq "NP"$? In altre parole, *verificare velocemente è equivalente a risolvere velocemente?*

  La maggior parte degli informatici teorici crede che $P != "NP"$, ma nessuno è mai riuscito a dimostrarlo. La domanda è uno dei sette *Problemi del Millennio* del Clay Mathematics Institute, con un premio di un milione di dollari per chi la risolverà.
]

== Riduzioni polinomiali

L'idea: per confrontare la difficoltà di due problemi, si "trasforma" un problema nell'altro. Se sappiamo risolvere il secondo, sappiamo risolvere anche il primo.

#definizione(titolo: "Riduzione polinomiale")[
  Siano $Pi_1$ e $Pi_2$ problemi decisionali con insiemi di istanze $cal(I)_1$ e $cal(I)_2$. Si dice che $Pi_1$ *si riduce in tempo polinomiale* a $Pi_2$, e si scrive

  $ Pi_1 <=_p Pi_2 $

  se esiste una funzione $f: cal(I)_1 arrow.r cal(I)_2$ calcolabile in tempo polinomiale tale che, per ogni istanza $x in cal(I)_1$,

  $ Pi_1 (x) = 1 quad <==> quad Pi_2 (f(x)) = 1. $
]

#osservazione[
  *Cosa significa.* Una riduzione $Pi_1 <=_p Pi_2$ è un *traduttore*: trasforma istanze di $Pi_1$ in istanze di $Pi_2$ preservandone la risposta. Il fatto che $f$ sia polinomiale è cruciale: garantisce che la traduzione non "distrugge" l'efficienza.
]

#proposizione(titolo: "La riduzione trasporta la trattabilità")[
  _Se $Pi_1 <=_p Pi_2$ e $Pi_2 in P$, allora $Pi_1 in P$._
]

#dimostrazione(stile: "composizione di algoritmi")[
  Sia $f$ la riduzione, calcolabile in tempo $O(n^k)$, e sia $A_2$ un algoritmo polinomiale per $Pi_2$ di costo $O(m^h)$. Dato $x in cal(I)_1$ di taglia $n$:
  + calcoliamo $y = f(x)$ in tempo $O(n^k)$, ottenendo un'istanza di $Pi_2$ la cui taglia $m$ è al più $O(n^k)$ (non si può scrivere più di quanto si possa calcolare);
  + restituiamo $A_2 (y)$, in tempo $O(m^h) = O(n^(k h))$.

  Il costo totale è polinomiale e la risposta è corretta per definizione di riduzione. #h(1fr)
]

#nota[
  La proposizione si legge anche al contrario (per contrapposizione): se $Pi_1 in.not P$ e $Pi_1 <=_p Pi_2$, allora $Pi_2 in.not P$. *Una riduzione di $A$ a $B$ certifica che $B$ è almeno difficile quanto $A$.*
]

== NP-hard e NP-completi

Le riduzioni polinomiali permettono di individuare i problemi *più difficili* dentro NP.

#definizione(titolo: "NP-hard, NP-completo")[
  Un problema decisionale $Pi$ si dice:

  - *NP-hard* se _ogni_ problema $Pi' in "NP"$ si riduce polinomialmente a $Pi$:
    $ forall Pi' in "NP", quad Pi' <=_p Pi. $
  - *NP-completo* se è NP-hard e inoltre $Pi in "NP"$.
]

#ricorda[
  Intuitivamente, i problemi *NP-completi* sono i più difficili dentro NP. Un problema *NP-hard* può anche stare fuori da NP (è "almeno" così difficile, ma potrebbe esserlo di più).
]

#teorema(titolo: "Conseguenze della NP-completezza")[
  _Sia $Pi$ NP-completo._
  + _Se $Pi in P$, allora $P = "NP"$._
  + _Se $P != "NP"$, allora $Pi in.not P$._
]

#dimostrazione(stile: "uso della riduzione")[
  *Punto 1.* Sia $Pi'$ un qualsiasi problema in NP. Per NP-completezza $Pi' <=_p Pi$. Se $Pi in P$, per la proposizione precedente $Pi' in P$. Vale per ogni $Pi' in "NP"$, quindi $"NP" subset.eq P$. Combinato con $P subset.eq "NP"$, si ottiene $P = "NP"$.

  *Punto 2.* Contropositiva del Punto 1. #h(1fr)
]

#nota(titolo: "Conseguenza pratica")[
  Tutti i problemi NP-completi sono *equivalenti* dal punto di vista della complessità: o sono _tutti_ trattabili (e $P = "NP"$), o sono _tutti_ intrattabili. Trovare un algoritmo polinomiale per uno _qualunque_ di essi risolverebbe automaticamente l'intera classe NP.
]

=== Il teorema di Cook--Levin

Il primo problema del quale si è dimostrata la NP-completezza è SAT. Questo fornisce un "punto di ancoraggio": dimostrare che un nuovo problema $Pi$ è NP-completo si riduce a:
+ verificare che $Pi in "NP"$ (di solito facile: si esibisce un certificato);
+ esibire una riduzione $"SAT" <=_p Pi$ (oppure da un altro problema NP-completo già noto).

#teorema(titolo: "Cook (1971), Levin (1973)")[
  _SAT è NP-completo._
]

(La dimostrazione, tecnica, non viene riportata in questo corso.)

#proposizione(titolo: "Caratterizzazione operativa della NP-completezza")[
  _Un problema $Pi in "NP"$ è NP-completo se e solo se $"SAT" <=_p Pi$ (o, equivalentemente, $Pi^* <=_p Pi$ per un qualsiasi problema $Pi^*$ NP-completo)._
]

#dimostrazione(stile: "transitività delle riduzioni")[
  Le riduzioni polinomiali sono transitive: se $A <=_p B$ tramite $f$ e $B <=_p C$ tramite $g$, allora $A <=_p C$ tramite $g compose f$ (composizione di funzioni polinomiali è polinomiale). Per ogni $Pi' in "NP"$, $Pi' <=_p "SAT"$ (Cook) e per ipotesi $"SAT" <=_p Pi$, dunque $Pi' <=_p Pi$. #h(1fr)
]

=== Una riduzione esemplare: $"SAT" <=_p "CLIQUE"$

Mostriamo come la riduzione di Cook--Levin si propaga ad altri problemi.

#teorema[ _CLIQUE è NP-completo._ ]

#dimostrazione(stile: "riduzione esplicita")[
  *CLIQUE è in NP.* Certificato: il sottoinsieme di $k$ vertici. Verifica in $O(k^2)$.

  *Riduzione $"SAT" <=_p "CLIQUE"$.* Data una formula in FNC $F = c_1 and c_2 and dots and c_k$, costruiamo in tempo polinomiale un grafo $G = (V, E)$ tale che $G$ contenga una $k$-clique se e solo se $F$ è soddisfacibile.

  *Vertici.* Per ogni occorrenza di un letterale $ell$ nella clausola $c_i$ inseriamo il vertice $ell_i$. Se $F$ ha $k$ clausole e ognuna ha al più $r$ letterali, $|V| <= k r$.

  *Archi.* Mettiamo l'arco $(x_i, y_j)$ se e solo se:
  + $i != j$ (i due letterali appartengono a *clausole diverse*);
  + $x != overline(y)$ (i due letterali sono *consistenti*: possono essere veri contemporaneamente).

  Costruzione in tempo polinomiale: $|E| <= |V|^2 <= (k r)^2$, e ogni arco si decide in tempo costante.

  *Equivalenza.*

  ($arrow.l.double$) Se $F$ è soddisfacibile, esiste un'assegnazione $alpha$ che rende vera ogni clausola. Per ogni clausola $c_i$ scegliamo un letterale $ell^*_i$ vero in $alpha$ e prendiamo i vertici corrispondenti $ell^*_(1), dots, ell^*_(k)$. Sono vertici di clausole diverse, e sono mutualmente consistenti (perché tutti veri sotto $alpha$). Quindi formano una $k$-clique.

  ($arrow.r.double$) Se $G$ contiene una $k$-clique, i suoi $k$ vertici devono appartenere a $k$ clausole _distinte_ (per la condizione (1)). Inoltre i corrispondenti letterali sono tutti consistenti (per la condizione (2)), dunque possiamo assegnare valore _vero_ a tutti questi letterali simultaneamente, soddisfacendo tutte e $k$ le clausole. Estendendo arbitrariamente l'assegnazione alle variabili rimaste libere, otteniamo un'assegnazione che soddisfa $F$. #h(1fr)
]

#esempio(titolo: "$F = (a or b) and (overline(a) or overline(b) or c) and overline(c)$")[
  La formula ha $k = 3$ clausole; il grafo costruito ha $6$ vertici: $a_1, b_1, overline(a)_2, overline(b)_2, c_2, overline(c)_3$.

  Gli archi collegano coppie di vertici (i) di clausole diverse, (ii) consistenti. Ad esempio: $a_1$ è collegato a $overline(b)_2$ e a $c_2$ ma _non_ a $overline(a)_2$ (sono inconsistenti); $a_1$ non è collegato a $b_1$ (stessa clausola).

  Una $3$-clique nel grafo è ${b_1, overline(a)_2, overline(c)_3}$, che corrisponde all'assegnazione parziale $b = 1, a = 0, c = 0$: si verifica che soddisfa $F$.
]

#nota(titolo: "Problemi NP-equivalenti")[
  Per la transitività delle riduzioni, da $"SAT" <=_p "CLIQUE"$ e dal fatto che SAT è NP-completo segue anche $"CLIQUE" <=_p "SAT"$: SAT e CLIQUE sono *NP-equivalenti*. Tutti i problemi NP-completi sono mutuamente equivalenti: o sono _tutti_ facili (e $P = "NP"$), o sono _tutti_ difficili.
]

=== Altri NP-completi notevoli

Una volta dimostrato che CLIQUE è NP-completo, si possono dimostrare altri risultati di NP-completezza riducendosi a CLIQUE (o a SAT, o a uno qualsiasi dei nuovi NP-completi). Si è creata così una rete di migliaia di problemi NP-completi: se uno solo di essi fosse in $P$, lo sarebbero tutti.

#esempio(titolo: "Altri famosi NP-completi")[
  - *Cammino e Ciclo Hamiltoniano:* dato $G = (V, E)$, esiste un cammino (rispettivamente, un ciclo) semplice che attraversa _tutti_ i vertici una ed una sola volta?
  - *Commesso Viaggiatore (TSP):* dato un grafo completo $G$ con pesi $w$ sugli archi ed un intero $k$, esiste un ciclo di peso al più $k$ che attraversa ogni vertice una ed una sola volta?
  - *Zaino (Knapsack):* dato uno zaino di capacità $c$, $n$ oggetti di dimensioni $s_1, dots, s_n$ con profitti $p_1, dots, p_n$ ed un intero $k$, esiste un sottoinsieme degli oggetti di dimensione totale al più $c$ che garantisca profitto totale almeno $k$?
  - *Map Coloring:* è possibile colorare i vertici di un grafo con un numero limitato di colori in modo che a due vertici adiacenti sia assegnato un colore diverso? Sui grafi non planari è un problema difficile.
]

== La gerarchia completa e la questione di P vs NP

Riassumiamo le inclusioni note (e le poche che siamo certi essere strette):

#align(center)[
  $ P subset.eq "NP" subset.eq "PSPACE" subset.eq "EXP" subset.eq "Decidibili" subset.neq "Tutti i problemi". $
]

#osservazione[
  Sebbene si sappia che la classe dei problemi decidibili contiene strettamente la classe dei problemi indecidibili (per esempio, il problema dell'arresto sta fuori dalla prima), le inclusioni intermedie $P subset.eq "NP" subset.eq "PSPACE" subset.eq "EXP"$ sono in larga parte non ancora note essere strette. La domanda più celebre è la prima della catena.
]

#nota(titolo: "Cosa fare quando si incontra un NP-completo")[
  Se la soluzione ottima è troppo difficile da ottenere, una soluzione quasi ottima ottenibile facilmente potrebbe essere già abbastanza buona. In pratica si ricorre a una di queste strategie:

  - *Algoritmi approssimati:* restituiscono una soluzione la cui qualità non è troppo lontana da quella ottima.
  - *Algoritmi probabilistici:* la soluzione ottima si ottiene con alta probabilità.
  - *Euristiche:* simulazioni statistiche mostrano la bontà del metodo in molti casi, anche senza garanzie formali.
]

#ricorda[
  *Conseguenze sulla crittografia moderna.* Buona parte della *crittografia a chiave pubblica* (RSA, DSA, $dots$) si fonda sull'ipotesi che la fattorizzazione di interi e il logaritmo discreto _non_ siano in $P$. Curiosamente questi due problemi sono in NP ma _non_ si sa se siano NP-completi. Una dimostrazione di $P = "NP"$ avrebbe conseguenze drammatiche: si "romperebbero" molti protocolli crittografici. Una dimostrazione di $P != "NP"$ confermerebbe che la sicurezza è fondata.
]

== Esercizi

#esercizio(tipo: "Discussione")[
  Spiegare con parole proprie perché l'argomento di Turing per l'indecidibilità dell'arresto è una *diagonalizzazione*. Quale "tabella" stiamo costruendo, e qual è il "valore opposto" che mette in contraddizione l'enumerazione?
]

#esercizio(tipo: "Vero/Falso")[
  Stabilire se ciascuna delle seguenti affermazioni è vera o falsa, motivando.
  + Se $P = "NP"$, ogni problema in NP è risolvibile in tempo polinomiale.
  + Se $Pi_1 <=_p Pi_2$ e $Pi_1$ è NP-completo, allora $Pi_2$ è NP-completo.
  + Se $Pi_1 <=_p Pi_2$ e $Pi_2$ è NP-completo, allora $Pi_1$ è NP-completo.
  + L'esistenza di un algoritmo polinomiale per CLIQUE implicherebbe l'esistenza di un algoritmo polinomiale per SAT.
  + Il problema dell'arresto è in EXP.
]

#esercizio(tipo: "Calcolo")[
  Costruire esplicitamente il grafo $G$ ottenuto dalla riduzione SAT--CLIQUE applicata alla formula

  $ F = (x or y) and (overline(x) or y) and (overline(y) or z). $

  Quanti vertici ha? Quanti archi? Esibire una $3$-clique e l'assegnazione corrispondente.
]

#esercizio(tipo: "Dimostrazione")[
  Dimostrare per induzione che $L(n) = 2^n - 1$, dove $L(n)$ è la ricorrenza $L(1) = 1$, $L(n) = 2 L(n-1) + 1$. (Oltre alla base e al passo, mostrare anche che il "$+1$" è essenziale: cosa succederebbe se la ricorrenza fosse $L(n) = 2 L(n-1)$?)
]

#esercizio(tipo: "Controesempio")[
  Mostrare che la condizione "$f$ calcolabile in tempo polinomiale" nella definizione di riduzione $<=_p$ è essenziale: esibire (anche informalmente) due problemi $Pi_1 in.not P$ e $Pi_2 in P$ tali che esiste una funzione $f$ (non polinomiale) che riduce $Pi_1$ a $Pi_2$. Spiegare perché ciò non contraddice la proposizione "$Pi_1 <=_p Pi_2 and Pi_2 in P arrow.r.double Pi_1 in P$".
]

#esercizio(tipo: "Discussione")[
  L'algoritmo `Goldbach()` termina se e solo se la congettura di Goldbach è falsa. Supponiamo che un giorno si dimostri che Goldbach è vera. Cosa cambierebbe rispetto al teorema di Turing? E se invece si trovasse un controesempio?
]

#esercizio(tipo: "Riduzione")[
  Riprodurre, senza guardare il testo, la riduzione $"SAT" <=_p "CLIQUE"$: definizione dei vertici, regola degli archi, dimostrazione delle due implicazioni e analisi del costo.
]

#esercizio(tipo: "Discussione")[
  Spiegare a parole proprie perché, se un singolo problema NP-completo fosse risolvibile in tempo polinomiale, allora *tutti* i problemi in NP sarebbero risolvibili in tempo polinomiale.
]
