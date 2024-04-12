--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
generic
   Width, Height : Positive;
   with procedure Set_Pixel (X, Y : Natural; Set : Boolean);
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
   --  Resets Cursor to (0, 0) and calls Set_Pixel with Set => False for every
   --  pixel on the screen. This is inefficient for most displays and should
   --  only be used as a fallback.

   procedure Put
      (Ch : Character);
   procedure Put
      (Str : String);
   procedure Put_Line
      (Str : String);
   procedure New_Line;

end Generic_Tiny_Text;
