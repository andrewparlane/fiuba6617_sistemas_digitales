library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;
use work.vga_timings_800_600_pkg.all;

entity adv7123_tb2 is
end entity adv7123_tb2;

architecture sim of adv7123_tb2 is
    component adv7123 is
        generic (DELAY_TICKS:   natural := 1;

                 H_ACTIVE:      natural;    -- ticks
                 H_FRONT_PORCH: natural;    -- ticks
                 H_SYNC:        natural;    -- ticks
                 H_BACK_PORCH:  natural;    -- ticks

                 V_ACTIVE:      natural;    -- líneas
                 V_FRONT_PORCH: natural;    -- líneas
                 V_SYNC:        natural;    -- líneas
                 V_BACK_PORCH:  natural);   -- líneas

        port (clk:          in  std_ulogic;
              rst:          in  std_ulogic;
              rIn:          in  std_ulogic_vector(9 downto 0);
              gIn:          in  std_ulogic_vector(9 downto 0);
              bIn:          in  std_ulogic_vector(9 downto 0);
              pixelX:       out unsigned((utils_pkg.min_width(H_ACTIVE) - 1) downto 0);
              pixelY:       out unsigned((utils_pkg.min_width(V_ACTIVE) - 1) downto 0);
              endOfFrame:   out std_ulogic;
              clkOut:       out std_ulogic;
              rOut:         out std_ulogic_vector(9 downto 0);
              gOut:         out std_ulogic_vector(9 downto 0);
              bOut:         out std_ulogic_vector(9 downto 0);
              nBlank:       out std_ulogic;
              nSync:        out std_ulogic;
              nHSync:       out std_ulogic;
              nVSync:       out std_ulogic);

    end component adv7123;

    component adv7123_sva_wrapper is
    end component adv7123_sva_wrapper;

    signal clk:         std_ulogic := '0';
    signal rst:         std_ulogic := '1';

    signal pixelX:      unsigned((PIXEL_X_WIDTH - 1) downto 0);
    signal pixelY:      unsigned((PIXEL_Y_WIDTH - 1) downto 0);

    signal nBlank:      std_ulogic;
    signal nSync:       std_ulogic;
    signal nHSync:      std_ulogic;
    signal nVSync:      std_ulogic;
    signal endOfFrame:  std_ulogic;

    signal rIn:         std_ulogic_vector(9 downto 0);
    signal gIn:         std_ulogic_vector(9 downto 0);
    signal bIn:         std_ulogic_vector(9 downto 0);

    signal rOut:        std_ulogic_vector(9 downto 0);
    signal gOut:        std_ulogic_vector(9 downto 0);
    signal bOut:        std_ulogic_vector(9 downto 0);

    signal clkOut:      std_ulogic;

    -- 50 MHz
    constant CLK_HZ:        natural := 50 * 1000 * 1000;
    constant CLK_PERIOD:    time := 1 sec / CLK_HZ;

    constant LINE_TIME:     time := getLineTime(CLK_PERIOD);
    constant FRAME_TIME:    time := getFrameTime(CLK_PERIOD);
begin

    clk <= not clk after (CLK_PERIOD/2);

    dut: adv7123    generic map(DELAY_TICKS     => 1,
                                H_ACTIVE        => H_ACTIVE,
                                H_FRONT_PORCH   => H_FRONT_PORCH,
                                H_SYNC          => H_SYNC,
                                H_BACK_PORCH    => H_BACK_PORCH,
                                V_ACTIVE        => V_ACTIVE,
                                V_FRONT_PORCH   => V_FRONT_PORCH,
                                V_SYNC          => V_SYNC,
                                V_BACK_PORCH    => V_BACK_PORCH)
                    port map(clk => clk,
                             rst => rst,
                             rIn => rIn,
                             gIn => gIn,
                             bIn => bIn,
                             pixelX => pixelX,
                             pixelY => pixelY,
                             endOfFrame => endOfFrame,
                             clkOut => clkOut,
                             rOut => rOut,
                             gOut => gOut,
                             bOut => bOut,
                             nBlank => nBlank,
                             nSync  => nSync,
                             nHSync => nHSync,
                             nVSync => nVSync);

    sva:    adv7123_sva_wrapper;

    process (all)
    begin
        if ((pixelY >= to_unsigned(100, pixelX'length) and
             pixelY < to_unsigned(200, pixelX'length)) or
            (pixelY >= to_unsigned(300, pixelX'length) and
             pixelY < to_unsigned(400, pixelX'length)) or
            (pixelY >= to_unsigned(500, pixelX'length) and
             pixelY < to_unsigned(600, pixelX'length))) then
            rIn <= (others => '0');
            gIn <= (others => '0');
            bIn <= (others => '0');
        else
            if ((pixelX >= to_unsigned(0, pixelX'length) and
                 pixelX < to_unsigned(100, pixelX'length)) or
                (pixelX >= to_unsigned(300, pixelX'length) and
                 pixelX < to_unsigned(400, pixelX'length)) or
                (pixelX >= to_unsigned(600, pixelX'length) and
                 pixelX < to_unsigned(700, pixelX'length))) then
                rIn <= (others => '1');
            else
                rIn <= (others => '0');
            end if;

            if ((pixelX >= to_unsigned(100, pixelX'length) and
                 pixelX < to_unsigned(200, pixelX'length)) or
                (pixelX >= to_unsigned(400, pixelX'length) and
                 pixelX < to_unsigned(500, pixelX'length)) or
                (pixelX >= to_unsigned(700, pixelX'length) and
                 pixelX < to_unsigned(800, pixelX'length))) then
                gIn <= (others => '1');
            else
                gIn <= (others => '0');
            end if;

            if ((pixelX >= to_unsigned(200, pixelX'length) and
                 pixelX < to_unsigned(300, pixelX'length)) or
                (pixelX >= to_unsigned(500, pixelX'length) and
                 pixelX < to_unsigned(600, pixelX'length))) then
                bIn <= (others => '1');
            else
                bIn <= (others => '0');
            end if;
        end if;
    end process;

    process
    begin
        report ("CLK_HZ " & integer'image(CLK_HZ) & "Hz" &
                " -> periodo " & time'image(CLK_PERIOD) &
                " -> " & integer'image(1000000000 / (getFrameTime(CLK_PERIOD) / 1 ns)) &
                " cuadras cada segundo");
        rst <= '1';
        wait for CLK_PERIOD * 5;
        rst <= '0';
        wait for (2 * FRAME_TIME);
        rst <= '1';
        wait for 100 ns;
        std.env.stop;
    end process;

end architecture sim;