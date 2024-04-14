--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
with Board; use Board;

procedure Tiny_Text_Example is
begin
   loop
      if not Ready then
         Initialize;
      end if;

      for Ch in Text.Printable'Range loop
         Text.Put (Ch);
         Delays.Delay_Milliseconds (10);
         Screen.Update;
      end loop;
   end loop;
end Tiny_Text_Example;
