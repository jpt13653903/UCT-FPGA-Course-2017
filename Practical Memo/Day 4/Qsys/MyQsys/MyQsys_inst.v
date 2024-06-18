	MyQsys u0 (
		.clk_clk                       (<connected-to-clk_clk>),                       //             clk.clk
		.reset_reset_n                 (<connected-to-reset_reset_n>),                 //           reset.reset_n
		.sdram_ic_clock_clk            (<connected-to-sdram_ic_clock_clk>),            //  sdram_ic_clock.clk
		.clk_780k_clk                  (<connected-to-clk_780k_clk>),                  //        clk_780k.clk
		.clk_100m_clk                  (<connected-to-clk_100m_clk>),                  //        clk_100m.clk
		.sdram_interface_address       (<connected-to-sdram_interface_address>),       // sdram_interface.address
		.sdram_interface_byteenable_n  (<connected-to-sdram_interface_byteenable_n>),  //                .byteenable_n
		.sdram_interface_chipselect    (<connected-to-sdram_interface_chipselect>),    //                .chipselect
		.sdram_interface_writedata     (<connected-to-sdram_interface_writedata>),     //                .writedata
		.sdram_interface_read_n        (<connected-to-sdram_interface_read_n>),        //                .read_n
		.sdram_interface_write_n       (<connected-to-sdram_interface_write_n>),       //                .write_n
		.sdram_interface_readdata      (<connected-to-sdram_interface_readdata>),      //                .readdata
		.sdram_interface_readdatavalid (<connected-to-sdram_interface_readdatavalid>), //                .readdatavalid
		.sdram_interface_waitrequest   (<connected-to-sdram_interface_waitrequest>),   //                .waitrequest
		.sdram_ic_addr                 (<connected-to-sdram_ic_addr>),                 //        sdram_ic.addr
		.sdram_ic_ba                   (<connected-to-sdram_ic_ba>),                   //                .ba
		.sdram_ic_cas_n                (<connected-to-sdram_ic_cas_n>),                //                .cas_n
		.sdram_ic_cke                  (<connected-to-sdram_ic_cke>),                  //                .cke
		.sdram_ic_cs_n                 (<connected-to-sdram_ic_cs_n>),                 //                .cs_n
		.sdram_ic_dq                   (<connected-to-sdram_ic_dq>),                   //                .dq
		.sdram_ic_dqm                  (<connected-to-sdram_ic_dqm>),                  //                .dqm
		.sdram_ic_ras_n                (<connected-to-sdram_ic_ras_n>),                //                .ras_n
		.sdram_ic_we_n                 (<connected-to-sdram_ic_we_n>),                 //                .we_n
		.pll_locked_export             (<connected-to-pll_locked_export>)              //      pll_locked.export
	);

