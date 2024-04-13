--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
generic
   Width, Height : Positive;
   with procedure Set_Pixel (X, Y : Natural);
   with procedure Clear_Screen;
package Generic_Tiny_Text
   with Pure
is
   Scale : Positive := 1;

   type Point is record
      X, Y : Natural := 0;
   end record;

   subtype Printable is Character range ' ' .. '~';

   procedure Put
      (Pos : Point;
       Ch  : Character);

   Cursor : Point := (0, 0);

   procedure Clear;
   --  Resets Cursor to (0, 0) and calls Clear_Screen.

   procedure Put
      (Ch : Character);
   procedure Put
      (Str : String);
   procedure Put_Line
      (Str : String);
   procedure New_Line;

end Generic_Tiny_Text;
