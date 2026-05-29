library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ContadorOpcode is
    Port (
        clk      : in  STD_LOGIC;
        BTN      : in  STD_LOGIC;
        RESET    : in  STD_LOGIC;

        opcode   : out STD_LOGIC_VECTOR(2 downto 0)
    );
end ContadorOpcode;

architecture Behavioral of ContadorOpcode is

    signal btn_inc       : std_logic;
    signal btn_reset     : std_logic;

    signal btn_reg       : std_logic := '0';
    signal btn_pulse     : std_logic := '0';

    signal opcode_reg    : unsigned(2 downto 0) := (others => '0');

    signal filtro_debounce : integer range 0 to 5000000 := 0;
    signal btn_filtrado    : std_logic := '0';

begin

    btn_inc   <= not BTN;
    btn_reset <= not RESET;

    -- Debounce
    process(clk)
    begin
        if rising_edge(clk) then

            if btn_inc = '1' then

                if filtro_debounce < 1000000 then
                    filtro_debounce <= filtro_debounce + 1;
                else
                    btn_filtrado <= '1';
                end if;

            else
                filtro_debounce <= 0;
                btn_filtrado <= '0';
            end if;

            btn_reg <= btn_filtrado;

            btn_pulse <= btn_filtrado and (not btn_reg);

        end if;
    end process;

    -- Contador de opcode
    process(clk)
    begin
        if rising_edge(clk) then

            if btn_reset = '1' then

                opcode_reg <= (others => '0');

            elsif btn_pulse = '1' then

                if opcode_reg = 7 then
                    opcode_reg <= (others => '0');
                else
                    opcode_reg <= opcode_reg + 1;
                end if;

            end if;
        end if;
    end process;

    opcode <= std_logic_vector(opcode_reg);

end Behavioral;