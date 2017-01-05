# AGL.gap
# Sara Fish, 2016

Read("AGL.gap");

# TODO

k := 2;
Vk := Combinations(Vp,k);
updateTime("Combinations");
totalFixpunkte := 0;
count := 0;
for g in AGL do
	for M in Vk do
		M := Set(M);
		if M=OnSets(M,g) then
			totalFixpunkte := totalFixpunkte + 1;
		fi;
	od;
	count := count + 1;
	if count mod 1000000 = 0 then
		Print("totalFixpunkte=",totalFixpunkte,"\n");
		Print(count/1000000);
		updateTime("");
	fi;
od;
