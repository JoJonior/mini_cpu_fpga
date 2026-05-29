library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ULA is
    Port (
        A        : in  std_logic_vector(7 downto 0);
        B        : in  std_logic_vector(7 downto 0);
        opcode   : in  std_logic_vector(2 downto 0);

        resultado : out std_logic_vector(7 downto 0);
        zero      : out std_logic
    );
end ULA;

architecture Behavioral of ULA is

begin

    process(A, B, opcode)

        variable a_int : unsigned(7 downto 0);
        variable b_int : unsigned(7 downto 0);

        variable res : unsigned(7 downto 0);

    begin

        a_int := unsigned(A);
        b_int := unsigned(B);

        case opcode is
           
            -- SOMA
            when "000" =>
                res := a_int + b_int;

            -- SUBTRAÇÃO
            when "001" =>
                res := a_int - b_int;

            -- AND
            when "010" =>
                res := a_int and b_int;

            -- OR
            when "011" =>
                res := a_int or b_int;
            -- XOR
            when "100" =>
                res := a_int xor b_int;
            -- NOT
            when "101" =>
				-- SHIFT LEFT Muliplia por 2
                res := not a_int;
				when "110" =>
						res := shift_left(a_int, to_integer(b_int(2 downto 0)));

				-- SHIFT RIGHT
				when "111" =>
					 res := shift_right(a_int, to_integer(b_int(2 downto 0)));
				
            -- DEFAULT
            when others =>
                res := (others => '0');

        end case;

        resultado <= std_logic_vector(res);


        if res = 0 then
            zero <= '1';
        else
            zero <= '0';
        end if;

    end process;

end Behavioral;