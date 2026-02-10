#import "../template.typ": *

== Cos'è l'Informatica

#definition(title: "Informatica")[
  Lo studio sistematico degli *algoritmi* che descrivono e trasformano le informazioni: la loro teoria, analisi, progettazione, efficienza, implementazione e applicazione. (ACM -- Association for Computing Machinery)
]

L'informatica non è semplicemente lo studio dei computer, ma lo studio dei _processi algoritmici_: come rappresentare l'informazione, come trasformarla e come farlo in modo efficiente. Il calcolatore è lo strumento che permette di eseguire tali processi in modo rapido e affidabile.

== Algoritmo

#definition(title: "Algoritmo")[
  Una sequenza *finita* di *passi* (istruzioni) *univocamente determinati* che, se eseguiti da un *esecutore*, portano alla risoluzione di un *problema*.
]

Le parole chiave di questa definizione meritano un approfondimento:
- *Passi*: operazioni elementari, cioè istruzioni la cui esecuzione è ben definita e non ulteriormente scomponibile dal punto di vista dell'esecutore.
- *Esecutore*: l'entità (umano o macchina) che esegue i passi dell'algoritmo. Nel nostro caso l'esecutore è un calcolatore.
- *Problema*: la domanda a cui l'algoritmo deve rispondere, specificata in modo preciso tramite input e output.

Le tre componenti fondamentali di un algoritmo sono dunque:
+ il *problema* da risolvere,
+ il *procedimento* (la sequenza di passi) da seguire,
+ l'*esecutore* che interpreta ed esegue le istruzioni.

#note[
  La descrizione dell'algoritmo deve essere comprensibile dall'esecutore: un algoritmo corretto ma scritto in un linguaggio che l'esecutore non comprende risulta inutile.
]

=== Proprietà degli algoritmi

Un algoritmo deve soddisfare le seguenti proprietà:

- *Finitezza*: l'algoritmo è composto da un numero finito di passi e la sua esecuzione deve terminare in tempo finito per ogni input valido.
- *Non ambiguità*: ogni passo è definito in modo preciso, senza possibilità di interpretazioni diverse. L'esecutore non deve mai trovarsi nella condizione di non sapere cosa fare.
- *Determinismo*: dato lo stato corrente dell'esecuzione, il passo successivo è univocamente determinato. A parità di input, l'algoritmo produce sempre lo stesso output.
- *Generalità*: l'algoritmo risolve un'intera _classe_ di problemi, non una singola istanza specifica.

#example(title: "Algoritmo per il massimo di un vettore")[
  *Problema*: dato un array $A[1..n]$ di $n$ interi, determinare il valore massimo.

  - *Input*: array $A$ di $n$ interi
  - *Output*: il valore $m$ tale che $m = max{A[i] : 1 <= i <= n}$

  *Algoritmo* (in linguaggio naturale):
  + Assumi il primo elemento come massimo corrente.
  + Per ciascun elemento successivo, confrontalo con il massimo corrente: se è maggiore, aggiorna il massimo corrente.
  + Al termine, restituisci il massimo corrente.

  *In MAO*:

  #algorithm(title: "Massimo di un array")[
    ```
    int max(int[] A, int n){
        int m = A[1];
        int i = 2;
        while(i <= n){
            if(A[i] > m){
                m := A[i];
            }
            i := i + 1;
        }
        return m;
    }
    ```
  ]
]

== Programma e programmazione

#definition(title: "Programma")[
  La formulazione di un algoritmo in un *linguaggio di programmazione*. Un programma specifica al calcolatore quali operazioni eseguire, in quale ordine, su quali dati e sotto quali condizioni.
]

#definition(title: "Programmazione")[
  L'attività di progettare e scrivere programmi, ossia tradurre un algoritmo in una sequenza di istruzioni eseguibili da un calcolatore.
]

=== Differenza tra algoritmo e programma

Un algoritmo è un concetto _astratto_, indipendente dal linguaggio in cui viene espresso. Un programma è la sua realizzazione _concreta_ in un linguaggio specifico. Lo stesso algoritmo può essere implementato in linguaggi diversi, ottenendo programmi differenti ma semanticamente equivalenti.

#figure(
  table(
    columns: 3,
    [*Aspetto*], [*Algoritmo*], [*Programma*],
    [Livello], [Astratto], [Concreto],
    [Linguaggio], [Naturale / pseudocodice], [Linguaggio di programmazione],
    [Esecutore], [Umano o macchina], [Solo macchina],
    [Dettagli implementativi], [Possono essere omessi], [Tutti specificati],
  ),
  caption: [Confronto tra algoritmo e programma]
)

== Computer e problem solving

#definition(title: "Computer")[
  Un *calcolatore* è una macchina in grado di eseguire operazioni elementari con grande *rapidità* e *precisione*, seguendo le istruzioni di un programma.
]

Un computer riceve in *input* un programma (testo) e un insieme di dati, e produce in *output* il risultato dell'esecuzione del programma sui dati forniti. A differenza di altre macchine automatiche (ad esempio una lavatrice, il cui comportamento è fisso), un computer è *programmabile*: il compito svolto dipende interamente dal programma caricato.

=== Problem solving

#definition(title: "Problem solving")[
  Attività sistematica finalizzata all'analisi e alla risoluzione di _problemi computazionali_, ovvero problemi formulabili in termini di input, output e di una relazione tra essi.
]

Il processo di problem solving si articola nelle seguenti fasi:

+ *Specifica*: definizione precisa del problema, stabilendo chiaramente quali sono gli input ammissibili e qual è l'output atteso.
+ *Progettazione*: ideazione di un algoritmo che risolve il problema, ragionando sulla strategia risolutiva.
+ *Analisi*: studio delle proprietà dell'algoritmo, in particolare la sua _correttezza_ (produce l'output corretto per ogni input valido) e la sua _efficienza_ (quanto tempo e quanta memoria richiede).
+ *Codifica*: traduzione dell'algoritmo in un linguaggio di programmazione, ottenendo un programma.
+ *Testing e debugging*: verifica sperimentale della correttezza del programma su input di prova e correzione degli eventuali errori.
+ *Esecuzione*: esecuzione del programma sul calcolatore.

#note(title: "Problemi irrisolvibili")[
  Non tutti i problemi computazionali ammettono una soluzione algoritmica. Esistono problemi per i quali si può dimostrare che _non esiste alcun algoritmo_ in grado di risolverli. Un esempio celebre è il *Problema della fermata* (_Halting Problem_): dato un programma $P$ e un input $x$, stabilire se $P$ termina quando eseguito su $x$. Alan Turing dimostrò nel 1936 che non esiste alcun algoritmo in grado di rispondere correttamente per ogni coppia $(P, x)$.
]

== Problemi computazionali

#definition(title: "Problema computazionale")[
  Un problema formulato in modo preciso di cui si cerca una soluzione algoritmica. Un problema computazionale è definito da tre elementi:
  - *Input*: l'insieme dei dati in ingresso, cioè la descrizione di tutte le possibili _istanze_ del problema.
  - *Output*: il risultato atteso.
  - *Relazione input-output*: il vincolo che lega l'output all'input, specificando quale output è corretto per ciascun input.
]

#definition(title: "Istanza di un problema")[
  Un'istanza è un input specifico, cioè un particolare elemento dell'insieme degli input ammissibili. Un algoritmo che risolve un problema deve produrre l'output corretto per _ogni_ istanza.
]

#example(title: "Problema dell'ordinamento")[
  - *Input*: una sequenza di $n$ numeri $chevron.l a_1, a_2, dots, a_n chevron.r$
  - *Output*: una permutazione $chevron.l a'_1, a'_2, dots, a'_n chevron.r$ della sequenza di input tale che $a'_1 <= a'_2 <= dots <= a'_n$

  Ad esempio, data l'istanza $chevron.l 5, 2, 8, 1 chevron.r$, l'output corretto è $chevron.l 1, 2, 5, 8 chevron.r$.
]

#example(title: "Problema della ricerca")[
  - *Input*: una sequenza di $n$ numeri $chevron.l a_1, a_2, dots, a_n chevron.r$ e un valore $k$
  - *Output*: un indice $i$ tale che $a_i = k$, oppure $-1$ se $k$ non compare nella sequenza

  Ad esempio, data l'istanza $chevron.l 3, 7, 1, 9 chevron.r$ con $k = 7$, l'output corretto è $i = 2$.
]

== Correttezza e terminazione

Dato un problema computazionale, un algoritmo che intende risolverlo deve soddisfare due requisiti fondamentali.

#definition(title: "Correttezza")[
  Un algoritmo si dice *corretto* rispetto a un problema computazionale se, per ogni istanza valida dell'input, produce l'output corretto (cioè l'output che soddisfa la relazione input-output del problema).
]

#definition(title: "Terminazione")[
  Un algoritmo si dice *terminante* se, per ogni istanza valida dell'input, la sua esecuzione si conclude in un numero finito di passi.
]

#note[
  Un algoritmo che produce risultati corretti ma non termina su certi input non è considerato un algoritmo valido. Analogamente, un algoritmo che termina sempre ma produce risultati errati non è utile. Sono necessarie _entrambe_ le proprietà: correttezza e terminazione.
]
