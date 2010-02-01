//Assumed Sizes:
//All cells assumed to be 80 lambda wide and have the following heights(lambda)

//Contents:				Sizes:
//and2(y, a, b)				<size(and2) = 40>
//and3(y, a, b, c)			<size(and3) = 48>
//and4(y, a, b, c, d)			<size(and4) = 56>
//and5(y, a, b, c, d, e)		<size(and5) = 64>

//aoi(y, a, b, c)			<size(aoi) = 32>
//aaoi(y,a, b, c, d)			<size(aaoi)= 40>

//bmux2(y_b, s, s_b, d0, d1)		?

//buffer(y, a)				<size(buffer) = 32>


//fourtwo_x(cout, s, carry, a, b, c, d, cin);	<size(fourtwo_x) = size(fullAdd_x)*2> //352

//fullAdd(cout,   s, a, b, cin)		<size(fullAdd) = 128> * mirror adder
//fullAdd_x(cout,   s,   a, b, cin)	<size(fullAdd_x) = 176> * 3-input XOR + Maj
//fullAdd_xc(cout,   s,   a, b, cin)    <size(fullAdd_xc) = size(maj) + 2*size(xor2)>//160           * two levels of 2-input XORs + Maj
//fullAdd_i(cout_b, s_b, a, b, cin)	<size(fullAdd_i) = 96> * mirror adder with inverted outputs

//halfAdd(cout,s,a,b)			<size(halfAdd) = 80>

//inverter(y, a)			<size(inverter) = 16>

//maj(y, a, b, c)			<size(maj) = size(min)+size(inverter)>//48
//min(egress, a, b, c)			<size(min) = 32>
//mux2(s, s_b, d0, d1, y)		?

//nand2(y, a, b)			<size(nand2) = 24>
//nand3(y, a, b, c)			<size(nand3) = 32>
//nand4(y, a, b, c, d)			<size(nand4) = 40>
//nand5(y, a, b, c, d, e)		<size(nand5) = 48>

//nor2(y, a, b)				<size(nor2) = 24>
//nor3(y, a, b, c)			<size(nor3) = 32>

//oai(y, a, b, c)			<size(oai) = 32>

//or2(y,a,b)				<size(or2) = 40>

//r4be(y0, y1, y2, sing, doub, neg)	<size(r4be) = 168>
//r4bs(x0,x1,sing,doub,neg,pp)		<size(r4bs) = size(xnor2)+size(aaoi)>//56

//subxor(y_b, a, a_b, b, b_b)		??

//sum_b(s_b, a, b, cin, cout_b)		48?

//xor2(a, b, y)				<size(xor2) = 56>
//xor3(a,b,c,y);			<size(xor3) = 112>
//xor3c(y,a,ab,b,bb,c,cb)		<size(xor3c) = 144> *with inversion
//xnor2(a, b, y)			<size(xnor2) = 56>

// added on Jan 22, 2010 by Daniel Lee
//blackCell				<size(blackCell) = 88>
//grayCell				<size(grayCell) = 48>
