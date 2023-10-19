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

    rule { true #Equals ( notBool X <=Int Y ) } => { true #Equals Y  <Int X } [simplification]
    rule { true #Equals ( notBool X  <Int Y ) } => { true #Equals Y <=Int X } [simplification]
    rule { true #Equals ( notBool X  >Int Y ) } => { true #Equals X <=Int Y } [simplification]
    rule { true #Equals ( notBool X >=Int Y ) } => { true #Equals X  <Int Y } [simplification]
    rule { ( notBool X <=Int Y ) #Equals true } => { true #Equals Y  <Int X } [simplification]
    rule { ( notBool X  <Int Y ) #Equals true } => { true #Equals Y <=Int X } [simplification]
    rule { ( notBool X  >Int Y ) #Equals true } => { true #Equals X <=Int Y } [simplification]
    rule { ( notBool X >=Int Y ) #Equals true } => { true #Equals X  <Int Y } [simplification]

    // Bitwise

    rule A =/=Int B => notBool ( A ==Int B )
      [simplification, comm]

    rule A >>Int B ==Int 0 => log2Int ( A ) <=Int B
      [simplification, comm, concrete(A)]

    // Arithmetic

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

    rule ( ( X |Int ( 6928917744019834342450304135053993530982274426945361611473370484834304 >>Int ( ( maxUInt5 -Int Y:Int >>Int X ) *Int 8 ) modInt 256 ) ) <=Int maxUInt8 ) => Y:Int >>Int X <Int 3
      requires 4 <=Int X andBool X <Int 256 andBool 0 <=Int Y
      [simplification, concrete(X)]

    // rule { 0 #Equals bool2Word ( X ) <<Int Y } => { false #Equals X }
    //     requires 0 <=Int Y
    //     [concrete(Y), simplification]

    // rule { 0 #Equals ( bool2Word ( Z ) <<Int W |Int bool2Word ( X ) <<Int Y ) } => { false #Equals Z } #And { false #Equals X }
    //     requires 0 <=Int Y
    //      andBool 0 <=Int W
    //     [concrete(W,Y), simplification]

    //rule 1 <<Int ( _ |Int bool2Word ( _ ) <<Int Y ) <=Int X => true ensures 1 <<Int (1 <<Int Y) <=Int X [simplification, concrete(Y)]

    //rule 1 <<Int ( _ |Int bool2Word ( _ ) <<Int Y ) <=Int X => false ensures 1 <<Int (1 <<Int Y) >Int X [simplification, concrete(Y)]




    //rule X <Int (bool2Word ( _ ) <<Int A |Int bool2Word ( W ) <<Int B) => false
    //    requires (2 ^Int A +Int 2 ^Int B) <Int X
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

    // claim [log2-07]: <k> runLemma (1 <<Int ( bool2Word ( maxUInt64 <Int X:Int >>Int bool2Word ( maxUInt128 <Int X:Int ) <<Int 7 ) <<Int 6 |Int bool2Word ( maxUInt128 <Int X:Int ) <<Int 7 ) <=Int X:Int) => doneLemma(maxUInt128 <Int X:Int) ... </k>

    claim [arith-01]:
      <k>
        runLemma (
          ( ( maxUInt5 -Int VV0_x_114b9705:Int ) *Int 8 ) modInt 256
        ) => doneLemma (
          ( maxUInt5 -Int VV0_x_114b9705:Int ) *Int 8
        )
      </k>
      requires 1 <Int VV0_x_114b9705:Int
       andBool VV0_x_114b9705:Int <=Int 3

    claim [arith-02]:
      <k>
        runLemma (
          ( 6928917744019834342450304135053993530982274426945361611473370484834304 >>Int ( ( maxUInt5 -Int VV0_x_114b9705:Int ) *Int 8 ) modInt 256 ) ==Int 0
        ) => doneLemma (
          false
        )
      </k>
      requires 3 <Int VV0_x_114b9705:Int
       andBool VV0_x_114b9705:Int <=Int 15

    claim [arith-03]:
      <k>
        runLemma (
          ( 6928917744019834342450304135053993530982274426945361611473370484834304 >>Int ( ( maxUInt5 -Int VV0_x_114b9705:Int ) *Int 8 ) modInt 256 ) =/=Int 0
        ) => doneLemma (
          true
        )
      </k>
      requires 3 <Int VV0_x_114b9705:Int
       andBool VV0_x_114b9705:Int <=Int 15

    claim [arith-04]:
      <k>
        runLemma (
          ( 6928917744019834342450304135053993530982274426945361611473370484834304 >>Int ( ( maxUInt5 -Int VV0_x_114b9705:Int ) *Int 8 ) modInt 256 ) =/=Int 0
        ) => doneLemma (
          true
        )
      </k>
      requires 3 <Int VV0_x_114b9705:Int
       andBool VV0_x_114b9705:Int <=Int 15

    claim [arith-05]:
      <k>
        runLemma (
          ( ( 248 |Int ( 6928917744019834342450304135053993530982274426945361611473370484834304 >>Int ( ( maxUInt5 -Int VV0_x_114b9705:Int >>Int 248 ) *Int 8 ) modInt 256 ) ) <=Int maxUInt8 )
        ) => doneLemma (
          false
        )
      </k>
      requires 3 <Int VV0_x_114b9705:Int >>Int 248
       andBool VV0_x_114b9705:Int >>Int 248 <=Int 15
       andBool 0 <=Int VV0_x_114b9705:Int
       andBool maxUInt128 <Int VV0_x_114b9705:Int

endmodule