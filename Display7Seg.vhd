-- =====================================================
-- DISPLAY7SEG.VHD
-- COMPONENTE PARA CONTROLAR 4 DISPLAYS 7 SEGMENTOS
-- =====================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display7Seg is
    Port(
        clk : in std_logic;

        valor : in std_logic_vector(15 downto 0);

        SEG : out std_logic_vector(7 downto 0);
        DIG : out std_logic_vector(3 downto 0)
    );
end Display7Seg;

architecture Behavioral of Display7Seg is

    signal refresh_counter : unsigned(15 downto 0) := (others => '0');

    signal digit_select : std_logic_vector(1 downto 0);

    signal current_digit : std_logic_vector(3 downto 0);

begin

    ----------------------------------------------------
    -- DIVISOR DE CLOCK
    ----------------------------------------------------

    process(clk)
    begin

        if rising_edge(clk) then

            refresh_counter <= refresh_counter + 1;

        end if;

    end process;

    ----------------------------------------------------
    -- SELEÇÃO DO DISPLAY
    ----------------------------------------------------

    digit_select <= std_logic_vector(refresh_counter(15 downto 14));

    process(digit_select, valor)

    begin

        case digit_select is

            ------------------------------------------------
            -- DISPLAY 1
            ------------------------------------------------

            when "00" =>

                DIG <= "1110";

                current_digit <= valor(3 downto 0);

            ------------------------------------------------
            -- DISPLAY 2
            ------------------------------------------------

            when "01" =>

                DIG <= "1101";

                current_digit <= valor(7 downto 4);

            ------------------------------------------------
            -- DISPLAY 3
            ------------------------------------------------

            when "10" =>

                DIG <= "1011";

                current_digit <= valor(11 downto 8);

            ------------------------------------------------
            -- DISPLAY 4
            ------------------------------------------------

            when others =>

                DIG <= "0111";

                current_digit <= valor(15 downto 12);

        end case;

    end process;

    ----------------------------------------------------
    -- DECODIFICADOR HEX -> 7 SEG
    ----------------------------------------------------

    process(current_digit)

    begin

        case current_digit is

            when "0000" => SEG <= "11000000"; -- 0
            when "0001" => SEG <= "11111001"; -- 1
            when "0010" => SEG <= "10100100"; -- 2
            when "0011" => SEG <= "10110000"; -- 3
            when "0100" => SEG <= "10011001"; -- 4
            when "0101" => SEG <= "10010010"; -- 5
            when "0110" => SEG <= "10000010"; -- 6
            when "0111" => SEG <= "11111000"; -- 7
            when "1000" => SEG <= "10000000"; -- 8
            when "1001" => SEG <= "10010000"; -- 9
            when "1010" => SEG <= "10001000"; -- A
            when "1011" => SEG <= "10000011"; -- b
            when "1100" => SEG <= "11000110"; -- C
            when "1101" => SEG <= "10100001"; -- d
            when "1110" => SEG <= "10000110"; -- E
            when "1111" => SEG <= "10001110"; -- F

            when others => SEG <= "11111111";

        end case;

    end process;

end Behavioral;