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
