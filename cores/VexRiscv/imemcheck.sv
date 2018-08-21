`define RISCV_FORMAL
`define RISCV_FORMAL_NRET 1
`define RISCV_FORMAL_XLEN 32
`define RISCV_FORMAL_ILEN 32
`include "rvfi_macros.vh"
`include "rvfi_channel.sv"
`include "rvfi_imem_check.sv"

module testbench (
	input clk
);
	reg reset = 1;

	always @(posedge clk)
		reset <= 0;




	(* keep *) wire        iBus_cmd_valid;
	(* keep *) wire [31:0] iBus_cmd_payload_pc;
	(* keep *) wire iBus_cmd_ready;
	(* keep *) `rvformal_rand_reg iBus_cmd_ready_rand;
	(* keep *) wire iBus_rsp_valid;
	(* keep *) `rvformal_rand_reg iBus_rsp_valid_rand;
	(* keep *) reg [31:0] iBus_rsp_payload_inst;
	(* keep *) `rvformal_rand_reg [31:0] iBus_rsp_payload_inst_rand;


	(* keep *) wire  dBus_cmd_valid;
	(* keep *) wire  dBus_cmd_payload_wr;
	(* keep *) wire [31:0] dBus_cmd_payload_address;
	(* keep *) wire [31:0] dBus_cmd_payload_data;
	(* keep *) wire [1:0] dBus_cmd_payload_size;
	(* keep *) `rvformal_rand_reg dBus_cmd_ready;
	(* keep *) `rvformal_rand_reg    dBus_rsp_ready;
	(* keep *) `rvformal_rand_reg   [31:0] dBus_rsp_data;



	`RVFI_WIRES

	(* keep *) wire [31:0] imem_addr;
	(* keep *) wire [15:0] imem_data;

	rvfi_imem_check checker_inst (
		.clock     (clk      ),
		.reset     (reset  ),
		.enable    (1'b1     ),
		.imem_addr (imem_addr),
		.imem_data (imem_data),
		`RVFI_CONN
	);


       (* keep *) reg [2:0] iBusCmdPtr = 0;
       (* keep *) reg [2:0] iBusRspPtr = 0;
       (* keep *) reg [31:0]iBusRspAddr[8];



	assign iBus_cmd_ready = iBus_cmd_ready_rand && ((iBusCmdPtr + 1) & 7 != iBusRspPtr);
	assign iBus_rsp_valid = iBus_rsp_valid_rand && (iBusCmdPtr != iBusRspPtr);

	always @(*) begin
		iBus_rsp_payload_inst <= iBus_rsp_payload_inst_rand;
		if(iBus_rsp_valid) begin
			if (iBusRspAddr[iBusRspPtr] == imem_addr)
				assume(iBus_rsp_payload_inst[15:0] == imem_data);
			if (iBusRspAddr[iBusRspPtr] + 2 == imem_addr)
				assume(iBus_rsp_payload_inst[31:16] == imem_data);
		end
	end	

	always @(posedge clk) begin
		if (reset) begin
			iBusCmdPtr <= 0;
			iBusRspPtr <= 0;
			iBusRspAddr[0] <= 0;
			iBusRspAddr[1] <= 0;
			iBusRspAddr[2] <= 0;
			iBusRspAddr[3] <= 0;
			iBusRspAddr[4] <= 0;
			iBusRspAddr[5] <= 0;
			iBusRspAddr[6] <= 0;
			iBusRspAddr[7] <= 0;
		end else begin
			if(iBus_rsp_valid) begin
				iBusRspPtr <= iBusRspPtr + 1;
			end
			if(iBus_cmd_valid && iBus_cmd_ready) begin
				iBusRspAddr[iBusCmdPtr] <= iBus_cmd_payload_pc;
				iBusCmdPtr <= iBusCmdPtr + 1;
			end
		end
		
	end





	VexRiscv uut (
		.clk       (clk    ),
		.reset    (reset   ),

		.iBus_cmd_valid (iBus_cmd_valid),
		.iBus_cmd_ready (iBus_cmd_ready),
		.iBus_cmd_payload_pc  (iBus_cmd_payload_pc ),
		.iBus_rsp_valid(iBus_rsp_valid),
		.iBus_rsp_payload_inst (iBus_rsp_payload_inst),
		.iBus_rsp_payload_error(1'b0),

		.dBus_cmd_valid(dBus_cmd_valid),
		.dBus_cmd_payload_wr(dBus_cmd_payload_wr),
		.dBus_cmd_payload_address(dBus_cmd_payload_address),
		.dBus_cmd_payload_data(dBus_cmd_payload_data),
		.dBus_cmd_payload_size(dBus_cmd_payload_size),
		.dBus_cmd_ready(dBus_cmd_ready),
		.dBus_rsp_ready(dBus_rsp_ready),
		.dBus_rsp_data(dBus_rsp_data),
		.dBus_rsp_error(1'b0),

		`RVFI_CONN
	);

endmodule

