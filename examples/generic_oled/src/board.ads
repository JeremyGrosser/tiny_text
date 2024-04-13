--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
with RP.Timer.Interrupts;
with Generic_Tiny_Text;
with OLED;
with HAL;

package Board is

   Delays : RP.Timer.Interrupts.Delays;

   procedure Initialize;

   procedure OLED_Write
      (Data : HAL.UInt8_Array);

   package Screen is new OLED
      (Write => OLED_Write);

   procedure Set_Pixel
      (X, Y : Natural);

   package Text is new Generic_Tiny_Text
      (Set_Pixel     => Set_Pixel,
       Clear_Screen  => Screen.Clear,
       Width         => Screen.Width,
       Height        => Screen.Height);

end Board;
