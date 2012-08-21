#############################################################################
##
#W  cyclotom.gi                 GAP library                     Thomas Breuer
##
#H  @(#)$Id$
##
#Y  Copyright (C)  1997,  Lehrstuhl D fuer Mathematik,  RWTH Aachen,  Germany
#Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
##
##  This file contains methods for cyclotomics.
##
Revision.cyclotom_gi :=
    "@(#)$Id$";


#############################################################################
##
#M  Conductor( <list> ) . . . . . . . . . . . . . . . . . . . . .  for a list
##
##  (This works not only for lists of cyclotomics but also  for lists of
##  lists of cyclotomics etc.)
##
InstallOtherMethod( Conductor,
    "for a list",
    true,
    [ IsList ], 0,
    function( list )
    local n, entry;
    n:= 1;
    for entry in list do
      n:= LcmInt( n, Conductor( entry ) );
    od;
    return n;
    end );


#############################################################################
##
#M  RoundCyc( <cyc> ) . . . . . . . . . . cyclotomic integer near to <cyc>
##
InstallMethod( RoundCyc, "general cyclotomic", true, [ IsCyclotomic],
        0,  function ( x )
    local i, int, n, cfs, e;
    n:= Conductor( x );
    e:= E(n);
    cfs:= ExtRepOfObj( x );
    int:= 0;
    for i in [ 1 .. n ]  do
      if cfs[i] < 0 then
        int:= int + Int( cfs[i]-1/2 ) * e^(i-1);
      else
        int:= int + Int( cfs[i]+1/2 ) * e^(i-1);
#T use `Round' for the coefficients, too!
      fi;
    od;
    return int;
end );

#T operation `Round' ?
#T made RoundCyc an operation at least 7/12/98 SL



#############################################################################
##
#M  RoundCycDown( <cyc> ) . . . . . . . . . . cyclotomic integer near to <cyc>
##				rounding halves down
##
InstallMethod( RoundCycDown, "general cyclotomic", true, [ IsCyclotomic],
        0,  function ( x )
    local i, int, n, cfs, e;
    n:= Conductor( x );
    e:= E(n);
    cfs:= ExtRepOfObj( x );
    int:= 0;
    for i in [ 1 .. n ]  do
        int:= int + RoundCycDown( cfs[i]) * e^(i-1);
    od;
    return int;
end );

#############################################################################
##
#M  ComplexConjugate( <cyc> )
##
InstallMethod( ComplexConjugate,
    "for a cyclotomic",
    true,
    [ IsCyc ], 0,
    cyc -> GaloisCyc( cyc, -1 ) );


#############################################################################
##
#M  ExtRepOfObj( <cyc> )
##
#+  Let <cyc> be a cyclotomic with conductor <n>.
#+  The external representation of <cyc> is defined as
#+  `CoeffsCyc( <cyc>, <n> )'.
##
InstallMethod( ExtRepOfObj,
    "for an internal cyclotomic",
    true,
    [ IsCyc and IsInternalRep ], 0,
    COEFFS_CYC );


#############################################################################
##
#F  CoeffsCyc( <z>, <N> )
##
InstallGlobalFunction( CoeffsCyc, function( z, N )

    local coeffs,      # coefficients list (also intermediately)
          n,           # length of `coeffs'
          quo,         # factor by that we have to blow up
          s,           # denominator of `quo' (we have to reduce)
          factors,     #
          second,      # product of primes in second reduction step
          first,
          val,
          kk,
          pos,
          j,
          k,
          p,
          nn,
          newcoeffs;

    if IsCyc( z ) then

      # `z' is an internal cyclotomic, and therefore it is represented
      # in the smallest possible cyclotomic field.

      coeffs:= ExtRepOfObj( z ); # returns `CoeffsCyc( z, Conductor( z ) )'
      n:= Length( coeffs );
      quo:= N / n;
      if not IsInt( quo ) then
        return fail;
      fi;

    else

      # `z' is already a coefficients list
      coeffs:= z;
      n:= Length( coeffs );
      quo:= N / n;
      if not IsInt( quo ) then

        # Maybe `z' was not represented with respect to
        # the smallest possible cyclotomic field.
        # Try to reduce `z' until the denominator $s$ disappears.

        s:= DenominatorRat( quo );

        # step 1.
        # First we get rid of
        # - the $p$-parts for those primes $p$ that divide both $s$
        #   and $n / s$, and hence remain in the reduced expression,
        # - all primes but the squarefree part of the rest.

        factors:= Set( FactorsInt( s ) );
        second:= 1;
        for p in factors do
          if s mod p <> 0 or ( n / s ) mod p <> 0 then
            second:= second * p;
          fi;
        od;
        if second mod 2 = 0 then
          second:= second / 2;
        fi;
        first:= s / second;
        if first > 1 then
          newcoeffs:= ListWithIdenticalEntries( n / first, 0 );
          for k in [ 1 .. n ] do
            if coeffs[k] <> 0 then
              pos:= ( k - 1 ) / first + 1;
              if not IsInt( pos ) then
                return fail;
              fi;
              newcoeffs[ pos ]:= coeffs[k];
            fi;
          od;
          n:= n / first;
          coeffs:= newcoeffs;
        fi;

        # step 2.
        # Now we process those primes that shall disappear
        # in the reduced form.
        # Note that $p-1$ of the coefficients congruent modulo $n/p$
        # must be equal, and the negative of this value is put at the
        # position of the $p$-th element of this congruence class.
        if second > 1 then
          for p in FactorsInt( second ) do
            nn:= n / p;
            newcoeffs:= ListWithIdenticalEntries( nn, 0 );
            for k in [ 1 .. n ] do
              pos:= 0;
              if coeffs[k] <> 0 then
                val:= coeffs[k];
                for j in [ 1 .. p-1 ] do
                  kk:= ( ( k - 1 + j*nn ) mod n ) + 1;
                  if coeffs[ kk ] = val then
                    coeffs[ kk ]:= 0;
                  elif pos <> 0 or coeffs[kk] <> 0 or kk mod p <> 1 then
                    return fail;
                  else
                    pos:= ( kk - 1 ) / p + 1;
                  fi;
                od;
                newcoeffs[ pos ]:= - val;
              fi;
            od;
            n:= nn;
            coeffs:= newcoeffs;
          od;
        fi;
        quo:= NumeratorRat( quo );

      fi;

    fi;

    # If necessary then blow up the representation in two steps.

    # step 1.
    # For each prime `p' not dividing `n' we replace
    # `E(n)^k' by $ - \sum_{j=1}^{p-1} `E(n*p)^(p*k+j*n)'$.
    if quo <> 1 then

      for p in Set( FactorsInt( quo ) ) do
        if p <> 2 and n mod p <> 0 then
          nn  := n * p;
          quo := quo / p;
          newcoeffs:= ListWithIdenticalEntries( nn, 0 );
          for k in [ 1 .. n ] do
            if coeffs[k] <> 0 then
              for j in [ 1 .. p-1 ] do
                newcoeffs[ ( ( (k-1)*p + j*n  ) mod nn ) + 1 ]:= -coeffs[k];
              od;
            fi;
          od;
          coeffs:= newcoeffs;
          n:= nn;
        fi;
      od;

    fi;

    # step 2.
    # For the remaining divisors of `quo' we have
    # `E(n*p)^(k*p)' in the basis for each basis element `E(n)^k'.
    if quo <> 1 then

      n:= Length( coeffs );
      newcoeffs:= ListWithIdenticalEntries( quo*n, 0 );
      for k in [ 1 .. Length( coeffs ) ] do
        if coeffs[k] <> 0 then
          newcoeffs[ (k-1)*quo + 1 ]:= coeffs[k];
        fi;
      od;
      coeffs:= newcoeffs;

    fi;

    # Return the coefficients list.
    return coeffs;
end );


#############################################################################
##
#F  CycList( <coeffs> ) . . . . .  cyclotomic of Zumbroich base coeff. vector
##
##  (mainly to read tables produced by the `ctoc' script used to translate
##  character tables in CAS format to {\GAP})
##
##  *Note*\: `CycList( ExtRepOfObj( <cyc> ) )' = <cyc>, but
##          `ExtRepOfObj( CycList(<coeffs>) )' need not be equal to <coeffs>.
##
BindGlobal( "CycList", function( coeffs )
    local e, n;
    n:= Length( coeffs );
    e:= E(n);
    return Sum( [ 1 .. n ], i -> coeffs[i] * e^(i-1), 0 );
end );


#############################################################################
##
#F  IsGaussInt(<x>) . . . . . . . . . test if an object is a Gaussian integer
##
InstallGlobalFunction( IsGaussInt,
    x ->  IsCycInt( x ) and (Conductor( x ) = 1 or Conductor( x ) = 4) );


#############################################################################
##
#F  IsGaussRat( <x> ) . . . . . . .  test if an object is a Gaussian rational
##
InstallGlobalFunction( IsGaussRat,
    x -> IsCyc( x ) and (Conductor( x ) = 1 or Conductor( x ) = 4) );


##############################################################################
##
#F  DescriptionOfRootOfUnity( <root> )
##
##  Let $\zeta$ denote the primitive $n$-th root of unity $`E'(n)$,
##  and suppose that we know the coefficients of $\pm\zeta^i$ w.r.t.
##  the $n$-th Zumbroich basis (see~"ZumbroichBasis").
##  These coefficients are either all $1$ or all $-1$.
##  More precisely, they arise in the base conversion from (formally)
##  successively multiplying $\pm\zeta^i$ by
##  $1 = - \sum_{j=1}^{p-1} \zeta^{jn/p}$,
##  for suitable prime diviors $p$ of $n$,
##  and then treating the summands $\pm\zeta^{i + jn/p}$ in the same way
##  until roots in the basis are reached.
##  It should be noted that all roots obtained this way are distinct.
##
##  Suppose the above procedure must be applied for the primes
##  $p_1$, $p_2$, \ldots, $p_r$.
##  Then $\zeta^i$ is equal to
##  $(-1)^r \sum_{j_1=1}^{p_1-1} \cdots \sum_{j_r=1}^{p_r-1}
##  \zeta^{i + \sum_{k=1}^r j_k n/p_k}$.
##  The number of summands is $m = \prod_{k=1}^r (p_k-1)$.
##  Since these root are all distinct, we can compute the sum $s$ of their
##  exponents modulo $n$ from the known coefficients of $\zeta^i$,
##  and we get $s \equiv m ( i + r n/2 ) \pmod{n}$.
##  Either $m = 1$ or $m$ is even,
##  hence this congruence determines $\zeta^i$ at most up to its sign.
##
##  Now suppose that $g = \gcd( m, n )$ is nontrivial.
##  Then $i$ is determined only modulo $n/g$, and we have to decide which
##  of the $g$ possible values $i$ is.
##  This could be done by computing the values $j_{0,p}$ for one
##  candidate $i$, where $p$ runs over the prime divisors $p$ of $n$
##  for which $m$ is the product of $(p-1)$.
##
##  (Recall that each $n$-th root of unity is of the form
##  $\prod_{p\in P} \prod_{k_p=1}^{\nu_p-1} \zeta^{j_{k,p}n/p^{k_p+1}}$,
##  with $j_{0,p} \in \{ 0, 1, \ldots, p-1 \}$, $j_{k,2} \in \{ 0, 1 \}$
##  for $k > 0$, and $j_{k,p} \in \{ -(p-1)/2, \ldots, (p-1)/2 \}$ for
##  $p > 2$.
##  The root is in the $n$-th Zumbroich basis if and only if $j_{0,2} = 0$
##  and $j_{0,p} \not= 0$ for $p > 2$.)
##
##  But note that we do not have an easy access to the decomposition
##  of $m$ into factors $(p-1)$,
##  although in fact this decomposition is unique for $n \leq 65000$.
##
##  So the exponent is identified by dividing off one of the candidates
##  and then identifying the quotient, which is a $g$-th or $2 g$-th
##  root of unity.
##  (Note that $g$ is small compared to $n$.
##  $m$ divides the product of $(p-1)$ for prime divisors $p$
##  that divide $n$ at least with exponent $2$.
##  The maximum of $g$ for $n \leq 65000$ is $40$, so $2$ steps suffice
##  for these values of $n$.)
##
InstallGlobalFunction( DescriptionOfRootOfUnity, function( root )

    local coeffs,   # Zumbroich basis coefficients of `root'
          n,        # conductor of `n'
          sum,      # sum of exponents with nonzero coefficients
          num,      # number of nonzero coefficients
          i,        # loop variable
          val,      # one coefficient
          coeff,    # one nonzero coefficient (either `1' or `-1')
          exp,      # candidate for the exponent
          g,        # `Gcd( n, num )'
          groot;    # root in recursion

    # Handle the trivial cases that `root' is an integer.
    if root = 1 then
      return [ 1, 1 ];
    elif root = -1 then
      return [ 2, 1 ];
    fi;
    Assert( 1, not IsRat( root ) );

    # Compute the Zumbroich basis coefficients,
    # and number and sum of exponents with nonzero coefficient (mod `n').
    coeffs:= ExtRepOfObj( root );
    n:= Length( coeffs );
    sum:= 0;
    num:= 0;
    for i in [ 1 .. n ] do
      val:= coeffs[i];
      if val <> 0 then
        sum:= sum + i;
        num:= num + 1;
        coeff:= val;
      fi;
    od;
    sum:= sum - num;

    # `num' is equal to `1' if and only if `root' or its negative
    # belongs to the basis.
    # (The coefficient is equal to `-1' if and only if either
    # `n' is a power of $2$ or
    # `n' is odd and `root' is a primitive $2 `n'$-th root of unity.)
    if num = 1 then
      if coeff < 0 then
        if n mod 2 = 0 then
          sum:= sum + n/2;
        else
          sum:= 2*sum + n;
          n:= 2*n;
          sum:= sum mod n;
        fi;
      fi;
      Assert( 1, root = E(n)^sum );
      return [ n, sum ];
    fi;

    # Let $N$ be `n' if `n' is even, and equal to $2 `n'$ otherwise.
    # The exponent is determined modulo $N / \gcd( N, `num' )$.
    g:= GcdInt( n, num );
    if g = 1 then

      # If `n' and `num' are coprime then `root' is identified up to its sign.
      exp:= ( sum / num ) mod n;
      if root <> E(n)^exp then
        exp:= 2*exp + n;
        n:= 2*n;
        exp:= exp mod n;
      fi;

    elif g = 2 then

      # `n' is even, and again `root' is determined up to its sign.
      exp:= ( sum / num ) mod ( n / 2 );
      if root <> E(n)^exp then
        exp:= ( exp + n / 2 ) mod n;
      fi;

    else

      # Divide off one of the candidates.
      # The quotient is a `g'-th or $2 `g'$-th root of unity,
      # which can be identified by recursion.
      exp:= ( sum / num ) mod ( n / g );
      groot:= DescriptionOfRootOfUnity( root * E(n)^(n-exp) );
      if n mod 2 = 1 and groot[1] mod 2 = 0 then
        exp:= 2*exp;
        n:= 2*n;
      fi;
      exp:= ( exp + groot[2] * n / groot[1] ) mod n;

    fi;

    # Return the result.
    Assert( 1, root = E(n)^exp );
    return [ n, exp ];
end );


#############################################################################
##
#F  Atlas1( <n>, <i> )  . . . . . . . . . . . . . . . utility for EB, ..., EH
##
##  is the value $\frac{1}{i}\sum{j=1}^{n-1}z_n^{j^i}$ for $2 \leq i \leq 8$
##  and $<n> \equiv 1 \pmod{i}$;
##  if $i > 2$, <n> should be a prime to get sure that the result is
##  well-defined;
##  `Atlas1' returns the value given above if it is a cyclotomic integer.
##  (see: Conway et al, ATLAS of finite groups, Oxford University Press 1985,
##        Chapter 7, Section 10)
##
BindGlobal( "Atlas1", function( n, i )
local k,atlas, En;

    if not IsInt( n ) or n < 1 then
      Error( "usage: EB(<n>), EC(<n>), ..., EH(<n>) with appropriate ",
             "integer <n>" );
    elif n mod i <> 1 then
      Error( "<n> not congruent 1 mod ", i );
    fi;

    if n = 1 then
      return 0;
    fi;

    atlas:= 0;
    En:= E(n);

    if i mod 2 = 0 then
      for k in [ 1 .. QuoInt( n-1, 2 ) ] do
        atlas:= atlas + 2 * En ^ ( (k^i) mod n );
      od;
    else
      for k in [ 1 .. QuoInt( n-1, 2 ) ] do
        atlas:= atlas + En^( ( k^i ) mod n ) + En^( n - ( k^i ) mod n );
      od;
      if n mod 2 = 0 then
        atlas:= atlas + En ^ ( ( ( n / 2 ) ^ i )  mod  n );
      fi;
    fi;
    atlas:= atlas / i;
    if not IsCycInt( atlas ) then
      Error( "result divided by ", i, " is not a cyclotomic integer" );
    fi;
    return atlas;
end );


#############################################################################
##
#F  EB( <n> ), EC( <n> ), \ldots, EH( <n> ) . . .  some ATLAS irrationalities
##
InstallGlobalFunction( EB, n -> Atlas1( n, 2 ) );
InstallGlobalFunction( EC, n -> Atlas1( n, 3 ) );
InstallGlobalFunction( ED, n -> Atlas1( n, 4 ) );
InstallGlobalFunction( EE, n -> Atlas1( n, 5 ) );
InstallGlobalFunction( EF, n -> Atlas1( n, 6 ) );
InstallGlobalFunction( EG, n -> Atlas1( n, 7 ) );
InstallGlobalFunction( EH, n -> Atlas1( n, 8 ) );


#############################################################################
##
#F  NK( <n>, <k>, <d> ) . . . . . . . . . . utility for ATLAS irrationalities
##
InstallGlobalFunction( NK, function( n, k, deriv )
    local  nk;
    if n <= 2 or ( k in [ 2, 3, 5, 6, 7 ] and Phi( n ) mod k <> 0 )
              or k < 2 or k > 8 then
      return fail;
    fi;
    if k mod 4 = 0 then

      # an automorphism of order 4 exists if 4 divides $p-1$ for an odd
      # prime divisor $p$ of `n', or if 16 divides `n';
      # an automorphism of order 8 exists if 8 divides $p-1$ for an odd
      # prime divisor $p$ of `n', or if 32 divides `n';
      if ForAll(Set(FactorsInt(n)),x->(x-1) mod k<>0) and n mod (4*k)<>0 then
        return fail;
      fi;
    fi;
    nk:= 1;
    if k in [ 2, 3, 5, 7 ] then   # for primes
      while true do
        if ( nk ^ k ) mod n = 1 and nk mod n <> 1 then
          if deriv = 0 then return nk; fi;
          deriv:= deriv - 1;
        fi;
        if ( ( (-nk) ^ k ) - 1 ) mod n = 0 and ( -nk -1 ) mod n <> 0 then
          if deriv = 0 then return -nk; fi;
          deriv:= deriv - 1;
        fi;
        nk:= nk + 1;
      od;
    elif k = 4 then
      while true do
        if ( nk ^ 4 ) mod n = 1 and ( nk ^ 2 ) mod n <> 1 then
          if deriv = 0 then return nk; fi;
          deriv:= deriv - 1;
          if deriv = 0 then return -nk; fi;
          deriv:= deriv - 1;
        fi;
        nk:= nk + 1;
      od;
    elif k = 6 then
      while true do
        if (nk^6) mod n = 1 and (nk^2) mod n <> 1 and (nk^3) mod n <> 1 then
          if deriv = 0 then return nk; fi;
          deriv:= deriv - 1;
        fi;
        if (nk^6) mod n=1 and (nk^2) mod n<>1 and (-(nk^3) mod n)+n<>1 then
          if deriv = 0 then return -nk; fi;
          deriv:= deriv - 1;
        fi;
        nk:= nk + 1;
      od;
    elif k = 8 then
      while true do
        if ( nk ^ 8 ) mod n = 1 and ( nk ^ 4 ) mod n <> 1 then
          if deriv = 0 then return nk; fi;
          deriv:= deriv - 1;
          if deriv = 0 then return -nk; fi;
          deriv:= deriv - 1;
        fi;
        nk:= nk + 1;
      od;
    fi;
end );


#############################################################################
##
#F  Atlas2( <n>, <k>, <deriv> ) . . . . . . utility for ATLAS irrationalities
##
BindGlobal( "Atlas2", function( n, k, deriv )

    local i, e, nk, result;

    if not ( IsInt( n ) and IsInt( k ) and IsInt( deriv ) ) then
      Error( "usage: ATLAS irrationalities require integral arguments" );
    fi;

    nk:= NK( n, k, deriv );
    e:= E(n);
    result:= 0;
    for i in [ 0 .. k-1 ] do
      result:= result + e^( (nk^i) mod n );
    od;
    return result;
end );


#############################################################################
##
#F  EY(<n>), EY(<n>,<deriv>) . . . . . . .  ATLAS irrationalities $y_n$ resp.
#F                                          $y_n^{<deriv>}$
#F  ... ES(<n>), ES(<n>,<deriv>)              ... $s_n$ resp. $s_n^{<deriv>}$
##
InstallGlobalFunction( EY, function(arg)
    if   Length(arg)=1 then return Atlas2(arg[1],2,0);
    elif Length(arg)=2 then return Atlas2(arg[1],2,arg[2]);
    else Error( "usage: EY(n) resp. EY(n,deriv)" ); fi;
end );

InstallGlobalFunction( EX, function(arg)
    if   Length(arg)=1 then return Atlas2(arg[1],3,0);
    elif Length(arg)=2 then return Atlas2(arg[1],3,arg[2]);
    else Error( "usage: EX(n) resp. EX(n,deriv)" ); fi;
end );

InstallGlobalFunction( EW, function(arg)
    if   Length(arg)=1 then return Atlas2(arg[1],4,0);
    elif Length(arg)=2 then return Atlas2(arg[1],4,arg[2]);
    else Error( "usage: EW(n) resp. EW(n,deriv)" ); fi;
end );

InstallGlobalFunction( EV, function(arg)
    if   Length(arg)=1 then return Atlas2(arg[1],5,0);
    elif Length(arg)=2 then return Atlas2(arg[1],5,arg[2]);
    else Error( "usage: EV(n) resp. EV(n,deriv)" ); fi;
end );

InstallGlobalFunction( EU, function(arg)
    if   Length(arg)=1 then return Atlas2(arg[1],6,0);
    elif Length(arg)=2 then return Atlas2(arg[1],6,arg[2]);
    else Error( "usage: EU(n) resp. EU(n,deriv)" ); fi;
end );

InstallGlobalFunction( ET, function(arg)
    if   Length(arg)=1 then return Atlas2(arg[1],7,0);
    elif Length(arg)=2 then return Atlas2(arg[1],7,arg[2]);
    else Error( "usage: ET(n) resp. ET(n,deriv)" ); fi;
end );

InstallGlobalFunction( ES, function(arg)
    if   Length(arg)=1 then return Atlas2(arg[1],8,0);
    elif Length(arg)=2 then return Atlas2(arg[1],8,arg[2]);
    else Error( "usage: ES(n) resp. ES(n,deriv)" ); fi;
end );


#############################################################################
##
#F  EM( <n> ), EM( <n>, <deriv> ) . . . . ATLAS irrationality $m_{<n>}$ resp.
##                                                        $m_{<n>}^{<deriv>}$
InstallGlobalFunction( EM, function( arg )
    local n;
    n:= arg[1];
    if Length( arg ) = 1 then
      return E(n) - E(n)^(-1);
    elif Length( arg ) = 2 and IsInt( n ) then
      return E(n) - E(n)^( NK( n, 2, arg[2] ) mod n );
    else
      Error( "usage: EM(<n>) resp. EM(<n>,<deriv>)" );
    fi;
end );


#############################################################################
##
#F  EL( <n> ), EL( <n>, <deriv> ) . . . . ATLAS irrationality $l_{<n>}$ resp.
##                                                        $l_{<n>}^{<deriv>}$
InstallGlobalFunction( EL, function( arg )
    local n, nk;
    n:= arg[1];
    if Length( arg ) > 2 or not IsInt( n ) then
      Error( "usage: EL( <n> ) resp. EL( <n>, <deriv> )" );
    fi;
    if Length(arg)=1 then
      nk:= NK(n,4,0) mod n;
    else
      nk:= NK(n,4,arg[2]) mod n;
    fi;
    return E(n)-E(n)^nk+E(n)^((nk^2) mod n)-E(n)^((nk^3) mod n);
end );


#############################################################################
##
#F  EK( <n> ), EK( <n>, <deriv> ) . . . . ATLAS irrationality $k_{<n>}$ resp.
##                                                        $k_{<n>}^{<deriv>}$
InstallGlobalFunction( EK, function( arg )

    local n, nk, e;

    n:= arg[1];
    if Length( arg ) > 2 or not IsInt( n ) then
      Error( "usage: EK( <n> ) resp. EK( <n>, <deriv> )" );
    fi;
    if Length(arg)=1 then
      nk:= NK(n,6,0) mod n;
    else
      nk:= NK(n,6,arg[2]) mod n;
    fi;
    e:= E(n);
    return e-e^nk+e^((nk^2) mod n)-e^((nk^3) mod n)+
           e^((nk^4) mod n)-e^((nk^5) mod n);
end );


#############################################################################
##
#F  EJ( <n> ), EJ( <n>, <deriv> ) . . . . ATLAS irrationality $j_{<n>}$ resp.
##                                                        $j_{<n>}^{<deriv>}$
InstallGlobalFunction( EJ, function( arg )
    local n, nk, e;
    n:= arg[1];
    if Length( arg ) > 2 or not IsInt( n ) then
      Error( "usage: EJ( <n> ) resp. EJ( <n>, <deriv> )" );
    fi;
    if Length(arg)=1 then
      nk:= NK(n,8,0) mod n;
    else
      nk:= NK(n,8,arg[2]) mod n;
    fi;
    e:= E(n);
    return e-e^nk+e^((nk^2) mod n)-e^((nk^3) mod n)+
           e^((nk^4) mod n)-e^((nk^5) mod n)+e^((nk^6) mod n)-
           e^((nk^7) mod n);
end );


#############################################################################
##
#F  ER( <n> ) . . . . ATLAS irrationality $r_{<n>}$ (pos. square root of <n>)
##
##  Different from other {\ATLAS} irrationalities,
##  `ER' (and its synonym `Sqrt') can be applied also to noninteger
##  rationals.
##
InstallGlobalFunction( ER, function( n )
    local factor;
    if IsInt( n ) then
      if n = 0 then
        return 0;
      elif n < 0 then
        factor:= E(4);
        n:= -n;
      else
        factor:= 1;
      fi;
#T split into a product of a square and a squarefree remainder!
      if   n mod 4 = 1 then
        return factor * ( 2 * EB(n) + 1 );
      elif n mod 4 = 2 then
        return factor * ( E(8) - E(8)^3 ) * ER( n / 2 );
      elif n mod 4 = 3 then
        return factor * (-E(4)) * ( 2 * EB(n) + 1 );
      else
        return factor * 2 * ER( n / 4 );
      fi;
    elif IsRat( n ) then
      factor:= DenominatorRat( n );
      return ER( NumeratorRat( n ) * factor ) / factor;
    else
      Error( "argument must be rational" );
    fi;
end );


#############################################################################
##
#F  EI( <n> ) . . . . ATLAS irrationality $i_{<n>}$ (the square root of -<n>)
##
InstallGlobalFunction( EI, n -> E(4) * ER(n) );


#############################################################################
##
#F  StarCyc( <cyc> )  . . . . the unique nontrivial galois conjugate of <cyc>
##
InstallGlobalFunction( StarCyc, function( cyc )
    local i, conj;
    conj:= [];
    for i in PrimeResidues( Conductor( cyc ) ) do
      AddSet( conj, GaloisCyc( cyc, i ) );
    od;
    if Length( conj ) = 2 then
      return Difference( conj, [ cyc ] )[1];
    else
      return fail;
    fi;
end );


#############################################################################
##
#F  Quadratic( <cyc> ) . . . . .  information about quadratic irrationalities
##
InstallGlobalFunction( Quadratic, function( cyc )

    local coeffs,     # Zumbroich basis coefficients of `cyc'
          facts,      # factors of conductor of `cyc'
          factsset,   # set of `facts'
          two_part,   # 2-part of the conductor of `cyc'
          root,       # `root' component of the result
          a,          # `a'    component of the result
          b,          # `b'    component of the result
          d,          # `d'    component of the result
          ATLAS,      # string that expresses `cyc' in {\sf ATLAS} format
          ATLAS2,     # another string, maybe shorter ...
          display;    # string that shows a way to input `cyc'

    if not IsCycInt( cyc ) then
      return fail;
    elif IsInt( cyc ) then
      return rec(
                  a       := cyc,
                  b       := 0,
                  root    := 1,
                  d       := 1,
                  ATLAS   := String( cyc ),
                  display := String( cyc )
                 );
    fi;

    coeffs:= ExtRepOfObj( cyc );
    facts:= FactorsInt( Length( coeffs ) );
    factsset:= Set( facts );
    two_part:= Number( facts, x -> x = 2 );

    # Compute candidates for `a', `b', `root', `d'.
    if two_part = 0 and Length( facts ) = Length( factsset ) then

      root:= Length( coeffs );
      if root mod 4 = 3 then
        root:= -root;
      fi;
      a:= StarCyc( cyc );
      if a = fail then
        return fail;
      fi;

      # Set `a' to the trace of `cyc' over the rationals.
      a:= cyc + a;

      if Length( factsset ) mod 2 = 0 then
        b:= 2 * coeffs[2] - a;
      else
        b:= 2 * coeffs[2] + a;
      fi;
      if a mod 2 = 0 and b mod 2 = 0 then
        a:= a / 2;
        b:= b / 2;
        d:= 1;
      else
        d:= 2;
      fi;

    elif two_part = 2 and Length( facts ) = Length( factsset ) + 1 then

      root:= Length( coeffs ) / 4;
      if root = 1 then
        a:= coeffs[1];
        b:= - coeffs[2];
      else
        a:= coeffs[5];
        if Length( factsset ) mod 2 = 0 then a:= -a; fi;
        b:= - coeffs[ root + 5 ];
      fi;
      if root mod 4 = 1 then
        root:= -root;
        b:= -b;
      fi;
      d:= 1;

    elif two_part = 3 then

      root:= Length( coeffs ) / 4;
      if root = 2 then
        a:= coeffs[1];
        b:= coeffs[2];
        if b = coeffs[4] then
          root:= -2;
        fi;
      else
        a:= coeffs[9];
        if Length( factsset ) mod 2 = 0 then a:= -a; fi;
        b:= coeffs[ root / 2 + 9 ];
        if b <> - coeffs[ 3 * root / 2 - 7 ] then
          root:= -root;
        elif ( root / 2 ) mod 4 = 3 then
          b:= -b;
        fi;
      fi;
      d:= 1;

    else
      return fail;
    fi;

    # Check whether the candidates `a', `b', `d', `root' are correct.
    if d * cyc <> a + b * ER( root ) then
      return fail;
    fi;

    # Compute a string for the irrationality in {\ATLAS} format.
    if d = 2 then

      # Necessarily `root' is congruent 1 mod 4, only $b_{'root'}$ possible.
      # We have $'cyc' = ('a' + `b') / 2 + `b' b_{'root'}$.
      if a + b = 0 then
        if b = 1 then
          ATLAS:= "";
        elif b = -1 then
          ATLAS:= "-";
        else
          ATLAS:= ShallowCopy( String( b ) );
        fi;
      elif b = 1 then
        ATLAS:= Concatenation( String( ( a + b ) / 2 ), "+" );
      elif b = -1 then
        ATLAS:= Concatenation( String( ( a + b ) / 2 ), "-" );
      elif 0 < b then
        ATLAS:= Concatenation( String( ( a + b ) / 2 ), "+", String( b ) );
      else
        ATLAS:= Concatenation( String( ( a + b ) / 2 ), String( b ) );
      fi;

      Append( ATLAS, "b" );
      if 0 < root then
        Append( ATLAS, String( root ) );
      else
        Append( ATLAS, String( -root ) );
      fi;

    else

      # `d' = 1, so we may use $i_{'root'}$ and $r_{'root'}$.
      if a = 0 then
        ATLAS:= "";
      else
        ATLAS:= ShallowCopy( String( a ) );
      fi;
      if a <> 0 and b > 0 then Append( ATLAS, "+" ); fi;
      if b = -1 then
        Append( ATLAS, "-" );
      elif b <> 1 then
        Append( ATLAS, String( b ) );
      fi;
      if root > 0 then
        ATLAS:= Concatenation( ATLAS, "r", String( root ) );
      elif root = -1 then
        Append( ATLAS, "i" );
      else
        ATLAS:= Concatenation( ATLAS, "i", String( -root ) );
      fi;

      if ( root - 1 ) mod 4 = 0 then

        # In this case, also $b_{|'root'|}$ is possible.
        # Note that here the coefficients are never equal to $\pm 1$.
        if a = -b then
          ATLAS2:= String( 2 * b );
        else
          ATLAS2:= Concatenation( String( a+b ), "+", String( 2*b ) );
        fi;
        if root > 0 then
          ATLAS2:= Concatenation( ATLAS2, "b", String( root ) );
        else
          ATLAS2:= Concatenation( ATLAS2, "b", String( -root ) );
        fi;

        if Length( ATLAS2 ) < Length( ATLAS ) then
          ATLAS:= ATLAS2;
        fi;

      fi;

    fi;

    # Compute a string used by the `Display' function for character tables.
    if a = 0 then
      if b = 1 then
        display:= "";
      elif b = -1 then
        display:= "-";
      else
        display:= Concatenation( String( b ), "*" );
      fi;
    elif b = 1 then
      display:= Concatenation( String( a ), "+" );
    elif b = -1 then
      display:= Concatenation( String( a ), "-" );
    elif 0 < b then
      display:= Concatenation( String( a ), "+", String( b ), "*" );
    else
      display:= Concatenation( String( a ), String( b ), "*" );
    fi;
    Append( display, Concatenation( "ER(", String( root ), ")" ) );
    if d <> 1 then
      display:= Concatenation( "(", display, ")/", String( d ) );
    fi;

    ConvertToStringRep( ATLAS );
    ConvertToStringRep( display );

    # Return the result.
    return rec(
                a       := a,
                b       := b,
                root    := root,
                d       := d,
                ATLAS   := ATLAS,
                display := display
               );
end );


#############################################################################
##
#M  GaloisMat( <mat> )  . . . . . . . . . . . . . for a matrix of cyclotomics
##
##  Note that we must not mix up plain lists and class functions, since
##  these objects lie in different families.
##
InstallMethod( GaloisMat,
    "for a matrix of cyclotomics",
    true,
    [ IsMatrix and IsCyclotomicCollColl ], 0,
    function( mat )

    local warned,      # at most one warning will be printed if `mat' grows
          ncha,        # number of rows in `mat'
          nccl,        # number of columns in `mat'
          galoisfams,  # list with information about conjugate characters:
                       #       1 means rational character,
                       #      -1 means character with undefs,
                       #       0 means dependent irrational character,
                       #  [ .. ] means leading irrational character.
          n,           # conductor of irrationalities in `mat'
          genexp,      # generators of prime residues mod `n'
          generators,  # permutation of `mat' induced by elements in `genexp'
          X,           # one row of `mat'
          i, j,        # loop over rows of `mat'
          irrats,      # set of irrationalities in `X'
          fusion,      # positions of `irrats' in `X'
          k, l, m,     # loop variables
          generator,
          irratsimages,
          automs,
          family,
          orders,
          exp,
          image,
          oldorder,
          cosets,
          auto,
          conj,
          blocklength,
          innerlength;

    warned := false;
    ncha   := Length( mat );
    mat    := ShallowCopy( mat );

    # Step 1:
    # Find the minimal cyclotomic field $Q_n$ containing all irrational
    # entries of <mat>.

    galoisfams:= [];
    n:= 1;
    for i in [ 1 .. ncha ] do
      if ForAny( mat[i], IsUnknown ) then
        galoisfams[i]:= -1;
      elif ForAll( mat[i], IsRat ) then
        galoisfams[i]:= 1;
      else
        n:= LcmInt( n, Conductor( mat[i] ) );
      fi;
    od;

    # Step 2:
    # Compute generators for Aut( Q(n):Q ), that is,
    # compute generators for (Z/nZ)* and convert them to exponents.

    if 1 < n then

      # Each Galois automorphism induces a permutation of rows.
      # Compute the permutations for each generating automorphism.
      # (Initialize with the identity permutation.)
      genexp:= Flat( GeneratorsPrimeResidues( n ).generators );
      generators:= List( genexp, x -> [ 1 .. ncha ] );

    else

      # The matrix is rational.
      generators:= [];

    fi;

    # Step 3:
    # For each character X, find and complete the family of conjugates.

    if 0 < ncha then
      nccl:= Length( mat[1] );
    fi;

    for i in [ 1 .. ncha ] do
      if not IsBound( galoisfams[i] ) then

        # We have found an independent character that is not integral
        # and contains no unknowns.

        X:= mat[i];
        for j in [ i+1 .. ncha ] do
          if mat[j] = X then
            galoisfams[j]:= Unknown();

            Print( "#E GaloisMat: row ", i, " is equal to row ", j, "\n" );
#T InfoWarning?

          fi;
        od;

        # Initialize the list of distinct irrationalities of `X'
        # (not ordered).
        # Each Galois automorphism induces a permutation of that list
        # rather than of the entries of `X' themselves.
        irrats:= [];

        # Store how to distribute the entries of irrats to `X'.
        fusion:= [];

        for j in [ 1 .. nccl ] do
          if IsCyc( X[j] ) and not IsRat( X[j] ) then
            k:= 1;
            while k <= Length( irrats ) and X[j] <> irrats[k] do
              k:= k+1;
            od;
            if k > Length( irrats ) then
              # This is the first appearance of `X[j]' in `X'.
              irrats[k]:= X[j];
            fi;

            # Store the position in `irrats'.
            fusion[j]:= k;
          else
            fusion[j]:= 0;
          fi;
        od;

        irratsimages:= [ irrats ];
        automs:= [ 1 ];
        family:= [ i ]; # indices of family members (same ordering as automs)
        orders:= [];    # orders[k] will be the order of the k-th generator
        for j in [ 1 .. Length( genexp ) ] do
          exp:= genexp[j];
          image:= List( irrats, x -> GaloisCyc( x, exp ) );
          oldorder:= Length( automs );  # group order up to now
          cosets:= [];
          orders[j]:= 1;
          while not image in irratsimages do
            orders[j]:= orders[j] + 1;
            for k in [ 1 .. oldorder ] do
              auto:= ( automs[k] * exp ) mod n;
              image:= List( irrats, x -> GaloisCyc( x, auto ) );
              conj:= [];    # the conjugate character
              for l in [ 1 .. nccl ] do
                if fusion[l] = 0 then
                  conj[l]:= X[l];
                else
                  conj[l]:= image[ fusion[l] ];
                fi;
              od;
              l:= i+1;
              while l <= ncha and mat[l] <> conj do l:= l+1; od;
#T use Position!
              if l <= ncha then

                galoisfams[l]:= 0;
                Add( family, l );
                for m in [ l+1 .. ncha ] do
                  if mat[m] = conj then galoisfams[m]:= 0; fi;
                od;

              else

                if not warned and 500 < Length( mat ) then
                  Info( InfoWarning, 1,
                        "GaloisMat: completion of <mat> will have",
                        " more than 500 rows" );
                  warned:= true;
                fi;

                Add( mat, conj );
                galoisfams[ Length( mat ) ]:= 0;
                Add( family, Length( mat ) );

              fi;
              Add( automs, auto );
              Add( cosets, image );
            od;
            exp:= exp * genexp[j];
            image:= List( irrats, x -> GaloisCyc( x, exp ) );
          od;
          irratsimages:= Concatenation( irratsimages, cosets );
        od;

        # Store the conjugates and automorphisms.
        galoisfams[i]:= [ family, automs ];

        # Now the length of `family' is the size of the Galois family of the
        # row `X'.
        # Compute the permutation operation of the generators on the set of
        # rows in `family'.

        blocklength:= 1;
        for j in [ 1 .. Length( genexp ) ] do

          innerlength:= blocklength;
          blocklength:= blocklength * orders[j];
          generator:= [ 1 .. blocklength ];

          # `genexp[j]' maps the conjugates under the action of
          # $\langle `genexp[1]', \ldots, `genexp[j-1]' \rangle$
          # (a set of length `innerlength') as one block to their images,
          # preserving the order of succession.

          for l in [ 1 .. blocklength - innerlength ] do
            generator[l]:= l + innerlength;
          od;

          # Compute how a power of `genexp[j]' maps back to the block.

          exp:= ( genexp[j] ^ orders[j] ) mod n;
          for l in [ 1 .. innerlength ] do
            generator[ l + blocklength - innerlength ]:=
                 Position( irratsimages, List( irrats,
                             x -> GaloisCyc( x, exp*automs[l] ) ) );
          od;

          # Transfer this operation to the cosets under the operation of
          # $\langle `genexp[j+1]',\ldots,`genexp[Length(genexp)]' \rangle$,
          # and transfer this to <mat> via `family'.

          for k in [ 0 .. Length( family ) / blocklength - 1 ] do
            for l in [ 1 .. blocklength ] do
              generators[j][ family[ l + k*blocklength ] ]:=
                           family[ generator[ l ] + k*blocklength ];
            od;
          od;

        od;

      fi;
    od;

    # Convert the `generators' component to a set of generating permutations.
    generators:= Set( List( generators, PermList ) );
    RemoveSet( generators, () );
    if IsEmpty( generators ) then
      generators:= [ () ];
    fi;

    # Return the result.
    return rec(
                mat        := mat,
                galoisfams := galoisfams,
                generators := generators
               );
    end );


#############################################################################
##
#M  RationalizedMat( <mat> )  . . . . . .  list of rationalized rows of <mat>
##
InstallMethod( RationalizedMat,
    "for a matrix",
    true,
    [ IsMatrix ], 0,
    function( mat )
    local i, rationalizedmat, rationalfams;

    rationalfams:= GaloisMat( mat );
    mat:= rationalfams.mat;
    rationalfams:= rationalfams.galoisfams;
    rationalizedmat:= [];
    for i in [ 1 .. Length( mat ) ] do
      if rationalfams[i] = 1 or rationalfams[i] = -1 then
        # The row is rational or contains unknowns.
        Add( rationalizedmat, mat[i] );
      elif IsList( rationalfams[i] ) then
        # The row is a leading character of a family.
        Add( rationalizedmat, Sum( mat{ rationalfams[i][1] } ) );
      fi;
    od;
    return rationalizedmat;
    end );


InstallOtherMethod( RationalizedMat,
    "for an empty list",
    true,
    [ IsList and IsEmpty ], 0,
    empty -> [] );


#############################################################################
##
#M  IsGeneratorsOfMagmaWithInverses( <cycs> ) . .  for a coll. of cyclotomics
##
##  Disallow to create groups of cyclotomics because the `\^' operator has
##  a meaning for cyclotomics that makes it not compatible with that for
##  groups.
##
InstallMethod( IsGeneratorsOfMagmaWithInverses,
    "for a collection of cyclotomics (return false)",
    true,
    [ IsCyclotomicCollection ],
    SUM_FLAGS, # override evrything else
    function( gens )
    Info( InfoWarning, 1,
          "no groups of cyclotomics allowed because of incompatible ^" );
    return false;
    end );


#############################################################################
##
#E

