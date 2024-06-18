
module MyQsys (
	clk_clk,
	reset_reset_n,
	sdram_ic_clock_clk,
	clk_780k_clk,
	clk_100m_clk,
	sdram_interface_address,
	sdram_interface_byteenable_n,
	sdram_interface_chipselect,
	sdram_interface_writedata,
	sdram_interface_read_n,
	sdram_interface_write_n,
	sdram_interface_readdata,
	sdram_interface_readdatavalid,
	sdram_interface_waitrequest,
	sdram_ic_addr,
	sdram_ic_ba,
	sdram_ic_cas_n,
	sdram_ic_cke,
	sdram_ic_cs_n,
	sdram_ic_dq,
	sdram_ic_dqm,
	sdram_ic_ras_n,
	sdram_ic_we_n,
	pll_locked_export);	

	input		clk_clk;
	input		reset_reset_n;
	output		sdram_ic_clock_clk;
	output		clk_780k_clk;
	output		clk_100m_clk;
	input	[24:0]	sdram_interface_address;
	input	[1:0]	sdram_interface_byteenable_n;
	input		sdram_interface_chipselect;
	input	[15:0]	sdram_interface_writedata;
	input		sdram_interface_read_n;
	input		sdram_interface_write_n;
	output	[15:0]	sdram_interface_readdata;
	output		sdram_interface_readdatavalid;
	output		sdram_interface_waitrequest;
	output	[12:0]	sdram_ic_addr;
	output	[1:0]	sdram_ic_ba;
	output		sdram_ic_cas_n;
	output		sdram_ic_cke;
	output		sdram_ic_cs_n;
	inout	[15:0]	sdram_ic_dq;
	output	[1:0]	sdram_ic_dqm;
	output		sdram_ic_ras_n;
	output		sdram_ic_we_n;
	output		pll_locked_export;
endmodule
