--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
with HAL.Bitmap;
with SSD1306.Standard_Resolutions;
with RP.I2C_Master; use RP.I2C_Master;
with RP.GPIO; use RP.GPIO;
with RP.Clock;
with RP.Device;
with Pico;

with Tiny_Text;

procedure Tiny_Text_Example is
   SDA  : GPIO_Point renames Pico.GP0;
   SCL  : GPIO_Point renames Pico.GP1;
   RST  : GPIO_Point renames Pico.GP2;
   Port : I2C_Master_Port renames RP.Device.I2CM_0;

   OLED : SSD1306.Standard_Resolutions.SSD1306_128x32_Screen
      (Port => Port'Access,
       RST  => RST'Access,
       Time => RP.Device.Timer'Access);
   Text : Tiny_Text.Text_Buffer;
begin
   RP.Clock.Initialize (Pico.XOSC_Frequency);
   RP.Device.Timer.Enable;
   Port.Configure (Baudrate => 100_000);
   SDA.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
   SCL.Configure (Output, Pull_Up, RP.GPIO.I2C, Schmitt => True);
   OLED.Initialize (External_VCC => False);
   OLED.Initialize_Layer (1, HAL.Bitmap.M_1);
   Text.Initialize
      (Bitmap => OLED.Hidden_Buffer (1),
       Width  => OLED.Width,
       Height => OLED.Height);
   OLED.Turn_On;
   loop
      for Ch in Tiny_Text.Printable'Range loop
         Text.Put (Ch);
         OLED.Update_Layers;
         RP.Device.Timer.Delay_Milliseconds (10);
      end loop;
      RP.Device.Timer.Delay_Seconds (10);
      Text.Clear;
   end loop;
end Tiny_Text_Example;
