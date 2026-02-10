#import "../template.typ": *

== Derivazioni e Linguaggi Generati

Il meccanismo fondamentale delle grammatiche formali è la *derivazione*: si parte da un non terminale e, applicando ripetutamente le produzioni, si ottengono stringhe di terminali. In questa sezione formalizziamo questo processo.

=== Derivazione immediata

#definition(title: "Derivazione immediata")[
  Data una grammatica $G = (T, N, P)$ con $S = T union N$, e date due stringhe $beta, beta' in S^*$, si dice che $beta'$ è un *derivato immediato* di $beta$, e si scrive:
  $ beta arrow.r beta' $
  se e solo se esistono stringhe $beta_1, beta_2 in S^*$, un non terminale $X in N$ e una produzione $X ::= alpha in P$ tali che:
  $ beta = beta_1 X beta_2 quad "e" quad beta' = beta_1 alpha beta_2 $
  In altre parole, $beta'$ si ottiene da $beta$ sostituendo un'occorrenza del non terminale $X$ con la parte destra $alpha$ di una sua produzione, lasciando invariato il contesto $beta_1$ e $beta_2$.
]

#example(title: "Derivazione immediata")[
  Data la grammatica con le produzioni: \
  Esp $::=$ Num $|$ Esp Op Esp \
  Op $::=$ $+$ $|$ $times$ \
  Num $::=$ 0 $|$ 1 $|$ ... $|$ 9

  Partiamo dalla stringa $beta =$ Esp $+$ Esp Op 2. Applicando la produzione Esp $::=$ Num all'occorrenza più a sinistra di Esp, otteniamo:
  $ "Esp" + "Esp Op" 2 arrow.r "Num" + "Esp Op" 2 $
  Qui $beta_1 = epsilon$, $X =$ Esp, $alpha =$ Num, $beta_2 = + "Esp Op" 2$.
]

#note[
  Se una stringa contiene più non terminali, ad ogni passo possiamo scegliere *quale* non terminale espandere e *quale* produzione applicare. Questa libertà di scelta porta, in generale, a derivazioni diverse per la stessa stringa.
]

=== Derivazione (in zero o più passi)

#definition(title: "Derivazione")[
  Data una grammatica $G = (T, N, P)$, e date due stringhe $beta, beta' in S^*$, si dice che $beta'$ è un *derivato* di $beta$, e si scrive:
  $ beta arrow.r^* beta' $
  se e solo se esiste una sequenza finita (eventualmente vuota) di derivazioni immediate:
  $ beta = beta_0 arrow.r beta_1 arrow.r beta_2 arrow.r dots.c arrow.r beta_n = beta' quad (n >= 0) $
  Il numero $n$ è detto *lunghezza della derivazione*.

  - Se $n = 0$, allora $beta = beta'$ (ogni stringa deriva da se stessa: *riflessività*).
  - Se $beta arrow.r^* gamma$ e $gamma arrow.r^* beta'$, allora $beta arrow.r^* beta'$ (*transitività*).
]

#example(title: "Derivazione passo per passo")[
  Con la grammatica delle espressioni, deriviamo la stringa $3 + 5$:
  $
  & "Esp" \
  arrow.r quad & "Esp Op Esp" \
  arrow.r quad & "Num Op Esp" \
  arrow.r quad & 3 "Op Esp" \
  arrow.r quad & 3 + "Esp" \
  arrow.r quad & 3 + "Num" \
  arrow.r quad & 3 + 5
  $
  Poiché $"Esp" arrow.r^* 3 + 5$ e $3 + 5 in T^*$, la stringa $3 + 5$ appartiene al linguaggio generato da Esp.
]

== Linguaggio generato da un non terminale

#definition(title: "Linguaggio generato")[
  Data una grammatica $G = (T, N, P)$ e un non terminale $X in N$, il *linguaggio generato* da $X$, scritto $L(X)$, è l'insieme di tutte e sole le stringhe di terminali derivabili da $X$:
  $ L(X) = {w in T^* | X arrow.r^* w} $
  Quando la grammatica ha un simbolo iniziale $S_0$, il *linguaggio generato dalla grammatica* è $L(G) = L(S_0)$.
]

#note[
  Si noti che $L(X) subset.eq T^*$: il linguaggio contiene solo stringhe composte esclusivamente da simboli terminali. Le stringhe intermedie che contengono ancora non terminali (dette *forme sentenziali*) non fanno parte del linguaggio.
]

=== Appartenenza al linguaggio

Data una grammatica $G = (T, N, P)$ e una stringa $w in T^*$, per stabilire se $w in L(X)$ si ragiona nel modo seguente:
- $w in L(X)$ se e solo se partendo dal simbolo $X$ è possibile, applicando una o più produzioni, ottenere la stringa $w$ composta da soli terminali.
- $w in.not L(X)$ se e solo se *qualunque* sequenza di applicazioni di produzioni a partire da $X$ non è in grado di generare $w$.

#observation[
  Dimostrare che $w in L(X)$ è relativamente semplice: basta esibire una derivazione $X arrow.r^* w$. Dimostrare che $w in.not L(X)$ è più difficile, perché richiede di escludere *tutte* le possibili derivazioni.
]

=== Esempio completo: numeri naturali senza zeri iniziali

#example(title: "Grammatica per numeri naturali senza zeri iniziali")[
  Consideriamo la grammatica dell'esempio precedente per le espressioni aritmetiche. La produzione Num $::=$ Cifra $|$ Num Cifra permette di generare stringhe come $007$, che non è una rappresentazione canonica di un numero naturale.

  Per ottenere una grammatica che non generi zeri iniziali, modifichiamo le produzioni:

  NonZero $::=$ 1 $|$ 2 $|$ 3 $|$ ... $|$ 9 \
  Cifra $::=$ 0 $|$ NonZero \
  Pos $::=$ NonZero $|$ Pos Cifra \
  Num $::=$ 0 $|$ Pos

  In questa grammatica:
  - *NonZero* genera una cifra diversa da zero.
  - *Cifra* genera una cifra qualsiasi (0--9).
  - *Pos* genera un numero positivo: la prima cifra è necessariamente diversa da zero (NonZero), mentre le cifre successive possono essere qualsiasi (Cifra).
  - *Num* genera lo zero oppure un numero positivo.

  Verifichiamo: $L("Num")$ contiene $0$, $5$, $42$, $100$, ma *non* contiene $007$ né $00$.
]
