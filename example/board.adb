with STM32.SPI; use STM32.SPI;
with HAL.SPI;   use HAL.SPI;

package body Board is
   procedure Initialize is
      Pins : GPIO_Points := (LCD_RST, LCD_DC, LCD_CS);
   begin
      Enable_Clock (LCD_DIN & LCD_CLK);
      Enable_Clock (Pins);
      Set (Pins);
      Configure_IO
        (Pins,
         (Resistors   => Pull_Up,
          Mode        => Mode_Out,
          Output_Type => Push_Pull,
          Speed       => Speed_25MHz));

      Configure_IO
        (LCD_DIN & LCD_CLK,
         (Resistors      => Pull_Up,
          Mode           => Mode_AF,
          AF_Output_Type => Push_Pull,
          AF_Speed       => Speed_25MHz,
          AF             => GPIO_AF_SPI2_5));

      Enable_Clock (SPI_2);
      Configure
        (SPI_2,
         (Direction           => D2Lines_FullDuplex,
          Mode                => Master,
          Data_Size           => Data_Size_8b,
          Clock_Polarity      => High,
          Clock_Phase         => P2Edge,
          Slave_Management    => Software_Managed,
          Baud_Rate_Prescaler => BRP_8,
          First_Bit           => MSB,
          CRC_Poly            => 0));
      Enable (SPI_2);

      Display.Initialize;
      Display.Set_Bias (3);
      Display.Set_Contrast (60);
   end Initialize;
end Board;
