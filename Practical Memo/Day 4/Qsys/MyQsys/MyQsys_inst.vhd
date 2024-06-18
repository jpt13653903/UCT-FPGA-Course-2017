	component MyQsys is
		port (
			clk_clk                       : in    std_logic                     := 'X';             -- clk
			reset_reset_n                 : in    std_logic                     := 'X';             -- reset_n
			sdram_ic_clock_clk            : out   std_logic;                                        -- clk
			clk_780k_clk                  : out   std_logic;                                        -- clk
			clk_100m_clk                  : out   std_logic;                                        -- clk
			sdram_interface_address       : in    std_logic_vector(24 downto 0) := (others => 'X'); -- address
			sdram_interface_byteenable_n  : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable_n
			sdram_interface_chipselect    : in    std_logic                     := 'X';             -- chipselect
			sdram_interface_writedata     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			sdram_interface_read_n        : in    std_logic                     := 'X';             -- read_n
			sdram_interface_write_n       : in    std_logic                     := 'X';             -- write_n
			sdram_interface_readdata      : out   std_logic_vector(15 downto 0);                    -- readdata
			sdram_interface_readdatavalid : out   std_logic;                                        -- readdatavalid
			sdram_interface_waitrequest   : out   std_logic;                                        -- waitrequest
			sdram_ic_addr                 : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ic_ba                   : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_ic_cas_n                : out   std_logic;                                        -- cas_n
			sdram_ic_cke                  : out   std_logic;                                        -- cke
			sdram_ic_cs_n                 : out   std_logic;                                        -- cs_n
			sdram_ic_dq                   : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_ic_dqm                  : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ic_ras_n                : out   std_logic;                                        -- ras_n
			sdram_ic_we_n                 : out   std_logic;                                        -- we_n
			pll_locked_export             : out   std_logic                                         -- export
		);
	end component MyQsys;

	u0 : component MyQsys
		port map (
			clk_clk                       => CONNECTED_TO_clk_clk,                       --             clk.clk
			reset_reset_n                 => CONNECTED_TO_reset_reset_n,                 --           reset.reset_n
			sdram_ic_clock_clk            => CONNECTED_TO_sdram_ic_clock_clk,            --  sdram_ic_clock.clk
			clk_780k_clk                  => CONNECTED_TO_clk_780k_clk,                  --        clk_780k.clk
			clk_100m_clk                  => CONNECTED_TO_clk_100m_clk,                  --        clk_100m.clk
			sdram_interface_address       => CONNECTED_TO_sdram_interface_address,       -- sdram_interface.address
			sdram_interface_byteenable_n  => CONNECTED_TO_sdram_interface_byteenable_n,  --                .byteenable_n
			sdram_interface_chipselect    => CONNECTED_TO_sdram_interface_chipselect,    --                .chipselect
			sdram_interface_writedata     => CONNECTED_TO_sdram_interface_writedata,     --                .writedata
			sdram_interface_read_n        => CONNECTED_TO_sdram_interface_read_n,        --                .read_n
			sdram_interface_write_n       => CONNECTED_TO_sdram_interface_write_n,       --                .write_n
			sdram_interface_readdata      => CONNECTED_TO_sdram_interface_readdata,      --                .readdata
			sdram_interface_readdatavalid => CONNECTED_TO_sdram_interface_readdatavalid, --                .readdatavalid
			sdram_interface_waitrequest   => CONNECTED_TO_sdram_interface_waitrequest,   --                .waitrequest
			sdram_ic_addr                 => CONNECTED_TO_sdram_ic_addr,                 --        sdram_ic.addr
			sdram_ic_ba                   => CONNECTED_TO_sdram_ic_ba,                   --                .ba
			sdram_ic_cas_n                => CONNECTED_TO_sdram_ic_cas_n,                --                .cas_n
			sdram_ic_cke                  => CONNECTED_TO_sdram_ic_cke,                  --                .cke
			sdram_ic_cs_n                 => CONNECTED_TO_sdram_ic_cs_n,                 --                .cs_n
			sdram_ic_dq                   => CONNECTED_TO_sdram_ic_dq,                   --                .dq
			sdram_ic_dqm                  => CONNECTED_TO_sdram_ic_dqm,                  --                .dqm
			sdram_ic_ras_n                => CONNECTED_TO_sdram_ic_ras_n,                --                .ras_n
			sdram_ic_we_n                 => CONNECTED_TO_sdram_ic_we_n,                 --                .we_n
			pll_locked_export             => CONNECTED_TO_pll_locked_export              --      pll_locked.export
		);

