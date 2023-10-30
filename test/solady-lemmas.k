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

    rule A <Int bool2Word ( _ ) <<Int B => false
      requires A >=Int 1 <<Int B [simplification, concrete( A , B )]

/*
    rule A <Int bool2Word ( X ) <<Int B => X
        requires A <Int 1 <<Int B [simplification, concrete( A , B )]

    rule chop ( 1 <<Int Y ) => 1 <<Int Y requires Y <Int 256 [simplification]

    rule { 0 #Equals bool2Word ( X ) <<Int Y } => { false #Equals X }
        requires 0 <=Int Y
        [concrete(Y), simplification]

    rule { 0 #Equals ( bool2Word ( Z ) <<Int W |Int bool2Word ( X ) <<Int Y ) } => { false #Equals Z } #And { false #Equals X }
        requires 0 <=Int Y
         andBool 0 <=Int W
        [concrete(W,Y), simplification]
*/
    //rule Y <Int X orBool W <Int X => (Y <Int X andBool W >=Int X) orBool W <Int X requires W >Int Y [simplification, concrete(W,Y)]

    //rule 1 <<Int ( bool2Word ( A ) <<Int Y |Int bool2Word ( B ) <<Int Z ) <=Int X => 1 <<Int minInt(Y,Z) <=Int X
    //  requires (A orBool B) [simplification, concrete(Y,Z)]

    //rule A <Int (bool2Word ( _ ) <<Int B |Int bool2Word ( _ ) <<Int C) => false
    //    requires A >=Int (1 <<Int B |Int 1 <<Int C)
    //    [simplification, concrete( B , C )]
    //rule bool2Word ( A ) <<Int Y |Int bool2Word ( B ) <<Int Z => (1 <<Int Y) orBool (1 <<Int Z) orBool (1 <<Int Y +Int 1 <<Int Z)
    //  requires (A orBool B)
    //  [simplification, concrete(Y,Z)]

    //rule X <Int (A |Int B) => false
    //    requires log2Int ( A ) <Int log2Int ( X )
    //     andBool log2Int ( B ) <Int log2Int ( X )
    //    [simplification, concrete(X)]
//
    //rule log2Int ( bool2Word ( _ ) <<Int X ) <Int Y => true
    //    requires X <Int Y
    //    [simplification, concrete(X,Y)]

    //rule X <Int (bool2Word ( _ ) <<Int A |Int bool2Word ( _ ) <<Int B) => false
    //    requires A <Int log2Int ( X )
    //     andBool B <Int log2Int ( X )
    //    [simplification, concrete(X,A,B)]

    //rule A <Int bool2Word ( _ ) <<Int B => false
    //    requires A >=Int 2 ^Int B andBool B <Int 256 [simplification, concrete( A , B )]
    //rule A <Int bool2Word ( X ) <<Int B => X
    //    requires A <Int 2 ^Int B andBool B <Int 256 [simplification, concrete( A , B )]

    //
    // ML
    //

    //rule #Not ( ( { false #Equals X:Bool } #And { false #Equals Y:Bool } ) ) => {true #Equals X } #Or { true #Equals Y } [simplification]

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

    //claim [log2-05]: <k> runLemma( maxUInt8 <Int chop ( bool2Word ( _ ) <<Int 7) ) => doneLemma(false) ... </k>

    //claim [log2-06]: <k> runLemma (maxUInt8 <Int ( bool2Word ( maxUInt64 <Int X:Int >>Int bool2Word ( maxUInt128 <Int X:Int ) <<Int 7 ) <<Int 6 |Int bool2Word ( maxUInt128 <Int X:Int ) <<Int 7 ) ) => doneLemma(false) ... </k>


endmodule