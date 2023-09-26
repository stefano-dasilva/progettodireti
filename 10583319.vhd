library IEEE;
use ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_1164.ALL;

    entity project_reti_logiche is
         port (
             i_clk : in std_logic;
             i_rst : in std_logic;
             i_start : in std_logic; 
             i_w : in std_logic; 
             
             o_z0 : out std_logic_vector(7 downto 0); 
             o_z1 : out std_logic_vector(7 downto 0); 
             o_z2 : out std_logic_vector(7 downto 0); 
             o_z3 : out std_logic_vector(7 downto 0); 
             o_done : out std_logic; 
             
             o_mem_addr : out std_logic_vector(15 downto 0); 
             i_mem_data : in std_logic_vector(7 downto 0); 
             o_mem_we : out std_logic; 
             o_mem_en : out std_logic 
         ); 
     end project_reti_logiche;
 
architecture project_reti_logiche_arch of project_reti_logiche is

    component datapath is 
    
     port ( 
           i_clk : in std_logic;
           i_rst : in std_logic;
           i_w   : in std_logic;
           o_mem_addr   : out std_logic_vector(15 downto 0) ;
           i_mem_data    : in std_logic_vector(7 downto 0) ;
           
           reg1_load : in std_logic;
           mem_data_load : in std_logic;
           reg4_load : in std_logic;
           reg5_load : in std_logic;
           reg6_load : in std_logic;
           reg7_load : in std_logic;
           select_dmux_load : in std_logic;
           reg_mem_addr_load : in std_logic;
                 
                 
           reg1_rst : in std_logic;
           reg2_rst : in std_logic;
           mem_data_rst : in std_logic;
           select_dmux_rst : in std_logic;
           reg_mem_addr_rst : in std_logic;
                                 
           reg4_7_selectors : out std_logic_vector(1 downto 0);
               
           o_z0    : out std_logic_vector(7 downto 0) ;
           o_z1    : out std_logic_vector(7 downto 0) ;
           o_z2    : out std_logic_vector(7 downto 0) ;
           o_z3    : out std_logic_vector(7 downto 0) ;
           
           input_reg_sel_rst : in std_logic;
           input_reg_sel_out : out std_logic;

           enable_rst : in std_logic;                
                      
           mux_sel : in std_logic
                                                                    
           );
   end component;
         
         signal reg1_load, mem_data_load, reg4_load, reg5_load, reg6_load, reg7_load, reg_mem_addr_load, select_dmux_load:  std_logic;      
         signal reg1_rst, reg2_rst, mem_data_rst, select_dmux_rst, reg_mem_addr_rst : std_logic;
         signal reg4_7_selectors :  std_logic_vector(1 downto 0);      
         signal input_reg_sel_rst,enable_rst :  std_logic;
         signal mux_sel   :  std_logic;
         signal input_reg_sel_out : std_logic;               
            
         type S is (WAIT_START,SEL_CHANNEL,SEL_MEM_ADDR,FETCH_MEM,SAVE_MEM_DATA,PREP_VALUE4,PREP_VALUE5,PREP_VALUE6,PREP_VALUE7, PROD_OUT);
         signal curr_state, next_state : S; 


begin
    
    DATAPATH0: datapath port map(
     i_clk => i_clk           ,
     i_rst => i_rst           ,
     i_w  => i_w              ,
     o_mem_addr => o_mem_addr ,
     i_mem_data => i_mem_data ,          
     reg1_load  => reg1_load  ,
     mem_data_load  => mem_data_load  ,         
     o_z0       => o_z0       ,
     o_z1       => o_z1       ,
     o_z2       => o_z2       ,
     o_z3       => o_z3       ,         
     input_reg_sel_rst  => input_reg_sel_rst  ,
     mux_sel    => mux_sel    ,
     reg4_load => reg4_load     ,
     reg5_load => reg5_load     ,
     reg6_load => reg6_load     ,
     reg7_load => reg7_load     ,   
     reg1_rst => reg1_rst ,
     reg2_rst => reg2_rst,
     reg4_7_selectors => reg4_7_selectors ,
     input_reg_sel_out => input_reg_sel_out,     
     mem_data_rst => mem_data_rst,    
     select_dmux_rst => select_dmux_rst ,
     select_dmux_load => select_dmux_load,
     enable_rst => enable_rst,
     reg_mem_addr_rst =>  reg_mem_addr_rst,
     reg_mem_addr_load =>  reg_mem_addr_load   
    );
       
-----------------FSM-------------------

---------------------------------------
    process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            curr_state <= WAIT_START;
        elsif rising_edge (i_clk) then
            curr_state <= next_state;
        end if;
    end process;  
--------------------------------------

     process(curr_state, i_start, input_reg_sel_out, reg4_7_selectors)
    begin
        next_state <= curr_state;
 
        case curr_state is
            when WAIT_START =>
                if i_start = '1' then
                    next_state <= SEL_CHANNEL; 
                end if;         
            when SEL_CHANNEL =>
                if input_reg_sel_out = '1' or i_start = '0'  then              
                    next_state <= SEL_MEM_ADDR;                   
                end if;              
            when SEL_MEM_ADDR =>
                if i_start = '0' then
                    next_state <=  FETCH_MEM;
                end if;
            when FETCH_MEM =>
                next_state <= SAVE_MEM_DATA;
            when SAVE_MEM_DATA =>
                if(reg4_7_selectors = "00") then
                next_state <= PREP_VALUE4;
                elsif(reg4_7_selectors = "01") then
                next_state <= PREP_VALUE5;
                elsif(reg4_7_selectors = "10") then
                next_state <= PREP_VALUE6;
                elsif(reg4_7_selectors = "11") then
                next_state <= PREP_VALUE7;
                end if;
            when PREP_VALUE4 =>
                next_state <= PROD_OUT;
            when PREP_VALUE5 =>
                 next_state <= PROD_OUT;
            when PREP_VALUE6 =>
                 next_state <= PROD_OUT;
            when PREP_VALUE7 =>
                 next_state <= PROD_OUT;                                                           
            when PROD_OUT  =>
                next_state <= WAIT_START;          
        end case;
    end process;
       
---------------------------------------------------------------------------------
   
     process( curr_state )
     begin   
     
     reg1_load <= '0';
     mem_data_load <= '0';
     reg4_load <= '0';
     reg5_load <= '0';
     reg6_load <= '0';
     reg7_load <= '0';       
     o_done <= '0';
     mux_sel <= '0';
     o_mem_en <= '0';
     o_mem_we <= '0';
     input_reg_sel_rst <= '1';
     reg1_rst <= '0';
     reg2_rst <= '0';
     mem_data_rst <= '0';
     select_dmux_load <= '0';
     select_dmux_rst <= '1';
     enable_rst <= '1';
     reg_mem_addr_load <= '0';
     reg_mem_addr_rst <= '1';
        
        case curr_state is 
            when WAIT_START =>
                mux_sel <= '0';  
                o_done <= '0';
                reg1_rst <= '0';
                reg1_load <= '1';
                select_dmux_rst <= '0';
                select_dmux_load <= '1';        
                                                                 
            when SEL_CHANNEL =>
               enable_rst <= '0';
               reg1_load <= '1';
               input_reg_sel_rst <= '0';  
               select_dmux_rst <= '0';
              select_dmux_load <= '1'; 
               o_done <= '0';
                                                 
            when SEL_MEM_ADDR =>         
                enable_rst <= '0';          
                reg1_rst <= '1';
                reg1_load <= '0';
                input_reg_sel_rst <= '1';
                select_dmux_rst <= '0';
                select_dmux_load <= '0';    
                 reg_mem_addr_rst <= '0';
                 reg_mem_addr_load <= '1';    
                o_done <= '0'; 
                         
            when FETCH_MEM =>                        
                 o_mem_en <= '1';
                 reg2_rst <= '1';
                 reg_mem_addr_rst <= '0';
                 reg_mem_addr_load <= '1';  
                 select_dmux_rst <= '0';
                 select_dmux_load <= '0';    
                 o_done <= '0'; 
                        
            when SAVE_MEM_DATA =>
            
                mem_data_rst <= '0';
                mem_data_load <= '1';
                 reg_mem_addr_rst <= '1';
               select_dmux_rst <= '0';
               o_done <= '0';
            
            when PREP_VALUE4  =>
                reg4_load <= '1';
                mem_data_load <= '0';
                o_done <= '0';
                select_dmux_rst <= '0';

            when PREP_VALUE5  =>
                 reg5_load <= '1';
                 mem_data_load <= '0';
                 o_done <= '0';
                 select_dmux_rst <= '0';

            when PREP_VALUE6  =>
                 reg6_load <= '1';
                 mem_data_load <= '0';
                 o_done <= '0';
                 select_dmux_rst <= '0';

            when PREP_VALUE7 =>
                 reg7_load <= '1';
                 mem_data_load <= '0';     
                 o_done <= '0';
                 select_dmux_rst <= '0';
                                                   
            when PROD_OUT =>
                mux_sel <= '1';
                o_done <= '1';
                select_dmux_rst <= '1';
                reg4_load <= '0';
                reg5_load <= '0';
                reg6_load <= '0';
                reg7_load <= '0';  
                reg1_rst <= '1';  
                reg2_rst <= '1'; 
                mem_data_rst <= '1';
   
                     
            end case;     
     end process;

end project_reti_logiche_arch;

----------------DATAPATH----------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity datapath is 
    port ( 
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_w   : in std_logic;
        o_mem_addr   : out std_logic_vector(15 downto 0) ;
        i_mem_data    : in std_logic_vector(7 downto 0) ;
        
        reg1_load : in std_logic;
        mem_data_load : in std_logic;
        reg4_load: in std_logic;
        reg5_load: in std_logic;        
        reg6_load: in std_logic;
        reg7_load: in std_logic;   
        select_dmux_load : in std_logic;
        reg_mem_addr_load : in std_logic;
            
        reg1_rst : in std_logic;
        reg2_rst : in std_logic;
        mem_data_rst : in std_logic;
        select_dmux_rst : in std_logic;
        reg_mem_addr_rst : in std_logic;
              
        reg4_7_selectors : out std_logic_vector(1 downto 0);
              
        o_z0    : out std_logic_vector(7 downto 0) ;
        o_z1    : out std_logic_vector(7 downto 0) ;
        o_z2    : out std_logic_vector(7 downto 0) ;
        o_z3    : out std_logic_vector(7 downto 0) ;
        
        input_reg_sel_rst : in std_logic;
        input_reg_sel_out : out std_logic;
             
        mux_sel : in std_logic;
        
        enable_rst : in std_logic       
             
        );
end datapath;


architecture Behavioral of datapath is

    signal reg1_out : STD_LOGIC_VECTOR (1 downto 0);
    signal reg2_out : STD_LOGIC_VECTOR (15 downto 0);
    signal mem_data_out : std_logic_vector (7 downto 0);
    signal dmux_outz0, dmux_outz1, dmux_outz2, dmux_outz3 :  std_logic_vector(7 downto 0) := "00000000";
    signal reg4_out,reg5_out,reg6_out,reg7_out :  std_logic_vector(7 downto 0);
    signal input_reg_sel : STD_LOGIC;
    signal enable_out : STD_LOGIC;
    signal select_dmux_out : std_logic_vector ( 1 downto 0);
    signal reg_mem_addr_out : STD_LOGIC_VECTOR (15 downto 0);
    
       
begin

    
-----DEMULTIPLEXER-------------------------------------------------------------------------------------------------------------------------------------------------
    
    dmux_outz0 <= mem_data_out when select_dmux_out = "00" else "00000000"   ;
    dmux_outz1 <= mem_data_out when select_dmux_out = "01" else "00000000"   ;
    dmux_outz2 <= mem_data_out when select_dmux_out = "10" else "00000000"  ;
    dmux_outz3 <= mem_data_out when select_dmux_out = "11" else "00000000"  ;

----REG1SITRO1----------------------------------------------------------------------------------------------------------------------------------------------------

    reg1_write : process (i_clk, i_rst, reg1_rst, reg1_load)
    
begin
    if  i_rst = '1' or reg1_rst = '1' then
             reg1_out <= "00";
    elsif i_clk'event and i_clk = '1' then
            if( reg1_load = '1' ) then
                 reg1_out( 1) <= reg1_out(0);
                 reg1_out(0) <= i_w;
            else
                 reg1_out <= reg1_out;
            end if;
     end if;     
  end process;     

----REGDSEL--------------------------------------------------------------------------------------------------------------------------------------------------

    select_dmux_write : process (i_clk, i_rst,select_dmux_rst)
    
begin
    if  i_rst = '1' or select_dmux_rst = '1' then
            select_dmux_out <= "00";
        elsif i_clk'event and i_clk = '1' then
            if( select_dmux_load = '1') then
            select_dmux_out <= reg1_out;         
        end if;    
       end if;     
     end process;   
    
----REGISTROMEMADDR------------------------------------------------------------------------------------------------------------------------------------------

    reg_mem_addr_write : process (i_clk, i_rst,  reg_mem_addr_rst)
    
begin
    if  i_rst = '1' or  reg_mem_addr_rst = '1' then
            reg_mem_addr_out <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if(  reg_mem_addr_load = '1') then
             reg_mem_addr_out <= reg2_out;         
        end if;    
       end if;     
     end process;   
     
----REG1SITRO2---------------------------------------------------------------------------------------------------------------------------------------------------

  reg2_write : process ( i_clk, i_rst , reg2_rst)
begin
    if  i_rst = '1' or reg2_rst = '1' then
        reg2_out <= "0000000000000000";
    elsif rising_edge(i_clk) then
        if (enable_out = '1') then
            reg2_out( 15 downto 1 ) <= reg2_out(14 downto 0);
            reg2_out(0) <= i_w;
        end if;
    end if;
end process;   

----REG1SITRO3-------------------------------------------------------------------------------------------------------------------------------------------------

    mem_data_write : process ( i_clk, i_rst, mem_data_rst)
    begin
        if  i_rst = '1' or mem_data_rst = '1' then
            mem_data_out <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if( mem_data_load = '1') then
            mem_data_out <= i_mem_data ;
            end if;
       end if;     
     end process;  

----REG1SITRO4------------------------------------------------------------------------------------------------------------------------------------------------

    reg4_write : process ( i_clk, i_rst)
    begin
        if  i_rst = '1' then
            reg4_out <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if( reg4_load = '1') then
            reg4_out <= dmux_outz0 ;
            end if;
       end if;     
     end process;    

----REG1SITRO5--------------------------------------------------------------------------------------------------------------------------------------------------

    reg5_write : process ( i_clk, i_rst)
    begin
        if  i_rst = '1' then
            reg5_out <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if( reg5_load = '1') then
            reg5_out <= dmux_outz1 ;
            end if;
       end if;     
     end process;         

----REG1SITRO6-------------------------------------------------------------------------------------------------------------------------------------------------

    reg6_write : process ( i_clk, i_rst)
    begin
        if  i_rst = '1' then
            reg6_out <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if( reg6_load = '1') then
            reg6_out <= dmux_outz2 ;
            end if;
       end if;     
     end process;    

----REG1SITRO7----------------------------------------------------------------------------------------------------------------------------------------------------

    reg7_write : process ( i_clk, i_rst)
    begin
        if  i_rst = '1' then
            reg7_out <= "00000000";
        elsif i_clk'event and i_clk = '1' then
            if( reg7_load = '1') then
            reg7_out <= dmux_outz3 ;
            end if;
       end if;     
     end process;    
  
----MUX4----------------------------------------------------------------------------------------------------------------------------------------------------------

    with mux_sel select
        o_z0 <= reg4_out(7 downto 0) when '1',
                "00000000" when '0',
                "XXXXXXXX" when others;
 
----MUX5----------------------------------------------------------------------------------------------------------------------------------------------------------  
                  
    with mux_sel select
    o_z1 <= reg5_out(7 downto 0) when '1',
            "00000000" when '0',
            "XXXXXXXX" when others;    

----MUX6---------------------------------------------------------------------------------------------------------------------------------------------------------

    with mux_sel select
        o_z2 <= reg6_out(7 downto 0) when '1',
                "00000000" when '0',
                "XXXXXXXX" when others;
                
----MUX7----------------------------------------------------------------------------------------------------------------------------------------------------
                  
    with mux_sel select
    o_z3 <= reg7_out(7 downto 0) when '1',
            "00000000" when '0',
            "XXXXXXXX" when others;
                                              
--------SLEZIONE---------------------------------------------------------------------------------------------------------------------------------------------
    
    input_reg_sel_out <= '1' when (input_reg_sel = '1') else '0';
    
-------------CONTATORE-----------------------------------------------------------------------------------------------------------------------------------------

    process (input_reg_sel_rst, i_clk)
    begin
        if (input_reg_sel_rst = '1') then
            input_reg_sel <= '0';
        elsif i_clk'event and i_clk = '1' then  
          input_reg_sel <= '1';
        end if;
    end process;  
      
 -------------CONTATORE2--------------------------------------------------------------------------------------------------------------------------------------
    
        process (enable_rst,  i_clk)
        begin
            if (enable_rst = '1') then
                enable_out <= '0';
            elsif (i_clk'event and i_clk = '1' and enable_rst = '0') then           
              enable_out <='1';
            end if;
        end process;     

-------------------SELETTORE---------------------------------------------------------------------------------------------------------------------------

    reg4_7_selectors <= select_dmux_out; 
 
----------ASSEGNAMENTO INDIRIZZO MEMORIA---------------------------------------------------------------------------------------------------------------- 

    o_mem_addr <=  reg_mem_addr_out;
         
------------------------------------------------------------------------------------------------------------------------------------------------------
  
end Behavioral;