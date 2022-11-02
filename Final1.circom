pragma circom 2.0.0;

template Adder2() {
    // Declare signals and components
    signal input a;
    signal input b;
    signal output c;
    c <== a+b;
 }

template Multiplier2() {
    // Declare signals and components
    signal input a;
    signal input b;
    signal input w; // will be some private input
    signal output c;

    component add0 = Adder2();
    component add1 = Adder2();

     // Statements
     add0.a <== a;
     add0.b <== b; 
     add1.a <== b; 
     add1.b <== w; 
     c <== add0.c*add1.c;
 }

template Final1() { //TODO: Finish end
    // Declare signals and components
    signal input S0;
    signal input S1;
    signal input S2; // will be some private input
    signal output finalc;

    component main {public [a, b]} = Multiplier2(); //S2

    // Statements
    // Add the Row constraint S_i[x_i+y_i]+(1-S_i)[x_i*y_i]-c_i=0 when i=0,1,2
    // S0*(...)+(...)*()-c0=0; (where S0=1 since add gate)
    //S1*(...)+(...)*()-c1=0; (where S1=1 since add gate)
    //S2*(...)+(...)*()-c2=0; (where S0=2 since mult gate)
    finalc <== main.c;
}

component main Final1();

