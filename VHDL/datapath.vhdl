library ieee;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_std.all;
library work;
use work.all;

entity datapath is
	port ( clk: in std_logic; 
			 rst: in std_logic);
end entity;

architecture Darkhold of datapath is

	signal one: std_logic_vector(15 downto 0) := "0000000000000001";
	signal in_PC,PC,PC1,PC2,PC3,PC4,PC5,instruction, imm, imm1, mux_out, pc_write,IR1,IR2,IR3,IR4,IR5 : std_logic_vector(15 downto 0) := (others=>'0');
   signal Rfa_int,Rfb_int, Ra_int, Rb_int, Ra, Rb, Ra1, Rb1, Rb2,data_wr   :std_logic_vector(15 downto 0):= (others=>'0');
	signal OPR1_int,OPR2_int, OPR1, OPR2,alu_out_int,alu_out,data_out,out1,out1_interm  :std_logic_vector(15 downto 0):= (others=>'0');
	signal en, jal_en, en_bp,en_bp_jal, bp,sel1,sel,C,Z,cond_bit_int, cond_bit,cond_bit1, comp,Rf_wr_en,data_wr_en : std_logic := '0';
	signal stall_en1, stall_en2, buffenlw, PC_wr_en,PC_sel : std_logic :='0';
	signal A1,A2,A3,A1_imm,A2_imm,A3_imm,A31,A32,A33,wr_addr,OP: std_logic_vector(2 downto 0):= (others=>'0');
	signal sel3,flag_mod : std_logic_vector(1 downto 0):= (others=>'0');
	signal buff_en1,buff_en2,buff_en3, buff_en: std_logic_vector(4 downto 0):= (others=>'0');
begin
	
		PC_temp:work.programmeCounter port map(d1=>pc_write,d2=>in_PC ,ld=>PC_wr_en,clr=>rst,clk=>clk,q=>PC); 
		
		instruction_memory: work.memory port map(RAM_ADDR => PC,
																 RAM_DATA_IN => one,
																 RAM_WR => '0',
																 RAM_CLOCK => clk,
																 RAM_DATA_OUT => instruction);
																 
																 
		decoder0: work.decode0 port map( instruction_in => instruction, imm => imm,
													pc_in => PC, en => en, jal_en=> jal_en);
													
													
		--SE : work.SEXT5_0 port map( data_in => imm, data_out => se_imm, sel=> #control);
		
		table : work.Branch_predictor port map(PC_in => PC, PC_n=> PC5,instruction => instruction,
																			instruction_n=> IR5, tnt=>cond_bit1,predn => bp);
		
		en_bp <= en and bp;
		en_bp_jal <= en_bp or jal_en;
		
		mux8 : work.MUX2 port map( inp1 => one, inp2 => imm, sel => en_bp_jal,output=>mux_out);
		
		adder1 : work.adder port map( INPUT1 => PC, INPUT2 => mux_out, OUTPUT=> pc_write);
		
		PC1_t : work.register16 port map( d=> PC, ld=> buff_en(4), clr=>rst, clk => clk, q=> PC1);
		
		IR1_t: work.register16 port map( d=> instruction, ld=>buff_en(4), clr=> rst, clk=> clk, q=>IR1);
		
----------------------------------------------Stage 1 complete------------------------------------------------------

		
		decoder1: work.decode1 port map (instruction_in => IR1,
														PC_in=> PC, imm => imm1, 
														ra => A1_imm, A3=> A3_imm,rb=> A2_imm);
														
		A1_t: work.register3 port map(d=> A1_imm, ld=>buff_en(3), clr=>rst,  clk => clk, q=> A1); 	
		A2_t: work.register3 port map(d=> A2_imm, ld=>buff_en(3), clr=>rst,  clk => clk, q=> A2); 												
		A3_t: work.register3 port map(d=> A3_imm, ld=>buff_en(3), clr=>rst,  clk => clk, q=> A3); 
		PC2_t : work.register16 port map( d=> PC1, ld=>buff_en(3), clr=>rst,  clk => clk, q=> PC2); 	
		
		IR2_t: work.register16 port map( d=> IR1, ld=>buff_en(3), clr=> rst, clk=> clk, q=>IR2);
														
-------------------------------------------Stage 2 complete ---------------------------------------------------------

		reg_file: work.register_file port map(outA => Rfa_int,
															outB => Rfb_int,
														data_in => data_wr,
														writeEnable1=> Rf_wr_en,
														 regASel => A1,
														 regBSel => A2,
															writeRegSel =>wr_addr,
																clk=> clk
															);
		
		decoder3: work.decode3 port map( instruction_in => IR2, sel1=> sel1, sel3=>sel3);
		
	PC3_t : work.register16 port map( d=> PC2, ld=>buff_en(2), clr=>rst, clk => clk, q=> PC3); 	
		
	IR3_t: work.register16 port map( d=> IR2, ld=>buff_en(2), clr=> rst, clk=> clk, q=>IR3);
		
	mux1: work.MUX2 port map( inp1 => Rb_int, inp2=> imm1, sel=> sel1, output=> OPR2_int);
	
	mux3 : work.MUX port map( inp1=> Ra_int, inp2=> imm1, inp3=> PC2, sel=> sel3, output=> OPR1_int);
	
	OPR1_t : work.register16 port map( d=> OPR1_int, ld=> buff_en(2), clr=> rst, clk=> clk, q=> OPR1);	
	OPR2_t : work.register16 port map( d=> OPR2_int, ld=> buff_en(2), clr=> rst, clk=> clk, q=> OPR2);
	
	Ra_t: work.register16 port map( d=> Ra_int, ld=> buff_en(2), clr=> rst, clk=> clk, q=> Ra);		
	Rb_t: work.register16 port map( d=> Rb_int, ld=> buff_en(2), clr=> rst, clk=> clk, q=> Rb);
	
	
	A31_t: work.register3 port map( d=> A3, ld=>buff_en(2), clr=> rst, clk=> clk, q=>A31);
		
-----------------------------------------Stage 3 complete-------------------------------------------------------------

	ALU : work.ALU port map( operand1=> OPR1, operand2=> OPR2, op=> OP, flag_mod => flag_mod, output=> alu_out_int, cy=> C, z=>Z);
	
	decoder4: work.decode4 port map(instruction_in=> IR3, cy=>C, z=>Z, comp => comp,
				cond_bit=> cond_bit_int, flag_mod=> flag_mod, op=> OP);
				
	PC4_t : work.register16 port map( d=> PC3, ld=>buff_en(1), clr=>rst, clk => clk, q=> PC4); 	
		
	IR4_t: work.register16 port map( d=> IR3, ld=>buff_en(1), clr=> rst, clk=> clk, q=>IR4); 
	
	A32_t: work.register3 port map( d=> A31, ld=>buff_en(1), clr=> rst, clk=> clk, q=>A32);
				
	Ra1_t: work.register16 port map( d=> Ra, ld=> buff_en(1), clr=> rst, clk=> clk, q=> Ra1);		
	Rb1_t: work.register16 port map( d=> Rb, ld=> buff_en(1), clr=> rst, clk=> clk, q=> Rb1);
	alu_out_t: work.register16 port map( d=> alu_out_int, ld=> buff_en(1), clr=> rst, clk=> clk, q=> alu_out);
	cond_bit_t: work.register1 port map( d=> cond_bit_int, ld=> buff_en(1), clr=> rst, clk=> clk, q=> cond_bit);
	comparator_t: work.comparator port map(inp1=> Ra, inp2=> Rb, comp=> comp);
	
----------------------------------------Stage 4 complete---------------------------------------------------------------

	
	data_memory: work.memory port map(RAM_ADDR => alu_out,
																 RAM_DATA_IN => Ra1,
																 RAM_WR => data_wr_en,
																 RAM_CLOCK => clk,
																 RAM_DATA_OUT => data_out);
   decoder5 : work.decode5 port map(instruction_in => IR4,wr_en=> data_wr_en, sel=> sel);
	
	MUXx: work.MUX2 port map(inp1=> alu_out, inp2=> data_out, sel=>sel , output=> out1_interm);
	
	
	PC5_t : work.register16 port map( d=> PC4, ld=>buff_en(0), clr=>rst, clk => clk, q=> PC5); 	
		
	IR5_t: work.register16 port map( d=> IR4, ld=>buff_en(0), clr=> rst, clk=> clk, q=>IR5); 
	
	A33_t: work.register3 port map( d=> A32, ld=>buff_en(0), clr=> rst, clk=> clk, q=>A33);
						
	Rb2_t: work.register16 port map( d=> Rb1, ld=> buff_en(0), clr=> rst, clk=> clk, q=> Rb2);
	
	cond1_t: work.register1 port map( d=> cond_bit, ld=> buff_en(0), clr=> rst, clk=> clk, q=> cond_bit1); 
	
	out1_t: work.register16 port map( d=> out1_interm, ld=> buff_en(0), clr=> rst, clk=> clk, q=> out1);
---------------------------------------Stage 5 complete----------------------------------------------------------------

	
	
	decoder6: work.decode6 port map(instruction_in=> IR5, prediction=> bp, cond_bit=> cond_bit1,
                                   rf_wr=> Rf_wr_en , sel=>PC_sel, PC_wr_en => PC_wr_en);

	PC_mux: work.MUX2 port map(inp1=> out1,inp2=> Rb2,sel=>PC_sel,output=>in_PC);
	
	
	wr_addr <= A33;
	
	data_wr <= out1;
	
------------------------------------Stage 6 complete-----------------------------------------------------------------

	
	forwarding_logic1: work.forward_logic port map(ir3=> IR3, ir4=>IR4, ir5=>IR5, 
																		out_rf=>Rfa_int, out_ex=>alu_out,
																		out_mem=>out1_interm, out1=>out1, 
																		read_addr=>A1, a31=>A31, a32=>A32, a33=>A33,
																		stall_enable=>stall_en1, output=> Ra_int);
																		
	forwarding_logic2: work.forward_logic port map(ir3=> IR3, ir4=>IR4, ir5=>IR5, 
																		out_rf=>Rfb_int, out_ex=>alu_out,
																		out_mem=>out1_interm, out1=>out1, 
																		read_addr=>A2, a31=>A31, a32=>A32, a33=>A33,
																		stall_enable=>stall_en2, output=> Rb_int);																
	
	buffenlw <= stall_en1 or stall_en2;
	
-----------------------------------Forwarding logic complete---------------------------------------------------------

	buffen1 : work.buffer_en port map(clock=>clk,instruction_in => instruction, buff_en=>buff_en1);
	buffen2 : work.buff_en2 port map(instruction_in=>IR3, predn => bp, comp => comp,
												clock=>clk,
												buff_en=>buff_en2);	
	
	buffen3 : work.buff_en3 port map(en => buffenlw, buff_en=> buff_en3);
	
	
	buff_en <= buff_en1 and buff_en2 and buff_en3;
	
	end darkhold;
		