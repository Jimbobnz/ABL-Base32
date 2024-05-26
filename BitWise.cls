 
/*------------------------------------------------------------------------
   File        : BitWise
   Purpose     : 
   Syntax      : 
   Description : ABL BitWise 
   Author(s)   : James Bowen
   Created     : Sun May 26 21:35:35 NZST 2024
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.


class BitWise:
    
    /*------------------------------------------------------------------------------
         Purpose:
         Notes:
        ------------------------------------------------------------------------------*/

    method public static int64 RShift( input x as int64, input z as int64):

        define variable ishift as int64 no-undo.
        define variable y      as int64 no-undo.
    
        do ishift = 1 to z:
    
            put-bits(y, 32, 1) = get-bits(x, 32, 1).   //The empty position in the most significant bit is filled with a copy of the original MSB
            put-bits(y, 1, 31) = get-bits(x, 2, 31).
    
            x = y.
    
        end.
    
        return x.

    end method.        

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method public static int64 LShift( input x as int64, input z as int64):

    
        define variable ishift as int64 no-undo.
        define variable y      as int64 no-undo.
    
        do ishift = 1 to z:
    
            put-bits(y, 2, 31) = get-bits(x, 1, 31).   
            put-bits(y, 1, 1)  = 0.  // The empty position in the least significant bit is filled with a zero.
    
            x = y.
    
        end.
    
        return x.
    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method public static int64 OR( input X as int64, input Y as int64):

        define variable n as int64 no-undo.
        define variable Z as int64 no-undo.

        do n = 1 to 64:

            if get-bits(X, n, 1) = 1 or get-bits(Y, n, 1) = 1 then
                PUT-BITS(Z, n, 1) = 1.

        end.

        return Z.

    end method.
    
    /*------------------------------------------------------------------------------
    Purpose: bitAnd
    Notes:
    ------------------------------------------------------------------------------*/

    method public static int64 AND( input X as int64, input Y as int64):

        define variable b as int64 no-undo.
        define variable n as int64 no-undo.
        define variable Z as int64 no-undo.

        do n = 1 to 64:

            if get-bits(X, n, 1) = 1 and get-bits(Y, n, 1) = 1 then
                b = 1.

            PUT-BITS(Z, n, 1) = b.
            b = 0.

        end.

        return Z.
    end method.    
     

end class.