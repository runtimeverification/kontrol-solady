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

    claim [first-roadblock]: <k> runLemma(bool2Word( notBool ( notBool ( ( notBool X:Int ==Int 0 ) andBool maxUInt256 /Word X:Int <Int 0 ) ) )) => doneLemma(0) ...  </k>
    claim [mulWad-first-roadblock]: <k> runLemma(bool2Word( notBool ( notBool ( ( notBool X:Int ==Int 0 ) andBool maxUInt256 /Word X:Int <Int 0 ) ) )) => doneLemma(0) ...  </k>
      requires 0 <=Int X

    claim [mulWadUp-second-roadblock]: <k> runLemma( notBool ( ( notBool X:Int ==Int 0 ) andBool maxUInt256 /Word X:Int <Int Y:Int ) ) => doneLemma(false) ... </k>
      requires ( notBool ( notBool ( ( notBool X:Int ==Int 0 ) andBool maxUInt256 /Word X:Int <Int Y:Int ) ) )
      andBool Y =/=Int 0
      andBool #rangeUInt(256, Y)
      andBool #rangeUInt(256, X)
      andBool X:Int <=Int ( maxUInt256 /Int Y:Int )

    claim [mulWadUp-first-roadblock]: <k> runLemma( ( ( notBool ( ( notBool ( ( X:Int *Int Y:Int ) /Int 1000000000000000000 ) ==Int 0 ) andBool maxUInt256 /Word ( ( X:Int *Int Y:Int ) /Int 1000000000000000000 ) <Int 1000000000000000000 ) ) ) ) => doneLemma(true) ... </k>
      requires notBool ( ( notBool X:Int ==Int 0 ) andBool maxUInt256 /Word X:Int <Int Y:Int )
      andBool Y =/=Int 0
      andBool #rangeUInt(256, Y)
      andBool #rangeUInt(256, X)
      andBool X:Int <=Int ( maxUInt256 /Int Y:Int )

endmodule