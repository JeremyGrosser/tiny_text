--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
pragma Style_Checks ("M120");
with PCD8544;
with HAL.Bitmap;
with Tiny_Text;

with RP.Timer.Interrupts;
with RP.Clock;
with RP.GPIO;
with RP.SPI;
with RP2040_SVD.SPI;

procedure Tiny_Text_Example is
   MOSI  : RP.GPIO.GPIO_Point := (Pin => 2);
   MISO  : RP.GPIO.GPIO_Point := (Pin => 3);
   SCK   : RP.GPIO.GPIO_Point := (Pin => 4);
   DC    : aliased RP.GPIO.GPIO_Point := (Pin => 5);
   RST   : aliased RP.GPIO.GPIO_Point := (Pin => 6);
   CS    : aliased RP.GPIO.GPIO_Point := (Pin => 7);
   Port  : aliased RP.SPI.SPI_Port
      (0, RP2040_SVD.SPI.SPI0_Periph'Access);

   Timer : aliased RP.Timer.Interrupts.Delays;

   LCD : PCD8544.PCD8544_Device
      (Port => Port'Unchecked_Access,
       DC   => DC'Unchecked_Access,
       RST  => RST'Unchecked_Access,
       CS   => CS'Unchecked_Access,
       Time => Timer'Unchecked_Access);

   Text : Tiny_Text.Text_Buffer;
begin
   RP.Clock.Initialize (12_000_000);

   MOSI.Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.SPI);
   MISO.Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.SPI);
   SCK.Configure (RP.GPIO.Output, RP.GPIO.Floating, RP.GPIO.SPI);
   DC.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up);
   RST.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up);
   CS.Configure (RP.GPIO.Output, RP.GPIO.Pull_Up);
   Port.Configure;

   LCD.Initialize;
   LCD.Initialize_Layer
      (Layer  => 1,
       Mode   => HAL.Bitmap.M_1,
       X      => 0,
       Y      => 0,
       Width  => LCD.Width,
       Height => LCD.Height);
   LCD.Set_Display_Mode (Enable => True, Invert => False);

   Text.Initialize
      (Bitmap  => LCD.Hidden_Buffer (Layer => 1),
       Width   => LCD.Width,
       Height  => LCD.Height,
       Scale   => 1);

   Timer.Enable;

   loop
      Text.Put_Line ("hello");
      LCD.Update_Layers;
      Timer.Delay_Seconds (1);
   end loop;
end Tiny_Text_Example;
