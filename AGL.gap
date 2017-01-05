# AGL.gap
# Sara Fish, 2016

# In AGL.gap wird die AGL(4,3) in GAP implementiert. Die entstehende Gruppe AGL operiert auf der Menge V und ist damit eine Untergruppe von S_81. Dieses Programm ist nicht fuer die Berechnungen notwendig und wird nur der Vollstaendigkeit wegen angehaengt.


# Grundlegenes (ist auch in alle.gap zu finden)
n := 4;
F := GF(3);
V := F^n;
G := GL(n,3);
Vp := [];
vektorenliste := List(V);
for i in [1..Size(V)] do
	Add(Vp,PermList(List(vektorenliste,x->Position(vektorenliste,x+vektorenliste[i]))));
od;

# affineMatrixGens ist ein Erzeugendensystem von AGL(4,3) (in 5x5 Matrizenform). 
affineMatrixGens := [ 
[ [ Z(3), 0*Z(3), 0*Z(3), 0*Z(3) ,0*Z(3)], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3),0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3) ,0*Z(3)], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0,0*Z(3) ] , [0*Z(3),0*Z(3),0*Z(3),0*Z(3),Z(3)^0] ], 
[ [ Z(3), 0*Z(3), 0*Z(3), Z(3)^0,0*Z(3) ], [ Z(3), 0*Z(3), 0*Z(3), 0*Z(3),0*Z(3) ], [ 0*Z(3), Z(3), 0*Z(3), 0*Z(3),0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3), 0*Z(3),0*Z(3) ], [0*Z(3),0*Z(3),0*Z(3),0*Z(3),Z(3)^0]  ] ,
[ [ Z(3)^0, 0*Z(3), 0*Z(3), 0*Z(3),0*Z(3)], [ 0*Z(3), Z(3)^0, 0*Z(3), 0*Z(3),0*Z(3) ], [ 0*Z(3), 0*Z(3), Z(3)^0, 0*Z(3),0*Z(3) ], [ 0*Z(3), 0*Z(3), 0*Z(3), Z(3)^0 ,0*Z(3)] , [Z(3)^0 ,0*Z(3),0*Z(3),0*Z(3),Z(3)^0] ]
];


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

# Die Vektoren Vp werden in 5x1 Vektoren umgewandelt, die mit den affineMatrixGens multipliziert werden koennen.
Vaffine := [];
for i in [1..81] do
	thing := numberToVector(i);
	Add(thing,Z(3)^0);
	Vaffine[i] := thing;
od;

# Nun werden die affineMatrixGens von der Matrixform in die Permutationsform umgewandelt.
affinePermGens := [];
for i in [1..3] do
	matrix := affineMatrixGens[i];
	affinePermGens[i] := Permutation(matrix,Vaffine);
od;

AGL := Group(affinePermGens);
