#############################################################################
##
#W  semicong.gd                  GAP library                 Andrew Solomon
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This file contains the declaration for semigroup congruences.
##
Revision.semicong_gd :=
    "@(#)$Id$";

###########################################################################
##
#O  SemigroupCongruenceByGeneratingPairs(<s>,<list>)
##
##  create a semigroup congruence on <s> generated by the list
##  <list> of pairs.
##
DeclareSynonym("SemigroupCongruenceByGeneratingPairs",
	MagmaCongruenceByGeneratingPairs);

###########################################################################
##
#C  IsSemigroupCongruence(<c>)
##
##  a magma congruence <c> on a semigroup.
##
DeclareCategory("IsSemigroupCongruence", IsMagmaCongruence);

#############################################################################
##
#C  IsSemigroupCongruenceClassEnumerator(<S>)
##
DeclareCategory("IsSemigroupCongruenceClassEnumerator", IsDomainEnumerator);



###########################################################################
##
#P  IsReesCongruence(<c>)
##
##  returns true precisely when the congruence <c> has at most one
##  nonsingleton congruence class.
##
DeclareProperty("IsReesCongruence", IsSemigroupCongruence );

#############################################################################
##
#E

