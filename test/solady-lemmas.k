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


    // Bool
    rule notBool notBool X => X [simplification]

    rule [boolOfTrue]:  bool2Word ( X ) => 1 requires X         [simplification]
    rule [boolOfFalse]: bool2Word ( X ) => 0 requires notBool X [simplification]

    rule X /Word Y <Int 0 => false
      requires X >=Int 0
      andBool  Y >=Int 0
      [simplification]

endmodule

module SOLADY-LEMMAS-SPEC
    imports SOLADY-LEMMAS

    claim [first-roadblock]: <k> runLemma(bool2Word( notBool ( notBool ( ( notBool X:Int ==Int 0 ) andBool maxUInt256 /Word X:Int <Int 0 ) ) )) => doneLemma(0) ...  </k>
      requires 0 <=Int X

endmodule