.PHONY: lab2
lab1:
    make clean
    verilator --build ./PipelineCPU.v ./ALU.V ./ALUCtrl.v ./IDControl.v ./EXControl.v ./DataMemory.v \
        ./ImmGen.v ./InstructionMemory.v ./Mux2to1.v ./PC.v ./Register.v ./ShiftLeftOne.v ./Adder.v \
        ./Mux3to1.v ./BranchCMP.v ./Forwarding.v ./HarzardDetection.v \
        ./regIFID.v ./regIDEX.v ./regEXMEM.v ./regMEMWB.v \
        --exe ./testbench.cpp -cc --trace -Wall
    ./obj_dir/VPipelineCPU

.PHONY: clean
clean:
    rm -rf obj_dir
    rm -f waveform.vcd
# verilator --cc example_testbench.cpp --exe --build -j 0 -Wall Adder.v ALU.v ALUCtrl.v Control.v DataMemory.v ImmGen.v InstructionMemory.v Mux2to1.v PC.v Register.v ShiftLeftOne.v SingleCycleCPU.v

