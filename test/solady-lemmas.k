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

    rule chop ( 1 <<Int Y ) => 1 <<Int Y requires Y <Int 256 [simplification]

    rule ( A:Int >>Int B:Int ) >>Int C:Int => A >>Int ( B +Int C ) [simplification]

    rule A =/=Int B => notBool ( A ==Int B )
      [simplification, comm]

    rule #Ceil ( byte (X:Int, Y:Int) ) => #Top
      requires 0 <=Int X andBool X <Int 32
       andBool 0 <=Int Y andBool Y <Int pow256
       [simplification]

    //
    // Bitwise
    //

    rule A >>Int B ==Int 0 => log2Int ( A ) <=Int B
      [simplification, comm, concrete(A)]

    rule 0 <=Int A >>Int B => true
      requires 0 <=Int A andBool 0 <=Int B
      [simplification]

    rule A >>Int B <Int C => true
      requires A <Int C <<Int B
      [simplification, concrete(B, C)]

    rule X xorInt maxUInt256 => maxUInt256 -Int X
      requires #rangeUInt ( 256 , X )
      [simplification]

    //
    // Comparisons
    //

    // Concrete to the left of comparisons, prioritising <=Int and <Int
    rule X >=Int Y => Y <=Int X [simplification, concrete(Y)]
    rule X  >Int Y => Y  <Int X [simplification, concrete(Y)]

    // Negations at K-level
    rule notBool X <=Int Y => Y  <Int X [simplification]
    rule notBool X  <Int Y => Y <=Int X [simplification]
    rule notBool X  >Int Y => X <=Int Y [simplification]
    rule notBool X >=Int Y => X  <Int Y [simplification]

    // Negations ad ML-level
    rule { true #Equals ( notBool X <=Int Y ) } => { true #Equals Y  <Int X } [simplification]
    rule { true #Equals ( notBool X  <Int Y ) } => { true #Equals Y <=Int X } [simplification]
    rule { true #Equals ( notBool X  >Int Y ) } => { true #Equals X <=Int Y } [simplification]
    rule { true #Equals ( notBool X >=Int Y ) } => { true #Equals X  <Int Y } [simplification]
    rule { ( notBool X <=Int Y ) #Equals true } => { true #Equals Y  <Int X } [simplification]
    rule { ( notBool X  <Int Y ) #Equals true } => { true #Equals Y <=Int X } [simplification]
    rule { ( notBool X  >Int Y ) #Equals true } => { true #Equals X <=Int Y } [simplification]
    rule { ( notBool X >=Int Y ) #Equals true } => { true #Equals X  <Int Y } [simplification]

    //
    // Arithmetic
    //

    rule A modInt B => A
      requires 0 <=Int A andBool A <Int B
      [simplification]

    rule A *Int B <Int C => A <Int C /Int B
      requires C modInt B ==Int 0
      [simplification, concrete(B, C)]

    rule A <=Int B *Int C => A /Int C <=Int B
      requires A modInt C ==Int 0
      [simplification, concrete(A, C)]

    rule A <=Int B -Int C => C <=Int B -Int A
      [simplification, concrete(A, B)]

    //
    // Specialised
    //

    syntax Int ::= "cachedBytesConstant" [alias]
    rule cachedBytesConstant => 6928917744019834342450304135053993530982274426945361611473370484834304

    rule ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( Y >>Int X ) ) *Int 8 ) ) modInt 256 => 0
      requires 0 <=Int X andBool 0 <=Int Y andBool Y >>Int X <Int 32
       andBool ( Y >>Int X <Int 2 orBool 16 <=Int Y >>Int X )
      [simplification, concrete(X)]

    rule ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( Y >>Int X ) ) *Int 8 ) ) modInt 256 => 1
      requires 0 <=Int X andBool 0 <=Int Y andBool Y >>Int X <Int 32
       andBool 2 <=Int Y >>Int X andBool Y >>Int X <Int 4
      [simplification, concrete(X)]

    rule ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( Y >>Int X ) ) *Int 8 ) ) modInt 256 => 2
      requires 0 <=Int X andBool 0 <=Int Y andBool Y >>Int X <Int 32
       andBool 4 <=Int Y >>Int X andBool Y >>Int X <Int 8
      [simplification, concrete(X)]

    rule ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( Y >>Int X ) ) *Int 8 ) ) modInt 256 => 3
      requires 0 <=Int X andBool 0 <=Int Y andBool Y >>Int X <Int 32
       andBool 8 <=Int Y >>Int X andBool Y >>Int X <Int 16
      [simplification, concrete(X)]

    rule maxUInt8 <Int X |Int ( ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( Y >>Int X ) ) *Int 8 ) ) modInt 256 ) => false
      requires 0 <=Int X andBool X <Int 256
       andBool 0 <=Int Y
       andBool Y >>Int X <Int 32
      [simplification, concrete(X)]

    rule X |Int ( ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( Y >>Int X ) ) *Int 8 ) ) modInt 256 ) <=Int maxUInt8 => true
      requires 0 <=Int X andBool X <Int 256
       andBool 0 <=Int Y
       andBool Y >>Int X <Int 32
      [simplification, concrete(X)]

    rule maxUInt8 <=Int X |Int ( ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( Y >>Int X ) ) *Int 8 ) ) modInt 256 ) => false
      requires 0 <=Int X andBool X <Int 252
       andBool 0 <=Int Y
       andBool Y >>Int X <Int 32
      [simplification, concrete(X)]

    rule X |Int ( ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( Y >>Int X ) ) *Int 8 ) ) modInt 256 ) <Int maxUInt8 => true
      requires 0 <=Int X andBool X <Int 252
       andBool 0 <=Int Y
       andBool Y >>Int X <Int 32
      [simplification, concrete(X)]

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

    // claim [log2-07]: <k> runLemma (1 <<Int ( bool2Word ( maxUInt64 <Int X:Int >>Int bool2Word ( maxUInt128 <Int X:Int ) <<Int 7 ) <<Int 6 |Int bool2Word ( maxUInt128 <Int X:Int ) <<Int 7 ) <=Int X:Int) => doneLemma(maxUInt128 <Int X:Int) ... </k>

    claim [arith-01]:
      <k>
        runLemma (
                  notBool ( maxUInt8 <=Int ( 4 |Int ( ( cachedBytesConstant >>Int ( ( maxUInt5 -Int ( VV0_x_114b9705:Int >>Int 4 ) ) *Int 8 ) ) modInt 256 ) ) )
          andBool VV0_x_114b9705 >>Int 4 <Int 32
        ) => doneLemma (
          true
        )
      </k>
      requires 0 <=Int VV0_x_114b9705:Int
       andBool VV0_x_114b9705:Int >>Int 4 <=Int 1

endmodule