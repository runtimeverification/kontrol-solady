requires "evm.md"
requires "foundry.md"

module SOLADY-LEMMAS
    imports BOOL
    imports FOUNDRY
    imports INFINITE-GAS
    imports INT-SYMBOLIC
    imports MAP-SYMBOLIC
    imports SET-SYMBOLIC

    syntax StepSort ::= Int
                      | Bool
                      | Bytes
                      | Set
 // -------------------------

    syntax KItem ::= runLemma ( StepSort )
                   | doneLemma( StepSort )

    rule <k> runLemma(T) => doneLemma(T) ... </k>
    
    //
    // Bool
    //

    rule bool2Word ( X ) => 1 requires X         [simplification]
    rule bool2Word ( X ) => 0 requires notBool X [simplification]
    
    rule chop ( bool2Word ( X ) <<Int Y ) => bool2Word ( X ) <<Int Y requires Y <Int 256 [simplification]

    //rule { 0 #Equals bool2Word ( X ) <<Int Y } => { false #Equals X }
    //    requires 0 <=Int Y
    //    [concrete(Y), simplification]

    //rule { 0 #Equals ( bool2Word ( Z ) <<Int W |Int bool2Word ( X ) <<Int Y ) } => { false #Equals ( Z orBool X ) }
    //    requires 0 <=Int Y
    //    andBool 0 <=Int W
    //    [concrete(W,Y), simplification]
    
    rule A <Int bool2Word ( _ ) <<Int B => false
        requires A >=Int 2 ^Int B andBool B <Int 256 [simplification, concrete( A , B )]
    rule A <Int bool2Word ( X ) <<Int B => X
        requires A <Int 2 ^Int B andBool B <Int 256 [simplification, concrete( A , B )]
    
    //
    // ML
    //

    rule #Not ( { false #Equals X:Bool andBool Y:Bool } ) => {true #Equals X } #And { true #Equals Y } [simplification]
    
    //
    // Arithmetic
    //
    
    rule X xorInt maxUInt256 => maxUInt256 -Int X
      requires #rangeUInt ( 256 , X )
      [simplification]

endmodule

module SOLADY-LEMMAS-SPEC
    imports SOLADY-LEMMAS
    
    //claim [log2-01]: <k> runLemma(chop (bool2Word ( X:Bool ) <<Int 7)) => doneLemma(128) ...  </k>
    //  requires X:Bool
    
    //claim [log2-02]: <k> runLemma(chop (bool2Word ( X:Bool ) <<Int 7)) => doneLemma(0) ...  </k>
    //  requires notBool X:Bool
    
    //claim [log2-03]: <k> runLemma(1 <<Word (bool2Word ( X:Bool ) <<Int 7)) => doneLemma(pow128) ...  </k>
    //  requires X:Bool
    
    //claim [log2-04]: <k> runLemma(bool2Word ( X:Bool ) <<Int 7) => doneLemma(128) ...  </k>
    //  requires X:Bool

    claim [log2-05]: <k>  maxUInt8 <Int chop ( bool2Word ( maxUInt128 <Int _ ) <<Int 7 ) => doneLemma(false) ... </k>
endmodule