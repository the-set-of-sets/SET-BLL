# null-eine.gap
# Sara Fish, 2016

# Sei k eine natuerliche Zahl. In diesem Programm wird die Anzahl von 'wesentlich verschiedenen' k-elementigen Teilmengen mit
#	- keinen SETs
#	- GENAU einem SET
# bestimmt. Dazu werden Repraesentantensysteme von den Bahnen von der AGL auf diesem Mengen. 

####################
# 0. METHODE #######
####################
# 0. Methode
# 1. Initialisierung
# 2. Funktion isMinimal definieren
# 3. Repraesentanten zaehlen

####################
# 1. INITIALISIERUNG
####################

gens := [];#gens[k] ist eine Liste von Erzeuger von AGL(k,3). Die ersten zwei Eintraege sind Erzeuger von der GL(k,3) (und wurden mit dem GAP-Befehl GeneratorsOfGroup(GL(2,3)) gefunden) und der letzter Eintrag ist eine Translation (fuer den affinen Teil.) 
tgens := [];#tgens[k] ist eine Liste von den k Translationen aus der AGL(k,3), die jeweils Addition mit einem Basisvektor bewirken. z.B. tgens[2] hat zwei Translationen: +(1,0) und +(0,1). 

gens[2] := [
[ [ Z(3), 0*Z(3) , 0*Z(3)],[ 0*Z(3), Z(3)^0,0*Z(3) ],[0*Z(3), 0*Z(3), Z(3)^0]],
[ [ Z(3), Z(3)^0 ,0*Z(3)], [ Z(3), 0*Z(3),0*Z(3) ] ,[0*Z(3),0*Z(3),Z(3)^0]],
[ [Z(3)^0,0*Z(3),0*Z(3)], [0*Z(3),Z(3)^0,0*Z(3)],[Z(3)^0,0*Z(3),Z(3)^0]]
];#GeneratorsOfGroup(GL(2,3)); for first two, 3rd is translator
tgens[2] := [
[ [Z(3)^0,0*Z(3),0*Z(3)], [0*Z(3),Z(3)^0,0*Z(3)],[Z(3)^0,0*Z(3),Z(3)^0]],
[ [Z(3)^0,0*Z(3),0*Z(3)], [0*Z(3),Z(3)^0,0*Z(3)],[Z(3)*0,Z(3)^0,Z(3)^0]]
];

gens[3] := [
[ [ Z(3), 0*Z(3), 0*Z(3) ,0*Z(3)], [ 0*Z(3), Z(3)^0, 0*Z(3),0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0,0*Z(3) ] , [0*Z(3),0*Z(3),0*Z(3),Z(3)^0]], 
[ [ Z(3), 0*Z(3), Z(3)^0,0*Z(3)], [ Z(3), 0*Z(3), 0*Z(3),0*Z(3)], [ 0*Z(3), Z(3), 0*Z(3),0*Z(3)] ,[0*Z(3),0*Z(3),0*Z(3),Z(3)^0]],
[ [Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)^0,0*Z(3),0*Z(3),Z(3)^0]]
];#GeneratorsOfGroup(GL(3,3)); for first two, 3rd is translator
tgens[3] := [
[ [Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)^0,0*Z(3),0*Z(3),Z(3)^0]],
[ [Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)*0,Z(3)^0,0*Z(3),Z(3)^0]],
[ [Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)*0,Z(3)*0,Z(3)^0,Z(3)^0]]
];
gens[4] := [
[ [ Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ,0*Z(3)], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3) ,0*Z(3)], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ,0*Z(3)], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ,0*Z(3)] , [0*Z(3),0*Z(3),0*Z(3),0*Z(3),Z(3)^0]],
[ [ Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ,0*Z(3)], [ Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ,0*Z(3)], [ 0*Z(3), Z(3), 0*Z(3), 0*Z(3) ,0*Z(3)], [ 0*Z(3), 0*Z(3), Z(3), 0*Z(3) ,0*Z(3)],[0*Z(3),0*Z(3),0*Z(3),0*Z(3),Z(3)^0] ],
[[Z(3)^0, 0*Z(3),0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[Z(3)*0,0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)^0,0*Z(3),0*Z(3),0*Z(3),Z(3)^0]]
];#GeneratorsOfGroup(GL(4,3)); for first two, 3rd is translator
tgens[4] := [
[[Z(3)^0, 0*Z(3),0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[Z(3)*0,0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)^0,0*Z(3),0*Z(3),0*Z(3),Z(3)^0]],
[[Z(3)^0, 0*Z(3),0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[Z(3)*0,0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)*0,Z(3)^0,0*Z(3),0*Z(3),Z(3)^0]],
[[Z(3)^0, 0*Z(3),0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[Z(3)*0,0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)*0,Z(3)*0,Z(3)^0,0*Z(3),Z(3)^0]],
[[Z(3)^0, 0*Z(3),0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),Z(3)^0,0*Z(3),0*Z(3),0*Z(3)],[0*Z(3),0*Z(3),Z(3)^0,0*Z(3),0*Z(3)],[Z(3)*0,0*Z(3),0*Z(3),Z(3)^0,0*Z(3)],[Z(3)*0,0*Z(3),0*Z(3),Z(3)^0,Z(3)^0]]
];

F := GF(3);
MIN_DIM := 2;
MAX_DIM := 4;

#vecs[d] enthaelt alle 3^d Vektoren. (ohne affinen Teil, d.h. 4D Vektoren haben Laenge 4.) 
vecs := [];
for i in [MIN_DIM..MAX_DIM] do
	vecs[i] := List(F^i);
	for v in vecs[i] do ConvertToVectorRep(v,3); od;
od;

#affine_vecs[d] enhaelt alle 3^d affine Vektoren (mit affinem Teil, d.h. 4D Vektoren haben Laenge 5 und enden mit Z(3)^0) 
affine_vecs := [];
for i in [MIN_DIM..MAX_DIM] do
	affine_vecs[i]:= List(vecs[i],j -> Concatenation(j,[Z(3)^0]));
	for v in affine_vecs[i] do ConvertToVectorRep(v,3); od;
od;

perm_gens := [];#gens in der Permutationsschreibweise (Permutation von [1..3^d])
perm_tgens := [];#tgens in der Permutationsschreibweise (Permutation von [1..3^d])
AGL := [];#AGL(d,3) als Gruppenaktion auf [1..3^d]
perm_GL := [];#GL(d,3) als Gruppenaktion auf [1..3^d]
for i in [MIN_DIM..MAX_DIM] do
	perm_gens[i] := List(gens[i],j-> Permutation(j,affine_vecs[i]));
	perm_tgens[i] := List(tgens[i],j->Permutation(j,affine_vecs[i]));
	AGL[i] := Group(perm_gens[i]);
	perm_GL[i] := Group(perm_gens[i]{[1..(Length(perm_gens[i])-1)]});
od;

#Wandelt ein Koerperelement (Z(3)*0, Z(3)^0, Z(3)) in eine ganze Zahl (0,1,2) um.
entryToNumber := function(e)
	if e=Z(3) then
		return 2;
	elif e=Z(3)^0 then
		return 1;
	elif e=Z(3)*0 then
		return 0;
	else
		return "ERROR";
	fi;
end;

#numberToEntry ist einfach n*Z(3)^0, ich glaube aber nicht, dass das irgendwann verwendet werden muss.

#Converts a d-vector to a number. This number is its index in the array vecs[d]. So (0,0,0,0) is 1 and (2,0,0,0) is 55. 
vectorToNumber := function(v)
	local num,i;
	num := 0;
	for i in [1..Length(v)] do
		num := 3*num + entryToNumber(v[i]);
	od;
	return num + 1;
end;

affineVectorToVector := function(v)
	local vec;
	vec := List(v){[1..(Size(v)-1)]};
	ConvertToVectorRep( vec ,3);
	return vec;
end;

#Convers an affine d-vector to a number. This number is its index in the array affine_vecs[d]. 
affineVectorToNumber := function(v)
	return vectorToNumber(affineVectorToVector(v));
	#removes last entry (the affine bit) and just uses VectorToNumber
end;

#writing sets
sets := [];
for i in [1..(3^MAX_DIM)] do
	sets[i] := [];
	for j in [1..(3^MAX_DIM)] do
		if i=j then
			sets[i][j] := fail;
		else
			sets[i][j] := vectorToNumber(- vecs[MAX_DIM][i] - vecs[MAX_DIM][j]);
		fi;
	od;
od;

#trans[d][i] stores the transversal (in AGL[d]) that puts i onto 1, for i in [1..3^d]. 
trans := [];
for i in [MIN_DIM..MAX_DIM] do
	trans[i] := [];
	transGroup := Elements(Subgroup(AGL[i],perm_tgens[i]));#just the group elements listed
	for j in [1..Size(transGroup)] do
		trans[i][j] := transGroup[1^(transGroup[j])]^(-1);
	od;	
od;

#stab_gens[d][i][j] stores the group element (in AGL[d]) that leaves the dims up to (but NOT including) i (where i in [1..DIM]) constant ("stabilized"). Thus i is the first dim that is NOT fixed anymore. It puts j (which is outside the prev 1...(i-1) dimensions) onto the 'Einheitsvektor' 3^(i-1)+1 of the dimension i, while remaining in the stabilizer of all vectors with dim [1..(i-1)], i.e. while not moving any of these vectors.  
stab_gens := [];
new_stab := [];
new_dim_vector := 0;
for i in [MIN_DIM..MAX_DIM] do
	stab_gens[i] := [];
	new_stab := perm_GL[i];#this is Stabilizer(AGL,(0,0,0,0))
	for j in [1..i] do
		new_dim_vector := 3^(j-1) + 1;#number of (1,0,0,0), then (0,1,0,0), etc. 
		stab_gens[i][j] := List([1..3^i], k-> RepresentativeAction(new_stab,k,new_dim_vector));
		new_stab := Stabilizer(new_stab,new_dim_vector);
	od;
od;

##############
# 2. ISMINIMAL
##############

#d...current dimension of vectors. (usually: d=4, since AGL(4,3))
#worker...w bzw. x bei M. This is the vector that is being changed. (Well, technically it stays the same; all changes are saved to the temp vector try.) If somehow worker < goal, then false is returned and we are done, since goal is not minimal. [Set, sublist of [1..81]]
#goal..."goal" vector, the vector being tested for minimality. Not being changed. If no worker can be found s.t. worker < goal, then goal was minimal and true was returned. [Set, sublist of [1..81]]
#dim...the first dimension that has not been "fixed" via trans and stab_gens. All entries in dimensions <dim are identical in worker and goal. (If worker were smaller, we would have returned false. If goal were smaller, we would have abandoned worker (backtrack principle)). [0 at start, goes to 4]
#pos...abhaengig von dim. First position in list at which goal and worker differ, which is just the first position that has the new dimension dim. [position in worker/goal, so somewhere in [1..81], in case of setless [1..20]]

#AUSGABE: false falls nicht minimal in Bahn, true falls minimal in Bahn.
powersOfThree := List([1..MAX_DIM],i->3^i);

isMinimal := function(d,worker,goal,dim,pos)
	local i,try,new_pos;
	if dim=0 then#First layer, use trans to give worker a 1
		for i in [1..Length(worker)] do
			try := OnSets(worker,trans[d][worker[i]]);
			if isMinimal(d,try,goal,1,2)=false then
				return false;
			fi;
		od;
	else#1<= dim <= d
		for i in [pos..Length(worker)] do
			try := OnSets(worker,stab_gens[d][dim][worker[i]]);
			if try < goal then
				return false;
			else#recurse on try=goal in [pos..new_pos], otherwise move on
				if dim<d then#dim=d, do nothing
					new_pos := pos + 1;
					while try[new_pos] < powersOfThree[dim] + 1 do#stop once new_pos geq 3^dim+1, i.e. is in next dim
						new_pos := new_pos + 1;
					od;
					if try{[pos..(new_pos-1)]} = goal{[pos..(new_pos-1)]} then
						if isMinimal(d,try,goal,dim+1,new_pos)=false then
							return false;
						fi;
					#elif try > goal: Don't need to continue. (backtracking principle)
					fi;
				fi;
			fi;
		od;
	fi;
	#going down a stack
	return true;
end;

# Gibt an, ob der Vektor v mit Dimension d minimal ist. 
isMin := function(d,v)
	return isMinimal(d,v,v,0,1);
end;

############################
# 3. Repraesentanten zaehlen
############################


badTries := function(base,tries)
	local bad,t,i,found;
	bad := Set([]);
	for t in tries do
		i := 1;
		found := false;
		while i<=Length(base) and found=false do
		#for i in [1..Length(base)] do
			if sets[t][base[i]] in base{[(i+1)..Length(base)]} then
				AddSet(bad,t);
				found:=true;#will never add t twice since (a,b,t) and (a,c,t) set => (a,b,c) set. can break after first found
			fi;
			i := i + 1;
		od;
	od;
	return bad;
end;

#n...number of sets each teilmenge should have. If -1, any number is permissible. (Bewirkt: Falls n=-1, werden alle Karten untersucht. Falls n<>-1, werden nur die Karten hinzugefuegt, die keine Sets hinzufuegen. Man geht daher davon aus, dass all Bahnvertreter aus old genau n sets haben.) 
#d...dimension, note that all Teilmengen with d will have this rank.
#old...all k-1 Teilmengen that can be made into valid k-Teilmengen with num_sets sets. This is just the d-1 and d k-1 Teilmengen. 
#AUSGABE: Liste von allen Vertretern, die zu [d][k] gehoeren.
calcParticularReps := function(n,d,old)
	local reps,i,base,tries,bad_tries,try;
	reps := [];
	for base in old do
		#All possible points that can be added
		last := base[Length(base)];
		if last<=3^(d-1) then#if base not full rank, next card to be added MUST be new Einheitsvektor 
			tries := Set([3^(d-1)+1]);
		else
			tries := Set([(last+1)..(3^d)]);#else, must try all cards in dimension d
		fi;
		#Removing points that add sets
		if n<> -1 then
			bad_tries := badTries(base,tries);
			SubtractSet(tries,bad_tries);
		fi;
		#Berechnung der Vertreter
		for i in tries do
			try := ShallowCopy(base);
			AddSet(try,i);
			if isMin(d,try) then
				Add(reps,try);
			fi;
		od;
	od;
	return reps;
end;

#converts teilmenge of vectors to numbers. 
vectorToNumber_menge := function(M)
	local i;
	return Set(List(M,i->vectorToNumber(i)));
end;

#n...Anzahl von Sets, die in den Vertretern vorkommen sollen. n=0 fuer setless, n=1 fuer ein set. 
calcReps := function(n)
	local reps,d,i,old,num_reps,min,max,start;
	reps := [];
	if n=0 then
		reps[1] := [];
		reps[1][2] := [[1,2]];
		min := MIN_DIM;#2
		max := MAX_DIM;#4
		start := List([1..max], i->i+1);#for each d in start, start at d+1
	elif n=1 then
		reps[1] := [];
		reps[1][3] := [[1,2,3]];
		min := MIN_DIM;
		max := MAX_DIM;
		start := List([1..max], i->i+2);#for each d in start, start at d+2
	elif n=2 then
		reps[2] := [];
		reps[2][5] := [vectorToNumber_menge([[0,0,0,0],[1,0,0,0],[2,0,0,0],[0,1,0,0],[0,2,0,0]]*Z(3)^0)];#schneiden sich
		reps[2][6] := [ vectorToNumber_menge([[0,0,0,0],[1,0,0,0],[2,0,0,0],[0,1,0,0],[1,1,0,0],[2,1,0,0]]*Z(3)^0) ];#parallel, 
		reps[3] := [];
		reps[3][6] := [ vectorToNumber_menge([[0,0,0,0],[1,0,0,0],[2,0,0,0],[1,1,0,0],[1,1,1,0],[1,1,2,0]]*Z(3)^0) ];#windschief?
		#[[0,0,0,0],[1,0,0,0],[2,0,0,0],[0,1,0,0],[0,2,0,0]] (schneiden sich) oder [[0,0,0,0],[1,0,0,0],[2,0,0,0],[0,1,0,0],[1,1,0,0],[2,1,0,0]] (parallel) oder [[0,0,0,0],[1,0,0,0],[2,0,0,0],[1,1,0,0],[1,1,1,0],[1,1,2,0]](schief?)
		return reps;
	elif n=-1 then#alle
		reps[1] := [];
		reps[1][1] := [];
		reps[1][2] := [[1,2]];
		reps[1][3] := [[1,2,3]];
		reps[2] := [];
		reps[2][3] := [[1,2,4]];
		min := MIN_DIM;
		max := MAX_DIM;
		start := List([1..max], i->i+1);
	fi;
	for d in [min..max] do
		reps[d] := [];
		i := start[d];
		num_reps := 1;#there is one rep [d][i]. When this reaches 0, (for setless,[d][d+1], d=4 at 21) calculation of reps stops.
		while num_reps > 0 do
			old := [];
			if IsBound(reps[d][i-1]) then
				old := reps[d][i-1];
			fi;
			if IsBound(reps[d-1][i-1]) then
				old := Union(old,reps[d-1][i-1]);
			fi;
			reps[d][i] := calcParticularReps(n,d,old);
			num_reps := Length(reps[d][i]);
			i := i+1;
		od;
	od;
	return reps;
end;

############
# ERGEBNISSE
############
#SET-frei: siehe null-reps.gap
#mit genau einem SET: siehe eins-reps.gap
