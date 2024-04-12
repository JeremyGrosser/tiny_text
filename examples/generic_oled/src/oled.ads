--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
--  ER-OLEDM0.42-1W-I2C
--  https://www.buydisplay.com/i2c-white-0-42-inch-oled-display-module-72x40-arduino-raspberry-pi
--  SSD1306B controller
--
--  This display has a different initialization sequence from other SSD1306
--  based OLED screens because the screen pixels start at segment 28, not 0
--  https://www.buydisplay.com/download/manual/ER-OLED0.42-1_Datasheet.pdf
--
with HAL; use HAL;

generic
   with procedure Write (Data : UInt8_Array);
package OLED
   with Preelaborate
is
   Width    : constant := 72;
   Height   : constant := 40;

   subtype Column is Integer range 0 .. Width - 1;
   subtype Row    is Integer range 0 .. Height - 1;

   procedure Initialize;

   procedure Set_Pixel
      (X   : Column;
       Y   : Row;
       Set : Boolean);

   procedure Update;

   procedure Clear;

end OLED;
