--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
with Interfaces; use Interfaces;

package body Generic_Tiny_Text is
   Font_Width  : constant := 3;
   Font_Height : constant := 6;

   type Font_Character is mod 2 ** 18 with Size => 18;
   type Font_Array is array (Character) of Font_Character;
   Font_Data : constant Font_Array := (
      ' ' => 2#000_000_000_000_000_000#,
      '!' => 2#010_010_010_000_010_000#,
      '"' => 2#101_101_000_000_000_000#,
      '#' => 2#101_111_101_111_101_000#,
      '$' => 2#011_110_011_110_010_000#,
      '%' => 2#100_001_010_100_001_000#,
      '&' => 2#110_110_111_101_011_000#,
      ''' => 2#010_010_000_000_000_000#,
      '(' => 2#001_010_010_010_001_000#,
      ')' => 2#100_010_010_010_100_000#,
      '*' => 2#101_010_101_000_000_000#,
      '+' => 2#000_010_111_010_000_000#,
      ',' => 2#000_000_000_010_100_000#,
      '-' => 2#000_000_111_000_000_000#,
      '.' => 2#000_000_000_000_010_000#,
      '/' => 2#001_001_010_100_100_000#,
      '0' => 2#011_101_101_101_110_000#,
      '1' => 2#010_110_010_010_010_000#,
      '2' => 2#110_001_010_100_111_000#,
      '3' => 2#110_001_010_001_110_000#,
      '4' => 2#101_101_111_001_001_000#,
      '5' => 2#111_100_110_001_110_000#,
      '6' => 2#011_100_111_101_111_000#,
      '7' => 2#111_001_010_100_100_000#,
      '8' => 2#111_101_111_101_111_000#,
      '9' => 2#111_101_111_001_110_000#,
      ':' => 2#000_010_000_010_000_000#,
      ';' => 2#000_010_000_010_100_000#,
      '<' => 2#001_010_100_010_001_000#,
      '=' => 2#000_111_000_111_000_000#,
      '>' => 2#100_010_001_010_100_000#,
      '?' => 2#111_001_010_000_010_000#,
      '@' => 2#010_101_111_100_011_000#,
      'A' => 2#010_101_111_101_101_000#,
      'B' => 2#110_101_110_101_110_000#,
      'C' => 2#011_100_100_100_011_000#,
      'D' => 2#110_101_101_101_110_000#,
      'E' => 2#111_100_111_100_111_000#,
      'F' => 2#111_100_111_100_100_000#,
      'G' => 2#011_100_111_101_011_000#,
      'H' => 2#101_101_111_101_101_000#,
      'I' => 2#111_010_010_010_111_000#,
      'J' => 2#001_001_001_101_010_000#,
      'K' => 2#101_101_110_101_101_000#,
      'L' => 2#100_100_100_100_111_000#,
      'M' => 2#101_111_111_101_101_000#,
      'N' => 2#101_111_111_111_101_000#,
      'O' => 2#010_101_101_101_010_000#,
      'P' => 2#110_101_110_100_100_000#,
      'Q' => 2#010_101_101_111_011_000#,
      'R' => 2#110_101_111_110_101_000#,
      'S' => 2#011_100_010_001_110_000#,
      'T' => 2#111_010_010_010_010_000#,
      'U' => 2#101_101_101_101_011_000#,
      'V' => 2#101_101_101_010_010_000#,
      'W' => 2#101_101_111_111_101_000#,
      'X' => 2#101_101_010_101_101_000#,
      'Y' => 2#101_101_010_010_010_000#,
      'Z' => 2#111_001_010_100_111_000#,
      '[' => 2#111_100_100_100_111_000#,
      '\' => 2#000_100_010_001_000_000#,
      ']' => 2#111_001_001_001_111_000#,
      '^' => 2#010_101_000_000_000_000#,
      '_' => 2#000_000_000_000_111_000#,
      '`' => 2#100_010_000_000_000_000#,
      'a' => 2#000_110_011_101_111_000#,
      'b' => 2#100_110_101_101_110_000#,
      'c' => 2#000_011_100_100_011_000#,
      'd' => 2#001_011_101_101_011_000#,
      'e' => 2#000_011_101_110_011_000#,
      'f' => 2#001_010_111_010_010_000#,
      'g' => 2#000_011_101_111_001_010#,
      'h' => 2#100_110_101_101_101_000#,
      'i' => 2#010_000_010_010_010_000#,
      'j' => 2#001_000_001_001_101_010#,
      'k' => 2#100_101_110_110_101_000#,
      'l' => 2#110_010_010_010_111_000#,
      'm' => 2#000_111_111_111_101_000#,
      'n' => 2#000_110_101_101_101_000#,
      'o' => 2#000_010_101_101_010_000#,
      'p' => 2#000_110_101_101_110_100#,
      'q' => 2#000_011_101_101_011_001#,
      'r' => 2#000_011_100_100_100_000#,
      's' => 2#000_011_110_011_110_000#,
      't' => 2#010_111_010_010_011_000#,
      'u' => 2#000_101_101_101_011_000#,
      'v' => 2#000_101_101_111_010_000#,
      'w' => 2#000_101_111_111_111_000#,
      'x' => 2#000_101_010_010_101_000#,
      'y' => 2#000_101_101_011_001_010#,
      'z' => 2#000_111_011_110_111_000#,
      '{' => 2#011_010_100_010_011_000#,
      '|' => 2#010_010_000_010_010_000#,
      '}' => 2#110_010_001_010_110_000#,
      '~' => 2#011_110_000_000_000_000#,
      others => 2#111_101_101_101_111_000#);

   procedure Put
      (Pos : Point;
       Ch  : Character)
   is
      FC : constant Unsigned_32 := Unsigned_32 (Font_Data (Ch));
      PX, PY : Natural;
   begin
      for X in 0 .. (Font_Width - 1) loop
         for Y in 0 .. (Font_Height - 1) loop
            PX := (Pos.X + (Font_Width - X)) * Scale;
            PY := (Pos.Y + Y) * Scale;
            if (Shift_Right (FC, (Font_Width * Font_Height) - (Y * 3) + X) and 1) = 1 then
               for RX in PX .. PX + Scale - 1 loop
                  for RY in PY .. PY + Scale - 1 loop
                     Set_Pixel (RX, RY);
                  end loop;
               end loop;
            end if;
         end loop;
      end loop;
   end Put;

   procedure Clear is
   begin
      Cursor := (0, 0);
      Clear_Screen;
   end Clear;

   procedure Advance is
   begin
      Cursor.X := Cursor.X + Font_Width + 1 + Scale / 2;
      if (Cursor.X + Font_Width) * Scale >= Width then
         New_Line;
      end if;
   end Advance;

   procedure Put
      (Ch : Character)
   is
   begin
      if Ch = ASCII.LF then
         New_Line;
      else
         Put (Cursor, Ch);
         Advance;
      end if;
   end Put;

   procedure Put
      (Str : String)
   is
   begin
      for Ch of Str loop
         Put (Ch);
      end loop;
   end Put;

   procedure Put_Line
      (Str : String)
   is
   begin
      Put (Str);
      New_Line;
   end Put_Line;

   procedure New_Line is
   begin
      Cursor.X := 0;
      Cursor.Y := Cursor.Y + Font_Height + 1 + Scale / 2;
      if (Cursor.Y + Font_Height) * Scale >= Height then
         Cursor.Y := 0;
         Clear;
      end if;
   end New_Line;

end Generic_Tiny_Text;
