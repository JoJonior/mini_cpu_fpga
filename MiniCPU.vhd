library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MiniCPU is
	Port(

		CLOCK_50 : in std_logic;

		key_ENT1,key_ENT2,key_OPCODE,key_RESULT:  in std_logic;
		key_Reset: in std_logic;
		
		LEDR : out std_logic_vector(2 downto 0);
		
		LED_RESULT: out std_logic;

		SEG : out std_logic_vector(7 downto 0);
		DIG : out std_logic_vector(3 downto 0)

	);
end MiniCPU;

architecture Behavioral of MiniCPU is

	-- COMPONENTES
	component Display7Seg
	  Port(
			clk : in std_logic;

			valor : in std_logic_vector(15 downto 0);

			SEG : out std_logic_vector(7 downto 0);
			DIG : out std_logic_vector(3 downto 0)
	  );
	end component;
	
	component ContadorBotao
	  Port(
			clk : in std_logic;
			ENT1 : in std_logic;
			RESET : in std_logic;
			num_bits : out std_logic_vector(7 downto 0)
	  );
	end component;
	
	
	
	component ContadorOpcode
		 Port (
			  clk      : in  STD_LOGIC;
			  BTN      : in  STD_LOGIC;
			  RESET    : in  STD_LOGIC;
			  opcode   : out STD_LOGIC_VECTOR(2 downto 0)
		 );
	end component;
	
	component processadorCPU
		 Port (
			  clk      : in  STD_LOGIC;
			  reset    : in  STD_LOGIC;
			  Ent1  : in std_logic_vector(7 downto 0);
			  Ent2  : in std_logic_vector(7 downto 0);
			  opcode   : in STD_LOGIC_VECTOR(2 downto 0);
			  Display : out std_logic_vector(7 downto 0)
		 );
	end component;
	
	-- INVERTER INPUTS:
	signal INV_key_ENT1,INV_key_ENT2,INV_key_OPCODE,INV_key_RESULT,INV_key_Reset : std_logic;
		
	
	-- SINAIS

	signal Ent1 : std_logic_vector(7 downto 0) := "00000000";
	signal Ent2 : std_logic_vector(7 downto 0) := "00000000";
	
	--signal Ent1 : std_logic_vector(3 downto 0) := "0000";
	--signal Ent2 : std_logic_vector(3 downto 0) := "0000";

	signal opcode : std_logic_vector(2 downto 0) := "000";

	signal resultado : std_logic_vector(7 downto 0);

	signal display_valor : std_logic_vector(15 downto 0);

	signal mostrar_resultado : std_logic := '0';
	
	signal resultado_cpu   : std_logic_vector(7 downto 0);
	signal resultado_salvo : std_logic_vector(7 downto 0);
	
	signal resultado_bcd : std_logic_vector(15 downto 0);
	
	signal result_reg   : std_logic := '0';
	signal result_pulse : std_logic := '0';
	
	signal entradas_bcd : std_logic_vector(15 downto 0);



begin
		
	 --begin INVERSÃO
	 INV_key_ENT1   <=  key_ENT1;
    INV_key_ENT2   <=  key_ENT2;
    INV_key_OPCODE <=  key_OPCODE;
    INV_key_RESULT <= key_RESULT;
	 INV_key_Reset <=  key_Reset;
	 --end
	 
	 ENTRADA_1: ContadorBotao
			port map(
			clk =>  CLOCK_50,
			ENT1 =>  INV_key_ENT1,
			RESET =>  INV_key_Reset,
			num_bits => Ent1
				
			);

	 ENTRADA_2: ContadorBotao
			port map(
			clk =>  CLOCK_50,
			ENT1 =>  INV_key_ENT2,
			RESET =>  INV_key_Reset,
			num_bits => Ent2
				
			);
			
		SELETOR_OPCODE: ContadorOpcode
			port map(
				clk =>  CLOCK_50,
				BTN =>  INV_key_OPCODE,
				RESET =>  INV_key_Reset,
				opcode => opcode
				
			);


	 
	 LEDR(2 downto 0) <= opcode;
	 
	 
		CPU : processadorCPU
		port map(

			 clk => CLOCK_50,
			 reset => INV_key_Reset,

			 Ent1 => Ent1,
			 Ent2 => Ent2,

			 opcode => opcode,

			 Display => resultado_cpu

	 );
	 
	process(CLOCK_50)
	begin
		 if rising_edge(CLOCK_50) then

			  result_reg <= INV_key_RESULT;

			  if INV_key_Reset = '0' then

					resultado_salvo <= (others => '0');
					mostrar_resultado <= '0';

			  elsif (INV_key_RESULT = '0' and result_reg = '1') then

					resultado_salvo <= resultado_cpu;

					mostrar_resultado <= not mostrar_resultado;

			  end if;

		 end if;
	end process;
	
	process(resultado_salvo)

		 variable valor_int : integer;
		 variable milhar  : integer;
		 variable centena : integer;
		 variable dezena  : integer;
		 variable unidade : integer;

	begin

		 valor_int := to_integer(unsigned(resultado_salvo));

		 milhar  := valor_int / 1000;
		 centena := (valor_int mod 1000) / 100;
		 dezena  := (valor_int mod 100) / 10;
		 unidade := valor_int mod 10;

		 resultado_bcd <=
			  std_logic_vector(to_unsigned(milhar,4)) &
			  std_logic_vector(to_unsigned(centena,4)) &
			  std_logic_vector(to_unsigned(dezena,4)) &
			  std_logic_vector(to_unsigned(unidade,4));

	end process;
	
	process(Ent1, Ent2)

		 variable valor1 : integer;
		 variable valor2 : integer;

		 variable cent1 : integer;
		 variable dez1  : integer;
		 variable uni1  : integer;

		 variable cent2 : integer;
		 variable dez2  : integer;
		 variable uni2  : integer;

	begin

		 valor1 := to_integer(unsigned(Ent1));
		 valor2 := to_integer(unsigned(Ent2));

		 -----------------------------------
		 -- ENT1
		 -----------------------------------

		 cent1 := valor1 / 100;
		 dez1  := (valor1 mod 100) / 10;
		 uni1  := valor1 mod 10;

		 -----------------------------------
		 -- ENT2
		 -----------------------------------

		 cent2 := valor2 / 100;
		 dez2  := (valor2 mod 100) / 10;
		 uni2  := valor2 mod 10;

		 -----------------------------------
		 -- FORMATO:
		 -- [dez1][uni1][dez2][uni2]
		 -----------------------------------

		 entradas_bcd <=
			  std_logic_vector(to_unsigned(dez1,4)) &
			  std_logic_vector(to_unsigned(uni1,4)) &
			  std_logic_vector(to_unsigned(dez2,4)) &
			  std_logic_vector(to_unsigned(uni2,4));

	end process;
	
	display_valor <= 
			resultado_bcd
			when mostrar_resultado = '1'
			else
			entradas_bcd;
	 DISPLAY : Display7Seg
    port map(

        clk => CLOCK_50,

        valor => display_valor,

        SEG => SEG,
        DIG => DIG

    );
	LED_RESULT <= not INV_key_RESULT; --sem clicar fica acesso, ao clicar apaga


end Behavioral;