# 20set.gap
# Sara Fish, 2016

# Eine Menge von 20 Karten, die kein SET enthaelt, wird gefunden.
# Das Programm braucht auf meinem Laptop ca. 10 Sekunden, eine solche Menge zu finden. 

####################
# 1. Grundlegenes ##
####################

Vp := [1..81];

fieldToNumber := function(f)
	if f=Z(3)*0 then return 0;
	elif f=Z(3)^0 then return 1;
	elif f=Z(3) then return 2;
	else return fail;
	fi;
end;
numberToField := [0*Z(3),Z(3)^0,Z(3)]; 

#Number to Vector: Wandelt Vp ([1..81]) in V ([0,0,0,0] bis [2,2,2,2]) um. 
#z.B. 54 hat die Basis-3-Darstellung 2000. Daher ist die dazugehoerige Nummer 2000-1 = 1222. (also 53) Der entsprechender Vektor ist dann [Z(3)^0, Z(3),Z(3), Z(3)]
numberToVector := function(num)
	local i,vec;
	if num>81 or num<1 then return fail; fi;
	vec := [];
	num := num - 1;#to shift from [1..81] to [0..80]
	for i in [1..4] do
		vec[5-i] := numberToField[(num mod 3)+1];
		num := (num - (num mod 3))/3;
	od;
	return vec;
end;

#Vector to Number: Wandelt V ([0,0,0,0] bis [2,2,2,2]) in Vp ([1..81]) um.
# z.B. [2,0,0,0] entspricht der 3-adischen Zahl 54. Die entsprechende Zahl ist damit 55.	
vectorToNumber := function(vec)
	local i,num;
	num := 0;
	for i in [1..4] do
		num := num + (3^(4-i))*fieldToNumber(vec[i]);
	od;
	return num+1;#to shift from [0..80] to [1..81]
end;

thirdCard := List(Vp,i -> []);
#thirdCard[i][j] gibt an, welche dritte Karte i und j zu einem SET ergaenzt. thirdCard[i][i] = fail. 
for i in Vp do
	for j in Vp do
		if i=j then
			thirdCard[i][j] := fail;
		else
			thirdCard[i][j] := vectorToNumber(-numberToVector(i)-numberToVector(j));
		fi;
	od;
od;

#hasSet gibt an, ob eine Menge M von Karten (aus Vp) ein SET hat. Falls M ein SET hat, wird true ausgegeben. Sonst, false. 
hasSet := function(M)
	local k1,k2,k3;
	for k1 in [3..Size(M)] do
		for k2 in [2..(k1-1)] do
			for k3 in [1..(k2-1)] do
				#Reihenfolge: k3, k2, k1
				if thirdCard[M[k1]][M[k2]] = M[k3] then
					return true;
				fi;
			od;
		od;
	od;
	return false;
end;

########################################
# 2. Setfreie Menge mit 20 Karten suchen
########################################

# finde verwendet ein Backtrack-Algorithmus, um eine Menge von 20 Karten ohne SET zu finden. 
finde := function(t)
	local neu;
	if hasSet(t) then
		return false;
	elif Size(t)=20 then
		Print(t);#Eine Menge von 20 Karten ohne SET.
		return true;
	else
		for neu in [(t[Size(t)]+1)..81] do
			Add(t,neu);
			if finde(t) then
				return true;
			fi;
			Remove(t);
		od;
		return false;
	fi;
end;

main := function()
	local start;
	start := [1];
	return finde(start);
end;

main();
