# Come contribuire

Grazie per voler contribuire a questa raccolta di appunti! Ecco come fare.

## Prerequisiti

- Un account [GitHub](https://github.com)
- [Typst](https://typst.app/) installato localmente (per compilare e verificare le modifiche)
- Conoscenza base di Git

## Workflow per contribuire

### 1. Fork della repository

Clicca il pulsante **Fork** in alto a destra nella pagina GitHub del progetto.

### 2. Clona il tuo fork

```bash
git clone https://github.com/TUO-USERNAME/prog-algo.git
cd prog-algo
```

### 3. Crea un branch

```bash
git checkout -b fix/nome-della-modifica
```

Usa prefissi descrittivi per i branch:
- `fix/` per correzioni (es. `fix/errore-quicksort`)
- `feat/` per nuovi contenuti (es. `feat/lezione-heap`)
- `docs/` per modifiche alla documentazione

### 4. Fai le tue modifiche

Modifica i file `.typ` seguendo le linee guida di stile descritte sotto.

### 5. Compila e verifica

```bash
typst compile main.typ main.pdf
```

Controlla che il PDF generato sia corretto prima di aprire la PR.

### 6. Commit e push

```bash
git add file-modificati.typ
git commit -m "Descrizione breve della modifica"
git push origin fix/nome-della-modifica
```

### 7. Apri una Pull Request

Vai sulla pagina GitHub della repo originale e clicca **New Pull Request**. Seleziona il tuo branch e descrivi le modifiche fatte.

## Linee guida di stile per Typst

### Ambienti disponibili

Ogni corso ha un template con ambienti predefiniti. Usali in modo consistente:

- `definizione` — Per definizioni formali
- `teorema` / `proposizione` / `lemma` / `corollario` — Per enunciati
- `dimostrazione` — Per dimostrazioni
- `esempio` — Per esempi pratici
- `osservazione` / `nota` — Per osservazioni e note
- `attenzione` / `ricorda` — Per avvertimenti e promemoria

### Convenzioni generali

- Usa la numerazione gerarchica: Capitolo.Sezione.Numero
- Progressione dal semplice al complesso
- Mantieni rigore matematico ma con esposizione chiara
- Aggiungi esempi dopo ogni definizione o teorema quando possibile

### Formule matematiche

- Usa `$...$` per formule inline
- Usa `$ ... $` (con spazi) per formule in display
- Mantieni una notazione consistente con il resto del documento

## Cosa contribuire

- Correzioni di errori di battitura o matematici
- Nuove lezioni seguendo la struttura esistente
- Esercizi svolti
- Diagrammi e figure esplicative
- Miglioramenti alla chiarezza del testo

## Cosa evitare

- Non modificare i file `template.typ` senza discuterne prima in una Issue
- Non aggiungere materiale coperto da copyright (slide del professore, libri scansionati)

## Segnalare problemi

Se trovi un errore ma non sai come correggerlo, apri una [Issue](../../issues) descrivendo:
- In quale lezione si trova l'errore
- Cosa c'e di sbagliato
- Eventualmente, la correzione suggerita
