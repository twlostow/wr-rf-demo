`define ADDR_DDS_CR                    7'h0
`define DDS_CR_TEST_OFFSET 0
`define DDS_CR_TEST 32'h00000001
`define DDS_CR_SLAVE_OFFSET 1
`define DDS_CR_SLAVE 32'h00000002
`define DDS_CR_MASTER_OFFSET 2
`define DDS_CR_MASTER 32'h00000004
`define DDS_CR_ADC_BB_ENABLE_OFFSET 3
`define DDS_CR_ADC_BB_ENABLE 32'h00000008
`define DDS_CR_WR_LINK_OFFSET 4
`define DDS_CR_WR_LINK 32'h00000010
`define DDS_CR_WR_TIME_OFFSET 5
`define DDS_CR_WR_TIME 32'h00000020
`define DDS_CR_CLK_ID_OFFSET 16
`define DDS_CR_CLK_ID 32'hffff0000
`define ADDR_DDS_GPIOR                 7'h4
`define DDS_GPIOR_PLL_SYS_CS_N_OFFSET 0
`define DDS_GPIOR_PLL_SYS_CS_N 32'h00000001
`define DDS_GPIOR_PLL_SYS_RESET_N_OFFSET 1
`define DDS_GPIOR_PLL_SYS_RESET_N 32'h00000002
`define DDS_GPIOR_PLL_SCLK_OFFSET 2
`define DDS_GPIOR_PLL_SCLK 32'h00000004
`define DDS_GPIOR_PLL_SDIO_OFFSET 3
`define DDS_GPIOR_PLL_SDIO 32'h00000008
`define DDS_GPIOR_PLL_SDIO_DIR_OFFSET 4
`define DDS_GPIOR_PLL_SDIO_DIR 32'h00000010
`define DDS_GPIOR_PLL_VCXO_RESET_N_OFFSET 5
`define DDS_GPIOR_PLL_VCXO_RESET_N 32'h00000020
`define DDS_GPIOR_PLL_VCXO_CS_N_OFFSET 6
`define DDS_GPIOR_PLL_VCXO_CS_N 32'h00000040
`define DDS_GPIOR_PLL_VCXO_FUNCTION_OFFSET 7
`define DDS_GPIOR_PLL_VCXO_FUNCTION 32'h00000080
`define DDS_GPIOR_PLL_VCXO_SDO_OFFSET 8
`define DDS_GPIOR_PLL_VCXO_SDO 32'h00000100
`define DDS_GPIOR_ADF_CE_OFFSET 9
`define DDS_GPIOR_ADF_CE 32'h00000200
`define DDS_GPIOR_ADF_CLK_OFFSET 10
`define DDS_GPIOR_ADF_CLK 32'h00000400
`define DDS_GPIOR_ADF_LE_OFFSET 11
`define DDS_GPIOR_ADF_LE 32'h00000800
`define DDS_GPIOR_ADF_DATA_OFFSET 12
`define DDS_GPIOR_ADF_DATA 32'h00001000
`define DDS_GPIOR_ADC_SDI_OFFSET 13
`define DDS_GPIOR_ADC_SDI 32'h00002000
`define DDS_GPIOR_ADC_CNV_OFFSET 14
`define DDS_GPIOR_ADC_CNV 32'h00004000
`define DDS_GPIOR_ADC_SCK_OFFSET 15
`define DDS_GPIOR_ADC_SCK 32'h00008000
`define DDS_GPIOR_ADC_SDO_OFFSET 16
`define DDS_GPIOR_ADC_SDO 32'h00010000
`define ADDR_DDS_FREQ_HI               7'h8
`define ADDR_DDS_FREQ_LO               7'hc
`define ADDR_DDS_GAIN                  7'h10
`define ADDR_DDS_RSTR                  7'h14
`define DDS_RSTR_PLL_RST_OFFSET 0
`define DDS_RSTR_PLL_RST 32'h00000001
`define DDS_RSTR_SW_RST_OFFSET 1
`define DDS_RSTR_SW_RST 32'h00000002
`define ADDR_DDS_I2CR                  7'h18
`define DDS_I2CR_SCL_OUT_OFFSET 0
`define DDS_I2CR_SCL_OUT 32'h00000001
`define DDS_I2CR_SDA_OUT_OFFSET 1
`define DDS_I2CR_SDA_OUT 32'h00000002
`define DDS_I2CR_SCL_IN_OFFSET 2
`define DDS_I2CR_SCL_IN 32'h00000004
`define DDS_I2CR_SDA_IN_OFFSET 3
`define DDS_I2CR_SDA_IN 32'h00000008
`define ADDR_DDS_PIR                   7'h1c
`define DDS_PIR_KP_OFFSET 0
`define DDS_PIR_KP 32'h0000ffff
`define DDS_PIR_KI_OFFSET 16
`define DDS_PIR_KI 32'hffff0000
`define ADDR_DDS_DLYR                  7'h20
`define DDS_DLYR_DELAY_OFFSET 0
`define DDS_DLYR_DELAY 32'h0000ffff
`define ADDR_DDS_PHASER                7'h24
`define DDS_PHASER_PHASE_OFFSET 0
`define DDS_PHASER_PHASE 32'h0000ffff
`define ADDR_DDS_MACL                  7'h28
`define DDS_MACL_MACL_OFFSET 0
`define DDS_MACL_MACL 32'hffffffff
`define ADDR_DDS_MACH                  7'h2c
`define DDS_MACH_MACH_OFFSET 0
`define DDS_MACH_MACH 32'h0000ffff
`define ADDR_DDS_HIT_CNT               7'h30
`define DDS_HIT_CNT_HIT_CNT_OFFSET 0
`define DDS_HIT_CNT_HIT_CNT 32'h00ffffff
`define ADDR_DDS_MISS_CNT              7'h34
`define DDS_MISS_CNT_MISS_CNT_OFFSET 0
`define DDS_MISS_CNT_MISS_CNT 32'h00ffffff
`define ADDR_DDS_RX_CNT                7'h38
`define DDS_RX_CNT_RX_CNT_OFFSET 0
`define DDS_RX_CNT_RX_CNT 32'h00ffffff
`define ADDR_DDS_TX_CNT                7'h3c
`define DDS_TX_CNT_TX_CNT_OFFSET 0
`define DDS_TX_CNT_TX_CNT 32'h00ffffff
`define ADDR_DDS_PD_FIFO_R0            7'h40
`define DDS_PD_FIFO_R0_DATA_OFFSET 0
`define DDS_PD_FIFO_R0_DATA 32'h0000ffff
`define ADDR_DDS_PD_FIFO_CSR           7'h44
`define DDS_PD_FIFO_CSR_FULL_OFFSET 16
`define DDS_PD_FIFO_CSR_FULL 32'h00010000
`define DDS_PD_FIFO_CSR_EMPTY_OFFSET 17
`define DDS_PD_FIFO_CSR_EMPTY 32'h00020000
`define ADDR_DDS_TUNE_FIFO_R0          7'h48
`define DDS_TUNE_FIFO_R0_DATA_OFFSET 0
`define DDS_TUNE_FIFO_R0_DATA 32'hffffffff
`define ADDR_DDS_TUNE_FIFO_CSR         7'h4c
`define DDS_TUNE_FIFO_CSR_FULL_OFFSET 16
`define DDS_TUNE_FIFO_CSR_FULL 32'h00010000
`define DDS_TUNE_FIFO_CSR_EMPTY_OFFSET 17
`define DDS_TUNE_FIFO_CSR_EMPTY 32'h00020000
