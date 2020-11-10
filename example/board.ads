--  
--  Tiny_Text demo board setup
--
--  This is a STM32-H405 dev board with a PCD8544 LCD.
--
with STM32.GPIO;   use STM32.GPIO;
with STM32.Device; use STM32.Device;
with PCD8544;      use PCD8544;
with Ravenscar_Time;

package Board is
   LCD_CLK : GPIO_Point renames PB13; -- EXT2_16
   LCD_DIN : GPIO_Point renames PB15; -- EXT2_19
   LCD_RST : GPIO_Point renames PC3;  -- EXT2_9
   LCD_CS  : GPIO_Point renames PB12; -- EXT2_17
   LCD_DC  : GPIO_Point renames PC2;  -- EXT2_2

   Display : PCD8544_Device
     (Port => SPI_2'Access,
      RST  => LCD_RST'Access,
      CS   => LCD_CS'Access,
      DC   => LCD_DC'Access,
      Time => Ravenscar_Time.Delays);

   procedure Initialize;
end Board;
