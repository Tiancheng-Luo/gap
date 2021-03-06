#############################################################################
##
#W  grpperm.tst                 GAP tests                    Alexander Hulpke
##
##
#Y  Copyright (C)  1997
##
##  Exclude from testinstall.g: why?
##
gap> START_TEST("grpperm.tst");
gap> G1 := TrivialSubgroup (Group ((1,2)));;
gap> G2 := SymmetricGroup ([]);;
gap> G3:=Intersection (G1, G2);;
gap> Size(G3);
1
gap> Pcgs(G3);;
gap> g:=Group((1,2,9)(3,4,5)(6,7,8), (1,4,7)(2,5,8)(3,6,9));;
gap> h:=Group((1,2,9)(3,4,5)(6,7,8));;
gap> (g<h)=(AsSSortedList(g)<AsSSortedList(h));
true
gap> g:=Group( (1,2,3), (2,3)(4,5) );;
gap> IsSolvable(g);
true
gap> RepresentativeAction(g,(2,5,3), (2,3,4));
(2,3)(4,5)
gap> g:=Group( ( 9,11,10), ( 2, 3, 4),  (14,17,15), (13,16)(15,17), 
>              ( 8,12)(10,11), ( 5, 7)(10,11), (15,16,17), (10,11,12) );;
gap> Sum(ConjugacyClasses(g),Size)=Size(g);
true
gap> g:= Group( (4,8,12),(2,10)(4,8),(1,10)(2,5)(3,12)(4,7)(6,9)(8,11),
>               (1,7)(3,9)(5,11)(6,10) );;
gap> e:=ElementaryAbelianSeriesLargeSteps(DerivedSeries(g));;
gap> List(e,Size);
[ 2592, 324, 162, 81, 1 ]
gap> ForAll([1..Length(e)-1],i->HasElementaryAbelianFactorGroup(e[i],e[i+1]));
true
gap> group:=
> Subgroup( Group( (  1,  2)(  3,  5)(  4,  7)(  6, 10)(  8, 12)(  9, 13)
> ( 14, 19)( 15, 20)( 16, 22)( 17, 23)( 18, 25)( 24, 31)( 26, 33)( 27, 34)
> ( 28, 36)( 29, 38)( 30, 39)( 35, 45)( 37, 46)( 41, 48)( 42, 50)( 43, 51)
> ( 44, 53)( 47, 57)( 49, 59)( 52, 62)( 54, 64)( 55, 65)( 56, 67)( 58, 70)
> ( 60, 73)( 61, 74)( 63, 77)( 66, 80)( 68, 82)( 69, 75)( 71, 84)( 72, 85)
> ( 76, 88)( 78, 90)( 79, 91)( 81, 94)( 83, 97)( 86,100)( 87,101)( 89,102)
> ( 92,104)( 93,105)( 95,103)( 96,106)( 99,107)(108,114)(109,115)(110,112)
> (113,117)(118,119), (  1,  3,  6)(  2,  4,  8)(  5,  9, 14)(  7, 11, 16)
> ( 10, 15, 21)( 12, 17, 24)( 13, 18, 26)( 19, 27, 35)( 20, 28, 37)( 22, 29, 36)
> ( 23, 30, 40)( 25, 32, 42)( 31, 41, 49)( 33, 43, 52)( 34, 44, 54)( 38, 39, 47)
> ( 45, 55, 66)( 46, 56, 68)( 48, 58, 71)( 50, 60, 65)( 51, 61, 75)( 53, 63, 78)
> ( 57, 69, 73)( 59, 72, 86)( 62, 76, 89)( 64, 79, 92)( 67, 81, 95)( 70, 83, 98)
> ( 74, 87, 77)( 80, 93, 88)( 82, 96, 97)( 84, 99,108)( 85, 90,103)( 91,101,110)
> ( 94,100,109)(102,111,104)(105,112,116)(106,113,118)(114,115,117) ), 
> [ (  1,  6)(  2, 25)(  4, 27, 70, 98, 35, 42)(  5, 44)(  7, 11)(  8, 32, 19)
>     (  9, 50, 33,111, 24, 34)( 12,113, 40, 65, 14, 54)( 13, 78)( 15, 21)
>     ( 17,104, 52, 60, 23,106)( 18, 41, 88, 93, 49, 63)( 20,109)( 22,107, 29)
>     ( 26, 53, 31)( 28, 86, 76, 62, 59,100)( 30,118)( 37, 94, 72)
>     ( 38,110, 99,114, 90, 95)( 39, 87, 92, 71, 73,101)( 43,102)
>     ( 45, 85,115, 46, 58, 64)( 47, 67, 84, 91, 57, 74)( 48, 56, 66, 79, 77, 69
>      )( 51, 75)( 55, 68,117,108, 81,103)( 96, 97)(112,116), 
>   (  1,  8, 65, 89, 94, 10, 37, 72, 43, 32,  6, 14, 19, 83, 54)
>     (  2,  9, 78, 86, 67, 63, 52, 76, 93, 55, 44, 49, 42, 24, 82,118,  4, 13,
>       17, 92, 88, 62,104, 18, 85,109, 41, 34, 35, 16)(  3, 21, 15)
>     (  5, 45, 95,117, 59, 29, 47, 74,110, 50, 30, 69, 64, 91, 22, 20,103, 99,
>       46, 60, 26, 87, 39, 90, 27, 25, 66, 81, 73, 53)(  7, 36, 84,106, 38, 51,
>      33, 79, 98, 96, 56,100, 68, 31,116,112, 80, 71, 28,114, 97, 70, 48,111,
>       75, 77, 23,115,107, 11)( 12,102, 40,119,113)( 57,108,105,101, 58, 61) 
>  ] );;
gap> perf:=RepresentativesPerfectSubgroups(group);;
gap> List(perf,Size);
[ 1, 60, 960, 30720 ]
gap> g:=Group([
> (2,3,5,4)(6,14,21)(7,12,22,9,13,24,10,11,25,8,15,23)(16,32,27)(17,31,
> 29,18,35,26,20,33,30,19,34,28), (1,26,25,2,28,24)(3,30,23,5,29,21)
> (4,27,22)(6,9)(7,8)(11,18,35,13,16,31,12,17,33,15,19,32)(14,20,34) ]);;
gap> h:=Group([ (31,32,33,34,35), (26,27,28,29,30), (21,22,23,24,25),
> (16,17,18,19,20), (11,12,13,14,15), (6,7,8,9,10), (1,2,3,4,5) ] );;
gap> Size(g/h);
2752512
gap> g:=WreathProduct(MathieuGroup(11),Group((1,2)));
<permutation group of size 125452800 with 5 generators>
gap> Length(ConjugacyClassesSubgroups(g));
2048
gap> g:=SemidirectProduct(GL(3,5),GF(5)^3);
<matrix group of size 186000000 with 3 generators>
gap> g:=Image(IsomorphismPermGroup(g));
<permutation group of size 186000000 with 3 generators>
gap> List(MaximalSubgroupClassReps(g),Size);
[ 93000000, 1488000, 6000000, 6000000, 60000, 48000, 46500 ]
gap> g:=Image(IsomorphismPermGroup(GL(2,5)));;
gap> w:=WreathProduct(g,SymmetricGroup(5));;
gap> m:=MaximalSubgroupClassReps(w);;
gap> Collected(List(m,x->Index(w,x)));
[ [ 2, 3 ], [ 5, 1 ], [ 6, 1 ], [ 10, 1 ], [ 16, 1 ], [ 3125, 1 ], 
  [ 7776, 1 ], [ 100000, 1 ] ]
gap> Unbind(m);Unbind(w);Unbind(g);
gap> g := Group(GeneratorsOfGroup(SymmetricGroup(1000)));;
gap> IsNaturalSymmetricGroup(g);
true
gap> Size(g) = Factorial(1000);
true
gap> g := Group(GeneratorsOfGroup(AlternatingGroup(999)));;
gap> IsNaturalSymmetricGroup(g);
false
gap> IsNaturalAlternatingGroup(g);
true
gap> 2*Size(g) = Factorial(999);
true
gap> Intersection(SymmetricGroup([1..5]),SymmetricGroup([3..8]));
Sym( [ 3 .. 5 ] )
gap> Intersection(SymmetricGroup([1..5]),AlternatingGroup([3..8]));
Alt( [ 3 .. 5 ] )
gap> Intersection(AlternatingGroup([1..5]),AlternatingGroup([3..8]));
Alt( [ 3 .. 5 ] )
gap> Intersection(AlternatingGroup([1..5]),SymmetricGroup([3..8]));  
Alt( [ 3 .. 5 ] )
gap> s := SymmetricGroup(100);
Sym( [ 1 .. 100 ] )
gap> Stabilizer(s,3,OnPoints);
Sym( [ 1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,\
 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 4\
1, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60,\
 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 8\
0, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99,\
 100 ] )
gap> Stabilizer(s,[3,4,101],OnTuples); 
Sym( [ 1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22\
, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, \
42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61\
, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, \
81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 10\
0 ] )
gap> Stabilizer(s,[3,4,101],OnSets);
<permutation group of size 188537808977664954912523714861144849476193875281579\
033269884775545894141400464475977659523184154582396472117011772169208588252951\
34720000000000000000000000 with 3 generators>
gap> Stabilizer(s,[[2,3],[3,4,5,101]],OnTuplesSets);
<permutation group of size 198335586974189937841914280308378760231636729730253\
559088875210967698444561818299997537895207400149796415018947793150861127974912\
0000000000000000000000 with 3 generators>
gap> Stabilizer(s,[[2,3],[3,4,101]],OnTuplesSets);  
Sym( [ 1, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 2\
3, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42,\
 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 6\
2, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81,\
 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100 ]\
 )
gap> Centralizer(s,(1,2,3,4)(5,6,7,8)(9,10,11)(12,13,14));
<permutation group of size 139548069409954938518969413651821655960040854381993\
238884831283501108134558516513594307316297031600121692765028352000000000000000\
00000 with 91 generators>
gap> GeneratorsOfGroup(last);
[ (1,2,3,4), (1,5)(2,6)(3,7)(4,8), (5,6,7,8), (9,10,11), (9,12)(10,13)(11,14),
  (12,13,14), (15,100), (16,100), (17,100), (18,100), (19,100), (20,100), 
  (21,100), (22,100), (23,100), (24,100), (25,100), (26,100), (27,100), 
  (28,100), (29,100), (30,100), (31,100), (32,100), (33,100), (34,100), 
  (35,100), (36,100), (37,100), (38,100), (39,100), (40,100), (41,100), 
  (42,100), (43,100), (44,100), (45,100), (46,100), (47,100), (48,100), 
  (49,100), (50,100), (51,100), (52,100), (53,100), (54,100), (55,100), 
  (56,100), (57,100), (58,100), (59,100), (60,100), (61,100), (62,100), 
  (63,100), (64,100), (65,100), (66,100), (67,100), (68,100), (69,100), 
  (70,100), (71,100), (72,100), (73,100), (74,100), (75,100), (76,100), 
  (77,100), (78,100), (79,100), (80,100), (81,100), (82,100), (83,100), 
  (84,100), (85,100), (86,100), (87,100), (88,100), (89,100), (90,100), 
  (91,100), (92,100), (93,100), (94,100), (95,100), (96,100), (97,100), 
  (98,100), (99,100) ]
gap> Centralizer(AlternatingGroup(14), (1,2,3,4)(5,6,7,8)(9,10,11)(12,13,14));
<permutation group of size 288 with 7 generators>
gap> GeneratorsOfGroup(last);
[ (1,3)(2,4), (1,5)(2,6)(3,7)(4,8), (5,7)(6,8), (1,2,3,4)(5,8,7,6), 
  (9,10,11), (1,2,3,4)(9,12)(10,13)(11,14), (12,13,14) ]
gap> a8 := AlternatingGroup(8);;
gap> pairs := Tuples( [1..8], 2 );;
gap> orbs := Orbits( a8, pairs, OnPairs );; Length( orbs );
2
gap> u56 := Stabilizer( a8, orbs[2][1], OnPairs );; Index( a8, u56 );
56
gap> g:=TransitiveGroup(12,250);;
gap> hom:=IsomorphismPcGroup(g);;
gap> Length(ConjugacyClassesByHomomorphicImage(g,hom));
65
gap> gp1:=Group(
> (1,23,6,64,38)(2,42,18,19,11)(3,7,30,49,50)(4,14,20,45,46)(5,9,21,41,58,34, 
> 17,29,48,44)(8,26,40,43,33)(10,22,59,60,32)(12,24,53,74,76)(13,31,55,81,77,
> 61,25,52,75,83)(15,27,51,78,79)(16,28,47,68,71,62,36,56,70,69)(35,57,82,92,
> 91,37,54,80,90,93)(66,72)(85,86)(88,94)(95,96)(97,98,100,102,104)(99,101,
> 103,105,106), (1,32,11,3)(2,10,23,7)(4,15,33,12)(5,13,34,61)(6,38,42,19)(8,
> 27,14,24)(9,25,17,31)(16,35,62,37)(18,63,64,39)(20,46,26,43)(21,44,29,
> 58)(22,60,30,50)(28,54,36,57)(40,67,45,65)(41,66,48,72)(47,69,56,71)(49,84,
> 59,73)(51,79,53,76)(52,77,55,83)(68,85,70,86)(74,89,78,87)(75,88,81,94)(80,
> 91,82,93)(90,95,92,96)(97,98)(99,101)(102,104)(105,106), 
> (4,33)(8,14)(12,15)(16,62)(20,26)(24,27)(28,36)(35,37)(40,45)(43,46)(47,
> 56)(51,53)(54,57)(65,67)(68,70)(69,71)(74,78)(76,79)(80,82)(85,86)(87,
> 89)(90,92)(91,93)(95,96), (1,4)(2,8)(3,12)(5,16)(6,20)(7,24)(9,28)(10,
> 27)(11,33)(13,35)(14,23)(15,32)(17,36)(18,40)(19,43)(21,47)(22,51)(25,
> 54)(26,42)(29,56)(30,53)(31,57)(34,62)(37,61)(38,46)(39,65)(41,68)(44,
> 69)(45,64)(48,70)(49,74)(50,76)(52,80)(55,82)(58,71)(59,78)(60,79)(63,
> 67)(66,85)(72,86)(73,87)(75,90)(77,91)(81,92)(83,93)(84,89)(88,95)(94,96), 
> (1,5)(2,9)(3,13)(4,16)(6,21)(7,25)(8,28)(10,31)(11,34)(12,35)(14,36)(15,
> 37)(17,23)(18,41)(19,44)(20,47)(22,52)(24,54)(26,56)(27,57)(29,42)(30,
> 55)(32,61)(33,62)(38,58)(39,66)(40,68)(43,69)(45,70)(46,71)(48,64)(49,
> 75)(50,77)(51,80)(53,82)(59,81)(60,83)(63,72)(65,85)(67,86)(73,88)(74,
> 90)(76,91)(78,92)(79,93)(84,94)(87,95)(89,96));;
gap> gp2:=Group(
> (4,16)(5,20)(8,14)(9,18)(12,15)(13,39)(23,29)(24,32)(27,30)(28,35)(42,47)(43,
> 50)(45,48)(46,60)(54,56)(55,58)(65,67)(66,72)(74,78)(75,81)(76,79)(77,
> 83)(87,89)(88,94), (1,2,6,21,40,11,26,44,64,22)(3,10,34,61,53,36,7,25,52,
> 62)(4,14,23,47,48)(5,9,24,43,60,20,18,32,50,46)(8,29,42,45,16)(12,27,56,74,
> 76)(13,35,58,81,77,39,28,55,75,83)(15,30,54,78,79)(17,33,49,69,71)(19,31,
> 51,68,70)(37,57,82,90,92)(38,59,80,91,93)(41,63)(66,72)(73,84)(88,94), 
> (1,4,11,16)(2,8,26,14)(3,12,36,15)(5,19,20,17)(6,23,44,29)(7,27,10,30)(9,33,
> 18,31)(13,38,39,37)(21,42,64,47)(22,45,40,48)(24,51,32,49)(25,54,34,56)(28,
> 59,35,57)(41,65,63,67)(43,69,50,68)(46,71,60,70)(52,74,61,78)(53,76,62,
> 79)(55,82,58,80)(66,86,72,85)(73,87,84,89)(75,91,81,90)(77,93,83,92)(88,96,
> 94,95), (1,5)(2,9)(3,13)(4,17)(6,24)(7,28)(8,31)(10,35)(11,20)(12,37)(14,
> 33)(15,38)(16,19)(18,26)(21,43)(22,46)(23,49)(25,55)(27,57)(29,51)(30,
> 59)(32,44)(34,58)(36,39)(40,60)(41,66)(42,68)(45,70)(47,69)(48,71)(50,
> 64)(52,75)(53,77)(54,80)(56,82)(61,81)(62,83)(63,72)(65,85)(67,86)(73,
> 88)(74,90)(76,92)(78,91)(79,93)(84,94)(87,95)(89,96), 
> (1,36,11,3)(2,10,26,7)(4,15,16,12)(5,39,20,13)(6,40,44,22)(8,30,14,27)(9,35,
> 18,28)(17,38,19,37)(21,63,64,41)(23,48,29,45)(24,60,32,46)(25,62,34,53)(31,
> 59,33,57)(42,67,47,65)(43,72,50,66)(49,71,51,70)(52,84,61,73)(54,79,56,
> 76)(55,83,58,77)(68,86,69,85)(74,89,78,87)(75,94,81,88)(80,93,82,92)(90,96,
> 91,95));;
gap> IsomorphismGroups(gp1,gp2)<>fail;
true
gap> STOP_TEST( "grpperm.tst", 1814420000);

#############################################################################
##
#E
