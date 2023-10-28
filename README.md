# Progetto Reti Logiche

## Descrizione Generale 
Il progetto  richiede l'implementazione di un modulo hardware (descritto in VHDL) che si interfaccia con una memoria e rispetta le seguenti specifiche:

A un alto livello di astrazione, il sistema riceve informazioni su una locazione di memoria, il cui contenuto deve essere indirizzato verso uno dei quattro canali di uscita disponibili. Le informazioni sul canale da utilizzare e l'indirizzo di memoria al quale accedere vengono fornite tramite un ingresso seriale a un bit, mentre le uscite del sistema forniscono tutti i bit della parola di memoria in parallelo.

## Interfacce

Il modulo da implementare ha due ingressi principali da 1 bit (W e START) e 5 uscite principali. Le uscite sono le seguenti: quattro da 8 bit (Z0, Z1, Z2, Z3) e una da 1 bit (DONE). Inoltre, il modulo ha un segnale di clock (CLK), unico per tutto il sistema, e un segnale di reset (RESET) anch'esso unico.

## Funzionamento

All'istante iniziale, relativo al reset del sistema, le uscite hanno valori predefiniti. I dati in ingresso vengono organizzati come sequenze sull'ingresso seriale W. Questi dati contengono due bit di intestazione seguiti da N bit di indirizzo della memoria. Gli N bit di indirizzo permettono di costruire un indirizzo di memoria.

Gli N bit di indirizzo possono variare da 0 fino a un massimo di 16 bit. Gli indirizzi di memoria sono tutti di 16 bit. Se il numero di bit N è inferiore a 16, l'indirizzo viene esteso con zeri sui bit più significativi.

Le sequenze di ingresso sono valide quando il segnale START è alto (=1) e terminano quando il segnale START è basso (=0). Il segnale START rimane alto per un numero specifico di cicli di clock.

Le uscite Z0, Z1, Z2, e Z3 sono inizialmente a zero. I valori rimangono invariati tranne il canale sul quale viene mandato il messaggio letto in memoria; i valori sono visibili solo quando il valore di DONE è 1.

Il modulo deve essere progettato per garantire che il tempo massimo per produrre il risultato sia inferiore a 20 cicli di clock.

## Appendice

Il file [Specifica progetto di reti logica AA 2022-2023.pdf](Specifica progetto di reti logica AA 2022-2023.pdf) contiene la specifica completa del progetto, mentre [10583319.pdf](10583319.pdf) è un file scritto in LaTEX che descrive in maniera dettagliata il processo logico e decisionale che mi ha portato alla progettazione del modulo.

### Strumenti Utilizzati

Linguaggio: VHDL <br>
Ambiente : Vivado <br>
Altro : LaTEX <br>

