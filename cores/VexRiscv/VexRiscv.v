// Generator : SpinalHDL v1.1.6    git head : 2643ea2afba86dc6321cd50da8126412cf13d7ec
// Date      : 04/06/2018, 23:42:12
// Component : VexRiscv


`define Src2CtrlEnum_binary_sequancial_type [1:0]
`define Src2CtrlEnum_binary_sequancial_RS 2'b00
`define Src2CtrlEnum_binary_sequancial_IMI 2'b01
`define Src2CtrlEnum_binary_sequancial_IMS 2'b10
`define Src2CtrlEnum_binary_sequancial_PC 2'b11

`define AluBitwiseCtrlEnum_binary_sequancial_type [1:0]
`define AluBitwiseCtrlEnum_binary_sequancial_XOR_1 2'b00
`define AluBitwiseCtrlEnum_binary_sequancial_OR_1 2'b01
`define AluBitwiseCtrlEnum_binary_sequancial_AND_1 2'b10
`define AluBitwiseCtrlEnum_binary_sequancial_SRC1 2'b11

`define AluCtrlEnum_binary_sequancial_type [1:0]
`define AluCtrlEnum_binary_sequancial_ADD_SUB 2'b00
`define AluCtrlEnum_binary_sequancial_SLT_SLTU 2'b01
`define AluCtrlEnum_binary_sequancial_BITWISE 2'b10

`define BranchCtrlEnum_binary_sequancial_type [1:0]
`define BranchCtrlEnum_binary_sequancial_INC 2'b00
`define BranchCtrlEnum_binary_sequancial_B 2'b01
`define BranchCtrlEnum_binary_sequancial_JAL 2'b10
`define BranchCtrlEnum_binary_sequancial_JALR 2'b11

`define Src1CtrlEnum_binary_sequancial_type [1:0]
`define Src1CtrlEnum_binary_sequancial_RS 2'b00
`define Src1CtrlEnum_binary_sequancial_IMU 2'b01
`define Src1CtrlEnum_binary_sequancial_PC_INCREMENT 2'b10

`define ShiftCtrlEnum_binary_sequancial_type [1:0]
`define ShiftCtrlEnum_binary_sequancial_DISABLE_1 2'b00
`define ShiftCtrlEnum_binary_sequancial_SLL_1 2'b01
`define ShiftCtrlEnum_binary_sequancial_SRL_1 2'b10
`define ShiftCtrlEnum_binary_sequancial_SRA_1 2'b11

module StreamFifoLowLatency (
      input   io_push_valid,
      output  io_push_ready,
      input   io_push_payload_error,
      input  [31:0] io_push_payload_inst,
      output  io_pop_valid,
      input   io_pop_ready,
      output reg  io_pop_payload_error,
      output reg [31:0] io_pop_payload_inst,
      input   io_flush,
      output [0:0] io_occupancy,
      input   clk,
      input   reset);
  wire  _zz_5;
  reg  _zz_6;
  wire [0:0] _zz_7;
  reg  _zz_1;
  reg  pushPtr_willIncrement;
  reg  pushPtr_willClear;
  wire  pushPtr_willOverflowIfInc;
  wire  pushPtr_willOverflow;
  reg  popPtr_willIncrement;
  reg  popPtr_willClear;
  wire  popPtr_willOverflowIfInc;
  wire  popPtr_willOverflow;
  wire  ptrMatch;
  reg  risingOccupancy;
  wire  empty;
  wire  full;
  wire  pushing;
  wire  popping;
  wire [32:0] _zz_2;
  wire [32:0] _zz_3;
  reg [32:0] _zz_4;
  assign io_push_ready = _zz_5;
  assign io_pop_valid = _zz_6;
  assign _zz_7 = _zz_2[0 : 0];
  always @ (*) begin
    _zz_1 = 1'b0;
    pushPtr_willIncrement = 1'b0;
    if(pushing)begin
      _zz_1 = 1'b1;
      pushPtr_willIncrement = 1'b1;
    end
  end

  always @ (*) begin
    pushPtr_willClear = 1'b0;
    popPtr_willClear = 1'b0;
    if(io_flush)begin
      pushPtr_willClear = 1'b1;
      popPtr_willClear = 1'b1;
    end
  end

  assign pushPtr_willOverflowIfInc = 1'b1;
  assign pushPtr_willOverflow = (pushPtr_willOverflowIfInc && pushPtr_willIncrement);
  always @ (*) begin
    popPtr_willIncrement = 1'b0;
    if(popping)begin
      popPtr_willIncrement = 1'b1;
    end
  end

  assign popPtr_willOverflowIfInc = 1'b1;
  assign popPtr_willOverflow = (popPtr_willOverflowIfInc && popPtr_willIncrement);
  assign ptrMatch = 1'b1;
  assign empty = (ptrMatch && (! risingOccupancy));
  assign full = (ptrMatch && risingOccupancy);
  assign pushing = (io_push_valid && _zz_5);
  assign popping = (_zz_6 && io_pop_ready);
  assign _zz_5 = (! full);
  always @ (*) begin
    if((! empty))begin
      _zz_6 = 1'b1;
      io_pop_payload_error = _zz_7[0];
      io_pop_payload_inst = _zz_2[32 : 1];
    end else begin
      _zz_6 = io_push_valid;
      io_pop_payload_error = io_push_payload_error;
      io_pop_payload_inst = io_push_payload_inst;
    end
  end

  assign _zz_2 = _zz_3;
  assign io_occupancy = (risingOccupancy && ptrMatch);
  assign _zz_3 = _zz_4;
  always @ (posedge clk) begin
    if(reset) begin
      risingOccupancy <= 1'b0;
    end else begin
      if((pushing != popping))begin
        risingOccupancy <= pushing;
      end
      if(io_flush)begin
        risingOccupancy <= 1'b0;
      end
    end
  end

  always @ (posedge clk) begin
    if(_zz_1)begin
      _zz_4 <= {io_push_payload_inst,io_push_payload_error};
    end
  end

endmodule

module VexRiscv (
      output  rvfi_valid,
      output [63:0] rvfi_order,
      output [31:0] rvfi_insn,
      output reg  rvfi_trap,
      output  rvfi_halt,
      output  rvfi_intr,
      output [4:0] rvfi_rs1_addr,
      output [31:0] rvfi_rs1_rdata,
      output [4:0] rvfi_rs2_addr,
      output [31:0] rvfi_rs2_rdata,
      output [4:0] rvfi_rd_addr,
      output [31:0] rvfi_rd_wdata,
      output [31:0] rvfi_pc_rdata,
      output [31:0] rvfi_pc_wdata,
      output [31:0] rvfi_mem_addr,
      output [3:0] rvfi_mem_rmask,
      output [3:0] rvfi_mem_wmask,
      output [31:0] rvfi_mem_rdata,
      output [31:0] rvfi_mem_wdata,
      output  iBus_cmd_valid,
      input   iBus_cmd_ready,
      output [31:0] iBus_cmd_payload_pc,
      input   iBus_rsp_valid,
      input   iBus_rsp_payload_error,
      input  [31:0] iBus_rsp_payload_inst,
      output  dBus_cmd_valid,
      input   dBus_cmd_ready,
      output  dBus_cmd_payload_wr,
      output [31:0] dBus_cmd_payload_address,
      output [31:0] dBus_cmd_payload_data,
      output [1:0] dBus_cmd_payload_size,
      input   dBus_rsp_ready,
      input   dBus_rsp_error,
      input  [31:0] dBus_rsp_data,
      input   clk,
      input   reset);
  wire  _zz_190;
  reg [54:0] _zz_191;
  reg [31:0] _zz_192;
  reg [31:0] _zz_193;
  reg  _zz_194;
  reg  _zz_195;
  wire  _zz_196;
  wire [1:0] _zz_197;
  wire [31:0] _zz_198;
  wire  _zz_199;
  wire  _zz_200;
  wire [31:0] _zz_201;
  wire  _zz_202;
  wire  _zz_203;
  wire  _zz_204;
  wire [31:0] _zz_205;
  wire [0:0] _zz_206;
  wire  _zz_207;
  wire  _zz_208;
  wire  _zz_209;
  wire [4:0] _zz_210;
  wire [1:0] _zz_211;
  wire [1:0] _zz_212;
  wire [1:0] _zz_213;
  wire [2:0] _zz_214;
  wire [31:0] _zz_215;
  wire [2:0] _zz_216;
  wire [31:0] _zz_217;
  wire [31:0] _zz_218;
  wire [11:0] _zz_219;
  wire [11:0] _zz_220;
  wire [2:0] _zz_221;
  wire [31:0] _zz_222;
  wire [9:0] _zz_223;
  wire [0:0] _zz_224;
  wire [19:0] _zz_225;
  wire [29:0] _zz_226;
  wire [9:0] _zz_227;
  wire [1:0] _zz_228;
  wire [0:0] _zz_229;
  wire [1:0] _zz_230;
  wire [0:0] _zz_231;
  wire [1:0] _zz_232;
  wire [1:0] _zz_233;
  wire [0:0] _zz_234;
  wire [1:0] _zz_235;
  wire [0:0] _zz_236;
  wire [1:0] _zz_237;
  wire [2:0] _zz_238;
  wire [0:0] _zz_239;
  wire [2:0] _zz_240;
  wire [0:0] _zz_241;
  wire [2:0] _zz_242;
  wire [0:0] _zz_243;
  wire [2:0] _zz_244;
  wire [0:0] _zz_245;
  wire [2:0] _zz_246;
  wire [0:0] _zz_247;
  wire [0:0] _zz_248;
  wire [0:0] _zz_249;
  wire [0:0] _zz_250;
  wire [0:0] _zz_251;
  wire [0:0] _zz_252;
  wire [0:0] _zz_253;
  wire [0:0] _zz_254;
  wire [0:0] _zz_255;
  wire [2:0] _zz_256;
  wire [11:0] _zz_257;
  wire [11:0] _zz_258;
  wire [31:0] _zz_259;
  wire [31:0] _zz_260;
  wire [31:0] _zz_261;
  wire [31:0] _zz_262;
  wire [1:0] _zz_263;
  wire [31:0] _zz_264;
  wire [1:0] _zz_265;
  wire [1:0] _zz_266;
  wire [32:0] _zz_267;
  wire [31:0] _zz_268;
  wire [32:0] _zz_269;
  wire [19:0] _zz_270;
  wire [11:0] _zz_271;
  wire [11:0] _zz_272;
  wire [2:0] _zz_273;
  wire [31:0] _zz_274;
  wire [54:0] _zz_275;
  wire  _zz_276;
  wire  _zz_277;
  wire [6:0] _zz_278;
  wire [4:0] _zz_279;
  wire  _zz_280;
  wire [4:0] _zz_281;
  wire [31:0] _zz_282;
  wire [31:0] _zz_283;
  wire [1:0] _zz_284;
  wire [1:0] _zz_285;
  wire  _zz_286;
  wire [0:0] _zz_287;
  wire [13:0] _zz_288;
  wire [31:0] _zz_289;
  wire [31:0] _zz_290;
  wire [31:0] _zz_291;
  wire  _zz_292;
  wire  _zz_293;
  wire  _zz_294;
  wire [1:0] _zz_295;
  wire [1:0] _zz_296;
  wire  _zz_297;
  wire [0:0] _zz_298;
  wire [9:0] _zz_299;
  wire [31:0] _zz_300;
  wire [31:0] _zz_301;
  wire  _zz_302;
  wire [0:0] _zz_303;
  wire [0:0] _zz_304;
  wire [0:0] _zz_305;
  wire [0:0] _zz_306;
  wire  _zz_307;
  wire [0:0] _zz_308;
  wire [6:0] _zz_309;
  wire [31:0] _zz_310;
  wire [31:0] _zz_311;
  wire [31:0] _zz_312;
  wire [31:0] _zz_313;
  wire [0:0] _zz_314;
  wire [1:0] _zz_315;
  wire [2:0] _zz_316;
  wire [2:0] _zz_317;
  wire  _zz_318;
  wire [0:0] _zz_319;
  wire [3:0] _zz_320;
  wire [31:0] _zz_321;
  wire [31:0] _zz_322;
  wire [31:0] _zz_323;
  wire [31:0] _zz_324;
  wire [31:0] _zz_325;
  wire  _zz_326;
  wire [2:0] _zz_327;
  wire [2:0] _zz_328;
  wire  _zz_329;
  wire [0:0] _zz_330;
  wire [0:0] _zz_331;
  wire [31:0] _zz_332;
  wire [31:0] _zz_333;
  wire [31:0] _zz_334;
  wire [31:0] _zz_335;
  wire [31:0] _zz_336;
  wire [31:0] _zz_337;
  wire [31:0] _zz_338;
  wire  _zz_339;
  wire  _zz_340;
  wire [31:0] _zz_341;
  wire [31:0] _zz_342;
  wire [31:0] _zz_343;
  wire  _zz_344;
  wire [0:0] _zz_345;
  wire [6:0] _zz_346;
  wire [31:0] _zz_347;
  wire [31:0] _zz_348;
  wire [31:0] _zz_349;
  wire  _zz_350;
  wire [0:0] _zz_351;
  wire [0:0] _zz_352;
  wire  writeBack_FORMAL_HALT;
  wire  memory_FORMAL_HALT;
  wire  execute_FORMAL_HALT;
  wire  decode_FORMAL_HALT;
  wire `AluBitwiseCtrlEnum_binary_sequancial_type decode_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_binary_sequancial_type _zz_1;
  wire `AluBitwiseCtrlEnum_binary_sequancial_type _zz_2;
  wire `AluBitwiseCtrlEnum_binary_sequancial_type _zz_3;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_4;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_5;
  wire `ShiftCtrlEnum_binary_sequancial_type decode_SHIFT_CTRL;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_6;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_7;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_8;
  wire [31:0] writeBack_REGFILE_WRITE_DATA;
  wire [31:0] execute_REGFILE_WRITE_DATA;
  wire [31:0] execute_SHIFT_RIGHT;
  wire [31:0] writeBack_FORMAL_INSTRUCTION;
  wire [31:0] memory_FORMAL_INSTRUCTION;
  wire [31:0] execute_FORMAL_INSTRUCTION;
  wire [31:0] decode_FORMAL_INSTRUCTION;
  wire [31:0] decode_SRC1;
  wire [31:0] writeBack_FORMAL_MEM_ADDR;
  wire [31:0] memory_FORMAL_MEM_ADDR;
  wire [31:0] execute_FORMAL_MEM_ADDR;
  wire `AluCtrlEnum_binary_sequancial_type decode_ALU_CTRL;
  wire `AluCtrlEnum_binary_sequancial_type _zz_9;
  wire `AluCtrlEnum_binary_sequancial_type _zz_10;
  wire `AluCtrlEnum_binary_sequancial_type _zz_11;
  wire [31:0] writeBack_RS1;
  wire [31:0] memory_RS1;
  wire [31:0] decode_RS1;
  wire [31:0] decode_SRC2;
  wire `BranchCtrlEnum_binary_sequancial_type decode_BRANCH_CTRL;
  wire `BranchCtrlEnum_binary_sequancial_type _zz_12;
  wire `BranchCtrlEnum_binary_sequancial_type _zz_13;
  wire `BranchCtrlEnum_binary_sequancial_type _zz_14;
  wire [3:0] writeBack_FORMAL_MEM_RMASK;
  wire [3:0] memory_FORMAL_MEM_RMASK;
  wire [3:0] execute_FORMAL_MEM_RMASK;
  wire [31:0] writeBack_RS2;
  wire [31:0] memory_RS2;
  wire [31:0] decode_RS2;
  wire  execute_PREDICTION_CONTEXT_hazard;
  wire  execute_PREDICTION_CONTEXT_hit;
  wire [19:0] execute_PREDICTION_CONTEXT_line_source;
  wire [1:0] execute_PREDICTION_CONTEXT_line_branchWish;
  wire [31:0] execute_PREDICTION_CONTEXT_line_target;
  wire  execute_PREDICTION_CONTEXT_line_unaligned;
  wire  decode_PREDICTION_CONTEXT_hazard;
  wire  decode_PREDICTION_CONTEXT_hit;
  wire [19:0] decode_PREDICTION_CONTEXT_line_source;
  wire [1:0] decode_PREDICTION_CONTEXT_line_branchWish;
  wire [31:0] decode_PREDICTION_CONTEXT_line_target;
  wire  decode_PREDICTION_CONTEXT_line_unaligned;
  wire [31:0] memory_MEMORY_READ_DATA;
  wire  decode_MEMORY_ENABLE;
  wire  writeBack_RS1_USE;
  wire  memory_RS1_USE;
  wire  execute_RS1_USE;
  wire [31:0] execute_NEXT_PC2;
  wire  writeBack_RS2_USE;
  wire  memory_RS2_USE;
  wire  execute_RS2_USE;
  wire [31:0] writeBack_FORMAL_MEM_WDATA;
  wire [31:0] memory_FORMAL_MEM_WDATA;
  wire [31:0] execute_FORMAL_MEM_WDATA;
  wire  decode_SRC_USE_SUB_LESS;
  wire [3:0] writeBack_FORMAL_MEM_WMASK;
  wire [3:0] memory_FORMAL_MEM_WMASK;
  wire [3:0] execute_FORMAL_MEM_WMASK;
  wire [31:0] execute_BRANCH_CALC;
  wire [1:0] memory_MEMORY_ADDRESS_LOW;
  wire [1:0] execute_MEMORY_ADDRESS_LOW;
  wire  execute_BRANCH_DO;
  wire [31:0] writeBack_FORMAL_PC_NEXT;
  wire [31:0] memory_FORMAL_PC_NEXT;
  wire [31:0] execute_FORMAL_PC_NEXT;
  wire [31:0] decode_FORMAL_PC_NEXT;
  wire  decode_SRC_LESS_UNSIGNED;
  wire  execute_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_EXECUTE_STAGE;
  wire [31:0] writeBack_FORMAL_MEM_RDATA;
  wire [31:0] memory_NEXT_PC2;
  wire [31:0] memory_BRANCH_CALC;
  wire  memory_BRANCH_DO;
  wire  execute_IS_RVC;
  wire [31:0] _zz_15;
  wire [31:0] _zz_16;
  wire [31:0] execute_PC;
  wire [31:0] execute_RS1;
  wire `BranchCtrlEnum_binary_sequancial_type execute_BRANCH_CTRL;
  wire `BranchCtrlEnum_binary_sequancial_type _zz_17;
  wire  _zz_18;
  wire  decode_RS2_USE;
  wire  decode_RS1_USE;
  wire  execute_REGFILE_WRITE_VALID;
  wire  execute_BYPASSABLE_EXECUTE_STAGE;
  wire  memory_REGFILE_WRITE_VALID;
  wire  memory_BYPASSABLE_MEMORY_STAGE;
  wire  writeBack_REGFILE_WRITE_VALID;
  wire [31:0] memory_SHIFT_RIGHT;
  reg [31:0] _zz_19;
  wire `ShiftCtrlEnum_binary_sequancial_type memory_SHIFT_CTRL;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_20;
  wire [31:0] _zz_21;
  wire `ShiftCtrlEnum_binary_sequancial_type execute_SHIFT_CTRL;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_22;
  wire  _zz_23;
  wire [31:0] _zz_24;
  wire [31:0] _zz_25;
  wire  execute_SRC_LESS_UNSIGNED;
  wire  execute_SRC_USE_SUB_LESS;
  wire [31:0] _zz_26;
  wire [31:0] _zz_27;
  wire `Src2CtrlEnum_binary_sequancial_type decode_SRC2_CTRL;
  wire `Src2CtrlEnum_binary_sequancial_type _zz_28;
  wire [31:0] _zz_29;
  wire [31:0] _zz_30;
  wire `Src1CtrlEnum_binary_sequancial_type decode_SRC1_CTRL;
  wire `Src1CtrlEnum_binary_sequancial_type _zz_31;
  wire [31:0] _zz_32;
  wire [31:0] execute_SRC_ADD_SUB;
  wire  execute_SRC_LESS;
  wire `AluCtrlEnum_binary_sequancial_type execute_ALU_CTRL;
  wire `AluCtrlEnum_binary_sequancial_type _zz_33;
  wire [31:0] _zz_34;
  wire [31:0] execute_SRC2;
  wire [31:0] execute_SRC1;
  wire `AluBitwiseCtrlEnum_binary_sequancial_type execute_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_binary_sequancial_type _zz_35;
  reg  _zz_36;
  wire [31:0] _zz_37;
  wire [31:0] _zz_38;
  wire [31:0] decode_INSTRUCTION_ANTICIPATED;
  reg  decode_REGFILE_WRITE_VALID;
  wire  decode_LEGAL_INSTRUCTION;
  wire  decode_INSTRUCTION_READY;
  wire `Src2CtrlEnum_binary_sequancial_type _zz_39;
  wire  _zz_40;
  wire `AluCtrlEnum_binary_sequancial_type _zz_41;
  wire  _zz_42;
  wire  _zz_43;
  wire `AluBitwiseCtrlEnum_binary_sequancial_type _zz_44;
  wire  _zz_45;
  wire `BranchCtrlEnum_binary_sequancial_type _zz_46;
  wire  _zz_47;
  wire  _zz_48;
  wire `Src1CtrlEnum_binary_sequancial_type _zz_49;
  wire  _zz_50;
  wire  _zz_51;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_52;
  wire  _zz_53;
  wire [31:0] _zz_54;
  wire  writeBack_MEMORY_ENABLE;
  wire [1:0] writeBack_MEMORY_ADDRESS_LOW;
  wire [31:0] writeBack_MEMORY_READ_DATA;
  wire [31:0] memory_REGFILE_WRITE_DATA;
  wire  memory_ALIGNEMENT_FAULT;
  wire [31:0] memory_INSTRUCTION;
  wire  memory_MEMORY_ENABLE;
  wire [31:0] _zz_55;
  wire [31:0] _zz_56;
  wire [3:0] _zz_57;
  wire [3:0] _zz_58;
  wire [31:0] _zz_59;
  wire [1:0] _zz_60;
  wire [31:0] execute_RS2;
  wire [31:0] execute_SRC_ADD;
  wire [31:0] execute_INSTRUCTION;
  wire  execute_ALIGNEMENT_FAULT;
  wire  execute_MEMORY_ENABLE;
  wire  _zz_61;
  wire  memory_IS_RVC;
  wire [31:0] memory_PC;
  wire  memory_PREDICTION_CONTEXT_hazard;
  wire  memory_PREDICTION_CONTEXT_hit;
  wire [19:0] memory_PREDICTION_CONTEXT_line_source;
  wire [1:0] memory_PREDICTION_CONTEXT_line_branchWish;
  wire [31:0] memory_PREDICTION_CONTEXT_line_target;
  wire  memory_PREDICTION_CONTEXT_line_unaligned;
  wire  _zz_62;
  wire  _zz_63;
  wire [19:0] _zz_64;
  wire [1:0] _zz_65;
  wire [31:0] _zz_66;
  wire  _zz_67;
  reg  _zz_68;
  reg [31:0] _zz_69;
  reg [31:0] _zz_70;
  wire [31:0] _zz_71;
  wire  _zz_72;
  wire  _zz_73;
  wire [31:0] _zz_74;
  wire [31:0] _zz_75;
  wire [31:0] _zz_76;
  wire  decode_IS_RVC;
  wire  _zz_77;
  reg  _zz_78;
  reg  _zz_79;
  reg  _zz_80;
  reg  _zz_81;
  reg [31:0] _zz_82;
  wire  _zz_83;
  wire  _zz_84;
  wire [31:0] _zz_85;
  wire  _zz_86;
  wire [31:0] writeBack_PC /* verilator public */ ;
  wire [31:0] writeBack_INSTRUCTION /* verilator public */ ;
  wire [31:0] decode_PC /* verilator public */ ;
  wire [31:0] decode_INSTRUCTION /* verilator public */ ;
  reg  decode_arbitration_haltItself /* verilator public */ ;
  wire  decode_arbitration_haltByOther;
  reg  decode_arbitration_removeIt;
  wire  decode_arbitration_flushAll /* verilator public */ ;
  wire  decode_arbitration_redoIt;
  wire  decode_arbitration_isValid /* verilator public */ ;
  wire  decode_arbitration_isStuck;
  wire  decode_arbitration_isStuckByOthers;
  wire  decode_arbitration_isFlushed;
  wire  decode_arbitration_isMoving;
  wire  decode_arbitration_isFiring;
  reg  execute_arbitration_haltItself;
  wire  execute_arbitration_haltByOther;
  reg  execute_arbitration_removeIt;
  reg  execute_arbitration_flushAll;
  wire  execute_arbitration_redoIt;
  reg  execute_arbitration_isValid;
  wire  execute_arbitration_isStuck;
  wire  execute_arbitration_isStuckByOthers;
  wire  execute_arbitration_isFlushed;
  wire  execute_arbitration_isMoving;
  wire  execute_arbitration_isFiring;
  reg  memory_arbitration_haltItself;
  wire  memory_arbitration_haltByOther;
  reg  memory_arbitration_removeIt;
  wire  memory_arbitration_flushAll;
  wire  memory_arbitration_redoIt;
  reg  memory_arbitration_isValid;
  wire  memory_arbitration_isStuck;
  wire  memory_arbitration_isStuckByOthers;
  wire  memory_arbitration_isFlushed;
  wire  memory_arbitration_isMoving;
  wire  memory_arbitration_isFiring;
  wire  writeBack_arbitration_haltItself;
  wire  writeBack_arbitration_haltByOther;
  reg  writeBack_arbitration_removeIt;
  wire  writeBack_arbitration_flushAll;
  wire  writeBack_arbitration_redoIt;
  reg  writeBack_arbitration_isValid /* verilator public */ ;
  wire  writeBack_arbitration_isStuck;
  wire  writeBack_arbitration_isStuckByOthers;
  wire  writeBack_arbitration_isFlushed;
  wire  writeBack_arbitration_isMoving;
  wire  writeBack_arbitration_isFiring /* verilator public */ ;
  wire [31:0] _zz_87;
  reg  _zz_88;
  wire  decodeExceptionPort_valid;
  wire [3:0] decodeExceptionPort_payload_code;
  wire [31:0] decodeExceptionPort_payload_badAddr;
  wire  _zz_89;
  wire [31:0] _zz_90;
  reg [63:0] writeBack_FormalPlugin_order;
  reg  writeBack_FormalPlugin_haltRequest;
  wire  _zz_91;
  reg  _zz_92;
  reg  _zz_93;
  reg  _zz_94;
  reg  _zz_95;
  reg  _zz_96;
  reg  writeBack_FormalPlugin_haltFired;
  wire  IBusSimplePlugin_jump_pcLoad_valid;
  wire [31:0] IBusSimplePlugin_jump_pcLoad_payload;
  wire  IBusSimplePlugin_killLastStage;
  wire  IBusSimplePlugin_fetchPc_preOutput_valid;
  wire  IBusSimplePlugin_fetchPc_preOutput_ready;
  wire [31:0] IBusSimplePlugin_fetchPc_preOutput_payload;
  wire  _zz_97;
  wire  IBusSimplePlugin_fetchPc_output_valid;
  wire  IBusSimplePlugin_fetchPc_output_ready;
  wire [31:0] IBusSimplePlugin_fetchPc_output_payload;
  wire  IBusSimplePlugin_fetchPc_predictionPcLoad_valid;
  wire [31:0] IBusSimplePlugin_fetchPc_predictionPcLoad_payload;
  reg [31:0] IBusSimplePlugin_fetchPc_pcReg /* verilator public */ ;
  reg  IBusSimplePlugin_fetchPc_inc;
  reg [31:0] IBusSimplePlugin_fetchPc_pc;
  reg  IBusSimplePlugin_fetchPc_samplePcNext;
  reg  _zz_98;
  reg [31:0] IBusSimplePlugin_decodePc_pcReg /* verilator public */ ;
  wire [31:0] IBusSimplePlugin_decodePc_pcPlus;
  wire  IBusSimplePlugin_decodePc_injectedDecode;
  wire  IBusSimplePlugin_decodePc_predictionPcLoad_valid;
  wire [31:0] IBusSimplePlugin_decodePc_predictionPcLoad_payload;
  wire  IBusSimplePlugin_iBusRsp_input_valid;
  wire  IBusSimplePlugin_iBusRsp_input_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_input_payload;
  wire  IBusSimplePlugin_iBusRsp_inputPipeline_0_valid;
  reg  IBusSimplePlugin_iBusRsp_inputPipeline_0_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_inputPipeline_0_payload;
  wire  _zz_99;
  reg  _zz_100;
  reg [31:0] _zz_101;
  reg  IBusSimplePlugin_iBusRsp_readyForError;
  wire  IBusSimplePlugin_iBusRsp_output_valid;
  reg  IBusSimplePlugin_iBusRsp_output_ready;
  wire [31:0] IBusSimplePlugin_iBusRsp_output_payload_pc;
  wire  IBusSimplePlugin_iBusRsp_output_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_iBusRsp_output_payload_rsp_inst;
  wire  IBusSimplePlugin_iBusRsp_output_payload_isRvc;
  wire  IBusSimplePlugin_decompressor_output_valid;
  wire  IBusSimplePlugin_decompressor_output_ready;
  wire [31:0] IBusSimplePlugin_decompressor_output_payload_pc;
  wire  IBusSimplePlugin_decompressor_output_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_decompressor_output_payload_rsp_inst;
  wire  IBusSimplePlugin_decompressor_output_payload_isRvc;
  reg  IBusSimplePlugin_decompressor_bufferValid;
  reg [15:0] IBusSimplePlugin_decompressor_bufferData;
  wire [31:0] IBusSimplePlugin_decompressor_raw;
  wire  IBusSimplePlugin_decompressor_isRvc;
  wire [15:0] _zz_102;
  reg [31:0] IBusSimplePlugin_decompressor_decompressed;
  wire [4:0] _zz_103;
  wire [4:0] _zz_104;
  wire [11:0] _zz_105;
  wire  _zz_106;
  reg [11:0] _zz_107;
  wire  _zz_108;
  reg [9:0] _zz_109;
  wire [20:0] _zz_110;
  wire  _zz_111;
  reg [14:0] _zz_112;
  wire  _zz_113;
  reg [2:0] _zz_114;
  wire  _zz_115;
  reg [9:0] _zz_116;
  wire [20:0] _zz_117;
  wire  _zz_118;
  reg [4:0] _zz_119;
  wire [12:0] _zz_120;
  wire [4:0] _zz_121;
  wire [4:0] _zz_122;
  wire [4:0] _zz_123;
  wire  _zz_124;
  reg [2:0] _zz_125;
  reg [2:0] _zz_126;
  wire  _zz_127;
  reg [6:0] _zz_128;
  wire  IBusSimplePlugin_injector_decodeInput_valid;
  wire  IBusSimplePlugin_injector_decodeInput_ready;
  wire [31:0] IBusSimplePlugin_injector_decodeInput_payload_pc;
  wire  IBusSimplePlugin_injector_decodeInput_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  wire  IBusSimplePlugin_injector_decodeInput_payload_isRvc;
  reg  _zz_129;
  reg [31:0] _zz_130;
  reg  _zz_131;
  reg [31:0] _zz_132;
  reg  _zz_133;
  reg [31:0] IBusSimplePlugin_injector_formal_rawInDecode;
  reg  IBusSimplePlugin_predictor_historyWrite_valid;
  wire [9:0] IBusSimplePlugin_predictor_historyWrite_payload_address;
  wire [19:0] IBusSimplePlugin_predictor_historyWrite_payload_data_source;
  reg [1:0] IBusSimplePlugin_predictor_historyWrite_payload_data_branchWish;
  wire [31:0] IBusSimplePlugin_predictor_historyWrite_payload_data_target;
  wire  IBusSimplePlugin_predictor_historyWrite_payload_data_unaligned;
  wire [29:0] _zz_134;
  wire  _zz_135;
  wire [19:0] IBusSimplePlugin_predictor_line_source;
  wire [1:0] IBusSimplePlugin_predictor_line_branchWish;
  wire [31:0] IBusSimplePlugin_predictor_line_target;
  wire  IBusSimplePlugin_predictor_line_unaligned;
  wire [54:0] _zz_136;
  reg  IBusSimplePlugin_predictor_hit;
  reg  IBusSimplePlugin_predictor_historyWriteLast_valid;
  reg [9:0] IBusSimplePlugin_predictor_historyWriteLast_payload_address;
  reg [19:0] IBusSimplePlugin_predictor_historyWriteLast_payload_data_source;
  reg [1:0] IBusSimplePlugin_predictor_historyWriteLast_payload_data_branchWish;
  reg [31:0] IBusSimplePlugin_predictor_historyWriteLast_payload_data_target;
  reg  IBusSimplePlugin_predictor_historyWriteLast_payload_data_unaligned;
  wire  IBusSimplePlugin_predictor_hazard;
  wire  IBusSimplePlugin_predictor_fetchContext_hazard;
  wire  IBusSimplePlugin_predictor_fetchContext_hit;
  wire [19:0] IBusSimplePlugin_predictor_fetchContext_line_source;
  wire [1:0] IBusSimplePlugin_predictor_fetchContext_line_branchWish;
  wire [31:0] IBusSimplePlugin_predictor_fetchContext_line_target;
  wire  IBusSimplePlugin_predictor_fetchContext_line_unaligned;
  wire  IBusSimplePlugin_predictor_decompressorContext_hazard;
  reg  IBusSimplePlugin_predictor_decompressorContext_hit;
  wire [19:0] IBusSimplePlugin_predictor_decompressorContext_line_source;
  wire [1:0] IBusSimplePlugin_predictor_decompressorContext_line_branchWish;
  wire [31:0] IBusSimplePlugin_predictor_decompressorContext_line_target;
  wire  IBusSimplePlugin_predictor_decompressorContext_line_unaligned;
  reg  _zz_137;
  reg  _zz_138;
  reg [19:0] _zz_139;
  reg [1:0] _zz_140;
  reg [31:0] _zz_141;
  reg  _zz_142;
  wire  IBusSimplePlugin_predictor_injectorContext_hazard;
  wire  IBusSimplePlugin_predictor_injectorContext_hit;
  wire [19:0] IBusSimplePlugin_predictor_injectorContext_line_source;
  wire [1:0] IBusSimplePlugin_predictor_injectorContext_line_branchWish;
  wire [31:0] IBusSimplePlugin_predictor_injectorContext_line_target;
  wire  IBusSimplePlugin_predictor_injectorContext_line_unaligned;
  reg [2:0] IBusSimplePlugin_pendingCmd;
  wire [2:0] IBusSimplePlugin_pendingCmdNext;
  wire  _zz_143;
  reg [2:0] IBusSimplePlugin_rsp_discardCounter;
  wire [31:0] IBusSimplePlugin_rsp_fetchRsp_pc;
  reg  IBusSimplePlugin_rsp_fetchRsp_rsp_error;
  wire [31:0] IBusSimplePlugin_rsp_fetchRsp_rsp_inst;
  wire  IBusSimplePlugin_rsp_fetchRsp_isRvc;
  wire  IBusSimplePlugin_rsp_issueDetected;
  wire  _zz_144;
  wire  _zz_145;
  wire  IBusSimplePlugin_rsp_join_valid;
  wire  IBusSimplePlugin_rsp_join_ready;
  wire [31:0] IBusSimplePlugin_rsp_join_payload_pc;
  wire  IBusSimplePlugin_rsp_join_payload_rsp_error;
  wire [31:0] IBusSimplePlugin_rsp_join_payload_rsp_inst;
  wire  IBusSimplePlugin_rsp_join_payload_isRvc;
  wire  _zz_146;
  reg [31:0] _zz_147;
  reg [3:0] _zz_148;
  wire [3:0] execute_DBusSimplePlugin_formalMask;
  reg [31:0] writeBack_DBusSimplePlugin_rspShifted;
  wire  _zz_149;
  reg [31:0] _zz_150;
  wire  _zz_151;
  reg [31:0] _zz_152;
  reg [31:0] writeBack_DBusSimplePlugin_rspFormated;
  wire [19:0] _zz_153;
  wire  _zz_154;
  wire  _zz_155;
  wire  _zz_156;
  wire  _zz_157;
  wire `ShiftCtrlEnum_binary_sequancial_type _zz_158;
  wire `Src1CtrlEnum_binary_sequancial_type _zz_159;
  wire `BranchCtrlEnum_binary_sequancial_type _zz_160;
  wire `AluBitwiseCtrlEnum_binary_sequancial_type _zz_161;
  wire `AluCtrlEnum_binary_sequancial_type _zz_162;
  wire `Src2CtrlEnum_binary_sequancial_type _zz_163;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress1;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress2;
  wire [31:0] decode_RegFilePlugin_rs1Data;
  wire  _zz_164;
  wire [31:0] decode_RegFilePlugin_rs2Data;
  wire  _zz_165;
  reg  writeBack_RegFilePlugin_regFileWrite_valid /* verilator public */ ;
  wire [4:0] writeBack_RegFilePlugin_regFileWrite_payload_address /* verilator public */ ;
  wire [31:0] writeBack_RegFilePlugin_regFileWrite_payload_data /* verilator public */ ;
  reg  _zz_166;
  reg [31:0] execute_IntAluPlugin_bitwise;
  reg [31:0] _zz_167;
  reg [31:0] _zz_168;
  wire  _zz_169;
  reg [19:0] _zz_170;
  wire  _zz_171;
  reg [19:0] _zz_172;
  reg [31:0] _zz_173;
  wire [31:0] execute_SrcPlugin_addSub;
  wire  execute_SrcPlugin_less;
  wire [4:0] execute_FullBarrielShifterPlugin_amplitude;
  reg [31:0] _zz_174;
  wire [31:0] execute_FullBarrielShifterPlugin_reversed;
  reg [31:0] _zz_175;
  reg  _zz_176;
  reg  _zz_177;
  reg  _zz_178;
  reg [4:0] _zz_179;
  wire  execute_BranchPlugin_eq;
  wire [2:0] _zz_180;
  reg  _zz_181;
  reg  _zz_182;
  wire [31:0] execute_BranchPlugin_branch_src1;
  wire  _zz_183;
  reg [10:0] _zz_184;
  wire  _zz_185;
  reg [19:0] _zz_186;
  wire  _zz_187;
  reg [18:0] _zz_188;
  reg [31:0] _zz_189;
  wire [31:0] execute_BranchPlugin_branch_src2;
  wire [31:0] execute_BranchPlugin_branchAdder;
  wire  memory_BranchPlugin_predictionMissmatch;
  reg  decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg  decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg  execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg  decode_to_execute_SRC_LESS_UNSIGNED;
  reg [31:0] decode_to_execute_FORMAL_PC_NEXT;
  reg [31:0] execute_to_memory_FORMAL_PC_NEXT;
  reg [31:0] memory_to_writeBack_FORMAL_PC_NEXT;
  reg  execute_to_memory_ALIGNEMENT_FAULT;
  reg  execute_to_memory_BRANCH_DO;
  reg [1:0] execute_to_memory_MEMORY_ADDRESS_LOW;
  reg [1:0] memory_to_writeBack_MEMORY_ADDRESS_LOW;
  reg [31:0] execute_to_memory_BRANCH_CALC;
  reg [3:0] execute_to_memory_FORMAL_MEM_WMASK;
  reg [3:0] memory_to_writeBack_FORMAL_MEM_WMASK;
  reg  decode_to_execute_SRC_USE_SUB_LESS;
  reg [31:0] execute_to_memory_FORMAL_MEM_WDATA;
  reg [31:0] memory_to_writeBack_FORMAL_MEM_WDATA;
  reg  decode_to_execute_RS2_USE;
  reg  execute_to_memory_RS2_USE;
  reg  memory_to_writeBack_RS2_USE;
  reg [31:0] execute_to_memory_NEXT_PC2;
  reg  decode_to_execute_RS1_USE;
  reg  execute_to_memory_RS1_USE;
  reg  memory_to_writeBack_RS1_USE;
  reg [31:0] decode_to_execute_INSTRUCTION;
  reg [31:0] execute_to_memory_INSTRUCTION;
  reg [31:0] memory_to_writeBack_INSTRUCTION;
  reg  decode_to_execute_MEMORY_ENABLE;
  reg  execute_to_memory_MEMORY_ENABLE;
  reg  memory_to_writeBack_MEMORY_ENABLE;
  reg [31:0] memory_to_writeBack_MEMORY_READ_DATA;
  reg  decode_to_execute_PREDICTION_CONTEXT_hazard;
  reg  decode_to_execute_PREDICTION_CONTEXT_hit;
  reg [19:0] decode_to_execute_PREDICTION_CONTEXT_line_source;
  reg [1:0] decode_to_execute_PREDICTION_CONTEXT_line_branchWish;
  reg [31:0] decode_to_execute_PREDICTION_CONTEXT_line_target;
  reg  decode_to_execute_PREDICTION_CONTEXT_line_unaligned;
  reg  execute_to_memory_PREDICTION_CONTEXT_hazard;
  reg  execute_to_memory_PREDICTION_CONTEXT_hit;
  reg [19:0] execute_to_memory_PREDICTION_CONTEXT_line_source;
  reg [1:0] execute_to_memory_PREDICTION_CONTEXT_line_branchWish;
  reg [31:0] execute_to_memory_PREDICTION_CONTEXT_line_target;
  reg  execute_to_memory_PREDICTION_CONTEXT_line_unaligned;
  reg [31:0] decode_to_execute_RS2;
  reg [31:0] execute_to_memory_RS2;
  reg [31:0] memory_to_writeBack_RS2;
  reg  decode_to_execute_IS_RVC;
  reg  execute_to_memory_IS_RVC;
  reg [3:0] execute_to_memory_FORMAL_MEM_RMASK;
  reg [3:0] memory_to_writeBack_FORMAL_MEM_RMASK;
  reg `BranchCtrlEnum_binary_sequancial_type decode_to_execute_BRANCH_CTRL;
  reg [31:0] decode_to_execute_SRC2;
  reg [31:0] decode_to_execute_RS1;
  reg [31:0] execute_to_memory_RS1;
  reg [31:0] memory_to_writeBack_RS1;
  reg `AluCtrlEnum_binary_sequancial_type decode_to_execute_ALU_CTRL;
  reg [31:0] execute_to_memory_FORMAL_MEM_ADDR;
  reg [31:0] memory_to_writeBack_FORMAL_MEM_ADDR;
  reg [31:0] decode_to_execute_SRC1;
  reg [31:0] decode_to_execute_FORMAL_INSTRUCTION;
  reg [31:0] execute_to_memory_FORMAL_INSTRUCTION;
  reg [31:0] memory_to_writeBack_FORMAL_INSTRUCTION;
  reg [31:0] execute_to_memory_SHIFT_RIGHT;
  reg [31:0] execute_to_memory_REGFILE_WRITE_DATA;
  reg [31:0] memory_to_writeBack_REGFILE_WRITE_DATA;
  reg `ShiftCtrlEnum_binary_sequancial_type decode_to_execute_SHIFT_CTRL;
  reg `ShiftCtrlEnum_binary_sequancial_type execute_to_memory_SHIFT_CTRL;
  reg `AluBitwiseCtrlEnum_binary_sequancial_type decode_to_execute_ALU_BITWISE_CTRL;
  reg [31:0] decode_to_execute_PC;
  reg [31:0] execute_to_memory_PC;
  reg [31:0] memory_to_writeBack_PC;
  reg  decode_to_execute_REGFILE_WRITE_VALID;
  reg  execute_to_memory_REGFILE_WRITE_VALID;
  reg  memory_to_writeBack_REGFILE_WRITE_VALID;
  reg  decode_to_execute_FORMAL_HALT;
  reg  execute_to_memory_FORMAL_HALT;
  reg  memory_to_writeBack_FORMAL_HALT;
  reg [54:0] IBusSimplePlugin_predictor_history [0:1023];
  reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;
  assign rvfi_valid = _zz_194;
  assign rvfi_halt = _zz_195;
  assign iBus_cmd_valid = _zz_196;
  assign dBus_cmd_payload_size = _zz_197;
  assign dBus_cmd_payload_address = _zz_198;
  assign dBus_cmd_valid = _zz_199;
  assign dBus_cmd_payload_wr = _zz_200;
  assign dBus_cmd_payload_data = _zz_201;
  assign _zz_207 = (IBusSimplePlugin_fetchPc_preOutput_valid && IBusSimplePlugin_fetchPc_preOutput_ready);
  assign _zz_208 = (((IBusSimplePlugin_predictor_decompressorContext_line_branchWish[1] && IBusSimplePlugin_predictor_decompressorContext_hit) && (! IBusSimplePlugin_predictor_decompressorContext_hazard)) && (IBusSimplePlugin_decompressor_output_valid && IBusSimplePlugin_decompressor_output_ready));
  assign _zz_209 = (IBusSimplePlugin_iBusRsp_output_valid && IBusSimplePlugin_iBusRsp_output_ready);
  assign _zz_210 = {_zz_102[1 : 0],_zz_102[15 : 13]};
  assign _zz_211 = _zz_102[6 : 5];
  assign _zz_212 = _zz_102[11 : 10];
  assign _zz_213 = writeBack_INSTRUCTION[13 : 12];
  assign _zz_214 = {IBusSimplePlugin_fetchPc_inc,(2'b00)};
  assign _zz_215 = {29'd0, _zz_214};
  assign _zz_216 = (decode_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_217 = {29'd0, _zz_216};
  assign _zz_218 = {{_zz_112,_zz_102[6 : 2]},(12'b000000000000)};
  assign _zz_219 = {{{(4'b0000),_zz_102[8 : 7]},_zz_102[12 : 9]},(2'b00)};
  assign _zz_220 = {{{(4'b0000),_zz_102[8 : 7]},_zz_102[12 : 9]},(2'b00)};
  assign _zz_221 = (decode_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_222 = {29'd0, _zz_221};
  assign _zz_223 = _zz_134[9:0];
  assign _zz_224 = _zz_136[54 : 54];
  assign _zz_225 = (IBusSimplePlugin_iBusRsp_inputPipeline_0_payload >>> 12);
  assign _zz_226 = (IBusSimplePlugin_iBusRsp_inputPipeline_0_payload >>> 2);
  assign _zz_227 = _zz_226[9:0];
  assign _zz_228 = (memory_PREDICTION_CONTEXT_line_branchWish + _zz_230);
  assign _zz_229 = (memory_PREDICTION_CONTEXT_line_branchWish == (2'b10));
  assign _zz_230 = {1'd0, _zz_229};
  assign _zz_231 = (memory_PREDICTION_CONTEXT_line_branchWish == (2'b01));
  assign _zz_232 = {1'd0, _zz_231};
  assign _zz_233 = (memory_PREDICTION_CONTEXT_line_branchWish - _zz_235);
  assign _zz_234 = memory_PREDICTION_CONTEXT_line_branchWish[1];
  assign _zz_235 = {1'd0, _zz_234};
  assign _zz_236 = (! memory_PREDICTION_CONTEXT_line_branchWish[1]);
  assign _zz_237 = {1'd0, _zz_236};
  assign _zz_238 = (IBusSimplePlugin_pendingCmd + _zz_240);
  assign _zz_239 = (_zz_196 && iBus_cmd_ready);
  assign _zz_240 = {2'd0, _zz_239};
  assign _zz_241 = iBus_rsp_valid;
  assign _zz_242 = {2'd0, _zz_241};
  assign _zz_243 = (iBus_rsp_valid && (IBusSimplePlugin_rsp_discardCounter != (3'b000)));
  assign _zz_244 = {2'd0, _zz_243};
  assign _zz_245 = iBus_rsp_valid;
  assign _zz_246 = {2'd0, _zz_245};
  assign _zz_247 = _zz_153[2 : 2];
  assign _zz_248 = _zz_153[3 : 3];
  assign _zz_249 = _zz_153[6 : 6];
  assign _zz_250 = _zz_153[7 : 7];
  assign _zz_251 = _zz_153[10 : 10];
  assign _zz_252 = _zz_153[13 : 13];
  assign _zz_253 = _zz_153[14 : 14];
  assign _zz_254 = _zz_153[17 : 17];
  assign _zz_255 = execute_SRC_LESS;
  assign _zz_256 = (decode_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_257 = decode_INSTRUCTION[31 : 20];
  assign _zz_258 = {decode_INSTRUCTION[31 : 25],decode_INSTRUCTION[11 : 7]};
  assign _zz_259 = ($signed(_zz_260) + $signed(_zz_264));
  assign _zz_260 = ($signed(_zz_261) + $signed(_zz_262));
  assign _zz_261 = execute_SRC1;
  assign _zz_262 = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_263 = (execute_SRC_USE_SUB_LESS ? _zz_265 : _zz_266);
  assign _zz_264 = {{30{_zz_263[1]}}, _zz_263};
  assign _zz_265 = (2'b01);
  assign _zz_266 = (2'b00);
  assign _zz_267 = ($signed(_zz_269) >>> execute_FullBarrielShifterPlugin_amplitude);
  assign _zz_268 = _zz_267[31 : 0];
  assign _zz_269 = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_binary_sequancial_SRA_1) && execute_FullBarrielShifterPlugin_reversed[31]),execute_FullBarrielShifterPlugin_reversed};
  assign _zz_270 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_271 = execute_INSTRUCTION[31 : 20];
  assign _zz_272 = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_273 = (execute_IS_RVC ? (3'b010) : (3'b100));
  assign _zz_274 = {29'd0, _zz_273};
  assign _zz_275 = {IBusSimplePlugin_predictor_historyWrite_payload_data_unaligned,{IBusSimplePlugin_predictor_historyWrite_payload_data_target,{IBusSimplePlugin_predictor_historyWrite_payload_data_branchWish,IBusSimplePlugin_predictor_historyWrite_payload_data_source}}};
  assign _zz_276 = (_zz_102[11 : 10] == (2'b01));
  assign _zz_277 = ((_zz_102[11 : 10] == (2'b11)) && (_zz_102[6 : 5] == (2'b00)));
  assign _zz_278 = (7'b0000000);
  assign _zz_279 = _zz_102[6 : 2];
  assign _zz_280 = _zz_102[12];
  assign _zz_281 = _zz_102[11 : 7];
  assign _zz_282 = (decode_INSTRUCTION & (32'b00000000000000000000000001110000));
  assign _zz_283 = (32'b00000000000000000000000000100000);
  assign _zz_284 = {((decode_INSTRUCTION & _zz_289) == (32'b00000000000000000000000000100100)),((decode_INSTRUCTION & _zz_290) == (32'b00000000000000000100000000010000))};
  assign _zz_285 = (2'b00);
  assign _zz_286 = (((decode_INSTRUCTION & _zz_291) == (32'b00000000000000000010000000010000)) != (1'b0));
  assign _zz_287 = ({_zz_292,_zz_293} != (2'b00));
  assign _zz_288 = {(_zz_294 != (1'b0)),{(_zz_295 != _zz_296),{_zz_297,{_zz_298,_zz_299}}}};
  assign _zz_289 = (32'b00000000000000000000000001100100);
  assign _zz_290 = (32'b00000000000000000100000000010100);
  assign _zz_291 = (32'b00000000000000000110000000010100);
  assign _zz_292 = ((decode_INSTRUCTION & (32'b00000000000000000010000000010000)) == (32'b00000000000000000010000000000000));
  assign _zz_293 = ((decode_INSTRUCTION & (32'b00000000000000000101000000000000)) == (32'b00000000000000000001000000000000));
  assign _zz_294 = ((decode_INSTRUCTION & (32'b00000000000000000000000001010000)) == (32'b00000000000000000000000000000000));
  assign _zz_295 = {(_zz_300 == _zz_301),_zz_154};
  assign _zz_296 = (2'b00);
  assign _zz_297 = ({_zz_154,_zz_302} != (2'b00));
  assign _zz_298 = ({_zz_303,_zz_304} != (2'b00));
  assign _zz_299 = {(_zz_305 != _zz_306),{_zz_307,{_zz_308,_zz_309}}};
  assign _zz_300 = (decode_INSTRUCTION & (32'b00000000000000000001000000000000));
  assign _zz_301 = (32'b00000000000000000001000000000000);
  assign _zz_302 = ((decode_INSTRUCTION & (32'b00000000000000000011000000000000)) == (32'b00000000000000000010000000000000));
  assign _zz_303 = ((decode_INSTRUCTION & _zz_310) == (32'b00000000000000000000000000000000));
  assign _zz_304 = ((decode_INSTRUCTION & _zz_311) == (32'b00000000000000000000000000000000));
  assign _zz_305 = _zz_155;
  assign _zz_306 = (1'b0);
  assign _zz_307 = ((_zz_312 == _zz_313) != (1'b0));
  assign _zz_308 = ({_zz_314,_zz_315} != (3'b000));
  assign _zz_309 = {(_zz_316 != _zz_317),{_zz_318,{_zz_319,_zz_320}}};
  assign _zz_310 = (32'b00000000000000000000000000000100);
  assign _zz_311 = (32'b00000000000000000000000000011000);
  assign _zz_312 = (decode_INSTRUCTION & (32'b00000000000000000000000001001000));
  assign _zz_313 = (32'b00000000000000000000000001000000);
  assign _zz_314 = ((decode_INSTRUCTION & _zz_321) == (32'b00000000000000000000000001000000));
  assign _zz_315 = {(_zz_322 == _zz_323),(_zz_324 == _zz_325)};
  assign _zz_316 = {_zz_157,{_zz_154,_zz_156}};
  assign _zz_317 = (3'b000);
  assign _zz_318 = (_zz_155 != (1'b0));
  assign _zz_319 = (_zz_326 != (1'b0));
  assign _zz_320 = {(_zz_327 != _zz_328),{_zz_329,{_zz_330,_zz_331}}};
  assign _zz_321 = (32'b00000000000000000000000001000100);
  assign _zz_322 = (decode_INSTRUCTION & (32'b01000000000000000000000000110000));
  assign _zz_323 = (32'b01000000000000000000000000110000);
  assign _zz_324 = (decode_INSTRUCTION & (32'b00000000000000000010000000010100));
  assign _zz_325 = (32'b00000000000000000010000000010000);
  assign _zz_326 = ((decode_INSTRUCTION & (32'b00000000000000000000000001000100)) == (32'b00000000000000000000000000000100));
  assign _zz_327 = {_zz_154,{(_zz_332 == _zz_333),(_zz_334 == _zz_335)}};
  assign _zz_328 = (3'b000);
  assign _zz_329 = (((decode_INSTRUCTION & _zz_336) == (32'b00000000000000000000000000100000)) != (1'b0));
  assign _zz_330 = ((_zz_337 == _zz_338) != (1'b0));
  assign _zz_331 = ({_zz_339,_zz_340} != (2'b00));
  assign _zz_332 = (decode_INSTRUCTION & (32'b00000000000000000010000000010000));
  assign _zz_333 = (32'b00000000000000000010000000010000);
  assign _zz_334 = (decode_INSTRUCTION & (32'b00000000000000000001000000010000));
  assign _zz_335 = (32'b00000000000000000000000000010000);
  assign _zz_336 = (32'b00000000000000000000000000100100);
  assign _zz_337 = (decode_INSTRUCTION & (32'b00000000000000000111000000010100));
  assign _zz_338 = (32'b00000000000000000101000000010000);
  assign _zz_339 = ((decode_INSTRUCTION & (32'b01000000000000000011000000010100)) == (32'b01000000000000000001000000010000));
  assign _zz_340 = ((decode_INSTRUCTION & (32'b00000000000000000111000000010100)) == (32'b00000000000000000001000000010000));
  assign _zz_341 = (32'b00000000000000000100000001111111);
  assign _zz_342 = (decode_INSTRUCTION & (32'b00000000000000000010000001111111));
  assign _zz_343 = (32'b00000000000000000010000000010011);
  assign _zz_344 = ((decode_INSTRUCTION & (32'b00000000000000000110000000111111)) == (32'b00000000000000000000000000100011));
  assign _zz_345 = ((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000000000000000011));
  assign _zz_346 = {((decode_INSTRUCTION & (32'b00000000000000000101000001011111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & (32'b00000000000000000111000001111011)) == (32'b00000000000000000000000001100011)),{((decode_INSTRUCTION & _zz_347) == (32'b00000000000000000000000000110011)),{(_zz_348 == _zz_349),{_zz_350,{_zz_351,_zz_352}}}}}};
  assign _zz_347 = (32'b11111110000000000000000001111111);
  assign _zz_348 = (decode_INSTRUCTION & (32'b10111100000000000111000001111111));
  assign _zz_349 = (32'b00000000000000000101000000010011);
  assign _zz_350 = ((decode_INSTRUCTION & (32'b11111100000000000011000001111111)) == (32'b00000000000000000001000000010011));
  assign _zz_351 = ((decode_INSTRUCTION & (32'b10111110000000000111000001111111)) == (32'b00000000000000000101000000110011));
  assign _zz_352 = ((decode_INSTRUCTION & (32'b10111110000000000111000001111111)) == (32'b00000000000000000000000000110011));
  always @ (posedge clk) begin
    if(_zz_68) begin
      IBusSimplePlugin_predictor_history[IBusSimplePlugin_predictor_historyWrite_payload_address] <= _zz_275;
    end
  end

  always @ (posedge clk) begin
    if(_zz_135) begin
      _zz_191 <= IBusSimplePlugin_predictor_history[_zz_223];
    end
  end

  always @ (posedge clk) begin
    if(_zz_36) begin
      RegFilePlugin_regFile[writeBack_RegFilePlugin_regFileWrite_payload_address] <= writeBack_RegFilePlugin_regFileWrite_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_164) begin
      _zz_192 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_165) begin
      _zz_193 <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  StreamFifoLowLatency IBusSimplePlugin_rsp_rspBuffer ( 
    .io_push_valid(_zz_190),
    .io_push_ready(_zz_202),
    .io_push_payload_error(iBus_rsp_payload_error),
    .io_push_payload_inst(iBus_rsp_payload_inst),
    .io_pop_valid(_zz_203),
    .io_pop_ready(_zz_145),
    .io_pop_payload_error(_zz_204),
    .io_pop_payload_inst(_zz_205),
    .io_flush(IBusSimplePlugin_killLastStage),
    .io_occupancy(_zz_206),
    .clk(clk),
    .reset(reset) 
  );
  assign writeBack_FORMAL_HALT = memory_to_writeBack_FORMAL_HALT;
  assign memory_FORMAL_HALT = execute_to_memory_FORMAL_HALT;
  assign execute_FORMAL_HALT = decode_to_execute_FORMAL_HALT;
  assign decode_FORMAL_HALT = _zz_77;
  assign decode_ALU_BITWISE_CTRL = _zz_1;
  assign _zz_2 = _zz_3;
  assign _zz_4 = _zz_5;
  assign decode_SHIFT_CTRL = _zz_6;
  assign _zz_7 = _zz_8;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign execute_REGFILE_WRITE_DATA = _zz_34;
  assign execute_SHIFT_RIGHT = _zz_21;
  assign writeBack_FORMAL_INSTRUCTION = memory_to_writeBack_FORMAL_INSTRUCTION;
  assign memory_FORMAL_INSTRUCTION = execute_to_memory_FORMAL_INSTRUCTION;
  assign execute_FORMAL_INSTRUCTION = decode_to_execute_FORMAL_INSTRUCTION;
  assign decode_FORMAL_INSTRUCTION = _zz_71;
  assign decode_SRC1 = _zz_32;
  assign writeBack_FORMAL_MEM_ADDR = memory_to_writeBack_FORMAL_MEM_ADDR;
  assign memory_FORMAL_MEM_ADDR = execute_to_memory_FORMAL_MEM_ADDR;
  assign execute_FORMAL_MEM_ADDR = _zz_59;
  assign decode_ALU_CTRL = _zz_9;
  assign _zz_10 = _zz_11;
  assign writeBack_RS1 = memory_to_writeBack_RS1;
  assign memory_RS1 = execute_to_memory_RS1;
  assign decode_RS1 = _zz_38;
  assign decode_SRC2 = _zz_29;
  assign decode_BRANCH_CTRL = _zz_12;
  assign _zz_13 = _zz_14;
  assign writeBack_FORMAL_MEM_RMASK = memory_to_writeBack_FORMAL_MEM_RMASK;
  assign memory_FORMAL_MEM_RMASK = execute_to_memory_FORMAL_MEM_RMASK;
  assign execute_FORMAL_MEM_RMASK = _zz_57;
  assign writeBack_RS2 = memory_to_writeBack_RS2;
  assign memory_RS2 = execute_to_memory_RS2;
  assign decode_RS2 = _zz_37;
  assign execute_PREDICTION_CONTEXT_hazard = decode_to_execute_PREDICTION_CONTEXT_hazard;
  assign execute_PREDICTION_CONTEXT_hit = decode_to_execute_PREDICTION_CONTEXT_hit;
  assign execute_PREDICTION_CONTEXT_line_source = decode_to_execute_PREDICTION_CONTEXT_line_source;
  assign execute_PREDICTION_CONTEXT_line_branchWish = decode_to_execute_PREDICTION_CONTEXT_line_branchWish;
  assign execute_PREDICTION_CONTEXT_line_target = decode_to_execute_PREDICTION_CONTEXT_line_target;
  assign execute_PREDICTION_CONTEXT_line_unaligned = decode_to_execute_PREDICTION_CONTEXT_line_unaligned;
  assign decode_PREDICTION_CONTEXT_hazard = _zz_62;
  assign decode_PREDICTION_CONTEXT_hit = _zz_63;
  assign decode_PREDICTION_CONTEXT_line_source = _zz_64;
  assign decode_PREDICTION_CONTEXT_line_branchWish = _zz_65;
  assign decode_PREDICTION_CONTEXT_line_target = _zz_66;
  assign decode_PREDICTION_CONTEXT_line_unaligned = _zz_67;
  assign memory_MEMORY_READ_DATA = _zz_55;
  assign decode_MEMORY_ENABLE = _zz_43;
  assign writeBack_RS1_USE = memory_to_writeBack_RS1_USE;
  assign memory_RS1_USE = execute_to_memory_RS1_USE;
  assign execute_RS1_USE = decode_to_execute_RS1_USE;
  assign execute_NEXT_PC2 = _zz_15;
  assign writeBack_RS2_USE = memory_to_writeBack_RS2_USE;
  assign memory_RS2_USE = execute_to_memory_RS2_USE;
  assign execute_RS2_USE = decode_to_execute_RS2_USE;
  assign writeBack_FORMAL_MEM_WDATA = memory_to_writeBack_FORMAL_MEM_WDATA;
  assign memory_FORMAL_MEM_WDATA = execute_to_memory_FORMAL_MEM_WDATA;
  assign execute_FORMAL_MEM_WDATA = _zz_56;
  assign decode_SRC_USE_SUB_LESS = _zz_47;
  assign writeBack_FORMAL_MEM_WMASK = memory_to_writeBack_FORMAL_MEM_WMASK;
  assign memory_FORMAL_MEM_WMASK = execute_to_memory_FORMAL_MEM_WMASK;
  assign execute_FORMAL_MEM_WMASK = _zz_58;
  assign execute_BRANCH_CALC = _zz_16;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign execute_MEMORY_ADDRESS_LOW = _zz_60;
  assign execute_BRANCH_DO = _zz_18;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = _zz_70;
  assign decode_SRC_LESS_UNSIGNED = _zz_42;
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_40;
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_50;
  assign writeBack_FORMAL_MEM_RDATA = _zz_54;
  assign memory_NEXT_PC2 = execute_to_memory_NEXT_PC2;
  assign memory_BRANCH_CALC = execute_to_memory_BRANCH_CALC;
  assign memory_BRANCH_DO = execute_to_memory_BRANCH_DO;
  assign execute_IS_RVC = decode_to_execute_IS_RVC;
  assign execute_PC = decode_to_execute_PC;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_BRANCH_CTRL = _zz_17;
  assign decode_RS2_USE = _zz_51;
  assign decode_RS1_USE = _zz_45;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  assign memory_SHIFT_RIGHT = execute_to_memory_SHIFT_RIGHT;
  always @ (*) begin
    _zz_19 = memory_REGFILE_WRITE_DATA;
    case(memory_SHIFT_CTRL)
      `ShiftCtrlEnum_binary_sequancial_SLL_1 : begin
        _zz_19 = _zz_175;
      end
      `ShiftCtrlEnum_binary_sequancial_SRL_1, `ShiftCtrlEnum_binary_sequancial_SRA_1 : begin
        _zz_19 = memory_SHIFT_RIGHT;
      end
      default : begin
      end
    endcase
  end

  assign memory_SHIFT_CTRL = _zz_20;
  assign execute_SHIFT_CTRL = _zz_22;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_26 = decode_PC;
  assign _zz_27 = decode_RS2;
  assign decode_SRC2_CTRL = _zz_28;
  assign _zz_30 = decode_RS1;
  assign decode_SRC1_CTRL = _zz_31;
  assign execute_SRC_ADD_SUB = _zz_25;
  assign execute_SRC_LESS = _zz_23;
  assign execute_ALU_CTRL = _zz_33;
  assign execute_SRC2 = decode_to_execute_SRC2;
  assign execute_SRC1 = decode_to_execute_SRC1;
  assign execute_ALU_BITWISE_CTRL = _zz_35;
  always @ (*) begin
    _zz_36 = 1'b0;
    if(writeBack_RegFilePlugin_regFileWrite_valid)begin
      _zz_36 = 1'b1;
    end
  end

  assign decode_INSTRUCTION_ANTICIPATED = _zz_76;
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_48;
    if((decode_INSTRUCTION[11 : 7] == (5'b00000)))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = _zz_53;
  assign decode_INSTRUCTION_READY = _zz_73;
  assign writeBack_MEMORY_ENABLE = memory_to_writeBack_MEMORY_ENABLE;
  assign writeBack_MEMORY_ADDRESS_LOW = memory_to_writeBack_MEMORY_ADDRESS_LOW;
  assign writeBack_MEMORY_READ_DATA = memory_to_writeBack_MEMORY_READ_DATA;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_ALIGNEMENT_FAULT = execute_to_memory_ALIGNEMENT_FAULT;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_SRC_ADD = _zz_24;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign execute_ALIGNEMENT_FAULT = _zz_61;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign memory_IS_RVC = execute_to_memory_IS_RVC;
  assign memory_PC = execute_to_memory_PC;
  assign memory_PREDICTION_CONTEXT_hazard = execute_to_memory_PREDICTION_CONTEXT_hazard;
  assign memory_PREDICTION_CONTEXT_hit = execute_to_memory_PREDICTION_CONTEXT_hit;
  assign memory_PREDICTION_CONTEXT_line_source = execute_to_memory_PREDICTION_CONTEXT_line_source;
  assign memory_PREDICTION_CONTEXT_line_branchWish = execute_to_memory_PREDICTION_CONTEXT_line_branchWish;
  assign memory_PREDICTION_CONTEXT_line_target = execute_to_memory_PREDICTION_CONTEXT_line_target;
  assign memory_PREDICTION_CONTEXT_line_unaligned = execute_to_memory_PREDICTION_CONTEXT_line_unaligned;
  always @ (*) begin
    _zz_68 = 1'b0;
    if(IBusSimplePlugin_predictor_historyWrite_valid)begin
      _zz_68 = 1'b1;
    end
  end

  always @ (*) begin
    _zz_69 = memory_FORMAL_PC_NEXT;
    if(_zz_89)begin
      _zz_69 = _zz_90;
    end
  end

  assign decode_IS_RVC = _zz_72;
  always @ (*) begin
    _zz_78 = writeBack_FORMAL_HALT;
    if(writeBack_arbitration_isFlushed)begin
      _zz_78 = 1'b0;
    end
    if(writeBack_arbitration_isFlushed)begin
      _zz_78 = 1'b0;
    end
  end

  always @ (*) begin
    _zz_79 = memory_FORMAL_HALT;
    memory_arbitration_haltItself = 1'b0;
    if(memory_arbitration_isFlushed)begin
      _zz_79 = 1'b0;
    end
    if((_zz_88 || ((memory_arbitration_isValid && memory_BRANCH_DO) && (memory_BRANCH_CALC[0 : 0] != (1'b0)))))begin
      _zz_79 = 1'b1;
      memory_arbitration_haltItself = 1'b1;
    end
    if(memory_arbitration_isFlushed)begin
      _zz_79 = 1'b0;
    end
    if((((memory_arbitration_isValid && memory_MEMORY_ENABLE) && (! memory_INSTRUCTION[5])) && (! dBus_rsp_ready)))begin
      memory_arbitration_haltItself = 1'b1;
    end
  end

  always @ (*) begin
    _zz_80 = execute_FORMAL_HALT;
    if(execute_arbitration_isFlushed)begin
      _zz_80 = 1'b0;
    end
    if(execute_arbitration_isFlushed)begin
      _zz_80 = 1'b0;
    end
  end

  always @ (*) begin
    _zz_81 = decode_FORMAL_HALT;
    decode_arbitration_haltItself = 1'b0;
    if(decodeExceptionPort_valid)begin
      _zz_81 = 1'b1;
      decode_arbitration_haltItself = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      _zz_81 = 1'b0;
    end
    if(decode_arbitration_isFlushed)begin
      _zz_81 = 1'b0;
    end
    if((decode_arbitration_isValid && (_zz_176 || _zz_177)))begin
      decode_arbitration_haltItself = 1'b1;
    end
  end

  always @ (*) begin
    _zz_82 = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_82 = writeBack_DBusSimplePlugin_rspFormated;
    end
  end

  assign _zz_83 = writeBack_REGFILE_WRITE_VALID;
  assign _zz_84 = writeBack_RS2_USE;
  assign _zz_85 = writeBack_INSTRUCTION;
  assign _zz_86 = writeBack_RS1_USE;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  assign decode_PC = _zz_75;
  assign decode_INSTRUCTION = _zz_74;
  assign decode_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushAll = 1'b0;
  assign decode_arbitration_redoIt = 1'b0;
  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! dBus_cmd_ready)) && (! execute_ALIGNEMENT_FAULT)))begin
      execute_arbitration_haltItself = 1'b1;
    end
  end

  assign execute_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_flushAll = 1'b0;
    if(_zz_89)begin
      execute_arbitration_flushAll = 1'b1;
    end
  end

  assign execute_arbitration_redoIt = 1'b0;
  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushAll = 1'b0;
  assign memory_arbitration_redoIt = 1'b0;
  assign writeBack_arbitration_haltItself = 1'b0;
  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  assign writeBack_arbitration_flushAll = 1'b0;
  assign writeBack_arbitration_redoIt = 1'b0;
  always @ (*) begin
    _zz_194 = writeBack_arbitration_isFiring;
    rvfi_trap = 1'b0;
    _zz_195 = 1'b0;
    if(_zz_96)begin
      _zz_194 = 1'b1;
      rvfi_trap = 1'b1;
      _zz_195 = 1'b1;
    end
    if(writeBack_FormalPlugin_haltFired)begin
      _zz_194 = 1'b0;
    end
  end

  assign rvfi_order = writeBack_FormalPlugin_order;
  assign rvfi_insn = writeBack_FORMAL_INSTRUCTION;
  assign rvfi_intr = 1'b0;
  assign rvfi_rs1_addr = (_zz_86 ? _zz_85[19 : 15] : (5'b00000));
  assign rvfi_rs2_addr = (_zz_84 ? _zz_85[24 : 20] : (5'b00000));
  assign rvfi_rs1_rdata = (_zz_86 ? writeBack_RS1 : (32'b00000000000000000000000000000000));
  assign rvfi_rs2_rdata = (_zz_84 ? writeBack_RS2 : (32'b00000000000000000000000000000000));
  assign rvfi_rd_addr = (_zz_83 ? _zz_85[11 : 7] : (5'b00000));
  assign rvfi_rd_wdata = (_zz_83 ? _zz_82 : (32'b00000000000000000000000000000000));
  assign rvfi_pc_rdata = writeBack_PC;
  assign rvfi_pc_wdata = writeBack_FORMAL_PC_NEXT;
  assign rvfi_mem_addr = writeBack_FORMAL_MEM_ADDR;
  assign rvfi_mem_rmask = writeBack_FORMAL_MEM_RMASK;
  assign rvfi_mem_wmask = writeBack_FORMAL_MEM_WMASK;
  assign rvfi_mem_rdata = writeBack_FORMAL_MEM_RDATA;
  assign rvfi_mem_wdata = writeBack_FORMAL_MEM_WDATA;
  always @ (*) begin
    writeBack_FormalPlugin_haltRequest = 1'b0;
    if((decode_arbitration_isValid && _zz_81))begin
      if((((1'b1 && (! execute_arbitration_isValid)) && (! memory_arbitration_isValid)) && (! writeBack_arbitration_isValid)))begin
        writeBack_FormalPlugin_haltRequest = 1'b1;
      end
    end
    if((execute_arbitration_isValid && _zz_80))begin
      if(((1'b1 && (! memory_arbitration_isValid)) && (! writeBack_arbitration_isValid)))begin
        writeBack_FormalPlugin_haltRequest = 1'b1;
      end
    end
    if((memory_arbitration_isValid && _zz_79))begin
      if((1'b1 && (! writeBack_arbitration_isValid)))begin
        writeBack_FormalPlugin_haltRequest = 1'b1;
      end
    end
    if((writeBack_arbitration_isValid && _zz_78))begin
      if(1'b1)begin
        writeBack_FormalPlugin_haltRequest = 1'b1;
      end
    end
  end

  assign _zz_91 = 1'b0;
  assign _zz_77 = 1'b0;
  assign IBusSimplePlugin_jump_pcLoad_valid = _zz_89;
  assign IBusSimplePlugin_jump_pcLoad_payload = _zz_90;
  assign IBusSimplePlugin_killLastStage = (IBusSimplePlugin_jump_pcLoad_valid || decode_arbitration_removeIt);
  assign _zz_97 = (! 1'b0);
  assign IBusSimplePlugin_fetchPc_output_valid = (IBusSimplePlugin_fetchPc_preOutput_valid && _zz_97);
  assign IBusSimplePlugin_fetchPc_preOutput_ready = (IBusSimplePlugin_fetchPc_output_ready && _zz_97);
  assign IBusSimplePlugin_fetchPc_output_payload = IBusSimplePlugin_fetchPc_preOutput_payload;
  always @ (*) begin
    IBusSimplePlugin_fetchPc_pc = (IBusSimplePlugin_fetchPc_pcReg + _zz_215);
    IBusSimplePlugin_fetchPc_samplePcNext = 1'b0;
    if(IBusSimplePlugin_fetchPc_predictionPcLoad_valid)begin
      IBusSimplePlugin_fetchPc_samplePcNext = 1'b1;
      IBusSimplePlugin_fetchPc_pc = IBusSimplePlugin_fetchPc_predictionPcLoad_payload;
    end
    if(IBusSimplePlugin_jump_pcLoad_valid)begin
      IBusSimplePlugin_fetchPc_samplePcNext = 1'b1;
      IBusSimplePlugin_fetchPc_pc = IBusSimplePlugin_jump_pcLoad_payload;
    end
    if(_zz_207)begin
      IBusSimplePlugin_fetchPc_samplePcNext = 1'b1;
    end
  end

  assign IBusSimplePlugin_fetchPc_preOutput_valid = _zz_98;
  assign IBusSimplePlugin_fetchPc_preOutput_payload = IBusSimplePlugin_fetchPc_pc;
  assign IBusSimplePlugin_decodePc_pcPlus = (IBusSimplePlugin_decodePc_pcReg + _zz_217);
  assign IBusSimplePlugin_decodePc_injectedDecode = 1'b0;
  assign IBusSimplePlugin_iBusRsp_input_ready = ((1'b0 && (! _zz_99)) || IBusSimplePlugin_iBusRsp_inputPipeline_0_ready);
  assign _zz_99 = _zz_100;
  assign IBusSimplePlugin_iBusRsp_inputPipeline_0_valid = _zz_99;
  assign IBusSimplePlugin_iBusRsp_inputPipeline_0_payload = _zz_101;
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_readyForError = 1'b1;
    if((IBusSimplePlugin_decompressor_bufferValid && IBusSimplePlugin_decompressor_isRvc))begin
      IBusSimplePlugin_iBusRsp_readyForError = 1'b0;
    end
    if(IBusSimplePlugin_injector_decodeInput_valid)begin
      IBusSimplePlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusSimplePlugin_decompressor_raw = (IBusSimplePlugin_decompressor_bufferValid ? {IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[15 : 0],IBusSimplePlugin_decompressor_bufferData} : {IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[31 : 16],(IBusSimplePlugin_iBusRsp_output_payload_pc[1] ? IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[31 : 16] : IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[15 : 0])});
  assign IBusSimplePlugin_decompressor_isRvc = (IBusSimplePlugin_decompressor_raw[1 : 0] != (2'b11));
  assign _zz_102 = IBusSimplePlugin_decompressor_raw[15 : 0];
  always @ (*) begin
    IBusSimplePlugin_decompressor_decompressed = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(_zz_210)
      5'b00000 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{{{{{(2'b00),_zz_102[10 : 7]},_zz_102[12 : 11]},_zz_102[5]},_zz_102[6]},(2'b00)},(5'b00010)},(3'b000)},_zz_104},(7'b0010011)};
      end
      5'b00010 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{_zz_105,_zz_103},(3'b010)},_zz_104},(7'b0000011)};
      end
      5'b00110 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{_zz_105[11 : 5],_zz_104},_zz_103},(3'b010)},_zz_105[4 : 0]},(7'b0100011)};
      end
      5'b01000 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{_zz_107,_zz_102[11 : 7]},(3'b000)},_zz_102[11 : 7]},(7'b0010011)};
      end
      5'b01001 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{_zz_110[20],_zz_110[10 : 1]},_zz_110[11]},_zz_110[19 : 12]},_zz_122},(7'b1101111)};
      end
      5'b01010 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{_zz_107,(5'b00000)},(3'b000)},_zz_102[11 : 7]},(7'b0010011)};
      end
      5'b01011 : begin
        IBusSimplePlugin_decompressor_decompressed = ((_zz_102[11 : 7] == (5'b00010)) ? {{{{{{{{{_zz_114,_zz_102[4 : 3]},_zz_102[5]},_zz_102[2]},_zz_102[6]},(4'b0000)},_zz_102[11 : 7]},(3'b000)},_zz_102[11 : 7]},(7'b0010011)} : {{_zz_218[31 : 12],_zz_102[11 : 7]},(7'b0110111)});
      end
      5'b01100 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{((_zz_102[11 : 10] == (2'b10)) ? _zz_128 : {{(1'b0),(_zz_276 || _zz_277)},(5'b00000)}),(((! _zz_102[11]) || _zz_124) ? _zz_102[6 : 2] : _zz_104)},_zz_103},_zz_126},_zz_103},(_zz_124 ? (7'b0010011) : (7'b0110011))};
      end
      5'b01101 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{_zz_117[20],_zz_117[10 : 1]},_zz_117[11]},_zz_117[19 : 12]},_zz_121},(7'b1101111)};
      end
      5'b01110 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{{{_zz_120[12],_zz_120[10 : 5]},_zz_121},_zz_103},(3'b000)},_zz_120[4 : 1]},_zz_120[11]},(7'b1100011)};
      end
      5'b01111 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{{{_zz_120[12],_zz_120[10 : 5]},_zz_121},_zz_103},(3'b001)},_zz_120[4 : 1]},_zz_120[11]},(7'b1100011)};
      end
      5'b10000 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{(7'b0000000),_zz_102[6 : 2]},_zz_102[11 : 7]},(3'b001)},_zz_102[11 : 7]},(7'b0010011)};
      end
      5'b10010 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{{{{(4'b0000),_zz_102[3 : 2]},_zz_102[12]},_zz_102[6 : 4]},(2'b00)},_zz_123},(3'b010)},_zz_102[11 : 7]},(7'b0000011)};
      end
      5'b10100 : begin
        IBusSimplePlugin_decompressor_decompressed = ((_zz_102[12 : 2] == (11'b10000000000)) ? (32'b00000000000100000000000001110011) : ((_zz_102[6 : 2] == (5'b00000)) ? {{{{(12'b000000000000),_zz_102[11 : 7]},(3'b000)},(_zz_102[12] ? _zz_122 : _zz_121)},(7'b1100111)} : {{{{{_zz_278,_zz_279},(_zz_280 ? _zz_281 : _zz_121)},(3'b000)},_zz_102[11 : 7]},(7'b0110011)}));
      end
      5'b10110 : begin
        IBusSimplePlugin_decompressor_decompressed = {{{{{_zz_219[11 : 5],_zz_102[6 : 2]},_zz_123},(3'b010)},_zz_220[4 : 0]},(7'b0100011)};
      end
      default : begin
      end
    endcase
  end

  assign _zz_103 = {(2'b01),_zz_102[9 : 7]};
  assign _zz_104 = {(2'b01),_zz_102[4 : 2]};
  assign _zz_105 = {{{{(5'b00000),_zz_102[5]},_zz_102[12 : 10]},_zz_102[6]},(2'b00)};
  assign _zz_106 = _zz_102[12];
  always @ (*) begin
    _zz_107[11] = _zz_106;
    _zz_107[10] = _zz_106;
    _zz_107[9] = _zz_106;
    _zz_107[8] = _zz_106;
    _zz_107[7] = _zz_106;
    _zz_107[6] = _zz_106;
    _zz_107[5] = _zz_106;
    _zz_107[4 : 0] = _zz_102[6 : 2];
  end

  assign _zz_108 = _zz_102[12];
  always @ (*) begin
    _zz_109[9] = _zz_108;
    _zz_109[8] = _zz_108;
    _zz_109[7] = _zz_108;
    _zz_109[6] = _zz_108;
    _zz_109[5] = _zz_108;
    _zz_109[4] = _zz_108;
    _zz_109[3] = _zz_108;
    _zz_109[2] = _zz_108;
    _zz_109[1] = _zz_108;
    _zz_109[0] = _zz_108;
  end

  assign _zz_110 = {{{{{{{{_zz_109,_zz_102[8]},_zz_102[10 : 9]},_zz_102[6]},_zz_102[7]},_zz_102[2]},_zz_102[11]},_zz_102[5 : 3]},(1'b0)};
  assign _zz_111 = _zz_102[12];
  always @ (*) begin
    _zz_112[14] = _zz_111;
    _zz_112[13] = _zz_111;
    _zz_112[12] = _zz_111;
    _zz_112[11] = _zz_111;
    _zz_112[10] = _zz_111;
    _zz_112[9] = _zz_111;
    _zz_112[8] = _zz_111;
    _zz_112[7] = _zz_111;
    _zz_112[6] = _zz_111;
    _zz_112[5] = _zz_111;
    _zz_112[4] = _zz_111;
    _zz_112[3] = _zz_111;
    _zz_112[2] = _zz_111;
    _zz_112[1] = _zz_111;
    _zz_112[0] = _zz_111;
  end

  assign _zz_113 = _zz_102[12];
  always @ (*) begin
    _zz_114[2] = _zz_113;
    _zz_114[1] = _zz_113;
    _zz_114[0] = _zz_113;
  end

  assign _zz_115 = _zz_102[12];
  always @ (*) begin
    _zz_116[9] = _zz_115;
    _zz_116[8] = _zz_115;
    _zz_116[7] = _zz_115;
    _zz_116[6] = _zz_115;
    _zz_116[5] = _zz_115;
    _zz_116[4] = _zz_115;
    _zz_116[3] = _zz_115;
    _zz_116[2] = _zz_115;
    _zz_116[1] = _zz_115;
    _zz_116[0] = _zz_115;
  end

  assign _zz_117 = {{{{{{{{_zz_116,_zz_102[8]},_zz_102[10 : 9]},_zz_102[6]},_zz_102[7]},_zz_102[2]},_zz_102[11]},_zz_102[5 : 3]},(1'b0)};
  assign _zz_118 = _zz_102[12];
  always @ (*) begin
    _zz_119[4] = _zz_118;
    _zz_119[3] = _zz_118;
    _zz_119[2] = _zz_118;
    _zz_119[1] = _zz_118;
    _zz_119[0] = _zz_118;
  end

  assign _zz_120 = {{{{{_zz_119,_zz_102[6 : 5]},_zz_102[2]},_zz_102[11 : 10]},_zz_102[4 : 3]},(1'b0)};
  assign _zz_121 = (5'b00000);
  assign _zz_122 = (5'b00001);
  assign _zz_123 = (5'b00010);
  assign _zz_124 = (_zz_102[11 : 10] != (2'b11));
  always @ (*) begin
    case(_zz_211)
      2'b00 : begin
        _zz_125 = (3'b000);
      end
      2'b01 : begin
        _zz_125 = (3'b100);
      end
      2'b10 : begin
        _zz_125 = (3'b110);
      end
      default : begin
        _zz_125 = (3'b111);
      end
    endcase
  end

  always @ (*) begin
    case(_zz_212)
      2'b00 : begin
        _zz_126 = (3'b101);
      end
      2'b01 : begin
        _zz_126 = (3'b101);
      end
      2'b10 : begin
        _zz_126 = (3'b111);
      end
      default : begin
        _zz_126 = _zz_125;
      end
    endcase
  end

  assign _zz_127 = _zz_102[12];
  always @ (*) begin
    _zz_128[6] = _zz_127;
    _zz_128[5] = _zz_127;
    _zz_128[4] = _zz_127;
    _zz_128[3] = _zz_127;
    _zz_128[2] = _zz_127;
    _zz_128[1] = _zz_127;
    _zz_128[0] = _zz_127;
  end

  assign IBusSimplePlugin_decompressor_output_valid = (IBusSimplePlugin_decompressor_isRvc ? (IBusSimplePlugin_decompressor_bufferValid || IBusSimplePlugin_iBusRsp_output_valid) : (IBusSimplePlugin_iBusRsp_output_valid && (IBusSimplePlugin_decompressor_bufferValid || (! IBusSimplePlugin_iBusRsp_output_payload_pc[1]))));
  assign IBusSimplePlugin_decompressor_output_payload_pc = IBusSimplePlugin_iBusRsp_output_payload_pc;
  assign IBusSimplePlugin_decompressor_output_payload_isRvc = IBusSimplePlugin_decompressor_isRvc;
  assign IBusSimplePlugin_decompressor_output_payload_rsp_inst = (IBusSimplePlugin_decompressor_isRvc ? IBusSimplePlugin_decompressor_decompressed : IBusSimplePlugin_decompressor_raw);
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_output_ready = ((! IBusSimplePlugin_decompressor_output_valid) || (! (((! IBusSimplePlugin_decompressor_output_ready) || ((IBusSimplePlugin_decompressor_isRvc && (! IBusSimplePlugin_iBusRsp_output_payload_pc[1])) && (IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[17 : 16] != (2'b11)))) || (((! IBusSimplePlugin_decompressor_isRvc) && IBusSimplePlugin_decompressor_bufferValid) && (IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[17 : 16] != (2'b11))))));
    if(_zz_208)begin
      IBusSimplePlugin_iBusRsp_output_ready = 1'b1;
    end
  end

  assign IBusSimplePlugin_decompressor_output_ready = ((1'b0 && (! IBusSimplePlugin_injector_decodeInput_valid)) || IBusSimplePlugin_injector_decodeInput_ready);
  assign IBusSimplePlugin_injector_decodeInput_valid = _zz_129;
  assign IBusSimplePlugin_injector_decodeInput_payload_pc = _zz_130;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_error = _zz_131;
  assign IBusSimplePlugin_injector_decodeInput_payload_rsp_inst = _zz_132;
  assign IBusSimplePlugin_injector_decodeInput_payload_isRvc = _zz_133;
  assign _zz_76 = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusSimplePlugin_decompressor_output_payload_rsp_inst);
  assign IBusSimplePlugin_injector_decodeInput_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = IBusSimplePlugin_injector_decodeInput_valid;
  assign _zz_75 = IBusSimplePlugin_decodePc_pcReg;
  assign _zz_74 = IBusSimplePlugin_injector_decodeInput_payload_rsp_inst;
  assign _zz_73 = 1'b1;
  assign _zz_72 = IBusSimplePlugin_injector_decodeInput_payload_isRvc;
  assign _zz_71 = IBusSimplePlugin_injector_formal_rawInDecode;
  always @ (*) begin
    _zz_70 = (decode_PC + _zz_222);
    if(IBusSimplePlugin_decodePc_predictionPcLoad_valid)begin
      _zz_70 = IBusSimplePlugin_decodePc_predictionPcLoad_payload;
    end
  end

  assign _zz_134 = (IBusSimplePlugin_fetchPc_output_payload >>> 2);
  assign _zz_135 = (IBusSimplePlugin_iBusRsp_inputPipeline_0_ready || IBusSimplePlugin_killLastStage);
  assign _zz_136 = _zz_191;
  assign IBusSimplePlugin_predictor_line_source = _zz_136[19 : 0];
  assign IBusSimplePlugin_predictor_line_branchWish = _zz_136[21 : 20];
  assign IBusSimplePlugin_predictor_line_target = _zz_136[53 : 22];
  assign IBusSimplePlugin_predictor_line_unaligned = _zz_224[0];
  always @ (*) begin
    IBusSimplePlugin_predictor_hit = ((IBusSimplePlugin_predictor_line_source == _zz_225) && (! ((! IBusSimplePlugin_predictor_line_unaligned) && IBusSimplePlugin_iBusRsp_inputPipeline_0_payload[1])));
    if((! IBusSimplePlugin_decompressor_output_valid))begin
      IBusSimplePlugin_predictor_hit = 1'b0;
    end
  end

  assign IBusSimplePlugin_predictor_hazard = (IBusSimplePlugin_predictor_historyWriteLast_valid && (IBusSimplePlugin_predictor_historyWriteLast_payload_address == _zz_227));
  assign IBusSimplePlugin_fetchPc_predictionPcLoad_valid = (((IBusSimplePlugin_predictor_line_branchWish[1] && IBusSimplePlugin_predictor_hit) && (! IBusSimplePlugin_predictor_hazard)) && (IBusSimplePlugin_iBusRsp_inputPipeline_0_valid && IBusSimplePlugin_iBusRsp_inputPipeline_0_ready));
  assign IBusSimplePlugin_fetchPc_predictionPcLoad_payload = IBusSimplePlugin_predictor_line_target;
  assign IBusSimplePlugin_predictor_fetchContext_hazard = IBusSimplePlugin_predictor_hazard;
  assign IBusSimplePlugin_predictor_fetchContext_hit = IBusSimplePlugin_predictor_hit;
  assign IBusSimplePlugin_predictor_fetchContext_line_source = IBusSimplePlugin_predictor_line_source;
  assign IBusSimplePlugin_predictor_fetchContext_line_branchWish = IBusSimplePlugin_predictor_line_branchWish;
  assign IBusSimplePlugin_predictor_fetchContext_line_target = IBusSimplePlugin_predictor_line_target;
  assign IBusSimplePlugin_predictor_fetchContext_line_unaligned = IBusSimplePlugin_predictor_line_unaligned;
  assign IBusSimplePlugin_predictor_decompressorContext_hazard = IBusSimplePlugin_predictor_fetchContext_hazard;
  always @ (*) begin
    IBusSimplePlugin_predictor_decompressorContext_hit = IBusSimplePlugin_predictor_fetchContext_hit;
    if((IBusSimplePlugin_predictor_decompressorContext_line_unaligned && (IBusSimplePlugin_decompressor_bufferValid || (IBusSimplePlugin_decompressor_isRvc && (! IBusSimplePlugin_iBusRsp_output_payload_pc[1])))))begin
      IBusSimplePlugin_predictor_decompressorContext_hit = 1'b0;
    end
  end

  assign IBusSimplePlugin_predictor_decompressorContext_line_source = IBusSimplePlugin_predictor_fetchContext_line_source;
  assign IBusSimplePlugin_predictor_decompressorContext_line_branchWish = IBusSimplePlugin_predictor_fetchContext_line_branchWish;
  assign IBusSimplePlugin_predictor_decompressorContext_line_target = IBusSimplePlugin_predictor_fetchContext_line_target;
  assign IBusSimplePlugin_predictor_decompressorContext_line_unaligned = IBusSimplePlugin_predictor_fetchContext_line_unaligned;
  assign IBusSimplePlugin_predictor_injectorContext_hazard = _zz_137;
  assign IBusSimplePlugin_predictor_injectorContext_hit = _zz_138;
  assign IBusSimplePlugin_predictor_injectorContext_line_source = _zz_139;
  assign IBusSimplePlugin_predictor_injectorContext_line_branchWish = _zz_140;
  assign IBusSimplePlugin_predictor_injectorContext_line_target = _zz_141;
  assign IBusSimplePlugin_predictor_injectorContext_line_unaligned = _zz_142;
  assign IBusSimplePlugin_decodePc_predictionPcLoad_valid = (((IBusSimplePlugin_predictor_injectorContext_line_branchWish[1] && IBusSimplePlugin_predictor_injectorContext_hit) && (! IBusSimplePlugin_predictor_injectorContext_hazard)) && (IBusSimplePlugin_injector_decodeInput_valid && IBusSimplePlugin_injector_decodeInput_ready));
  assign IBusSimplePlugin_decodePc_predictionPcLoad_payload = IBusSimplePlugin_predictor_injectorContext_line_target;
  assign _zz_62 = IBusSimplePlugin_predictor_injectorContext_hazard;
  assign _zz_63 = IBusSimplePlugin_predictor_injectorContext_hit;
  assign _zz_64 = IBusSimplePlugin_predictor_injectorContext_line_source;
  assign _zz_65 = IBusSimplePlugin_predictor_injectorContext_line_branchWish;
  assign _zz_66 = IBusSimplePlugin_predictor_injectorContext_line_target;
  assign _zz_67 = IBusSimplePlugin_predictor_injectorContext_line_unaligned;
  always @ (*) begin
    IBusSimplePlugin_predictor_historyWrite_valid = 1'b0;
    if((! memory_BranchPlugin_predictionMissmatch))begin
      IBusSimplePlugin_predictor_historyWrite_valid = memory_PREDICTION_CONTEXT_hit;
      IBusSimplePlugin_predictor_historyWrite_payload_data_branchWish = (_zz_228 - _zz_232);
    end else begin
      if(memory_PREDICTION_CONTEXT_hit)begin
        IBusSimplePlugin_predictor_historyWrite_valid = 1'b1;
        IBusSimplePlugin_predictor_historyWrite_payload_data_branchWish = (_zz_233 + _zz_237);
      end else begin
        IBusSimplePlugin_predictor_historyWrite_valid = 1'b1;
        IBusSimplePlugin_predictor_historyWrite_payload_data_branchWish = (2'b10);
      end
    end
    if((memory_PREDICTION_CONTEXT_hazard || (! memory_arbitration_isFiring)))begin
      IBusSimplePlugin_predictor_historyWrite_valid = 1'b0;
    end
  end

  assign IBusSimplePlugin_predictor_historyWrite_payload_address = _zz_87[11 : 2];
  assign IBusSimplePlugin_predictor_historyWrite_payload_data_source = (_zz_87 >>> 12);
  assign IBusSimplePlugin_predictor_historyWrite_payload_data_target = memory_BRANCH_CALC;
  assign IBusSimplePlugin_predictor_historyWrite_payload_data_unaligned = ((! memory_PC[1]) ^ memory_IS_RVC);
  assign IBusSimplePlugin_pendingCmdNext = (_zz_238 - _zz_242);
  assign _zz_143 = (_zz_196 && iBus_cmd_ready);
  assign IBusSimplePlugin_fetchPc_output_ready = (IBusSimplePlugin_iBusRsp_input_ready && _zz_143);
  assign IBusSimplePlugin_iBusRsp_input_valid = (IBusSimplePlugin_fetchPc_output_valid && _zz_143);
  assign IBusSimplePlugin_iBusRsp_input_payload = IBusSimplePlugin_fetchPc_output_payload;
  assign _zz_196 = ((IBusSimplePlugin_fetchPc_output_valid && IBusSimplePlugin_iBusRsp_input_ready) && (IBusSimplePlugin_pendingCmd != (3'b111)));
  assign iBus_cmd_payload_pc = {IBusSimplePlugin_fetchPc_output_payload[31 : 2],(2'b00)};
  assign _zz_190 = (iBus_rsp_valid && (! (IBusSimplePlugin_rsp_discardCounter != (3'b000))));
  assign IBusSimplePlugin_rsp_fetchRsp_pc = IBusSimplePlugin_iBusRsp_inputPipeline_0_payload;
  always @ (*) begin
    IBusSimplePlugin_rsp_fetchRsp_rsp_error = _zz_204;
    if((! _zz_203))begin
      IBusSimplePlugin_rsp_fetchRsp_rsp_error = 1'b0;
    end
  end

  assign IBusSimplePlugin_rsp_fetchRsp_rsp_inst = _zz_205;
  assign IBusSimplePlugin_rsp_issueDetected = 1'b0;
  assign _zz_145 = (_zz_144 && IBusSimplePlugin_rsp_join_ready);
  assign _zz_144 = (IBusSimplePlugin_iBusRsp_inputPipeline_0_valid && _zz_203);
  always @ (*) begin
    IBusSimplePlugin_iBusRsp_inputPipeline_0_ready = _zz_145;
    if((! IBusSimplePlugin_iBusRsp_inputPipeline_0_valid))begin
      IBusSimplePlugin_iBusRsp_inputPipeline_0_ready = 1'b1;
    end
  end

  assign IBusSimplePlugin_rsp_join_valid = _zz_144;
  assign IBusSimplePlugin_rsp_join_payload_pc = IBusSimplePlugin_rsp_fetchRsp_pc;
  assign IBusSimplePlugin_rsp_join_payload_rsp_error = IBusSimplePlugin_rsp_fetchRsp_rsp_error;
  assign IBusSimplePlugin_rsp_join_payload_rsp_inst = IBusSimplePlugin_rsp_fetchRsp_rsp_inst;
  assign IBusSimplePlugin_rsp_join_payload_isRvc = IBusSimplePlugin_rsp_fetchRsp_isRvc;
  assign _zz_146 = (! IBusSimplePlugin_rsp_issueDetected);
  assign IBusSimplePlugin_rsp_join_ready = (IBusSimplePlugin_iBusRsp_output_ready && _zz_146);
  assign IBusSimplePlugin_iBusRsp_output_valid = (IBusSimplePlugin_rsp_join_valid && _zz_146);
  assign IBusSimplePlugin_iBusRsp_output_payload_pc = IBusSimplePlugin_rsp_join_payload_pc;
  assign IBusSimplePlugin_iBusRsp_output_payload_rsp_error = IBusSimplePlugin_rsp_join_payload_rsp_error;
  assign IBusSimplePlugin_iBusRsp_output_payload_rsp_inst = IBusSimplePlugin_rsp_join_payload_rsp_inst;
  assign IBusSimplePlugin_iBusRsp_output_payload_isRvc = IBusSimplePlugin_rsp_join_payload_isRvc;
  assign _zz_61 = (((_zz_197 == (2'b10)) && (_zz_198[1 : 0] != (2'b00))) || ((_zz_197 == (2'b01)) && (_zz_198[0 : 0] != (1'b0))));
  assign _zz_199 = ((((execute_arbitration_isValid && execute_MEMORY_ENABLE) && (! execute_arbitration_isStuckByOthers)) && (! execute_arbitration_removeIt)) && (! execute_ALIGNEMENT_FAULT));
  assign _zz_200 = execute_INSTRUCTION[5];
  assign _zz_198 = execute_SRC_ADD;
  assign _zz_197 = execute_INSTRUCTION[13 : 12];
  always @ (*) begin
    case(_zz_197)
      2'b00 : begin
        _zz_147 = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_147 = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_147 = execute_RS2[31 : 0];
      end
    endcase
  end

  assign _zz_201 = _zz_147;
  assign _zz_60 = _zz_198[1 : 0];
  always @ (*) begin
    case(_zz_197)
      2'b00 : begin
        _zz_148 = (4'b0001);
      end
      2'b01 : begin
        _zz_148 = (4'b0011);
      end
      default : begin
        _zz_148 = (4'b1111);
      end
    endcase
  end

  assign execute_DBusSimplePlugin_formalMask = (_zz_148 <<< _zz_198[1 : 0]);
  assign _zz_59 = (_zz_198 & (32'b11111111111111111111111111111100));
  assign _zz_58 = ((_zz_199 && _zz_200) ? execute_DBusSimplePlugin_formalMask : (4'b0000));
  assign _zz_57 = ((_zz_199 && (! _zz_200)) ? execute_DBusSimplePlugin_formalMask : (4'b0000));
  assign _zz_56 = _zz_201;
  assign _zz_55 = dBus_rsp_data;
  always @ (*) begin
    _zz_88 = memory_ALIGNEMENT_FAULT;
    if((! (memory_arbitration_isValid && memory_MEMORY_ENABLE)))begin
      _zz_88 = 1'b0;
    end
  end

  always @ (*) begin
    writeBack_DBusSimplePlugin_rspShifted = writeBack_MEMORY_READ_DATA;
    case(writeBack_MEMORY_ADDRESS_LOW)
      2'b01 : begin
        writeBack_DBusSimplePlugin_rspShifted[7 : 0] = writeBack_MEMORY_READ_DATA[15 : 8];
      end
      2'b10 : begin
        writeBack_DBusSimplePlugin_rspShifted[15 : 0] = writeBack_MEMORY_READ_DATA[31 : 16];
      end
      2'b11 : begin
        writeBack_DBusSimplePlugin_rspShifted[7 : 0] = writeBack_MEMORY_READ_DATA[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign _zz_149 = (writeBack_DBusSimplePlugin_rspShifted[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_150[31] = _zz_149;
    _zz_150[30] = _zz_149;
    _zz_150[29] = _zz_149;
    _zz_150[28] = _zz_149;
    _zz_150[27] = _zz_149;
    _zz_150[26] = _zz_149;
    _zz_150[25] = _zz_149;
    _zz_150[24] = _zz_149;
    _zz_150[23] = _zz_149;
    _zz_150[22] = _zz_149;
    _zz_150[21] = _zz_149;
    _zz_150[20] = _zz_149;
    _zz_150[19] = _zz_149;
    _zz_150[18] = _zz_149;
    _zz_150[17] = _zz_149;
    _zz_150[16] = _zz_149;
    _zz_150[15] = _zz_149;
    _zz_150[14] = _zz_149;
    _zz_150[13] = _zz_149;
    _zz_150[12] = _zz_149;
    _zz_150[11] = _zz_149;
    _zz_150[10] = _zz_149;
    _zz_150[9] = _zz_149;
    _zz_150[8] = _zz_149;
    _zz_150[7 : 0] = writeBack_DBusSimplePlugin_rspShifted[7 : 0];
  end

  assign _zz_151 = (writeBack_DBusSimplePlugin_rspShifted[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_152[31] = _zz_151;
    _zz_152[30] = _zz_151;
    _zz_152[29] = _zz_151;
    _zz_152[28] = _zz_151;
    _zz_152[27] = _zz_151;
    _zz_152[26] = _zz_151;
    _zz_152[25] = _zz_151;
    _zz_152[24] = _zz_151;
    _zz_152[23] = _zz_151;
    _zz_152[22] = _zz_151;
    _zz_152[21] = _zz_151;
    _zz_152[20] = _zz_151;
    _zz_152[19] = _zz_151;
    _zz_152[18] = _zz_151;
    _zz_152[17] = _zz_151;
    _zz_152[16] = _zz_151;
    _zz_152[15 : 0] = writeBack_DBusSimplePlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_213)
      2'b00 : begin
        writeBack_DBusSimplePlugin_rspFormated = _zz_150;
      end
      2'b01 : begin
        writeBack_DBusSimplePlugin_rspFormated = _zz_152;
      end
      default : begin
        writeBack_DBusSimplePlugin_rspFormated = writeBack_DBusSimplePlugin_rspShifted;
      end
    endcase
  end

  assign _zz_54 = writeBack_MEMORY_READ_DATA;
  assign _zz_154 = ((decode_INSTRUCTION & (32'b00000000000000000000000000000100)) == (32'b00000000000000000000000000000100));
  assign _zz_155 = ((decode_INSTRUCTION & (32'b00000000000000000000000000010100)) == (32'b00000000000000000000000000000100));
  assign _zz_156 = ((decode_INSTRUCTION & (32'b00000000000000000000000000100000)) == (32'b00000000000000000000000000000000));
  assign _zz_157 = ((decode_INSTRUCTION & (32'b00000000000000000000000000010000)) == (32'b00000000000000000000000000010000));
  assign _zz_153 = {({_zz_154,(_zz_282 == _zz_283)} != (2'b00)),{({_zz_154,_zz_156} != (2'b00)),{(_zz_157 != (1'b0)),{(_zz_284 != _zz_285),{_zz_286,{_zz_287,_zz_288}}}}}};
  assign _zz_53 = ({((decode_INSTRUCTION & (32'b00000000000000000000000001011111)) == (32'b00000000000000000000000000010111)),{((decode_INSTRUCTION & (32'b00000000000000000000000001111111)) == (32'b00000000000000000000000001101111)),{((decode_INSTRUCTION & (32'b00000000000000000001000001101111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_341) == (32'b00000000000000000100000001100011)),{(_zz_342 == _zz_343),{_zz_344,{_zz_345,_zz_346}}}}}}} != (14'b00000000000000));
  assign _zz_158 = _zz_153[1 : 0];
  assign _zz_52 = _zz_158;
  assign _zz_51 = _zz_247[0];
  assign _zz_50 = _zz_248[0];
  assign _zz_159 = _zz_153[5 : 4];
  assign _zz_49 = _zz_159;
  assign _zz_48 = _zz_249[0];
  assign _zz_47 = _zz_250[0];
  assign _zz_160 = _zz_153[9 : 8];
  assign _zz_46 = _zz_160;
  assign _zz_45 = _zz_251[0];
  assign _zz_161 = _zz_153[12 : 11];
  assign _zz_44 = _zz_161;
  assign _zz_43 = _zz_252[0];
  assign _zz_42 = _zz_253[0];
  assign _zz_162 = _zz_153[16 : 15];
  assign _zz_41 = _zz_162;
  assign _zz_40 = _zz_254[0];
  assign _zz_163 = _zz_153[19 : 18];
  assign _zz_39 = _zz_163;
  assign decodeExceptionPort_valid = ((decode_arbitration_isValid && decode_INSTRUCTION_READY) && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign _zz_164 = 1'b1;
  assign decode_RegFilePlugin_rs1Data = _zz_192;
  assign _zz_165 = 1'b1;
  assign decode_RegFilePlugin_rs2Data = _zz_193;
  assign _zz_38 = decode_RegFilePlugin_rs1Data;
  assign _zz_37 = decode_RegFilePlugin_rs2Data;
  always @ (*) begin
    writeBack_RegFilePlugin_regFileWrite_valid = (_zz_83 && writeBack_arbitration_isFiring);
    if(_zz_166)begin
      writeBack_RegFilePlugin_regFileWrite_valid = 1'b1;
    end
  end

  assign writeBack_RegFilePlugin_regFileWrite_payload_address = _zz_85[11 : 7];
  assign writeBack_RegFilePlugin_regFileWrite_payload_data = _zz_82;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_binary_sequancial_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_binary_sequancial_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      `AluBitwiseCtrlEnum_binary_sequancial_XOR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = execute_SRC1;
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_binary_sequancial_BITWISE : begin
        _zz_167 = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_binary_sequancial_SLT_SLTU : begin
        _zz_167 = {31'd0, _zz_255};
      end
      default : begin
        _zz_167 = execute_SRC_ADD_SUB;
      end
    endcase
  end

  assign _zz_34 = _zz_167;
  always @ (*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_binary_sequancial_RS : begin
        _zz_168 = _zz_30;
      end
      `Src1CtrlEnum_binary_sequancial_PC_INCREMENT : begin
        _zz_168 = {29'd0, _zz_256};
      end
      default : begin
        _zz_168 = {decode_INSTRUCTION[31 : 12],(12'b000000000000)};
      end
    endcase
  end

  assign _zz_32 = _zz_168;
  assign _zz_169 = _zz_257[11];
  always @ (*) begin
    _zz_170[19] = _zz_169;
    _zz_170[18] = _zz_169;
    _zz_170[17] = _zz_169;
    _zz_170[16] = _zz_169;
    _zz_170[15] = _zz_169;
    _zz_170[14] = _zz_169;
    _zz_170[13] = _zz_169;
    _zz_170[12] = _zz_169;
    _zz_170[11] = _zz_169;
    _zz_170[10] = _zz_169;
    _zz_170[9] = _zz_169;
    _zz_170[8] = _zz_169;
    _zz_170[7] = _zz_169;
    _zz_170[6] = _zz_169;
    _zz_170[5] = _zz_169;
    _zz_170[4] = _zz_169;
    _zz_170[3] = _zz_169;
    _zz_170[2] = _zz_169;
    _zz_170[1] = _zz_169;
    _zz_170[0] = _zz_169;
  end

  assign _zz_171 = _zz_258[11];
  always @ (*) begin
    _zz_172[19] = _zz_171;
    _zz_172[18] = _zz_171;
    _zz_172[17] = _zz_171;
    _zz_172[16] = _zz_171;
    _zz_172[15] = _zz_171;
    _zz_172[14] = _zz_171;
    _zz_172[13] = _zz_171;
    _zz_172[12] = _zz_171;
    _zz_172[11] = _zz_171;
    _zz_172[10] = _zz_171;
    _zz_172[9] = _zz_171;
    _zz_172[8] = _zz_171;
    _zz_172[7] = _zz_171;
    _zz_172[6] = _zz_171;
    _zz_172[5] = _zz_171;
    _zz_172[4] = _zz_171;
    _zz_172[3] = _zz_171;
    _zz_172[2] = _zz_171;
    _zz_172[1] = _zz_171;
    _zz_172[0] = _zz_171;
  end

  always @ (*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_binary_sequancial_RS : begin
        _zz_173 = _zz_27;
      end
      `Src2CtrlEnum_binary_sequancial_IMI : begin
        _zz_173 = {_zz_170,decode_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_binary_sequancial_IMS : begin
        _zz_173 = {_zz_172,{decode_INSTRUCTION[31 : 25],decode_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_173 = _zz_26;
      end
    endcase
  end

  assign _zz_29 = _zz_173;
  assign execute_SrcPlugin_addSub = _zz_259;
  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign _zz_25 = execute_SrcPlugin_addSub;
  assign _zz_24 = execute_SrcPlugin_addSub;
  assign _zz_23 = execute_SrcPlugin_less;
  assign execute_FullBarrielShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_174[0] = execute_SRC1[31];
    _zz_174[1] = execute_SRC1[30];
    _zz_174[2] = execute_SRC1[29];
    _zz_174[3] = execute_SRC1[28];
    _zz_174[4] = execute_SRC1[27];
    _zz_174[5] = execute_SRC1[26];
    _zz_174[6] = execute_SRC1[25];
    _zz_174[7] = execute_SRC1[24];
    _zz_174[8] = execute_SRC1[23];
    _zz_174[9] = execute_SRC1[22];
    _zz_174[10] = execute_SRC1[21];
    _zz_174[11] = execute_SRC1[20];
    _zz_174[12] = execute_SRC1[19];
    _zz_174[13] = execute_SRC1[18];
    _zz_174[14] = execute_SRC1[17];
    _zz_174[15] = execute_SRC1[16];
    _zz_174[16] = execute_SRC1[15];
    _zz_174[17] = execute_SRC1[14];
    _zz_174[18] = execute_SRC1[13];
    _zz_174[19] = execute_SRC1[12];
    _zz_174[20] = execute_SRC1[11];
    _zz_174[21] = execute_SRC1[10];
    _zz_174[22] = execute_SRC1[9];
    _zz_174[23] = execute_SRC1[8];
    _zz_174[24] = execute_SRC1[7];
    _zz_174[25] = execute_SRC1[6];
    _zz_174[26] = execute_SRC1[5];
    _zz_174[27] = execute_SRC1[4];
    _zz_174[28] = execute_SRC1[3];
    _zz_174[29] = execute_SRC1[2];
    _zz_174[30] = execute_SRC1[1];
    _zz_174[31] = execute_SRC1[0];
  end

  assign execute_FullBarrielShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_binary_sequancial_SLL_1) ? _zz_174 : execute_SRC1);
  assign _zz_21 = _zz_268;
  always @ (*) begin
    _zz_175[0] = memory_SHIFT_RIGHT[31];
    _zz_175[1] = memory_SHIFT_RIGHT[30];
    _zz_175[2] = memory_SHIFT_RIGHT[29];
    _zz_175[3] = memory_SHIFT_RIGHT[28];
    _zz_175[4] = memory_SHIFT_RIGHT[27];
    _zz_175[5] = memory_SHIFT_RIGHT[26];
    _zz_175[6] = memory_SHIFT_RIGHT[25];
    _zz_175[7] = memory_SHIFT_RIGHT[24];
    _zz_175[8] = memory_SHIFT_RIGHT[23];
    _zz_175[9] = memory_SHIFT_RIGHT[22];
    _zz_175[10] = memory_SHIFT_RIGHT[21];
    _zz_175[11] = memory_SHIFT_RIGHT[20];
    _zz_175[12] = memory_SHIFT_RIGHT[19];
    _zz_175[13] = memory_SHIFT_RIGHT[18];
    _zz_175[14] = memory_SHIFT_RIGHT[17];
    _zz_175[15] = memory_SHIFT_RIGHT[16];
    _zz_175[16] = memory_SHIFT_RIGHT[15];
    _zz_175[17] = memory_SHIFT_RIGHT[14];
    _zz_175[18] = memory_SHIFT_RIGHT[13];
    _zz_175[19] = memory_SHIFT_RIGHT[12];
    _zz_175[20] = memory_SHIFT_RIGHT[11];
    _zz_175[21] = memory_SHIFT_RIGHT[10];
    _zz_175[22] = memory_SHIFT_RIGHT[9];
    _zz_175[23] = memory_SHIFT_RIGHT[8];
    _zz_175[24] = memory_SHIFT_RIGHT[7];
    _zz_175[25] = memory_SHIFT_RIGHT[6];
    _zz_175[26] = memory_SHIFT_RIGHT[5];
    _zz_175[27] = memory_SHIFT_RIGHT[4];
    _zz_175[28] = memory_SHIFT_RIGHT[3];
    _zz_175[29] = memory_SHIFT_RIGHT[2];
    _zz_175[30] = memory_SHIFT_RIGHT[1];
    _zz_175[31] = memory_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_176 = 1'b0;
    _zz_177 = 1'b0;
    if(_zz_178)begin
      if((_zz_179 == decode_INSTRUCTION[19 : 15]))begin
        _zz_176 = 1'b1;
      end
      if((_zz_179 == decode_INSTRUCTION[24 : 20]))begin
        _zz_177 = 1'b1;
      end
    end
    if((writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID))begin
      if((1'b1 || (! 1'b1)))begin
        if((writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]))begin
          _zz_176 = 1'b1;
        end
        if((writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]))begin
          _zz_177 = 1'b1;
        end
      end
    end
    if((memory_arbitration_isValid && memory_REGFILE_WRITE_VALID))begin
      if((1'b1 || (! memory_BYPASSABLE_MEMORY_STAGE)))begin
        if((memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]))begin
          _zz_176 = 1'b1;
        end
        if((memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]))begin
          _zz_177 = 1'b1;
        end
      end
    end
    if((execute_arbitration_isValid && execute_REGFILE_WRITE_VALID))begin
      if((1'b1 || (! execute_BYPASSABLE_EXECUTE_STAGE)))begin
        if((execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]))begin
          _zz_176 = 1'b1;
        end
        if((execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]))begin
          _zz_177 = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_176 = 1'b0;
    end
    if((! decode_RS2_USE))begin
      _zz_177 = 1'b0;
    end
  end

  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_180 = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_180 == (3'b000))) begin
        _zz_181 = execute_BranchPlugin_eq;
    end else if((_zz_180 == (3'b001))) begin
        _zz_181 = (! execute_BranchPlugin_eq);
    end else if((((_zz_180 & (3'b101)) == (3'b101)))) begin
        _zz_181 = (! execute_SRC_LESS);
    end else begin
        _zz_181 = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_binary_sequancial_INC : begin
        _zz_182 = 1'b0;
      end
      `BranchCtrlEnum_binary_sequancial_JAL : begin
        _zz_182 = 1'b1;
      end
      `BranchCtrlEnum_binary_sequancial_JALR : begin
        _zz_182 = 1'b1;
      end
      default : begin
        _zz_182 = _zz_181;
      end
    endcase
  end

  assign _zz_18 = _zz_182;
  assign execute_BranchPlugin_branch_src1 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_binary_sequancial_JALR) ? execute_RS1 : execute_PC);
  assign _zz_183 = _zz_270[19];
  always @ (*) begin
    _zz_184[10] = _zz_183;
    _zz_184[9] = _zz_183;
    _zz_184[8] = _zz_183;
    _zz_184[7] = _zz_183;
    _zz_184[6] = _zz_183;
    _zz_184[5] = _zz_183;
    _zz_184[4] = _zz_183;
    _zz_184[3] = _zz_183;
    _zz_184[2] = _zz_183;
    _zz_184[1] = _zz_183;
    _zz_184[0] = _zz_183;
  end

  assign _zz_185 = _zz_271[11];
  always @ (*) begin
    _zz_186[19] = _zz_185;
    _zz_186[18] = _zz_185;
    _zz_186[17] = _zz_185;
    _zz_186[16] = _zz_185;
    _zz_186[15] = _zz_185;
    _zz_186[14] = _zz_185;
    _zz_186[13] = _zz_185;
    _zz_186[12] = _zz_185;
    _zz_186[11] = _zz_185;
    _zz_186[10] = _zz_185;
    _zz_186[9] = _zz_185;
    _zz_186[8] = _zz_185;
    _zz_186[7] = _zz_185;
    _zz_186[6] = _zz_185;
    _zz_186[5] = _zz_185;
    _zz_186[4] = _zz_185;
    _zz_186[3] = _zz_185;
    _zz_186[2] = _zz_185;
    _zz_186[1] = _zz_185;
    _zz_186[0] = _zz_185;
  end

  assign _zz_187 = _zz_272[11];
  always @ (*) begin
    _zz_188[18] = _zz_187;
    _zz_188[17] = _zz_187;
    _zz_188[16] = _zz_187;
    _zz_188[15] = _zz_187;
    _zz_188[14] = _zz_187;
    _zz_188[13] = _zz_187;
    _zz_188[12] = _zz_187;
    _zz_188[11] = _zz_187;
    _zz_188[10] = _zz_187;
    _zz_188[9] = _zz_187;
    _zz_188[8] = _zz_187;
    _zz_188[7] = _zz_187;
    _zz_188[6] = _zz_187;
    _zz_188[5] = _zz_187;
    _zz_188[4] = _zz_187;
    _zz_188[3] = _zz_187;
    _zz_188[2] = _zz_187;
    _zz_188[1] = _zz_187;
    _zz_188[0] = _zz_187;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_binary_sequancial_JAL : begin
        _zz_189 = {{_zz_184,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
      end
      `BranchCtrlEnum_binary_sequancial_JALR : begin
        _zz_189 = {_zz_186,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        _zz_189 = {{_zz_188,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
      end
    endcase
  end

  assign execute_BranchPlugin_branch_src2 = _zz_189;
  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign _zz_16 = {execute_BranchPlugin_branchAdder[31 : 1],((execute_BRANCH_CTRL == `BranchCtrlEnum_binary_sequancial_JALR) ? 1'b0 : execute_BranchPlugin_branchAdder[0])};
  assign _zz_15 = (execute_PC + _zz_274);
  assign memory_BranchPlugin_predictionMissmatch = ((((memory_PREDICTION_CONTEXT_hit && (! memory_PREDICTION_CONTEXT_hazard)) && memory_PREDICTION_CONTEXT_line_branchWish[1]) != memory_BRANCH_DO) || (memory_BRANCH_DO && (memory_PREDICTION_CONTEXT_line_target != memory_BRANCH_CALC)));
  assign _zz_87 = (((! memory_IS_RVC) && memory_PC[1]) ? memory_NEXT_PC2 : memory_PC);
  assign _zz_89 = (memory_arbitration_isFiring && memory_BranchPlugin_predictionMissmatch);
  assign _zz_90 = (memory_BRANCH_DO ? memory_BRANCH_CALC : memory_NEXT_PC2);
  assign _zz_28 = _zz_39;
  assign _zz_14 = decode_BRANCH_CTRL;
  assign _zz_12 = _zz_46;
  assign _zz_17 = decode_to_execute_BRANCH_CTRL;
  assign _zz_31 = _zz_49;
  assign _zz_11 = decode_ALU_CTRL;
  assign _zz_9 = _zz_41;
  assign _zz_33 = decode_to_execute_ALU_CTRL;
  assign _zz_8 = decode_SHIFT_CTRL;
  assign _zz_5 = execute_SHIFT_CTRL;
  assign _zz_6 = _zz_52;
  assign _zz_22 = decode_to_execute_SHIFT_CTRL;
  assign _zz_20 = execute_to_memory_SHIFT_CTRL;
  assign _zz_3 = decode_ALU_BITWISE_CTRL;
  assign _zz_1 = _zz_44;
  assign _zz_35 = decode_to_execute_ALU_BITWISE_CTRL;
  assign decode_arbitration_isFlushed = (((decode_arbitration_flushAll || execute_arbitration_flushAll) || memory_arbitration_flushAll) || writeBack_arbitration_flushAll);
  assign execute_arbitration_isFlushed = ((execute_arbitration_flushAll || memory_arbitration_flushAll) || writeBack_arbitration_flushAll);
  assign memory_arbitration_isFlushed = (memory_arbitration_flushAll || writeBack_arbitration_flushAll);
  assign writeBack_arbitration_isFlushed = writeBack_arbitration_flushAll;
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_haltItself) || memory_arbitration_haltItself) || writeBack_arbitration_haltItself));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_haltItself) || writeBack_arbitration_haltItself));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_haltItself));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  always @ (posedge clk) begin
    if(reset) begin
      writeBack_FormalPlugin_order <= (64'b0000000000000000000000000000000000000000000000000000000000000000);
      _zz_92 <= _zz_91;
      _zz_93 <= _zz_91;
      _zz_94 <= _zz_91;
      _zz_95 <= _zz_91;
      _zz_96 <= _zz_91;
      writeBack_FormalPlugin_haltFired <= 1'b0;
      IBusSimplePlugin_fetchPc_pcReg <= (32'b00000000000000000000000000000000);
      IBusSimplePlugin_fetchPc_inc <= 1'b0;
      _zz_98 <= 1'b0;
      IBusSimplePlugin_decodePc_pcReg <= (32'b00000000000000000000000000000000);
      _zz_100 <= 1'b0;
      IBusSimplePlugin_decompressor_bufferValid <= 1'b0;
      _zz_129 <= 1'b0;
      IBusSimplePlugin_pendingCmd <= (3'b000);
      IBusSimplePlugin_rsp_discardCounter <= (3'b000);
      _zz_166 <= 1'b1;
      _zz_178 <= 1'b0;
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      memory_to_writeBack_REGFILE_WRITE_DATA <= (32'b00000000000000000000000000000000);
      memory_to_writeBack_INSTRUCTION <= (32'b00000000000000000000000000000000);
    end else begin
      if(writeBack_arbitration_isFiring)begin
        writeBack_FormalPlugin_order <= (writeBack_FormalPlugin_order + (64'b0000000000000000000000000000000000000000000000000000000000000001));
      end
      _zz_92 <= writeBack_FormalPlugin_haltRequest;
      _zz_93 <= _zz_92;
      _zz_94 <= _zz_93;
      _zz_95 <= _zz_94;
      _zz_96 <= _zz_95;
      if((_zz_194 && _zz_195))begin
        writeBack_FormalPlugin_haltFired <= 1'b1;
      end
      if(IBusSimplePlugin_fetchPc_predictionPcLoad_valid)begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if(IBusSimplePlugin_jump_pcLoad_valid)begin
        IBusSimplePlugin_fetchPc_inc <= 1'b0;
      end
      if(_zz_207)begin
        IBusSimplePlugin_fetchPc_inc <= 1'b1;
      end
      if(IBusSimplePlugin_fetchPc_samplePcNext)begin
        IBusSimplePlugin_fetchPc_pcReg <= IBusSimplePlugin_fetchPc_pc;
      end
      if((IBusSimplePlugin_fetchPc_preOutput_valid && IBusSimplePlugin_fetchPc_preOutput_ready))begin
        IBusSimplePlugin_fetchPc_pcReg[1 : 0] <= (2'b00);
        if(IBusSimplePlugin_fetchPc_pc[1])begin
          IBusSimplePlugin_fetchPc_inc <= 1'b1;
        end
      end
      _zz_98 <= 1'b1;
      if((decode_arbitration_isFiring && (! IBusSimplePlugin_decodePc_injectedDecode)))begin
        IBusSimplePlugin_decodePc_pcReg <= IBusSimplePlugin_decodePc_pcPlus;
      end
      if(IBusSimplePlugin_decodePc_predictionPcLoad_valid)begin
        IBusSimplePlugin_decodePc_pcReg <= IBusSimplePlugin_decodePc_predictionPcLoad_payload;
      end
      if(IBusSimplePlugin_jump_pcLoad_valid)begin
        IBusSimplePlugin_decodePc_pcReg <= IBusSimplePlugin_jump_pcLoad_payload;
      end
      if(IBusSimplePlugin_killLastStage)begin
        _zz_100 <= 1'b0;
      end
      if(IBusSimplePlugin_iBusRsp_input_ready)begin
        _zz_100 <= IBusSimplePlugin_iBusRsp_input_valid;
      end
      if((IBusSimplePlugin_decompressor_output_valid && IBusSimplePlugin_decompressor_output_ready))begin
        IBusSimplePlugin_decompressor_bufferValid <= 1'b0;
      end
      if(_zz_209)begin
        IBusSimplePlugin_decompressor_bufferValid <= ((! (((! IBusSimplePlugin_decompressor_isRvc) && (! IBusSimplePlugin_iBusRsp_output_payload_pc[1])) && (! IBusSimplePlugin_decompressor_bufferValid))) && (! ((IBusSimplePlugin_decompressor_isRvc && IBusSimplePlugin_iBusRsp_output_payload_pc[1]) && IBusSimplePlugin_decompressor_output_ready)));
      end
      if(IBusSimplePlugin_killLastStage)begin
        IBusSimplePlugin_decompressor_bufferValid <= 1'b0;
      end
      if(IBusSimplePlugin_decompressor_output_ready)begin
        _zz_129 <= IBusSimplePlugin_decompressor_output_valid;
      end
      if(IBusSimplePlugin_killLastStage)begin
        _zz_129 <= 1'b0;
      end
      if(_zz_208)begin
        IBusSimplePlugin_decompressor_bufferValid <= 1'b0;
      end
      IBusSimplePlugin_pendingCmd <= IBusSimplePlugin_pendingCmdNext;
      IBusSimplePlugin_rsp_discardCounter <= (IBusSimplePlugin_rsp_discardCounter - _zz_244);
      if(IBusSimplePlugin_killLastStage)begin
        IBusSimplePlugin_rsp_discardCounter <= (IBusSimplePlugin_pendingCmd - _zz_246);
      end
      _zz_166 <= 1'b0;
      _zz_178 <= (_zz_83 && writeBack_arbitration_isFiring);
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_19;
      end
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
    end
  end

  always @ (posedge clk) begin
    if(IBusSimplePlugin_iBusRsp_input_ready)begin
      _zz_101 <= IBusSimplePlugin_iBusRsp_input_payload;
    end
    if(_zz_209)begin
      IBusSimplePlugin_decompressor_bufferData <= IBusSimplePlugin_iBusRsp_output_payload_rsp_inst[31 : 16];
    end
    if(IBusSimplePlugin_decompressor_output_ready)begin
      _zz_130 <= IBusSimplePlugin_decompressor_output_payload_pc;
      _zz_131 <= IBusSimplePlugin_decompressor_output_payload_rsp_error;
      _zz_132 <= IBusSimplePlugin_decompressor_output_payload_rsp_inst;
      _zz_133 <= IBusSimplePlugin_decompressor_output_payload_isRvc;
    end
    if(IBusSimplePlugin_injector_decodeInput_ready)begin
      IBusSimplePlugin_injector_formal_rawInDecode <= IBusSimplePlugin_decompressor_raw;
    end
    if(IBusSimplePlugin_iBusRsp_inputPipeline_0_ready)begin
      IBusSimplePlugin_predictor_historyWriteLast_valid <= IBusSimplePlugin_predictor_historyWrite_valid;
      IBusSimplePlugin_predictor_historyWriteLast_payload_address <= IBusSimplePlugin_predictor_historyWrite_payload_address;
      IBusSimplePlugin_predictor_historyWriteLast_payload_data_source <= IBusSimplePlugin_predictor_historyWrite_payload_data_source;
      IBusSimplePlugin_predictor_historyWriteLast_payload_data_branchWish <= IBusSimplePlugin_predictor_historyWrite_payload_data_branchWish;
      IBusSimplePlugin_predictor_historyWriteLast_payload_data_target <= IBusSimplePlugin_predictor_historyWrite_payload_data_target;
      IBusSimplePlugin_predictor_historyWriteLast_payload_data_unaligned <= IBusSimplePlugin_predictor_historyWrite_payload_data_unaligned;
    end
    if(IBusSimplePlugin_injector_decodeInput_ready)begin
      _zz_137 <= IBusSimplePlugin_predictor_decompressorContext_hazard;
      _zz_138 <= IBusSimplePlugin_predictor_decompressorContext_hit;
      _zz_139 <= IBusSimplePlugin_predictor_decompressorContext_line_source;
      _zz_140 <= IBusSimplePlugin_predictor_decompressorContext_line_branchWish;
      _zz_141 <= IBusSimplePlugin_predictor_decompressorContext_line_target;
      _zz_142 <= IBusSimplePlugin_predictor_decompressorContext_line_unaligned;
    end
    if (!(! (((dBus_rsp_ready && memory_MEMORY_ENABLE) && memory_arbitration_isValid) && memory_arbitration_isStuck))) begin
      $display("ERROR DBusSimplePlugin doesn't allow memory stage stall when read happend");
    end
    if (!(! (((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE) && (! writeBack_INSTRUCTION[5])) && writeBack_arbitration_isStuck))) begin
      $display("ERROR DBusSimplePlugin doesn't allow writeback stage stall when read happend");
    end
    _zz_179 <= _zz_85[11 : 7];
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= decode_FORMAL_PC_NEXT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= execute_FORMAL_PC_NEXT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= _zz_69;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ALIGNEMENT_FAULT <= execute_ALIGNEMENT_FAULT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_DO <= execute_BRANCH_DO;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BRANCH_CALC <= execute_BRANCH_CALC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_MEM_WMASK <= execute_FORMAL_MEM_WMASK;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_MEM_WMASK <= memory_FORMAL_MEM_WMASK;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_MEM_WDATA <= execute_FORMAL_MEM_WDATA;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_MEM_WDATA <= memory_FORMAL_MEM_WDATA;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2_USE <= decode_RS2_USE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_RS2_USE <= execute_RS2_USE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_RS2_USE <= memory_RS2_USE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_NEXT_PC2 <= execute_NEXT_PC2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1_USE <= decode_RS1_USE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_RS1_USE <= execute_RS1_USE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_RS1_USE <= memory_RS1_USE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_READ_DATA <= memory_MEMORY_READ_DATA;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_CONTEXT_hazard <= decode_PREDICTION_CONTEXT_hazard;
      decode_to_execute_PREDICTION_CONTEXT_hit <= decode_PREDICTION_CONTEXT_hit;
      decode_to_execute_PREDICTION_CONTEXT_line_source <= decode_PREDICTION_CONTEXT_line_source;
      decode_to_execute_PREDICTION_CONTEXT_line_branchWish <= decode_PREDICTION_CONTEXT_line_branchWish;
      decode_to_execute_PREDICTION_CONTEXT_line_target <= decode_PREDICTION_CONTEXT_line_target;
      decode_to_execute_PREDICTION_CONTEXT_line_unaligned <= decode_PREDICTION_CONTEXT_line_unaligned;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PREDICTION_CONTEXT_hazard <= execute_PREDICTION_CONTEXT_hazard;
      execute_to_memory_PREDICTION_CONTEXT_hit <= execute_PREDICTION_CONTEXT_hit;
      execute_to_memory_PREDICTION_CONTEXT_line_source <= execute_PREDICTION_CONTEXT_line_source;
      execute_to_memory_PREDICTION_CONTEXT_line_branchWish <= execute_PREDICTION_CONTEXT_line_branchWish;
      execute_to_memory_PREDICTION_CONTEXT_line_target <= execute_PREDICTION_CONTEXT_line_target;
      execute_to_memory_PREDICTION_CONTEXT_line_unaligned <= execute_PREDICTION_CONTEXT_line_unaligned;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= _zz_27;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_RS2 <= execute_RS2;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_RS2 <= memory_RS2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RVC <= decode_IS_RVC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_RVC <= execute_IS_RVC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_MEM_RMASK <= execute_FORMAL_MEM_RMASK;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_MEM_RMASK <= memory_FORMAL_MEM_RMASK;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_13;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2 <= decode_SRC2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= _zz_30;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_RS1 <= execute_RS1;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_RS1 <= memory_RS1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_10;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_MEM_ADDR <= execute_FORMAL_MEM_ADDR;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_MEM_ADDR <= memory_FORMAL_MEM_ADDR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1 <= decode_SRC1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_INSTRUCTION <= decode_FORMAL_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_INSTRUCTION <= execute_FORMAL_INSTRUCTION;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_INSTRUCTION <= memory_FORMAL_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_RIGHT <= execute_SHIFT_RIGHT;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= execute_REGFILE_WRITE_DATA;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_7;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_SHIFT_CTRL <= _zz_4;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= _zz_26;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= execute_PC;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_HALT <= _zz_81;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_HALT <= _zz_80;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_HALT <= _zz_79;
    end
    if((((! IBusSimplePlugin_iBusRsp_output_ready) && (IBusSimplePlugin_decompressor_output_valid && IBusSimplePlugin_decompressor_output_ready)) && (! IBusSimplePlugin_killLastStage)))begin
      _zz_101[1] <= 1'b1;
    end
  end

endmodule


