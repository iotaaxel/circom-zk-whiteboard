pragma circom 2.0.0;

template Adder2() {
    // Declare signals and components
    signal input a;
    signal input b;
    signal output c;
    c <== a + b;
 }

template Multiplier2() {
    // Declare signals and components
    signal input a;
    signal input b;
    signal input w; // keep as private input
    signal output c;

    component add0 = Adder2();
    component add1 = Adder2();

    // Statements
    add0.a <== a;
    add0.b <== b; 
    add1.a <== b; 
    add1.b <== w; 
    c <== add0.c * add1.c; 
 }

component main {public [a, b]} = Multiplier2(); 

