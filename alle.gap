# alle.gap
# Sara Fish, 2016

# Sei k eine natuerliche Zahl. In diesem Programm wird die Anzahl von 'wesentlich verschiedenen' k-elementigen Teilmengen eines SET-Blattes bestimmt. Konkret wird die Anzahl von Bahnen von der Gruppe G = AGL(4,3) (die Gruppe von Symmetrien) auf Omega_k = P_k((F_3)^4) (alle k-elementigen Mengen von Karten) berechnet.

# Die Listen listTypen, listAnzahlen und masterList sind in alle-daten.gap (auf https://github.com/the-set-of-sets/SET-BLL erhaeltlich). 

####################
# 0. METHODE #######
####################
# 0. Methode
# 1. Initialisierung
# 2. Berechnung aller moeglichen Zykeltypen (von Gruppenelementen aus G auf Omega_k)
# 3. Fuer jeden Zykeltyp wird ausgerechnet, die viele Elemente aus Omega_k (k-elementige Mengen von Karten) von einem Gruppenelement mit diesem Zykeltyp fixiert werden. 
# 4. Anwendung des Burnside-Lemmas, um schliesslich die Anzahl von Bahnen von G auf Omega_k zu berechnen.

##############################
# 1. INITIALISIERUNG #########
##############################

# 1.1 Grundlegenes

n := 4;
F := GF(3);
V := F^n;
G := GL(n,3);
S_n := SymmetricGroup(n);

# Die 81 (oder meinetwegen auch Size(F)^n=|V| ) Vektoren induzieren jeweils eine Permutation auf V. Vp ist eine Liste von 81 Permutationen auf [1..81], die jeweils Translationen des iten Vektors bewirken.
Vp := [];
vektorenliste := List(V);
for i in [1..Size(V)] do
	Add(Vp,PermList(List(vektorenliste,x->Position(vektorenliste,x+vektorenliste[i]))));
od;

# 1.2 Die fuer die Bruhat-Zerlegung notwendigen Untergruppen von G in GAP erstellen: U, W, T, Uteil.

# Bemerkung: Uteil wird in der Facharbeit als U_p bezeichnet. 
# WICHTIG: U, W, T und Uteil sind Untergruppen von G. Up, Wp, Tp und Uteilp sind Untergruppen von S_81. Fuer die Berechnung werden Up, Wp, Tp und Uteilp verwendet, weil der Umgang mit Permutationen in GAP in diesem Fall wesentlich effizienter ist als der mit Matrizen.

# 1.2.1 U, W, T

U := Group([
[ [ Z(3)^0, Z(3)^0, 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ],
[ [ Z(3)^0, 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ],
[ [ Z(3)^0, 0*Z(3), 0*Z(3), Z(3)^0 ], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ],
[ [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0, Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ],
[ [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0, 0*Z(3), Z(3)^0 ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ],
[ [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, Z(3)^0 ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ],
]);#obere Dreiecksmatrizen (mit Einsen auf der Diagonale), |U|=3^6=729
Up := Group(List(U,u -> Permutation(u,V) ));

W := Group(List(S_n,x->PermutationMat(x,n,F)));#Permutationsmatrizen, |W|=4!=24
Wp := Group(List(W,w -> Permutation(w,V) ));

T := Group([ 
[ [ Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ], 
[ [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ], 
[ [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ] ], 
[ [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3) ], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3) ] ] 
]);#Diagonalmatrizen, |T|=2^4=16
Tp := Group(List(T,t -> Permutation(t,V) ));

# 1.2.2 Uteil

# Die Erstellung von Uteil ist eigentlich nicht kompliziert. Alle Berechnungen wurden schon per Hand gemacht (siehe Anhang, "U_p Untergruppen (Bruhat Zerlegung)"). Die Funktion findUteil gibt fuer eine Permutationsmatrix p aus die entsprechende Matrix Uteil. (siehe Tabelle im Anhang)

findUteil := function(w)
	local temp, p, nullPunkte, umwandeln, ergebnis,i;
	if not n=4 then return -1; fi;

	#w wird von der Matrixschreibweise in die Permutationsschreiweise umgewandelt
	for i in S_n do 
		temp := PermutationMat(i,n,F);
		if temp=w then
			break;
		fi;
	od;
	p := i;#p ist die Permutation in S_4, die zu w gehoert.
 
	#Alle Uteil Matrizen sind obere Dreiecksmatrizen mit Einsen auf der Diagonale. Die sechs Eintraege oberhalb der Diagonale haben entweder den Wert * (koennen beliebig sein) oder 0. Im folgenden werden die Informationen aus der Tabelle im Anhang uebertragen. nullPunkte gibt fuer jede der 24 Permutationen p an, welche der sechs Eintraege den Wert 0 annehmen. Daraus wird dann die Untergruppe Uteil erstellt.
	nullPunkte := []; ## Nach dem Muster
#                       1 2 3
#                         4 5
#                           6
	if p=(1,4)(2,3) then nullPunkte := []; fi;
	if p=(1,3,2,4) then nullPunkte := [6]; fi;
	if p=(1,4) then nullPunkte := [4]; fi;
	if p=(1,3,4) then nullPunkte := [5,6]; fi;
	if p=(1,2,4) then nullPunkte := [4,5]; fi;
	if p=(1,2,3,4) then nullPunkte := [4,5,6]; fi;
	if p=(1,4,2,3) then nullPunkte := [1]; fi;
	if p=(1,3)(2,4) then nullPunkte := [1,6]; fi;
	if p=(1,4,3) then nullPunkte := [2,4]; fi;
	if p=(1,3) then nullPunkte := [3,5,6]; fi;
	if p=(1,2,4,3) then nullPunkte := [2,4,5]; fi;
	if p=(1,2,3) then nullPunkte := [3,4,5,6]; fi;
	if p=(1,4,2) then nullPunkte := [1,2]; fi;
	if p=(1,3,4,2) then nullPunkte := [1,3,6]; fi;
	if p=(1,4,3,2) then nullPunkte := [1,2,4]; fi;
	if p=(1,3,2) then nullPunkte := [1,3,5,6]; fi;
	if p=(1,2)(3,4) then nullPunkte := [2,3,4,5]; fi;
	if p=(1,2) then nullPunkte := [2,3,4,5,6]; fi;
	if p=(2,4) then nullPunkte := [1,2,3]; fi;
	if p=(2,3,4) then nullPunkte := [1,2,3,6]; fi;
	if p=(2,4,3) then nullPunkte := [1,2,3,4]; fi;
	if p=(2,3) then nullPunkte := [1,2,3,5,6]; fi;
	if p=(3,4) then nullPunkte := [1,2,3,4,5]; fi;
	if p=() then nullPunkte := [1,2,3,4,5,6]; fi;
	#Damit ist Uteil eine obere Dreiecksmatrix mit 1 auf der Diagonale und 0en genau an den in nullPunkte angegebenen Stellen.

	#Die Zahlen 1 bis 6 geben Positionen in der Matrix an nach dem Muster
#                       1 2 3
#                         4 5
#                           6
	#Die Funktion umwandeln wandelt diese Positionsangaben in Koordinaten um (Reihe + Spalte in der Matrix). 
	#Damit gilt z.B. List([1,2],umwandeln) = [ [1,2], [1,3] ]
	umwandeln := function(num)
		ergebnis := [];
		if num=1 then ergebnis := [1,2]; fi;
		if num=2 then ergebnis := [1,3]; fi;
		if num=3 then ergebnis := [1,4]; fi;
		if num=4 then ergebnis := [2,3]; fi;
		if num=5 then ergebnis := [2,4]; fi;
		if num=6 then ergebnis := [3,4]; fi;
		return ergebnis;
	end;
	#Nun wird die Gruppe U "filtriert". Nur die Matrizen, die an der richtigen Stelle den Eintrag 0 haben, bleiben uebrig. Damit kann Uteil erstellt werden. 
	return Group(Filtered(U,u -> ForAll(List(nullPunkte,umwandeln), ding -> IsZero(u[ding[1]][ding[2]]) ) ));
end;

##############################
# 2. BERECHNUNG DER ZYKELTYPEN
##############################
#Der Kern des Programms. Zu jedem g in AGL(4,3) existiert eine eindeutige Bruhat-Zerlegung g = u*t*p*v*trans, wobei u in U, t in T, p in W, v in U_p und trans eine Translation um einen konstanten Vektor in V bezeichnet. Es wird ueber die Gruppen U, T, W, U_p und Vp (Translationen) iteriert und jedes mal ein g ausgerechnet, dessen Zykltyp (CycleStructurePerm) ausgerechnet wird. Alle Zykltypen (wir werden feststellen, dass es 55 sind) werden in listTypen gespeichert und die Haeufigkeiten der 55 Zykltypen werden mitgezaehlt (listAnzahlen). 

count := 0;
listTypen := []; #an der iten Stelle steht ein Zykeltyp (Ausgabe von CycleStructurePerm)
length := Length(listTypen);
listAnzahlen := []; #an der iten Stelle steht die Anzahl von bisher gesehenen bahntypen listTypen[i].

for w in W do#|W|=24
	wp := Permutation(w,V);
	Uteilp := Group(List(findUteil(w),uteil -> Permutation(uteil,V) ));#Uteilp ist jetzt Operation auf V
	for v in Uteilp do#|Uteilp| liegt zweischen 1 und 729, meistens ca 81
		h1 := wp * v;
		for t in Tp do#|Tp| = 16
			h2 := t*h1;
			for u in Up do#|Up|=729
				h3 := u*h2;
				for translation in Vp do#|Vp| = 81
					g := h3*translation;#Nun g = u*t*wp*v*translation. Die Multiplikation wird zur Verbesserung der Laufzeit so mit den Hilfsvariablen h1, h2 und h3 aufgeteilt. 
					struct := CycleStructurePerm(g);
					stelle := Position(listTypen,struct);
					if stelle=fail then
						Add(listTypen,struct);
						length := length + 1;
						listAnzahlen[length] := 1;
					else
						listAnzahlen[stelle] := listAnzahlen[stelle] + 1;
					fi;
				od;
			od;
		od;
	od;
od;

# Jetzt haben wir listTypen und listAnzahlen.

#######################################
# 3. FIXPUNKTE VON ZYKELTYPEN BERECHNEN
#######################################
#Fuer alle k und fuer jede der 55 Zykeltypen wird berechnet, wie viele k-elementige Teilmengen von Omega von einem Gruppenelement mit dem bestimmten Zykeltyp fixiert werden. Die Herangehensweise wird in dem Beweis von Lemma 6 beschrieben.


#Eingabe: struct (Ausgabe von CycleStructurePerm), numPoints (hier |Omega| = 81)
#Ausgabe: struct (um einen Index verschoben, damit die Fixpunkte (1-Zyklen) mitgezaehlt werden)
#z.B. changeStruct([2,1],81) = [74,2,1].
changeStruct := function(struct,numPoints)
	local l,sum,i;
	l := [];
	sum := 0;
	for i in [1..Length(struct)] do
		if IsBound(struct[i]) then
			l[i+1] := struct[i];
			sum := sum + (i+1)*struct[i];
		fi;
	od;
	l[1] := numPoints - sum;
	return l;
end;

#Eingabe: k, cstruct (CycleStructurePerm changed mit changeStruct)
#Ausgabe: Liste von Listen, die die Form cstruct haben.
#z.B. g hat den Zykeltyp (1^27, 9^3, 27^1). Falls k=28, sind die Moeglichkeiten [ [[1,1],[27,1]], [[1,1],[9,3]], [[1,10],[9,2]], [[1,19],[9,1]] ]. 
partition := function(k,cstruct)
	local possible, pos, things, thing;
	possible := [];
	if k=0 then
		return [[]];
	fi;
	for pos in [1..k] do
		if IsBound(cstruct[pos]) then
			if cstruct[pos]>0 then
				cstruct[pos] := cstruct[pos]-1;
				things := partition(k-pos,cstruct);
				cstruct[pos] := cstruct[pos]+1;
				for thing in things do
					if IsBound(thing[pos]) then
						thing[pos] := thing[pos] + 1;
					else
						thing[pos] := 1;
					fi;
				od;
				for thing in things do
					if not thing in possible then
						Add(possible, thing);
					fi;
				od;
			fi;
		fi;
	od;
	return possible;
end;

#Gegeben ist ein k in [0..81] (bzw. ..41 reicht) und ein g (genauer zu sein, einer der 55 Zykltypen, die ausgerechnet wurden und schon in listTypen stehen). Es wird mithilfe von partition() die Anzahl von k-Elementigen Teilmengen berechnet, die unter g festbleiben. 
#Eingabe: k (Groesse der Teilmenge), gstruct (output von CycleStructurePerm)
#Ausgabe: Anzahl der k-Elementigen Teilmengen, die von g fixiert werden.
anzahlFixTeil := function(k,gstruct)
	local cstruct, parts, sum,part,pos,prod;
	cstruct := changeStruct(gstruct,Size(V));
	parts := partition(k,cstruct);
	sum := 0;
	for part in parts do
		prod := 1;
		for pos in [1..Length(part)] do
			if IsBound(part[pos]) then
				prod := prod* Binomial(cstruct[pos],part[pos]);
			fi;
		od;
		sum := sum + prod;
	od;
	return sum;
end;

k_MIN := 1;
k_MAX := 41;

#Eingabe: Nichts (von k_MIN, k_MAX abhaengig)
#Ausgabe: masterList. An stelle k ist eine Liste mit 55 Eintraegen, die die Anzahl von k-elementigen Teilmengen angeben, die unter dem bestimmten Zykltyp (siehe typenList) festbleiben. 
#Anmerkung: Mein Laptop braucht ca. 8 Stunden hierfuer. 
computeAll := function()
	local masterList,k,gstruct;
	masterList := [];#an k-ter Stelle ist eine Liste mit 55 Elementen, die Anzahl fuer jedes Zykltyp (Reihenfolge gegeben durch die Reihenfolge in basis.gap
	for k in [k_MIN..k_MAX] do
		masterList[k] := [];
		for gstruct in typenList do
			Add(masterList[k],anzahlFixTeil(k,gstruct));
		od;
	od;
	return masterList;
end;

masterList := computeAll();

################################################################
# 4. ANZAHL DER BAHNEN BERECHNEN (ANWENDUNG DES BURNSIDE-LEMMAS)
################################################################
# Nun koennen wir listTypen, listAnzahlen und masterList verwenden und direkt in die Formel fuer das Burnside-Lemma eingeben. Die Liste BAHNEN_ALLE gibt an k-ter Stelle an, wie viele verschiedene Bahnen von G auf Omega_k existieren. 

anzahlBahnen := function(k)
	local anzahl, pos;
	if k<0 or k>Length(masterList) then return -1; fi;
	anzahl := 0;
	for pos in [1..Length(listTypen)] do
		anzahl := anzahl + listAnzahlen[pos]*masterList[k][pos];
	od;
	return anzahl/(Size(G)*Size(V));
end;

BAHNEN_ALLE := List([1..40],anzahlBahnen);

# Ausgabe war [ 1, 1, 2, 3, 6, 15, 34, 105, 384, 1658, 8135, 41407, 205211, 963708, 4231059, 17295730, 65807588, 233346408, 772518828, 2392611091, 6946116261, 18937468347, 48568206996, 117356752981, 267548687984, 576222904363, 1173737365919, 2263568972663, 4136780036942, 7170309576688, 11796184561289, 18431386920534, 27367649303603, 38636503940897, 51883126670392, 66294936428615, 80628826002618, 93359571424793, 102934827016066, 108081525023972 ]. 
