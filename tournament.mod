# ------------------------------
# Progetto di Ricerca Operativa
# di Giada Sabini
# ------------------------------

# Volleyball Tournament Organization

# ------------------------------

## PARAMETRI ##

param num_teams > 0; 				#numero PARI di squadre 


## INSIEMI ##

set Teams;							#insieme delle squadre
set Days := {1..num_teams-1};		#numero di giorni necessari per completare il torneo 


## PARAMETRI ##

param interest{Teams,Teams}>=0;		#interesse di ogni match 


## VARIABILI ##
var x{Teams,Teams,Days} binary;		#variabile binaria realtiva (i,j,g):
									#1 se il match viene effettuato in una tal giornata g
									#0 altrimenti



## VINCOLI ##

#vincolo per evitare che una squadra sfidi se stessa 
subject to no_self_matching{i in Teams, g in Days, j in Teams: j=i}: x[i,j,g] = 0;

#vincolo per evitare che una squadra sfidi due volte lo stesso avversario 
subject to no_same_matching{i in Teams, j in Teams: j!=i}: 
					sum{g in Days} (x[i,j,g] + x[j,i,g]) = 1;

#vincolo sul numero di match disponibili in una giornata 
subject to number_of_match_in_a_day{g in Days}: 
									sum{i in Teams}
										sum{j in Teams}
											x[i,j,g] = (num_teams/2);		
				
#vincolo affinchè una squadra abbia solo un avversario in ogni giornata 
subject to only_one_match_in_a_day{i in Teams, g in Days}: 
					sum{j in Teams} (x[i,j,g] + x[j,i,g]) = 1;	

													
#vincolo affinchè in ogni giornata ci sia almeno una partita di massimo interesse:
#(almeno un nodo in una giornata ha un arco uscente/entrante con valore 3) 	
subject to at_least_one{g in Days}:
					sum{i in Teams, j in Teams: interest[i,j] == 3} (x[i,j,g]) >= 1 ;	
		




## OBIETTIVO ##

#il minimo livello medio di interesse tra tutte le giornate sia massimizzato

var M;
subject to Min_lev{g in Days}: M <= (sum{i in Teams}
									sum{j in Teams}
										x[i,j,g] * interest[i,j]) / (num_teams/2);

maximize Min_level: M;



