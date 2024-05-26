 
/*------------------------------------------------------------------------
   File        : Base32
   Purpose     : 
   Syntax      : 
   Description : Static class object fot Base32 incoding and decoding. 
   Author(s)   : James Bowen
   Created     : Sun May 26 20:07:08 NZST 2024
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.


class Base32: 

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method public static raw Decode( input base32EncodedValue as character ):
        
        define variable returnArray       as raw       no-undo.
    
        define variable chCharByte        as character no-undo.
    
        define variable iValue            as integer   no-undo.    
        define variable characterPosition as integer   no-undo.
        define variable iLength           as integer   no-undo.
        define variable iByteCount        as integer   no-undo.
        define variable iBitsRemaining    as integer   no-undo.
        define variable iMask             as integer   no-undo. 
        define variable iCurrentByte      as integer   no-undo.
        define variable bytePosition      as integer   no-undo.
    
        //set-byte-order(returnArray ) = big-endian.
     
        if base32EncodedValue eq "" then
            return ?.
    
        assign
            base32EncodedValue = replace(base32EncodedValue,' ','')
            base32EncodedValue = replace(base32EncodedValue,'=','')
            base32EncodedValue = trim(base32EncodedValue)
            .
        
        assign    
            iLength    = length(base32EncodedValue,"RAW")   
            iByteCount = truncate(iLength * 5 / 8,0)
            .
    
        //set-size(returnArray ) = 0.
        //set-size(returnArray ) = iByteCount.
        
        length(returnArray) = iByteCount.     
    
        assign
            iBitsRemaining = 8
            iMask          = 0
            iCurrentByte   = 0
            bytePosition   = 0
            .
    
        do characterPosition = 1 to iLength:
    
            chCharByte = substring(base32EncodedValue, characterPosition, 1, "RAW").
        
            iValue = base32:charToValue(input chCharByte).
        
            if iValue eq ? then
                next.
        
            if iBitsRemaining gt 5 then
            do:
                assign
                    iMask          = BitWise:LShift(iValue , (iBitsRemaining - 5) )
                    iCurrentByte   = BitWise:OR(iCurrentByte, iMask)
                    iBitsRemaining = iBitsRemaining - 5
                    .
            
            end.
            else
            do:
            
                assign
                    iMask        = BitWise:RShift(iValue , (5 - iBitsRemaining) )
                    iCurrentByte = BitWise:OR(iCurrentByte, iMask)
                    bytePosition = bytePosition + 1
                    .

                put-byte(returnArray, bytePosition) = iCurrentByte.
            
                assign
                    iCurrentByte   = BitWise:LShift(iValue , (3 + iBitsRemaining) )
                    iBitsRemaining = iBitsRemaining + 3
                    .        
            end.
        end.
    
        if bytePosition ne iByteCount then
        do:
            bytePosition  = bytePosition + 1.
            put-byte(returnArray, bytePosition) = iCurrentByte.
        
        end.
    
        return returnArray.
    
        finally:
    
            //set-size(returnArray) = 0.
    
        end finally.

    end method.

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method public static character Encode( input rawDataBytes as raw  ):
        
        define variable Base32Chars   as character no-undo initial "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567".
        
        define variable base32String  as character no-undo.
        define variable outputLength  as integer   no-undo.
        define variable byteBuffer    as int64     no-undo.
        define variable nextByte      as int64     no-undo.
        define variable bitsLeft      as integer   no-undo.
        define variable currentByte   as int64     no-undo.
        define variable maskedByte    as int64     no-undo.
        define variable pad           as integer   no-undo.
        define variable indexPos      as integer   no-undo.
        //define variable shiftAmount   as integer   no-undo.
        define variable shiftedBuffer as int64     no-undo.
        //define variable maskedIndex   as int64     no-undo.
        
        if rawDataBytes eq ? or length(rawDataBytes) eq 0 then 
            return "".
            
        outputLength = integer( truncate(  (length(rawDataBytes) * 8 + 4) / 5,0) ).
        
        byteBuffer = get-byte(rawDataBytes, 1).
        nextByte = 2.
        bitsLeft = 8.
        
        do while (bitsLeft gt 0 or nextByte lt length(rawDataBytes)):

            if (bitsLeft lt 5) then
            do:
                
                if (nextByte < length(rawDataBytes)) then
                do:
                    assign
                        currentByte = get-byte(rawDataBytes, nextByte)
                        nextByte    = nextByte + 1
                        maskedByte  = BitWise:And(currentByte, 0xFF)
                        byteBuffer  = BitWise:LShift(byteBuffer, 8)
                        byteBuffer  = BitWise:OR(byteBuffer, maskedByte)
                        bitsLeft    = bitsLeft + 8.
                end.
                else
                do:
                    assign
                        pad        = 8 - bitsLeft
                        byteBuffer = BitWise:LShift(byteBuffer, pad)
                        bitsLeft   = bitsLeft + pad.
                end.
                
            end.
            
            assign          
                shiftedBuffer = BitWise:RShift(byteBuffer, (bitsLeft - 5) )
            indexPos   = BitWise:And(shiftedBuffer, 0x1F)
                //indexPos      = maskedIndex            
                bitsLeft      = bitsLeft - 5            
                base32String  = base32String + substring(Base32Chars,indexPos + 1, 1).
            
        end.
        
        return base32String.

    end method.
    
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    method private static integer charToValue(  input charByte as character):

        define variable charByteValue as integer no-undo.
             
        charByteValue = asc(charByte).

    //65-90 == uppercase letters
        if charByteValue lt 91 and charByteValue gt 64 then
            return charByteValue - 65.
    
    //50-55 == numbers 2-7
        if charByteValue lt 56 and charByteValue gt 49 then
            return charByteValue - 24.
    
    //97-122 == lowercase letters
        if(charByteValue lt 123 and charByteValue gt 96) then
            return charByteValue - 97.

        return ?.

    end method.    

end class.

