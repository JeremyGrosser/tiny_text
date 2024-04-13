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
      Text.Clear;
      for Ch in Text.Printable'Range loop
         Text.Put (Ch);
         Delays.Delay_Milliseconds (10);
      end loop;
      Screen.Update;
      Delays.Delay_Seconds (1);
   end loop;
end Tiny_Text_Example;
