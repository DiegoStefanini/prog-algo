#import "../template.typ": *

== Linguaggi di Programmazione

Abbiamo visto che un algoritmo ed un programma sono concetti distinti: il primo è una descrizione astratta di un procedimento risolutivo, il secondo è la sua formulazione concreta in un linguaggio comprensibile da una macchina. Il *linguaggio di programmazione* è lo strumento che consente questa traduzione.

#definition(title: "Linguaggio di programmazione")[
  Un linguaggio di programmazione è un linguaggio formale dotato di una *sintassi* rigorosa e di una *semantica* precisa, progettato per esprimere algoritmi in una forma eseguibile da un calcolatore.
]

I linguaggi di programmazione condividono alcune caratteristiche fondamentali:
- sono *formali*: ogni costrutto ha una definizione precisa e non ambigua;
- sono *eseguibili*: un programma scritto correttamente può essere eseguito da una macchina;
- sono *espressivi*: permettono di descrivere algoritmi che risolvono problemi computazionali.

#note[
  Un linguaggio di programmazione funge da *ponte* tra il ragionamento umano e l'esecuzione automatica. Esistono centinaia di linguaggi (C, Python, Java, JavaScript, Haskell, ...), ciascuno con caratteristiche proprie, ma tutti fondati sugli stessi concetti di base che studieremo in questo corso.
]

== Il linguaggio MAO

Per lo studio dei fondamenti della programmazione utilizzeremo un linguaggio didattico appositamente progettato.

#definition(title: "MAO -- Modello Astratto Operazionale")[
  MAO è un linguaggio di programmazione imperativo semplificato, progettato a fini didattici. Pur essendo sintetico, MAO include tutti i costrutti fondamentali presenti nei linguaggi reali: dichiarazioni, assegnamenti, condizionali, cicli, funzioni e array.
]

La scelta di un linguaggio didattico permette di concentrarsi sui *concetti* della programmazione senza le complicazioni tecniche dei linguaggi industriali (gestione della memoria, librerie, ambienti di sviluppo, ecc.).

=== Costrutti principali

I costrutti fondamentali di MAO sono riassunti nella tabella seguente.

#figure(
  table(
    columns: 3,
    [*Costrutto*], [*Sintassi*], [*Descrizione*],
    [Dichiarazione], [`int x = 5;`], [Introduce una nuova variabile con tipo e valore iniziale],
    [Assegnamento], [`x := x + 1;`], [Modifica il valore di una variabile già dichiarata],
    [Condizionale], [`if(x > 0){ ... } else { ... }`], [Esegue un blocco in base a una condizione],
    [Ciclo], [`while(x > 0){ ... }`], [Ripete un blocco finché la condizione è vera],
    [Funzione], [`int f(int a){ return a * 2; }`], [Definisce un sottoprogramma con parametri e valore di ritorno],
    [Array], [`int[] A = int[5];`], [Dichiara una sequenza indicizzata di valori],
  ),
  caption: [Costrutti fondamentali del linguaggio MAO],
)

#note(title: "Dichiarazione vs. Assegnamento")[
  In MAO la distinzione tra *dichiarazione* e *assegnamento* è resa esplicita dalla sintassi:
  - il simbolo `=` si usa esclusivamente nella *dichiarazione*, cioè quando si introduce una nuova variabile (ad esempio `int x = 5;`);
  - il simbolo `:=` si usa per l'*assegnamento*, cioè per modificare il valore di una variabile già esistente (ad esempio `x := x + 1;`).

  Questa convenzione, diversa da quella adottata dalla maggior parte dei linguaggi reali (che usano `=` per entrambe le operazioni), ha il vantaggio di rendere immediatamente visibile se un'istruzione sta creando una nuova variabile o modificandone una esistente.
]

#example(title: "Primo programma in MAO")[
  ```
  int x = 5;
  int y = 3;
  int somma = x + y;
  ```
  Il programma dichiara due variabili intere `x` e `y`, poi dichiara una terza variabile `somma` il cui valore iniziale è la somma delle prime due. Al termine dell'esecuzione, `somma` contiene il valore $8$.
]

#example(title: "Uso del ciclo while")[
  ```
  int n = 5;
  int fatt = 1;
  while(n > 1){
      fatt := fatt * n;
      n := n - 1;
  }
  ```
  Questo programma calcola il fattoriale di $5$. Si noti l'uso di `:=` per gli assegnamenti all'interno del ciclo: le variabili `fatt` e `n` sono già state dichiarate e qui ne modifichiamo il valore.
]

== Sintassi e Semantica

Lo studio di un linguaggio di programmazione si articola in due aspetti complementari ma distinti: la *sintassi*, che riguarda la forma delle frasi, e la *semantica*, che riguarda il loro significato.

#figure(
  table(
    columns: 3,
    [*Aspetto*], [*Domanda chiave*], [*Esempio*],
    [*Sintassi*], [Come si scrive un programma valido?], [`if(x > 0){ ... }`],
    [*Semantica*], [Cosa significa un programma valido?], [Se $x > 0$, esegui il blocco],
  ),
  caption: [I due livelli di analisi di un linguaggio],
)

#definition(title: "Sintassi")[
  La sintassi di un linguaggio è l'insieme delle regole che stabiliscono quali sequenze di simboli costituiscono frasi (programmi) *ben formate*. In altri termini, la sintassi definisce la struttura grammaticale del linguaggio.
]

#definition(title: "Semantica")[
  La semantica di un linguaggio associa un *significato* a ciascuna frase sintatticamente corretta. Nel caso dei linguaggi di programmazione, la semantica specifica quale computazione viene eseguita da un programma: quali operazioni vengono svolte, in quale ordine e con quale effetto sullo stato della macchina.
]

La distinzione tra sintassi e semantica è cruciale: un programma può essere sintatticamente corretto ma semanticamente errato (ovvero, compila senza errori ma non fa ciò che vogliamo), oppure sintatticamente scorretto e quindi non eseguibile affatto.

#example(title: "Stesso significato, sintassi diversa")[
  L'operazione "incrementa $x$ di 1" si scrive in modo diverso a seconda del linguaggio:

  #figure(
    table(
      columns: 2,
      [*Linguaggio*], [*Sintassi*],
      [MAO], [`x := x + 1;`],
      [Python], [`x = x + 1`],
      [C/C++], [`x++;`],
    ),
    caption: [La stessa operazione in linguaggi diversi],
  )

  Le tre istruzioni hanno la stessa *semantica* (incrementare il valore di $x$ di un'unità) ma *sintassi* differente. Questo dimostra che la sintassi è una proprietà del linguaggio, mentre la semantica è legata al significato dell'operazione.
]

=== Perché una sintassi formale?

Nel linguaggio naturale, un interlocutore umano è in grado di interpretare frasi anche in presenza di errori:

#example(title: "Ambiguità del linguaggio naturale")[
  La frase "Dmoani vado al mrae" è comprensibile per un essere umano come "Domani vado al mare", nonostante gli errori di ortografia. Un calcolatore, invece, non possiede questa capacità di interpretazione: richiede istruzioni scritte in modo *esatto* e *non ambiguo*.
]

Per questo motivo i linguaggi di programmazione hanno una sintassi *formale*, definita in modo rigoroso tramite *grammatiche formali*. Una grammatica formale specifica in modo preciso e completo quali sequenze di simboli appartengono al linguaggio e quali no.

#example(title: "Errori sintattici in MAO")[
  ```
  int x = ;        // ERRORE: manca l'espressione dopo =
  if x > 0 { }    // ERRORE: mancano le parentesi tonde
  int 3y = 10;     // ERRORE: identificatore non valido
  ```
  Ciascuna di queste righe viola una regola sintattica di MAO e viene rifiutata prima ancora che il programma possa essere eseguito. Il compilatore (o l'interprete) segnala l'errore indicando quale regola è stata violata.
]

#note[
  Le grammatiche formali non sono una peculiarità dei linguaggi di programmazione: anche le lingue naturali possiedono una grammatica (soggetto + verbo + complemento in italiano). La differenza fondamentale è che le grammatiche dei linguaggi naturali ammettono eccezioni e ambiguità, mentre quelle dei linguaggi formali sono *complete* e *non ambigue* per costruzione.
]

== Obiettivi della programmazione

Scrivere un programma corretto non è sufficiente: un buon programma deve soddisfare diversi criteri di qualità.

- *Correttezza*: il programma deve risolvere il problema per cui è stato progettato, producendo l'output atteso per ogni input valido. La correttezza può essere verificata tramite *testing* (esecuzione su casi di prova) o dimostrata formalmente tramite *invarianti* e *precondizioni/postcondizioni*.

- *Efficienza*: il programma deve utilizzare le risorse computazionali (tempo di esecuzione e spazio in memoria) in modo ragionevole. Lo studio dell'efficienza è l'oggetto della *complessità computazionale*, trattata nella parte algoritmica del corso.

- *Leggibilità*: il codice deve essere comprensibile da altri programmatori (e dal programmatore stesso a distanza di tempo). Nomi di variabili significativi, commenti appropriati e una struttura logica chiara contribuiscono alla leggibilità.

- *Manutenibilità*: il programma deve essere facilmente modificabile e aggiornabile. Un codice ben strutturato e modulare facilita la correzione di errori e l'aggiunta di nuove funzionalità.

#note[
  Questi obiettivi possono talvolta entrare in conflitto: ad esempio, un'ottimizzazione aggressiva per l'efficienza può rendere il codice meno leggibile. La buona pratica di programmazione consiste nel trovare il giusto equilibrio tra questi criteri.
]

=== Verso la formalizzazione

Per poter studiare i linguaggi di programmazione con rigore matematico, è necessario formalizzarne sia la sintassi sia la semantica. Nel seguito del corso affronteremo questi temi in modo sistematico:

+ *Linguaggi formali e grammatiche*: definiremo gli strumenti matematici (alfabeti, stringhe, grammatiche) per descrivere la sintassi di un linguaggio.

+ *Semantica operazionale*: formalizzeremo il significato dei programmi tramite regole di inferenza che descrivono come un programma modifica lo stato della macchina durante l'esecuzione.

+ *Sistemi di tipi*: studieremo come verificare staticamente (cioè prima dell'esecuzione) che un programma rispetti vincoli di coerenza sui tipi dei dati.

Tutti questi aspetti saranno illustrati sul linguaggio MAO, che verrà introdotto gradualmente: prima nella sua versione base (MiniMao, con sole espressioni e comandi semplici), poi nella versione completa (con array, funzioni e ricorsione).
