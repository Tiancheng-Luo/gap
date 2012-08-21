#############################################################################
##
#W  basismut.gd                 GAP library                     Thomas Breuer
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1996,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This file declares the categories and operations for mutable bases.
#1
##  It is useful to have a *mutable basis* of a free module when successively
##  closures with new vectors are formed, since one does not want to create
##  a new module and a corresponding basis for each step.
##  
##  Note that the situation here is different from the situation with
##  stabilizer chains, which are (mutable or immutable) records that do not
##  need to know about the groups they describe.
##  There are several reasons to store the underlying module
##  in an immutable basis.
##
##  \beginlist
##  \item{-}
##      One cannot have bases without vectors if the module is not stored.
##      (The call `BasisOfDomain( <V> )' may return such a basis.)
##
##  \item{-}
##      In some cases it is cheaper to compute coefficients only after a
##      (positive) membership test, which is a question to the module.
##      This occurs for example for finite fields and cyclotomic fields,
##      of course it is not allowed where `Coefficients' is used to
##      implement the membership test.
##  \endlist
## 
##  So immutable bases and mutable bases are different categories of objects.
##  The only thing they have in common is that one can ask both for
##  their basis vectors and for the coefficients of a given vector.
##  
##  Since `Immutable' produces an immutable copy of any {\GAP} object,
##  it would in principle be possible to construct a mutable basis that
##  is in fact immutable.
##  In the sequel, we will deal only with mutable bases that are in fact
##  mutable {\GAP} objects.
##
##  A mutable basis of a free left module is
##  \beginlist
##  \item{-}
##      an object in `IsMutable'
##      (hence unable to store attributes and properties)
##
##  \item{-}
##      that is constructed by `MutableBasis',
##
##  \item{-}
##      that can be asked for the number of basis vectors by
##      `NrBasisVectors',
##
##  \item{-}
##      that can be asked for membership of an element by
##      `IsContainedInSpan',
##
##  \item{-}
##      that can be first argument of `Coefficients' and `BasisVectors',
##
##  \item{-}
##      that can be modified by `CloseMutableBasis' 
##      (whose methods have to guarantee consistency),
##
##  \item{-}
##      for which one can eventually get an immutable basis with same
##      basis vectors by `ImmutableBasis',
##
##  \item{-}
##      and for which `ShallowCopy' returns a mutable plain list
##      containing the current basis vectors.
##  \endlist
##  
##  Since mutable bases do not admit arbitrary changes of their lists of
##  basis vectors, a mutable basis is *not* a list.
##  It is, however, a collection, more precisely its family is the family
##  of its collection of basis vectors.
##
##  Similar to the situation with bases,
##  {\GAP} supports three types of mutable bases, namely
##
##  \beginlist
##  \item{1.}
##      mutable bases that store an immutable basis;
##      this is the default of `MutableBasis',
##
##  \item{2.}
##      mutable bases that store a mutable basis for a nicer module;
##      this works if we have access to the mechanism of computing
##      nice vectors, and requires the construction with
##      `MutableBasisViaNiceMutableBasisMethod2' or
##      `MutableBasisViaNiceMutableBasisMethod3';
##      note that this is meaningful only if the mechanism of taking
##      nice/ugly vectors is invariant under closures of the basis,
##      which is the case for example if the vectors are elements of
##      structure constants algebras, matrices, or Lie objects,
##
##  \item{3.}
##      mutable bases that use special information to perform their tasks;
##      examples are mutable bases of Gaussian row and matrix spaces.
##  \endlist
##
##  The *constructor* for mutable bases is `MutableBasis'.
##
Revision.basismut_gd :=
    "@(#)$Id$";


#############################################################################
##
#C  IsMutableBasis( <obj> )
##
##  is `true' if <obj> is a mutable basis.
##
DeclareCategory( "IsMutableBasis", IsObject );


#############################################################################
##
#O  MutableBasis( <R>, <vectors> )
#O  MutableBasis( <R>, <vectors>, <zero> )
##
##  is a mutable basis for the <R>-free module generated by the vectors
##  in the list <vectors>.
##  The optional argument <zero> is the zero vector of the module.
##
##  *Note* that <vectors> will in general *not* be the basis vectors of the
##  mutable basis!
#T provide `AddBasisVector' to achieve this?
##
DeclareOperation( "MutableBasis", [ IsRing, IsCollection ] );

DeclareSynonym( "MutableBasisByGenerators", MutableBasis );
#T obsolete!


#############################################################################
##
#F  MutableBasisViaNiceMutableBasisMethod2( <R>, <vectors> )
#F  MutableBasisViaNiceMutableBasisMethod3( <R>, <vectors>, <zero> )
##
##  Let $M$ be the <R>-free left module generated by the vectors in the list
##  <vectors>, and assume that $M$ is handled via nice bases.
##  `MutableBasisViaNiceMutableBasisMethod?' returns a mutable basis for $M$.
##  The optional argument <zero> is the zero vector of the module.
##
##  *Note* that $M$ is stored, and that it is used in calls to `NiceVector'
##  and `UglyVector', and for accessing <R>.
##  (See the remark in the beginning of the file.)
##
DeclareGlobalFunction( "MutableBasisViaNiceMutableBasisMethod2" );

DeclareGlobalFunction( "MutableBasisViaNiceMutableBasisMethod3" );


#############################################################################
##
#O  NrBasisVectors( <MB> )
##
##  Is the number of basis vectors of <MB>.
##
DeclareOperation( "NrBasisVectors", [ IsMutableBasis ] );


#############################################################################
##
#O  ImmutableBasis( <MB> )
#O  ImmutableBasis( <MB>, <V> )
##
##  `ImmutableBasis' returns the immutable basis $B$ with the same basis
##  vectors as in the mutable basis <MB>.
##
##  If the second argument <V> is present then <V> is the underlying module
##  of $B$.
##  (This variant is used mainly for the case that one knows the module for
##  the desired basis in advance, and if it has a nicer structure than the
##  module known to <MB>;
##  this happens for example if one constructs a basis of an ideal using
##  iterated closures of a mutable basis, and the final basis $B$ shall
##  have the initial ideal as underlying module.)
##
DeclareOperation( "ImmutableBasis", [ IsMutableBasis ] );

DeclareOperation( "ImmutableBasis", [ IsMutableBasis, IsFreeLeftModule ] );


#############################################################################
##
#O  CloseMutableBasis( <MB>, <v> )
##
##  changes the mutable basis <MB> such that afterwards it describes the
##  span of the old basis vectors together with <v>.
##
##  *Note* that this does in general *not* mean that <v> is added to the
##  basis vectors of <MB> if <v> enlarges the dimension. Usually some
##  transformations are applied to keep the basis echelonized.
##
DeclareOperation( "CloseMutableBasis",
    [ IsMutableBasis and IsMutable, IsVector ] );


#############################################################################
##
#O  IsContainedInSpan( <MB>, <v> )
##
##  is `true' if the element <v> is contained in the module described by the
##  mutable basis <MB>, and `false' otherwise.
##
DeclareOperation( "IsContainedInSpan", [ IsMutableBasis, IsVector ] );


#############################################################################
##
#E

