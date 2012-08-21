#############################################################################
##
#W  alglie.gd                   GAP library                     Thomas Breuer
#W                                                        and Willem de Graaf
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This file contains the declaration of attributes, properties, and
##  operations for Lie algebras.
##
Revision.alglie_gd :=
    "@(#)$Id$";

#1 
## A Lie algebra $L$ is an algebra such that 
## $xx=0$ and $x(yz)+y(zx)+z(xy)=0$ for all $x,y,z\in L$. A common way of
## creating a Lie algebra is by taking an associative
## algebra together with the commutator as product. Therefore
## the product of two elements $x,y$ of a Lie algebra is usually denoted by 
## $[x,y]$, but in {\GAP} this denotes the list of the elements $x$ and $y$;
## hence the product of elements is made by the usual `*'.
## This gives no problems when dealing with Lie algebras given by a 
## table of structure constants. However, for matrix Lie algebras 
## the situation is not so easy as `*' denotes the ordinary (associative)
## matrix multiplication. In \GAP this problem is solved by wrapping 
## elements of a matrix Lie algebra up as LieObjects, and then define 
## the `*' for LieObjects to be the commutator (see "ref:lie objects");

#############################################################################
##
#P  IsLieAbelian( <L> )
##
##  is `true' if <L> is a Lie algebra such that each product of elements in
##  <L> is zero, and `false' otherwise.
##
DeclareProperty( "IsLieAbelian",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#P  IsLieNilpotent( <L> )
##
##  A Lie algebra <L> is defined to be (Lie) {\it nilpotent} when its
##  (Lie) lower central
##  series reaches the trivial subalgebra.
##
DeclareProperty( "IsLieNilpotent",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#P  IsRestrictedLieAlgebra( <L> )
##
##  Test whether <L> is restricted.
##
DeclareProperty( "IsRestrictedLieAlgebra",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#A  LieDerivedSubalgebra( <L> )
##
##  is the (Lie) derived subalgebra of the Lie algebra <L>.  
##
DeclareAttribute( "LieDerivedSubalgebra",
    IsAlgebra and IsLieAlgebra );

#############################################################################
##
#A  LieDerivedSeries( <L> )
##
##  is the (Lie) derived series of the Lie algebra <L>.  
##
DeclareAttribute( "LieDerivedSeries",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#P  IsLieSolvable( <L> )
##
##  A Lie algebra <L> is defined to be (Lie) {\it solvable} when its
##  (Lie) derived series reaches the trivial subalgebra.
##
DeclareProperty( "IsLieSolvable",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#A  LieLowerCentralSeries( <L> )
##
##  is the (Lie) lower central series of the Lie algebra <L>.  
##
DeclareAttribute( "LieLowerCentralSeries",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#A  LieUpperCentralSeries( <L> )
##
##  is the (Lie) upper central series of the Lie algebra <L>.
##
DeclareAttribute( "LieUpperCentralSeries",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#A  LieCentre( <L> )
#A  LieCenter( <L> )
##
##  The *Lie* centre of the Lie algebra <L> is the kernel of the adjoint
##  mapping, that is, the set $\{ a \in L; \forall x\in L:a x = 0 \}$.
##
##  In characteristic 2 this may differ from the usual centre (that is
##  the set of all $a\in L$ such that $ax=xa$ for all $x\in L$). 
##  Therefore, this operation is named `LieCentre' and not `Centre'. 
##
##
DeclareAttribute( "LieCentre", IsAlgebra and IsLieAlgebra );

DeclareSynonym( "LieCenter", LieCentre );


#############################################################################
##
#A  Derivations( <B> )
##
##  is the matrix Lie algebra of derivations of the algebra $A$ with basis
##  <B>.
##
##  A derivation is a linear map $D: A \rightarrow A$ with the property
##  $D( a b ) = D(a) b + a D(b)$.
##
##  With respect to the basis $B$ of $A$, the derivation $D$ is described
##  by the matrix $[ d_{i,j} ]$
##  which means that $D$ maps $b_i$ to $\sum_{j=1}^n d_{ij} b_j$.
##
##  The set of derivations of $A$ forms a Lie algebra with product given by
##  $(D_1 D_2)(a) = D_1(D_2(a)) - D_2(D_1(a))$.
##
DeclareAttribute( "Derivations", IsBasis );


#############################################################################
##
#A  KillingMatrix( <B> )
##
##  is the matrix of the Killing form $\kappa$ with respect to the basis <B>,
##  i.e., the matrix $(\kappa(b_i,b_j))$ where $b_1,b_2\ldots $ are the
##  basis vectors of <B>.
##
DeclareAttribute( "KillingMatrix", IsBasis );


#############################################################################
##
#A  CartanSubalgebra( <L> )
##
##  A Cartan subalgebra of a Lie algebra <L> is defined as a nilpotent
##  subalgebra of <L> equal to its own Lie normalizer in <L>.
##
DeclareAttribute( "CartanSubalgebra",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#A  PthPowerImages( <B> )
##
##  Here `B' is a basis of a restricted Lie algebra. This function returns
##  the list of the images of the basis vectors of `B' under the $p$-map.
##
DeclareAttribute( "PthPowerImages", IsBasis );


#############################################################################
##
#A  NonNilpotentElement( <L> )
##
##  A non-nilpotent element of a Lie algebra <L> is an element $x$ such that
##  $ad x$ is not nilpotent.
##  If <L> is not nilpotent, then by Engel's theorem non nilpotent elements
##  exist in <L>.
##  In this case this function returns a non nilpotent element of <L>,
##  otherwise (if <L> is nilpotent) `fail' is returned.
##
DeclareAttribute( "NonNilpotentElement",
    IsAlgebra and IsLieAlgebra );
DeclareSynonym( "NonLieNilpotentElement", NonNilpotentElement);


#############################################################################
##
#A  AdjointAssociativeAlgebra( <L>, <K> )
##
##  is the associative matrix algebra (with 1) generated by the 
##  matrices of the adjoint representation of the subalgebra <K> on the Lie 
##  algebra <L>.
##
DeclareOperation( "AdjointAssociativeAlgebra",
    [IsAlgebra and IsLieAlgebra, IsAlgebra and IsLieAlgebra] );

#############################################################################
##
#A  LieNilRadical( <L> )
##
##  This function calculates the (Lie) nil radical of the Lie algebra
##  <L>.
##
DeclareAttribute( "LieNilRadical", IsAlgebra and IsLieAlgebra );


#############################################################################
##
#A  LieSolvableRadical( <L> )
##
##  Returns the (Lie) solvable radical of the Lie algebra <L>.
##
DeclareAttribute( "LieSolvableRadical",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#A  SemiSimpleType( <L> )
##
##  Let <L> be a semisimple Lie algebra, i.e., a direct sum of simple
##  Lie algebras. Then `SemiSimpleType' returns the type of <L>, i.e.,
##  a string containing the types of the simple summands of <L>.
##
##
DeclareAttribute( "SemiSimpleType",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#O  LieCentralizer( <L>, <S> )
##
##  is the annihilator of <S> in the Lie algebra <L>, that is, the set
##  $\{ a \in L; \forall s\in S:a\*s = 0\}$.
##  Here <S> may be a subspace or a subalgebra of <L>.
##
DeclareOperation( "LieCentralizer",
    [ IsAlgebra and IsLieAlgebra, IsVectorSpace ] );


#############################################################################
##
#A  LieCentralizerInParent( <S> )
##
##  is the Lie centralizer of the vector space <S> in its parent Lie algebra
##  $L$.
##
DeclareAttribute( "LieCentralizerInParent",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#O  LieNormalizer( <L>, <U> )
##
##  is the normalizer of the subspace <U> in the Lie algebra <L>,
##  that is, the set $N_L(U) = \{ x \in L; [x,U] \subset U \}$.
##
DeclareOperation( "LieNormalizer",
    [ IsAlgebra and IsLieAlgebra, IsVectorSpace ] );


#############################################################################
##
#A  LieNormalizerInParent( <S> )
##
##  is the Lie normalizer of the vector space <S> in its parent Lie algebra
##  $L$.
##
DeclareAttribute( "LieNormalizerInParent",
    IsAlgebra and IsLieAlgebra );


#############################################################################
##
#O  AdjointMatrix( <B>, <x> )
##
##  is the matrix of the adjoint representation of the element <x> w.r.t.
##  the basis <B>. The adjoint map is the left multiplication by <x>.
##  The $i$-th column of the resulting matrix represents the image of the
##  the $i$-th basis vector of <B> under left multiplication by <x>. 
##
DeclareOperation( "AdjointMatrix", [ IsBasis, IsRingElement ] );


#############################################################################
##
#O  KappaPerp( <L>, <U> )
##
##  is the orthogonal complement of the subspace <U> of the Lie algebra <L>
##  with respect to the Killing form $\kappa$, that is,
##  the set $U^{\perp} = \{ x \in L; \kappa (x,y)=0 \hbox{ for all } 
##  y\in L \}$.
##
##  $U^{\perp}$ is a subspace of <L>, and if <U> is an ideal of <L> then
##  $U^{\perp}$ is a subalgebra of <L>.
##
DeclareOperation( "KappaPerp",
    [ IsAlgebra and IsLieAlgebra, IsVectorSpace ] );


#############################################################################
##
#O  PowerSi( <one>, <i> )
#A  PowerS( <L> )
##
##  <one> is the identity in a field $F$ of characteristic $p$.
##  The $p$-th power map of a restricted Lie algebra over $F$
##  satisfies the following relation.
##  $(x+y)^{[p]} = x^{[p]} + y^{[p]} + \sum_{i=1}^{p-1} s_i(x,y)$
##  where $i s_i(x,y)$ is the coefficient of $T^{i-1}$ in the polynomial
##  $( ad (Tx+y) )^{p-1} (x)$ (see Jacobson, p. 187f.).
##  From this it follows that
##  $i s_i(x,y) = \sum [ \ldots [[[x,y],a_1],a_2]\ldots, a_{p-2}]$ where
##  $a_j$ is $x$ or $y$ where the sum is taken over all words
##  $w = a_1 \cdots a_n$ such that $w$ contains $i-1$ $x$'s and $p-2-i+1$
##  $y$'s.
##
##  `PowerSi' returns the function $s_i$, which only depends on $p$ and
##  $i$ and not on the Lie algebra or on $F$.
##
##  `PowerS' returns the list $[ s_1, \ldots, s_{p-1} ]$ of all s-functions
##  as computed by `PowerSi'.
##
DeclareGlobalFunction( "PowerSi" );

DeclareAttribute( "PowerS", IsAlgebra and IsLieAlgebra );


#############################################################################
##
#O  PthPowerImage( <B>, <x> )
##
##  <B> is a basis of a restricted Lie algebra $L$.
##  This function calculates for an element <x> of $L$ the image of <x>
##  under the $p$-map.
##
DeclareOperation( "PthPowerImage", [ IsBasis, IsRingElement ] );


#############################################################################
##
#O  FindSl2( <L>, <x> )
##
##  This function tries to find a subalgebra $S$ of the Lie algebra <L> with
##  $S$ isomorphic to $sl_2$ and such that the nilpotent element <x> of <L>
##  is contained in $S$.
##  If such an algebra exists then it is returned,
##  otherwise `fail' is returned.
##
DeclareGlobalFunction( "FindSl2" );


##############################################################################
##
#A  RootSystem( <L> )
##
##  `RootSystem' calculates the root system of the semisimple Lie algebra
##  <L> with a split Cartan subalgebra.
##  The output is a record with the following components:
## \beginlist
##  \item{-} `roots' 
##    the set of roots of <L> with respect to the Cartan subalgebra that
##    is output by `CartanSubalgebra( <L> )'. First the positive roots
##    are listed according to increasing height. The second half of the list
##    consists of the negative roots.
##  \item{-} `rootvecs'
##    the set of elements of <L> that are root vectors corresponding to the
##    roots in `roots' (i.e., the first vector spanns the root space
##    corresponding to the forst root in `roots' and so on).
##  \item{-} `fundroots'
##    a set of fundamental roots
##  \item{-} `cartanmat'
##    the Cartan matrix of the set of fundamental roots.
##  \endlist
##
DeclareAttribute( "RootSystem", IsAlgebra and IsLieAlgebra );


##############################################################################
##
#F  SimpleLieAlgebra( <type>, <n>, <F> )
##
##
##  This function constructs the simple Lie algebra of type <type> and
##  of rank <n> over the field <F>.
##
##  <type> must be one of A, B, C, D, E, F, G,
##  H, K, S, W. For the types A to G, <n> must be a positive integer.
##  The last four types only exist over fields of characteristic $p>0$.
##  If the type is H, then <n> must be a list of positive integers of 
##  even length.
##  If the type is K, then <n> must be a list of positive integers of odd 
##  length.
##  For the other types, S and W, <n> must be a list of positive integers
##  of any length. In some cases the Lie algebra returned by this function
##  is not simple. Examples are the Lie algebras of type $A_n$ over a field
##  of characteristic $p>0$ where $p$ divides $n+1$, and the Lie algebras
##  of type $K_n$ where $n$ is a list of length 1.
##
DeclareGlobalFunction( "SimpleLieAlgebra" );


#############################################################################
##
#F  DescriptionOfNormalizedUEAElement( <T>, <listofpairs> )
##
##  <T> is the structure constants table of a finite dim. Lie algebra $L$.
##
##  <listofpairs> is a list of the form
##  $[ l_1, c_1, l_2, c_2, \ldots, l_n, c_n ]$
##  where the $c_i$ are coefficients and the $l_i$ encode monomials
##  $x_{i_1}^{e_1} x_{i_2}^{e_2} \cdots x_{i_m}^{e_m}$ as lists
##  $[ i_1, e_1, i_2, e_2, \ldots, i_m, e_m ]$.
##  (All $e_k$ are nonzero.)
##  Here the generator $x_k$ of the universal enveloping algebra corresponds
##  to the $k$-th basis vector of $L$.
##
##  `DescriptionOfNormalizedUEAElement' applies successively the rewriting
##  rules of the universal enveloping algebra of $L$ such that the final
##  value descibes the same element as <listofpairs>, each monomial is
##  normalized, and the monomials are ordered lexicographically.
##  This list is the return value.
##
DeclareGlobalFunction(
    "DescriptionOfNormalizedUEAElement" );


#############################################################################
##
#A  UniversalEnvelopingAlgebra( <L> ) . . . . . . . . . . . for a Lie algebra
##
##  Returns the universal enveloping algebra of the Lie algebra <L>.
##  The elements of this algebra are written on a Poincare-Birkhoff-Witt
##  basis.
##
DeclareAttribute(
    "UniversalEnvelopingAlgebra",
    IsLieAlgebra );


#############################################################################
##
#F  FreeLieAlgebra( <R>, <rank> )
#F  FreeLieAlgebra( <R>, <rank>, <name> )
#F  FreeLieAlgebra( <R>, <name1>, <name2>, ... )
##
##  Returns a free Lie algebra of rank <rank> over the ring <R>. 
##  `FreeLieAlgebra( <R>, <name1>, <name2>,...)' returns a free Lie algebra
##  over <R> with generators named <name1>, <name2>, and so on.
##  The elements of a free Lie algebra are written on the Hall-Lyndon
##  basis.
##  
DeclareGlobalFunction( "FreeLieAlgebra" );


#############################################################################
##
#C  IsFamilyElementOfFreeLieAlgebra( <Fam> )
##
##  We need this for the normalization method, which takes a family as first
##  argument.
##
DeclareCategory( "IsFamilyElementOfFreeLieAlgebra",
    IsElementOfMagmaRingModuloRelationsFamily );

#############################################################################
##
#C  IsFptoSCAMorphism( <map> )  
##
##  A morphism from a finitely presented algebra to an isomorphic
##  structure constants algebra. Needs a special method for image
##  because the default method tries to compute a basis of the source.
##
DeclareCategory( "IsFptoSCAMorphism", IsAlgebraGeneralMapping and IsTotal and 
                                      IsSingleValued );

##############################################################################
##
#F  FpLieAlgebraByCartanMatrix( C )
##
##
##  Here <C> must be a Cartan matrix. The function returns the 
##  finitely-presented Lie algebra over the field of rational numbers 
##  defined by this Cartan matrix. By Serre's theorem, this Lie algebra is a 
##  semisimple Lie algebra, and its root system has Cartan matrix <C>.
##
DeclareGlobalFunction( "FpLieAlgebraByCartanMatrix" );


#############################################################################
##
#F  FpLieAlgebraEnumeration( <FpL> )
#F  FpLieAlgebraEnumeration( <FpL>, <max>, <weights>, <ishom> )
##
##  When called with one argument, which is a finitely presented Lie 
##  algebra, this function computes a homomorphism to an sc algebra.
##  More arguments can be used to compute nilpotent quotients (see comments
##  to this function in the file alglie.gi).
##
DeclareGlobalFunction( "FpLieAlgebraEnumeration" );

#############################################################################
##
#F  NilpotentQuotientOfFpLieAlgebra( <FpL>, <max> )
#F  NilpotentQuotientOfFpLieAlgebra( <FpL>, <max>, <weights> )
##
##  
##  Here <FpL> is a finitely presented Lie algebra. Let $K$ be the
##  quotient of <FpL> by the <max>+1-th term of its lower central series.
##  This function calculates a surjective homomorphism of <FpL> onto $K$.
##  When called with the third argument <weights>, the $k$-th generator of
##  <FpL> gets assigned the $k$-th element of the list <weights>. In that
##  case a quotient is calculated of <FpL> by the ideal generated by all 
##  elements of weight <max>+1. If the list <weights> only consists of
##  $1$'s then the two calls are equivalent. The default value of 
##  <weights> is a list (of length equal to the number of generators of
##  <FpL>) consisting of $1$'s.\par
##  If the relators of <FpL> are homogeneous, then the resulting 
##  algebra is naturally graded. 
## 
DeclareGlobalFunction( "NilpotentQuotientOfFpLieAlgebra" );

##############################################################################
##
#A  JenningsLieAlgebra( G )
##
##  Let $G$ be a $p$-group, and let $G=G_1\supset G_2\supset \cdots 
##  \supset G_m=1$
##  be its Jennings series. Then the quotients $G_i/G_{i+1}$ are elementary
##  Abelian p-groups, i.e., they are isomorphic to vector spaces over $GF_p$.
##  Now the Jennings-Lie algebra $L$ of $G$ is the direct sum of those vector
##  spaces. The Lie bracket on $L$ is induced by the commutator in $G$. 
##  Furthermore, the map $g\mapsto g^p$ in $G$ induces a $p$-map in $L$
##  making $L$ into a restricted Lie algebra. In the canonical basis of $L$
##  this $p$-map is added as an attribute. A Lie algebra created by
##  `JenningsLieAlgebra( <G> )' is naturally graded. The attribute
##  `Grading' is set.
##

DeclareAttribute( "JenningsLieAlgebra", IsGroup );

#############################################################################
##
#E  alglie.gd . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here









