# circom-zk-whiteboard
## Overview
The following image taken from the ZK Whiteboard Session Module Five slides describes what will be coded:
<figure>
    <img src="https://user-images.githubusercontent.com/25125141/199579706-89b2b9ee-19db-4015-b745-2d75736f9e58.png" width="900">
    <figcaption>Source: <a href="https://drive.google.com/file/d/1_lKJwZmWef6zpW2VViz5a2OeEfdTa4Uf/view?usp=sharing">Slides</a></figcaption>
</figure>

## Notes
- In this example, `S` is used as an operator selector. `S0` and `S1` are set to 1 to indicate addition gates. `S2` is set to 0 to indicate a multication gate. These are important to apply the row constraint equally. 
- Row constraint: `S_i[x_i+y_i]+(1-S_i)[x_i*y_i]-c_i=0`
  - at i=0: `(x_0+y_0) - c_0 = 0`
  - at i=1: `(x_1+y_1) - c_1 = 0` 
  - at i=2: `(x_2*y_2) - c_2 = 0`
- **Important Note:** The arithmetic circuit has been constructed with these row constraints but since Circom does not allow non-quadratic constraints, the row constraints are not explicitly stated.

## Resources
### Relevant Videos:
- [Module One: What is a SNARK?](https://zkhack.dev/whiteboard/module-one/)
- [Module Two: Building a SNARK (Part I)](https://zkhack.dev/whiteboard/module-two/)
- [Module Three: Building a SNARK (Part II)](https://zkhack.dev/whiteboard/module-three/)
- [Module Four: SNARKs vs. STARKS with Brendan and Bobbin](https://zkhack.dev/whiteboard/module-four/)
- [Module Five: PLONK and Custom Gates with Adrian Hamelink](https://zkhack.dev/whiteboard/module-five)
  - [Slides](https://drive.google.com/file/d/1_lKJwZmWef6zpW2VViz5a2OeEfdTa4Uf/view?usp=sharing)
### Circom Documentation
- [Main Guide](https://docs.circom.io/)
- [More Basic Circuits](https://docs.circom.io/more-circuits/more-basic-circuits/)
- [Constraint Generation](https://docs.circom.io/circom-language/constraint-generation/)
- [Signals](https://docs.circom.io/circom-language/signals/)
- [Compiling Circuits](https://docs.circom.io/getting-started/compiling-circuits/)
- [Computing the Witness](https://docs.circom.io/getting-started/computing-the-witness/)
- [Proving Circuits with ZK](https://docs.circom.io/getting-started/proving-circuits/)

## Compilation Steps from [Circom](https://docs.circom.io/) documentation
### Compile circuit: 
1. Run `circom multiplier2.circom --r1cs --wasm --sym --c`

### Compute witness (with C++): 
1. Navigate to the `multiplier2_cpp` directory
2. Add an `input.json` file with `a`, `b`, and `w` values as string inputs
3. Run `make`
  - **Troubleshoot fatal error: nlohmann/json.hpp: No such file or directory:** `sudo apt upgrade && sudo apt install nlohmann-json3-dev libgmp-dev nasm && make`
4. Run executable: `./multiplier2 input.json witness.wtns`

### Prove circuit with Groth16 ZkSnark Protocol
#### Trusted Setup (part 1) - Powers of Tau
- Note that this step is independent of the circuit.
1. Start "Powers of Tau" ceremony: `snarkjs powersoftau new bn128 12 pot12_0000.ptau -v`
2. Contribute to the ceremony: `snarkjs powersoftau contribute pot12_0000.ptau pot12_0001.ptau --name="First contribution" -v`
#### Trusted Setup (part 2)
- Note that this step is circuit-specific.
1. Setup by running `snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v`
2. Generate a .zkey file with both the proving and verification keys and all phase 2 contributions: `snarkjs groth16 setup multiplier2.r1cs pot12_final.ptau multiplier2_0000.zkey`
    - Troubleshoot `multiplier2.r1cs` not found: use `../multiplier2.r1cs` in the above command
3. Contribute to part 2 of the ceremony: `snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v`
4. Export the verification key: `snarkjs zkey export verificationkey multiplier2_0001.zkey verification_key.json`

#### Generate a Proof
1. Run `snarkjs groth16 prove multiplier2_0001.zkey witness.wtns proof.json public.json`

### Verify a Proof
1. Run `snarkjs groth16 verify verification_key.json public.json proof.json`

   Outputs: ```[INFO]  snarkJS: OK!```