
`timescale 1ns / 1ps

module cpu_aes

   #(
	parameter AWIDTH_DBP=10,
	parameter DWIDTH_DBP=34
)(
    input clk,
	input reset,
	
	output [31:0] add1  ,
	input  [31:0] rdata1,
	output [ 3:0] wen1  ,
	output [31:0] wdata1,
	output [31:0] add2  ,
	input  [31:0] rdata2,
	output [ 3:0] wen2  ,
	output [31:0] wdata2,
	
	output [AWIDTH_DBP-1:0] dbp_add1  ,
	input  [DWIDTH_DBP-1:0] dbp_rdata1,
	output [AWIDTH_DBP-1:0] dbp_add2  ,
	input  [DWIDTH_DBP-1:0] dbp_rdata2,
	output                  dbp_wen2  ,
	output [DWIDTH_DBP-1:0] dbp_wdata2,
	
    output reg [127:0] cipher,
    output Dvld	,
	input wait_en
    );
    
	 
	wire seldummy1,seldummy2,seldummy3;
	wire [3:0] wen_D   ; 
	reg en_aes; 
	wire selout;       
	 wire [127:0] Din_wire;                                                        /////////////////////////////////
	 reg [127:0] Din;
	 wire [127:0] Kin; 
	 
	 wire [127:0] Dout;
	
	reg Krdy,Drdy,en_rdy;
	
	
	wire [31:0] din1_aes;
	wire [31:0]din2_aes;
	wire [3:0]control_aes;
	wire [31:0] dout_aes;
	wire [7:0] fn_aes;
	wire [31:0] din1_aesmul;
	assign wen_D    = (add2 == 32'h000001f0) ? 0    : wen2 ;
	AES_12clk_design1 aes (Kin, Din, Dout, Krdy, Drdy, Kvld, Dvld,en_aes, BSY,clk,~reset,selout,din1_aes,din2_aes,control_aes,dout_aes,fn_aes, din1_aesmul);
   
   
	
	always@(posedge clk or posedge reset)                          //////////////////////////////////////////
	begin
	if(reset) en_aes <=0;
	else if ((add2 == 32'h00000030)&&(wen_D!=4'b0000))begin

	en_aes <=1;   end
	else 
	begin 
	if (Dvld==1)
	en_aes <=0;
	  end 
	end
	
	 
	  
	 assign Din_wire[127:96] = ((add2 == 32'h00000030) ? wdata2 : Din[127:96]) ;            /////////////////////////////
	 assign Din_wire[95:64] = ((add2 == 32'h00000034) ?wdata2 : Din[95:64]) ;          ////////////////////////////////
    assign Din_wire[63:32] = ((add2 == 32'h00000038) ? wdata2 : Din[63:32]) ;         ////////////////////////////////
     assign Din_wire[31:0] = ((add2 == 32'h0000003c) ? wdata2 : Din[31:0]) ;      	 /////////////////////////////
	     //////////////////////////////////////////////
	


	assign Kin = 128'h0123456789abcdef123456789abcdef0; 

      
	
	 always@(posedge clk)
	 begin
	 if (reset)
	 Din  <= 128'h0;
	 else
	 Din <= Din_wire;
	 end
	 
	 
	 
	 //always@(*)
	 //begin
	//	if(Dvld)
	 //cipher = Dout;
	 //end
	 
	 
	 
	 
	
	
	
	
	
	always@ (posedge clk)
	begin
	if((add2 == 32'h00000038)&&(wen_D!=4'b0000))
	begin   en_rdy<=1;    end
	else
	begin   en_rdy<=0;  end
	end
	always@ (posedge clk)
	begin
	if(en_rdy)
	begin   Krdy<=1;  Drdy<=1;  end
	else
	begin   Krdy<=0;  Drdy<=0;  end
	end
	
	
	//and a1(seldummy1,1'b1,selout);
	
	//and a2(seldummy2,1'b1,seldummy1);
	
	//and a3(seldummy3,1'b1,seldummy2);
	
	and a1(seldummy1,en_aes,selout); ///kotha ga idhi pettam vachindhi.. we felt en_aes and dvld one vuntay.. forthat clock cycle . and next clock cycle lo en_aes 0 avthadhi.
	
	and a2(seldummy2,en_aes,seldummy1);
	
	and a3(seldummy3,en_aes,seldummy2);
	
	always @(posedge seldummy3)
	 begin
	
		cipher <=  Dout;
		
	 end

////////////////////////////////
	

//CPU Core   
  cpu #(
	   .AWIDTH_DBP ( AWIDTH_DBP ),
	   .DWIDTH_DBP ( DWIDTH_DBP )
	) cpu_inst (
		.clk   ( clk  ),
		.reset ( reset),
		// Channel 1
		.add1   ( add1   ),
		.rdata1 ( rdata1 ),
		.wen1   ( wen1   ),
		.wdata1 ( wdata1 ),
		// Channel 2
		.add2   ( add2   ),
		.rdata2 ( rdata2 ),
		.wen2   ( wen2   ),
		.wdata2 ( wdata2 ),
		
		.dbp_add1   ( dbp_add1   ),
		.dbp_rdata1 ( dbp_rdata1 ),
		.dbp_add2   ( dbp_add2   ),
		.dbp_rdata2 ( dbp_rdata2 ),
		.dbp_wen2   ( dbp_wen2   ),
		.dbp_wdata2 ( dbp_wdata2 ),
		.wait_en( wait_en),
		.din1_aes    ( din1_aes    ),
		.din2_aes    ( din2_aes    ),
        .control_aes (control_aes  ),
		.dout_aes    ( dout_aes    ),
		.din1_aesmul ( din1_aesmul ),
		.fn_aes   ( fn_aes ),
		.Dvld     (Dvld)
	);
	
	
	
	
	endmodule
 
	
	
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////////////////////////////////////


module cpu#(
	parameter AWIDTH_DBP=10,
	parameter DWIDTH_DBP=34
)(
    input clk,
	input reset,
	
	output [31:0] add1  ,
	input  [31:0] rdata1,
	output [ 3:0] wen1  ,
	output [31:0] wdata1,
	output [31:0] add2  ,
	input  [31:0] rdata2,
	output [ 3:0] wen2  ,
	output [31:0] wdata2,
	
	output [AWIDTH_DBP-1:0] dbp_add1  ,
	input  [DWIDTH_DBP-1:0] dbp_rdata1,
	output [AWIDTH_DBP-1:0] dbp_add2  ,
	input  [DWIDTH_DBP-1:0] dbp_rdata2,
	output                  dbp_wen2  ,
	output [DWIDTH_DBP-1:0] dbp_wdata2,
	input  wait_en,
	input  [31:0] din1_aes,
	input  [31:0] din2_aes,
	input  [3:0]  control_aes,
	output [31:0] dout_aes,
	input [31:0] din1_aesmul,
	input [7:0] fn_aes,
	input Dvld
);
	
//-----------------------------------------------------------------------------------------------//
//                                       Memory Controller                                       //
//-----------------------------------------------------------------------------------------------//

	wire        inst_rready;
	wire        inst_req   ;
	wire [31:0] inst_add   ;
	wire [31:0] inst       ;
	wire        vinst      ;
	wire        mm_pause   ;
	
	wire        mem_umload2;
	wire [6:0]  mem_rd_add2;
	
	wire [2:0]  mem_ren2   ;
	wire [31:0] mem_radd2  ;
	
	wire [2:0]  mem_wen2   ;
	wire [31:0] mem_wadd2  ;
	wire [31:0] mem_wdata2 ;
	
	wire        mem_rd_en  ;
	wire [6:0]  mem_rd_add ;
	wire [31:0] mem_rd_data;
	
	
	memory_controller  inst_memory_controller (
	   .clk         ( clk         ),
	   .reset       ( reset       ),
	   .inst_rready ( inst_rready ),
	   //------------------------------------------ Channel 1
	   .ren1        ( inst_req    ),
	   .radd1       ( inst_add    ),
	   .rdata1      ( inst        ),
	   .vrdata1     ( vinst       ),
	   //------------------------------------------ Channel 2
	   .umload      ( mem_umload2 ),
	   .rd_add2     ( mem_rd_add2 ),
	   
	   .ren2        ( mem_ren2    ),
	   .radd2       ( mem_radd2   ),
	   .wen2        ( mem_wen2    ),
	   .wadd2       ( mem_wadd2   ),
	   .wdata2      ( mem_wdata2  ),
	   
	   .rd_en       ( mem_rd_en   ),
	   .rd_add      ( mem_rd_add  ),
	   .rd_data     ( mem_rd_data ),
	   //------------------------------------------ Memory I/O Signals
	   .mem_add1    ( add1   ),
	   .mem_rdata1  ( rdata1 ),
	   .mem_wen1    ( wen1   ),
	   .mem_wdata1  ( wdata1 ),
	   .mem_add2    ( add2   ),
	   .mem_rdata2  ( rdata2 ),
	   .mem_wen2    ( wen2   ),
	   .mem_wdata2  ( wdata2 ),
	   
	   .mm_pause    ( mm_pause )
	);
	
//-----------------------------------------------------------------------------------------------//
//                                        Program Counter                                        //
//-----------------------------------------------------------------------------------------------//

	wire reset_pc ;
	wire pause_pc ;
	
	wire        de_pfalse  ;
	wire [31:0] pc_pc      ;
	wire [31:0] buff_pc_pc ;
	
	wire        jal     ;
	wire [31:0] jal_add ;
	
	wire [31:0] buff_dd_pc ;
	
	wire        buff_ex_jal    ;
	wire        buff_ex_jb     ;
	wire        buff_ex_jb_en  ;
	wire [31:0] buff_ex_jb_add ;
	wire [31:0] buff_pc_dbp    ;
	
	wire        pc_update1    ;
	wire        pc_update2    ;
	wire        pc_update3    ;
	wire        pc_update4    ;
	wire [31:0] pc_update_add ;
	
	DBP #(
	   .AWIDTH ( AWIDTH_DBP ),
	   .DWIDTH ( DWIDTH_DBP )
	) inst_DBP (
	   .clk           ( clk      ),
	   .reset         ( reset    ),
	   .clear_dbp     ( reset_pc ),
	   .pause         ( pause_pc ),
	   
	   .inst_req      ( inst_req ),
	   .inst_add      ( inst_add ),
	   
	   .de_pfalse     ( de_pfalse  ),
	   .pc_pc         ( pc_pc      ),
	   .buff_pc_pc    ( buff_pc_pc ),
	   
	   .jal           ( jal     ),
	   .jal_add       ( jal_add ),
	   
	   .buff_dd_pc    ( buff_dd_pc ),
	   
	   .buff_ex_jal    ( buff_ex_jal    ),
	   .buff_ex_jb     ( buff_ex_jb     ),
	   .buff_ex_jb_en  ( buff_ex_jb_en  ),
	   .buff_ex_jb_add ( buff_ex_jb_add ),
	   .buff_ex_pc     ( buff_pc_dbp    ),
	   
	   
	   .add1   ( dbp_add1   ),
	   .rdata1 ( dbp_rdata1 ),
	   .add2   ( dbp_add2   ),
	   .rdata2 ( dbp_rdata2 ),
	   .wen2   ( dbp_wen2   ),
	   .wdata2 ( dbp_wdata2 ),
	   
	   .pc_update1     ( pc_update1    ),
	   .pc_update2     ( pc_update2    ),
	   .pc_update3     ( pc_update3    ),
	   .pc_update4     ( pc_update4    ),
	   .pc_update_add  ( pc_update_add )
	);
	
	wire        pc_pinst ;
	// wire [31:0] pc_pc    ;
	wire [31:0] pc_inst  ;
	wire        pc_vout  ;
   
	prog_counter  PC (
	   .clk           ( clk      ),
	   .reset         ( reset    ),
	   .pause         ( pause_pc ),
	   
	   .pc_update1    ( pc_update1    ),
	   .pc_update2    ( pc_update2    ),
	   .pc_update3    ( pc_update3    ),
	   .pc_update4    ( pc_update4    ),
	   .pc_update_add ( pc_update_add ),
	//----------------------------------- Input signals
	   .inst_rready   ( inst_rready ),
	   .req           ( inst_req    ),
	   .inst_add      ( inst_add    ),
	   .vinst         ( vinst       ),
	   .inst          ( inst        ),
	//------------------------------------- Output signals
	   .pc_pinst      ( pc_pinst ),
	   .pc            ( pc_pc    ),
	   .inst_out      ( pc_inst  ),
	   .vinst_out     ( pc_vout  ),
	   .wait_en       ( wait_en  )
	);
	
	wire        buff_pc_pinst ;
	// wire [31:0] buff_pc_pc    ;
	wire [31:0] buff_pc_inst  ;
	wire        buff_pc_vout  ;
	
	localparam pc_WIDTH1 = 1+32+32 ;
	localparam pc_WIDTH2 = 1 ;
	
	buffer #(
	   .WIDTH1 ( pc_WIDTH1 ),
	   .WIDTH2 ( pc_WIDTH2 )
	)  buffer_pc (
	    .clk   ( clk      ),
	    .reset ( reset_pc ),
	    .pause ( pause_pc ),
	//-------------------------------------------------------------------------------
		.din1 ( {pc_pinst, pc_pc, pc_inst} ),
		.din2 ( {pc_vout} ),
	//-------------------------------------------------------------------------------
		.dout1 ( {buff_pc_pinst, buff_pc_pc, buff_pc_inst } ),
		.dout2 ( {buff_pc_vout} )
	);
	
//-----------------------------------------------------------------------------------------------//
//                            1st Stage : Instruction Decode	                                 //
//-----------------------------------------------------------------------------------------------//
	
	wire        wrd_en1   ;
	wire [6:0]  wrd_add1  ;
	wire [31:0] wrd_data1 ;
	wire        wrd_en2   ;
	wire [6:0]  wrd_add2  ;
	wire [31:0] wrd_data2 ;
	
	wire [31:0] de_rs1    ;
	wire [31:0] de_rs2    ;
	wire [31:0] de_data3  ;
	wire [ 2:0] de_r_wait ;
	wire [ 5:0] de_r_tag  ;
	wire [14:0] de_r_add  ;
	
	wire        de_branch   ;
	wire [12:0] de_control  ;
	wire [ 3:0] de_control2 ;
	wire [ 7:0] de_fn       ;
	
	wire clear_de;
	wire clear_ex;
	
	ps_decode  ID (
	   .clk         ( clk         ),
	   .reset       ( reset       ),
	   .clear_de    ( clear_de    ),
	   .clear_ex    ( clear_ex    ),
	//------------------------------------------- inputs
	   .pinst       ( buff_pc_pinst ),
	   .pc          ( buff_pc_pc    ),
	   .instruction ( buff_pc_inst  ),
	   .vinst       ( buff_pc_vout  ),
	    
	   .wrd_en1     ( wrd_en1       ),
	   .wrd_add1    ( wrd_add1[4:0] ),
	   .wrd_data1   ( wrd_data1     ),
	   .wrd_en2     ( wrd_en2       ),
	   .wrd_add2    ( wrd_add2[4:0] ),
	   .wrd_data2   ( wrd_data2     ),
	//------------------------------------------- outputs
	   .rs1         ( de_rs1    ),
	   .rs2         ( de_rs2    ),
	   .data3       ( de_data3  ),
	   .r_wait      ( de_r_wait ),
	   .r_tag       ( de_r_tag  ),
	   .r_add       ( de_r_add  ),
	   
	   .branch      ( de_branch   ),
	   .control     ( de_control  ),
	   .control2    ( de_control2 ),
	   .fn          ( de_fn       )
	);
	
	assign de_pfalse = de_control[12] ;
	
	wire [31:0] buff_de_pc       ;
	wire [31:0] buff_de_data3    ;
	wire        buff_de_branch   ;
	wire [12:0] buff_de_control  ;
	wire [ 3:0] buff_de_control2 ;
	wire [ 7:0] buff_de_fn       ;
	
	wire reset_de ;
	wire pause_de ;
	
	localparam de_WIDTH1 = 32+32 ;
	localparam de_WIDTH2 = 1+8+13+4 ;
	
	buffer #(
	   .WIDTH1 ( de_WIDTH1 ),
	   .WIDTH2 ( de_WIDTH2 )
	)  buffer_de (
	    .clk   ( clk      ),
	    .reset ( reset_de ),
	    .pause ( pause_de ),
	//-------------------------------------------------------------------------------
		.din1 ( {buff_pc_pc, de_data3 } ),
		.din2 ( {de_branch, de_fn, de_control, de_control2} ),
	//-------------------------------------------------------------------------------
		.dout1 ( {buff_de_pc, buff_de_data3 } ),
		.dout2 ( {buff_de_branch, buff_de_fn, buff_de_control, buff_de_control2 } )
	);
	
	// wire        fps_wrd_en1   ;
	// wire [6:0]  fps_wrd_add1  ;
	// wire [31:0] fps_wrd_data1 ;
	// wire        fps_wrd_en2 = 1'b0;
	// wire [6:0]  fps_wrd_add2 = 7'd0 ;
	// wire [31:0] fps_wrd_data2 ;
	
	// wire [04:0] fps_rs1_add;
	// wire [04:0] fps_rs2_add;
	// wire [04:0] fps_rd_add;
	// wire [ 4:0] fps_controller ;
	// wire [31:0] fps_rs1        ;
	// wire [31:0] fps_rs2        ;
	// wire [ 2:0] fps_r_wait     ;
	// wire [ 5:0] fps_r_tag      ;
	
	// fp_decode  inst_fp_decode (
	   // .clk            ( clk            ),
	   // .reset          ( reset          ),
	   // .clear_de       ( clear_de       ),
	   // .instruction    ( pc_inst        ),
	   
	   // .wrd_en1        ( fps_wrd_en1    ),
	   // .wrd_add1       ( fps_wrd_add1[4:0]),
	   // .wrd_data1      ( fps_wrd_data1  ),
	   // .wrd_en2        ( 1'b0           ),
	   // .wrd_add2       ( fps_wrd_add2[4:0]),
	   // .wrd_data2      ( fps_wrd_data2  ),
	   
	   // .rs1_add        ( fps_rs1_add    ),
	   // .rs2_add        ( fps_rs2_add    ),
	   // .rd_add         ( fps_rd_add     ),
	   
	   // .fps_controller ( fps_controller ),
	   // .rs1            ( fps_rs1        ),
	   // .rs2            ( fps_rs2        ),
	   // .r_wait         ( fps_r_wait     ),
	   // .r_tag          ( fps_r_tag      )
	// );
	
	// wire        buff_fps_ex_rd_en  ;
	// wire [6:0]  buff_fps_ex_rd_add ;
	// wire [31:0] buff_fps_ex_rd_data;
	
	// wire [04:0] buff_fps_rd_add;
	// wire [ 4:0] buff_fps_de_controller ;
	// wire [31:0] buff_fps_de_rs1     ;
	// wire [31:0] buff_fps_de_rs2     ;
	// wire [ 2:0] buff_fps_de_r_wait  ;
	// wire [ 1:0] buff_fps_de_rd_tag  ;
	
	// wire        buff_fps_de_pause   ;
	
	// wire clear_fps_de ;
	// wire pause_fps_de ;
	
	// fps_buff_de  inst_buff_fps_de (
	    // .clk             ( clk              ),
	    // .reset           ( reset | clear_de ),
	    // .pause           ( pause_fps_de     ),
	    // //---------------------------------------------------
		// .de_rs1_add    ( fps_rs1_add ),
		// .de_rs2_add    ( fps_rs2_add ),
		// .de_rd_add     ( fps_rd_add  ),
		
	    // .de_controller ( fps_controller  ),
	    // .de_rs1        ( fps_rs1         ),
	    // .de_rs2        ( fps_rs2         ),
	    // .de_r_wait     ( fps_r_wait      ),
	    // .de_r_tag      ( fps_r_tag       ),
		
	    // .wrd_en1         ( fps_wrd_en1    ),
	    // .wrd_add1        ( fps_wrd_add1   ),
	    // .wrd_data1       ( fps_wrd_data1  ),
	    // .wrd_en2         ( fps_wrd_en2    ),
	    // .wrd_add2        ( fps_wrd_add2   ),
	    // .wrd_data2       ( fps_wrd_data2  ),
	    // .buff_ex_rd_en   ( fps_wrd_en1    ),
	    // .buff_ex_rd_add  ( fps_wrd_add1   ),
	    // .buff_ex_rd_data ( fps_wrd_data1  ),
	    // //----------------------------------------------------
	    // .buff_rd_add     ( buff_fps_rd_add ),
		
		// .buff_rs1        ( buff_fps_de_rs1         ),
	    // .buff_rs2        ( buff_fps_de_rs2         ),
	    // .buff_r_wait     ( buff_fps_de_r_wait      ),
	    // .buff_rd_tag     ( buff_fps_de_rd_tag      ),
	    // .buff_controller ( buff_fps_de_controller  ),
		
		// .buff_de_pause   ( buff_fps_de_pause    )
	// );
	
//-----------------------------------------------------------------------------------------------//
//                                 2nd Stage : Data Distribute (DD)
//-----------------------------------------------------------------------------------------------//
	
	wire        ex_rd_en  ;
	wire [6:0]  ex_rd_add ;
	wire [31:0] ex_rd_data;
	wire        buff_ex_rd_en  ;
	wire [6:0]  buff_ex_rd_add ;
	wire [31:0] buff_ex_rd_data;
	
	wire [31:0] dd_rs1    ;
	wire [31:0] dd_rs2    ;
	wire [ 1:0] dd_rd_tag ;
	wire [ 4:0] dd_rd_add ;
	
	wire dd_pause ;
	
	data_distribute  inst_dd (
	    .clk        ( clk      ),
	    .reset      ( reset_de ),
	    .pause      ( pause_de ),
    //----------------------------------------- inputs
	    .de_rs1     ( de_rs1    ),
	    .de_rs2     ( de_rs2    ),
	    .de_r_wait  ( de_r_wait ),
	    .de_r_tag   ( de_r_tag  ),
	    .de_r_add   ( de_r_add  ),
		
	    .wrd_en1     ( wrd_en1     ),
	    .wrd_add1    ( wrd_add1    ),
	    .wrd_data1   ( wrd_data1   ),
	    .wrd_en2     ( wrd_en2     ),
	    .wrd_add2    ( wrd_add2    ),
	    .wrd_data2   ( wrd_data2   ),
	    .ex_rd_en    ( ex_rd_en    ),
	    .ex_rd_add   ( ex_rd_add   ),
	    .ex_rd_data  ( ex_rd_data  ),
		.mem_rd_en   ( mem_rd_en   ),
	    .mem_rd_add  ( mem_rd_add  ),
	    .mem_rd_data ( mem_rd_data ),
	    .buff_ex_rd_en   ( buff_ex_rd_en   ),
	    .buff_ex_rd_add  ( buff_ex_rd_add  ),
	    .buff_ex_rd_data ( buff_ex_rd_data ),
    //---------------------------------------------- outputs
	    .dd_rs1     ( dd_rs1    ),
	    .dd_rs2     ( dd_rs2    ),
	    .dd_rd_tag  ( dd_rd_tag ),
	    .dd_rd_add  ( dd_rd_add ),
		
		.dd_pause   ( dd_pause )
	);
	
	
	// wire [31:0] buff_dd_pc      ;
	wire [31:0] buff_dd_rs1     ;
	wire [31:0] buff_dd_rs2     ;
	wire [31:0] buff_dd_data3   ;
	wire [ 1:0] buff_dd_rd_tag  ;
	wire [ 4:0] buff_dd_rd_add  ;
	wire        buff_dd_branch  ;
	wire [12:0] buff_dd_control ;
	wire [ 3:0] buff_dd_control2;
	wire [ 7:0] buff_dd_fn      ;
	
	wire reset_dd ;
	wire pause_dd ;
	
	localparam dd_WIDTH1 = 32+32+32+32+2+5+4 ;
	localparam dd_WIDTH2 = 1+8+13 ;
	
	buffer #(
	   .WIDTH1 ( dd_WIDTH1 ),
	   .WIDTH2 ( dd_WIDTH2 )
	)  buffer_dd (
	   .clk   ( clk      ),
	   .reset ( reset_dd ),
	   .pause ( pause_dd ),
	   
	   .din1  ( {buff_de_pc, dd_rs1, dd_rs2, buff_de_data3, dd_rd_tag, dd_rd_add, buff_de_control2} ),
	   .din2  ( {buff_de_branch, buff_de_fn, buff_de_control} ),
	   
	   .dout1 ( {buff_dd_pc, buff_dd_rs1, buff_dd_rs2, buff_dd_data3, buff_dd_rd_tag, buff_dd_rd_add, buff_dd_control2} ),
	   .dout2 ( {buff_dd_branch, buff_dd_fn, buff_dd_control} )
	);
	
//-----------------------------------------------------------------------------------------------//
//                                 3rd Stage : Instruction Execute                               //
//-----------------------------------------------------------------------------------------------//

	wire        ex_branch      ;
	wire        ex_jalr        ;
	wire [31:0] ex_jalr_add    ;
	
	wire [2:0]  ex_mem_ren    ;
	wire [31:0] ex_mem_radd   ;
	wire [6:0]  ex_mem_rd_add ;
	wire [2:0]  ex_mem_wen    ;
	wire [31:0] ex_mem_wadd   ;
	wire [31:0] ex_mem_wdata  ;
	
	// wire        ex_rd_en      ;
	// wire [6:0]  ex_rd_add     ;
	// wire [31:0] ex_rd_data    ;
	
	wire        md_rd_en      ;
	wire [6:0]  md_rd_add     ;
	wire [31:0] md_rd_data    ;
	
	wire        fps_ex_rd_en   ;
	wire [6:0]  fps_ex_rd_add  ;
	wire [31:0] fps_ex_rd_data ;
	
	// wire clear_ex ;
	wire pause_ex ;
	wire ex_pause ;
	
    ps_execute  IE (
	   .clk             ( clk             ),
	   .reset           ( reset           ),
	   .pause           ( pause_ex        ),
	   .dbp_clear_ex    ( clear_ex        ),
	   //--------------------------------------- inputs
	   .pc              ( buff_dd_pc      ),
	   .rs1             ( buff_dd_rs1     ),
	   .rs2             ( buff_dd_rs2     ),
	   .data3           ( buff_dd_data3   ),
	   .rd_tag          ( buff_dd_rd_tag  ),
	   .rd_add          ( buff_dd_rd_add  ),
	   .branch          ( buff_dd_branch  ),
	   .control         ( buff_dd_control ),
	   .control2        ( buff_dd_control2),
	   .fn              ( buff_dd_fn      ),
	   
	   // .fps_rs1        ( buff_fps_de_rs1        ),
	   // .fps_rs2        ( buff_fps_de_rs2        ),
	   // .fps_r_wait     ( buff_fps_de_r_wait     ),
	   // .fps_rd_tag     ( buff_fps_de_rd_tag     ),
	   // .fps_rd_add     ( buff_fps_rd_add        ),
	   // .fps_controller ( buff_fps_de_controller ),
	   //--------------------------------------- outputs
	   .ex_branch     ( ex_branch       ),
	   .ex_jalr       ( ex_jalr         ),
	   .ex_jalr_add   ( ex_jalr_add     ),
	   
	   .ex_mem_ren    ( ex_mem_ren      ),
	   .ex_mem_radd   ( ex_mem_radd     ),
	   .ex_mem_rd_add ( ex_mem_rd_add   ),
	   .ex_mem_wen    ( ex_mem_wen      ),
	   .ex_mem_wadd   ( ex_mem_wadd     ),
	   .ex_mem_wdata  ( ex_mem_wdata    ),
	   
	   .ex_rd_en      ( ex_rd_en        ),
	   .ex_rd_add     ( ex_rd_add       ),
	   .ex_rd_data    ( ex_rd_data      ),
	   
	   .md_rd_data    ( md_rd_data      ),
	   .md_rd_add     ( md_rd_add       ),
	   .md_rd_en      ( md_rd_en        ),
	   
	   .ex_pause      ( ex_pause        ),
	   .din1_aes    ( din1_aes    ),
		.din2_aes    ( din2_aes    ),
        .control_aes ( control_aes ),
		.dout_aes    ( dout_aes    ),
		.wait_en     ( wait_en     ),
	    .din1_aesmul ( din1_aesmul ),
		.fn_aes   ( fn_aes ),
		.Dvld     ( Dvld )
	   
	   // .fps_ex_rd_en  ( fps_ex_rd_en   ),
	   // .fps_ex_rd_add ( fps_ex_rd_add  ),
	   // .fps_ex_rd_data( fps_ex_rd_data )
	);
	
	assign mem_umload2 = buff_dd_control[9] ;
	assign mem_rd_add2 = ex_mem_rd_add      ;
	
	assign mem_ren2    = ex_mem_ren   ;
	assign mem_radd2   = ex_mem_radd  ;
	assign mem_wen2    = ex_mem_wen   ;
	assign mem_wadd2   = ex_mem_wadd  ;
	assign mem_wdata2  = ex_mem_wdata ;
	
	// For simulation only
	// assign rd_en_all  = de_rd_en_i | de_rd_en_l | de_rd_en_m ;
	// assign rd_add_all = de_rd_add;
	// assign pc_sim     = buff_de_pc    ;
	
//-----------------------------------------------------------------------------------------------//
//                                     EX buffer
//-----------------------------------------------------------------------------------------------//
	wire ex_jal    = !clear_ex & (buff_dd_control[11] | buff_dd_control[12]) ;
	wire ex_jb     = !clear_ex & (buff_dd_branch | ex_jalr) ;
	wire ex_jb_en  = !clear_ex & (ex_branch      | ex_jalr) ;
	
	wire [31:0] ex_jb_add = ex_jalr_add ;
	wire [31:0] ex_pc     = buff_dd_pc  ;
	
	wire ex_rd_en_bex = clear_ex ? 0 : ex_rd_en ;
	
	// wire        pause_ex       ;
	wire [31:0] buff_ex_pc ;
	
	// wire        buff_ex_rd_en  ;
	// wire [4:0]  buff_ex_rd_add ;
	// wire [31:0] buff_ex_rd_data;
	wire        buff_md_rd_en  ;
	wire [6:0]  buff_md_rd_add ;
	wire [31:0] buff_md_rd_data;
	
	// wire        buff_fps_ex_rd_en  ;
	// wire [6:0]  buff_fps_ex_rd_add ;
	// wire [31:0] buff_fps_ex_rd_data;
	
	localparam ex_WIDTH1 = 32+32+7+32+7+32 ;
	localparam ex_WIDTH2 = 1+1+1+1+1 ;
	
	buffer #(
	   .WIDTH1 ( ex_WIDTH1 ),
	   .WIDTH2 ( ex_WIDTH2 )
	)  buffer_ex (
	    .clk   ( clk      ),
	    .reset ( reset    ),
	    .pause ( pause_ex ),
	//-------------------------------------------------------------------------------
		.din1 ( {ex_jb_add, ex_pc, ex_rd_add, ex_rd_data, md_rd_add, md_rd_data} ),
		.din2 ( {ex_jal, ex_jb, ex_jb_en, ex_rd_en_bex, md_rd_en} ),
	//-------------------------------------------------------------------------------
		.dout1 ( {buff_ex_jb_add, buff_ex_pc, buff_ex_rd_add, buff_ex_rd_data, buff_md_rd_add, buff_md_rd_data} ),
		.dout2 ( {buff_ex_jal, buff_ex_jb, buff_ex_jb_en, buff_ex_rd_en, buff_md_rd_en} )
	);
	
//-----------------------------------------------------------------------------------------------//
//                                     4th Stage : Register Write
//-----------------------------------------------------------------------------------------------//
	wire        oc_rd_en1   ;
	wire [6:0]  oc_rd_add1  ;
	wire [31:0] oc_rd_data1 ;
	wire        oc_rd_en2   ;
	wire [6:0]  oc_rd_add2  ;
	wire [31:0] oc_rd_data2 ;
	
	wire        oc_pause    ;
	
	reg_write  RW (
	   .clk        ( clk   ),
	   .reset      ( reset ),
	//---------------------------------------------- Inputs
	   .rd_en1    ( buff_ex_rd_en   ),
	   .rd_add1   ( buff_ex_rd_add  ),
	   .rd_data1  ( buff_ex_rd_data ),
	   
	   .rd_en2    ( mem_rd_en   ),
	   .rd_add2   ( mem_rd_add  ),
	   .rd_data2  ( mem_rd_data ),
	   
	   .rd_en3    ( buff_md_rd_en   ),
	   .rd_add3   ( buff_md_rd_add  ),
	   .rd_data3  ( buff_md_rd_data ),
	   
	//---------------------------------------------- Outputs
	   .wrd_en1   ( oc_rd_en1   ),
	   .wrd_add1  ( oc_rd_add1  ),
	   .wrd_data1 ( oc_rd_data1 ),
	    
	   .wrd_en2   ( oc_rd_en2   ),
	   .wrd_add2  ( oc_rd_add2  ),
	   .wrd_data2 ( oc_rd_data2 ),
	   
	//---------------------------------------------- Pause if two reg write signals
	   .oc_pause  ( oc_pause    )
	);
	
//-----------------------------------------------------------------------------------------------//
//                                     OC buffer
//-----------------------------------------------------------------------------------------------//
	
	wire        pause_oc       ;
	wire        buff_oc_rd_en1  ;
	wire [6:0]  buff_oc_rd_add1 ;
	wire [31:0] buff_oc_rd_data1;
	wire        buff_oc_rd_en2  ;
	wire [6:0]  buff_oc_rd_add2 ;
	wire [31:0] buff_oc_rd_data2;
	
	localparam OC_WIDTH1 = 7+32+7+32 ;
	localparam OC_WIDTH2 = 1+1 ;
	
	buffer #(
	   .WIDTH1 ( OC_WIDTH1 ),
	   .WIDTH2 ( OC_WIDTH2 )
	)  buffer_oc (
	    .clk   ( clk      ),
	    .reset ( reset    ),
	    .pause ( pause_oc ),
	//-------------------------------------------------------------------------------
		.din1 ( {oc_rd_add1,oc_rd_data1,oc_rd_add2,oc_rd_data2} ),
		.din2 ( {oc_rd_en1,oc_rd_en2} ),
	//-------------------------------------------------------------------------------
		.dout1 ( {buff_oc_rd_add1,buff_oc_rd_data1,buff_oc_rd_add2,buff_oc_rd_data2} ),
		.dout2 ( {buff_oc_rd_en1,buff_oc_rd_en2} )
	);
	
//---------------------------------------------------------------------------------//
	
	assign wrd_en1   = buff_oc_rd_en1   ;
	assign wrd_add1  = buff_oc_rd_add1  ;
	assign wrd_data1 = buff_oc_rd_data1 ;
	assign wrd_en2   = buff_oc_rd_en2   ;
	assign wrd_add2  = buff_oc_rd_add2  ;
	assign wrd_data2 = buff_oc_rd_data2 ;
	
	assign clear_de = pc_update3 ;
	assign clear_ex = pc_update4 ;
	
	assign reset_pc = reset | pc_update2 | pc_update3 | pc_update4 ;
	assign reset_de = reset | pc_update3 | pc_update4 ;
	assign reset_dd = reset | pc_update4 ;
	
	assign pause_pc = oc_pause | ex_pause | dd_pause | mm_pause ;
	assign pause_de = oc_pause | ex_pause | dd_pause | mm_pause ;
	assign pause_dd = oc_pause | ex_pause | mm_pause ;
	// assign pause_pc = oc_pause | ex_pause | buff_de_pause | buff_fps_de_pause ;
	// assign pause_de = oc_pause | ex_pause | buff_de_pause | buff_fps_de_pause ;
	assign pause_ex = oc_pause | mm_pause ;
	assign pause_oc = 1'b0 ;
	
	assign buff_pc_dbp = buff_ex_pc ;
	
	// assign pause_fps_de = pause_de ;
	
	assign jal     = buff_de_control[11] ;
	assign jal_add = buff_de_data3 ;

// ---------------		Reg Status Write (Simulation Only)	-------------------- //
	
	// wire        sim_rd_en  = ( clear_ex ) ? 0 : ( buff_dd_control[10] ) ;
	// wire [6:0]  sim_rd_add = { buff_dd_rd_tag, buff_dd_rd_add } ;
	// wire [31:0] sim_pc     = buff_dd_pc ;
	
	// reg_fwrite  inst_reg_fwrite (
	   // .clk        ( clk        ),
	   // .reset      ( reset      ),
	   
	   // .rd_en      ( sim_rd_en  ),
	   // .rd_add     ( sim_rd_add ),
	   // .pc         ( sim_pc     ),
	   // .mem_ren    ( mem_ren2   ),
	   // .mem_radd   ( mem_radd2  ),
	   // .mem_wen    ( mem_wen2   ),
	   // .mem_wadd   ( mem_wadd2  ),
	   // .mem_wdata  ( mem_wdata2 ),
	   
	   // .wrd_en1    ( wrd_en1   ),
	   // .wrd_add1   ( wrd_add1  ),
	   // .wrd_data1  ( wrd_data1 ),
	   // .wrd_en2    ( wrd_en2   ),
	   // .wrd_add2   ( wrd_add2  ),
	   // .wrd_data2  ( wrd_data2 )
	// );
	
endmodule

module memory_controller(
	input clk,
	input reset,
	output inst_rready,
	
	// Channel 1
	input         ren1,
	input  [31:0] radd1,
	output [31:0] rdata1,
	output        vrdata1,
	
	input [6:0] rd_add2,
	input        umload,
	
	// Channel 2
	input [2:0]  ren2,
	input [31:0] radd2,
	input [2:0]  wen2,
	input [31:0] wadd2,
	input [31:0] wdata2,
	
	output        rd_en,
	output [6:0]  rd_add,
	output [31:0] rd_data,
	
	output  [31:0] mem_add1,
	input   [31:0] mem_rdata1,
	output   [3:0] mem_wen1,
	output  [31:0] mem_wdata1,
	output  [31:0] mem_add2,
	input   [31:0] mem_rdata2,
	output   [3:0] mem_wen2,
	output  [31:0] mem_wdata2,
	
	output mm_pause
);
	wire pause_req ;
	
	assign inst_rready = (reset) ? 1'b0 : 1'b1 ;
	
	assign mm_pause = 1'b0 ;
	
//-------------------------------------------------------------------------------------//
//                                     Channel 1
//-------------------------------------------------------------------------------------//
	
	reg reg_vrdata1; always@(posedge clk) if (reset) reg_vrdata1 <= 1'b0; else reg_vrdata1 <= ren1 ;
	
	assign rdata1  = mem_rdata1 ;
	assign vrdata1 = reg_vrdata1;
	
//-------------------------------------------------------------------------------------//
//                                     Channel 2
//-------------------------------------------------------------------------------------//
	
	wire [3:0] wire_vrdata2 = (ren2[2]==1'b1) ? 4'b1111 
	:                         (ren2[1]==1'b1 & radd2[1]==1'b0) ? 4'b0011 
	:                         (ren2[1]==1'b1 & radd2[1]==1'b1) ? 4'b1100 
	:                         (ren2[0]==1'b1 & radd2[1:0]==2'b00) ? 4'b0001 
	:                         (ren2[0]==1'b1 & radd2[1:0]==2'b01) ? 4'b0010 
	:                         (ren2[0]==1'b1 & radd2[1:0]==2'b10) ? 4'b0100 
	:                         (ren2[0]==1'b1 & radd2[1:0]==2'b11) ? 4'b1000 
	:                         4'b0000;
	
	reg        reg_ren2   ; always@(posedge clk) if (reset) reg_ren2    <= 0; else reg_ren2    <= ( ren2!=0 ) ;
	reg        reg_umload ; always@(posedge clk) if (reset) reg_umload  <= 0; else reg_umload  <= umload      ;
	reg [ 6:0] reg_rd_add2; always@(posedge clk) if (reset) reg_rd_add2 <= 0; else reg_rd_add2 <= rd_add2     ;
	reg [ 3:0] reg_vrdata2; always@(posedge clk) if (reset) reg_vrdata2 <= 0; else reg_vrdata2 <= wire_vrdata2;
    
	wire [31:0] wire_mem_rdata = mem_rdata2 ;
	
	assign rd_en   = reg_ren2;
    assign rd_add  = reg_rd_add2;
    assign rd_data = ( reg_vrdata2 == 4'b1111              ) ? wire_mem_rdata
	:                ( reg_vrdata2 == 4'b0011 & reg_umload ) ? { 16'd0,                   wire_mem_rdata[15:0]  } 
	:                ( reg_vrdata2 == 4'b0011              ) ? {{16{wire_mem_rdata[15]}}, wire_mem_rdata[15:0]  } 
	:                ( reg_vrdata2 == 4'b1100 & reg_umload ) ? { 16'd0,                   wire_mem_rdata[31:16] } 
	:                ( reg_vrdata2 == 4'b1100              ) ? {{16{wire_mem_rdata[31]}}, wire_mem_rdata[31:16] } 
	:                ( reg_vrdata2 == 4'b0001 & reg_umload ) ? { 24'd0,                   wire_mem_rdata[7:0]   } 
	:                ( reg_vrdata2 == 4'b0001              ) ? {{24{wire_mem_rdata[7]}},  wire_mem_rdata[7:0]   } 
	:                ( reg_vrdata2 == 4'b0010 & reg_umload ) ? { 24'd0,                   wire_mem_rdata[15:8]  } 
	:                ( reg_vrdata2 == 4'b0010              ) ? {{24{wire_mem_rdata[15]}}, wire_mem_rdata[15:8]  } 
	:                ( reg_vrdata2 == 4'b0100 & reg_umload ) ? { 24'd0,                   wire_mem_rdata[23:16] } 
	:                ( reg_vrdata2 == 4'b0100              ) ? {{24{wire_mem_rdata[23]}}, wire_mem_rdata[23:16] } 
	:                ( reg_vrdata2 == 4'b1000 & reg_umload ) ? { 24'd0,                   wire_mem_rdata[31:24] } 
	:                ( reg_vrdata2 == 4'b1000              ) ? {{24{wire_mem_rdata[31]}}, wire_mem_rdata[31:24] } 
	:                32'd0 ;
	
	wire [3:0 ]wire_wen2 = ( wen2[2] ) ? 4'b1111 
	:                      ( wen2[1] & wadd2[1]==0 ) ? 4'b0011 
	:                      ( wen2[1] & wadd2[1]==1 ) ? 4'b1100 
	:                      ( wen2[0] & wadd2[1:0]==2'b00 ) ? 4'b0001 
	:                      ( wen2[0] & wadd2[1:0]==2'b01 ) ? 4'b0010 
	:                      ( wen2[0] & wadd2[1:0]==2'b10 ) ? 4'b0100 
	:                      ( wen2[0] & wadd2[1:0]==2'b11 ) ? 4'b1000 
	:                        4'b0000 ;
	
//-------------------------------------------------------------------------------------//
//                                     Memory outputs
//-------------------------------------------------------------------------------------//
	assign 	 mem_add1   = radd1 ;
	assign   mem_wen1   = 0 ;
	assign   mem_wdata1 = 0 ;
	
	assign 	 mem_add2   = ( wen2!=0 ) ? wadd2 : radd2 ;
	assign 	 mem_wen2   = wire_wen2 ;
	assign   mem_wdata2 = wdata2 ;
	
	
endmodule

module prog_counter(
		input clk,
		input reset,
		input pause,
		
		input        pc_update1   ,
		input        pc_update2   ,
		input        pc_update3   ,
		input        pc_update4   ,
		input [31:0] pc_update_add,
		
		input         inst_rready,
		output        req        ,
		output [31:0] inst_add   ,
		input         vinst      ,
		input [31:0]  inst       ,
		
		output pc_pinst,
		output [31:0] pc,
		output [31:0] inst_out,
		output vinst_out,
		input wait_en
		
    );
	
	wire pc_update = pc_update1 | pc_update2 | pc_update3 | pc_update4 ;
	
	reg reg_pinst;
	reg [31:0] reg_pc;  // current instruction address
	
	//wire [31:0] wire_pc = pc_update ? pc_update_add
	//:                                  reg_pc + 32'd4 ;
	
	wire [31:0] wire_pc = wait_en ? reg_pc:(pc_update ? pc_update_add:reg_pc + 32'd4) ;
	
	always@(posedge clk) if (reset) reg_pc <= 32'h000001fc ; else if (req) reg_pc <= wire_pc ;
	
	always@(posedge clk) if (reset) reg_pinst <=  1'b0 ; else if (req) reg_pinst <= pc_update1 ;
	
//-------------------------------------------------------------- Output signals
	
	assign req = (reset      ) ? 1'b0 
	:            (pc_update  ) ? 1'b1 
	:            (pause      ) ? 1'b0 
	:            (inst_rready) ? 1'b1 
	:            1'b0;
	
	assign inst_add = wire_pc;
//-------------------------------------------------------------- Buffer stage
	wire buffer_en = pause & vinst;
	
	reg buffer_full; 
	always@(posedge clk) begin
		if      ( reset     ) buffer_full<=1'b0; 
		else if ( pc_update ) buffer_full<=1'b0; 
		else if ( buffer_en ) buffer_full<=1'b1; 
		else if ( !pause    ) buffer_full<=1'b0;
	end
	
	reg [31:0] buffer_inst; 
	always@(posedge clk) begin
		if      ( reset     ) buffer_inst<=32'd0; 
		else if ( buffer_en ) buffer_inst<=inst; 
		else if ( !pause    ) buffer_inst<=32'd0;
	end
	
//-------------------------------------------------------------- Output signals
	
	assign pc_pinst = pc_update1  ;
	assign pc       = reg_pc ;
	assign inst_out = buffer_full ? buffer_inst : inst ;
	
	assign vinst_out = pause       ? 1'b0 
	:                  buffer_full ? 1'b1
	:                                vinst ;
	
endmodule


module data_distribute(
	input clk,
	input reset,
	input pause,
//---------------------------------------------- Inputs
	input [31:0] de_rs1     ,
	input [31:0] de_rs2     ,
	input [ 2:0] de_r_wait  ,
	input [ 5:0] de_r_tag   ,
	input [14:0] de_r_add   ,
	
	input        wrd_en1    ,
	input [6:0]  wrd_add1   ,
	input [31:0] wrd_data1  ,
	input        wrd_en2    ,
	input [6:0]  wrd_add2   ,
	input [31:0] wrd_data2  ,
	input        ex_rd_en   ,
	input [6:0]  ex_rd_add  ,
	input [31:0] ex_rd_data ,
	input        mem_rd_en   ,
	input [6:0]  mem_rd_add  ,
	input [31:0] mem_rd_data ,
	input        buff_ex_rd_en   ,
	input [6:0]  buff_ex_rd_add  ,
	input [31:0] buff_ex_rd_data ,
//---------------------------------------------- Inputs
	output [31:0] dd_rs1    ,
	output [31:0] dd_rs2    ,
	output [ 1:0] dd_rd_tag ,
	output [ 4:0] dd_rd_add ,
	output        dd_pause
);
	
	reg [ 5:0] reg_de_r_tag ; always@(posedge clk) if (reset) reg_de_r_tag <= 0; else if (!pause) reg_de_r_tag <= de_r_tag ;
	reg [14:0] reg_de_r_add ; always@(posedge clk) if (reset) reg_de_r_add <= 0; else if (!pause) reg_de_r_add <= de_r_add ;
	
	wire rs1_vwdata, rs2_vwdata, rd_vwdata ;
	
	reg reg_de_rd_wait  ; always@(posedge clk) if (reset) reg_de_rd_wait  <= 0; else if (!pause) reg_de_rd_wait  <= de_r_wait[2] ; else if ( rd_vwdata  ) reg_de_rd_wait  <= 1'b0 ;
	reg reg_de_rs2_wait ; always@(posedge clk) if (reset) reg_de_rs2_wait <= 0; else if (!pause) reg_de_rs2_wait <= de_r_wait[1] ; else if ( rs2_vwdata ) reg_de_rs2_wait <= 1'b0 ;
	reg reg_de_rs1_wait ; always@(posedge clk) if (reset) reg_de_rs1_wait <= 0; else if (!pause) reg_de_rs1_wait <= de_r_wait[0] ; else if ( rs1_vwdata ) reg_de_rs1_wait <= 1'b0 ;
	
	reg [31:0] reg_de_rs1 ; always@(posedge clk) if (reset) reg_de_rs1 <= 0; else if (!pause) reg_de_rs1 <= de_rs1 ; else if ( reg_de_rs1_wait ) reg_de_rs1 <= dd_rs1 ;
	reg [31:0] reg_de_rs2 ; always@(posedge clk) if (reset) reg_de_rs2 <= 0; else if (!pause) reg_de_rs2 <= de_rs2 ; else if ( reg_de_rs2_wait ) reg_de_rs2 <= dd_rs2 ;
	
	wire [1:0] reg_de_rs1_tag, reg_de_rs2_tag, reg_de_rd_tag ;
	
	assign { reg_de_rd_tag, reg_de_rs2_tag, reg_de_rs1_tag } = reg_de_r_tag ;
	
	wire [6:0] rd_add  = { reg_de_rd_tag  - 1, reg_de_r_add[14:10] } ;
	wire [6:0] rs2_add = { reg_de_rs2_tag - 1, reg_de_r_add[09:05] } ;
	wire [6:0] rs1_add = { reg_de_rs1_tag - 1, reg_de_r_add[04:00] } ;
	
	assign rd_vwdata  = ( reg_de_rd_wait & wrd_en1  & rd_add==wrd_add1  ) ? 1'b1
	:                   ( reg_de_rd_wait & wrd_en2  & rd_add==wrd_add2  ) ? 1'b1
	:                   ( reg_de_rd_wait & ex_rd_en & rd_add==ex_rd_add ) ? 1'b1
	:                   ( reg_de_rd_wait & buff_ex_rd_en & rd_add==buff_ex_rd_add ) ? 1'b1
	:                   ( reg_de_rd_wait & mem_rd_en     & rd_add==mem_rd_add     ) ? 1'b1
	:                                                                       1'b0 ;
	
	wire rs1_vwdata1 = ( reg_de_rs1_wait & wrd_en1  & rs1_add==wrd_add1  ) ;
	wire rs1_vwdata2 = ( reg_de_rs1_wait & wrd_en2  & rs1_add==wrd_add2  ) ;
	wire rs1_vwdata3 = ( reg_de_rs1_wait & ex_rd_en & rs1_add==ex_rd_add ) ;
	wire rs1_vwdata4 = ( reg_de_rs1_wait & buff_ex_rd_en & rs1_add==buff_ex_rd_add ) ;
	wire rs1_vwdata5 = ( reg_de_rs1_wait & mem_rd_en     & rs1_add==mem_rd_add ) ;
	
	wire rs2_vwdata1 = ( reg_de_rs2_wait & wrd_en1  & rs2_add==wrd_add1  ) ;
	wire rs2_vwdata2 = ( reg_de_rs2_wait & wrd_en2  & rs2_add==wrd_add2  ) ;
	wire rs2_vwdata3 = ( reg_de_rs2_wait & ex_rd_en & rs2_add==ex_rd_add ) ;
	wire rs2_vwdata4 = ( reg_de_rs2_wait & buff_ex_rd_en & rs2_add==buff_ex_rd_add ) ;
	wire rs2_vwdata5 = ( reg_de_rs2_wait & mem_rd_en     & rs2_add==mem_rd_add ) ;
	
	assign rs1_vwdata = rs1_vwdata1 | rs1_vwdata2 | rs1_vwdata3 | rs1_vwdata4 | rs1_vwdata5 ;
	assign rs2_vwdata = rs2_vwdata1 | rs2_vwdata2 | rs2_vwdata3 | rs2_vwdata4 | rs2_vwdata5 ;
	
	//----------------------------------------------------------------------------------------------------- outputs
	
	assign dd_rd_tag = reg_de_rd_tag;
	assign dd_rd_add = reg_de_r_add[14:10];
	
	assign dd_rs1 = ( rs1_vwdata1 ) ? wrd_data1
	:               ( rs1_vwdata2 ) ? wrd_data2
	:               ( rs1_vwdata3 ) ? ex_rd_data
	:               ( rs1_vwdata4 ) ? buff_ex_rd_data
	:               ( rs1_vwdata5 ) ? mem_rd_data
	:                                 reg_de_rs1 ;
	
	assign dd_rs2 = ( rs2_vwdata1 ) ? wrd_data1
	:               ( rs2_vwdata2 ) ? wrd_data2
	:               ( rs2_vwdata3 ) ? ex_rd_data
	:               ( rs2_vwdata4 ) ? buff_ex_rd_data
	:               ( rs2_vwdata5 ) ? mem_rd_data
	:                                 reg_de_rs2 ;
	
	assign dd_pause = (reg_de_rs1_wait & (!(wrd_en1&(rs1_add==wrd_add1)) & !(wrd_en2&(rs1_add==wrd_add2)) & !(ex_rd_en&(rs1_add==ex_rd_add)) & !(buff_ex_rd_en&(rs1_add==buff_ex_rd_add)) & !(mem_rd_en&(rs1_add==mem_rd_add)))) ? 1'b1
	:                 (reg_de_rs2_wait & (!(wrd_en1&(rs2_add==wrd_add1)) & !(wrd_en2&(rs2_add==wrd_add2)) & !(ex_rd_en&(rs2_add==ex_rd_add)) & !(buff_ex_rd_en&(rs2_add==buff_ex_rd_add)) & !(mem_rd_en&(rs2_add==mem_rd_add)))) ? 1'b1
	:                 (reg_de_rd_wait  & (!(wrd_en1&(rd_add ==wrd_add1)) & !(wrd_en2&(rd_add ==wrd_add2)) & !(ex_rd_en&(rd_add ==ex_rd_add)) & !(buff_ex_rd_en&(rd_add ==buff_ex_rd_add)) & !(mem_rd_en&(rd_add ==mem_rd_add)))) ? 1'b1 
	:                                                                                                                                                      1'b0 ;
	
	// reg [31:0] pause_count=0; always@(posedge clk) if (buff_de_pause) pause_count <= pause_count+1 ;
	
endmodule


module CSR(
		input clk,
		input reset,
		input ins_counter_up,
		//--------------------//
		input [11:0] imm,
		output [31:0] rdata,
		output vrdata,
		input [31:0] wdata,
		input rw,
		input rs,
		input rc
    );
	
////////    Read/Write registers   ////////
	
	
	reg [31:0] FFLAGS;
	always@(posedge clk) begin
		if      (reset) FFLAGS <= 0;
		else if (rw && imm==12'h001) FFLAGS <= wdata;
		else if (rs && imm==12'h001) FFLAGS <= FFLAGS | wdata;
		else if (rc && imm==12'h001) FFLAGS <= FFLAGS & ~wdata;
	end
	
	reg [31:0] FRM;
	always@(posedge clk) begin
		if      (reset             ) FRM <= 0;
		else if (rw && imm==12'h002) FRM <= wdata;
		else if (rs && imm==12'h002) FRM <= FRM | wdata;
		else if (rc && imm==12'h002) FRM <= FRM & ~wdata;
	end
	
	reg [31:0] FCAR;
	always@(posedge clk) begin
		if      (             reset) FCAR <= 0;
		else if (rw && imm==12'h003) FCAR <= wdata;
		else if (rs && imm==12'h003) FCAR <= FCAR | wdata;
		else if (rc && imm==12'h003) FCAR <= FCAR & ~wdata;
	end
	
////////    Read only registers   ////////
	
	reg [63:0] RDCYCLE  ; always@(posedge clk) if (reset) RDCYCLE   <= 0; else RDCYCLE <= RDCYCLE + 1 ;
	reg [63:0] RDTIME   ; always@(posedge clk) if (reset) RDTIME    <= 0; else RDTIME  <= RDTIME  + 1 ;
	reg [63:0] RDINSTRET; always@(posedge clk) if (reset) RDINSTRET <= 0; else if (ins_counter_up) RDINSTRET <= RDINSTRET + 1;
	
	
	
////////    Output   ////////
	
	assign vrdata = rw | rs | rc ;
	assign rdata = reset          ? 0
	:              (imm==12'h001) ? FFLAGS
	:              (imm==12'h002) ? FRM
	:              (imm==12'h003) ? FCAR
	:              (imm==12'hc00) ? RDCYCLE[31:0]
	:              (imm==12'hc01) ? RDTIME[31:0]
	:              (imm==12'hc02) ? RDINSTRET[31:0]
	:              (imm==12'hc80) ? RDCYCLE[63:32]
	:              (imm==12'hc81) ? RDTIME[63:32]
	:              (imm==12'hc82) ? RDINSTRET[63:32]
    :              0;
	
endmodule


module DBP#(
		parameter AWIDTH=10,
		parameter DWIDTH=34
)(
		input clk,
		input reset,
		input clear_dbp,
		input pause,
		
	//------------------------------------- input
		input        inst_req,
		input [31:0] inst_add,
		
		input        de_pfalse,
		input [31:0] pc_pc,
		input [31:0] buff_pc_pc,
		
		input        jal,
		input [31:0] jal_add,
		
		input [31:0] buff_dd_pc,
		
		input        buff_ex_jal,
		input        buff_ex_jb,
		input        buff_ex_jb_en,
		input [31:0] buff_ex_jb_add,
		input [31:0] buff_ex_pc,
		
	//------------------------------------- output
		output [AWIDTH-1:0] add1,
		input  [DWIDTH-1:0] rdata1,
		output [AWIDTH-1:0] add2,
		input  [DWIDTH-1:0] rdata2,
		output              wen2,
		output [DWIDTH-1:0] wdata2,
		
		output        pc_update1,
		output        pc_update2,
		output        pc_update3,
		output        pc_update4,
		output [31:0] pc_update_add
    );
	
//------------------------------------- Dynamic Branch Table
	
	assign add1 = inst_add[AWIDTH+1:2] ;
	assign add2 = wen2 ? buff_ex_pc[AWIDTH+1:2] : buff_dd_pc[AWIDTH+1:2] ;
	
	wire [31:0] bht_badd1  ; 
	wire [1:0]  bht_count1 ; 
	
	assign {bht_count1, bht_badd1} = rdata1 ;
	
	wire [31:0] bht_badd2  ; 
	wire [1:0]  bht_count2 ; 
	
	assign {bht_count2, bht_badd2} = rdata2 ;
	
//-------------------------------------  Branch Prediction
	
	reg        reg_inst_req; always@(posedge clk) if (reset|clear_dbp) reg_inst_req <= 0; else if (!pause) reg_inst_req <= inst_req ;
	reg [31:0] reg_inst_add; always@(posedge clk) if (reset|clear_dbp) reg_inst_add <= 0; else if (!pause) reg_inst_add <= inst_add ;
	
	wire        predict_en  = ( reg_inst_req & bht_count1>1 ) ? 1'b1 : 1'b0 ;
	wire [31:0] predict_add = bht_badd1 ;
	
//------------------------------------- Branch Table Check
	
	wire branch_take  = buff_ex_jb_en ;
	wire branch_ntake = buff_ex_jb & !buff_ex_jb_en ;
	
	wire wrong_prediction = ( ( branch_ntake | branch_take ) & ( buff_ex_jb_add != buff_dd_pc ) ) ? 1'b1 : 1'b0 ;
	
	wire [31:0] pc_update_add1 = predict_add    ;
	wire [31:0] pc_update_add2 = buff_pc_pc+4   ;
	wire [31:0] pc_update_add3 = jal_add        ;
	wire [31:0] pc_update_add4 = buff_ex_jb_add ;
	
	assign pc_update1 = !pause & predict_en ;
	assign pc_update2 = !pause & de_pfalse ;
	assign pc_update3 = (jal & jal_add!=buff_pc_pc) ;
	assign pc_update4 = wrong_prediction ;
	
	// assign pc_update = pc_update3 ? 1 
	// :                  pause      ? 0 
	// :                  pc_update2 ? 1
	// :                  pc_update1 ? 1 
	// :                               0 ;
	
	assign pc_update_add = pc_update4 ? pc_update_add4
	:                      pc_update3 ? pc_update_add3
	:                      pc_update2 ? pc_update_add2
	:                                   pc_update_add1 ;
	
	//------------------------------------- Branch Table Update
	
	wire [1:0] count = (branch_ntake & bht_count2>0) ? (bht_count2-1)
	:                  (bht_count2<3)                ? (bht_count2+1) 
	:                                                   bht_count2 ;
	
	assign wen2 = branch_ntake | branch_take | buff_ex_jal ;
	
	assign wdata2 = { count, buff_ex_jb_add } ;
	
	// assign pinst = pause ? 0 : pc_update2 ;
	
endmodule


module divu_radix8#(
	parameter WIDTH = 33
)(
	input clk,
	input reset,
	input pause,
	
	input en,
	input [WIDTH-1:0] divisor,
	input [WIDTH-1:0] dividend,      // width should be multiple of 4
	
	output ready,
	output [WIDTH-1:0] q,
	output [WIDTH-1:0] r,
	output vout
);

	// localparam width1 = $clog2(WIDTH) ;
	localparam width1 = 8 ;
	
	integer index;
	reg [width1-1:0] msb_count ;
	
	//initial msb_count = 0 ;
	always @* begin // combination logic
		msb_count=0;
		for(index = 2; index < WIDTH; index = index + 3) begin
			if(dividend[index]!=0 || dividend[index-1]!=0 || dividend[index-2]!=0 ) begin
				msb_count = index;
			end
		end
	end
	
	wire [width1-1:0] shifts = WIDTH - 1 - msb_count;
	
	wire [WIDTH-1:0] wire_dividend = dividend << shifts ;

	reg reg_ready;
	always@(posedge clk) begin
	    if      ( reset ) reg_ready <= 1; 
		else if ( vout  ) reg_ready <= 1; 
		else if ( en    ) reg_ready <= 0; 
	end
	
	assign ready = reg_ready;
	
	wire init = en & ready;
	
	reg [WIDTH-1  :0] reg_divisor;
	reg [2*WIDTH-1:0] reg_dividend;
	
	reg [WIDTH-1  :0] reg_q;
	
	wire [2:0] wire_q0 ;
	
	wire [WIDTH-1:0] wire_d1 ;
	wire [WIDTH-4:0] wire_d0 = reg_dividend[WIDTH-4:0] ;
	
	always@(posedge clk) begin
		if (reset) begin
			reg_divisor  <= {WIDTH{1'b0}} ;
			reg_dividend <= {(2*WIDTH){1'b0}};
			reg_q        <= {WIDTH{1'b0}};
		end else if (init) begin
			reg_divisor  <= divisor ;
			reg_dividend <= {{WIDTH{1'b0}}, wire_dividend} ;
			reg_q        <= {WIDTH{1'b0}};
		end else begin
			reg_dividend <= {wire_d1, wire_d0, 3'd0} ;
			reg_q        <= {reg_q[WIDTH-4:0], wire_q0} ;
		end
	end
	
	wire [WIDTH+2:0] wire_b   = reg_divisor       ;
	wire [WIDTH+2:0] wire_2b  = reg_divisor << 1  ;
	wire [WIDTH+2:0] wire_3b  = wire_b + wire_2b  ;
	wire [WIDTH+2:0] wire_4b  = reg_divisor << 2  ;
	wire [WIDTH+2:0] wire_5b  = wire_4b + wire_b  ;
	wire [WIDTH+2:0] wire_6b  = wire_4b + wire_2b ;
	wire [WIDTH+2:0] wire_7b  = wire_4b + wire_3b ;
	
	wire [WIDTH+2:0] wire_a = { reg_dividend[(2*WIDTH-1):WIDTH-3] } ;
	
	wire [WIDTH+2:0] wire_s   =   wire_a - wire_b ;
	wire [WIDTH+2:0] wire_2s  =   wire_a - wire_2b ;
	wire [WIDTH+2:0] wire_3s  =   wire_a - wire_3b ;
	wire [WIDTH+2:0] wire_4s  =   wire_a - wire_4b ;
	wire [WIDTH+2:0] wire_5s  =   wire_a - wire_5b ;
	wire [WIDTH+2:0] wire_6s  =   wire_a - wire_6b ;
	wire [WIDTH+2:0] wire_7s  =   wire_a - wire_7b ;
	
	assign wire_d1 = ( wire_7s[WIDTH+2]  == 1'b0 ) ? wire_7s[WIDTH-1:0] 
	:                ( wire_6s[WIDTH+2]  == 1'b0 ) ? wire_6s[WIDTH-1:0] 
	:                ( wire_5s[WIDTH+2]  == 1'b0 ) ? wire_5s[WIDTH-1:0] 
	:                ( wire_4s[WIDTH+2]  == 1'b0 ) ? wire_4s[WIDTH-1:0] 
	:                ( wire_3s[WIDTH+2]  == 1'b0 ) ? wire_3s[WIDTH-1:0] 
	:                ( wire_2s[WIDTH+2]  == 1'b0 ) ? wire_2s[WIDTH-1:0] 
	:                ( wire_s[WIDTH+2]   == 1'b0 ) ? wire_s[WIDTH-1:0] 
	:                  wire_a[WIDTH-1:0] ;
	
	
	assign wire_q0 = ( wire_7s[WIDTH+2]  == 1'b0 ) ? 3'd7 
	:                ( wire_6s[WIDTH+2]  == 1'b0 ) ? 3'd6 
	:                ( wire_5s[WIDTH+2]  == 1'b0 ) ? 3'd5 
	:                ( wire_4s[WIDTH+2]  == 1'b0 ) ? 3'd4 
	:                ( wire_3s[WIDTH+2]  == 1'b0 ) ? 3'd3 
	:                ( wire_2s[WIDTH+2]  == 1'b0 ) ? 3'd2 
	:                ( wire_s[WIDTH+2]   == 1'b0 ) ? 3'd1 
	:                 3'd0 ;
	
	reg [width1-1:0] count_limit;
	always@(posedge clk) if (init) count_limit <= msb_count ;
	
	reg [width1:0] count;
	
	always@(posedge clk) begin
		if      ( reset  ) count <= 32'hffffffff;
		else if ( init   ) count <= 0;
		else if ( !ready ) count <= count + 3;
	end
	
	// assign q    = wire_15b ;
	assign q    = reg_q ;
	assign r    = reg_dividend[(2*WIDTH-1):WIDTH] ;
	assign vout = ( !ready && count > count_limit ) ? 1'b1 : 1'b0 ;
	
endmodule

module mac#(
	parameter PWIDTH  = 32'd22,
	parameter PWIDTH1 = 32'd44
)(
	input clk,
	input reset,
	input pause,
	
	input mul_en,
	input mac_low,
	input mac_high,
	input [32:0] din1,
	input [32:0] din2,
	
	// output [65:0] test,
	
	output [31:0] dlout,
	output [31:0] dhout,
	output vldout,
	output vhdout
);
	
	wire wire_en = (mac_low | mac_high) ;
	
	wire acc_en = wire_en & !mul_en ;
	
	reg [65:0] reg_data;
	
	wire [PWIDTH-1:0] old_data = (mul_en) ? {PWIDTH{1'b0}} : reg_data[PWIDTH-1:0] ;
	
	wire [33:00] pp01 = { 1'b1, ~(din1[32] & din2[00]), ( din1[31:0] & {32{din2[00]}} ) };
	wire [33:01] pp02 = { ~(din1[32] & din2[01]), (din1[31:0] & {32{din2[01]}}) };
	wire [34:02] pp03 = { ~(din1[32] & din2[02]), (din1[31:0] & {32{din2[02]}}) };
	wire [35:03] pp04 = { ~(din1[32] & din2[03]), (din1[31:0] & {32{din2[03]}}) };
	wire [36:04] pp05 = { ~(din1[32] & din2[04]), (din1[31:0] & {32{din2[04]}}) };
	wire [37:05] pp06 = { ~(din1[32] & din2[05]), (din1[31:0] & {32{din2[05]}}) };
	wire [38:06] pp07 = { ~(din1[32] & din2[06]), (din1[31:0] & {32{din2[06]}}) };
	wire [39:07] pp08 = { ~(din1[32] & din2[07]), (din1[31:0] & {32{din2[07]}}) };
	wire [40:08] pp09 = { ~(din1[32] & din2[08]), (din1[31:0] & {32{din2[08]}}) };
	wire [41:09] pp10 = { ~(din1[32] & din2[09]), (din1[31:0] & {32{din2[09]}}) };
	wire [42:10] pp11 = { ~(din1[32] & din2[10]), (din1[31:0] & {32{din2[10]}}) };
	wire [43:11] pp12 = { ~(din1[32] & din2[11]), (din1[31:0] & {32{din2[11]}}) };
	wire [44:12] pp13 = { ~(din1[32] & din2[12]), (din1[31:0] & {32{din2[12]}}) };
	wire [45:13] pp14 = { ~(din1[32] & din2[13]), (din1[31:0] & {32{din2[13]}}) };
	wire [46:14] pp15 = { ~(din1[32] & din2[14]), (din1[31:0] & {32{din2[14]}}) };
	wire [47:15] pp16 = { ~(din1[32] & din2[15]), (din1[31:0] & {32{din2[15]}}) };
	wire [48:16] pp17 = { ~(din1[32] & din2[16]), (din1[31:0] & {32{din2[16]}}) };
	wire [49:17] pp18 = { ~(din1[32] & din2[17]), (din1[31:0] & {32{din2[17]}}) };
	wire [50:18] pp19 = { ~(din1[32] & din2[18]), (din1[31:0] & {32{din2[18]}}) };
	wire [51:19] pp20 = { ~(din1[32] & din2[19]), (din1[31:0] & {32{din2[19]}}) };
	wire [52:20] pp21 = { ~(din1[32] & din2[20]), (din1[31:0] & {32{din2[20]}}) };
	wire [53:21] pp22 = { ~(din1[32] & din2[21]), (din1[31:0] & {32{din2[21]}}) };
	wire [54:22] pp23 = { ~(din1[32] & din2[22]), (din1[31:0] & {32{din2[22]}}) };
	wire [55:23] pp24 = { ~(din1[32] & din2[23]), (din1[31:0] & {32{din2[23]}}) };
	wire [56:24] pp25 = { ~(din1[32] & din2[24]), (din1[31:0] & {32{din2[24]}}) };
	wire [57:25] pp26 = { ~(din1[32] & din2[25]), (din1[31:0] & {32{din2[25]}}) };
	wire [58:26] pp27 = { ~(din1[32] & din2[26]), (din1[31:0] & {32{din2[26]}}) };
	wire [59:27] pp28 = { ~(din1[32] & din2[27]), (din1[31:0] & {32{din2[27]}}) };
	wire [60:28] pp29 = { ~(din1[32] & din2[28]), (din1[31:0] & {32{din2[28]}}) };
	wire [61:29] pp30 = { ~(din1[32] & din2[29]), (din1[31:0] & {32{din2[29]}}) };
	wire [62:30] pp31 = { ~(din1[32] & din2[30]), (din1[31:0] & {32{din2[30]}}) };
	wire [63:31] pp32 = { ~(din1[32] & din2[31]), (din1[31:0] & {32{din2[31]}}) };
	wire [65:32] pp33 = { 1'b1, (din1[32] & din2[32]), ~(din1[31:0] & {32{din2[32]}}) };
	
	
	wire [65:0] p01 = { 32'd0, pp01        };    wire [65:0] p11 = { 23'd0, pp11, 10'd0 };    wire [65:0] p21 = { 13'd0, pp21, 20'd0 };    
	wire [65:0] p02 = { 32'd0, pp02, 01'd0 };    wire [65:0] p12 = { 22'd0, pp12, 11'd0 };    wire [65:0] p22 = { 12'd0, pp22, 21'd0 };    
	wire [65:0] p03 = { 31'd0, pp03, 02'd0 };    wire [65:0] p13 = { 21'd0, pp13, 12'd0 };    wire [65:0] p23 = { 11'd0, pp23, 22'd0 };    
	wire [65:0] p04 = { 30'd0, pp04, 03'd0 };    wire [65:0] p14 = { 20'd0, pp14, 13'd0 };    wire [65:0] p24 = { 10'd0, pp24, 23'd0 };    
	wire [65:0] p05 = { 29'd0, pp05, 04'd0 };    wire [65:0] p15 = { 19'd0, pp15, 14'd0 };    wire [65:0] p25 = { 09'd0, pp25, 24'd0 };    
	wire [65:0] p06 = { 28'd0, pp06, 05'd0 };    wire [65:0] p16 = { 18'd0, pp16, 15'd0 };    wire [65:0] p26 = { 08'd0, pp26, 25'd0 };    
	wire [65:0] p07 = { 27'd0, pp07, 06'd0 };    wire [65:0] p17 = { 17'd0, pp17, 16'd0 };    wire [65:0] p27 = { 07'd0, pp27, 26'd0 };    
	wire [65:0] p08 = { 26'd0, pp08, 07'd0 };    wire [65:0] p18 = { 16'd0, pp18, 17'd0 };    wire [65:0] p28 = { 06'd0, pp28, 27'd0 };    
	wire [65:0] p09 = { 25'd0, pp09, 08'd0 };    wire [65:0] p19 = { 15'd0, pp19, 18'd0 };    wire [65:0] p29 = { 05'd0, pp29, 28'd0 };    
	wire [65:0] p10 = { 24'd0, pp10, 09'd0 };    wire [65:0] p20 = { 14'd0, pp20, 19'd0 };    wire [65:0] p30 = { 04'd0, pp30, 29'd0 };    
	
	wire [65:0] p31 = { 03'd0, pp31, 30'd0 };
	wire [65:0] p32 = { 02'd0, pp32, 31'd0 };
	wire [65:0] p33 = {        pp33, 32'd0 };
	
	// assign test = p01 + p02 + p03 + p04 + p05 + p06 + p07 + p08 
	// +             p09 + p10 + p11 + p12 + p13 + p14 + p15 + p16 
	// +             p17 + p18 + p19 + p20 + p21 + p22 + p23 + p24 
	// +             p25 + p26 + p27 + p28 + p29 + p30 + p31 + p32 
	// +             p33 ;
	
	wire [PWIDTH+5:0] wire_sum11 = p01[PWIDTH-1:0] + p02[PWIDTH-1:0] + p03[PWIDTH-1:0] + p04[PWIDTH-1:0] + p05[PWIDTH-1:0] + p06[PWIDTH-1:0] + p07[PWIDTH-1:0] + p08[PWIDTH-1:0] 
	+                              p09[PWIDTH-1:0] + p10[PWIDTH-1:0] + p11[PWIDTH-1:0] + p12[PWIDTH-1:0] + p13[PWIDTH-1:0] + p14[PWIDTH-1:0] + p15[PWIDTH-1:0] + p16[PWIDTH-1:0] 
	+                              p17[PWIDTH-1:0] + p18[PWIDTH-1:0] + p19[PWIDTH-1:0] + p20[PWIDTH-1:0] + p21[PWIDTH-1:0] + p22[PWIDTH-1:0] + p23[PWIDTH-1:0] + p24[PWIDTH-1:0] 
	+                              p25[PWIDTH-1:0] + p26[PWIDTH-1:0] + p27[PWIDTH-1:0] + p28[PWIDTH-1:0] + p29[PWIDTH-1:0] + p30[PWIDTH-1:0] + p31[PWIDTH-1:0] + p32[PWIDTH-1:0] 
	+                              p33[PWIDTH-1:0] + old_data ;
	
	
	wire [PWIDTH1+5:PWIDTH] wire_sum12 = p01[PWIDTH1-1:PWIDTH] + p02[PWIDTH1-1:PWIDTH] + p03[PWIDTH1-1:PWIDTH] + p04[PWIDTH1-1:PWIDTH] + p05[PWIDTH1-1:PWIDTH] + p06[PWIDTH1-1:PWIDTH] + p07[PWIDTH1-1:PWIDTH] + p08[PWIDTH1-1:PWIDTH] 
	+                                    p09[PWIDTH1-1:PWIDTH] + p10[PWIDTH1-1:PWIDTH] + p11[PWIDTH1-1:PWIDTH] + p12[PWIDTH1-1:PWIDTH] + p13[PWIDTH1-1:PWIDTH] + p14[PWIDTH1-1:PWIDTH] + p15[PWIDTH1-1:PWIDTH] + p16[PWIDTH1-1:PWIDTH] 
	+                                    p17[PWIDTH1-1:PWIDTH] + p18[PWIDTH1-1:PWIDTH] + p19[PWIDTH1-1:PWIDTH] + p20[PWIDTH1-1:PWIDTH] + p21[PWIDTH1-1:PWIDTH] + p22[PWIDTH1-1:PWIDTH] + p23[PWIDTH1-1:PWIDTH] + p24[PWIDTH1-1:PWIDTH] 
	+                                    p25[PWIDTH1-1:PWIDTH] + p26[PWIDTH1-1:PWIDTH] + p27[PWIDTH1-1:PWIDTH] + p28[PWIDTH1-1:PWIDTH] + p29[PWIDTH1-1:PWIDTH] + p30[PWIDTH1-1:PWIDTH] + p31[PWIDTH1-1:PWIDTH] + p32[PWIDTH1-1:PWIDTH] 
	+                                    p33[PWIDTH1-1:PWIDTH] ;
	
	wire [65:PWIDTH1] wire_sum13 = p01[65:PWIDTH1] + p02[65:PWIDTH1] + p03[65:PWIDTH1] + p04[65:PWIDTH1] + p05[65:PWIDTH1] + p06[65:PWIDTH1] + p07[65:PWIDTH1] + p08[65:PWIDTH1] 
	+                              p09[65:PWIDTH1] + p10[65:PWIDTH1] + p11[65:PWIDTH1] + p12[65:PWIDTH1] + p13[65:PWIDTH1] + p14[65:PWIDTH1] + p15[65:PWIDTH1] + p16[65:PWIDTH1] 
	+                              p17[65:PWIDTH1] + p18[65:PWIDTH1] + p19[65:PWIDTH1] + p20[65:PWIDTH1] + p21[65:PWIDTH1] + p22[65:PWIDTH1] + p23[65:PWIDTH1] + p24[65:PWIDTH1] 
	+                              p25[65:PWIDTH1] + p26[65:PWIDTH1] + p27[65:PWIDTH1] + p28[65:PWIDTH1] + p29[65:PWIDTH1] + p30[65:PWIDTH1] + p31[65:PWIDTH1] + p32[65:PWIDTH1] 
	+                              p33[65:PWIDTH1] ;
	
	// assign test = wire_sum11 + {wire_sum12, {PWIDTH{1'b0}}} + {wire_sum13, {PWIDTH1{1'b0}}} ; 
	
	reg [PWIDTH +5:PWIDTH ] reg_sum11; always@(posedge clk) if (reset) reg_sum11 <= 0; else if (!pause) reg_sum11 <= wire_sum11[PWIDTH+5:PWIDTH] ;
	reg [PWIDTH1+5:PWIDTH ] reg_sum12; always@(posedge clk) if (reset) reg_sum12 <= 0; else if (!pause) reg_sum12 <= wire_sum12 ;
	reg [       65:PWIDTH1] reg_sum13; always@(posedge clk) if (reset) reg_sum13 <= 0; else if (!pause) reg_sum13 <= wire_sum13 ;
	
	reg reg_mul_en1  ; always@(posedge clk) if (reset) reg_mul_en1   <= 0; else if (!pause) reg_mul_en1   <= mul_en ;
	reg reg_mac_low1 ; always@(posedge clk) if (reset) reg_mac_low1  <= 0; else if (!pause) reg_mac_low1  <= mac_low ;
	reg reg_mac_high1; always@(posedge clk) if (reset) reg_mac_high1 <= 0; else if (!pause) reg_mac_high1 <= mac_high ;
	
// Stage 2
// --------------------------------------------------------------------------------------------------------------------------------------------
	
	wire [PWIDTH1-1:PWIDTH] old_data2 = (reg_mul_en1) ? {(PWIDTH1-PWIDTH){1'b0}} : reg_data[PWIDTH1-1:PWIDTH] ;
	
	wire [PWIDTH1+1:PWIDTH ] wire_sum21 = reg_sum11[PWIDTH +5:PWIDTH ] + reg_sum12[PWIDTH1-1:PWIDTH ] + old_data2 ;
	wire [       65:PWIDTH1] wire_sum22 = reg_sum12[PWIDTH1+5:PWIDTH1] + reg_sum13[       65:PWIDTH1] ;
	
	// assign test = reg_data[PWIDTH-1:0] + {wire_sum21, {PWIDTH{1'b0}}} + {wire_sum22, {PWIDTH1{1'b0}}} ; 
	
	reg [PWIDTH1+1:PWIDTH1] reg_sum21; always@(posedge clk) if (reset) reg_sum21 <= 0; else if (!pause) reg_sum21 <= wire_sum21[PWIDTH1+1:PWIDTH1] ;
	reg [       65:PWIDTH1] reg_sum22; always@(posedge clk) if (reset) reg_sum22 <= 0; else if (!pause) reg_sum22 <= wire_sum22[65:PWIDTH1] ;
	
	reg reg_mul_en2  ; always@(posedge clk) if (reset) reg_mul_en2   <= 0; else if (!pause) reg_mul_en2   <= reg_mul_en1 ;
	reg reg_mac_low2 ; always@(posedge clk) if (reset) reg_mac_low2  <= 0; else if (!pause) reg_mac_low2  <= reg_mac_low1 ;
	reg reg_mac_high2; always@(posedge clk) if (reset) reg_mac_high2 <= 0; else if (!pause) reg_mac_high2 <= reg_mac_high1 ;
	
// Stage 3
// --------------------------------------------------------------------------------------------------------------------------------------------
	
	wire [65:PWIDTH1] old_data3 = (reg_mul_en2) ? {(66-PWIDTH1){1'b0}} : reg_data[65:PWIDTH1] ;
	
	wire [65:PWIDTH1] wire_sum31 = reg_sum21 + reg_sum22 + old_data3 ;
	
	wire wire_en1 = reg_mac_low1 | reg_mac_high1 ;
	wire wire_en2 = reg_mac_low2 | reg_mac_high2 ;
	
	always@(posedge clk) begin
		if (reset) reg_data[PWIDTH -1:0      ] <= 0; else if (!pause & wire_en  ) reg_data[PWIDTH -1:0      ] <= wire_sum11[PWIDTH -1:0      ] ;
		if (reset) reg_data[PWIDTH1-1:PWIDTH ] <= 0; else if (!pause & wire_en1 ) reg_data[PWIDTH1-1:PWIDTH ] <= wire_sum21[PWIDTH1-1:PWIDTH ] ;
		if (reset) reg_data[       65:PWIDTH1] <= 0; else if (!pause & wire_en2 ) reg_data[       65:PWIDTH1] <= wire_sum31[       65:PWIDTH1] ;
	end
	
	assign dlout = { wire_sum21[31:PWIDTH],  reg_data[PWIDTH -1:0 ] };
	assign dhout = { wire_sum31[65:PWIDTH1], reg_data[PWIDTH1-1:32] };
	
	assign vldout = !pause & reg_mac_low1 ; 
	assign vhdout = !pause & reg_mac_high2 ;
	
endmodule


module mul_div (
	input clk,
	input rst,
	input pause,
	input [31:0] rs1,
	input [31:0] rs2,
	input [6:0]  in_rd_add,
	input [7:0]  fn,
	input [2:0]  control2,
	input [31:0] rs1_aes,
	input [7:0]  fn_aes,
	input        wait_en,
	input Dvld, 
// output signals
	output     reg   rd_en,
	output reg [ 6:0] rd_add,
	output reg [31:0] rd_data,
	
	output        md_pause_next
);
    wire rd_en_md;
	wire [ 6:0] rd_add_md;
	wire [31:0] rd_data_md;
	wire reset;
    reg  [31:0] rs1_md;
	reg [31:0] rs2_md;
	reg [6:0]  in_rd_add_md;
	reg [7:0]  fn_md;
	reg [2:0]  control2_md;
	assign reset = rst | Dvld;
	always@(*)begin
	if(wait_en==1) begin rs1_md = rs1_aes ;
	                  rs2_md = {rs1_aes[7:0],rs1_aes[15:8],rs1_aes[23:16],rs1_aes[31:24]};
	                  in_rd_add_md = rs1_aes[6:0] ;
                      fn_md = fn_aes ;
	                  control2_md = (fn_aes<30)? {1'b1,rs1_aes[31],rs1_aes[31]}:{1'b0,rs1_aes[31],rs1_aes[31]};
	                  rd_en = rd_en;
	                  rd_add = rd_add;
	                  rd_data = rd_data; end
	else begin        rs1_md = rs1 ;
	                  rs2_md = rs2 ;
	                  in_rd_add_md = in_rd_add ;
                      fn_md = fn ;
	                  control2_md = control2 ;
	                  rd_en = rd_en_md & ~wait_en & ~Dvld & (fn_aes!=0);
	                  rd_add = rd_add_md;
	                  rd_data = rd_data_md; end
	end
	wire mac_init, rs1_sign, rs2_sign ;

	assign { mac_init, rs1_sign, rs2_sign } = control2_md ;

//-------------------------------------------------------------------------------------//
//                                      MAC
//-------------------------------------------------------------------------------------//
	
	wire mac_low  = ( fn_md == 8'h1c ) ;
	wire mac_high = ( fn_md == 8'h1D ) ;
	
	wire mac_en = mac_high | mac_low ;
	
	wire [32:0] mac_din1 = rs1_sign ? {rs1_md[31],rs1_md} : {1'b0,rs1_md};
	wire [32:0] mac_din2 = rs2_sign ? {rs2_md[31],rs2_md} : {1'b0,rs2_md};
	
	wire [31:0] mac_dlout;
	wire [31:0] mac_dhout;
	wire mac_vldout;
	wire mac_vhdout;
	
	mac inst_mac (
	   .clk    ( clk       ),
	   .reset  (  reset    ),
	   .pause  ( pause     ),
	   .mul_en ( mac_init  ),
	   .mac_low  ( mac_low  ),
	   .mac_high ( mac_high ),
	   .din1   ( mac_din1  ),
	   .din2   ( mac_din2  ),
	   .dlout  ( mac_dlout  ),
	   .dhout  ( mac_dhout  ),
	   .vldout ( mac_vldout ),
	   .vhdout ( mac_vhdout )
	);
	
    reg [6:0] reg_mac_rd_add1; always@(posedge clk) if (reset) reg_mac_rd_add1 <= 0; else if (!pause) reg_mac_rd_add1 <= in_rd_add_md ;
    reg [6:0] reg_mac_rd_add2; always@(posedge clk) if (reset) reg_mac_rd_add2 <= 0; else if (!pause) reg_mac_rd_add2 <= reg_mac_rd_add1 ;
	
	wire        macl_rd_en   = pause ? 0 : mac_vldout ;
	wire [ 6:0] macl_rd_add  = reg_mac_rd_add1 ;
	wire [31:0] macl_rd_data = mac_dlout ;
	
	wire        mach_rd_en   = pause ? 0 : mac_vhdout ;
	wire [ 6:0] mach_rd_add  = reg_mac_rd_add2 ;
	wire [31:0] mach_rd_data = mac_dhout ;
	
//-------------------------------------------------------------------------------------//
//                                      Divider
//-------------------------------------------------------------------------------------//
	wire rs1_sign_true = rs1_sign & rs1_md[31] ;
	wire rs2_sign_true = rs2_sign & rs2_md[31] ;
	
	wire divr_sign = rs1_sign_true ;
    wire divq_sign = rs1_sign_true ^ rs2_sign_true ;
    
    wire [31:0] mag_rs1 = rs1_sign_true ? (~rs1_md+1'b1) : rs1_md ;
    wire [31:0] mag_rs2 = rs2_sign_true ? (~rs2_md+1'b1) : rs2_md ;
    
    wire divq_en = ( fn_md == 30 ) ;
    wire divr_en = ( fn_md == 31 ) ;
    
    wire div_en  =  divq_en | divr_en ;
    
    wire [9:0] div_data = { divq_sign, divr_sign, divr_en, in_rd_add_md } ;

	wire div_ready;
	
	reg [31:0] reg_mag_rs1 ; always@(posedge clk) if ( reset | div_ready ) reg_mag_rs1 <= 0; else if (!div_ready & div_en) reg_mag_rs1 <= mag_rs1;
    reg [31:0] reg_mag_rs2 ; always@(posedge clk) if ( reset | div_ready ) reg_mag_rs2 <= 0; else if (!div_ready & div_en) reg_mag_rs2 <= mag_rs2;
    reg        reg_div_en  ; always@(posedge clk) if ( reset | div_ready ) reg_div_en  <= 0; else if (!div_ready & div_en) reg_div_en  <= div_en;
    
	wire div_pause = !div_ready & (div_en|reg_div_en) ;
	
	reg [2:0] wadd ;
	wire fifo_wen = div_en ;
    always@(posedge clk) begin
    	if      ( reset    ) wadd <= 0;
    	else if ( fifo_wen ) wadd <= wadd + 1 ;
    end
    
    reg [9:0] fifo [7:0];
    always@(posedge clk) begin
    	if ( fifo_wen ) fifo[wadd] <= div_data ;
    end
    
	wire        wire_div_en  = div_en | reg_div_en ;
	wire [31:0] wire_mag_rs1 = ( reg_div_en ) ? reg_mag_rs1 : mag_rs1 ;
	wire [31:0] wire_mag_rs2 = ( reg_div_en ) ? reg_mag_rs2 : mag_rs2 ;
	
    wire [32:0] div_q;
    wire [32:0] div_r;
    wire        div_vout;
    
	divu_radix8 inst_divu_radix (
	   .clk      ( clk          ),
	   .reset    ( reset        ),
	   .pause    ( pause        ),
	   .en       ( wire_div_en  ),
	   .divisor  ( {1'b0,wire_mag_rs2} ),
	   .dividend ( {1'b0,wire_mag_rs1} ),
	   .ready    ( div_ready    ),
	   .q        ( div_q        ),
	   .r        ( div_r        ),
	   .vout     ( div_vout     )
	);
	
    wire [31:0] quotient  = div_q[31:0] ;
    wire [31:0] remainder = div_r[31:0] ;
	
	// div32_radix16  inst_div32_radix16 (
	   // .clk   ( clk          ),
	   // .reset ( reset        ),
	   // .en    ( wire_div_en  ),
	   // .a     ( wire_mag_rs1 ),
	   // .b     ( wire_mag_rs2 ),
	   // .ready ( div_ready    ),
	   // .q     ( quotient     ),
	   // .r     ( remainder    ),
	   // .vout  ( div_vout     )
	// );
	
    reg [2:0] radd;
    always@(posedge clk) begin
    	if      ( reset    ) radd <= 0;
    	else if ( div_vout ) radd <= radd + 1;
    end
    
    wire [9:0] fifo_out = fifo[radd];
    
    wire [31:0] signed_quotient  = ( fifo_out[9] ) ? ( ~quotient  + 1'b1 ) : quotient ;
    wire [31:0] signed_remainder = ( fifo_out[8] ) ? ( ~remainder + 1'b1 ) : remainder;
    
    wire        div_rd_en   = div_vout ;
    wire [6:0]  div_rd_add  = fifo_out[6:0] ;
    wire [31:0] div_rd_data = ( fifo_out[7] ) ? signed_remainder : signed_quotient ;
	
//-------------------------------------------------------------------------------------//
//                                      Output
//-------------------------------------------------------------------------------------//
	
	wire md_pnc;
	
	three2one #(
   .WIDTH ( 39 )
	)  two2one_md (
	   .clk   ( clk       ),
	   .reset ( reset     ),
	   .pause ( pause     ),
	   .vdin1 ( macl_rd_en ),
	   .vdin2 ( mach_rd_en ),
	   .vdin3 ( div_rd_en ),
	   
	   .din1  ( {macl_rd_add, macl_rd_data} ),
	   .din2  ( {mach_rd_add, mach_rd_data} ),
	   .din3  ( {div_rd_add, div_rd_data} ),
	   
	  .vdout ( rd_en_md ),
	   .dout  ( {rd_add_md, rd_data_md} ),
	   .pnc   ( md_pnc )
	);
	
	assign md_pause_next = (wait_en==1'b1) ? 1'b0 : div_pause | md_pnc ;
endmodule

module ps_decode(
	input clk      ,
	input reset    ,
	input clear_de ,
	input clear_ex ,
//---------------------------------------------- Inputs
	input pinst,
	input [31:0] pc,
    input [31:0] instruction,
	input vinst,
	//------------------------------ Register bank
	input        wrd_en1   ,
	input [4:0]  wrd_add1  ,
	input [31:0] wrd_data1 ,
	input        wrd_en2   ,
	input [4:0]  wrd_add2  ,
	input [31:0] wrd_data2 ,
	
//---------------------------------------------- Output Signals
	
	output        branch  ,
	
	// output        jal     ,
	// output [31:0] jal_add ,
	
	output [31:0] rs1     ,
	output [31:0] rs2     ,
	output [31:0] data3   ,
	output [ 2:0] r_wait  ,
	output [ 5:0] r_tag   ,
	output [14:0] r_add   ,
	
	output [12:0] control,
	output [ 3:0] control2,
	output [ 7:0] fn
);

	wire        vout   = ( instruction != 0 );
	wire [31:0] pc_out = pc;
	
	wire [6:0] opcode = instruction[6:0]   ;
	wire [2:0] fun3   = instruction[14:12] ;
	wire [6:0] fun7   = instruction[31:25] ;

//-------------------------------------------------------------------------------------------------------//
//                                          Register control                                             //
//-------------------------------------------------------------------------------------------------------//
	wire clear_de1 = clear_de | clear_ex ;

	wire rs1_en = !clear_de1 & vinst & ( opcode==7'b1100111|opcode==7'b1100011|opcode==7'b0000011
	|                opcode==7'b0100011|opcode==7'b0010011|opcode==7'b0110011
	|              ( opcode==7'b1110011&(fun3==3'b001|fun3==3'b010|fun3==3'b011)) 
	|                opcode==7'b0001011 );	
	
	wire rs2_en = !clear_de1 & vinst & ( opcode==7'b1100011|opcode==7'b0100011|opcode==7'b0110011 | (opcode==7'b0001011 & fun7!=7'b0000010) );
	
	// wire rd_en = ( opcode==7'b0110111|opcode==7'b0010111|opcode==7'b1101111|opcode==7'b1100111
	// |                   opcode==7'b0000011|opcode==7'b0010011|opcode==7'b0110011|opcode==7'b1110011 );
	
	wire [4:0] rs1_add = instruction[19:15];
	wire [4:0] rs2_add = instruction[24:20];
	wire [4:0] rd_add  = instruction[11:7];

	// CSR signals
	wire [11:0] csr_imm = instruction[31:20];
	wire [ 4:0] csr_add = instruction[19:15];
	
//-------------------------------------------------------------------------------------------------------//
//                                            RV32I Decode                                               //
//-------------------------------------------------------------------------------------------------------//
	wire        rd_en_i     ;
	wire        rd_en_l     ;
	wire [2:0]  mem_wen     ;
	wire [2:0]  mem_ren     ;
	wire        i_branch    ;
	wire        jal         ;
	wire [31:0] jal_add     ;
	wire        lui         ;
	wire        jalr        ;
	wire        umload      ;
	wire [31:0] var1        ;
	wire [31:0] var2        ;
	wire        var2rs1     ;
	wire        var2rs2     ;
	wire [3:0]  control_csr ;
	wire [7:0]  control_alu ;
	
	rv32i  decode_rv32i ( 
	   .instruction     ( instruction   ),
	   .pc              ( pc            ),
	   .rd_en_i         ( rd_en_i       ),
	   .rd_en_l         ( rd_en_l       ),
	   .mem_wen         ( mem_wen       ),
	   .mem_ren         ( mem_ren       ),
	   .branch          ( i_branch      ),
	   .jal             ( jal           ),
	   .jal_add         ( jal_add       ),
	   .lui             ( lui           ),
	   .jalr            ( jalr          ),
	   .umload          ( umload        ),
	   
	   .var1            ( var1          ),
	   .var2            ( var2          ),
	   
	   .var2rs1         ( var2rs1       ),
	   .var2rs2         ( var2rs2       ),
	   
	   .control_csr     ( control_csr   ),
	   .control_alu     ( control_alu   )
	);

// //-------------------------------------------------------------------------------------------------------//
// //                                            MAC Decode                                               //
// //-------------------------------------------------------------------------------------------------------//
	// wire rd_en_mac = !clear_de1 & (opcode==7'b0001011) & (rd_add!=5'b00000);
	// wire mac_int   = !clear_de1 & (opcode==7'b0001011 & fun3==3'b000 & fun7==7'b0000001) ;
	// wire mac_en    = !clear_de1 & (opcode==7'b0001011 & fun3==3'b001 & fun7==7'b0000001) ;
	
	// wire [7:0] control_mac = mac_int ? 31 
	// :                        mac_en  ? 32 
	// :                                   0 ;
	
//-------------------------------------------------------------------------------------------------------//
//                                              MUL DIV   
//-------------------------------------------------------------------------------------------------------//
	wire mac_init ;
	wire rs1_sign ;
	wire rs2_sign ;
	wire rd_en_m  ;
	
	wire [7:0] control_md ;
	
	rv32m  inst_rv32m (
	   .instruction ( instruction ),
	   .mac_init    ( mac_init    ),
	   .rs1_sign    ( rs1_sign    ),
	   .rs2_sign    ( rs2_sign    ),
	   .rd_en       ( rd_en_m     ),
	   .control_md  ( control_md  )
	);
	
	wire rd_en = !clear_de1 & vinst & ( rd_en_i | rd_en_l | rd_en_m ) ;
	
//-------------------------------------------------------------------------------------//
//                                  Register Bank                                      //
//-------------------------------------------------------------------------------------//
	
	wire        rs1_wait ;
	wire        rs2_wait ;
	wire        rd_wait  ;
	wire [1:0]  rs1_tag  ;
	wire [1:0]  rs2_tag  ;
	wire [1:0]  rd_tag   ;
	
	wire [31:0] rb_rs1;
	wire [31:0] rb_rs2;
	
	reg_bank  RB (
	   .clk        ( clk   ),
	   .reset      ( reset ),
	   .clear_de   ( clear_ex ),
	   //---------------------------- Write channel
	   .wrd_en1    ( wrd_en1    ),
	   .wrd_add1   ( wrd_add1   ),
	   .wrd_data1  ( wrd_data1  ),
	   .wrd_en2    ( wrd_en2    ),
	   .wrd_add2   ( wrd_add2   ),
	   .wrd_data2  ( wrd_data2  ),
	   //---------------------------- Read channel
	   .rs1_add    ( rs1_add    ),
	   .rs1_en     ( rs1_en     ),
	   .rs2_add    ( rs2_add    ),
	   .rs2_en     ( rs2_en     ),
	   .rd_add     ( rd_add     ),
	   .rd_en      ( rd_en      ),
	   //---------------------------- output data
	   .rs1_data   ( rb_rs1     ),
	   .rs2_data   ( rb_rs2     ),
	   .rs1_wait   ( rs1_wait   ),
	   .rs2_wait   ( rs2_wait   ),
	   .rd_wait    ( rd_wait    ),
	   .rs1_tag    ( rs1_tag    ),
	   .rs2_tag    ( rs2_tag    ),
	   .rd_tag     ( rd_tag     )
	);
//-------------------------------------------------------------------------------------------------------//
//                                            Outputs
//-------------------------------------------------------------------------------------------------------//
	
	wire pfalse = vinst & pinst & !i_branch & !jalr & !jal ;
	wire rd_en_0clk = rd_en_i ;
	
	// wire jal = vinst & i_jal ;
	
	// assign jal_add = i_jal ? i_jal_add
	// :                        pc+4 ; 
	
	assign branch = vinst & i_branch ;
	
	assign rs1 = var2rs1 ? var1 
	:                      rb_rs1 ;
	
	assign rs2 = var2rs2      ? var2 
	:                           rb_rs2 ;
	
	assign data3 = ( control_csr != 0 ) ? { 15'd0, csr_imm, csr_add }
	:                                     var2;
	
	assign r_wait = vinst ? { rd_wait, rs2_wait, rs1_wait } : 0 ;
	
	assign r_tag  = { rd_tag,  rs2_tag,  rs1_tag  } ;
	assign r_add  = { rd_add,  rs2_add,  rs1_add  } ;
	
	assign fn = vinst ? ( control_alu | control_md ) : 0 ;
	
	assign control2 = vinst ? { 1'b0, mac_init, rs1_sign, rs2_sign } : 0 ;
	
	assign control = vinst ? { pfalse, jal, rd_en, umload, jalr, rd_en_0clk, mem_ren[2:0], mem_wen[2:0], vout } : 0 ;
	
	
endmodule


module ps_execute(
		input clk,
		input reset,
		input pause,
		input dbp_clear_ex,
		
		input [31:0] pc      ,
		input        branch  ,
		input [31:0] rs1     ,
		input [31:0] rs2     ,
		input [31:0] data3   ,
		input [ 1:0] rd_tag  ,
		input [ 4:0] rd_add  ,
		input [12:0] control ,
		input [ 3:0] control2,
		input [ 7:0] fn      ,
		
		// input [ 4:0] fps_controller,
		// input [31:0] fps_rs1       ,
		// input [31:0] fps_rs2       ,
		// input [ 2:0] fps_r_wait    ,
		// input [ 1:0] fps_rd_tag    ,
		// input [04:0] fps_rd_add    ,
    //----------------------------------------- output signals
		output        ex_branch   ,
		output        ex_jalr     ,
		output [31:0] ex_jalr_add ,
		
		output [2:0]  ex_mem_ren    ,
		output [31:0] ex_mem_radd   ,
		output [6:0]  ex_mem_rd_add ,
		output [2:0]  ex_mem_wen    ,
		output [31:0] ex_mem_wadd   ,
		output [31:0] ex_mem_wdata  ,
	//----------------------------------------- outputs for next stage
		output        ex_rd_en   ,
		output [6:0]  ex_rd_add  ,
		output [31:0] ex_rd_data ,
        
        output        md_rd_en   ,
        output [6:0]  md_rd_add  ,
		output [31:0] md_rd_data ,
        input [31:0] din1_aes,
	    input [31:0] din2_aes,
	    input [3:0]  control_aes,
	    input wait_en,
	    output [31:0] dout_aes,
		input [31:0] din1_aesmul,
		input [7:0] fn_aes,
		input Dvld,
        // output        fps_ex_rd_en   ,
        // output [6:0]  fps_ex_rd_add  ,
		// output [31:0] fps_ex_rd_data ,
	//----------------------------------------- pause signal
		output        ex_pause
    );
	
	wire        vin         ;
	wire [2:0]  mem_wen     ;
	wire [2:0]  mem_ren     ;
	wire [3:0]  control_csr ;
	wire        jalr        ;
	wire        rd_en_i     ;
	
	assign { jalr, rd_en_i }    = control[8:7] ;
	assign { mem_ren, mem_wen } = control[6:1] ;
	assign { vin }              = control[0]   ;
	
	wire [6:0] rd_add_tag = { rd_tag, rd_add };
	
//-------------------------------------------------------------------------------------//
//                                         CSR
//-------------------------------------------------------------------------------------//
	
	wire [11:0] csr_imm = data3[16:5] ;
	wire [4:0]  csr_add = data3[ 4:0] ; 
	
	wire csr_i  = ( fn == 8'h12 ) ;
	wire csr_rw = ( fn == 8'h13 ) ;
	wire csr_rs = ( fn == 8'h14 ) ;
	wire csr_rc = ( fn == 8'h15 ) ;
	
	wire [31:0] csr_wdata   = ( csr_i ) ? { 27'd0, csr_add } : rs1  ;
	
	wire [31:0] csr_rdata;
	wire        csr_vrdata;
	
	CSR  inst_csr (
	   .clk            ( clk        ),
	   .reset          ( reset      ),
	   .ins_counter_up ( vin        ),
	   .imm            ( csr_imm    ),
	   .rdata          ( csr_rdata  ),
	   .vrdata         ( csr_vrdata ),
	   .wdata          ( csr_wdata  ),
	   .rw             ( csr_rw     ),
	   .rs             ( csr_rs     ),
	   .rc             ( csr_rc     )
	);
	
//-------------------------------------------------------------------------------------//
//                                       ALU
//-------------------------------------------------------------------------------------//
	wire [31:0] alu_in1 = rs1 ;
	wire [31:0] alu_in2 = rs2 ;
	
	// wire [3:0]  control_alu = ( fn[7:4] == 4'd0 ) ? fn[3:0] : 4'd0 ;
	wire [7:0]  control_alu = fn[7:0] ;

	wire [31:0] alu_out;
	
	ALU inst_ALU(
        .clk         ( clk         ),
        .reset       ( reset       ),
        .pause       ( pause       ),
        .din1        ( alu_in1     ),
		.din2        ( alu_in2     ),
		.din1_aes    ( din1_aes    ),
		.din2_aes    ( din2_aes    ),
        .control     ( control_alu ),
        .control_aes ( control_aes ), 
		.dout        ( alu_out     ),
		.dout_aes    ( dout_aes    ),
		.wait_en     ( wait_en     )
    );

//-------------------------------------------------------------------------------------//
//                                      MUL-DIV
//-------------------------------------------------------------------------------------//
    
	wire [7:0] fn_md = dbp_clear_ex ? 0 : fn ;
	
	wire md_pause_next;
	wire [31:0] wire_md_rd_data;
    wire [6:0]  wire_md_rd_add ;
    wire        wire_md_vrd    ;
	
	mul_div  inst_mul_div (
	   .clk            ( clk            ),
	   .rst            ( reset          ),
	   .pause          ( pause          ),
	   .rs1            ( rs1            ),
	   .rs2            ( rs2            ),
	   .in_rd_add      ( rd_add_tag     ),
	   .fn             ( fn_md          ),
	   .control2       ( control2[2:0]  ),
	   .rs1_aes        ( din1_aesmul    ),
	   .fn_aes         ( fn_aes         ),
	   .wait_en        ( wait_en        ),
	   .Dvld           ( Dvld           ),
	   // output
	   .rd_en      ( wire_md_vrd     ),
	   .rd_add     ( wire_md_rd_add  ),
	   .rd_data    ( wire_md_rd_data ),
	   .md_pause_next ( md_pause_next   )
	);
	
	assign md_rd_en   = wire_md_vrd     ;
	assign md_rd_add  = wire_md_rd_add  ;
	assign md_rd_data = wire_md_rd_data ;
	
//-------------------------------------------------------------------------------------//
//                                      output
//-------------------------------------------------------------------------------------//
	
	wire [31:0] next_pc = pc + 4;
	
	wire lui = ( fn == 8'h0f ) ;
	wire jal = ( fn == 8'h10 ) ;
	
	wire [31:0] ex_rd_data1 = ( jalr | jal ) ? next_pc
	:                         ( lui        ) ? data3 
	:                         ( csr_vrdata ) ? csr_rdata 
	:                                          alu_out ;

	wire branch_correct = branch & !dbp_clear_ex ;
	
	wire pfalse = control[12] ;
	
	assign ex_jalr     = !dbp_clear_ex & jalr ;
	assign ex_branch   = branch_correct & alu_out[0] ;
	assign ex_jalr_add = jalr      ? { alu_out[31:1], 1'b0 } 
	:                    ex_branch ? data3 
	:                    branch    ? next_pc
	:                    pfalse    ? next_pc
	:                                data3 ;
	
	wire [31:0] adder_dout = (rs1 + data3) ;
	
	assign ex_mem_ren    = dbp_clear_ex ? 0 : mem_ren ;
	assign ex_mem_radd   = adder_dout ;
	assign ex_mem_rd_add = rd_add_tag ;
	assign ex_mem_wen    = dbp_clear_ex ? 0 : mem_wen ;
	assign ex_mem_wadd   = adder_dout ;
	assign ex_mem_wdata  = (mem_wen==1) ?  {rs2[7:0],rs2[7:0],rs2[7:0],rs2[7:0]}
	:                      (mem_wen==2) ?  {rs2[15:0],rs2[15:0]}
	:                                      rs2    ; 
	
	assign ex_rd_en   = rd_en_i ;
	assign ex_rd_add  = rd_add_tag  ;
	assign ex_rd_data = ex_rd_data1 ;
	
	// wire fps_pnc;
	// fps_execution  inst_fps_execution (
	   // .clk            ( clk            ),
	   // .reset          ( reset          ),
	   // .fps_controller ( fps_controller ),
	   // .fps_rs1        ( fps_rs1        ),
	   // .fps_rs2        ( fps_rs2        ),
	   // .fps_r_wait     ( fps_r_wait     ),
	   // .fps_rd_tag     ( fps_rd_tag     ),
	   // .fps_rd_add     ( fps_rd_add     ),
	   
	   // .fps_ex_rd_data ( fps_ex_rd_data ),
	   // .fps_ex_rd_add  ( fps_ex_rd_add  ),
	   // .fps_ex_rd_en   ( fps_ex_rd_en   ),
	   // .fps_pnc        ( fps_pnc        ) 
	// );
	
	
//-------------------------------------------------------------------------------------//
//                                      Pause
//-------------------------------------------------------------------------------------//
	// reg reg_ex_pause; always@(posedge clk) if (reset) reg_ex_pause <= 0; else reg_ex_pause <= (fps_pnc | md_pause_next) ;
	reg reg_ex_pause; always@(posedge clk) if (reset) reg_ex_pause <= 0; else reg_ex_pause <= md_pause_next ;
	assign ex_pause = reg_ex_pause ;
	
endmodule

module reg_bank(
		input clk,
		input reset,
		input clear_de,
		//--------------------------- Write channel
		input        wrd_en1,
        input [4:0]  wrd_add1,
        input [31:0] wrd_data1,
		input        wrd_en2,
        input [4:0]  wrd_add2,
        input [31:0] wrd_data2,
		//--------------------------- Read channel
		input  [4:0]  rs1_add,
		input         rs1_en,
		input  [4:0]  rs2_add,
		input         rs2_en,
		input  [4:0]  rd_add,
		input         rd_en,
		//--------------------------- Outputs
		output [31:0] rs1_data,
		output [31:0] rs2_data,
		output        rs1_wait,
		output        rs2_wait,
		output        rd_wait ,
		output [ 1:0] rs1_tag ,
		output [ 1:0] rs2_tag ,
		output [ 1:0] rd_tag  
    );

	reg [31:0] mem [0:31];
	
// ---------------		Write Channel		-------------------- //	
	
	wire vwrd_en1 = wrd_en1 & wrd_add1!=0 ; 
	wire vwrd_en2 = wrd_en2 & wrd_add2!=0 ; 
	
	always@(posedge clk) begin
        if ( reset ) begin			
			mem[00] <= 32'd0; mem[01] <= 32'd0; mem[02] <= 32'h0002f000; mem[03] <= 32'd0; 
			mem[04] <= 32'd0; mem[05] <= 32'd0; mem[06] <= 32'd0; mem[07] <= 32'd0; 
			mem[08] <= 32'd0; mem[09] <= 32'd0; mem[10] <= 32'd0; mem[11] <= 32'd0; 
			mem[12] <= 32'd0; mem[13] <= 32'd0; mem[14] <= 32'd0; mem[15] <= 32'd0; 
			mem[16] <= 32'd0; mem[17] <= 32'd0; mem[18] <= 32'd0; mem[19] <= 32'd0; 
			mem[20] <= 32'd0; mem[21] <= 32'd0; mem[22] <= 32'd0; mem[23] <= 32'd0; 
			mem[24] <= 32'd0; mem[25] <= 32'd0; mem[26] <= 32'd0; mem[27] <= 32'd0; 
			mem[28] <= 32'd0; mem[29] <= 32'd0; mem[30] <= 32'd0; mem[31] <= 32'd0; 
		end else if (!(vwrd_en1 & vwrd_en2 & wrd_add1==wrd_add2)) begin
			if (vwrd_en1) mem[wrd_add1] <= wrd_data1;
			if (vwrd_en2) mem[wrd_add2] <= wrd_data2;
		end
    end
	
// ---------------		Read Channel		--------------------//
	
	reg [2:0] reg_rd_count [31:0] ;
	
	wire vrs1_en = rs1_en & rs1_add!=0 ;
	wire vrs2_en = rs2_en & rs2_add!=0 ;
	wire vrd_en  = rd_en  & rd_add!=0  ;
	
	wire rs1_wready1 = vrs1_en & wrd_en1 & wrd_add1==rs1_add & (reg_rd_count[rs1_add] == 1) ;
	wire rs2_wready1 = vrs2_en & wrd_en1 & wrd_add1==rs2_add & (reg_rd_count[rs2_add] == 1) ;
	wire rd_wready1  = vrd_en  & wrd_en1 & wrd_add1==rd_add  & (reg_rd_count[rd_add]  == 1) ;
	
	wire rs1_wready2 = vrs1_en & wrd_en2 & wrd_add2==rs1_add & (reg_rd_count[rs1_add] == 1) ;
	wire rs2_wready2 = vrs2_en & wrd_en2 & wrd_add2==rs2_add & (reg_rd_count[rs2_add] == 1) ;
	wire rd_wready2  = vrd_en  & wrd_en2 & wrd_add2==rd_add  & (reg_rd_count[rd_add]  == 1) ;
	
	always@(posedge clk) begin
		if ( reset | clear_de ) begin
			reg_rd_count[00] <= 0;   reg_rd_count[01] <= 0;   reg_rd_count[02] <= 0;   reg_rd_count[03] <= 0;
			reg_rd_count[04] <= 0;   reg_rd_count[05] <= 0;   reg_rd_count[06] <= 0;   reg_rd_count[07] <= 0;
			reg_rd_count[08] <= 0;   reg_rd_count[09] <= 0;   reg_rd_count[10] <= 0;   reg_rd_count[11] <= 0;
			reg_rd_count[12] <= 0;   reg_rd_count[13] <= 0;   reg_rd_count[14] <= 0;   reg_rd_count[15] <= 0;
			reg_rd_count[16] <= 0;   reg_rd_count[17] <= 0;   reg_rd_count[18] <= 0;   reg_rd_count[19] <= 0;
			reg_rd_count[20] <= 0;   reg_rd_count[21] <= 0;   reg_rd_count[22] <= 0;   reg_rd_count[23] <= 0;
			reg_rd_count[24] <= 0;   reg_rd_count[25] <= 0;   reg_rd_count[26] <= 0;   reg_rd_count[27] <= 0;
			reg_rd_count[28] <= 0;   reg_rd_count[29] <= 0;   reg_rd_count[30] <= 0;   reg_rd_count[31] <= 0;
		// end else if ( !(vrd_en & wrd_en1 & wrd_add1==rd_add) & !(vrd_en & wrd_en2 & wrd_add2==rd_add) ) begin 
		end else begin 
			if ( vrd_en & !(wrd_en1 & wrd_add1==rd_add & reg_rd_count[rd_add]!=0) & !(wrd_en2 & wrd_add2==rd_add & reg_rd_count[rd_add]!=0) ) reg_rd_count[rd_add] <= reg_rd_count[rd_add] + 1'b1;
			
			if ( wrd_en1 & reg_rd_count[wrd_add1]!=0 & !(vrd_en & wrd_add1==rd_add) ) reg_rd_count[wrd_add1] <= reg_rd_count[wrd_add1] - 1'b1;
			if ( wrd_en2 & reg_rd_count[wrd_add2]!=0 & !(vrd_en & wrd_add2==rd_add) ) reg_rd_count[wrd_add2] <= reg_rd_count[wrd_add2] - 1'b1;
		end
	end
	
	// wire [31:0] rready = reg_rd_count;
	
	wire rs1_ready = ( reg_rd_count[rs1_add] != 0 ) ? 1'b0 : 1'b1 ;
	wire rs2_ready = ( reg_rd_count[rs2_add] != 0 ) ? 1'b0 : 1'b1 ;
	wire  rd_ready = ( reg_rd_count[rd_add]  != 0 ) ? 1'b0 : 1'b1 ;
	
	assign rs1_wait = ( vrs1_en & !rs1_ready & !rs1_wready1 & !rs1_wready2 ) ? 1'b1 : 1'b0 ;
	assign rs2_wait = ( vrs2_en & !rs2_ready & !rs2_wready1 & !rs2_wready2 ) ? 1'b1 : 1'b0 ;
	assign rd_wait  = ( vrd_en  & !rd_ready  & !rd_wready1  & !rd_wready2  ) ? 1'b1 : 1'b0 ;
	
	assign rs1_data = ( vrs1_en & wrd_en1 & wrd_add1==rs1_add ) ? wrd_data1 : ( vrs1_en & wrd_en2 & wrd_add2==rs1_add ) ? wrd_data2 : mem[rs1_add];
	assign rs2_data = ( vrs2_en & wrd_en1 & wrd_add1==rs2_add ) ? wrd_data1 : ( vrs2_en & wrd_en2 & wrd_add2==rs2_add ) ? wrd_data2 : mem[rs2_add];
	
	reg [1:0] reg_tag_count [31:0] ;
	always@(posedge clk) begin
		if ( reset ) begin
			reg_tag_count[00] <= 0;   reg_tag_count[01] <= 0;   reg_tag_count[02] <= 0;   reg_tag_count[03] <= 0;
			reg_tag_count[04] <= 0;   reg_tag_count[05] <= 0;   reg_tag_count[06] <= 0;   reg_tag_count[07] <= 0;
			reg_tag_count[08] <= 0;   reg_tag_count[09] <= 0;   reg_tag_count[10] <= 0;   reg_tag_count[11] <= 0;
			reg_tag_count[12] <= 0;   reg_tag_count[13] <= 0;   reg_tag_count[14] <= 0;   reg_tag_count[15] <= 0;
			reg_tag_count[16] <= 0;   reg_tag_count[17] <= 0;   reg_tag_count[18] <= 0;   reg_tag_count[19] <= 0;
			reg_tag_count[20] <= 0;   reg_tag_count[21] <= 0;   reg_tag_count[22] <= 0;   reg_tag_count[23] <= 0;
			reg_tag_count[24] <= 0;   reg_tag_count[25] <= 0;   reg_tag_count[26] <= 0;   reg_tag_count[27] <= 0;
			reg_tag_count[28] <= 0;   reg_tag_count[29] <= 0;   reg_tag_count[30] <= 0;   reg_tag_count[31] <= 0;
		// end else if ( !(vrd_en & wrd_en1 & wrd_add1==rd_add) & !(vrd_en & wrd_en2 & wrd_add2==rd_add) ) begin 
		end else begin 
			if ( vrd_en ) reg_tag_count[rd_add] <= reg_tag_count[rd_add] + 1'b1;
		end
	end
	
	assign rs1_tag = reg_tag_count[rs1_add] ;
	assign rs2_tag = reg_tag_count[rs2_add] ;
	assign rd_tag  = reg_tag_count[rd_add]  ;
	
// // ---------------		Reg Status Write (Simulation Only)	-------------------- //
	
	// reg_status_write  inst_reg_status_write (
	   // .clk        ( clk        ),
	   // .reset      ( reset      ),
	   // .wrd_en1    ( wrd_en1    ),
	   // .wrd_add1   ( wrd_add1   ),
	   // .wrd_en2    ( wrd_en2    ),
	   // .wrd_add2   ( wrd_add2   ),
	   // .rd_en_all  ( sim_rd_en  ),
	   // .rd_add_all ( sim_rd_add ),
	   // .pc         ( sim_pc     ),
	   // .mem_wen    ( mem_wen    ),
	   // .mem_wadd   ( mem_wadd   ),
	   // .mem_wdata  ( mem_wdata  ),
	   // .mem00      ( mem[00]   ),	   .mem01      ( mem[01]   ),	   .mem02      ( mem[02]   ),	   .mem03      ( mem[03]   ),
	   // .mem04      ( mem[04]   ),	   .mem05      ( mem[05]   ),	   .mem06      ( mem[06]   ),	   .mem07      ( mem[07]   ),
	   // .mem08      ( mem[08]   ),	   .mem09      ( mem[09]   ),	   .mem10      ( mem[10]   ),	   .mem11      ( mem[11]   ),
	   // .mem12      ( mem[12]   ),	   .mem13      ( mem[13]   ),	   .mem14      ( mem[14]   ),	   .mem15      ( mem[15]   ),
	   // .mem16      ( mem[16]   ),	   .mem17      ( mem[17]   ),	   .mem18      ( mem[18]   ),	   .mem19      ( mem[19]   ),
	   // .mem20      ( mem[20]   ),	   .mem21      ( mem[21]   ),	   .mem22      ( mem[22]   ),	   .mem23      ( mem[23]   ),
	   // .mem24      ( mem[24]   ),	   .mem25      ( mem[25]   ),	   .mem26      ( mem[26]   ),	   .mem27      ( mem[27]   ),
	   // .mem28      ( mem[28]   ),	   .mem29      ( mem[29]   ),	   .mem30      ( mem[30]   ),	   .mem31      ( mem[31]   )
	// );
	
endmodule

module reg_write(
	input clk,
	input reset,
	
	input        rd_en1,
	input [6:0]  rd_add1,
	input [31:0] rd_data1,      
	
	input        rd_en2,
	input [6:0]  rd_add2,
	input [31:0] rd_data2,
	
	input        rd_en3,
	input [6:0]  rd_add3,
	input [31:0] rd_data3,
	
//******** output signals **********//
	output        wrd_en1,
	output [6:0]  wrd_add1,
	output [31:0] wrd_data1,
	
	output        wrd_en2,
	output [6:0]  wrd_add2,
	output [31:0] wrd_data2,
	
	output oc_pause
	);
	
	wire reg_wen = rd_en1 & rd_en2 & rd_en3;
	wire reg_clear = (rd_en1 & !rd_en2 & !rd_en3) | (!rd_en1 & rd_en2 & !rd_en3) | (!rd_en1 & !rd_en2 & rd_en3) | (!rd_en1 & !rd_en2 & !rd_en3) ;
	
	reg        reg_rd_en  ; 
	reg [6:0]  reg_rd_add ; 
	reg [31:0] reg_rd_data; 
	
	always@(posedge clk) begin
		if      ( reset     ) { reg_rd_en, reg_rd_add, reg_rd_data } <= { 1'd0, 7'd0, 32'd0 };
		else if ( reg_wen   ) { reg_rd_en, reg_rd_add, reg_rd_data } <= { rd_en3, rd_add3, rd_data3 };
		else if ( reg_clear ) { reg_rd_en, reg_rd_add, reg_rd_data } <= { 1'd0, 7'd0, 32'd0 };
		
	end
	
	wire wire_oc_pause = ( rd_en1 & rd_en2 & rd_en3 ) ;
	
	reg reg_oc_pause; always@(posedge clk) if(reset) reg_oc_pause <= 0; else reg_oc_pause <= wire_oc_pause;
	
//-------------------------------------------------------------------------------------//
//                                     outputs
//-------------------------------------------------------------------------------------//
	
	assign wrd_en1 = rd_en1 | rd_en2 | rd_en3 | reg_rd_en;
	assign {wrd_add1, wrd_data1} = (rd_en1   ) ? {rd_add1, rd_data1}
	:                              (rd_en2   ) ? {rd_add2, rd_data2}
	:                              (rd_en3   ) ? {rd_add3, rd_data3}
	:                              (reg_rd_en) ? {reg_rd_add, reg_rd_data}
	:                              39'd0;
	
	wire en1 = rd_en1 & rd_en2;
	wire en2 = (rd_en1 | rd_en2) & rd_en3;
	wire en3 = (rd_en1 | rd_en2 | rd_en3) & reg_rd_add;
	
	assign wrd_en2 = en1 | en2 | en3 ;
	assign {wrd_add2, wrd_data2} = (en1) ? {rd_add2, rd_data2}
	:                              (en2) ? {rd_add3, rd_data3}
	:                              (en3) ? {reg_rd_add, reg_rd_data}
	:                              39'd0;

	assign oc_pause = reg_oc_pause;
	
endmodule
module rv32i(
        input [31:0] instruction,
        input [31:0] pc,
		
		output rd_en_i,
		output rd_en_l,
		// memory signals
		output [2:0] mem_wen,
		output [2:0] mem_ren,
		// branch signals
		output jal,
		output [31:0] jal_add,
		output lui,
		output jalr,
		output branch,
		output umload,
		// data signals
		output [31:0] var1,
		output [31:0] var2,
		// variable
		output var2rs1,
		output var2rs2,
		
		output [3:0] control_csr,
		output [7:0] control_alu
    );
	
	wire [6:0] opcode = instruction[6:0];
    wire [2:0] fun3 = instruction[14:12];
    wire [6:0] fun7 = instruction[31:25];

//-------------------------------------------------------------------------------------------------------//
//                                            Immediates
//-------------------------------------------------------------------------------------------------------//
	// Immediate signals
    wire [11:0] imm_I = instruction[31:20];
    wire [11:0] imm_S = {instruction[31:25],instruction[11:7]};
    wire [11:0] imm_B = {instruction[31],instruction[7],instruction[30:25],instruction[11:8]};
	wire [19:0] imm_U = {instruction[31:12]};
	wire [19:0] imm_J = {instruction[31],instruction[19:12],instruction[20],instruction[30:21]};
	
////////    LUI, AUIPC, JAL, JALR    ////////
	wire   auipc = (opcode==7'b0010111);
    assign lui   = (opcode==7'b0110111);
    assign jal   = (opcode==7'b1101111);
    assign jalr  = (opcode==7'b1100111 & fun3==3'b000);
	
////////    BEQ, BNE, BLT, BGE, BLTU, BGEU    ////////
    wire beq  = (opcode==7'b1100011 & fun3==3'b000);
    wire bne  = (opcode==7'b1100011 & fun3==3'b001);
    wire blt  = (opcode==7'b1100011 & fun3==3'b100);
    wire bge  = (opcode==7'b1100011 & fun3==3'b101);
    wire bltu = (opcode==7'b1100011 & fun3==3'b110);
    wire bgeu = (opcode==7'b1100011 & fun3==3'b111);
	
////////    LB, LH, LW, LBU, LHU    ////////
    wire lb  = (opcode==7'b0000011 & fun3==3'b000);
    wire lh  = (opcode==7'b0000011 & fun3==3'b001);
    wire lw  = (opcode==7'b0000011 & fun3==3'b010);
    wire lbu = (opcode==7'b0000011 & fun3==3'b100);
    wire lhu = (opcode==7'b0000011 & fun3==3'b101);
	
////////    SB, SH, SW    ////////
    wire sb = (opcode==7'b0100011 & fun3==3'b000);
    wire sh = (opcode==7'b0100011 & fun3==3'b001);
    wire sw = (opcode==7'b0100011 & fun3==3'b010);
	
////////    ADDI, SLTI, SLTIU, XORI, ORI, ANDI    ////////
    wire addi  = (opcode==7'b0010011 & fun3==3'b000);
    wire slti  = (opcode==7'b0010011 & fun3==3'b010);
    wire sltiu = (opcode==7'b0010011 & fun3==3'b011);
    wire xori  = (opcode==7'b0010011 & fun3==3'b100);
    wire ori   = (opcode==7'b0010011 & fun3==3'b110);
    wire andi  = (opcode==7'b0010011 & fun3==3'b111);
	
////////    SLLI, SRLI, SRAI    ////////
    wire slli = (opcode==7'b0010011 & fun3==3'b001 & fun7==7'b0000000);
    wire srli = (opcode==7'b0010011 & fun3==3'b101 & fun7==7'b0000000);
    wire srai = (opcode==7'b0010011 & fun3==3'b101 & fun7==7'b0100000);
	
////////    ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND    ////////
    wire add  = (opcode==7'b0110011 & fun7==7'b0000000 & fun3==3'b000);
    wire sub  = (opcode==7'b0110011 & fun7==7'b0100000 & fun3==3'b000);
    wire sll  = (opcode==7'b0110011 & fun7==7'b0000000 & fun3==3'b001);
    wire slt  = (opcode==7'b0110011 & fun7==7'b0000000 & fun3==3'b010);
    wire sltu = (opcode==7'b0110011 & fun7==7'b0000000 & fun3==3'b011);
    wire xor2 = (opcode==7'b0110011 & fun7==7'b0000000 & fun3==3'b100);
    wire srl  = (opcode==7'b0110011 & fun7==7'b0000000 & fun3==3'b101);
    wire sra  = (opcode==7'b0110011 & fun7==7'b0100000 & fun3==3'b101);
    wire or2  = (opcode==7'b0110011 & fun7==7'b0000000 & fun3==3'b110);
    wire and2 = (opcode==7'b0110011 & fun7==7'b0000000 & fun3==3'b111);
	
////////    FENCE, FENCE.I    ////////
    wire fence  = (opcode==7'b0001111 & fun3==3'b000 & fun7==7'b0000000);
    wire fencei = (instruction==32'h000100f);
	
////////    ECALL, EBREAK    ////////
    wire ecall  = (instruction==32'h0000073);
    wire ebreak = (instruction==32'h0010073);
	
////////    CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI    ////////
    wire csrrw  = (opcode==7'b1110011 & fun3==3'b001);
    wire csrrs  = (opcode==7'b1110011 & fun3==3'b010);
    wire csrrc  = (opcode==7'b1110011 & fun3==3'b011);
    wire csrrwi = (opcode==7'b1110011 & fun3==3'b101);
    wire csrrsi = (opcode==7'b1110011 & fun3==3'b110);
    wire csrrci = (opcode==7'b1110011 & fun3==3'b111);
	
//****************************    Input Control Signals    *******************************//
	// temporary signals
	wire load  = lb | lbu | lh | lhu | lw;
	wire store = sw | sh | sb;
	// control signals
	assign branch = beq | bne | blt | bge | bltu | bgeu;
	assign umload = lhu | lbu;
	// memory signals
	assign mem_wen  = { sw, sh, sb };
	assign mem_ren  = { lw, ( lh | lhu ), ( lb | lbu ) };
	// alu signals
	wire alu_in2_I  = addi | xori | ori | andi | load | jalr;
	wire alu_in2_S  = store;
	// wire alu_in2_S  = store;
	wire alu_in2_B  = 0;
	wire alu_in2_J  = 0;
	wire alu_in2_U  = auipc;
	wire alu_add    = add | addi | auipc | jalr | store | load ;
	wire alu_sub    = sub;
	wire alu_xor    = xor2 | xori;
	wire alu_or     = or2  | ori;
	wire alu_and    = and2 | andi;
	// shift signals
	wire shift_operand_I = slli | srli | srai ;
	wire shift_left      = sll | slli ;
	wire shift_right     = srl | srli ;
	wire shift_aright    = sra | srai ;
	// comparator signals
	wire comp_in2_I   = (slti | sltiu);
	wire comp_equal   = beq;
	wire comp_nequal  = bne;
	wire comp_gequal  = bge;
	wire comp_lesser  = blt | slt | slti ;
	wire comp_ugequal = bgeu;
	wire comp_ulesser = bltu | sltu | sltiu ;
	// CSR signals
	wire csr_i  = csrrwi | csrrsi | csrrci ;
	wire csr_rw = csrrw  | csrrwi ;
	wire csr_rs = csrrs  | csrrsi ;
	wire csr_rc = csrrc  | csrrci ;
	
	//------------------------------------------------------- Adder
	
	// wire [31:0] adder_var = ( jal    ) ? { {11{imm_J[19]}}, imm_J, 1'b0 } 
	// :                       ( branch ) ? { {19{imm_B[11]}}, imm_B, 1'b0 } 
	// :                                    32'd0 ; 
	
	// wire [31:0] adder_dout = pc + adder_var;
	
	
	wire [31:0] adder_branch = pc + { {19{imm_B[11]}}, imm_B, 1'b0 } ;
	
	// wire [31:0] adder_dout = ( jal    ) ? adder_var1
	// :                        ( branch ) ? adder_var2
	// :                                     32'd0 ;
	
	//------------------------------------------------------- Outputs
	
	assign var1 = auipc ? pc
	:                     32'd0 ;
	
	
	wire var2_I = alu_in2_I | shift_operand_I | comp_in2_I ;
	wire var2_S = alu_in2_S ;
	wire var2_B = alu_in2_B ;
	wire var2_J = alu_in2_J ;
	wire var2_U = alu_in2_U | lui ;
	assign var2 = var2_I ? { {20{imm_I[11]}}, imm_I } 
	:             var2_S ? { {20{imm_S[11]}}, imm_S } 
	:             var2_B ? { {19{imm_B[11]}}, imm_B, 1'b0 } 
	:             var2_J ? { {11{imm_J[19]}}, imm_J, 1'b0 } 
	:             var2_U ? { imm_U, 12'h000 } 	
	:             jal    ? jal_add
	:             branch ? adder_branch
	: 			           32'd0;
	
	assign control_csr   = {csr_i,csr_rw,csr_rs,csr_rc};
//---------------------------------------------------------------- outputs
	
	assign jal_add = pc + { {11{imm_J[19]}}, imm_J, 1'b0 } ;
	
	assign rd_en_i = lui|auipc|jal|jalr|add|addi|sub|alu_xor|alu_or|alu_and|shift_left|shift_right|shift_aright|slt|sltu|slti|sltiu|csr_rs|csr_rw|csr_rc;
	assign rd_en_l = load;
	
	assign var2rs1 = auipc | jal ;
	assign var2rs2 = alu_in2_I | alu_in2_B | alu_in2_J | alu_in2_U | shift_operand_I | comp_in2_I ;
	
	assign control_alu = ( alu_add      ) ? 8'h01
	:	                 ( alu_sub      ) ? 8'h02
	:	                 ( alu_xor      ) ? 8'h03
	:	                 ( alu_or       ) ? 8'h04
	:	                 ( alu_and      ) ? 8'h05
	:	                 ( comp_equal   ) ? 8'h06
	:	                 ( comp_nequal  ) ? 8'h07
	:	                 ( comp_lesser  ) ? 8'h08
	:	                 ( comp_gequal  ) ? 8'h09
	:	                 ( comp_ulesser ) ? 8'h0a
	:	                 ( comp_ugequal ) ? 8'h0b
	:	                 ( shift_left   ) ? 8'h0c
	:	                 ( shift_right  ) ? 8'h0d
	:	                 ( shift_aright ) ? 8'h0e
	:	                 ( lui          ) ? 8'h0f
	:	                 ( jal          ) ? 8'h10
	:	                 ( csr_i        ) ? 8'h12
	:	                 ( csr_rw       ) ? 8'h13
	:	                 ( csr_rs       ) ? 8'h14
	:	                 ( csr_rc       ) ? 8'h15
	:	                                     0 ;
	
	
endmodule


module rv32m(
        input [31:0] instruction,
		
		output [7:0] control_md,
		output       rs1_sign,
		output       rs2_sign,
		output       mac_init,
		output       rd_en
    );
	
	wire [6:0] opcode = instruction[6:0];
    wire [2:0] fun3 = instruction[14:12];
    wire [6:0] fun7 = instruction[31:25];

////////    MUL,MULH,MULHSU,MULHU    ////////
	wire mul    = (opcode==7'b0110011 & fun7==7'b0000001 & fun3==3'b000);
    wire mulh   = (opcode==7'b0110011 & fun7==7'b0000001 & fun3==3'b001);
    wire mulhsu = (opcode==7'b0110011 & fun7==7'b0000001 & fun3==3'b010);
    wire mulhu  = (opcode==7'b0110011 & fun7==7'b0000001 & fun3==3'b011);
	
////////    DIV,DIVU    ////////
	wire div  = (opcode==7'b0110011 & fun7==7'b0000001 & fun3==3'b100);
    wire divu = (opcode==7'b0110011 & fun7==7'b0000001 & fun3==3'b101);
	
////////    REM,REMU    ////////
    wire rem  = (opcode==7'b0110011 & fun7==7'b0000001 & fun3==3'b110);
    wire remu = (opcode==7'b0110011 & fun7==7'b0000001 & fun3==3'b111);
	
//-------------------------------------------- Outputs
	wire mac_high = mulh|mulhsu|mulhu ;
	wire mac_low  = mul ;
	
	assign rs1_sign = mul|mulh|mulhsu|div|rem ;
	assign rs2_sign = mul|mulh|div|rem ;
	
	assign mac_init = mul|mulh|mulhsu|mulhu ;
	
	wire rd_en2 = div|divu ;
	wire rd_en3 = rem|remu ;
	
	assign rd_en = mac_init | rd_en2 |rd_en3 ;
	
	assign control_md = ( mac_low  ) ? 8'h1c 
	:                   ( mac_high ) ? 8'h1d 
	:                   ( rd_en2   ) ? 8'h1e 
	:                   ( rd_en3   ) ? 8'h1f 
	:                                  8'h00 ;
	
endmodule

module three2one #(
	parameter  WIDTH = 40
)(
	input clk,
	input reset,
	input pause,
	
	input vdin1,
	input vdin2,
	input vdin3,
	
	input [WIDTH-1:0] din1,
	input [WIDTH-1:0] din2,
	input [WIDTH-1:0] din3,
	
	output [WIDTH-1:0] dout,
	output             vdout,
	output pnc
);
	
	wire [WIDTH-1:0] dout1  ;
	wire vdout1 ;
	wire pnc1   ;
	wire pnc2   ;
	
	reg pause2; always@(posedge clk) if (reset) pause2 <= 0; else pause2 <= pnc2;
	
	two2one #(
		.WIDTH ( WIDTH )
	)  inst1_two2one (
		.clk   ( clk    ),
		.reset ( reset  ),
		.pause ( pause2 | pause ),
		.vdin1 ( vdin1  ),
		.vdin2 ( vdin2  ),
		.din1  ( din1   ),
		.din2  ( din2   ),
		.dout  ( dout1  ),
		.vdout ( vdout1 ),
		.pnc   ( pnc1   )
	);
	
	two2one #(
		.WIDTH ( WIDTH )
	)  inst2_two2one (
		.clk   ( clk   ),
		.reset ( reset ),
		.pause ( pause ),
		.vdin1 ( vdout1 ),
		.vdin2 ( vdin3 ),
		.din1  ( dout1  ),
		.din2  ( din3  ),
		.dout  ( dout  ),
		.vdout ( vdout ),
		.pnc   ( pnc2   )
	);
	
	assign pnc = pnc1 | pnc2 ;
	
endmodule


module two2one #(
	parameter  WIDTH = 40
)(
	input clk,
	input reset,
	input pause,
	
	input vdin1,
	input vdin2,
	
	input [WIDTH-1:0] din1,
	input [WIDTH-1:0] din2,
	
	output [WIDTH-1:0] dout,
	output             vdout,
	output pnc
);
	
	wire reg_write_en = vdin1 & vdin2 & !pause ;
	
	reg [WIDTH:0] reg_din2; always@(posedge clk) if (reset) reg_din2 <= {1'b0,{WIDTH{1'b0}}}; else if (reg_write_en) reg_din2 <= {vdin2,din2}; else if (!pause) reg_din2 <= {1'b0,{WIDTH{1'b0}}} ;
	
	wire din2_vreg = reg_din2[WIDTH];
	
	assign {vdout,dout} = (pause     ) ? {1'b0,{WIDTH{1'b0}}}
	:                     (vdin1     ) ? {vdin1,din1}
	:                     (vdin2     ) ? {vdin2,din2}
	:                     (din2_vreg ) ? reg_din2
	:                                    {1'b0,{WIDTH{1'b0}}} ;
	
	assign pnc = reg_write_en | (din2_vreg & pause) ;
	
endmodule






module buffer#(
	parameter WIDTH1 = 32+32+32+32+2+5+4,
	parameter WIDTH2 = 1+8+13
)(
	input clk,
	input reset,
	input pause,
//---------------------------------------------- Inputs
	input [WIDTH1-1:0] din1,
	input [WIDTH2-1:0] din2,
	
//---------------------------------------------- Outputs
	output [WIDTH1-1:0] dout1,
	output [WIDTH2-1:0] dout2
);

	reg [WIDTH1-1:0] reg_din1 ; always@(posedge clk) if (reset) reg_din1 <= {WIDTH1{1'b0}} ; else if (!pause) reg_din1 <= din1 ;
	reg [WIDTH2-1:0] reg_din2 ; always@(posedge clk) if (reset) reg_din2 <= {WIDTH2{1'b0}} ; else if (!pause) reg_din2 <= din2 ;
	
	assign dout1 = reg_din1 ;
	assign dout2 = pause ? {WIDTH2{1'b0}} : reg_din2 ;
	
endmodule


module ALU(
	input clk,
	input reset,
	input pause,
	
	input [31:0] din1,
	input [31:0] din2,
	input [31:0] din1_aes,
	input [31:0] din2_aes,
	input [7:0]  control,
	input [3:0]  control_aes,
	input wait_en,
	output reg [31:0] dout,
	output reg [31:0] dout_aes
);
    reg [31:0] din1_alu;
    reg [31:0] din2_alu;
    reg [7:0]  control_alu;
    wire [31:0] dout1;
    always@(*)begin
    if(wait_en) begin
                din1_alu = din1_aes;
                din2_alu = din2_aes;
                dout_aes    = dout1;
                control_alu = {4'b0,control_aes}; 
                dout     = dout; end
    else  begin
          din1_alu = din1;
          din2_alu = din2;
          control_alu = control;
          dout     = dout1; end  
    end
	wire wire_add_en = ( control_alu==8'h01 ) ; 
	wire wire_sub_en = ( control_alu==8'h02 ) ; 
	wire wire_xor_en = ( control_alu==8'h03 ) ; 
	wire wire_or_en  = ( control_alu==8'h04 ) ; 
	wire wire_and_en = ( control_alu==8'h05 ) ; 

// Arithmetic
//---------------------------------------------------------
	
	wire [31:0] wire_add32 = din1_alu + din2_alu ;
	wire [31:0] wire_sub32 = din1_alu - din2_alu ;
	wire [31:0] wire_xor32 = din1_alu ^ din2_alu ;
	wire [31:0] wire_or32  = din1_alu | din2_alu ;
	wire [31:0] wire_and32 = din1_alu & din2_alu ;
	
// Comparator
//---------------------------------------------------------
	wire signed [31:0] sign_din1_alu = din1_alu;
	wire signed [31:0] sign_din2_alu = din2_alu;
	
	wire wire_equal   = ( din1_alu == din2_alu );
	wire wire_nequal  = ( din1_alu != din2_alu );
	wire wire_lesser  = ( sign_din1_alu <  sign_din2_alu );
	wire wire_gequal  = ( sign_din1_alu >= sign_din2_alu );
	wire wire_ulesser = ( din1_alu <  din2_alu );
	wire wire_ugequal = ( din1_alu >= din2_alu );
	
// Shift
//---------------------------------------------------------
	wire [ 4:0]  operand = din2_alu[4:0];
    wire [31:0] wire_sll = din1_alu << operand;
    wire [31:0] wire_srl = din1_alu >> operand;
    wire [31:0] wire_sra = sign_din1_alu >>> operand;
	
	
    assign dout1 = ( wire_add_en    ) ? wire_add32 
	:	          ( wire_sub_en    ) ? wire_sub32 
	:	          ( wire_xor_en    ) ? wire_xor32 
	:	          ( wire_or_en     ) ? wire_or32  
	:	          ( wire_and_en    ) ? wire_and32 
	:	          ( control_alu==8'h06 ) ? {31'd0, wire_equal  }
	:	          ( control_alu==8'h07 ) ? {31'd0, wire_nequal }
	:	          ( control_alu==8'h08 ) ? {31'd0, wire_lesser }
	:	          ( control_alu==8'h09 ) ? {31'd0, wire_gequal }
	:	          ( control_alu==8'h0a ) ? {31'd0, wire_ulesser}
	:	          ( control_alu==8'h0b ) ? {31'd0, wire_ugequal}
	:	          ( control_alu==8'h0c ) ? wire_sll
	:	          ( control_alu==8'h0d ) ? wire_srl
	:	          ( control_alu==8'h0e ) ? wire_sra
	:	            32'd0;
	
endmodule







    
    










//================================================ AES_Composite_enc




module AES_12clk_design1(Kin, Din, Dout, Krdy, Drdy, Kvld, Dvld, EN, BSY, CLK, RSTn, selout, din1_aes, din2_aes,control_aes,dout_aes, fn_aes,din1_aesmul); //Successful design on hardware

   input  [127:0] Kin;  // Key input
   input [127:0]  Din;  // Data input
   output [127:0] Dout; // Data output
   input          Krdy; // Key input ready
   input          Drdy; // Data input ready
   output  reg       Kvld; // Data output valid
   output   reg      Dvld; // Data output valid
   
   input          EN;   // AES circuit enable
   output   reg      BSY;  // Busy signal
   input          CLK;  // System clock
   input          RSTn; // Reset (Low active)
	output reg selout;
	output reg [31:0] din1_aes;
   output [31:0] din2_aes;
   output reg [3:0] control_aes;
   input [31:0] dout_aes;
   output reg [7:0] fn_aes;
   output reg [31:0] din1_aesmul;
	
   reg [127:0]    dat,key, rkey;
   reg [31:0]      dat0,dat1,dat2;
	reg [2:0] count;					 
   wire [31:0] dat3;   
   wire [127:0]   dat_next,rkey_next;
   wire [31:0] dat_next0;
   reg [39:0]      rnd;  
   reg [7:0]      rcon; 
   reg            sel;  // Indicate final round

   wire           rst;
   wire [3:0]      Delay;
   reg [3:0]       shift;
   reg [3:0] i; //counter
    reg hold;
	wire [1:0] Delaysel;
	reg [1:0] in;		  
assign rst = ~RSTn;

//Instantiations
aes_core dut1(sel,i,dat,dat0,dat1,dat2,dat3,rkey_next,dat_next,dat_next0);
KeyExpantion keyexpantion (.kin(rkey), .kout(rkey_next), .rcon(rcon));
NoOfDelays noofdelays(.Delayin(in), .Delay(Delay));
Collatz c1(.Din(in), .CLK(CLK), .rst(rst), .EN(EN), .Delaysel(Delaysel));
 
always @(posedge CLK or posedge rst) begin 
 if (rst)  in <= 2'b00;
 else in <= dat[1:0];
 end

always @(posedge CLK or posedge rst) begin
      if (rst)     begin Dvld <= 0;
						 selout <=0; end
      else begin Dvld <= sel & shift[0];
				 selout <= sel & shift[0]; end
   end

   always @(posedge CLK or posedge rst) begin
      if (rst) Kvld <= 0;
      else if (EN) Kvld <= Krdy;
   end
   always @(posedge CLK or posedge rst)begin
    if(rst) begin shift <=4'b0;
    hold<=0;
    end
    else if(Drdy) shift<=4'b0;
    else if(shift==4'b0 ) shift<=Delay;
    else if (hold & shift==4'b0001) begin    hold <=0;
                                            shift<=4'b0;
                                            end 
    
    else if(i[3])begin hold<=1;
    shift <= {shift[0],shift[3:1]};
    end
end
   always @(posedge CLK or posedge rst) begin
      if (rst) BSY <= 0;
      else if (EN&(~hold)) BSY <= Drdy || (rnd[39:1] | sel);
   end  
   
   always @(posedge CLK or posedge rst) begin
      if (rst)             rnd <= 40'd1;
      else if (EN) begin
       if(Drdy)          rnd <= {rnd[38:0],rnd[39]};
       else if (shift[0] & ~rnd[0])    rnd <= {rnd[38:0],rnd[39]};
       else if (i[3])    rnd <= rnd;
       else if(~rnd[0])  rnd <= {rnd[38:0],rnd[39]};
      end
      end
      
 always@(posedge CLK or posedge rst)
 begin
  if(rst) i<=4'd0; 
  else if (EN) begin
       if(Drdy)    i<=4'd1;
       else if(shift[0])        i<=4'd1;
       else if(i[3])        i<=4'b1000;
       else if(~rnd[0]) i<={i[2:0],i[3]};
 end
 end
   
 always @(posedge CLK or posedge rst) begin
      if (rst)     sel <= 0;
      else if (Drdy) sel <=0;
      else if (EN)begin
      if (sel & rnd[0])   sel <=1;
      else sel <= rnd[39];
      end
   end
 
 //Input 
 always @(posedge CLK or posedge rst) begin
      if (rst)
      dat <= 128'h0;
      else if (EN) begin
         if (Drdy)   
         begin            // dat <= Din ^ key;
         dat <= Din ^ Kin;
         end
         else if (shift[0]) 
            dat <= dat_next;   
        // else if(Drdy)  dat3<=dat[31:0]; 
      end
   end
   
 always @(posedge CLK or posedge rst) begin
      if (rst)                 dat0 <= 32'h0;
      else if (EN) begin
          if ((i[0]) && (~rnd[0]|sel))  dat0 <= dat_next0;   
          //else if(Drdy)  dat0<=dat[127:96]; 
      end
   end
  
 always @(posedge CLK or posedge rst) begin
      if (rst)                 dat1 <= 32'h0;
      else if (EN) begin
          if ((i[1]) && (~rnd[0]|sel))  dat1 <= dat_next0; 
          //else if(Drdy)  dat1<=dat[95:64];     
      end
   end
   
 always @(posedge CLK or posedge rst) begin
      if (rst)                 dat2 <= 32'h0;
      else if (EN) begin
          if ((i[2]) && (~rnd[0]|sel))  dat2 <= dat_next0; 
          //else if(Drdy)  dat2<=dat[63:32];     
      end
   end
   
 assign Dout = dat; 

 always @(posedge CLK or posedge rst) begin
      if (rst)     key <= 128'h0;
      else if (EN)
        if (Krdy)  key <= Kin;
   end
   
   //Key
   always @(posedge CLK or posedge rst) begin
       if (rst)         rkey <= 128'h0;
      else if (EN) begin
         if (Krdy)        rkey <= Kin;
         else if (shift[0]) rkey <= rkey_next;
         else if (rnd[0] & shift[0]) rkey <= key;
      end
   end 
  
 always @(posedge CLK or posedge rst) begin
     if (rst)          rcon <= 8'h01;
     else if (EN) begin
        if (Drdy)    rcon <= 8'h01;
        else if (shift[0]&& ~rnd[0]) rcon <= xtime(rcon);
     end
   end
   
   function [7:0] xtime;
      input [7:0] x;
      xtime = (x[7]==1'b0)? {x[6:0],1'b0} : {x[6:0],1'b0} ^ 8'h1B;
   endfunction
 
 always@(posedge CLK or posedge rst) begin
	if(rst) begin
	din1_aes <= 32'hc8e421a5; //LFSR1
	// lfsr2 <= 32'ha80421ad;
	control_aes <= 4'b001; //LFSR2
	count <= 0;
	fn_aes <= 8'b0; end
	else if (EN) begin
	din1_aes <= {(din1_aes[31]^din1_aes[6]^din1_aes[5]^din1_aes[1]),din1_aes[31:1]};

// lfsr2 <= {(lfsr2[31]^lfsr2[30]^lfsr2[10]^lfsr2[0]),lfsr2[31:1]};
	control_aes <= {control_aes[2:1],control_aes[3]^control_aes[0],control_aes[3]};
	if (control_aes<4) begin   if(count==0) begin fn_aes <= 28;
                                        din1_aesmul <= din1_aes;
                                        count <= 4'd1; end
                           else         begin fn_aes <= fn_aes;
                                        din1_aesmul <= din1_aesmul;
                                        count <= count-1; end end
	else if (control_aes<8)begin if(count==0) begin fn_aes <= 29;
                                        din1_aesmul <= din1_aes;
                                        count <= 4'd1; end
                           else         begin fn_aes <= fn_aes;
                                        din1_aesmul <= din1_aesmul;
                                        count <= count-1; end end
	else if (control_aes<12)begin if(count==0) begin fn_aes <= 30;
                                        din1_aesmul <= din1_aes;
                                        count <= 4'd7; end
                           else         begin fn_aes <= fn_aes;
                                        din1_aesmul <= din1_aesmul;
                                        count <= count-1; end end
	else begin                 if(count==0) begin fn_aes <= 31;
                                        din1_aesmul <= din1_aes;
                                        count <= 4'd7; end
                           else         begin fn_aes <= fn_aes;
                                        din1_aesmul <= din1_aesmul;
                                        count <= count-1; end end
	end
	else begin din1_aes <= din1_aes;
           control_aes <= {control_aes[2:1],control_aes[3]^control_aes[0],control_aes[3]};
           din1_aesmul <= din1_aesmul;
           count <= 0;
           fn_aes <= 8'b0; end
	end
assign din2_aes = {din1_aes[7:0],din1_aes[15:8],din1_aes[23:16],din1_aes[31:24]};
 
endmodule

//***********************************************************************************************

module aes_core(sel,i,dat,din0,din1,din2,din3,k,datout,dout);
input sel;
input [3:0]i;
input [31:0] din0,din1,din2,din3;
output reg[31:0] dout;
input [127:0] dat,k;
output [127:0] datout;
reg [31:0] a;
wire [31:0]b; //inputs to byte-substitution block

wire [127:0]data,data1,data2;
wire [127:0] rx; //input to row-shift block
wire [127:0] rs; //output after row-shift
wire [31:0] mx0,mx1,mx2,mx3; //input to mix-column block
wire [31:0] my0,my1,my2,my3; //output of mix-column block

maximov f(a,b);
always@(*)begin 
    case(i)
    4'd1: begin
        a<=dat[127:96];
        dout<=b;
    end
    4'd2: begin
        a<=dat[95:64];
        dout<=b;
    end
    4'd4: begin
        a<=dat[63:32];
        dout<=b;
    end
    4'd8: begin
        a<=dat[31:0];
        dout<=b;
    end
    endcase
end
//Instantiations
// S-BOX (BYTE SUBSTITUTION MODULE)
//maximov f1(a0,b0);
//maximov f2(a1,b1);
//maximov f3(a2,b2);
//maximov f4(a3,b3);


//ROW-SHIFT MODULE

row_shift f17(rx,rs);

//MIX-COLUMN MODULE
MixColumns f18(mx0,my0);
MixColumns f19(mx1,my1);
MixColumns f20(mx2,my2);
MixColumns f21(mx3,my3);
 
 
 assign data={din0,din1,din2,b};
 
 assign rx=data;
 assign data1=rs;
 
 assign {mx0,mx1,mx2,mx3}=data1;
 assign data2={my0,my1,my2,my3};
 
 assign datout=(sel)?data1^k:data2^k;

endmodule

//************************************************************************************************
module MixColumns(x, y);

   //------------------------------------------------
   input  [31:0]  x;
   output [31:0]  y;

   //------------------------------------------------
   wire [7:0]    a0, a1, a2, a3;
   wire [7:0]    b0, b1, b2, b3;

   assign a0 = x[31:24];
   assign a1 = x[23:16];
   assign a2 = x[15: 8];
   assign a3 = x[ 7: 0];

   assign b0 = xtime(a0);
   assign b1 = xtime(a1);
   assign b2 = xtime(a2);
   assign b3 = xtime(a3);

   assign y[31:24] =    b0 ^ a1^b1 ^ a2    ^ a3;
   assign y[23:16] = a0        ^b1 ^ a2^b2 ^ a3;
   assign y[15: 8] = a0    ^ a1        ^b2 ^ a3^b3;
   assign y[ 7: 0] = a0^b0 ^ a1    ^ a2        ^b3;
  
   function [7:0] xtime;
      input [7:0] x;
      xtime = (x[7]==1'b0)? {x[6:0],1'b0} : {x[6:0],1'b0} ^ 8'h1B;
   endfunction
   
endmodule // MixColumns
//************************************************************************************************

module KeyExpantion (kin, kout, rcon);

   //------------------------------------------------
   input [127:0]  kin;
   output [127:0] kout;
   input [7:0] 	  rcon;

   //------------------------------------------------
   wire [31:0]    ws, wr, w0, w1, w2, w3;

   //------------------------------------------------
   maximov SB1 ({kin[23:16], kin[15:8], kin[7:0], kin[31:24]}, ws);
   assign wr = {(ws[31:24] ^ rcon), ws[23:0]};

   assign w0 = wr ^ kin[127:96];
   assign w1 = w0 ^ kin[95:64];
   assign w2 = w1 ^ kin[63:32];
   assign w3 = w2 ^ kin[31:0];

   assign kout = {w0, w1, w2, w3};

endmodule // KeyExpantion

//*********************************************************************************************

// Maximov's S-Box
module maximov(x,y); // maximov based sbox
input [31:0] x;
output [31:0] y;

wire [7:0] byte_in1, byte_in2, byte_in3, byte_in4;
wire [7:0] byte_out1, byte_out2, byte_out3, byte_out4;

assign byte_in1 = x[31:24];
assign byte_in2 = x[23:16];
assign byte_in3 = x[15:8];
assign byte_in4 = x[7:0];

bSbox cm1(byte_in1, byte_out1);
bSbox cm2(byte_in2, byte_out2);
bSbox cm3(byte_in3, byte_out3);
bSbox cm4(byte_in4, byte_out4);

assign y = {byte_out1, byte_out2, byte_out3, byte_out4};
endmodule

module bSbox( t, a );
input [7:0] t;
output [7:0] a;
wire U0,U1,U2,U3,U4,U5,U6,U7;
wire R0,R1,R2,R3,R4,R5,R6,R7;

wire T20, T21, T22, T10, T11, T12, T13, T0, T1, T2, T3, T4;

wire Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13, Q14, Q15, Q16;

wire X0, X1, X2, X3;

wire Y0, Y1, Y2, Y3, Y00, Y01, Y02, Y13, Y23;
 
wire N0, N1, N2, N3, N4, N5, N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16, N17;

wire Z24, Z66;

wire H0, H1, H2, H3, H4, H5, H6, H7, H8, H9, H10, H11, H12, H13, H14, H15, H16, H17, H18;

assign U0 = t[7];
assign U1 = t[6];
assign U2 = t[5];
assign U3 = t[4];
assign U4 = t[3];
assign U5 = t[2];
assign U6 = t[1];
assign U7 = t[0];



// File: ftop.b
assign Z24 = U3 ^ U4;
assign Q17 = U1 ^ U7;
assign Q16 = U5 ^ Q17;
assign Q0 = Z24 ^ Q16;
assign Z66 = U1 ^ U6;
assign Q7 = Z24 ^ Z66;
assign Q2 = U2 ^ Q0;
assign Q1 = Q7 ^ Q2;
assign Q3 = U0 ^ Q7;
assign Q4 = U0 ^ Q2;
assign Q5 = U1 ^ Q4;
assign Q6 = U2 ^ U3;
assign Q10 = Q6 ^ Q7;
assign Q8 = U0 ^ Q10;
assign Q9 = Q8 ^ Q2;
assign Q12 = Z24 ^ Q17;
assign Q15 = U7 ^ Q4;
assign Q13 = Z24 ^ Q15;
assign Q14 = Q15 ^ Q0;
assign Q11 = U5;



// File: mulx.a
assign T20 = ~(Q6 & Q12);
assign T21 = ~(Q3 & Q14);
assign T22 = ~(Q1 & Q16);
assign T10 = ((~(Q3 | Q14)) ^ (~(Q0 & Q7)));
assign T11 = ((~(Q4 | Q13)) ^ (~(Q10 & Q11)));
assign T12 = ((~(Q2 | Q17)) ^ (~(Q5 & Q9)));
assign T13 = ((~(Q8 | Q15)) ^ (~(Q2 & Q17)));
assign X0 = T10 ^ (T20 ^ T22);
assign X1 = T11 ^ (T21 ^ T20);
assign X2 = T12 ^ (T21 ^ T22);
assign X3 = T13 ^ (T21 ^ (~(Q4 & Q13)));

//File: inv.a
assign T0 = (~(X0 & X2));
assign T1 = (~(X1 | X3));
assign T2 = T0 ~^ T1;
assign Y0 = X2? T2 : X3; //Y0 = MUX(X2, T2, X3)
assign Y2 = X0? T2 : X1;//Y2 = MUX(X0, T2, X1)
assign T3 = X1? X2 : 1; //T3 = MUX(X1, X2, 1)
assign Y1 = T2? X3 : T3;//Y1 = MUX(T2, X3, T3)
assign T4 = X3? X0 : 1; //T4 = MUX(X3, X0, 1)
assign Y3 = T2 ? X1 : T4;//Y3 = MUX(T2, X1, T4)

//# File: s0.a
//@inv.a
assign Y02 = Y2 ^ Y0;
assign Y13 = Y3 ^ Y1;
assign Y23 = Y3 ^ Y2;
assign Y01 = Y1 ^ Y0;
assign Y00 = Y02 ^ Y13;

//# File: muln.a
assign N0 = (~(Y01 &  Q11));
assign N1 = (~(Y0  &  Q12));
assign N2 = (~(Y1  &  Q0));
assign N3 = (~(Y23 &  Q17));
assign N4 = (~(Y2  &  Q5));
assign N5 = (~(Y3  &  Q15));
assign N6 = (~(Y13 &  Q14));
assign N7 = (~(Y00 &  Q16));
assign N8 = (~(Y02 &  Q13));
assign N9 = (~(Y01 &  Q7));
assign N10 = (~(Y0 &  Q10));
assign N11 = (~(Y1 &  Q6));
assign N12 = (~(Y23 &  Q2));
assign N13 = (~(Y2  &  Q9));
assign N14 = (~(Y3  &  Q8));
assign N15 = (~(Y13 &  Q3));
assign N16 = (~(Y00 &  Q1));
assign N17 = (~(Y02 &  Q4));

//# File: fbot.b
assign H0 = N1 ^ N5;
assign H1 = N4 ^ H0;
assign R2 = N2 ~^ H1;
assign H2 = N9 ^ N15;
assign H3 = N11 ^ N17;
assign R6 = H2 ~^ H3;
assign H4 = N11 ^ N14;
assign H5 = N9 ^ N12;
assign R5 = H4 ^ H5;
assign H6 = N16 ^ H2;
assign H7 = R2 ^ R6;
assign H8 = N10 ^ H7;
assign R7 = H6 ~^ H8;
assign H9 = N8 ^ H1;
assign H10 = N13 ^ H8;
assign R3 = H5 ^ H10;
assign H11 = H9 ^ H10;
assign H12 = N7 ^ H11;
assign H13 = H4 ^ H12;
assign R4 = N1 ^ H13;
assign H14 = N0 ~^ R7;
assign H15 = H9 ^ H14;
assign H16 = H7 ^ H15;
assign R1 = N6 ~^ H16;
assign H17 = N4 ^ H14;
assign H18 = N3 ^ H17;
assign R0 = H13 ^ H18;

assign a[7] = R0;
assign a[6] = R1;
assign a[5] = R2;
assign a[4] = R3;
assign a[3] = R4;
assign a[2] = R5;
assign a[1] = R6;
assign a[0] = R7;


endmodule



//*********************************************************************************************

module row_shift(sb,rs);
input [127:0] sb;
output reg [127:0] rs;

always@(sb)
begin
             //Bytes-1,5,9,13 have no row shift
       rs[127:120] = sb[127:120]; // byte-1
       rs[119:112] = sb[87:80]; // new byte-2 
       rs[111:104] = sb[47:40]; // new byte-3
       rs[103:96]  = sb[7:0];   // new byte-4
             
       rs[95:88]   = sb[95:88]; // byte-5
       rs[87:80]   = sb[55:48]; // new byte-6
       rs[79:72]   = sb[15:8];  // new byte-7
       rs[71:64]   = sb[103:96];// new byte-8
             
       rs[63:56]   = sb[63:56]; // byte-9
       rs[55:48]   = sb[23:16]; // new byte-10
       rs[47:40]   = sb[111:104];// new byte-11
       rs[39:32]   = sb[71:64]; // new byte-12
             
       rs[31:24]   = sb[31:24]; // byte-13
       rs[23:16]   = sb[119:112]; // new byte-14
       rs[15:8]    = sb[79:72]; // new byte-15
       rs[7:0]     = sb[39:32]; // new byte-16 
end                 
endmodule


module NoOfDelays(input [1:0] Delayin,output reg [3:0] Delay);

always@(Delayin)
case(Delayin)
2'b00: Delay<=4'b0010;
2'b01: Delay<=4'b0010;
2'b10: Delay<=4'b0100;
2'b11: Delay<=4'b0100;
endcase
endmodule


module Collatz(input [1:0] Din,input CLK, input rst, input EN, output  [1:0] Delaysel);
 reg [31:0] cc_out;
   
   
 always @ (posedge CLK or posedge rst) begin
     if (rst) cc_out <= 32'h01234567;
	else if(EN)begin
	 case (Din)
         2'd0: cc_out[31:0] <= (cc_out[0]==0)?(cc_out[31:0]>>1):(cc_out[31:0]<<1)+cc_out[31:0]+32'd1;
         2'd1: cc_out[31:0] <= (cc_out[0]==0)?(cc_out[31:0]>>1):(cc_out[31:0]<<2)+32'd1;
         2'd2: cc_out[31:0] <= (cc_out[0]==0)?(cc_out[31:0]>>1):(cc_out[31:0]<<2)+cc_out[31:0]+32'd1;
         2'd3: cc_out[31:0] <= (cc_out[0]==0)?(cc_out[31:0]>>1):(cc_out[31:0]<<2)+(cc_out[31:0]<<1)+32'd1;
         
       endcase
	 end
     else cc_out <= cc_out;
    end	 

assign Delaysel=cc_out%4;	

endmodule 