\m5_TLV_version 1d: tl-x.org
\SV
   // This code can be found in: https://github.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/risc-v_shell.tlv
   
   m5_include_lib(['https://raw.githubusercontent.com/stevehoover/LF-Building-a-RISC-V-CPU-Core/main/lib/risc-v_shell_lib.tlv'])



   //---------------------------------------------------------------------------------
   // /====================\
   // | Sum 1 to 9 Program |
   // \====================/
   //
   // Program to test RV32I
   // Add 1,2,3,...,9 (in that order).
   //
   // Regs:
   //  x12 (a2): 10
   //  x13 (a3): 1..10
   //  x14 (a4): Sum
   // 
   m5_asm(ADDI, x14, x0, 0)             // Initialize sum register a4 with 0
   m5_asm(ADDI, x12, x0, 1010)          // Store count of 10 in register a2.
   m5_asm(ADDI, x13, x0, 1)             // Initialize loop count register a3 with 0
   // Loop:
   m5_asm(ADD, x14, x13, x14)           // Incremental summation
   m5_asm(ADDI, x13, x13, 1)            // Increment loop count by 1
   m5_asm(BLT, x13, x12, 1111111111000) // If a3 is less than a2, branch to label named <loop>
   // Test result value in x14, and set x31 to reflect pass/fail.
   m5_asm(ADDI, x30, x14, 111111010100) // Subtract expected value of 44 to set x30 to 1 if and only iff the result is 45 (1 + 2 + ... + 9).
   m5_asm(BGE, x0, x0, 0) // Done. Jump to itself (infinite loop). (Up to 20-bit signed immediate plus implicit 0 bit (unlike JALR) provides byte address; last immediate bit should also be 0)
   m5_asm_end()
   m5_define(['M5_MAX_CYC'], 50)
   //---------------------------------------------------------------------------------



\SV
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
   /* verilator lint_on WIDTH */
\TLV
   
   $reset = *reset;
   
   
   // YOUR CODE HERE
   $next_pc[31:0] = $reset ? 32'b0 : $pc[31:0] + 1;
   $pc[31:0] = >>1$next_pc[31:0];
   
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = 1'b0;
   *failed = *cyc_cnt > M5_MAX_CYC;
   
   //m4+rf(32, 32, $reset, $wr_en, $wr_index[4:0], $wr_data[31:0], $rd_en1, $rd_index1[4:0], $rd_data1, $rd_en2, $rd_index2[4:0], $rd_data2)
   //m4+dmem(32, 32, $reset, $addr[4:0], $wr_en, $wr_data[31:0], $rd_en, $rd_data)
   m5+cpu_viz()
\SV
   endmodule
