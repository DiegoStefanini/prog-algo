# Programmazione ed Algoritmica - Universita di Pisa

Dispense e appunti per il corso di Programmazione ed Algoritmica del corso di laurea in Informatica presso l'Universita di Pisa.

## Contenuti

Appunti completi con algoritmi, grammatiche, semantica operazionale e type checking.

## Struttura del progetto

```
dispense/
├── algoritmica/         # Appunti di algoritmica
├── programmazione/      # Appunti di programmazione
├── images/              # Immagini utilizzate
├── temp/                # File temporanei
├── main.typ             # File principale
├── template.typ         # Template Typst
└── main.pdf             # PDF compilato
```

## Tecnologie usate

Le dispense sono scritte in [Typst](https://typst.app/), un linguaggio di markup moderno per la composizione di documenti.

### Compilare le dispense

Per compilare il documento Typst in PDF:

```bash
typst compile main.typ main.pdf
```

Oppure per la compilazione automatica ad ogni modifica:

```bash
typst watch main.typ main.pdf
```

### Installare Typst

- **Con cargo**: `cargo install --git https://github.com/typst/typst --locked typst-cli`
- **Homebrew (macOS)**: `brew install typst`
- **Pacman (Arch)**: `pacman -S typst`
- **Online**: [typst.app](https://typst.app/)

## Contribuire

Le contribuzioni sono benvenute! Puoi contribuire in diversi modi:

- Correggere errori nelle dispense esistenti
- Aggiungere nuove lezioni o appunti
- Migliorare la formattazione o la chiarezza del testo
- Aggiungere esercizi svolti

Leggi [CONTRIBUTING.md](CONTRIBUTING.md) per le linee guida su come contribuire.

## Licenza

Questi appunti sono condivisi liberamente a scopo didattico. Se utilizzi questo materiale, una menzione e apprezzata.
