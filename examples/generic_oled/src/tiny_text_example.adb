--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
with Board; use Board;

procedure Tiny_Text_Example is
begin
   Initialize;

   loop
      Text.Put_Line ("hello world!");
      Screen.Update;
      Delays.Delay_Seconds (1);
   end loop;
end Tiny_Text_Example;
