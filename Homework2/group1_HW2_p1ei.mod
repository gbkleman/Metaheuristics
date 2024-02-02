reset;

option solver cplex;

## Quality max of grapes

set products;
set grapeQuality;

param quality{products};
param poundsPerProduct{products};
param variableCost{products};
param sellingPrice{products};
param fruitCost{grapeQuality};
param totalWeight{grapeQuality};
param rating{grapeQuality};
param maxDemand{products} default Infinity;

var weight{p in products,q in grapeQuality} >=0;
var totalProduct{p in products} = (sum{g in grapeQuality} weight[p,g])/poundsPerProduct[p];

maximize netProfit: sum{p in products} 
						((sellingPrice[p]-variableCost[p])*(sum{g in grapeQuality} weight[p,g])/poundsPerProduct[p]
						-
						sum{q in grapeQuality} weight[p,q]*fruitCost[q]);
						
#subject to qualityControl {p in products}: sum {q in grapeQuality} rating[q]*weight[p,q]>= quality[p]*(sum {q in grapeQuality}weight[p,q]) ;
subject to weightLimit {q in grapeQuality}: sum {p in products} weight[p,q] <= totalWeight[q];
subject to demandRestrictions {p in products}: (sum{g in grapeQuality} weight[p,g])/poundsPerProduct[p] <= maxDemand[p];


data;


set products := raisins juice jelly;
set grapeQuality := A B;

param: 	quality,	poundsPerProduct, 	variableCost, 	sellingPrice,	maxDemand :=
raisins 8			6.75				5.07			8.39			.
juice	6			15.5				9.82			16.20			205000
jelly 	5			19					6.50			14.25			290000;

param: 	fruitCost, 		totalWeight, 	rating:=
A 		0.28			2100000			9
B 		0.28			6300000			5;

solve;

display totalProduct;
display weightLimit;