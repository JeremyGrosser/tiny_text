--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
with RP.GPIO; use RP.GPIO;
with RP.Clock;
with RP2040_SVD.I2C;
with RP.I2C_Master;
with HAL.I2C;

package body Board is

   OLED_Port  : RP.I2C_Master.I2C_Master_Port (0, RP2040_SVD.I2C.I2C0_Periph'Access);
   OLED_Addr  : constant HAL.I2C.I2C_Address := 2#0111100_0#;
   OLED_Ready : Boolean := False;

   SDA : GPIO_Point := (Pin => 2);
   SCL : GPIO_Point := (Pin => 3);
   RST : GPIO_Point := (Pin => 4);

   procedure Initialize is
   begin
      RP.Clock.Initialize (12_000_000);
      Delays.Enable;
      SDA.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
      SCL.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
      RST.Configure (Output, Pull_Up);
      OLED_Port.Configure (400_000);
      Text.Clear;
   end Initialize;

   procedure OLED_Write
      (Data : HAL.UInt8_Array)
   is
      use HAL.I2C;
      Status : I2C_Status;
   begin
      if not OLED_Ready then
         Screen.Initialize;
         OLED_Ready := True;
      end if;

      OLED_Port.Master_Transmit (OLED_Addr, I2C_Data (Data), Status, Timeout => 100);
      if Status /= Ok then
         OLED_Ready := False;
      end if;
   end OLED_Write;

end Board;
