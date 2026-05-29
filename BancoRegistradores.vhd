library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BancoRegistradores is
    Port (
        clk : in std_logic;
        reset : in std_logic;

        -- Controle de escrita
        we : in std_logic;
        endereco_write : in std_logic_vector(1 downto 0);
        dado_entrada : in std_logic_vector(7 downto 0);

        -- Controle de leitura
        endereco_read : in std_logic_vector(1 downto 0);
        dado_saida : out std_logic_vector(7 downto 0)
    );
end BancoRegistradores;

architecture Behavioral of BancoRegistradores is

    component Reg8
        Port (
            clk      : in  std_logic;
            reset    : in  std_logic;
            entrada  : in  std_logic_vector(7 downto 0);
            saida    : out std_logic_vector(7 downto 0)
        );
    end component;


    -- Saídas dos registradores
    signal reg0_out : std_logic_vector(7 downto 0);
    signal reg1_out : std_logic_vector(7 downto 0);
    signal reg2_out : std_logic_vector(7 downto 0);
    signal reg3_out : std_logic_vector(7 downto 0);

    -- Entradas dos registradores
    signal reg0_in : std_logic_vector(7 downto 0);
    signal reg1_in : std_logic_vector(7 downto 0);
    signal reg2_in : std_logic_vector(7 downto 0);
    signal reg3_in : std_logic_vector(7 downto 0);

begin



    reg0_in <= dado_entrada when (we = '1' and endereco_write = "00")
               else reg0_out;

    reg1_in <= dado_entrada when (we = '1' and endereco_write = "01")
               else reg1_out;

    reg2_in <= dado_entrada when (we = '1' and endereco_write = "10")
               else reg2_out;

    reg3_in <= dado_entrada when (we = '1' and endereco_write = "11")
               else reg3_out;


    REG0 : Reg8
        port map(
            clk => clk,
            reset => reset,
            entrada => reg0_in,
            saida => reg0_out
        );

    REG1 : Reg8
        port map(
            clk => clk,
            reset => reset,
            entrada => reg1_in,
            saida => reg1_out
        );

    REG2 : Reg8
        port map(
            clk => clk,
            reset => reset,
            entrada => reg2_in,
            saida => reg2_out
        );

    REG3 : Reg8
        port map(
            clk => clk,
            reset => reset,
            entrada => reg3_in,
            saida => reg3_out
        );


    with endereco_read select
        dado_saida <=
            reg0_out when "00",
            reg1_out when "01",
            reg2_out when "10",
            reg3_out when "11",
            "00000000" when others;

end Behavioral;