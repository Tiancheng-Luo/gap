/****************************************************************************
**
*W  vecffe.c                    GAP source                      Werner Nickel
**
*H  @(#)$Id$
**
*Y  (C) 1998 School Math and Comp. Sci., University of St.  Andrews, Scotland
**
*/
#include        "system.h"              /* system dependent part           */

const char * Revision_vecffe_c =
   "@(#)$Id$";

#include        "gasman.h"              /* garbage collector               */
#include        "objects.h"             /* objects                         */
#include        "scanner.h"             /* scanner                         */

#include        "gap.h"                 /* error handling, initialisation  */

#include        "ariths.h"              /* basic arithmetic                */
#include        "lists.h"               /* generic lists                   */

#include        "bool.h"                /* booleans                        */

#include        "integer.h"             /* integers                        */
#include        "finfield.h"            /* finite fields                   */

#include        "records.h"             /* generic records                 */
#include        "precord.h"             /* plain records                   */

#include        "lists.h"               /* generic lists                   */
#include        "listoper.h"            /* operations for generic lists    */
#include        "plist.h"               /* plain lists                     */
#include        "string.h"              /* strings                         */

#define INCLUDE_DECLARATION_PART
#include        "vecffe.h"              /* functions for fin field vectors */
#undef  INCLUDE_DECLARATION_PART

#include        "range.h"               /* ranges                          */

#include        "calls.h"               /* needed for opers.h              */
#include        "opers.h"               /* for TRY_NEXT_METHOD             */

/****************************************************************************
**

*F  IsXTNumPlistFFE(<list>) . . . . . . . . . . .  test if a list is a vector
**
**  'IsXTNumPlistFFE'  returns 1  if   the list <list>  is   a vector of
**  elements in the same finite field and  0 otherwise.    As a  sideeffect
**  the type of  the   list  is  changed to 'T_PLIST_FFE'.
**
**  'IsXTNumPlistFFE' is the function in 'IsXTNumListFuncs' for finite field
**  vectors.
*/
#define IS_IMM_PLIST(list)  ((TNUM_OBJ(list) - T_PLIST) % 2)

Int             IsXTNumPlistFFE (
    Obj                 list )
{
    Int                 isVector;       /* result                          */
    UInt                len;            /* length of the list              */
    Obj                 elm;            /* one element of the list         */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* the common (?) field            */

    /* if we already know that the list is a vector, very good             */
    if      ( T_PLIST_FFE    <= TNUM_OBJ(list)
           && TNUM_OBJ(list) <= T_PLIST_FFE + IMMUTABLE ) {
        isVector = 1;
    }

    /* if it is a nonempty plain list, check the entries                   */
    else if ( (TNUM_OBJ(list) == T_PLIST
            || TNUM_OBJ(list) == T_PLIST + IMMUTABLE
            || TNUM_OBJ(list) == T_PLIST_DENSE
            || TNUM_OBJ(list) == T_PLIST_DENSE + IMMUTABLE
            || (T_PLIST_HOM <= TNUM_OBJ(list)
             && TNUM_OBJ(list) <= T_PLIST_HOM_SSORT + IMMUTABLE))
           && LEN_PLIST(list) != 0
           && ELM_PLIST(list,1) != 0
           && TNUM_OBJ( ELM_PLIST(list,1) ) == T_FFE ) {
        fld = FLD_FFE( ELM_PLIST(list,1) );
        len = LEN_PLIST(list);
        for ( i = 2; i <= len; i++ ) {
            elm = ELM_PLIST( list, i );
            if ( elm == 0
              || TNUM_OBJ(elm) != T_FFE
              || FLD_FFE(elm) != fld )
                break;
        }
        isVector = (len < i) ? 1 : 0;
        if ( isVector )  RetypeBag( list, T_PLIST_FFE + IS_IMM_PLIST(list) );
    }

    /* otherwise the list is certainly not a vector                        */
    else {
        isVector = 0;
    }

    /* return the result                                                   */
    return isVector;
}


/****************************************************************************
**
*F  IsXTNumMatFFE(<list>) . . . . . . . . . . . .  test if a list is a matrix
**
**  'IsXTNumMatFFE' returns 1 if the list <list> is a matrix and 0 otherwise.
**  As a sideeffect the type of the rows is changed to 'T_VECTOR'.
**
**  'IsXTNumMatFFE' is the function in 'IsXTNumListFuncs' for matrices.
*/
Int             IsXTNumMatFFE (
    Obj                 list )
{
    Int                 isMatrix;       /* result                          */
    UInt                cols;           /* length of the rows              */
    UInt                len;            /* length of the list              */
    Obj                 elm;            /* one element of the list         */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* the common (?) field            */

     /* if it is a nonempty plain list, check the entries                   */
    if ( (TNUM_OBJ(list) == T_PLIST
       || TNUM_OBJ(list) == T_PLIST +IMMUTABLE
       || TNUM_OBJ(list) == T_PLIST_DENSE
       || TNUM_OBJ(list) == T_PLIST_DENSE +IMMUTABLE
       || (T_PLIST_HOM <= TNUM_OBJ(list)
        && TNUM_OBJ(list) <= T_PLIST_TAB_SSORT +IMMUTABLE))
      && LEN_PLIST( list ) != 0
      && ELM_PLIST( list, 1 ) != 0
      && IsXTNumPlistFFE( ELM_PLIST( list, 1 ) ) ) {
        len = LEN_PLIST( list );
        elm = ELM_PLIST( list, 1 );
        cols = LEN_PLIST( elm );
        fld = FLD_FFE( ELM_PLIST(elm,1) );
        for ( i = 2; i <= len; i++ ) {
            elm = ELM_PLIST( list, i );
            if ( elm == 0
              || ! IsXTNumPlistFFE( elm )
              || LEN_PLIST( elm ) != cols
              || FLD_FFE( ELM_PLIST(elm, 1) ) != fld )
                break;
        }
        isMatrix = (len < i) ? 1 : 0;
    }

    /* otherwise the list is certainly not a matrix                        */
    else {
        isMatrix = 0;
    }

    /* return the result                                                   */
    return isMatrix;
}


/****************************************************************************
**
*F  SumFFEVecFFE(<elmL>,<vecR>) . . . .  sum of an fin field elm and a vector
**
**  'SumFFEVecFFE' returns the sum of the fin field elm <elmL> and the vector
**  <vecR>.  The sum is a  list, where each element is  the sum of <elmL> and
**  the corresponding element of <vecR>.
**
**  'SumFFEVecFFE' is an improved version  of  'SumSclList', which  does  not
**  call 'SUM'.
*/
Obj             SumFFEVecFFE (
    Obj                 elmL,
    Obj                 vecR )
{
    Obj                 vecS;           /* handle of the sum               */
    Obj *               ptrS;           /* pointer into the sum            */
    FFV                 valS;           /* the value of a sum              */
    Obj *               ptrR;           /* pointer into the right operand  */
    FFV                 valR;           /* the value of an element in vecR */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */
    FFV                 valL;           /* the value of elmL               */

    extern Obj          SumSclList( Obj, Obj );  /* generic method         */

    /* get the field and check that elmL and vecR have the same field      */
    fld = FLD_FFE( ELM_PLIST( vecR, 1 ) );
    if( FLD_FFE( elmL ) != fld ) {
      /* check the characteristic                                          */
      if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( elmL ) ) )
          return SumSclList( elmL, vecR );

        elmL = ErrorReturnObj(
         "<elm>+<vec>: <elm> and <vec> must belong to the same finite field",
         0L, 0L, "you can return a new <elm>" );
        return SUM( elmL, vecR );
    }

    /* make the result list                                                */
    len = LEN_PLIST( vecR );
    vecS = NEW_PLIST( IS_MUTABLE_OBJ(vecR) ?
		      T_PLIST_FFE :T_PLIST_FFE+IMMUTABLE, len );
    SET_LEN_PLIST( vecS, len );

    /* to add we need the successor table                                  */
    succ = SUCC_FF( fld );

    /* loop over the elements and add                                      */
    valL = VAL_FFE( elmL );
    ptrR = ADDR_OBJ( vecR );
    ptrS = ADDR_OBJ( vecS );
    for ( i = 1; i <= len; i++ ) {
        valR = VAL_FFE( ptrR[i] );
        valS = SUM_FFV( valL, valR, succ );
        ptrS[i] = NEW_FFE( fld, valS );
    }

    /* return the result                                                   */
    return vecS;
}


/****************************************************************************
**
*F  SumVecFFEFFE(<vecL>,<elmR>) . . . . . sum of a vector and a fin field elm
**
**  'SumVecFFEFFE' returns  the sum of   the  vector <vecL> and  the  finite
**  field element <elmR>.  The sum is a  list, where each element  is the sum
**  of <elmR> and the corresponding element of <vecL>.
**
**  'SumVecFFEFFE' is an improved version  of  'SumListScl', which  does  not
**  call 'SUM'.
*/
Obj             SumVecFFEFFE (
    Obj                 vecL,
    Obj                 elmR )
{
    Obj                 vecS;           /* handle of the sum               */
    Obj *               ptrS;           /* pointer into the sum            */
    Obj *               ptrL;           /* pointer into the left operand   */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */
    FFV                 valR;           /* the value of elmR               */
    FFV                 valL;           /* the value of an element in vecL */
    FFV                 valS;           /* the value of a sum              */

    extern Obj          SumListScl( Obj, Obj );  /* generic method         */

    /* get the field and check that vecL and elmR have the same field      */
    fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
    if( FLD_FFE( elmR ) != fld ) {
      /* check the characteristic                                          */
      if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( elmR ) ) )
          return SumListScl( vecL, elmR );

        elmR = ErrorReturnObj(
         "<vec>+<elm>: <elm> and <vec> must belong to the same finite field",
         0L, 0L, "you can return a new <elm>" );
        return SUM( vecL, elmR );
    }

    /* make the result list                                                */
    len = LEN_PLIST( vecL );
    vecS = NEW_PLIST( IS_MUTABLE_OBJ(vecL) ?
		      T_PLIST_FFE :T_PLIST_FFE+IMMUTABLE, len );
    SET_LEN_PLIST( vecS, len );

    /* to add we need the successor table                                  */
    succ = SUCC_FF( fld );

    /* loop over the elements and add                                      */
    valR = VAL_FFE( elmR );
    ptrL = ADDR_OBJ( vecL );
    ptrS = ADDR_OBJ( vecS );
    for ( i = 1; i <= len; i++ ) {
        valL = VAL_FFE( ptrL[i] );
        valS = SUM_FFV( valL, valR, succ );
        ptrS[i] = NEW_FFE( fld, valS );
    }

    /* return the result                                                   */
    return vecS;
}

/****************************************************************************
**
*F  SumVecFFEVecFFE(<vecL>,<vecR>)  . . . . . . . . . . .  sum of two vectors
**
**  'SumVecFFEVecFFE' returns the sum  of the two  vectors <vecL> and <vecR>.
**  The sum is a new list, where each element is the sum of the corresponding
**  elements of <vecL> and <vecR>.
**
**  'SumVecFFEVecFFE' is an improved version of 'SumListList', which does not
**  call 'SUM'.
*/
Obj             SumVecFFEVecFFE (
    Obj                 vecL,
    Obj                 vecR )
{
    Obj                 vecS;           /* handle of the sum               */
    Obj *               ptrS;           /* pointer into the sum            */
    FFV                 valS;           /* one element of sum list         */
    Obj *               ptrL;           /* pointer into the left operand   */
    FFV                 valL;           /* one element of left operand     */
    Obj *               ptrR;           /* pointer into the right operand  */
    FFV                 valR;           /* one element of right operand    */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */

    extern Obj          SumListList( Obj, Obj );  /* generic method        */

    /* check the lengths                                                   */
    len = LEN_PLIST( vecL );
    if ( len != LEN_PLIST( vecR ) ) {
        vecR = ErrorReturnObj(
             "Vector +: lenghts differ <left> %d,  <right> %d",
             (Int)len, (Int)LEN_PLIST( vecR ), 
             "you can return a new vector for <right>" );
        return SUM( vecL, vecR );
    }

    /* check the fields                                                    */
    fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
    if( FLD_FFE( ELM_PLIST( vecR, 1 ) ) != fld ) {
        /* check the characteristic                                        */
        if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( ELM_PLIST( vecR, 1 ) ) ) )
            return SumListList( vecL, vecR );

        vecR = ErrorReturnObj(
             "Vector +: vectors have different fields",
              0L, 0L, "you can return a new vector for <right>" );
        return SUM( vecL, vecR );
    }

    /* make the result list                                                */
    vecS = NEW_PLIST( (IS_MUTABLE_OBJ(vecL) || IS_MUTABLE_OBJ(vecR)) ?
		      T_PLIST_FFE : T_PLIST_FFE+IMMUTABLE, len );
    SET_LEN_PLIST( vecS, len );

    /* to add we need the successor table                                  */
    succ = SUCC_FF( fld );

    /* loop over the elements and add                                      */
    ptrL = ADDR_OBJ( vecL );
    ptrR = ADDR_OBJ( vecR );
    ptrS = ADDR_OBJ( vecS );
    for ( i = 1; i <= len; i++ ) {
        valL = VAL_FFE( ptrL[i] );
        valR = VAL_FFE( ptrR[i] );
        valS = SUM_FFV( valL, valR, succ );
        ptrS[i] = NEW_FFE( fld, valS );
    }

    /* return the result                                                   */
    return vecS;
}

/****************************************************************************
**
*F  DiffFFEVecFFE(<elmL>,<vecR>)   difference of a fin field elm and a vector
**
**  'DiffFFEVecFFE' returns  the difference  of  the finite field element
**  <elmL> and  the vector <vecR>.   The difference  is  a list,  where  each
**  element is the difference of <elmL> and the corresponding element of
**  <vecR>. 
**
**  'DiffFFEVecFFE'  is an improved  version of 'DiffSclList', which does not
**  call 'DIFF'.
*/
Obj             DiffFFEVecFFE (
    Obj                 elmL,
    Obj                 vecR )
{
    Obj                 vecD;           /* handle of the difference        */
    Obj *               ptrD;           /* pointer into the difference     */
    Obj                 elmD;           /* one element of difference list  */
    Obj *               ptrR;           /* pointer into the right operand  */
    Obj                 elmR;           /* one element of right operand    */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */
    FFV                 valR;           /* the value of elmL               */
    FFV                 valL;           /* the value of an element in vecR */
    FFV                 valD;           /* the value of a difference       */

    extern Obj          DiffSclList( Obj, Obj );  /* generic method        */

    /* check the fields                                                    */
    fld = FLD_FFE( ELM_PLIST( vecR, 1 ) );
    if( FLD_FFE( elmL ) != fld ) {
        /* check the characteristic                                        */
        if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( elmL ) ) )
            return DiffSclList( elmL, vecR );

        elmL = ErrorReturnObj(
         "<elm>-<vec>: <elm> and <vec> must belong to the same finite field",
         0L, 0L, "you can return a new <elm>" );
        return DIFF( elmL, vecR );
    }

    /* make the result list                                                */
    len = LEN_PLIST( vecR );
    vecD = NEW_PLIST( IS_MUTABLE_OBJ(vecR) ?
		      T_PLIST_FFE :T_PLIST_FFE+IMMUTABLE, len );
    SET_LEN_PLIST( vecD, len );

    /* to subtract we need the successor table                             */
    succ = SUCC_FF( fld );

    /* loop over the elements and subtract                                 */
    valL = VAL_FFE( elmL );
    ptrR = ADDR_OBJ( vecR );
    ptrD = ADDR_OBJ( vecD );
    for ( i = 1; i <= len; i++ ) {
        valR = VAL_FFE( ptrR[i] );
        valR = NEG_FFV( valR, succ );
        valD = SUM_FFV( valL, valR, succ );
        ptrD[i] = NEW_FFE( fld, valD );
    }

    /* return the result                                                   */
    return vecD;
}


/****************************************************************************
**
*F  DiffVecFFEFFE(<vecL>,<elmR>)   difference of a vector and a fin field elm
**
**  'DiffVecFFEFFE' returns   the  difference of the  vector  <vecL>  and the
**  finite field element <elmR>.  The difference   is a list,   where each
**  element  is the difference of <elmR> and the corresponding element of
**  <vecL>. 
**
**  'DiffVecFFEFFE' is an improved  version of 'DiffListScl', which  does not
**  call 'DIFF'.
*/
Obj             DiffVecFFEFFE (
    Obj                 vecL,
    Obj                 elmR )
{
    Obj                 vecD;           /* handle of the difference        */
    Obj *               ptrD;           /* pointer into the difference     */
    FFV                 valD;           /* the value of a difference       */
    Obj *               ptrL;           /* pointer into the left operand   */
    FFV                 valL;           /* the value of an element in vecL */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */
    FFV                 valR;           /* the value of elmR               */

    extern Obj          DiffListScl( Obj, Obj );  /* generic method        */

    /* get the field and check that vecL and elmR have the same field      */
    fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
    if( FLD_FFE( elmR ) != fld ) {
        /* check the characteristic                                        */
        if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( elmR ) ) )
            return DiffListScl( vecL, elmR );

        elmR = ErrorReturnObj(
         "<vec>-<elm>: <elm> and <vec> must belong to the same finite field",
         0L, 0L, "you can return a new <elm>" );
        return DIFF( vecL, elmR );
    }

    /* make the result list                                                */
    len = LEN_PLIST( vecL );
    vecD = NEW_PLIST( IS_MUTABLE_OBJ(vecL) ?
		      T_PLIST_FFE :T_PLIST_FFE+IMMUTABLE, len );
    SET_LEN_PLIST( vecD, len );

    /* to subtract we need the successor table                             */
    succ = SUCC_FF( fld );

    /* loop over the elements and subtract                                 */
    valR = VAL_FFE( elmR );
    valR = NEG_FFV( valR, succ );
    ptrL = ADDR_OBJ( vecL );
    ptrD = ADDR_OBJ( vecD );
    for ( i = 1; i <= len; i++ ) {
        valL = VAL_FFE( ptrL[i] );
        valD = SUM_FFV( valL, valR, succ );
        ptrD[i] = NEW_FFE( fld, valD );
    }

    /* return the result                                                   */
    return vecD;
}


/****************************************************************************
**
*F  DiffVecFFEVecFFE(<vecL>,<vecR>) . . . . . . . . difference of two vectors
**
**  'DiffVecFFEVecFFE'  returns the difference of the  two vectors <vecL> and
**  <vecR>.   The  difference is   a new   list, where  each  element  is the
**  difference of the corresponding elements of <vecL> and <vecR>.
**
**  'DiffVecFFEVecFFE' is an improved  version of  'DiffListList', which does
**  not call 'DIFF'.
*/
Obj             DiffVecFFEVecFFE (
    Obj                 vecL,
    Obj                 vecR )
{
    Obj                 vecD;           /* handle of the difference        */
    Obj *               ptrD;           /* pointer into the difference     */
    FFV                 valD;           /* one element of difference list  */
    Obj *               ptrL;           /* pointer into the left operand   */
    FFV                 valL;           /* one element of left operand     */
    Obj *               ptrR;           /* pointer into the right operand  */
    FFV                 valR;           /* one element of right operand    */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */

    extern Obj          DiffListList( Obj, Obj );  /* generic method       */

    /* check the lengths                                                   */
    len = LEN_PLIST( vecL );
    if ( len != LEN_PLIST( vecR ) ) {
        vecR = ErrorReturnObj(
             "Vector -: lenghts differ <left> %d,  <right> %d",
             (Int)len, (Int)LEN_PLIST( vecR ), 
             "you can return a new vector for <right>" );
        return DIFF( vecL, vecR );
    }

    /* check the fields                                                    */
    fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
    if( FLD_FFE( ELM_PLIST( vecR, 1 ) ) != fld ) {
        /* check the characteristic                                        */
        if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( ELM_PLIST( vecR, 1 ) ) ) )
            return DiffListList( vecL, vecR );

        vecR = ErrorReturnObj(
             "Vector -: vectors have different fields",
              0L, 0L, "you can return a new vector for <right>" );
        return DIFF( vecL, vecR );
    }

    /* make the result list                                                */
    vecD = NEW_PLIST( (IS_MUTABLE_OBJ(vecL) || IS_MUTABLE_OBJ(vecR)) ?
		      T_PLIST_FFE : T_PLIST_FFE+IMMUTABLE, len );
    SET_LEN_PLIST( vecD, len );

    /* to subtract we need the successor table                             */
    succ = SUCC_FF( fld );

    /* loop over the elements and subtract                                 */
    ptrL = ADDR_OBJ( vecL );
    ptrR = ADDR_OBJ( vecR );
    ptrD = ADDR_OBJ( vecD );
    for ( i = 1; i <= len; i++ ) {
        valL = VAL_FFE( ptrL[i] );
        valR = VAL_FFE( ptrR[i] );
        valR = NEG_FFV( valR, succ );
        valD = SUM_FFV( valL, valR, succ );
        ptrD[i] = NEW_FFE( fld, valD );
    }

    /* return the result                                                   */
    return vecD;
}


/****************************************************************************
**
*F  ProdFFEVecFFE(<elmL>,<vecR>)  . . product of a fin field elm and a vector
**
**  'ProdFFEVecFFE' returns the product of the finite field element  <elmL>
**  and the vector <vecR>.  The product is  the list, where  each element is
**  the product  of <elmL> and the corresponding entry of <vecR>.
**
**  'ProdFFEVecFFE'  is an  improved version of 'ProdSclList', which does not
**  call 'PROD'.
*/
Obj             ProdFFEVecFFE (
    Obj                 elmL,
    Obj                 vecR )
{
    Obj                 vecP;           /* handle of the product           */
    Obj *               ptrP;           /* pointer into the product        */
    FFV                 valP;           /* the value of a product          */
    Obj *               ptrR;           /* pointer into the right operand  */
    FFV                 valR;           /* the value of an element in vecR */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */
    FFV                 valL;           /* the value of elmL               */

    extern Obj          ProdSclList( Obj, Obj );  /* generic method        */

    /* get the field and check that elmL and vecR have the same field      */
    fld = FLD_FFE( ELM_PLIST( vecR, 1 ) );
    if( FLD_FFE( elmL ) != fld ) {
        /* check the characteristic                                        */
        if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( elmL ) ) )
            return ProdSclList( elmL, vecR );

        elmL = ErrorReturnObj(
         "<elm>*<vec>: <elm> and <vec> must belong to the same finite field",
         0L, 0L, "you can return a new <elm>" );
        return PROD( elmL, vecR );
    }

    /* make the result list                                                */
    len = LEN_PLIST( vecR );
    vecP = NEW_PLIST( IS_MUTABLE_OBJ(vecR) ?
		      T_PLIST_FFE :T_PLIST_FFE+IMMUTABLE, len );
    SET_LEN_PLIST( vecP, len );

    /* to multiply we need the successor table                             */
    succ = SUCC_FF( fld );

    /* loop over the elements and multiply                                 */
    valL = VAL_FFE( elmL );
    ptrR = ADDR_OBJ( vecR );
    ptrP = ADDR_OBJ( vecP );
    for ( i = 1; i <= len; i++ ) {
        valR = VAL_FFE( ptrR[i] );
        valP = PROD_FFV( valL, valR, succ );
        ptrP[i] = NEW_FFE( fld, valP );
    }

    /* return the result                                                   */
    return vecP;
}

/****************************************************************************
**
*F  ProdVecFFEFFE(<vecL>,<elmR>)  .  product of a vector and a fin field elm
**
**  'ProdVecFFEFFE' returns the product of the finite field element  <elmR>
**  and the vector <vecL>.  The  product is the  list, where each element  is
**  the product of <elmR> and the corresponding element of <vecL>.
**
**  'ProdVecFFEFFE'  is an  improved version of 'ProdSclList', which does not
**  call 'PROD'.
*/
Obj             ProdVecFFEFFE (
    Obj                 vecL,
    Obj                 elmR )
{
    Obj                 vecP;           /* handle of the product           */
    Obj *               ptrP;           /* pointer into the product        */
    FFV                 valP;           /* the value of a product          */
    Obj *               ptrL;           /* pointer into the left operand   */
    FFV                 valL;           /* the value of an element in vecL */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */
    FFV                 valR;           /* the value of elmR               */

    extern Obj          ProdListScl( Obj, Obj );  /* generic method        */

    /* get the field and check that vecL and elmR have the same field      */
    fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
    if( FLD_FFE( elmR ) != fld ) {
        /* check the characteristic                                        */
        if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( elmR ) ) )
            return ProdListScl( vecL, elmR );

        elmR = ErrorReturnObj(
         "<vec>*<elm>: <elm> and <vec> must belong to the same finite field",
         0L, 0L, "you can return a new <elm>" );
        return PROD( vecL, elmR );
    }

    /* make the result list                                                */
    len = LEN_PLIST( vecL );
    vecP = NEW_PLIST( IS_MUTABLE_OBJ(vecL) ?
		      T_PLIST_FFE :T_PLIST_FFE+IMMUTABLE, len );
    SET_LEN_PLIST( vecP, len );

    /* to multiply we need the successor table                             */
    succ = SUCC_FF( fld );

    /* loop over the elements and multiply                                 */
    valR = VAL_FFE( elmR );
    ptrL = ADDR_OBJ( vecL );
    ptrP = ADDR_OBJ( vecP );
    for ( i = 1; i <= len; i++ ) {
        valL = VAL_FFE( ptrL[i] );
        valP = PROD_FFV( valL, valR, succ );
        ptrP[i] = NEW_FFE( fld, valP );
    }

    /* return the result                                                   */
    return vecP;
}


/****************************************************************************
**
*F  ProdVecFFEVecFFE(<vecL>,<vecR>) . . . . . . . . .  product of two vectors
**
**  'ProdVecFFEVecFFE'  returns the product  of   the two vectors <vecL>  and
**  <vecR>.  The  product  is the  sum of the   products of the corresponding
**  elements of the two lists.
**
**  'ProdVecFFEVecFFE' is an improved version  of 'ProdListList',  which does
**  not call 'PROD'.
*/
Obj             ProdVecFFEVecFFE (
    Obj                 vecL,
    Obj                 vecR )
{
    FFV                 valP;           /* one product                     */
    FFV                 valS;           /* sum of the products             */
    Obj *               ptrL;           /* pointer into the left operand   */
    FFV                 valL;           /* one element of left operand     */
    Obj *               ptrR;           /* pointer into the right operand  */
    FFV                 valR;           /* one element of right operand    */
    UInt                len;            /* length                          */
    UInt                i;              /* loop variable                   */
    FF                  fld;            /* finite field                    */
    FF *                succ;           /* successor table                 */

    extern Obj          ProdListList( Obj, Obj );  /* generic method       */

    /* check the lengths                                                   */
    len = LEN_PLIST( vecL );
    if ( len != LEN_PLIST( vecR ) ) {
        vecR = ErrorReturnObj(
             "Vector *: lenghts differ <left> %d,  <right> %d",
             (Int)len, (Int)LEN_PLIST( vecR ), 
             "you can return a new vector for <right>" );
        return PROD( vecL, vecR );
    }

    /* check the fields                                                    */
    fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
    if( FLD_FFE( ELM_PLIST( vecR, 1 ) ) != fld ) {
        /* check the characteristic                                        */
        if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( ELM_PLIST( vecR, 1 ) ) ) )
            return ProdListList( vecL, vecR );

        vecR = ErrorReturnObj(
             "Vector *: vectors have different fields",
              0L, 0L, "you can return a new vector for <right>" );
        return PROD( vecL, vecR );
    }

    /* to add we need the successor table                                  */
    succ = SUCC_FF( fld );

    /* loop over the elements and add                                      */
    valS = (FFV)0;
    ptrL = ADDR_OBJ( vecL );
    ptrR = ADDR_OBJ( vecR );
    for ( i = 1; i <= len; i++ ) {
        valL = VAL_FFE( ptrL[i] );
        valR = VAL_FFE( ptrR[i] );
        valP = PROD_FFV( valL, valR, succ );
        valS = SUM_FFV( valS, valP, succ );
    }

    /* return the result                                                   */
    return NEW_FFE( fld, valS );
}

/****************************************************************************
**
*F  FuncAddRowVectorVecFFEsMult( <self>, <vecL>, <vecR>, <mult> )
**
*/

static Obj AddRowVectorOp;   /* BH changed to static */

Obj FuncAddRowVectorVecFFEsMult( Obj self, Obj vecL, Obj vecR, Obj mult )
{
  Obj *ptrL;
  Obj *ptrR;
  FFV  valM;
  FFV  valS;
  FFV  valL;
  FFV  valR;
  FF  fld;
  FFV *succ;
  UInt len;
  UInt i;

   if (VAL_FFE(mult) == 0)
     return (Obj) 0;

   if (TNUM_OBJ(vecL) != T_PLIST_FFE &&
       TNUM_OBJ(vecL) != T_PLIST_FFE+IMMUTABLE)
     return TRY_NEXT_METHOD;

   if (TNUM_OBJ(vecR) != T_PLIST_FFE &&
       TNUM_OBJ(vecR) != T_PLIST_FFE+IMMUTABLE)
     return TRY_NEXT_METHOD;

   
  /* check the lengths                                                   */
  len = LEN_PLIST( vecL );
  if ( len != LEN_PLIST( vecR ) ) {
    vecR = ErrorReturnObj(
			  "Vector *: lenghts differ <left> %d,  <right> %d",
			  (Int)len, (Int)LEN_PLIST( vecR ), 
			  "you can return a new vector for <right>" );
    return CALL_3ARGS(AddRowVectorOp, vecL, vecR, mult);
  }

  /* check the fields                                                    */
  fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
  if( FLD_FFE( ELM_PLIST( vecR, 1 ) ) != fld ) {
    /* check the characteristic                                        */
    if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( ELM_PLIST( vecR, 1 ) ) ) )
      return TRY_NEXT_METHOD;
    
    vecR = ErrorReturnObj(
			  "AddRowVector: vectors have different fields",
			  0L, 0L, "you can return a new vector for <right>" );
    return CALL_3ARGS(AddRowVectorOp, vecL, vecR, mult);
  }

  /* Now check the multplier field */
  if( FLD_FFE( mult ) != fld ) {
    /* check the characteristic                                        */
    if( CHAR_FF( fld ) != CHAR_FF( FLD_FFE( mult ) ) )
      {
	mult = ErrorReturnObj(
			      "AddRowVector: multiplier has different field",
			      0L, 0L, "you can return a new multiplier" );
	return CALL_3ARGS(AddRowVectorOp, vecL, vecR, mult);
      }

    /* if the multiplier is over a non subfield then redispatch */
    if ((DEGR_FF(fld) % DegreeFFE(mult)) != 0)
      return TRY_NEXT_METHOD;

    /* otherwise it's a subfield, so promote it */
    valM = VAL_FFE(mult);
    if (valM != 0)
      valM = 1 + (valM-1)*(SIZE_FF(fld)-1)/(SIZE_FF(FLD_FFE(mult))-1);
  }
  else
    valM = VAL_FFE(mult);

  
  succ = SUCC_FF(fld);
  ptrL = ADDR_OBJ(vecL);
  ptrR = ADDR_OBJ(vecR);

  /* two versions of the loop to avoid multipling by 1 */
  if (valM == 1)
    for (i = 1; i <= len; i++)
      {
	valL = VAL_FFE(ptrL[i]);
	valR = VAL_FFE(ptrR[i]);
	valS = SUM_FFV(valL, valR, succ);
	ptrL[i] = NEW_FFE(fld,valS);
      }
  else
    for (i = 1; i <= len; i++)
      {
	valL = VAL_FFE(ptrL[i]);
	valR = VAL_FFE(ptrR[i]);
	valS = PROD_FFV(valR, valM, succ);
	valS = SUM_FFV(valL, valS, succ);
	ptrL[i] = NEW_FFE(fld,valS);
      }
  return (Obj) 0;
}
/****************************************************************************
**
*F  FuncMultRowVectorVecFFEs( <self>, <vec>, <mult> )
**
*/

static Obj MultRowVectorOp;   /* BH changed to static */

Obj FuncMultRowVectorVecFFEs( Obj self, Obj vec, Obj mult )
{
  Obj *ptr;
  FFV  valM;
  FFV  valS;
  FFV  val;
  FF  fld;
  FFV *succ;
  UInt len;
  UInt i;

   if (VAL_FFE(mult) == 1)
     return (Obj) 0;

   if (TNUM_OBJ(vec) != T_PLIST_FFE &&
       TNUM_OBJ(vec) != T_PLIST_FFE+IMMUTABLE)
     return TRY_NEXT_METHOD;
   
  /* check the lengths                                                   */
  len = LEN_PLIST( vec );

  fld = FLD_FFE( ELM_PLIST(vec,1));
  /* Now check the multplier field */
  if( FLD_FFE( mult ) != fld ) {
    /* check the characteristic                                        */
    if( CHAR_FF( fld ) != CHAR_FF( FLD_FFE( mult ) ) )
      {
	mult = ErrorReturnObj(
			      "MultRowVector: multiplier has different field",
			      0L, 0L, "you can return a new multiplier" );
	return CALL_2ARGS(MultRowVectorOp, vec, mult);
      }

    /* if the multiplier is over a non subfield then redispatch */
    if ((DEGR_FF(fld) % DegreeFFE(mult)) != 0)
      return TRY_NEXT_METHOD;

    /* otherwise it's a subfield, so promote it */
    valM = VAL_FFE(mult);
    if (valM != 0)
      valM = 1 + (valM-1)*(SIZE_FF(fld)-1)/(SIZE_FF(FLD_FFE(mult))-1);
  }
  else
    valM = VAL_FFE(mult);

  
  succ = SUCC_FF(fld);
  ptr = ADDR_OBJ(vec);

  /* two versions of the loop to avoid multipling by 0 */
  if (valM == 0)
    {
      Obj z;
      z = NEW_FFE(fld,0);
      for (i = 1; i <= len; i++)
	{
	  ptr[i] = z;
	}
    }
  else
    for (i = 1; i <= len; i++)
      {
	val = VAL_FFE(ptr[i]);
	valS = PROD_FFV(val, valM, succ);
	ptr[i] = NEW_FFE(fld,valS);
      }
  return (Obj) 0;
}

/****************************************************************************
**
*F  FuncAddRowVectorVecFFEs( <self>, <vecL>, <vecR> )
**
*/


Obj FuncAddRowVectorVecFFEs( Obj self, Obj vecL, Obj vecR )
{
  Obj *ptrL;
  Obj *ptrR;
  FFV  valS;
  FFV  valL;
  FFV  valR;
  FF  fld;
  FFV *succ;
  UInt len;
  UInt i;
  
   if (TNUM_OBJ(vecL) != T_PLIST_FFE &&
       TNUM_OBJ(vecL) != T_PLIST_FFE+IMMUTABLE)
     return TRY_NEXT_METHOD;

   if (TNUM_OBJ(vecR) != T_PLIST_FFE &&
       TNUM_OBJ(vecR) != T_PLIST_FFE+IMMUTABLE)
     return TRY_NEXT_METHOD;

  /* check the lengths                                                   */
  len = LEN_PLIST( vecL );
  if ( len != LEN_PLIST( vecR ) ) {
    vecR = ErrorReturnObj(
			  "Vector *: lenghts differ <left> %d,  <right> %d",
			  (Int)len, (Int)LEN_PLIST( vecR ), 
			  "you can return a new vector for <right>" );
    return CALL_2ARGS(AddRowVectorOp, vecL, vecR);
  }

  /* check the fields                                                    */
  fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
  if( FLD_FFE( ELM_PLIST( vecR, 1 ) ) != fld ) {
    /* check the characteristic                                        */
    if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( ELM_PLIST( vecR, 1 ) ) ) )
      return TRY_NEXT_METHOD;
    
    vecR = ErrorReturnObj(
			  "AddRowVector: vectors have different fields",
			  0L, 0L, "you can return a new vector for <right>" );
    return CALL_2ARGS(AddRowVectorOp, vecL, vecR);
  }


  
  succ = SUCC_FF(fld);
  ptrL = ADDR_OBJ(vecL);
  ptrR = ADDR_OBJ(vecR);

  for (i = 1; i <= len; i++)
    {
      valL = VAL_FFE(ptrL[i]);
      valR = VAL_FFE(ptrR[i]);
      valS = SUM_FFV(valL, valR, succ);
      ptrL[i] = NEW_FFE(fld,valS);
    }
  return (Obj) 0;
}

/****************************************************************************
**
*F  ProdVectorMatrix(<vecL>,<vecR>) . . . .  product of a vector and a matrix
**
**  'ProdVectorMatrix' returns the product of the vector <vecL> and the matrix
**  <vecR>.  The product is the sum of the  rows  of <vecR>, each multiplied by
**  the corresponding entry of <vecL>.
**
**  'ProdVectorMatrix'  is an improved version of 'ProdListList',  which does
**  not  call 'PROD' and  also accummulates  the sum into  one  fixed  vector
**  instead of allocating a new for each product and sum.
*/
Obj             ProdVecFFEMatFFE (
				  Obj                 vecL,
				  Obj                 matR )
{
  Obj                 vecP;           /* handle of the product           */
  Obj *               ptrP;           /* pointer into the product        */
  FFV *               ptrV;           /* value pointer into the product  */
  FFV                 valP;           /* one value of the product        */
  FFV                 valS;           /* value of a sum                  */
  FFV                 valL;           /* one value of the left operand   */
  Obj                 vecR;           /* one vector of the right operand */
  Obj *               ptrR;           /* pointer into the right vector   */
  FFV                 valR;           /* one value from the right vector */
  UInt                len;            /* length                          */
  UInt                col;            /* length of the rows in matR      */
  UInt                i, k;           /* loop variables                  */
  FF                  fld;            /* the common finite field         */
  FF *                succ;           /* the successor table             */

  extern Obj          ProdListList( Obj, Obj );  /* generic method       */

  /* check the lengths                                                   */
  len = LEN_PLIST( vecL );
  col = LEN_PLIST( ELM_PLIST( matR, 1 ) );
  if ( len != LEN_PLIST( matR ) ) {
    matR = ErrorReturnObj(
			  "<vec>*<mat>: <vec> (%d) must have the same length as <mat> (%d)",
			  (Int)len, (Int)col,
			  "you can return a new matrix for <mat>" );
    return PROD( vecL, matR );
  }

  /* check the fields                                                    */
  vecR = ELM_PLIST( matR, 1 );
  fld = FLD_FFE( ELM_PLIST( vecL, 1 ) );
  if( FLD_FFE( ELM_PLIST( vecR, 1 ) ) != fld ) {
    /* check the characteristic                                        */
    if( CHAR_FF( fld ) == CHAR_FF( FLD_FFE( ELM_PLIST( vecR, 1 ) ) ) )
      return ProdListList( vecL, matR );

    matR = ErrorReturnObj(
			  "<vec>*<mat>: <vec> and <mat> have different fields",
			  0L, 0L, "you can return a new matrix for <matR>" );
    return PROD( vecL, matR );
  }

  /* make the result list by multiplying the first entries               */
  vecP = ProdFFEVecFFE( ELM_PLIST( vecL, 1 ), vecR );

  /* to add we need the successor table                                  */
  succ = SUCC_FF( fld );

  /* convert vecP into a list of values                                  */
  /*N 5Jul1998 werner: This only works if sizeof(FFV) <= sizeof(Obj)     */
  /*N We have to be careful not to overwrite the length info             */
  ptrP = ADDR_OBJ( vecP );
  ptrV = ((FFV*)(ptrP+1))-1;
  for ( k = 1; k <= col; k++ )
    ptrV[k] = VAL_FFE( ptrP[k] );

  /* loop over the other entries and multiply                            */
  for ( i = 2; i <= len; i++ ) {
    valL = VAL_FFE( ELM_PLIST( vecL, i ) );
    vecR = ELM_PLIST( matR, i );
    ptrR = ADDR_OBJ( vecR );
    if( valL == (FFV)1 ) {
      for ( k = 1; k <= col; k++ ) {
	valR = VAL_FFE( ptrR[k] );
	valP = ptrV[k];
	ptrV[k] = SUM_FFV( valP, valR, succ );
      }
    }
    else if ( valL != (FFV)0 ) {
      for ( k = 1; k <= col; k++ ) {
	valR = VAL_FFE( ptrR[k] );
	valR = PROD_FFV( valL, valR, succ );
	valP = ptrV[k];
	ptrV[k] = SUM_FFV( valP, valR, succ );
      }
    }
  }

  /* convert vecP back into a list of finite field elements              */
  /*N 5Jul1998 werner: This only works if sizeof(FFV) <= sizeof(Obj)     */
  /*N We have to be careful not to overwrite the length info             */
  for ( k = col; k >= 1; k-- )
    ptrP[k] = NEW_FFE( fld, ptrV[k] );

  /* return the result                                                   */
  return vecP;
}




/****************************************************************************
**
*F * * * * * * * * * * * * * initialize package * * * * * * * * * * * * * * *
*/

/****************************************************************************
**
*V  GVarFuncs . . . . . . . . . . . . . . . . . . list of functions to export
*/
static StructGVarFunc GVarFuncs [] = {

  { "ADD_ROWVECTOR_VECFFES_3", 3, "vecl, vecr, mult",
    FuncAddRowVectorVecFFEsMult, "src/vecffe.c: ADD_ROWVECTOR_VECFFES_3" },

  { "ADD_ROWVECTOR_VECFFES_2", 2, "vecl, vecr",
    FuncAddRowVectorVecFFEs, "src/vecffe.c: ADD_ROWVECTOR_VECFFES_2" },

  { "MULT_ROWVECTOR_VECFFES", 2, "vec, mult",
    FuncMultRowVectorVecFFEs, "src/vecffe.c: MULT_ROWVECTOR_VECFFES" },
  
    { 0 }

};


/****************************************************************************
**
*F  InitKernel( <module> )  . . . . . . . . initialise kernel data structures
*/
static Int InitKernel (
    StructInitInfo *    module )
{
    Int                 t1;
    Int                 t2;

    IsXTNumListFuncs[ T_PLIST_FFE    ] = IsXTNumPlistFFE;
    IsXTNumListFuncs[ T_MAT_FFE      ] = IsXTNumMatFFE;

    /* install the arithmetic operation methods                            */
    for ( t1 = T_PLIST_FFE; t1 <= T_PLIST_FFE + IMMUTABLE; t1++ ) {
        SumFuncs[  T_FFE ][  t1   ] = SumFFEVecFFE;
        SumFuncs[   t1   ][ T_FFE ] = SumVecFFEFFE;
        DiffFuncs[ T_FFE ][  t1   ] = DiffFFEVecFFE;
        DiffFuncs[  t1   ][ T_FFE ] = DiffVecFFEFFE;
        ProdFuncs[ T_FFE ][  t1   ] = ProdFFEVecFFE;
        ProdFuncs[  t1   ][ T_FFE ] = ProdVecFFEFFE;
    }

    for ( t1 = T_PLIST_FFE; t1 <= T_PLIST_FFE + IMMUTABLE; t1++ ) {
        for ( t2 = T_PLIST_FFE; t2 <= T_PLIST_FFE + IMMUTABLE; t2++ ) {
            SumFuncs[  t1 ][ t2 ] =  SumVecFFEVecFFE;
            DiffFuncs[ t1 ][ t2 ] = DiffVecFFEVecFFE;
            ProdFuncs[ t1 ][ t2 ] = ProdVecFFEVecFFE;
        }
    }

    for ( t1 = T_PLIST_FFE; t1 <= T_PLIST_FFE + IMMUTABLE; t1++ ) {
        ProdFuncs[ t1        ][ T_MAT_FFE ] = ProdVecFFEMatFFE;
    }
    
    InitHdlrFuncsFromTable( GVarFuncs );

    InitFopyGVar("AddRowVector", &AddRowVectorOp);
    /* return success                                                      */
    return 0;
}

/****************************************************************************
**
*F  InitLibrary( <module> ) . . . . . . .  initialise library data structures
*/
static Int InitLibrary (
    StructInitInfo *    module )
{

    /* init filters and functions                                          */
  InitGVarFuncsFromTable( GVarFuncs );

    /* return success                                                      */
    return 0;
}


/****************************************************************************
**
*F  InitInfoVecFFE()  . . . . . . . . . . . . . . . . table of init functions
*/
static StructInitInfo module = {
    MODULE_BUILTIN,                     /* type                           */
    "vecffe",                           /* name                           */
    0,                                  /* revision entry of c file       */
    0,                                  /* revision entry of h file       */
    0,                                  /* version                        */
    0,                                  /* crc                            */
    InitKernel,                         /* initKernel                     */
    InitLibrary,                        /* initLibrary                    */
    0,                                  /* checkInit                      */
    0,                                  /* preSave                        */
    0,                                  /* postSave                       */
    0                                   /* postRestore                    */
};

StructInitInfo * InitInfoVecFFE ( void )
{
    module.revision_c = Revision_vecffe_c;
    module.revision_h = Revision_vecffe_h;
    FillInVersion( &module );
    return &module;
}


/****************************************************************************
**

*E  vecffe.c  . . . . . . . . . . . . . . . . . . . . . . . . . . . ends here
*/
