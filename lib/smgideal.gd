#############################################################################
##
#W  smgideal.gd              GAP library                     Robert Arthur
##
##
#Y  Copyright (C)  1996,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St Andrews, Scotland
#Y  Copyright (C) 2002 The GAP Group
##
##  This file contains declarations relating to semigroup ideals.
##


#############################################################################
##
#O  SemigroupIdealByGenerators(<S>, <gens>)
##
##  <#GAPDoc Label="SemigroupIdealByGenerators">
##  <ManSection>
##  <Oper Name="SemigroupIdealByGenerators" Arg='S, gens'/>
##
##  <Description>
##  <A>S</A> is a semigroup, <A>gens</A> is a list of elements of <A>S</A>.
##  Returns the two-sided ideal of <A>S</A> generated by <A>gens</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareSynonym("SemigroupIdealByGenerators", MagmaIdealByGenerators );


#############################################################################
##
#P  IsLeftSemigroupIdeal(<I>)
#P  IsRightSemigroupIdeal(<I>)
#P  IsSemigroupIdeal(<I>)
##
##  <#GAPDoc Label="IsLeftSemigroupIdeal">
##  <ManSection>
##  <Prop Name="IsLeftSemigroupIdeal" Arg='I'/>
##  <Prop Name="IsRightSemigroupIdeal" Arg='I'/>
##  <Prop Name="IsSemigroupIdeal" Arg='I'/>
##
##  <Description>
##  Categories of semigroup ideals.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareProperty("IsLeftSemigroupIdeal", IsLeftMagmaIdeal );
DeclareProperty("IsRightSemigroupIdeal", IsRightMagmaIdeal );
DeclareProperty("IsSemigroupIdeal", IsMagmaIdeal );


#############################################################################
##
#A  ReesCongruenceOfSemigroupIdeal( <I> )
##
##  <#GAPDoc Label="ReesCongruenceOfSemigroupIdeal">
##  <ManSection>
##  <Attr Name="ReesCongruenceOfSemigroupIdeal" Arg='I'/>
##
##  <Description>
##  A two sided ideal <A>I</A> of a semigroup <A>S</A>  defines a congruence on 
##  <A>S</A> given by <M>\Delta \cup I \times I</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute("ReesCongruenceOfSemigroupIdeal", IsMagmaIdeal);


DeclareGlobalFunction( "EnumeratorOfSemigroupIdeal" );
DeclareGlobalFunction( "IsBound_LeftSemigroupIdealEnumerator" );
DeclareGlobalFunction( "IsBound_RightSemigroupIdealEnumerator" );


#############################################################################
##
#E

