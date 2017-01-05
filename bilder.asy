// bilder.asy
// Sara Fish, 26.09-27.09 
// (wa Twiy knnwso ef Ggyiqwuywvwb, oywgxjv au hjs nvllfaiy ksmx pvfb ktsypjl gm licpm sur brj UuKhjoqlk pb n qftd)

/*
-----------------------
 Bedienungsanleitung fuer drawCard
-----------------------
drawCard(pair coords, int anzahl_index, int form_index, int fuellung_index, int farbe_index, real scaleFactor=1,bool includeLabel=false)

coords: Ein (x,y) Paar. Gibt an, an welcher Stelle im Bild die Karte gezeichnet werden soll.
anzahl_index, form_index, fuellung_index, farbe_index: Jeweils 1, 2 oder 3. Gibt die Auspraegung des jeweiligen Merkmals an. z.B. farbe_index = 0 gibt die Farbe Rot an. (Unten ist eine vollstaendige Tabelle aller Festlegungen.)
scaleFactor: Gibt die Groesse der Karte an.
includeLabel: true oder false. Falls true, werden die Koordinaten der Karte (die die vier Merkmale angeben, z.b. (0,1,2,0)) unter der Karte geschrieben.

FESTLEGUNG       0           1        2
ANZAHL           1          2         3
FORM            rechteck  raute     ellipse
FUELLUNG        voll       halb      nicht
FARBE           rot        grun      blau

z.B. zeichnet drawCard((0,0),0,0,0,0) eine Karte mit einem rotem und voll schattierten Rechteck.

*/

unitsize(1cm);
import patterns;

add("red_full",hatch(H=1mm,dir=E,p=red+1mm));
add("red_half",hatch(H=1mm,dir=E,p=red+.5mm));
add("none",hatch(H=1mm,dir=E,p=white));
add("green_full",hatch(H=1mm,dir=E,p=green+1mm));
add("green_half",hatch(H=1mm,dir=E,p=green+.5mm));
add("blue_full",hatch(H=1mm,dir=E,p=blue+1mm));
add("blue_half",hatch(H=1mm,dir=E,p=blue+.5mm));

//WARNING! Changing the aspect ratio might make the cards look bad / symbols overlap. 
real X_WIDTH = 4;//width of card
real Y_HEIGHT = 6;//height of card
real EPSILON = 0.25;//radius of rounded corner

//Draws the card with attributes anzahl_index, form_index, fuellung_index, farbe_index at (x,y) pair coords. (coords is untere linke Ecke)
void drawCard(pair coords, int anzahl_index, int form_index, int fuellung_index, int farbe_index, real scaleFactor=1, bool includeLabel=false)
{
	//Set dimensions of the card, including scaleFactor.
	real x_width = scaleFactor*X_WIDTH;
	real y_height = scaleFactor*Y_HEIGHT;
	real epsilon = scaleFactor*EPSILON;
	//Draw the outer rectangle. (rounded, there are probably better ways but I just did it manually)
	draw( coords+(epsilon,0){curl 0}{right} .. coords+(x_width-epsilon,0){curl 0}{right}.. coords+(x_width,epsilon){curl 0}{up} .. coords+(x_width, y_height-epsilon){curl 0}{up} .. coords+(x_width-epsilon,y_height){curl 0}{left}.. coords+(epsilon,y_height){curl 0}{left} .. coords+(0,y_height-epsilon){curl 0}{down}.. coords+(0,epsilon){curl 0}{down}.. cycle , black+1);
	//Draw label, if includeLabel (by default off). This is just the coords of the card (1,2,2,1) or whatever.
	if(includeLabel){
		label("("+string(anzahl_index)+","+string(form_index)+","+string(fuellung_index)+","+string(farbe_index)+")", coords+(x_width/2,0), align=S);
	}
	//Determine the coords of all the symbols that need to be drawn. toDraw is an array of pairs, each entry is a pair that gives the (bottom right) coord of a symbol that will go on a card. Thus toDraw.length == anzahl.
	pair[] toDraw;
	if(anzahl_index==0){
		toDraw.push( coords + (x_width/4, y_height*(5/12) ) );
	} else if(anzahl_index==1){
		toDraw.push( coords + (x_width/4, y_height*(3/12) ) );
		toDraw.push( coords + (x_width/4, y_height*(7/12) ) );
	} else if(anzahl_index==2){
		toDraw.push( coords + (x_width/4, y_height*(1/12) ) );
		toDraw.push( coords + (x_width/4, y_height*(5/12) ) );
		toDraw.push( coords + (x_width/4, y_height*(9/12) ) );
	} else {
		abort("Error: invalid anzahl!");
	}
	//smallX and smallY are useful for Raute and Ellipse, since the midpoints of their rectangular bounding boxes are used to define these curves. Raute is just connecting the midpoints. Ellipse is a Bezier curve (and thus not actually an ellipsis, but whatever) using these midpoints.
	pair smallX = (x_width/2 , 0);
	pair smallY = (0 , y_height/6);
	pair smallDim = (x_width/2, y_height/6);
	pen farbe;
	//Set farbe to be the correct pen color based on farbe_index.
	if(farbe_index==0){
		farbe = red;
	} else if(farbe_index==1){
		farbe = green;
	} else if(farbe_index==2){
		farbe = blue;
	} else {
		abort("Error: invalid farbe!");
	}
	//pat[farbe_index],[fuellung_index] returns a string s. At the top, all of these strings were assigned to particular shading patterns. So calling pattern(s) will make the shading pattern work.
	string[][] pat = { {"red_full","red_half","none"}, {"green_full","green_half","none"}, {"blue_full","blue_half","none"} };
	//Actually drawing the symbols on the card. For each symbol (so each coord in toDraw) (accounts for Anzahl), it draws the right form (accounts for Form), with the shader specified by pat[][] (accounts for Farbe and Fuellung). 
	for(pair coord : toDraw){
		if(form_index==0){//rectangle
			filldraw( box(  coord, coord+smallDim ), pattern(pat[farbe_index][fuellung_index]), farbe);
		} else if(form_index==1){//raute
			filldraw( (coord+smallX/2) -- (coord+smallX+smallY/2) -- (coord+smallX/2+smallY) -- (coord+smallY/2) -- cycle ,pattern(pat[farbe_index][fuellung_index]),farbe);
		} else if(form_index==2){//ellipse
			filldraw( ((coord+smallX/2){right} ..(coord+smallX+smallY/2){up}.. (coord+smallX/2+smallY){left} .. (coord+smallY/2)){down} .. cycle,pattern(pat[farbe_index][fuellung_index]) ,farbe);
		} else {
			abort("Erorr: invalid form!");
		}
		
	}
	return;
}

//This prints out all the cards. (For debugging purposes.)
/*
void printAll(){
for(int i1=0; i1<3; ++i1){
	for(int i2=0; i2<3; ++i2){
		for(int i3=0; i3<3; ++i3){
			for(int i4=0; i4<3; ++i4){
				int number = (i1-1) + 3*(i2-1) + 9*(i3-1) + 27*(i4-1);
				real x_spot = (X_WIDTH+2*EPSILON)*((i1-1) + 3*(i2-1));
				real y_spot = (Y_HEIGHT+4*EPSILON)*((i3-1) + 3*(i4-1));
				drawCard((x_spot,y_spot), i1,i2,i3,i4 , scaleFactor=1, includeLabel=true);
			}
		}
	}
}
return;}
*/
//printAll();
