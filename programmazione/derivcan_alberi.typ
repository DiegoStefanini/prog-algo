#import "../template.typ": *

== Derivazioni canoniche

Abbiamo visto che, quando una forma sentenziale contiene più non terminali, si può scegliere quale espandere per primo. Le *derivazioni canoniche* eliminano questa libertà di scelta fissando una strategia deterministica.

=== Derivazione canonica sinistra

#definition(title: "Derivazione canonica sinistra (leftmost derivation)")[
  Una derivazione $beta_0 arrow.r beta_1 arrow.r dots.c arrow.r beta_n$ è *canonica sinistra* se, ad ogni passo $beta_i arrow.r beta_(i+1)$, il non terminale sostituito è sempre quello *più a sinistra* nella stringa $beta_i$.
]

=== Derivazione canonica destra

#definition(title: "Derivazione canonica destra (rightmost derivation)")[
  Una derivazione $beta_0 arrow.r beta_1 arrow.r dots.c arrow.r beta_n$ è *canonica destra* se, ad ogni passo $beta_i arrow.r beta_(i+1)$, il non terminale sostituito è sempre quello *più a destra* nella stringa $beta_i$.
]

#example(title: "Derivazioni canoniche a confronto")[
  Data la grammatica: \
  Esp $::=$ Num $|$ Esp $+$ Esp \
  Num $::=$ 0 $|$ 1 $|$ 2 $|$ ... $|$ 9

  Deriviamo la stringa $3 + 5 + 2$.

  *Derivazione canonica sinistra* (ad ogni passo si espande il non terminale più a sinistra):
  $
  & "Esp" \
  arrow.r quad & "Esp" + "Esp" \
  arrow.r quad & "Esp" + "Esp" + "Esp" \
  arrow.r quad & "Num" + "Esp" + "Esp" \
  arrow.r quad & 3 + "Esp" + "Esp" \
  arrow.r quad & 3 + "Num" + "Esp" \
  arrow.r quad & 3 + 5 + "Esp" \
  arrow.r quad & 3 + 5 + "Num" \
  arrow.r quad & 3 + 5 + 2
  $

  *Derivazione canonica destra* (ad ogni passo si espande il non terminale più a destra):
  $
  & "Esp" \
  arrow.r quad & "Esp" + "Esp" \
  arrow.r quad & "Esp" + "Num" \
  arrow.r quad & "Esp" + 2 \
  arrow.r quad & "Esp" + "Esp" + 2 \
  arrow.r quad & "Esp" + "Num" + 2 \
  arrow.r quad & "Esp" + 5 + 2 \
  arrow.r quad & "Num" + 5 + 2 \
  arrow.r quad & 3 + 5 + 2
  $
]

#note[
  Entrambe le derivazioni producono la stessa stringa $3 + 5 + 2$, ma con ordini di sostituzione diversi. La derivazione canonica sinistra e quella destra rappresentano due strategie sistematiche per enumerare le derivazioni.
]

== Alberi di derivazione

Derivazioni diverse (per esempio la canonica sinistra e la canonica destra) possono corrispondere alla stessa "struttura" della derivazione. L'*albero di derivazione* (o *parse tree*) cattura esattamente questa struttura, astraendo dall'ordine in cui le produzioni vengono applicate.

#definition(title: "Albero di derivazione (parse tree)")[
  Data una grammatica libera dal contesto $G = (T, N, P)$ e un non terminale $X in N$, un *albero di derivazione* per una stringa $w in L(X)$ è un albero ordinato con le seguenti proprietà:
  + La *radice* è etichettata con $X$.
  + Ogni *nodo interno* è etichettato con un non terminale $Y in N$.
  + Le *foglie* sono etichettate con simboli terminali $a in T$ oppure con $epsilon$.
  + Se un nodo interno è etichettato con $Y$ e i suoi figli (da sinistra a destra) sono etichettati con $X_1, X_2, ..., X_k$, allora $Y ::= X_1 X_2 dots.c X_k$ è una produzione di $P$.
  + La stringa ottenuta leggendo le foglie da sinistra a destra è $w$ (detta *frontiera* dell'albero).
]

#example(title: "Albero di derivazione per la stringa 3 + 5")[
  Con la grammatica Esp $::=$ Num $|$ Esp $+$ Esp e Num $::=$ 0 $|$ ... $|$ 9, l'albero per $3 + 5$ è:

  #align(center)[
    #block(inset: 10pt)[
      #set text(size: 10pt)
      ```
                Esp
               / | \
             Esp  +  Esp
              |       |
             Num     Num
              |       |
              3       5
      ```
    ]
  ]

  Lettura dell'albero:
  - La radice Esp si espande con la produzione Esp $::=$ Esp $+$ Esp.
  - Il figlio sinistro Esp si espande con Esp $::=$ Num, poi Num $::=$ 3.
  - Il figlio destro Esp si espande con Esp $::=$ Num, poi Num $::=$ 5.
  - La frontiera (foglie da sinistra a destra) è $3 + 5$.
]

#observation[
  Derivazioni canoniche diverse (sinistra e destra) possono produrre lo *stesso albero* di derivazione. L'albero cattura la *struttura* della derivazione, non l'*ordine* delle sostituzioni. In particolare, per una grammatica libera dal contesto, esiste una corrispondenza biunivoca tra alberi di derivazione e derivazioni canoniche sinistre (e analogamente con le derivazioni canoniche destre).
]

=== Valutazione basata sull'albero

Quando l'albero di derivazione rappresenta un'espressione, la sua struttura determina l'ordine di valutazione:
- Si valutano prima i *sottoalberi* (ricorsivamente, dalle foglie verso la radice).
- Poi si applica l'operatore del nodo corrente ai risultati dei sottoalberi.

#example(title: "Valutazione dell'espressione 3 + 5")[
  Dall'albero dell'esempio precedente:
  + Valuta il sottoalbero sinistro: Num $arrow.r$ 3, valore = 3.
  + Valuta il sottoalbero destro: Num $arrow.r$ 5, valore = 5.
  + Applica l'operatore $+$: $3 + 5 = 8$.
]

== Albero di sintassi astratta (AST)

L'*albero di derivazione* (parse tree) cattura fedelmente la struttura di una derivazione, ma in fase di *analisi semantica* — quando il programma viene effettivamente interpretato o compilato — molte delle sue informazioni risultano *ridondanti*. Ad esempio, i nodi intermedi che servono solo a imporre la precedenza degli operatori (`Term`, `Factor`, ...) non hanno alcun ruolo nel calcolare il valore dell'espressione: il loro contributo è già "incorporato" nella forma dell'albero. L'*albero di sintassi astratta* (Abstract Syntax Tree, AST) è una versione *condensata* del parse tree che mantiene solo l'informazione semanticamente rilevante.

#definition(title: "Albero di sintassi astratta (AST)")[
  Data una derivazione di una stringa $w$ in una grammatica $G$, l'*albero di sintassi astratta* è un albero ordinato i cui nodi sono etichettati con i *costruttori* del linguaggio (operatori, parole chiave, costanti, identificatori) e in cui:
  + i *nodi interni* rappresentano operatori o costrutti composti, con tanti figli quanti sono gli operandi (ad esempio, un nodo $+$ ha esattamente due figli: gli operandi sinistro e destro);
  + le *foglie* rappresentano valori atomici (numeri, identificatori, costanti);
  + i *non terminali ausiliari* introdotti per disambiguare la grammatica (come `Term`, `Factor`, ...) *non compaiono* come nodi.
]

#example(title: "Confronto parse tree e AST per 3 + 5 × 2")[
  Consideriamo la grammatica disambiguata vista in precedenza:

  Esp $::=$ Term $|$ Esp $+$ Term \
  Term $::=$ Factor $|$ Term $times$ Factor \
  Factor $::=$ Num $|$ $($ Esp $)$ \
  Num $::=$ 0 $|$ 1 $|$ ... $|$ 9

  *Parse tree* per la stringa $3 + 5 times 2$:

  #align(center)[
    #block(inset: 10pt)[
      #set text(size: 10pt)
      ```
                  Esp
                /  |  \
              Esp  +  Term
               |    /  |  \
              Term Term × Factor
               |    |       |
              Factor Factor Num
               |     |      |
              Num   Num     2
               |     |
               3     5
      ```
    ]
  ]

  *AST* per la stessa stringa: tutti i non terminali ausiliari (Esp, Term, Factor, Num) sono stati eliminati, lasciando solo gli operatori e i valori:

  #align(center)[
    #block(inset: 10pt)[
      #set text(size: 10pt)
      ```
                +
               / \
              3   ×
                 / \
                5   2
      ```
    ]
  ]

  Si noti che la *forma* dell'AST riflette ancora la precedenza degli operatori: la moltiplicazione è più in profondità dell'addizione, perché viene valutata per prima. Ma i nodi che servivano *solo a imporre questa precedenza* (Term, Factor, Num) sono spariti, sostituiti da una struttura che parla direttamente in termini di operazioni.
]

#observation[
  Il parse tree e l'AST contengono la *stessa informazione semantica*, ma con livelli di dettaglio diversi:

  - il *parse tree* è fedele alla grammatica concreta: ogni applicazione di una produzione corrisponde a un nodo. È utile durante il parsing.
  - l'*AST* è fedele al *significato*: ogni nodo è un costruttore semantico. È la rappresentazione su cui operano le fasi successive del compilatore o dell'interprete (analisi semantica, type checking, generazione di codice, valutazione).
]

#note(title: "AST nei compilatori reali")[
  Tutti i compilatori e gli interpreti moderni costruiscono un AST come prodotto della fase di parsing: il parser riceve una stringa di token e restituisce direttamente l'AST, saltando completamente la rappresentazione esplicita del parse tree. Sull'AST si effettuano poi il *type checking* (analisi statica), le *ottimizzazioni* e la *generazione di codice intermedio*. La semantica operazionale dei capitoli successivi (MiniMao, MAO) è di fatto definita per induzione sulla struttura dell'AST.
]

#example(title: "AST di un comando MiniMao")[
  Consideriamo il comando MiniMao
  ```
  if (x > 0) { y := x + 1; } else { y := 0; }
  ```
  Il suo AST ha la forma:

  #align(center)[
    #block(inset: 10pt)[
      #set text(size: 10pt)
      ```
                    if
                  /  |  \
                 >  ass  ass
                / \  /\   /\
               x  0 y  + y  0
                     /\
                    x  1
      ```
    ]
  ]

  dove `ass` denota l'operatore di assegnamento. Anche in questo caso, costrutti sintattici come le parentesi graffe e il punto e virgola — necessari nella grammatica concreta per delimitare i blocchi — sono assenti dall'AST: la struttura ad albero ne implica già il ruolo strutturale.
]

== Ambiguità

#definition(title: "Grammatica ambigua")[
  Una grammatica $G$ è *ambigua* se esiste almeno una stringa $w in L(G)$ che ammette *due o più alberi di derivazione distinti*. Equivalentemente, $G$ è ambigua se esiste una stringa che ammette due derivazioni canoniche sinistre distinte (o due derivazioni canoniche destre distinte).
]

L'ambiguità è un problema grave perché alberi di derivazione diversi possono assegnare *significati diversi* alla stessa stringa.

#example(title: [Ambiguità nella stringa $3 + 5 times 2$])[
  Consideriamo la grammatica: \
  Esp $::=$ Num $|$ Esp $+$ Esp $|$ Esp $times$ Esp \
  Num $::=$ 0 $|$ 1 $|$ ... $|$ 9

  La stringa $3 + 5 times 2$ ammette due alberi di derivazione distinti.

  *Albero 1* -- interpreta come $(3 + 5) times 2$:
  #align(center)[
    #block(inset: 10pt)[
      #set text(size: 10pt)
      ```
              Esp
             / | \
           Esp  ×  Esp
          / | \     |
        Esp + Esp  Num
         |     |    |
        Num   Num   2
         |     |
         3     5
      ```
    ]
  ]
  Valore: $(3 + 5) times 2 = 16$

  *Albero 2* -- interpreta come $3 + (5 times 2)$:
  #align(center)[
    #block(inset: 10pt)[
      #set text(size: 10pt)
      ```
              Esp
             / | \
           Esp  +  Esp
            |     / | \
           Num  Esp × Esp
            |    |     |
            3   Num   Num
                 |     |
                 5     2
      ```
    ]
  ]
  Valore: $3 + (5 times 2) = 13$

  La stessa stringa ha due valutazioni diverse: 16 oppure 13, a seconda dell'albero scelto. Per un linguaggio di programmazione, questa situazione è inaccettabile.
]

== Risoluzione dell'ambiguità

Per eliminare l'ambiguità da una grammatica si possono adottare diverse strategie.

=== Introduzione di livelli di precedenza

Si ristruttura la grammatica introducendo non terminali aggiuntivi che codificano la *precedenza* e l'*associatività* degli operatori. L'idea è che gli operatori a precedenza più alta vengano "catturati" più in profondità nell'albero.

#example(title: "Grammatica non ambigua con precedenza")[
  Esp $::=$ Term $|$ Esp $+$ Term \
  Term $::=$ Factor $|$ Term $times$ Factor \
  Factor $::=$ Num $|$ $($ Esp $)$ \
  Num $::=$ 0 $|$ 1 $|$ ... $|$ 9

  In questa grammatica:
  - *Esp* gestisce l'addizione: un'espressione è un termine, oppure un'espressione seguita da $+$ e un termine. L'addizione è *associativa a sinistra*.
  - *Term* gestisce la moltiplicazione: un termine è un fattore, oppure un termine seguito da $times$ e un fattore. La moltiplicazione è *associativa a sinistra* e ha *precedenza maggiore* rispetto all'addizione.
  - *Factor* gestisce le "unità atomiche": un numero oppure un'espressione racchiusa tra parentesi.

  Con questa grammatica, la stringa $3 + 5 times 2$ ha un *unico* albero di derivazione, che corrisponde all'interpretazione $3 + (5 times 2) = 13$, rispettando la precedenza usuale della moltiplicazione sull'addizione.
]

=== Uso delle parentesi

Un altro metodo per risolvere l'ambiguità consiste nell'introdurre le *parentesi* nella grammatica per forzare esplicitamente l'ordine di valutazione.

#example(title: "Grammatica con parentesi obbligatorie")[
  Esp $::=$ Num $|$ $($ Esp Op Esp $)$ \
  Op $::=$ $+$ $|$ $times$ \
  Num $::=$ 0 $|$ 1 $|$ ... $|$ 9

  Con questa grammatica, ogni operazione binaria deve essere racchiusa tra parentesi, quindi non c'è ambiguità: $((3 + 5) times 2)$ e $(3 + (5 times 2))$ sono stringhe diverse.
]

#note(title: "Linguaggi inerentemente ambigui")[
  Non sempre è possibile eliminare l'ambiguità modificando la grammatica. Esistono *linguaggi inerentemente ambigui*: linguaggi per i quali *ogni* grammatica che li genera è ambigua. Un esempio classico è il linguaggio $L = {a^n b^n c^m d^m | n, m >= 1} union {a^n b^m c^m d^n | n, m >= 1}$. Tuttavia, per i linguaggi di programmazione questo problema tipicamente non si pone.
]
