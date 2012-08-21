#############################################################################
##
#W  algrep.gi                  GAP library               Willem de Graaf
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This file contains the methods for general modules over algebras.
##
Revision.algrep_gi :=
    "@(#)$Id$";


#############################################################################
##
#M  PrintObj( <obj> ) . . . . . . . . . . . . . . . . for an algebra module
#M  ViewObj( <obj> ) . . . . . . . . . . . . . . . .  for an algebra module
##
InstallMethod( PrintObj,
    "for algebra module",
    true, [ IsVectorSpace and IsAlgebraModule ], 0,
    function( V )

      if HasDimension( V ) then
         Print("<", Dimension(V), "-dimensional " );
      else
         Print( "<" );
      fi;
      if IsLeftAlgebraModuleElementCollection( V ) then
          if IsRightAlgebraModuleElementCollection( V ) then
              Print("bi-module over ");
              Print( LeftActingAlgebra( V ) );
              Print( " (left) and " );
              Print( RightActingAlgebra( V ) );
              Print( " (right)>" );
          else
              Print("left-module over ");
              Print( LeftActingAlgebra( V ) );
              Print(">");
          fi;
      else
          Print("right-module over ");
          Print( RightActingAlgebra( V ) );
          Print(">");
      fi;

  end );

  InstallMethod( ViewObj,
    "for algebra module",
    true, [ IsVectorSpace and IsAlgebraModule ], 0,
    function( V )

      if HasDimension( V ) then
         Print("<", Dimension(V), "-dimensional " );
      else
         Print( "<" );
      fi;
      if IsLeftAlgebraModuleElementCollection( V ) then
          if IsRightAlgebraModuleElementCollection( V ) then
              Print("bi-module over ");
              View( LeftActingAlgebra( V ) );
              Print( " (left) and " );
              View( RightActingAlgebra( V ) );
              Print( " (right)>" );
          else
              Print("left-module over ");
              View( LeftActingAlgebra( V ) );
              Print(">");
          fi;
      else
          Print("right-module over ");
          View( RightActingAlgebra( V ) );
          Print(">");
      fi;

end );

############################################################################
##
#M  ExtRepOfObj( <elm> )  . . . . . . . . . . . .  for algebra module elements
##
InstallMethod( ExtRepOfObj,
    "for algebra module element in packed element rep",
    true,
    [ IsAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
        elm -> elm![1] );

#############################################################################
##
#M  ObjByExtRep( <Fam>, <descr> ) . . . . . . . .  for algebra module elements
##
##
InstallMethod( ObjByExtRep,
    "for algebra module elements family, object",
    true,
    [ IsAlgebraModuleElementFamily, IsObject ], 0,
        function( Fam, vec )

    if Fam!.underlyingModuleEltsFam <> FamilyObj( vec ) then
        TryNextMethod();
    fi;
    return Objectify( Fam!.packedType, [ vec ] );
    end );



#############################################################################
##
#M  LeftAlgebraModule( <A>, <op>, <gens> ) . . .algebra, operation, generators
#M  LeftAlgebraModule( <A>, <op>, <gens>, "basis" ) . . if gens form a basis
##
##  The elements of an algebra module lie in the representation
##  `IsPackedElementDefaultRep': if <v> is an element of an algebra
##  module, then v![1] is an element of a vector space on which there
##  is an action of the algebra defined.
##
InstallMethod( LeftAlgebraModule,
    "for algebra, function of 2 args, module generators",
    true, [ IsAlgebra, IS_FUNCTION, IsHomogeneousList], 0,
    function( A, op, gens )

      local F,type,g,V;

      F:= LeftActingDomain( A );
      type:= NewType( NewFamily( "AlgModElementsFam",
                                    IsLeftAlgebraModuleElement ),
                       IsPackedElementDefaultRep );
      g:= List( gens, x -> Objectify( type, [ x ] ) );
      V:= Objectify( NewType( FamilyObj( g ),
                            IsLeftModule and IsAttributeStoringRep ),
                   rec() );
      SetLeftActingDomain( V, F );
      SetGeneratorsOfAlgebraModule( V, g );
      ElementsFamily( FamilyObj( V ) )!.left_operation:= op;
      ElementsFamily( FamilyObj( V ) )!.packedType:= type;
      ElementsFamily( FamilyObj( V ) )!.underlyingModuleEltsFam:=
                                              FamilyObj( gens[1] );
      SetZero( ElementsFamily( FamilyObj( V ) ), Zero( g[1] ) );
      FamilyObj( V )!.leftAlgebraElementsFam:= ElementsFamily( FamilyObj(A) );
      SetIsAlgebraModule( V, true );
      SetLeftActingAlgebra( V, A );
      return V;

  end );

InstallOtherMethod( LeftAlgebraModule,
    "for algebra, function of 2 args, generators, string",
    true, [ IsAlgebra, IS_FUNCTION, IsHomogeneousList, IsString], 0,
    function( A, op, gens, str )

      local F,type,g,V;

      if str<>"basis" then
         Error( "Usage: LeftAlgebraModule( <A>, <op>, <gens>, <str>) where the last argument is the string \"basis\"" );
      fi;

      F:= LeftActingDomain( A );
      type:= NewType( NewFamily( "AlgModElementsFam",
                                    IsLeftAlgebraModuleElement ),
                       IsPackedElementDefaultRep );
      g:= List( gens, x -> Objectify( type, [ x ] ) );
      V:= Objectify( NewType( FamilyObj( g ),
                  IsLeftModule and IsAttributeStoringRep ),
                  rec() );
      SetLeftActingDomain( V, F );
      SetGeneratorsOfAlgebraModule( V, g );
      SetZero( ElementsFamily( FamilyObj( V ) ), Zero( g[1] ) );
      ElementsFamily( FamilyObj( V ) )!.left_operation:= op;
      ElementsFamily( FamilyObj( V ) )!.packedType:= type;
      ElementsFamily( FamilyObj( V ) )!.underlyingModuleEltsFam:=
                                              FamilyObj( gens[1] );
      FamilyObj( V )!.leftAlgebraElementsFam:= ElementsFamily( FamilyObj(A) );
      SetIsAlgebraModule( V, true );
      SetLeftActingAlgebra( V, A );
      SetDimension( V, Length( g ) );
      SetBasisOfDomain( V, NewBasis( V, g ) );
      return V;

end );


#############################################################################
##
#M  RightAlgebraModule( <A>, <op>, <gens> ) . . .algebra, operation, generators
#M  RightAlgebraModule( <A>, <op>, <gens>, "basis" ) . . if gens form a basis
##
##  The elements of an algebra module lie in the representation
##  `IsPackedElementDefaultRep': if <v> is an element of an algebra
##  module, then v![1] is an element of a vector space on which there
##  is an action of the algebra defined.
##
InstallMethod( RightAlgebraModule,
    "for algebra, function of 2 args, module generators",
    true, [ IsAlgebra, IS_FUNCTION, IsHomogeneousList], 0,
    function( A, op, gens )

      local F,type,g,V;

      F:= LeftActingDomain( A );
      type:= NewType( NewFamily( "AlgModElementsFam",
                                    IsRightAlgebraModuleElement ),
                       IsPackedElementDefaultRep );
      g:= List( gens, x -> Objectify( type, [ x ] ) );
      V:= Objectify( NewType( FamilyObj( g ),
                  IsLeftModule and IsAttributeStoringRep ),
                  rec() );
      SetLeftActingDomain( V, F );
      SetGeneratorsOfAlgebraModule( V, g );
      SetZero( ElementsFamily( FamilyObj( V ) ), Zero( g[1] ) );
      ElementsFamily( FamilyObj( V ) )!.right_operation:= op;
      ElementsFamily( FamilyObj( V ) )!.packedType:= type;
      ElementsFamily( FamilyObj( V ) )!.underlyingModuleEltsFam:=
                                              FamilyObj( gens[1] );
      FamilyObj( V )!.rightAlgebraElementsFam:= ElementsFamily( FamilyObj(A) );
      SetIsAlgebraModule( V, true );
      SetRightActingAlgebra( V, A );
      return V;

end );


InstallOtherMethod( RightAlgebraModule,
    "for algebra, function of 2 args, generators, string",
    true, [ IsAlgebra, IS_FUNCTION, IsHomogeneousList, IsString], 0,
    function( A, op, gens, str )

      local F,type,g,V;

      if str<>"basis" then
         Error( "Usage: RightAlgebraModule( <A>, <op>, <gens>, <str>) where the last argument is the string \"basis\"" );
      fi;

      F:= LeftActingDomain( A );
      type:= NewType( NewFamily( "AlgModElementsFam",
                                    IsRightAlgebraModuleElement ),
                       IsPackedElementDefaultRep );
      g:= List( gens, x -> Objectify( type, [ x ] ) );
      V:= Objectify( NewType( FamilyObj( g ),
                  IsLeftModule and IsAttributeStoringRep ),
                  rec() );
      SetLeftActingDomain( V, F );
      SetGeneratorsOfAlgebraModule( V, g );
      SetZero( ElementsFamily( FamilyObj( V ) ), Zero( g[1] ) );
      ElementsFamily( FamilyObj( V ) )!.right_operation:= op;
      ElementsFamily( FamilyObj( V ) )!.packedType:= type;
      ElementsFamily( FamilyObj( V ) )!.underlyingModuleEltsFam:=
                                              FamilyObj( gens[1] );
      FamilyObj( V )!.rightAlgebraElementsFam:= ElementsFamily( FamilyObj(A) );
      SetIsAlgebraModule( V, true );
      SetRightActingAlgebra( V, A );
      SetDimension( V, Length( g ) );
      SetBasisOfDomain( V, NewBasis( V, g ) );
      return V;

  end );

#############################################################################
##
#M  BiAlgebraModule( <A>, <B>, <opl>, <opr>, <gens> )
#M  BiAlgebraModule( <A>, <B>, <opl>, <opr>, <gens>, "basis" )
##
##  The elements of an algebra module lie in the representation
##  `IsPackedElementDefaultRep': if <v> is an element of an algebra
##  module, then v![1] is an element of a vector space on which there
##  is an action of the algebra defined.
##
InstallMethod( BiAlgebraModule,
 "for 2 algebras, function of 2 args, function of 2 args, module generators",
     true,
     [ IsAlgebra, IsAlgebra, IS_FUNCTION, IS_FUNCTION, IsHomogeneousList], 0,
    function( A, B, opl, opr, gens )

      local F,type,g,V;

      F:= LeftActingDomain( A );
      type:= NewType( NewFamily( "AlgModElementsFam",
                          IsLeftAlgebraModuleElement and
                          IsRightAlgebraModuleElement ),
                       IsPackedElementDefaultRep );
      g:= List( gens, x -> Objectify( type, [ x ] ) );
      V:= Objectify( NewType( FamilyObj( g ),
                  IsLeftModule and IsAttributeStoringRep ),
                  rec() );
      SetLeftActingDomain( V, F );
      SetGeneratorsOfAlgebraModule( V, g );
      SetZero( ElementsFamily( FamilyObj( V ) ), Zero( g[1] ) );
      ElementsFamily( FamilyObj( V ) )!.left_operation:= opl;
      ElementsFamily( FamilyObj( V ) )!.right_operation:= opr;
      ElementsFamily( FamilyObj( V ) )!.packedType:= type;
      ElementsFamily( FamilyObj( V ) )!.underlyingModuleEltsFam:=
                                              FamilyObj( gens[1] );
      FamilyObj( V )!.leftAlgebraElementsFam:= ElementsFamily( FamilyObj(A) );
      FamilyObj( V )!.rightAlgebraElementsFam:= ElementsFamily( FamilyObj(B) );
      SetIsAlgebraModule( V, true );
      SetLeftActingAlgebra( V, A );
      SetRightActingAlgebra( V, B );
      return V;

  end );


InstallOtherMethod( BiAlgebraModule,
"for 2 algebras, function of 2 args, function of 2 args, generators, string",
true,
[ IsAlgebra, IsAlgebra, IS_FUNCTION, IS_FUNCTION, IsHomogeneousList, IsString],
        0,
    function( A, B, opl, opr, gens, str )

      local F,type,g,V;

      if str<>"basis" then
         Error( "Usage: RightAlgebraModule( <A>, <op>, <gens>, <str>) where the last argument is the string \"basis\"" );
      fi;

      F:= LeftActingDomain( A );
      type:= NewType( NewFamily( "AlgModElementsFam",
                                    IsLeftAlgebraModuleElement and
                                    IsRightAlgebraModuleElement ),
                       IsPackedElementDefaultRep );
      g:= List( gens, x -> Objectify( type, [ x ] ) );
      V:= Objectify( NewType( FamilyObj( g ),
                  IsLeftModule and IsAttributeStoringRep ),
                  rec() );
      SetLeftActingDomain( V, F );
      SetGeneratorsOfAlgebraModule( V, g );
      SetZero( ElementsFamily( FamilyObj( V ) ), Zero( g[1] ) );
      ElementsFamily( FamilyObj( V ) )!.left_operation:= opl;
      ElementsFamily( FamilyObj( V ) )!.right_operation:= opr;
      ElementsFamily( FamilyObj( V ) )!.packedType:= type;
      ElementsFamily( FamilyObj( V ) )!.underlyingModuleEltsFam:=
                                              FamilyObj( gens[1] );
      FamilyObj( V )!.leftAlgebraElementsFam:= ElementsFamily( FamilyObj(A) );
      FamilyObj( V )!.rightAlgebraElementsFam:= ElementsFamily( FamilyObj(B) );
      SetIsAlgebraModule( V, true );
      SetLeftActingAlgebra( V, A );
      SetRightActingAlgebra( V, B );
      SetDimension( V, Length( g ) );
      SetBasisOfDomain( V, NewBasis( V, g ) );
      return V;

end );

############################################################################
##
#R  IsMutableBasisViaUnderlyingMutableBasisRep( <B> )
##
DeclareRepresentation( "IsMutableBasisViaUnderlyingMutableBasisRep",
    IsComponentObjectRep,
        [ "moduleElementsFam", "underlyingMutableBasis" ] );

############################################################################
##
#M  MutableBasis( <R>, <vectors> )
#M  MutableBasis( <R>, <vectors>, <zero> )
##
##  Mutable bases of algebra modules delegate the work to corresponding
##  mutable bases of the underlying vector spaces.
##
InstallMethod( MutableBasis,
    "for ring and vectors",
    true,
    [ IsRing, IsAlgebraModuleElementCollection ], 0,
    function( R, vectors )
    local B;

    if ForAll( vectors, IsZero ) then
      return MutableBasis( R, [], vectors[1] );
    fi;

    B:= rec(
             moduleElementsFamily:= FamilyObj( vectors[1] ),
             underlyingMutableBasis:= MutableBasis( R,
                                        List( vectors, ExtRepOfObj ) )
            );

    return Objectify( NewType( FamilyObj( vectors ),
                                 IsMutableBasis
                             and IsMutable
                             and IsMutableBasisViaUnderlyingMutableBasisRep ),
                      B );
end );

InstallOtherMethod( MutableBasis,
    "for ring, list and zero",
    true,
    [ IsRing, IsList, IsAlgebraModuleElement ], 0,
    function( R, vectors, zero )
    local B;

    B:= rec(
             moduleElementsFamily:= FamilyObj( zero ),
             underlyingMutableBasis:= MutableBasis( R,
                                        List( vectors, ExtRepOfObj ),
                                        ExtRepOfObj( zero ) )
            );

    return Objectify( NewType( CollectionsFamily( FamilyObj( zero ) ),
                                   IsMutableBasis
                               and IsMutable
                               and IsMutableBasisViaUnderlyingMutableBasisRep ),
                      B );
end );

#############################################################################
##
#M  PrintObj( <MB> ) . . . . . . . . . . . . . . . . . .  view a mutable basis
##
InstallMethod( PrintObj,
    "for mutable basis with underlying mutable basis",
    true,
    [ IsMutableBasis and IsMutableBasisViaUnderlyingMutableBasisRep ], 0,
    function( MB )
    Print( "<mutable basis with " );
    Print( NrBasisVectors( MB ), " vectors>" );
    end );


############################################################################
##
#M  BasisVectors( <MB> )
#M  CloseMutableBasis( <MB>, <v> )
#M  IsContainedInSpan( <MB>, <v> )
##
InstallOtherMethod( BasisVectors,
    "for mutable basis with underlying mutable basis",
    true,
    [ IsMutableBasis and IsMutableBasisViaUnderlyingMutableBasisRep ], 0,
    function( MB )
    # return the basis vectors of the underlying mutable basis, wrapped up.
    return List( BasisVectors( MB!.underlyingMutableBasis ), x ->
       ObjByExtRep( MB!.moduleElementsFamily, x ));
end );

InstallMethod( CloseMutableBasis,
    "for mutable basis with underlying mutable basis, and vector",
    IsCollsElms,
    [ IsMutableBasis and IsMutable and
      IsMutableBasisViaUnderlyingMutableBasisRep, IsVector ], 0,
    function( MB, v )

       CloseMutableBasis( MB!.underlyingMutableBasis, ExtRepOfObj( v ) );

end );

InstallMethod( IsContainedInSpan,
    "for mutable basis with underlying mutable basis, and vector",
    IsCollsElms,
    [ IsMutableBasis and IsMutable and
      IsMutableBasisViaUnderlyingMutableBasisRep, IsVector ], 0,
    function( MB, v )

       return IsContainedInSpan( MB!.underlyingMutableBasis,
                   ExtRepOfObj( v ) );
end );

#############################################################################
##
#M  ActingAlgebra( <V> ) . . . . . . . . . . . . for an algebra module
##
InstallMethod( ActingAlgebra,
        "for an algebra module",
        true, [ IsAlgebraModule ], 0,
        function( V )

    if IsLeftAlgebraModuleElementCollection( V ) then
        if IsRightAlgebraModuleElementCollection( V ) then
            Error("ActingAlgebra is not defined for bi-modules");
        else
            return LeftActingAlgebra( V );
        fi;
    else
        return RightActingAlgebra( V );
    fi;
end );


#############################################################################
##
#M  PrintObj( <obj> ) . . . . . . . . . . . . . . . for algebra module element
##
InstallMethod( PrintObj,
    "for algebra module element in packed representation",
    true, [ IsAlgebraModuleElement and IsPackedElementDefaultRep], 0,
    function( v ) Print( v![1] ); end );

#############################################################################
##
#M  \=( <u>, <v> ) . . . . . . . . . . . . . . . for algebra module elements
#M  \<( <u>, <v> ) . . . . . . . . . . . . . . . for algebra module elements
#M  \+( <u>, <v> ) . . . . . . . . . . . . . . . for algebra module elements
#M  AINV( <u> ) . .. . . . . . . . . . . . . . . for an algebra module element
#M  \*( <u>, <scal> ) . . . . . . for an algebra module element and a scalar
#M  \*( <scal>, <u> ) . . . . . . for a scalar and an algebra module element
#M  ZeroOp( <u> ) . . . . . . . . . . . . . . . .for an algebra module element
##
##

InstallMethod(\=,
    "for two algebra module elements in packed representation",
    IsIdenticalObj, [ IsAlgebraModuleElement and IsPackedElementDefaultRep,
              IsAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
    function( u, v ) return u![1] = v![1]; end );

InstallMethod(\<,
    "for two algebra module elements in packed representation",
    IsIdenticalObj, [ IsAlgebraModuleElement and IsPackedElementDefaultRep,
              IsAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
    function( u, v ) return u![1] < v![1]; end );

InstallMethod(\+,
    "for two algebra module elements in packed representation",
    IsIdenticalObj, [ IsAlgebraModuleElement and IsPackedElementDefaultRep,
              IsAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
    function( u, v ) return Objectify( TypeObj( u ), [ u![1]+v![1] ] ); end );

InstallMethod(\+,
    "for an algebra module element in packed representation and a vector",
    true, [ IsAlgebraModuleElement and IsPackedElementDefaultRep,
              IsVector ], 0,
    function( u, v ) return Objectify( TypeObj( u ), [ u![1]+v ] ); end );


InstallMethod(\+,
    "for a vector and an algebra module element in packed representation",
    true, [ IsVector,
            IsAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
    function( u, v ) return Objectify( TypeObj( v ), [ u+v![1] ] ); end );

InstallMethod( AINV,
    "for an algebra module element in packed representation",
    true, [ IsAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
    function( u ) return Objectify( TypeObj(u), [ -u![1] ] ); end );

InstallMethod( \*,
    "for an algebra module element in packed representation and a scalar",
    true, [ IsAlgebraModuleElement and IsPackedElementDefaultRep,
            IsScalar ], 0,
    function( u, scal ) return Objectify( TypeObj(u), [ scal*u![1] ] );
    end );


InstallMethod( \*,
    "for a scalar and an algebra module element in packed representation",
    true, [ IsScalar, IsAlgebraModuleElement and IsPackedElementDefaultRep],0,
    function( scal, u ) return Objectify( TypeObj(u), [ scal*u![1] ] );
    end );

InstallMethod( ZeroOp,
    "for an algebra module element in packed representation",
    true, [ IsAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
    function( u ) return Objectify( TypeObj(u), [ 0*u![1] ] ); end );


#############################################################################
##
#M  \*( <obj>, <vec> ) . . . . . . . . . . . for a Lie object and a row vector
#M  \*( <vec>, <obj> ) . . . . . . . . . . . for a row vector and a Lie object
##
##
InstallMethod( \*,
    "for Lie object and row vector",
    true, [ IsLieObject and IsPackedElementDefaultRep, IsRowVector ], 0,
    function( m, v )
      return m![1]*v;
    end );

InstallMethod( \*,
    "for row vector and Lie object",
    true, [ IsRowVector, IsLieObject and IsPackedElementDefaultRep ], 0,
    function( v, m )
      return v*m![1];
    end );

#############################################################################
##
#M  \^( <a>, <v> ) . . . . . . . . . . . . for algebra elt, and elt of module
##
##  The action of an algebra element <a> on an element <v> of a left module
##  is denoted by <a>^<v>.
##
InstallOtherMethod( \^,
    "for an algebra element and an element of an algebra module",
    function( F1, F2 )
         return CollectionsFamily( F2 )!.leftAlgebraElementsFam = F1;
    end,
    [ IsRingElement,
          IsLeftAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
    function( x, u  )
        return Objectify( TypeObj( u ),
                       [ FamilyObj( u )!.left_operation(x,u![1])]);
end );

#############################################################################
##
#M  \^( <a>, <v> ) . . . . . . . . . . . . for algebra elt, and elt of module
##
##  The action of an algebra element <a> on an element <v> of a right module
##  is denoted by <v>^<a>.
##
InstallOtherMethod( \^,
    "for an algebra element and an element of an algebra module",
    function( F1, F2 )
         return CollectionsFamily( F1 )!.rightAlgebraElementsFam = F2;
    end,
    [ IsRightAlgebraModuleElement and IsPackedElementDefaultRep,
          IsRingElement ], 0,
    function( u, x  )
        return Objectify( TypeObj( u ),
                       [ FamilyObj( u )!.right_operation(u![1],x)]);
end );

#############################################################################
##
#M  NewBasis( <V>, <vecs> )  for space of algebra module elements
##                           and a list of elements thereof
##
##  Note that the work is delegated to a basis of the module
##  generated by the <v>![1] vectors, for <v> in <vecs>. This basis
##  is stored in the basis of the algebra module as <B>!.delegateBasis.
##
InstallOtherMethod( NewBasis,
    "for a space of algebra module elements, and homogeneous list",
    true,
    [ IsFreeLeftModule and IsAlgebraModuleElementCollection,
      IsList ], 0,
    function( V, vectors )
    local B, delmod;

    B:= Objectify( NewType( FamilyObj( V ),
                            IsBasis and
                            IsBasisOfAlgebraModuleElementSpace and
                            IsAttributeStoringRep ),
                   rec() );
    SetUnderlyingLeftModule( B, V );
    SetBasisVectors( B, vectors );
    if IsEmpty( vectors ) then
        delmod:= VectorSpace( LeftActingDomain(V), [ ],
                         ExtRepOfObj( Zero(V) ) );
        B!.delegateBasis:= Basis( delmod );
    else
        delmod:= VectorSpace( LeftActingDomain(V),
                         List( vectors, ExtRepOfObj ), "basis" );
        B!.delegateBasis:= Basis( delmod, List( vectors, ExtRepOfObj ) );
    fi;
    return B;
    end );


#############################################################################
##
#M  BasisOfDomain( <V> ) . . . . . . . . . . . . . . . for an algebra module
#M  BasisOfDomain( <V> ) . . . . . . . . . . . . . . . for a space of algebra
##                                                     module elements
##
InstallMethod( BasisOfDomain,
    "for an algebra module",
    true, [ IsFreeLeftModule and IsAlgebraModule ], 0,
    function( V )

      local A, gens, F, fam, B, vecs, from, op, ready;

      gens:= GeneratorsOfAlgebraModule( V );
      F:= LeftActingDomain( V );
      fam:= ElementsFamily( FamilyObj( V ) );
      if IsLeftAlgebraModuleElementCollection( V ) then
          if IsRightAlgebraModuleElementCollection( V ) then

              # We let the algebra act alternatingly from the left
              # and the right.
              vecs:= List( gens, ExtRepOfObj );
              from:= "left";
              op:= fam!.left_operation;
              ready:= false;
              A:= LeftActingAlgebra( V );

              while not ready do
                  B:= MutableBasisOfClosureUnderAction( F,
                              GeneratorsOfAlgebra( A ),
                              from,
                              vecs,
                              op,
                              ExtRepOfObj( Zero(V) ), "infinity" );
                  if Length( BasisVectors( B ) ) = Length( vecs ) and
                     from = "right" then
                      # from = "right", means that we acted both from the
                      # left and the right, and we did not find anything new.
                      # So we have a set of vectors closed under both the
                      # left and the right action.
                      ready:= true;
                  else
                      vecs:= BasisVectors( B );
                      if from = "left" then
                          from:= "right";
                          op:= fam!.right_operation;
                          A:= RightActingAlgebra( V );
                      else
                          from:= "left";
                          op:= fam!.left_operation;
                          A:= LeftActingAlgebra( V );
                      fi;
                  fi;

              od;

              vecs:= List( vecs, x -> ObjByExtRep( fam, x ) );
              SetDimension( V, Length( vecs ) );
              return NewBasis( V, vecs );

          else
              from:= "left";
              op:= fam!.left_operation;
              A:= LeftActingAlgebra( V );
          fi;
      else
          from:= "right";
          op:= fam!.right_operation;
          A:= RightActingAlgebra( V );
      fi;
      B:= MutableBasisOfClosureUnderAction( F,
                  GeneratorsOfAlgebra( A ),
                  from,
                  List( gens, ExtRepOfObj ),
                  op,
                  ExtRepOfObj( Zero(V) ), "infinity" );
      vecs:= List( BasisVectors(B), x -> ObjByExtRep( fam, x ) );
      SetDimension( V, Length( vecs ) );
      return NewBasis( V, vecs );
end );

InstallMethod( BasisOfDomain,
    "for a space of algebra module elements",
    true, [ IsFreeLeftModule and IsAlgebraModuleElementCollection ], 0,
    function( V )

    local   g,  fam,  B,  vecs;

    if HasIsAlgebraModule( V ) and IsAlgebraModule( V ) then
        TryNextMethod();
    fi;

    # In this case `V' is just a vector space of algebra module
    # elements, so there is no need to apply the action of an
    # algebra to get the basis.

    g:= List( GeneratorsOfLeftModule( V ), ExtRepOfObj );
    fam:= ElementsFamily( FamilyObj( V ) );
    B:= BasisOfDomain( VectorSpace( LeftActingDomain( V ), g ) );
    vecs:= List( BasisVectors(B), x -> ObjByExtRep( fam, x ) );
    return NewBasis( V, vecs );
end );




##############################################################################
##
#M  Coefficients( <B>, <v> ). . . . . . for basis of a space of algebra
##                                      module elements and vector
##
InstallMethod( Coefficients,
    "for basis of a space of algebra module elements, and algebra module element",
    true, [ IsBasisOfAlgebraModuleElementSpace,
            IsAlgebraModuleElement and IsPackedElementDefaultRep ], 0,
    function( B, v )

      return Coefficients( B!.delegateBasis, v![1] );
end );

##############################################################################
##
#M  Basis( <V>, <vecs> )
#M  BasisNC( <V>, <vecs> )
##
##  The basis of the space of algebra module elements <V> consisting of the
##  vectors in <vecs>.
##  In the NC version it is not checked whether the elements of <vecs> are
##  linearly independent.
##
InstallMethod( Basis,
    "for a space of algebra module elements and a collection of algebra module elements",
    IsIdenticalObj,
    [ IsFreeLeftModule and IsAlgebraModuleElementCollection,
      IsAlgebraModuleElementCollection and IsList ], 0,
    function( V, vectors )

     local W;

      if not ForAll( vectors, x -> x in V ) then return fail; fi;

      W:= VectorSpace( LeftActingDomain(V), List( vectors, ExtRepOfObj ) );
      if Dimension( W ) <> Length( vectors ) then return fail; fi;
      return NewBasis( V, vectors );
end );


InstallMethod( BasisNC,
    "for a space of algebra module elements and a collection of algebra module elements",
    IsIdenticalObj,
    [ IsFreeLeftModule and IsAlgebraModuleElementCollection,
      IsAlgebraModuleElementCollection and IsList ], 0,
    function( V, vectors )

      return NewBasis( V, vectors );
end );

##########################################################################
##
#M  IsFiniteDimensional( <V> ) . . . . . . .  . for a space of algebra module
##                                              elements
##
InstallMethod( IsFiniteDimensional,
        "for a space of algebra module elements",
        true, [ IsFreeLeftModule and IsAlgebraModuleElementCollection ], 0,
        function( V )

    return Length( Basis( V ) ) < infinity;
end );

##########################################################################
##
#M  GeneratorsOfLeftModule( <V> ) . . . . . . .  . for a space of algebra
##                                                 module elements
##
InstallMethod( GeneratorsOfLeftModule,
        "for a space of algebra module elements",
        true, [ IsFreeLeftModule and IsAlgebraModuleElementCollection ], 0,
        function( V )

    return BasisVectors( Basis( V ) );
end );

############################################################################
##
#M  SubAlgebraModule( <V>, <gens> [,<"basis">] )
##
##  Is the submodule of <V> generated by <gens>.
##
InstallMethod( SubAlgebraModule,
   "for algebra module, and a list of submodule generators",
   IsIdenticalObj, [ IsFreeLeftModule and IsAlgebraModule,
                     IsAlgebraModuleElementCollection and IsList ], 0,
   function( V, gens )

      local sub;

      sub:= Objectify( NewType( FamilyObj( V ),
                    IsLeftModule and IsAttributeStoringRep ), rec() );
      SetIsAlgebraModule( sub, true );
      SetLeftActingDomain( sub, LeftActingDomain( V ) );
      SetGeneratorsOfAlgebraModule( sub, gens );

      if HasIsFiniteDimensional( V ) and IsFiniteDimensional( V ) then
          SetIsFiniteDimensional( sub, true );
      fi;

      if IsLeftAlgebraModuleElementCollection( V ) then
          SetLeftActingAlgebra( sub, LeftActingAlgebra( V ) );
      fi;

      if IsRightAlgebraModuleElementCollection( V ) then
          SetRightActingAlgebra( sub, RightActingAlgebra( V ) );
      fi;

      return sub;

end );

InstallOtherMethod( SubAlgebraModule,
   "for algebra module, and a list of submodule generators, and string",
   function(F1,F2,F3) return IsIdenticalObj( F1, F2 ); end,
   [ IsFreeLeftModule and IsAlgebraModule,
     IsAlgebraModuleElementCollection and IsList,
     IsString ], 0,
   function( V, gens, str )

      local sub;

      if str<>"basis" then
         Error( "Usage: SubAlgebraModule( <V>, <gens>, <str>) where the last argument is string \"basis\"" );
      fi;

      sub:= Objectify( NewType( FamilyObj( V ),
                       IsLeftModule and IsAttributeStoringRep ), rec() );
      SetIsAlgebraModule( sub, true );
      SetLeftActingDomain( sub, LeftActingDomain( V ) );
      SetGeneratorsOfAlgebraModule( sub, gens );
      SetGeneratorsOfLeftModule( sub, gens );

      if IsLeftAlgebraModuleElementCollection( V ) then
          SetLeftActingAlgebra( sub, LeftActingAlgebra( V ) );
      fi;

      if IsRightAlgebraModuleElementCollection( V ) then
          SetRightActingAlgebra( sub, RightActingAlgebra( V ) );
      fi;

      SetBasisOfDomain( sub, NewBasis( sub, gens ) );
      SetDimension( sub, Length( gens ) );
      return sub;

end );

##############################################################################
##
#M  LeftModuleByHomomorphismToMatAlg( <A>, <f> ) . . for algebra and hom to
##                                                   matrix algebra
##
InstallMethod( LeftModuleByHomomorphismToMatAlg,
   "for an algebra and a homomorphism to a matrix algebra",
   true, [ IsAlgebra, IsAlgebraHomomorphism ], 0,
   function( A, f )

     local zero,bas;

     if not A = Source(f) then
        Error( "<A> must be the source of the homomorphism <f>" );
     fi;

     zero:= Zero( Range( f ) );
     if not IsMatrix( zero ) then
        Error( "the range of <f> must be a matrix algebra" );
     fi;

     bas:= IdentityMat( Length(zero), LeftActingDomain(A) );
     return LeftAlgebraModule( A, function( x, v ) return Image( f, x )*v; end,
                      bas, "basis");


   end );

##############################################################################
##
#M  RightModuleByHomomorphismToMatAlg( <A>, <f> ) . . for algebra and hom to
##                                                    matrix algebra
##
InstallMethod( RightModuleByHomomorphismToMatAlg,
   "for an algebra and a homomorphism to a matrix algebra",
   true, [ IsAlgebra, IsAlgebraHomomorphism ], 0,
   function( A, f )

     local zero,bas;

     if not A = Source(f) then
        Error( "<A> must be the source of the homomorphism <f>" );
     fi;

     zero:= Zero( Range( f ) );
     if not IsMatrix( zero ) then
        Error( "the range of <f> must be a matrix algebra" );
     fi;

     bas:= IdentityMat( Length(zero), LeftActingDomain(A) );
     return RightAlgebraModule( A, function( v, x ) return v*Image( f, x );
                                   end,
                      bas, "basis");


   end );

##############################################################################
##
#M  AdjointModule( <A> ) . . . . . . . . . . . . . . . . . . . for an algebra
##
##
InstallMethod( AdjointModule,
   "for an algebra",
   true, [ IsAlgebra ], 0,
   function( A )

    if IsFiniteDimensional( A ) and HasBasis( A ) then
       return LeftAlgebraModule( A, function( a, b ) return a*b; end,
                       BasisVectors( Basis( A ) ), "basis" );
    else
       return LeftAlgebraModule( A, function( a, b ) return a*b; end,
                       GeneratorsOfAlgebra( A ) );
    fi;

end );


#############################################################################
##
#M  FaithfulModule( <A> ) . . . . . . . . . . . . for an associative algebra
##
##
InstallMethod( FaithfulModule,
   "for an algebra",
   true, [ IsAlgebra ], 0,
   function( A )

    local   bb,  n,  BA,  F,  bv,  i,  M,  j,  col, B;

    if One( A ) <> fail then
        # the adjoint module is faithful.
        return AdjointModule( A );
    fi;

    # construct the adjoint representation of A on the algebra
    # gotten from A by adding a one (Dorroh extension).

    bb:= [];
    n:= Dimension( A );
    BA:= Basis( A );
    F:= LeftActingDomain( A );
    bv:= BasisVectors( BA );

    for i in [1..n] do
        M:=[];
        for j in [1..n] do
            col:= Coefficients( BA, bv[i] * bv[j] );
            col[n+1]:= Zero( F );
            Add( M, col );
        od;
        col:= [ 1 .. n+1 ] * Zero( F );
        col[i]:= One( F );
        Add( M, col );
        Add( bb, TransposedMat( M ) );
    od;

    B:= Algebra( Rationals, bb, "basis" );

    return LeftModuleByHomomorphismToMatAlg( A,
                   AlgebraHomomorphismByImages( A, B, bv, bb ) );

end );



#############################################################################
##
#M  ModuleByRestriction( <V>, <sub> ) . . .for an alg module and a subalgebra
#M  ModuleByRestriction( <V>, <sub>, <sub> ) for a bi-alg module and
##                                           two subalgebras
##
InstallMethod( ModuleByRestriction,
   "for an algebra module and a subalgebra",
   true, [ IsAlgebraModule, IsAlgebra ], 0,
   function( V, sub )

    local   gens, op;

    # Note that we need to take a basis of `V' as generators of the
    # `sub'-module; the module generators of `V' may not generate
    # `V' as a `sub'-module.

    gens:= List( Basis( V ), x -> ExtRepOfObj( x ) );

    if IsLeftAlgebraModuleElementCollection( V ) then
        if IsRightAlgebraModuleElementCollection( V ) then
            return ModuleByRestriction( V, sub, sub );
        fi;
        op:= ElementsFamily( FamilyObj( V ) )!.left_operation;
        return LeftAlgebraModule( sub, op, gens, "basis" );
    else
        op:= ElementsFamily( FamilyObj( V ) )!.right_operation;
        return RightAlgebraModule( sub, op, gens, "basis" );
    fi;

end );


InstallOtherMethod( ModuleByRestriction,
   "for a bi-algebra module and a subalgebra and a subalgebra",
    true, [ IsAlgebraModule, IsAlgebra, IsAlgebra ], 0,
    function( V, subl, subr )

    local  basis, gens;

    gens:= List( Basis( V ), x -> ExtRepOfObj( x ) );

    if IsLeftAlgebraModuleElementCollection( V ) then
        if IsRightAlgebraModuleElementCollection( V ) then
            return BiAlgebraModule( subl, subr,
                        ElementsFamily( FamilyObj( V ) )!.left_operation,
                        ElementsFamily( FamilyObj( V ) )!.right_operation,
                               gens, "basis" );
        else
            Error( "<V> must be a bi-module");
        fi;
    else
        Error( "<V> must be a bi-module");
    fi;

end );


########################################################################
##
#M  NaturalHomomorphismBySubAlgebraModule( <V>, <W> )
##
##
InstallMethod( NaturalHomomorphismBySubAlgebraModule,
        "for algebra module and a submodule",
        IsIdenticalObj, [ IsAlgebraModule, IsAlgebraModule ], 0,
        function( V, W )

    local   f,  quot,  left_op,  right_op,  bb,  qmod,  imgs, nathom;

    f:= NaturalHomomorphismBySubspace( V, W );
    quot:= ImagesSource( f );

    # We make V/W into an algebra module and produce new linear map from
    # V into this module, doing exactly the same as f does.

    if IsLeftAlgebraModuleElementCollection( V ) then
        if IsRightAlgebraModuleElementCollection( V ) then
            left_op:= function( x, v )
                return ImagesRepresentative( f,
                    ElementsFamily( FamilyObj( V ) )!.left_operation(x,
                               PreImagesRepresentative( f, v ) ) );
            end;
            right_op:= function( v, x )
                return ImagesRepresentative( f,
                    ElementsFamily( FamilyObj( V ) )!.right_operation(
                               PreImagesRepresentative( f, v ), x ) );
            end;
            bb:= BasisVectors( Basis( quot ) );
            qmod:= BiAlgebraModule( LeftActingAlgebra( V ),
                           RightActingAlgebra( V ),
                           left_op, right_op, bb, "basis" );
        else
            left_op:= function( x, v )
                return ImagesRepresentative( f,
                     ElementsFamily( FamilyObj( V ) )!.left_operation(x,
                           PreImagesRepresentative( f, v ) ) );
            end;
            bb:= BasisVectors( Basis( quot ) );
            qmod:= LeftAlgebraModule( LeftActingAlgebra( V ),
                           left_op, bb, "basis" );
        fi;
    else
        right_op:= function( v, x )
            return ImagesRepresentative( f,
                        ElementsFamily( FamilyObj( V ) )!.right_operation(
                               PreImagesRepresentative( f, v ), x ) );
        end;
        bb:= BasisVectors( Basis( quot ) );
        qmod:= RightAlgebraModule( RightActingAlgebra( V ),
                       right_op, bb, "basis" );
    fi;

    imgs:= List( Basis( V ), x -> Coefficients( Basis( quot ),
                   ImagesRepresentative(f,x)));
    nathom:= LeftModuleHomomorphismByMatrix( Basis( V ), imgs, Basis( qmod ) );
    SetIsSurjective( nathom, true );

    # Enter the preimages info.
    nathom!.basisimage:= Basis( qmod );
    nathom!.preimagesbasisimage:= f!.preimagesbasisimage;
    SetKernelOfAdditiveGeneralMapping( nathom, W );

    # Run the implications for the factor.
    UseFactorRelation( V, W, qmod );

    return nathom;

end );

#############################################################################
##
#M  \/( <V>, <W> )  . . . . . . .factor of a an algebra module by a submodule
#M  \/( <V>, <vectors> )  . . . .factor of a an algebra module by a submodule
##
InstallOtherMethod( \/,
        "for an algebra module and collection",
        IsIdenticalObj,
        [ IsVectorSpace and IsAlgebraModule, IsCollection ], 0,
        function( V, vectors )
    if IsAlgebraModule( vectors ) then
        TryNextMethod();
    else
        return V / SubAlgebraModule( V, vectors );
    fi;
end );

InstallOtherMethod( \/,
        "for two algebra modules",
        IsIdenticalObj,
        [ IsVectorSpace and IsAlgebraModule, IsAlgebraModule ], 0,
        function( V, W )
    return ImagesSource( NaturalHomomorphismBySubAlgebraModule( V, W ) );
end );


##############################################################################
##
#M  MatrixOfAction( <B>, <x> )
#M  MatrixOfAction( <B>, <x>, <side> )
##
InstallMethod( MatrixOfAction,
        "for a basis of an algebra module and an algebra element",
        true, [ IsBasisOfAlgebraModuleElementSpace, IsObject ], 0,
        function( B, x )


    if IsRightAlgebraModuleElementCollection( B ) then
        if IsLeftAlgebraModuleElementCollection( B ) then
            Error( "usage MatrixOfAction( <B>, <x>, <side> )" );
        fi;

        return List( B, b -> Coefficients( B, b^x ) );
    else
        return TransposedMatDestructive(
                       List( B, b -> Coefficients( B, x^b ) ) );
    fi;

end );

InstallOtherMethod( MatrixOfAction,
        "for a basis of an algebra module, an algebra element and a side",
        true, [ IsBasisOfAlgebraModuleElementSpace, IsObject, IsObject ], 0,
        function( B, x, side )


    if side = "right" then
        return List( B, b -> Coefficients( B, b^x ) );
    else
        return TransposedMatDestructive(
                       List( B, b -> Coefficients( B, x^b ) ) );
    fi;

end );


##############################################################################
##
#R  IsMonomialElementRep( <obj> )
##
##  A monomial element is a list of two components: the first component
##  is a list of the form [ t1, c1, t2, c2...] where the ci are coefficients,
##  and the ti are monomials (where the meaning of the word `monomial'
##  may differ according to the context).
##  The second component is `true' or `false',
##  `true' if the monomial element is in normal form, `false' otherwise.
##
DeclareRepresentation( "IsMonomialElementRep", IsPositionalObjectRep, [1,2] );


############################################################################
##
#M  ObjByExtRep( <fam>, <list> ) . . . for a MonomialElementFamily and a list
#M  ExtRepOfObj( <t> )  . . . . . . .  for a monomial element in monomial rep.
##
InstallMethod( ObjByExtRep,
        "for a family of monomial elements and a list",
        true, [ IsMonomialElementFamily, IsList] , 0,
        function( fam, list )
    return Objectify( fam!.monomialElementDefaultType,
                   [ Immutable( list ), false ] );
end );


InstallMethod( ExtRepOfObj,
        "for a monomial element",
        true, [ IsMonomialElement and IsMonomialElementRep ] , 0,
        function( t )  return t![1];
end );

##############################################################################
##
#M  ZeroOp( <m> ) . . . . . . . . . . . . . . for a monomial element
#M  \+( <m1>, <m2> )  . . . . . . . . . . . . for two monomial elements
#M  AINV( <m> ) . . . . . . . . . . . . . . . for a monomial element
#M  \*( <m>, <scal> ) . . . . . . . . . . for a monomial element and a scalar
#M  \*( <scal>, <m> ) . . . . . . . . . . for scalar and a monomial element
#M  \<( <m1>, <m2> ) . . . . . . . . . . . .  for two monomial elements
#M  \=( <m1>, <m2> ) . . . . . . . . . . . .  for two monomial elements
##
InstallMethod( ZeroOp,
        "for monomial elements",
        true, [ IsMonomialElement and IsMonomialElementRep ], 0,
        function( u )
    local res;
    res:= ObjByExtRep( FamilyObj( u ),
                  [ [], FamilyObj(u)!.zeroCoefficient ] );
    res![2]:= true;
    return res;
end );


InstallMethod(\+,
        "for monomial elements",
        IsIdenticalObj,
        [ IsMonomialElement and IsMonomialElementRep,
          IsMonomialElement and IsMonomialElementRep], 0,
        function( u, v )

    local lu,lv,zero, sum, res;

    # We assume that the monomials in the monomial elements are sorted
    # according to \<.

    lu:= u![1];
    lv:= v![1];
    zero:= FamilyObj( u )!.zeroCoefficient;
    sum:=  ZippedSum( lu, lv, zero, [\<,\+] );
    if sum = [ ] then sum:= [ [], zero ]; fi;
    res:= ObjByExtRep( FamilyObj( u ), sum );
    if u![2] and v![2] then res![2]:= true; fi;
    return res;

end );

InstallMethod( AINV,
        "for a monomial element",
        true,
        [ IsMonomialElement and IsMonomialElementRep ], 0,
        function( u )

    local lu,k,res;

    lu:= ShallowCopy( u![1] );
    for k in [2,4..Length(lu)] do
        lu[k]:= -lu[k];
    od;
    res:= ObjByExtRep( FamilyObj( u ), lu );
    if u![2] then res![2]:= true; fi;
    return res;

end );


InstallMethod(\*,
        "for a monomial element and a scalar",
        true,
        [ IsMonomialElement and IsMonomialElementRep, IsRingElement ], 0,
        function( u, scal )
    local lu,k,res;

    lu:= ShallowCopy( u![1] );
    for k in [2,4..Length(lu)] do
        lu[k]:= scal*lu[k];
    od;
    res:= ObjByExtRep( FamilyObj( u ), lu );
    if u![2] then res![2]:= true; fi;
    return res;

end );

InstallMethod(\*,
        "for a scalar and a monomial element",
        true,
        [ IsRingElement, IsMonomialElement and IsMonomialElementRep ], 0,
        function( scal, u  )
    local lu,k,res;

    lu:= ShallowCopy( u![1] );
    for k in [2,4..Length(lu)] do
        lu[k]:= scal*lu[k];
    od;
    res:= ObjByExtRep( FamilyObj( u ), lu );
    if u![2] then res![2]:= true; fi;
    return res;

end );


InstallMethod(\<,
        "for monomial elements",
        IsIdenticalObj,
        [ IsMonomialElement and IsMonomialElementRep,
          IsMonomialElement and IsMonomialElementRep], 0,
        function( u, v )
    local u1, v1;

    u1:= ConvertToNormalFormMonomialElement( u );
    v1:= ConvertToNormalFormMonomialElement( v );
    return u1![1] < v1![1];
end );

InstallMethod(\=,
        "for monomial elements",
        IsIdenticalObj,
        [ IsMonomialElement and IsMonomialElementRep,
          IsMonomialElement and IsMonomialElementRep], 0,
        function( u, v )

        local u1, v1;

    u1:= ConvertToNormalFormMonomialElement( u );
    v1:= ConvertToNormalFormMonomialElement( v );
    return u1![1] = v1![1];
end );

############################################################################
##
#F  TriangulizeMonomialElementList( <tt>, <zero>, <LM>, <LC> )
##
##  Here <tt> is a list of monomial elements, <zero> is the zero
##  of the ground field, <LM> is a function that calculates the
##  leading monomial of a monomial element (with respect to the ordering
##  \<), and <LC> is a function calculating the coefficient of the
##  leading monomial of a monomial element.
##
##  This function triangulizes the list <tt>, and returns a record with
##  the following components:
##
##  echelonbas: a list of basis vectors of the space spanned by <tt>,
##              in echelon form (with leading coefficients 1).
##
##  heads: a list of leading monomials of the elements of `echelonbas'.
##
##  basechange: a list of the same length as `ecelonbas' describing
##  the elements of `echlonbas' as linear combinations of the original
##  elements of `tt'. The elements of `basechange' are lists of the form
##  `[ l1, l2,...,lk ]', where the `li' are lists of the form `[ ind, cf ]';
##  the i-th element of `echelonbas' is the sum of `cf*tt[ind]'
##  when we loop over the entire list `basechange[i]'.
##
##  All of this is used to produce a basis of the space spaned by
##  `tt'.
##
TriangulizeMonomialElementList:= function( tt, zero, LM, LC )

    local   basechange,  heads,  k,  cf,  i,  head,  b,  b1,  pos;

    # Initially `basechange' is just the identity.
    # We sort `tt' to get the smallest leading monomials first.

    basechange:= List( [1..Length(tt)], x -> [ [ x, One( zero ) ] ] );
    SortParallel( tt, basechange,
            function( u, v ) return LM(u) < LM(v); end );

    heads:= [ ];
    k:= 1;

    # We perform a Gaussian elimination...

    while k <= Length( tt ) do

        if IsZero( tt[k] ) then

            # Get rid of it.
            Unbind( tt[k] );
            Unbind( basechange[k] );
            tt:= Filtered( tt, x -> IsBound( x ) );
            basechange:= Filtered( basechange, x -> IsBound( x ) );
        else

            # Eliminate all instances of `LM( tt[k] )' that occur `below'
            # `tt[k]'.
            cf:= LC( tt[k] );
            tt[k]:= (1/cf)*tt[k];
            for i in [1..Length(basechange[k])] do
                basechange[k][i][2]:= basechange[k][i][2]/cf;
            od;

            head:= LM( tt[k] );
            Add( heads, head );
            i:= k+1;
            while i <= Length(tt) do
                if LM( tt[i] ) = head then
                    cf:= LC( tt[i] );
                    tt[i]:= tt[i] - cf*tt[k];
                    if IsZero( tt[i] ) then

                        # Get rid of it.
                        Unbind( tt[i] );
                        Unbind( basechange[i] );
                        tt:= Filtered( tt, x -> IsBound( x ) );
                        basechange:= Filtered( basechange,
                                             x -> IsBound( x ) );
                    else

                        # Adjust the i-th entry in basechange, we basically
                        # subtract `cf' times the k-th entry of basechange.
                        for b in basechange[k] do
                            b1:= [ b[1], -cf*b[2] ];
                            pos:= PositionSorted( basechange[i], b1,
                                          function( x, y ) return x[1] < y[1];
                                      end );
                            if pos > Length( basechange[i] ) or
                                      basechange[i][pos][1] <> b1[1] then
                               InsertElmList(basechange[i],pos,b1 );
                            else
                               basechange[i][pos][2]:= basechange[i][pos][2]+
                                                                  b1[2];
                            fi;

                        od;
                        i:= i+1;
                    fi;
                else
                    i:= i+1;
                fi;
            od;
            k:= k+1;
        fi;
        # sort the lists again...
        SortParallel( tt, basechange,
                function( u, v ) return LM(u) < LM(v); end );
    od;

    return rec( echelonbas:= tt, heads:= heads, basechange:= basechange );

end;

#############################################################################
##
#R  IsBasisOfMonomialSpaceRep( <B> )
##
##  A basis of a monomial space knows the output of
##  `TriangulizeMonomialElementList' with its basis vectors as input.
##  It also knows the zero of the ground field.
##
DeclareRepresentation( "IsBasisOfMonomialSpaceRep", IsComponentObjectRep,
        [ "echelonBasis", "heads", "baseChange", "zeroCoefficient" ] );


#############################################################################
##
#M  NewBasis( <V>, <vecs> )  for space of monomial elements
##                           and a list of elements thereof
##
InstallOtherMethod( NewBasis,
    "for a space of monomial elements, and homogeneous list",
    true,
    [ IsFreeLeftModule and IsMonomialElementCollection,
      IsList ], 0,
    function( V, vectors )
    local B;

    B:= Objectify( NewType( FamilyObj( V ),
                            IsBasis and
                            IsBasisOfMonomialSpaceRep and
                            IsAttributeStoringRep ),
                   rec() );
    SetUnderlyingLeftModule( B, V );
    SetBasisVectors( B, vectors );

    return B;

end );


##############################################################################
##
#M  Basis( <V>, <vecs> )
#M  BasisNC( <V>, <vecs> )
##
##  The basis of the space of monomial elements <V> consisting of the
##  vectors in <vecs>.
##  In the NC version it is not checked whether the elements of <vecs> lie
##  in <V>.
##
##  In both cases the list of vectors <vecs> is triangulized, and the data
##  produced by this is stored in the basis.
##
InstallMethod( Basis,
    "for a space of monomial elements and a list of tensor elements",
    IsIdenticalObj,
    [ IsFreeLeftModule and IsMonomialElementCollection,
      IsMonomialElementCollection and IsList ], 0,
    function( V, vectors )

      local B, info;

      if not ForAll( vectors, x -> x in V ) then return fail; fi;

      # A call to `ConvertToNormalFormMonomialElement' makes sure
      # that all monomial elements
      # are in normal form, and that they are all sorted. So the leading
      # element is just the first element in the list etc.

      vectors:= List( vectors, x -> ConvertToNormalFormMonomialElement( x ) );
      info:= TriangulizeMonomialElementList( ShallowCopy( vectors ),
                     ElementsFamily(FamilyObj(V))!.zeroCoefficient,
                     x -> ExtRepOfObj(x)[1],
                     x -> ExtRepOfObj(x)[2] );
      if Length( info.echelonbas ) <> Length( vectors ) then return fail; fi;
      B:= NewBasis( V, vectors );
      B!.echelonBasis:= info.echelonbas;
      B!.heads:= info.heads;
      B!.baseChange:= info.basechange;
      B!.zeroCoefficient:= ElementsFamily(FamilyObj(V))!.zeroCoefficient;
      return B;
end );

InstallMethod( BasisNC,
    "for a space of monomial elements and a list of monomial elements",
    IsIdenticalObj,
    [ IsFreeLeftModule and IsMonomialElementCollection,
      IsMonomialElementCollection and IsList ], 0,
    function( V, vectors )

      local B, info;

      # A call to `ConvertToNormalFormMonomialElement' makes sure that
      # all monomial elements
      # are in normal form, and that they are all sorted. So the leading
      # element is just the first element in the list etc.

      vectors:= List( vectors, x -> ConvertToNormalFormMonomialElement( x ) );
      info:= TriangulizeMonomialElementList( ShallowCopy( vectors ),
                     ElementsFamily(FamilyObj(V))!.zeroCoefficient,
                     x -> ExtRepOfObj(x)[1],
                     x -> ExtRepOfObj(x)[2] );
      if Length( info.echelonbas ) <> Length( vectors ) then return fail; fi;
      B:= NewBasis( V, vectors );
      B!.echelonBasis:= info.echelonbas;
      B!.heads:= info.heads;
      B!.baseChange:= info.basechange;
      B!.zeroCoefficient:= ElementsFamily(FamilyObj(V))!.zeroCoefficient;
      return B;
end );

#############################################################################
##
#M  BasisOfDomain( <V> ) . . . . . . . . for a space of monomial elements
##
InstallMethod( BasisOfDomain,
    "for a space of monomial elements",
    true, [ IsFreeLeftModule and IsMonomialElementCollection ], 0,
    function( V )

    local B, vectors, info;

    vectors:= List( GeneratorsOfLeftModule(V), x ->
                    ConvertToNormalFormMonomialElement( x ) );
    info:= TriangulizeMonomialElementList( vectors,
                   ElementsFamily(FamilyObj(V))!.zeroCoefficient,
                   x -> ExtRepOfObj(x)[1],
                   x -> ExtRepOfObj(x)[2] );
    B:= NewBasis( V, info.echelonbas );
    B!.echelonBasis:= info.echelonbas;
    B!.heads:= info.heads;
    B!.baseChange:= List( [1..Length(info.echelonbas)], x -> [[ x, 1 ]] );
    B!.zeroCoefficient:= ElementsFamily(FamilyObj(V))!.zeroCoefficient;
    return B;

end );


##############################################################################
##
#M  Coefficients( <B>, <v> ). . . . . . for basis of a monomial space
##                                      and vector
##
InstallMethod( Coefficients,
    "for basis of a monomial space, and a vector",
        IsCollsElms, [ IsBasis and IsBasisOfMonomialSpaceRep,
                IsMonomialElement and IsMonomialElementRep], 0,
    function( B, v )

    local   w,  cf,  i,  b, c;

    # We use the echelon basis that comes with <B>.

    w:= ConvertToNormalFormMonomialElement( v );
    cf:= List( BasisVectors( B ), x -> B!.zeroCoefficient );
    for i in [1..Length(B!.heads)] do

        if IsZero( w ) then return cf; fi;

        if  w![1][1] < B!.heads[i] then
            return fail;
        elif w![1][1] = B!.heads[i] then
            c:= w![1][2];
            w:= w - c*B!.echelonBasis[i];
            for b in B!.baseChange[i] do
                cf[b[1]]:= cf[b[1]] + b[2]*c;
            od;
        fi;
    od;

    if not IsZero( w ) then return fail; fi;
    return cf;

end );

##############################################################################
##
#M  PrintObj( <te> ) . . . . . . . . . . . . . for tensor elements
##
##  The zero tenso is represented by `[ [], 0 ]'.
##
InstallMethod( PrintObj,
        "for tensor elements",
        true, [ IsTensorElement and IsMonomialElementRep ], 0,
        function( u )

    local   eu,  k,  i;

    eu:= u![1];

    if eu[1] = [] then
        Print("<0-tensor>");
    else

        for k in [1,3..Length(eu)-1] do
            Print( eu[k+1], "*(" );
            for i in [1..Length(eu[k])-1] do
                Print(eu[k][i],"<x>");
            od;
            Print( eu[k][Length(eu[k])], ")" );
            if k+1 <> Length( eu ) then
                if not ( IsRat( eu[k+3] ) and eu[k+3] < 0 ) then
                    Print("+");
                fi;
            fi;
        od;

    fi;

end );

##############################################################################
##
#M  ConvertToNormalFormMonomialElement( <te> ) . . for a tensor element
##
InstallMethod( ConvertToNormalFormMonomialElement,
        "for a tensor element",
        true, [ IsTensorElement ], 0,
        function( u )

    local   eu,  fam,  bases,  rank,  tensors,  cfts,  i,  le,  k,
            tt,  cf,  c,  is_replaced,  j,  tt1,  res, len;

    # We expand every component of every tensor in `u' wrt the bases
    # of the constituents of the tensor product. We assume those bases
    # are stored in the FamilyObj of the tensor element.

    if u![2] then return u; fi;

    eu:= ExtRepOfObj( u );
    fam:= FamilyObj( u );
    bases:= fam!.constituentBases;
    rank:= Length( bases );

    # `tensors' will be a list of tensors, i.e., a list of lists
    # of algebra module elements. `cfts' will be the list of their
    # coefficients.

    tensors:= List( eu{[1,3..Length(eu)-1]}, ShallowCopy );
    cfts:= eu{[2,4..Length(eu)]};

    for i in [1..rank] do

        # in all tensors expand the i-th component

        le:= Length( tensors );
        for k in [1..le] do
            tt:= ShallowCopy( tensors[k] );
            cf:= Coefficients( bases[i], tensors[k][i] );
            c:= cfts[k];

            # we replace the tensor on position `k', and add the rest
            # to the and of the list.

            is_replaced:= false;
            for j in [1..Length(cf)] do
                if cf[j] <> 0*cf[j] then
                    if not is_replaced then
                        tt1:= ShallowCopy( tt );
                        tt1[i]:= bases[i][j];
                        tensors[k]:= tt1;
                        cfts[k]:= c*cf[j];
                        is_replaced:= true;
                    else
                        tt1:= ShallowCopy( tt );
                        tt1[i]:= bases[i][j];
                        Add( tensors, tt1 );
                        Add( cfts, c*cf[j] );
                    fi;
                fi;
            od;
            if not is_replaced then
                # i.e., the tensor is zero, erase it
                Unbind( tensors[k] );
                Unbind( cfts[k] );
            fi;

        od;
        tensors:= Filtered( tensors, x -> IsBound( x ) );
        cfts:= Filtered( cfts, x -> IsBound( x ) );
    od;

    # Merge tensors and coefficients, take equal tensors together.
    SortParallel( tensors, cfts );
    res:= [ ];
    len:= 0;
    for i in [1..Length(tensors)] do
        if len > 0 and tensors[i] = res[len-1] then
            res[len]:= res[len]+cfts[i];
            if res[len] = 0*res[len] then
                Unbind( res[len-1] );
                Unbind( res[len] );
                len:= len-2;
            fi;
        else
            Add( res, tensors[i] );
            Add( res, cfts[i] );
            len:= len+2;
        fi;
    od;
    if res = [] then res:= [ [], fam!.zeroCoefficient ]; fi;

    res:= ObjByExtRep( fam, res );
    res![2]:= true;
    return res;

end );

##############################################################################
##
#M  TensorProduct( <list> ) . . . . for a list of Lie algebra modules.
##
InstallMethod( TensorProduct,
        "for a list of algebra modules",
        true, [ IsDenseList ], 0,
        function( list )

    local   left_lie_action,  right_lie_action,  F,  fam,  type,
            gens,  i,  gV,  gens1,  ten,  v,  ten1,  A,  B,  lefta,
            righta,  Tprod,  VT,  BT,  Bprod;

    # There are two types of actions on a tensor product: left and right.

    left_lie_action:= function( x, tn )

        local   res,  etn,  k,  i,  s;

        res:= [ ];
        etn:= tn![1];
        for k in [1,3..Length(etn)-1] do
            for i in [1..Length(etn[k])] do
                s:= ShallowCopy( etn[k] );
                s[i]:= x^s[i];
                Add( res, s );
                Add( res, etn[k+1] );
            od;
        od;
        return ConvertToNormalFormMonomialElement( ObjByExtRep( fam, res ) );
    end;

    right_lie_action:= function( tn, x )

        local   res,  etn,  k,  i,  s;

        res:= [ ];
        etn:= tn![1];
        for k in [1,3..Length(etn)-1] do
            for i in [1..Length(etn[k])] do
                s:= ShallowCopy( etn[k] );
                s[i]:= s[i]^x;
                Add( res, s );
                Add( res, etn[k+1] );
            od;
        od;
        return ConvertToNormalFormMonomialElement( ObjByExtRep( fam, res ) );
    end;

    # We first make the family of the tensor elements, and construct
    # a basis of the tensor space. Note that if the arguments do not
    # know how to compute bases, then the rewriting of tensors to normal
    # forms will fail. Hence we can assume that every module has a basis,
    # and therefore we have a basis of the tensor space as well.

    F:= LeftActingDomain( list[1] );
    fam:= NewFamily( "TensorElementsFam", IsTensorElement );
    type:= NewType( fam, IsMonomialElementRep );
    fam!.monomialElementDefaultType:= type;
    fam!.zeroCoefficient:= Zero( F );
    fam!.constituentBases:= List( list, BasisOfDomain );

    gens:= List( BasisOfDomain( list[1] ), x -> [ x ] );
    for i in [2..Length(list)] do
        gV:= BasisOfDomain( list[i] );
        gens1:= [ ];
        for i in [1..Length(gens)] do
            ten:= ShallowCopy( gens[i] );
            for v in gV do
                ten1:= ShallowCopy( ten );
                Add( ten1, v );
                Add( gens1, ten1 );
            od;
        od;
        gens:= gens1;
    od;

    gens:= List( gens, x -> ObjByExtRep( fam, [ x , One(F) ] ) );
    for i in [1..Length(gens)] do
        gens[i]![2]:= true;
    od;

    # Now we make the tensor module, we need to consider a few cases...

    if IsLeftAlgebraModuleElementCollection( list[1] ) then
        if IsRightAlgebraModuleElementCollection( list[1] ) then

            if not ForAll( list, V ->
                       IsLeftAlgebraModuleElementCollection(V) and
                       IsRightAlgebraModuleElementCollection(V)) then
              Error("for all modules the algebra must act om the same side");
            fi;

            A:= LeftActingAlgebra( list[1] );
            B:= RightActingAlgebra( list[1] );
            if not ForAll( list, V ->
                       IsIdenticalObj( LeftActingAlgebra(V), A ) and
                       IsIdenticalObj( RightActingAlgebra(V), B ) )
             then Error("all modules must have the same left acting algebra" );
            fi;

            if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
                lefta:= left_lie_action;
            else
                Error("tensor products are only defined for modules over Lie algebras");
            fi;

            if HasIsLieAlgebra( B ) and IsLieAlgebra( B ) then
                righta:= right_lie_action;
            else
                Error("tensor products are only defined for modules over Lie algebras");
            fi;

            Tprod:= BiAlgebraModule( A, B, lefta, righta, gens );
        fi;

        if not ForAll( list, IsLeftAlgebraModuleElementCollection ) then
            Error( "for all modules the algebra must act om the same side" );
        fi;

        A:= LeftActingAlgebra( list[1] );
        if not ForAll( list, V -> IsIdenticalObj( LeftActingAlgebra(V), A ) )
           then Error( "all modules must have the same left acting algebra" );
        fi;
        if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
            lefta:= left_lie_action;
        else
            Error("tensor products are only defined for modules over Lie algebras");
        fi;

        Tprod:= LeftAlgebraModule( A, lefta, gens );
    else

        if not ForAll( list, IsRightAlgebraModuleElementCollection ) then
            Error( "for all modules the algebra must act om the same side" );
        fi;

        A:= RightActingAlgebra( list[1] );
        if not ForAll( list, V -> IsIdenticalObj( RightActingAlgebra(V), A ) )
           then Error( "all modules must have the same left acting algebra" );
        fi;

        if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
            righta:= right_lie_action;
        else
            Error("tensor products are only defined for modules over Lie algebras");
        fi;

        Tprod:= RightAlgebraModule( A, righta, gens );
    fi;

    # We already know a basis of the tensor product, so we don't want
    # to construct this later on, and we don't want the method for
    # `NewBasis' for algebra modules to constuct this basis, because
    # this will result in a call to `Triangulize....' (and we already
    # know that our basis is triangular). So we basically do everything
    # ourselves.

    VT:= VectorSpace( F, gens );
    BT:= NewBasis( VT, gens );
    BT!.echelonBasis:= gens;
    BT!.baseChange:= List( [ 1..Length(gens)], x -> [ [ x, One(F) ] ] );
    BT!.heads:= List( gens, x -> ExtRepOfObj(x)[1] );
    BT!.zeroCoefficient:= Zero( F );
    Bprod:= Objectify( NewType( FamilyObj( Tprod ),
                    IsBasis and
                    IsBasisOfAlgebraModuleElementSpace and
                    IsAttributeStoringRep ),
                    rec() );
    SetUnderlyingLeftModule( Bprod, Tprod );
    SetBasisVectors( Bprod, GeneratorsOfAlgebraModule( Tprod ) );
    Bprod!.delegateBasis:= BT;
    SetBasis( Tprod, Bprod );
    SetDimension( Tprod, Length( gens ) );
    return Tprod;

end );

InstallOtherMethod( TensorProduct,
        "for two algebra modules",
        true, [ IsAlgebraModule, IsAlgebraModule ], 0,
        function( V, W )
    return TensorProduct( [V,W] );

end );


#############################################################################
##
#M  PrintObj( <we> ) . . . . . . . . . . . . . . for wedge elements
##
##  The zero wedge is represented by the list `[ [], 0 ]'.
##
InstallMethod( PrintObj,
        "for wedge elements",
        true, [ IsWedgeElement and IsMonomialElementRep ], 0,
        function( u )

    local   eu,  k,  i;

    eu:= u![1];

    if eu[1] = [] then
        Print("<0-wedge>");
    else

        for k in [1,3..Length(eu)-1] do
            Print( eu[k+1], "*(" );
            for i in [1..Length(eu[k])-1] do
                Print(eu[k][i],"/\\");
            od;
            Print( eu[k][Length(eu[k])], ")" );
            if k+1 <> Length( eu ) then
                if not ( IsRat( eu[k+3] ) and eu[k+3] < 0 ) then
                    Print("+");
                fi;
            fi;
        od;

    fi;

end );

###########################################################################
##
#M  ConvertToNormalFormMonomialElement( <we> ) . . . . for a wedge element
##
##
InstallMethod( ConvertToNormalFormMonomialElement,
        "for a wedge element",
        true, [ IsWedgeElement ], 0,
        function( u )

    local   eu,  fam,  basis,  rank,  tensors,  cfts,  wedge_inds,  i,
            le,  k,  tt,  cf,  c,  is_replaced,  j,  tt1,  ind,  perm,
            res,  len, wed;

    # We expand every component of every wedge in `u' wrt the basis
    # of the algebra module from which the exterior product was formed.

    if u![2] then return u; fi;

    eu:= ExtRepOfObj( u );
    fam:= FamilyObj( u );
    basis:= fam!.constituentBasis;
    rank:= fam!.rank;

    # `tensors' will be a list of wedges, i.e., a list of lists
    # of algebra module elements. `cfts' will be the list of their
    # coefficients.
    # `wedge_inds' will be a list of lists of indices in bijection
    # with `tensors'; if `wedge_inds[k] = [ 1, 2 ]' then `tensors[k]=
    # v1 /\ v2' wgere `v1' and `v2' are the first and second basis elements.

    tensors:= List( eu{[1,3..Length(eu)-1]}, ShallowCopy );
    cfts:= eu{[2,4..Length(eu)]};
    wedge_inds:= List( tensors, x -> [] );

    for i in [1..rank] do

        # in all wedges expand the i-th component

        le:= Length( tensors );
        for k in [1..le] do
            tt:= ShallowCopy( tensors[k] );
            cf:= Coefficients( basis, tensors[k][i] );
            c:= cfts[k];

            # we replace the wedge on position `k', and add the rest
            # to the and of the list.

            is_replaced:= false;
            for j in [1..Length(cf)] do
                if cf[j] <> 0*cf[j] then
                    if not is_replaced then
                        tt1:= ShallowCopy( tt );
                        tt1[i]:= basis[j];
                        tensors[k]:= tt1;
                        cfts[k]:= c*cf[j];
                        wedge_inds[k][i]:= j;
                        is_replaced:= true;
                    else
                        tt1:= ShallowCopy( tt );
                        tt1[i]:= basis[j];
                        Add( tensors, tt1 );
                        Add( cfts, c*cf[j] );
                        ind:= ShallowCopy( wedge_inds[k] );
                        ind[i]:= j;
                        Add( wedge_inds, ind );
                    fi;
                fi;
            od;
            if not is_replaced then
                # i.e., the wedge is zero, erase it
                Unbind( tensors[k] );
                Unbind( cfts[k] );
                Unbind( wedge_inds[k] );
            fi;

        od;
        tensors:= Filtered( tensors, x -> IsBound( x ) );
        cfts:= Filtered( cfts, x -> IsBound( x ) );
        wedge_inds:= Filtered( wedge_inds, x -> IsBound( x ) );
    od;

    # Merge wedges and coefficients, apply permutations to make the wedges
    # increasing, take equal wedges together.
    
    for i in [1..Length(tensors)] do
        
        # The tensors with duplicate entries are zero, we get rid of them.
        
        if not IsDuplicateFree( wedge_inds[i] ) then
            Unbind( wedge_inds[i] );
            Unbind( tensors[i] );
            Unbind( cfts[i] );
        else
            perm:= Sortex( wedge_inds[i] );
            tensors[i]:= Permuted( tensors[i], perm );
            cfts[i]:= SignPerm( perm )*cfts[i];
        fi;
        
    od;
    
    tensors:= Filtered( tensors, x -> IsBound(x) );
    wedge_inds:= Filtered( wedge_inds, x -> IsBound(x) );
    cfts:= Filtered( cfts, x -> IsBound(x) );
    
    perm:= Sortex( tensors );
    cfts:= Permuted( cfts, perm );
    wedge_inds:= Permuted( wedge_inds, perm );
    res:= [ ];
    len:= 0;
    for i in [1..Length(tensors)] do
        
        if len > 0 and tensors[i] = res[len-1] then
            res[len]:= res[len]+cfts[i];
            if res[len] = 0*res[len] then
                Unbind( res[len-1] );
                Unbind( res[len] );
                len:= len-2;
            fi;
        else
            Add( res, tensors[i] );
            Add( res, cfts[i] );
            len:= len+2;
        fi;
    od;
    if res = [] then res:= [ [], fam!.zeroCoefficient ]; fi;

    res:= ObjByExtRep( fam, res );
    res![2]:= true;
    return res;

end );


#############################################################################
##
#M  ExteriorPower( <V>, <k> ) . . . . . . for an algebra module and an integer
##
InstallMethod( ExteriorPower,
        "for an algebra module and an integer",
        true, [ IsAlgebraModule, IsInt ], 0,
        function( V, n )

    local   left_lie_action,  right_lie_action,  F,  fam,  type,
            combs,  gens,  i,  A,  B,  lefta,  righta,  Ext,  VT,  BT,
            Bprod;

    # There are two types of actions on an exterior power: left and right.

    left_lie_action:= function( x, tn )

        local   res,  etn,  k,  i,  s;

        res:= [ ];
        etn:= tn![1];
        for k in [1,3..Length(etn)-1] do
            for i in [1..Length(etn[k])] do
                s:= ShallowCopy( etn[k] );
                s[i]:= x^s[i];
                Add( res, s );
                Add( res, etn[k+1] );
            od;
        od;
        return ConvertToNormalFormMonomialElement( ObjByExtRep( fam, res ) );
    end;

    right_lie_action:= function( tn, x )

        local   res,  etn,  k,  i,  s;

        res:= [ ];
        etn:= tn![1];
        for k in [1,3..Length(etn)-1] do
            for i in [1..Length(etn[k])] do
                s:= ShallowCopy( etn[k] );
                s[i]:= s[i]^x;
                Add( res, s );
                Add( res, etn[k+1] );
            od;
        od;
        return ConvertToNormalFormMonomialElement( ObjByExtRep( fam, res ) );
    end;

    # We first make the family of the wedge elements, and construct
    # a basis of the exterior product. Note that if the arguments do not
    # know how to compute bases, then the rewriting of wedges to normal
    # forms will fail. Hence we can assume that every module has a basis,
    # and therefore we have a basis of the exterior power as well.

    F:= LeftActingDomain( V );
    fam:= NewFamily( "WedgeElementsFam", IsWedgeElement );
    type:= NewType( fam, IsMonomialElementRep );
    fam!.monomialElementDefaultType:= type;
    fam!.zeroCoefficient:= Zero( F );
    fam!.constituentBasis:= BasisOfDomain( V );
    fam!.rank:= n;

    combs:= Combinations( [1..Dimension(V)], n );
    gens:= List( combs, x -> BasisOfDomain(V){x} );
    if gens = [ ]  then
        gens[1] :=  ObjByExtRep( fam, [ [] , Zero(F) ] );
    else
        gens:= List( gens, x -> ObjByExtRep( fam, [ x , One(F) ] ) );
    fi;

    for i in [1..Length(gens)] do
        gens[i]![2]:= true;
    od;



    # Now we make the exterior module, we need to consider a few cases...

    if IsLeftAlgebraModuleElementCollection( V ) then
        if IsRightAlgebraModuleElementCollection( V ) then

            A:= LeftActingAlgebra( V );
            B:= RightActingAlgebra( V );

            if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
                lefta:= left_lie_action;
            else
                Error("exterior powers are only defined for modules over Lie algebras");
            fi;

            if HasIsLieAlgebra( B ) and IsLieAlgebra( B ) then
                righta:= right_lie_action;
            else
                Error("exterior powers are only defined for modules over Lie algebras");
            fi;

            Ext:= BiAlgebraModule( A, B, lefta, righta, gens );
        fi;

        A:= LeftActingAlgebra( V );
        if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
            lefta:= left_lie_action;
        else
            Error("exterior powers are only defined for modules over Lie algebras");
        fi;

        Ext:= LeftAlgebraModule( A, lefta, gens );
    else

        A:= RightActingAlgebra( V );

        if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
            righta:= right_lie_action;
        else
            Error("exterior powers are only defined for modules over Lie algebras");
        fi;

        Ext:= RightAlgebraModule( A, righta, gens );
    fi;

    # We already know a basis of the exterior power, so we don't want
    # to construct this later on, and we don't want the method for
    # `NewBasis' for algebra modules to constuct this basis, because
    # this will result in a call to `Triangulize....' (and we already
    # know that our basis is triangular). So we basically do everything
    # ourselves.

    if not ( Length( gens) = 1 and IsZero( gens[1] ) ) then
        VT:= VectorSpace( F, gens );
        BT:= NewBasis( VT, gens );
        BT!.echelonBasis:= gens;
        BT!.baseChange:= List( [ 1..Length(gens)], x -> [ [ x, One(F) ] ] );
        BT!.heads:= List( gens, x -> ExtRepOfObj(x)[1] );
        BT!.zeroCoefficient:= Zero( F );
        Bprod:= Objectify( NewType( FamilyObj( Ext ),
                        IsBasis and
                        IsBasisOfAlgebraModuleElementSpace and
                        IsAttributeStoringRep ),
                        rec() );
        SetUnderlyingLeftModule( Bprod, Ext );
        SetBasisVectors( Bprod, GeneratorsOfAlgebraModule( Ext ) );
        Bprod!.delegateBasis:= BT;
        SetBasis( Ext, Bprod );
        SetDimension( Ext, Length( gens ) );
    fi;

    return Ext;

end );

############################################################################
##
#M  PrintObj( <se> ) . . . . . . . . . . . for symmetric elements
##
InstallMethod( PrintObj,
        "for symmetric elements",
        true, [ IsSymmetricPowerElement and IsMonomialElementRep ], 0,
        function( u )

    local   eu,  k,  i;

    eu:= u![1];

    if eu[1] = [] then
        Print("<0-symmetric element>");
    else

        for k in [1,3..Length(eu)-1] do
            Print( eu[k+1], "*(" );
            for i in [1..Length(eu[k])-1] do
                Print(eu[k][i],".");
            od;
            Print( eu[k][Length(eu[k])], ")" );
            if k+1 <> Length( eu ) then
                if not ( IsRat( eu[k+3] ) and eu[k+3] < 0 ) then
                    Print("+");
                fi;
            fi;
        od;

    fi;

end );

############################################################################
##
#M  ConvertToNormalFormMonomialElement( <se> ) . . . for a symmetric element
##
InstallMethod( ConvertToNormalFormMonomialElement,
        "for a symmetric element",
        true, [ IsSymmetricPowerElement ], 0,
        function( u )

    local   eu,  fam,  basis,  rank,  tensors,  cfts,  symmetric_inds,  i,
            le,  k,  tt,  cf,  c,  is_replaced,  j,  tt1,  ind,  perm,
            res,  len, wed;

    # We expand every component of every symmetric elt in `u' wrt the basis
    # of the algebra module of which the symmetric product was formed.

    if u![2] then return u; fi;

    eu:= ExtRepOfObj( u );
    fam:= FamilyObj( u );
    basis:= fam!.constituentBasis;
    rank:= fam!.rank;

    # `tensors' will be a list of symmetric elements, i.e., a list of lists
    # of algebra module elements. `cfts' will be the list of their
    # coefficients.
    # `symmetric_inds' is a list of lists of indices, exactly analogous
    # to the list `wedge_inds' in the method for
    # `ConvertToNormalFormMonomialElement' for wedge elements.

    tensors:= List( eu{[1,3..Length(eu)-1]}, ShallowCopy );
    cfts:= eu{[2,4..Length(eu)]};
    symmetric_inds:= List( tensors, x -> [] );

    for i in [1..rank] do

        # in all tensor expand the i-th component

        le:= Length( tensors );
        for k in [1..le] do
            tt:= ShallowCopy( tensors[k] );
            cf:= Coefficients( basis, tensors[k][i] );
            c:= cfts[k];

            # we replace the symmetric element on position `k', and add the
            # rest to the and of the list.

            is_replaced:= false;
            for j in [1..Length(cf)] do
                if cf[j] <> 0*cf[j] then
                    if not is_replaced then
                        tt1:= ShallowCopy( tt );
                        tt1[i]:= basis[j];
                        tensors[k]:= tt1;
                        cfts[k]:= c*cf[j];
                        symmetric_inds[k][i]:= j;
                        is_replaced:= true;
                    else
                        tt1:= ShallowCopy( tt );
                        tt1[i]:= basis[j];
                        Add( tensors, tt1 );
                        Add( cfts, c*cf[j] );
                        ind:= ShallowCopy( symmetric_inds[k] );
                        ind[i]:= j;
                        Add( symmetric_inds, ind );
                    fi;
                fi;
            od;
            if not is_replaced then
                # i.e., the symmetric element is zero, erase it
                Unbind( tensors[k] );
                Unbind( cfts[k] );
                Unbind( symmetric_inds[k] );
            fi;

        od;
        tensors:= Filtered( tensors, x -> IsBound( x ) );
        cfts:= Filtered( cfts, x -> IsBound( x ) );
        symmetric_inds:= Filtered( symmetric_inds, x -> IsBound( x ) );
    od;

    # Merge symmetric elements and coefficients, apply permutations to make
    # the symmetric elements
    # increasing, take equal symmetric elements together.
    
    for i in [1..Length(tensors)] do
        
        perm:= Sortex( symmetric_inds[i] );
        tensors[i]:= Permuted( tensors[i], perm );
        
    od;
    
    perm:= Sortex( tensors );
    cfts:= Permuted( cfts, perm );
    symmetric_inds:= Permuted( symmetric_inds, perm );
    res:= [ ];
    len:= 0;
    for i in [1..Length(tensors)] do

        wed:= tensors[i];
        if len > 0 and wed = res[len-1] then
            res[len]:= res[len]+cfts[i];
            if res[len] = 0*res[len] then
                Unbind( res[len-1] );
                Unbind( res[len] );
                len:= len-2;
            fi;
        else
            Add( res, wed );
            Add( res, cfts[i] );
            len:= len+2;
        fi;
    od;
    if res = [] then res:= [ [], fam!.zeroCoefficient ]; fi;

    res:= ObjByExtRep( fam, res );
    res![2]:= true;
    return res;

end );

############################################################################
##
#M  SymmetricPower( <V>, <k> ) . . . . . for an algebra module and an integer
##
InstallMethod( SymmetricPower,
        "for an algebra module and an integer",
        true, [ IsAlgebraModule, IsInt ], 0,
        function( V, n )

    local   left_lie_action,  right_lie_action,  F,  fam,  type,
            combs,  gens,  i,  A,  B,  lefta,  righta,  Symm,  VT,
            BT,  Bsymm;

    # There are two types of actions on the symmetric power: left and right.

    left_lie_action:= function( x, tn )

        local   res,  etn,  k,  i,  s;

        res:= [ ];
        etn:= tn![1];
        for k in [1,3..Length(etn)-1] do
            for i in [1..Length(etn[k])] do
                s:= ShallowCopy( etn[k] );
                s[i]:= x^s[i];
                Add( res, s );
                Add( res, etn[k+1] );
            od;
        od;
        return ConvertToNormalFormMonomialElement( ObjByExtRep( fam, res ) );
    end;

    right_lie_action:= function( tn, x )

        local   res,  etn,  k,  i,  s;

        res:= [ ];
        etn:= tn![1];
        for k in [1,3..Length(etn)-1] do
            for i in [1..Length(etn[k])] do
                s:= ShallowCopy( etn[k] );
                s[i]:= s[i]^x;
                Add( res, s );
                Add( res, etn[k+1] );
            od;
        od;
        return ConvertToNormalFormMonomialElement( ObjByExtRep( fam, res ) );
    end;

    # We first make the family of the symmetric elements, and construct
    # a basis of the symmetric product. Note that if the arguments do not
    # know how to compute bases, then the rewriting of symmetrics to normal
    # forms will fail. Hence we can assume that every module has a basis,
    # and therefore we have a basis of the symmetric power as well.

    F:= LeftActingDomain( V );
    fam:= NewFamily( "SymmetricElementsFam", IsSymmetricPowerElement );
    type:= NewType( fam, IsMonomialElementRep );
    fam!.monomialElementDefaultType:= type;
    fam!.zeroCoefficient:= Zero( F );
    fam!.constituentBasis:= BasisOfDomain( V );
    fam!.rank:= n;

    combs:= UnorderedTuples( [1..Dimension(V)], n );
    gens:= List( combs, x -> BasisOfDomain(V){x} );
    gens:= List( gens, x -> ObjByExtRep( fam, [ x , One(F) ] ) );
    for i in [1..Length(gens)] do
        gens[i]![2]:= true;
    od;

    # Now we make the symmetric power, we need to consider a few cases...

    if IsLeftAlgebraModuleElementCollection( V ) then
        if IsRightAlgebraModuleElementCollection( V ) then

            A:= LeftActingAlgebra( V );
            B:= RightActingAlgebra( V );

            if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
                lefta:= left_lie_action;
            else
                Error("symmetric powers are only defined for modules over Lie algebras");
            fi;

            if HasIsLieAlgebra( B ) and IsLieAlgebra( B ) then
                righta:= right_lie_action;
            else
                Error("symmetric powers are only defined for modules over Lie algebras");
            fi;

            Symm:= BiAlgebraModule( A, B, lefta, righta, gens );
        fi;

        A:= LeftActingAlgebra( V );
        if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
            lefta:= left_lie_action;
        else
            Error("symmetric powers are only defined for modules over Lie algebras");
        fi;

        Symm:= LeftAlgebraModule( A, lefta, gens );
    else

        A:= RightActingAlgebra( V );

        if HasIsLieAlgebra( A ) and IsLieAlgebra( A ) then
            righta:= right_lie_action;
        else
            Error("symmetric powers are only defined for modules over Lie algebras");
        fi;

        Symm:= RightAlgebraModule( A, righta, gens );
    fi;

    # We already know a basis of the symmetric power, so we don't want
    # to construct this later on, and we don't want the method for
    # `NewBasis' for algebra modules to constuct this basis, because
    # this will result in a call to `Triangulize....' (and we already
    # know that our basis is triangular). So we basically do everything
    # ourselves.

    VT:= VectorSpace( F, gens );
    BT:= NewBasis( VT, gens );
    BT!.echelonBasis:= gens;
    BT!.baseChange:= List( [ 1..Length(gens)], x -> [ [ x, One(F) ] ] );
    BT!.heads:= List( gens, x -> ExtRepOfObj(x)[1] );
    BT!.zeroCoefficient:= Zero( F );
    Bsymm:= Objectify( NewType( FamilyObj( Symm ),
                    IsBasis and
                    IsBasisOfAlgebraModuleElementSpace and
                    IsAttributeStoringRep ),
                    rec() );
    SetUnderlyingLeftModule( Bsymm, Symm );
    SetBasisVectors( Bsymm, GeneratorsOfAlgebraModule( Symm ) );
    Bsymm!.delegateBasis:= BT;
    SetBasis( Symm, Bsymm );
    SetDimension( Symm, Length( gens ) );
    return Symm;

end );


##############################################################################
##
#M  ObjByExtRep( <fam>, <list> ) . . . for a sparse rowspace elt fam. and list
#M  ExtRepOfObj( <v> ) . . . . . . . . for a sparse rowspace element.
##
##  Elements of sparse rowspaces are represented by a list of the
##  form [ i1, c1, i2, c2, ...], where the ik are the indices of the
##  standard row vectors, and the ck are coefficients, and  i1<i2<...
##  So if ek are the unit row vectos then such a sparse element represents
##  c1*e{i1}+c2*e{i2}+...
##
InstallMethod( ObjByExtRep,
        "for a sparse rowspace element family and a list",
        true, [ IsSparseRowSpaceElementFamily, IsList ], 0,
        function( fam, lst )
    return Objectify( fam!.sparseRowSpaceElementDefaultType,
                   [ Immutable(lst) ] );
end );

InstallMethod( ExtRepOfObj,
        "for a sparse rowspace element",
        true, [ IsSparseRowSpaceElement and IsPackedElementDefaultRep ], 0,
        function( v )
    return v![1];
end);


##############################################################################
##
#M  PrintObj( <v> ) . . . . . . for a sparse rowspace element
##
##  A sparse rowspace element is printed as c1*v.i1+c2*v.i2+....
##
InstallMethod( PrintObj,
        "for a sparse rowspace element",
        true, [ IsSparseRowSpaceElement ], 0,
        function( v )

    local   ev,  k;

    ev:= ExtRepOfObj( v );
    if ev = [ ] then Print( "<zero of...>" ); fi;

    for k in [1,3..Length(ev)-1] do
        if k <> 1 then Print("+"); fi;
        Print( "(", ev[k+1], ")*e.", ev[k] );
    od;
end );


#############################################################################
##
#M  ZeroOp( <v> ) . . . . . . . . . . . . . for a sparse rowspace element
#M  \+( <u>, <v> ) . . . . . . . . . . . .  for sparse rowspace elements
#M  AINV( <u> ) . . . . . . . . . . . . . . for a sparse rowspace element
#M  \*( <scal>, <u> )  . . . . . for a sparse rowspace element and scalar
#M  \*( <u>, <scal> ) . . . . . .for a sclalar and sparse rowspace element
#M  \<( <u>, <v> )  . . . . . . . . . . . . for sparse rowspace elements
#M  \=( <u>, <v> ) . . . . . . . . . . . . for sparse rowspace elements
##
InstallMethod( ZeroOp,
        "for sparse rowspace elements",
        true, [ IsSparseRowSpaceElement and IsPackedElementDefaultRep ], 0,
        function( u )

    return ObjByExtRep( FamilyObj( u ), [] );
end );


InstallMethod(\+,
        "for sparse rowspace elements",
        IsIdenticalObj,
        [ IsSparseRowSpaceElement and IsPackedElementDefaultRep,
          IsSparseRowSpaceElement and IsPackedElementDefaultRep], 0,
        function( u, v )

    local lu,lv,zero, sum, res;

    lu:= u![1];
    lv:= v![1];
    zero:= FamilyObj( u )!.zeroCoefficient;
    sum:=  ZippedSum( lu, lv, zero, [\<,\+] );
    return ObjByExtRep( FamilyObj( u ), sum );

end );

InstallMethod( AINV,
        "for a sparse rowspace element",
        true,
        [ IsSparseRowSpaceElement and IsPackedElementDefaultRep ], 0,
        function( u )

    local   eu,  k;

    eu:= ShallowCopy( u![1] );
    for k in [2,4..Length(eu)] do
        eu[k]:= -eu[k];
    od;

    return ObjByExtRep( FamilyObj( u ), eu );
end );

InstallMethod( \*,
        "for a sparse rowspace element and a scalar",
        true,
        [ IsSparseRowSpaceElement and IsPackedElementDefaultRep,
          IsRingElement ], 0,
        function( u, scal )

    local   eu,  k;

    eu:= ShallowCopy( u![1] );
    for k in [2,4..Length(eu)] do
        eu[k]:= scal*eu[k];
    od;

    return ObjByExtRep( FamilyObj( u ), eu );
end );


InstallMethod( \*,
        "for a scalar and a sparse rowspace element",
        true,
        [ IsRingElement,
          IsSparseRowSpaceElement and IsPackedElementDefaultRep ], 0,
        function( scal, u )

    local   eu,  k;

    eu:= ShallowCopy( u![1] );
    for k in [2,4..Length(eu)] do
        eu[k]:= scal*eu[k];
    od;

    return ObjByExtRep( FamilyObj( u ), eu );
end );


InstallMethod(\<,
        "for sparse rowspace elements",
        IsIdenticalObj,
        [ IsSparseRowSpaceElement and IsPackedElementDefaultRep,
          IsSparseRowSpaceElement and IsPackedElementDefaultRep], 0,
        function( u, v )
    return u![1] < v![1];
end );

InstallMethod(\=,
        "for sparse rowspace elements",
        IsIdenticalObj,
        [ IsSparseRowSpaceElement and IsPackedElementDefaultRep,
          IsSparseRowSpaceElement and IsPackedElementDefaultRep], 0,
        function( u, v )
    return u![1] = v![1];
end );

#############################################################################
##
#R  IsBasisOfSparseRowSpaceRep( <B> )
##
##  A basis of a sparse rowspace has the record components
##  `echelonBasis' (a list of vectors spanning the same space, and in
##  echelon form), `heads' (the indices of the `leading' vectors of
##  the elements of `echelonBasis'), `baseChange' ( a list of the same length
##  as `ecelonBasis' describing
##  the elements of `echlonBasis' as linear combinations of the basis vectors
##  of the basis <B>. The elements of `baseChange' are lists of the form
##  `[ l1, l2,...,lk ]', where the `li' are lists of the form `[ ind, cf ]';
##  the i-th element of `echelonBas' is the sum of `cf*B[ind]'
##  when we loop over the entire list `basechange[i]'.), `zeroCoefficient'
##  (the zero of the ground field).
##
DeclareRepresentation( "IsBasisOfSparseRowSpaceRep", IsComponentObjectRep,
        [ "echelonBasis", "heads", "baseChange", "zeroCoefficient" ] );

##############################################################################
##
#M  NewBasis( <V>, <vectors> ) . . . . . . for a sparse row space and a list
##
##  We note that in this function the list <vectors> gets triangulized,
##  and a basis is always returned, also if the dimenion of <V> is less
##  than the length of <vectors>.
##
InstallOtherMethod( NewBasis,
        "for a free module of sparse row space elements, and list",
        true,
        [ IsFreeLeftModule and IsSparseRowSpaceElementCollection,
          IsList ], 0,
        function( V, vectors )

    local   tt,  zero,  basechange,  heads,  k,  cf,  i,  head,  b,
            b1,  pos,  B;

    # We first triangulize the elements of `vectors'.

    tt:= ShallowCopy( vectors );
    zero:= Zero( LeftActingDomain( V ) );

    # Initially `basechange' is just the identity.
    # We sort `tt' to get the smallest leading monomials first.

    basechange:= List( [1..Length(tt)], x -> [ [ x, One( zero ) ] ] );
    SortParallel( tt, basechange,
            function( u, v ) return u![1][1] < v![1][1]; end );

    heads:= [ ];
    k:= 1;

    # We perform a Gaussian elimination...

    while k <= Length( tt ) do

        if IsZero( tt[k] ) then

            # Get rid of it.
            Unbind( tt[k] );
            Unbind( basechange[k] );
            tt:= Filtered( tt, x -> IsBound( x ) );
            basechange:= Filtered( basechange, x -> IsBound( x ) );
        else

            # If there is a vector starting with the same index as `tt[k]'
            # occuring "below" `tt[k]' then subtract `tt[k]' the appropriate
            # number of times.
            # First we make the leading coefficient of `tt[k]' equal to 1.

            cf:= tt[k]![1][2];
            tt[k]:= (1/cf)*tt[k];
            for i in [1..Length(basechange[k])] do
                basechange[k][i][2]:= basechange[k][i][2]/cf;
            od;

            head:= tt[k]![1][1];
            Add( heads, head );
            i:= k+1;
            while i <= Length(tt) do
                if tt[i]![1][1] = head then
                    cf:= tt[i]![1][2];
                    tt[i]:= tt[i] - cf*tt[k];
                    if IsZero( tt[i] ) then

                        # Get rid of it.
                        Unbind( tt[i] );
                        Unbind( basechange[i] );
                        tt:= Filtered( tt, x -> IsBound( x ) );
                        basechange:= Filtered( basechange,
                                             x -> IsBound( x ) );
                    else

                        # Adjust the i-th entry in basechange, we basically
                        # subtract `cf' times the k-th entry of basechange.
                        for b in basechange[k] do
                            b1:= [ b[1], -cf*b[2] ];
                            pos:= PositionSorted( basechange[i], b1,
                                          function( x, y ) return x[1] < y[1];
                                      end );
                            if pos > Length( basechange[i] ) or
                                      basechange[i][pos][1] <> b1[1] then
                               InsertElmList(basechange[i],pos,b1 );
                            else
                               basechange[i][pos][2]:= basechange[i][pos][2]+
                                                                  b1[2];
                            fi;

                        od;
                        i:= i+1;
                    fi;
                else
                    i:= i+1;
                fi;
            od;
            k:= k+1;
        fi;
        # Sort the lists again...
        # This is necessary, because by the elim operation the lists may have
        # become unsorted.
        SortParallel( tt, basechange,
                function( u, v ) return u![1][1] < v![1][1]; end );
    od;

    # Finally we construct the basis.

    B:= Objectify( NewType( FamilyObj( V ),
                IsBasisOfSparseRowSpaceRep and
                IsBasis and
                IsAttributeStoringRep ),
                rec() );

    B!.semiEchelonBasis:= tt;
    B!.heads:= heads;
    B!.baseChange:= basechange;
    B!.zeroCoefficient:= zero;

    SetUnderlyingLeftModule( B, V );

    return B;
end );

#############################################################################
##
#M  Basis( <V>, <vectors> )
#M  BasisNC( <V>, <vectors> )
#M  BasisOfDomain( <V> )
##
InstallMethod( Basis,
        "for a free module of sparse row space elements, and list",
        true,
        [ IsFreeLeftModule and IsSparseRowSpaceElementCollection,
          IsHomogeneousList ], 0,
        function( V, vectors )
    local B;

    if not ForAll( vectors, x -> x in V ) then return fail; fi;
    B:= NewBasis( V, vectors );
    if Length( B ) <> Length( vectors ) then return fail; fi;
    SetBasisVectors( B, vectors );
    return B;

end );


InstallMethod( BasisNC,
        "for a free module of sparse row space elements, and list",
        true,
        [ IsFreeLeftModule and IsSparseRowSpaceElementCollection,
          IsHomogeneousList ], 0,
        function( V, vectors )
    local B;

    B:= NewBasis( V, vectors );
    SetBasisVectors( B, vectors );
    return B;

end );


InstallMethod( BasisOfDomain,
        "for a free module of sparse row space elements",
        true,
        [ IsFreeLeftModule and IsSparseRowSpaceElementCollection ], 0,
        function( V )
    local B, BV;

    # We return an echelonized basis.

    B:= NewBasis( V, GeneratorsOfLeftModule( V ) );
    BV:= B!.semiEchelonBasis;
    SetBasisVectors( B, BV );
    B!.baseChange:= List( [1..Length(BV)], x ->
                          [ [ x, One( LeftActingDomain(V) ) ] ] );
    return B;

end );

##############################################################################
##
#M  Coefficients( <B>, <v> ). . . . . . for basis of a sparse row space
##                                      and vector
##
InstallMethod( Coefficients,
        "for basis of a sparse rowspace, and a vector",
        IsCollsElms, [ IsBasis and IsBasisOfSparseRowSpaceRep,
                IsSparseRowSpaceElement ], 0,
    function( B, v )

    local   w,  cf,  i,  b, c;

    # We use the echelon basis that comes with <B>.

    w:= v;
    cf:= List( BasisVectors( B ), x -> B!.zeroCoefficient );
    for i in [1..Length(B!.heads)] do

        if IsZero( w ) then return cf; fi;

        if  w![1][1] < B!.heads[i] then
            return fail;
        elif w![1][1] = B!.heads[i] then
            c:= w![1][2];
            w:= w - c*B!.semiEchelonBasis[i];
            for b in B!.baseChange[i] do
                cf[b[1]]:= cf[b[1]] + b[2]*c;
            od;
        fi;
    od;

    if not IsZero( w ) then return fail; fi;
    return cf;

end );


#############################################################################
##
#M  FullSparseRowSpace( <F>, <n> )  . . . . . . for a ring and an integer
##
##
InstallMethod( FullSparseRowSpace,
        "for a ring and an integer",
        true, [ IsRing, IsInt ], 0,
        function( F, n )

    local   fam,  bV,  V,  B;

    fam:= NewFamily( "FamilyOfSparseRowSpaceElements",
                  IsSparseRowSpaceElement );
    fam!.sparseRowSpaceElementDefaultType:= NewType( fam,
                                               IsPackedElementDefaultRep );
    fam!.zeroCoefficient:= Zero( F );
    bV:= List( [1..n], x -> ObjByExtRep( fam, [ x, One(F) ] ) );
    V:= VectorSpace( F, bV );
    B:= Objectify( NewType( FamilyObj( V ),
                IsBasisOfSparseRowSpaceRep and
                IsBasis and
                IsAttributeStoringRep ),
                rec() );

    B!.semiEchelonBasis:= bV;
    B!.heads:= [1..n];
    B!.baseChange:= List( [1..n], x -> [ [ x, One( F ) ] ] );
    B!.zeroCoefficient:= Zero( F );

    SetUnderlyingLeftModule( B, V );
    SetBasisVectors( B, bV );
    SetBasisOfDomain( V, B );
    SetDimension( V, n );
    return V;

end );


###############################################################################
##
#M  PrintObj( <u> ) . . . . . . . . . . . . . . . . . for a direct sum element
##
InstallMethod( PrintObj,
        "for direct sum elements",
        true, [ IsDirectSumElement and IsPackedElementDefaultRep ], 0,
        function( u )

    local   eu,  k,  i;

    eu:= u![1];
    for k in [1..Length(eu)] do
        Print("( ",eu[k]," )");
        if k <> Length( eu ) then
            Print( "(+)" );
        fi;
    od;

end );

############################################################################
##
#M  ObjByExtRep( <fam>, <list> ) . . . for a DirectSumElementFamily and a list
#M  ExtRepOfObj( <t> )  . . . . . . .  for a direct sum element in packed rep.
##
InstallMethod( ObjByExtRep,
        "for a family of direct sum elements and a list",
        true, [ IsDirectSumElementFamily, IsList] , 0,
        function( fam, list )
    return Objectify( fam!.directSumElementDefaultType,
                   [ Immutable( list ) ] );
end );


InstallMethod( ExtRepOfObj,
        "for a direct sum element",
        true, [ IsDirectSumElement and IsPackedElementDefaultRep ] , 0,
        function( t )  return t![1];
end );

InstallMethod( ZeroOp,
        "for direct sum elements",
        true, [ IsDirectSumElement and IsPackedElementDefaultRep ], 0,
        function( u )

    return ObjByExtRep( FamilyObj( u ), List(
                   FamilyObj( u )!.constituentModules, V -> Zero(V) ) );
end );


InstallMethod(\+,
        "for direct sum elements",
        IsIdenticalObj,
        [ IsDirectSumElement and IsPackedElementDefaultRep,
          IsDirectSumElement and IsPackedElementDefaultRep], 0,
        function( u, v )
    return ObjByExtRep( FamilyObj( u ), ExtRepOfObj( u )+ ExtRepOfObj( v ) );
end );

InstallMethod( AINV,
        "for a direct sum element",
        true,
        [ IsDirectSumElement and IsPackedElementDefaultRep ], 0,
        function( u )
    return ObjByExtRep( FamilyObj( u ), -ExtRepOfObj( u ) );
end );


InstallMethod(\*,
        "for a direct sum element and a scalar",
        true,
        [ IsDirectSumElement and IsPackedElementDefaultRep, IsRingElement ], 0,
        function( u, scal )
    return ObjByExtRep( FamilyObj( u ), scal*ExtRepOfObj( u ) );
end );

InstallMethod(\*,
        "for a direct sum element and a scalar",
        true,
        [ IsRingElement, IsDirectSumElement and IsPackedElementDefaultRep ],0,
        function( scal, u  )
    return ObjByExtRep( FamilyObj( u ), scal*ExtRepOfObj( u ) );
end );


InstallMethod(\<,
        "for direct sum elements",
        IsIdenticalObj,
        [ IsDirectSumElement and IsPackedElementDefaultRep,
          IsDirectSumElement and IsPackedElementDefaultRep], 0,
        function( u, v )
    return u![1] < v![1];
end );

InstallMethod(\=,
        "for direct sum elements",
        IsIdenticalObj,
        [ IsDirectSumElement and IsPackedElementDefaultRep,
          IsDirectSumElement and IsPackedElementDefaultRep], 0,
        function( u, v )
    return u![1] = v![1];
end );


#############################################################################
##
#M  NiceFreeLeftModuleInfo( <C> ) . . . . . . .  for a module of dir sum elts
#M  NiceVector ( <C>, <c> ) . . for a module of dir sum elts and a dir sum elt
#M  UglyVector( <C>, <v> ) . . .for a module of dir sum elts and a row vector
##
InstallHandlingByNiceBasis( "IsDirectSumElementsSpace", rec(
    detect:= function( R, gens, V, zero )
      return IsDirectSumElementCollection( V );
      end,

    NiceFreeLeftModuleInfo := ReturnFalse,

    NiceVector := function( V, v )
      local   ev,  vec,  num,  i,  cf,  k;

      if not IsPackedElementDefaultRep( v ) then
        TryNextMethod();
      fi;
      ev:= ExtRepOfObj( v );
      vec:= [ ];
      num:= 0;
      for i in [1..Length(ev)] do
          cf:= Coefficients( BasisOfDomain(
                       FamilyObj(v)!.constituentModules[i] ), ev[i] );
          for k in [1..Length(cf)] do
              if cf[k] <> 0*cf[k] then
                  Add( vec, num+k );
                  Add( vec, cf[k] );
              fi;
          od;
          num:= num + Dimension( FamilyObj(v)!.constituentModules[i] );
      od;
      return ObjByExtRep( FamilyObj( v )!.niceVectorFam, vec );
      end,

    UglyVector := function( V, vec )
      local   ev,  fam,  mods,  u,  d,  k,  i;

      # We do the inverse of `NiceVector'.
      ev:= ShallowCopy( vec![1] );
      fam:= ElementsFamily( FamilyObj( V ) );
      mods:= fam!.constituentModules;
      u:= List( mods, x -> Zero( x ) );
      d:= 0;
      k:= 1;
      i:= 1;
      while IsBound( ev[k] ) and i <= Length( mods ) do
          if ev[k] <= d+Dimension(mods[i]) then
              u[i]:= u[i] + ev[k+1]*Basis(mods[i])[ev[k]-d];
              k:= k+2;
          else
              d:= d + Dimension( mods[i] );
              i:= i+1;
          fi;
      od;
      return ObjByExtRep( fam, u );
      end ) );


############################################################################
##
#M  DirectSumOfAlgebraModules( <list> )
#M  DirectSumOfAlgebraModules( <V>, <W> )
##
InstallMethod( DirectSumOfAlgebraModules,
        "for a list of algebra modules",
        true, [ IsDenseList ], 0,
        function( list )

    local   left_action,  right_action,  F,  fam,  type,  niceVF,
            gens,  zero,  i,  gV,  v,  be,  A,  B,  V,  W,  niceMod,
            BW;

    # There are two types of action on a direct sum: left and right.

    left_action:= function( x, tn )

        return ObjByExtRep( FamilyObj( tn ),
                       List( ShallowCopy( ExtRepOfObj( tn ) ), u -> x^u ) );
    end;

    right_action:= function( tn, x )

        return ObjByExtRep( FamilyObj( tn ),
                       List( ShallowCopy( ExtRepOfObj( tn ) ), u -> u^x ) );
    end;


    # We first make the family of the direct sum elements, and construct
    # a basis of the direct sum. Note that if the arguments do not
    # know how to compute bases, then the rewriting of tensors to normal
    # forms will fail. Hence we can assume that every module has a basis,
    # and therefore we have a basis of the tensor space as well.

    F:= LeftActingDomain( list[1] );
    fam:= NewFamily( "DirectSumElementsFam", IsDirectSumElement );
    type:= NewType( fam, IsPackedElementDefaultRep );
    fam!.directSumElementDefaultType:= type;
    fam!.zeroCoefficient:= Zero( F );
    fam!.constituentModules:= list;

    niceVF:= NewFamily( "NiceVectorFam", IsSparseRowSpaceElement );
    niceVF!.zeroCoefficient:= Zero( F );
    niceVF!.sparseRowSpaceElementDefaultType:=
                              NewType( niceVF, IsPackedElementDefaultRep );
    fam!.niceVectorFam:= niceVF;

    gens:= [ ];
    zero:= List( list, x -> Zero( x ) );
    for i in [1..Length(list)] do
        gV:= BasisOfDomain( list[i] );
        for v in gV do
            be:= ShallowCopy( zero );
            be[i]:= v;
            Add( gens, be );
        od;
    od;

    if gens = [ ] then
        gens:= [ zero ];
    fi;

    gens:= List( gens, x -> ObjByExtRep( fam, x ) );
    for i in [1..Length(gens)] do
        gens[i]![2]:= true;
    od;

    # Now we make the direct sum, we need to consider a few cases...

    if IsLeftAlgebraModuleElementCollection( list[1] ) then
        if IsRightAlgebraModuleElementCollection( list[1] ) then

            if not ForAll( list, V ->
                       IsLeftAlgebraModuleElementCollection(V) and
                       IsRightAlgebraModuleElementCollection(V)) then
              Error("for all modules the algebra must act om the same side");
            fi;

            A:= LeftActingAlgebra( list[1] );
            B:= RightActingAlgebra( list[1] );
            if not ForAll( list, V ->
                       IsIdenticalObj( LeftActingAlgebra(V), A ) and
                       IsIdenticalObj( RightActingAlgebra(V), B ) )
             then Error("all modules must have the same left acting algebra" );
            fi;

            V:= BiAlgebraModule( A, B, left_action, right_action,
                           gens );
        fi;

        if not ForAll( list, IsLeftAlgebraModuleElementCollection ) then
            Error( "for all modules the algebra must act om the same side" );
        fi;

        A:= LeftActingAlgebra( list[1] );
        if not ForAll( list, V -> IsIdenticalObj( LeftActingAlgebra(V), A ) )
           then Error( "all modules must have the same left acting algebra" );
        fi;

        V:= LeftAlgebraModule( A, left_action, gens );
    else

        if not ForAll( list, IsRightAlgebraModuleElementCollection ) then
            Error( "for all modules the algebra must act om the same side" );
        fi;

        A:= RightActingAlgebra( list[1] );
        if not ForAll( list, V -> IsIdenticalObj( RightActingAlgebra(V), A ) )
           then Error( "all modules must have the same left acting algebra" );
        fi;

        V:= RightAlgebraModule( A, right_action, gens );
    fi;

    if IsZero( gens[1] ) then
        return V;
    fi;

    # We construct a basis `B' of the direct sum.
    # This is a basis of an algebra module, so it works via a delegate
    # basis, which is a basis of the module spanned by the elements `gens'.
    # We call this module `W', and `BW' will be a basis of `W'.
    # Now `W' works via a nice basis and we know the basis vectors of this
    # nice basis (namely all unit vectors). So we set the attribute `NiceBasis'
    # of `BW' to be the standard basis of the full row space.

    W:= VectorSpace( F, gens, "basis" );
    niceMod:= FullSparseRowSpace( F, Length(gens) );
    SetNiceFreeLeftModule( W, niceMod );
    B:= Objectify( NewType( FamilyObj( V ), IsBasis and
                 IsBasisOfAlgebraModuleElementSpace and
                 IsAttributeStoringRep ), rec() );
    SetUnderlyingLeftModule( B, V );
    SetBasisVectors( B, GeneratorsOfAlgebraModule(V) );

    BW:= Objectify( NewType( FamilyObj( W ), IsBasisByNiceBasis and
                                            IsAttributeStoringRep ), rec() );
    SetUnderlyingLeftModule( BW, W );
    SetBasisVectors( BW, gens );
    SetNiceBasis( BW, BasisOfDomain( niceMod ) );

    B!.delegateBasis:= BW;
    SetBasisOfDomain( V, B );
    SetDimension( V, Length( gens ) );
    return V;


end );


InstallOtherMethod( DirectSumOfAlgebraModules,
        "for two algebra modules",
        true, [ IsAlgebraModule, IsAlgebraModule ], 0,
        function( V, W )
    return DirectSumOfAlgebraModules( [ V, W ] );
end );

