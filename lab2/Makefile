.PHONY: lab2
lab1:
    make clean
    verilator --build ./SingleCycleCPU.v ./ALU.V ./ALUCtrl.v ./Control.v ./DataMemory.v \
        ./ImmGen.v ./InstructionMemory.v ./Mux2to1.v ./PC.v ./Register.v ./ShiftLeftOne.v ./Adder.v \
        ./Mux3to1.v ./BranchCMP.v  \
        --exe ./example_testbench.cpp -cc --trace -Wall
    ./obj_dir/VSingleCycleCPU

.PHONY: clean
clean:
    rm -rf obj_dir
    rm -f waveform.vcd
# verilator --cc example_testbench.cpp --exe --build -j 0 -Wall Adder.v ALU.v ALUCtrl.v Control.v DataMemory.v ImmGen.v InstructionMemory.v Mux2to1.v PC.v Register.v ShiftLeftOne.v SingleCycleCPU.v

