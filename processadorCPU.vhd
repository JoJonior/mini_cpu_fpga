library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity processadorCPU is
    Port ( 
          
          clk      : in std_logic;
          reset    : in std_logic;

          -- Entradas externas
          Ent1     : in std_logic_vector(7 downto 0);
          Ent2     : in std_logic_vector(7 downto 0);

          -- Operação da ULA
          opcode   : in std_logic_vector(2 downto 0);

          -- Resultado
          Display  : out std_logic_vector(7 downto 0)

    );
end processadorCPU;

architecture Behavioral of processadorCPU is

    ------------------------------------------------
    -- COMPONENTE REGISTRADOR
    ------------------------------------------------

    component Reg8
        Port (
            clk      : in  std_logic;
            reset    : in  std_logic;

            entrada  : in  std_logic_vector(7 downto 0);

            saida    : out std_logic_vector(7 downto 0)
        );
    end component;

    ------------------------------------------------
    -- COMPONENTE ULA
    ------------------------------------------------

    component ULA
        Port (
            A         : in std_logic_vector(7 downto 0);
            B         : in std_logic_vector(7 downto 0);

            opcode    : in std_logic_vector(2 downto 0);

            resultado : out std_logic_vector(7 downto 0);

            zero      : out std_logic
        );
    end component;

    ------------------------------------------------
    -- SINAIS INTERNOS
    ------------------------------------------------

    signal regA_out : std_logic_vector(7 downto 0);
    signal regB_out : std_logic_vector(7 downto 0);

    signal ula_resultado : std_logic_vector(7 downto 0);

begin

    ------------------------------------------------
    -- REGISTRADOR A
    ------------------------------------------------

    REG_A : Reg8
    port map(

        clk => clk,

        reset => reset,

        entrada => Ent1,

        saida => regA_out

    );

    ------------------------------------------------
    -- REGISTRADOR B
    ------------------------------------------------

    REG_B : Reg8
    port map(

        clk => clk,

        reset => reset,

        entrada => Ent2,

        saida => regB_out

    );

    ------------------------------------------------
    -- ULA
    -- continua usando as entradas diretamente
    ------------------------------------------------

    MINHA_ULA : ULA
    port map(

        A => Ent1,

        B => Ent2,

        opcode => opcode,

        resultado => ula_resultado,

        zero => open

    );

    ------------------------------------------------
    -- SAÍDA FINAL
    ------------------------------------------------

    Display <= ula_resultado;

end Behavioral;