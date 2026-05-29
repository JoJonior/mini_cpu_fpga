library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg8 is
    Port (
        clk      : in  std_logic;
        reset    : in  std_logic;
        entrada  : in  std_logic_vector(7 downto 0);
        saida    : out std_logic_vector(7 downto 0)
    );
end Reg8;

architecture Behavioral of Reg8 is

    signal reg : std_logic_vector(7 downto 0);

begin

    process(clk, reset)
    begin
        if reset = '1' then
            reg <= "00000000";

        elsif rising_edge(clk) then
            reg <= entrada;
        end if;
    end process;

    saida <= reg;

end Behavioral;