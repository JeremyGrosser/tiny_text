--  Tiny Text
--  Copyright 2020 Jeremy Grosser
--  See LICENSE for details

with Interfaces; use Interfaces;

package body Tiny_Text is
   procedure Initialize
      (This   : in out Text_Buffer;
      Bitmap : Any_Bitmap_Buffer;
      Width  : Natural;
      Height : Natural) is
   begin
      This.Width := Width;
      This.Height := Height;
      This.Bitmap := Bitmap;
      This.Default_Cursor := (0, 0);
      This.Clear;
   end Initialize;

   procedure Clear (This : in out Text_Buffer) is
   begin
      This.Bitmap.Set_Source (This.Background);
      This.Bitmap.Fill;
      This.Cursor := This.Default_Cursor;
      This.Bitmap.Set_Source (This.Foreground);
   end Clear;

   procedure New_Line (This : in out Text_Buffer) is
   begin
      This.Cursor.X := 0;
      This.Cursor.Y := This.Cursor.Y + Font_Height + 1;
      if (This.Cursor.Y + Font_Height) >= This.Height then
         This.Cursor.Y := 0;
         This.Clear;
      end if;
   end New_Line;

   procedure Advance (This : in out Text_Buffer) is
   begin
      This.Cursor.X := This.Cursor.X + Font_Width + 1;
      if This.Cursor.X >= This.Width then
         This.New_Line;
      end if;
   end Advance;

   procedure Put
      (This      : in out Text_Buffer;
       Location   : Point;
       Char      : Character;
       Foreground : Bitmap_Color;
       Background : Bitmap_Color) is
      P : Point;
      FC : constant Unsigned_32 := Unsigned_32 (Font_Data (Char));
      Pixel : Unsigned_32;
   begin
      for X in 0 .. (Font_Width - 1) loop
         for Y in 0 .. (Font_Height - 1) loop
            P.X := (Location.X + (Font_Width - X));
            P.Y := (Location.Y + Y);
            Pixel := Shift_Right
               (FC, (Font_Width * Font_Height) - (Y * 3) + X) and 1;
            if Pixel = 1 then
               This.Bitmap.Set_Pixel (P, Foreground);
            else
               This.Bitmap.Set_Pixel (P, Background);
            end if;
         end loop;
      end loop;
   end Put;

   procedure Put
      (This : in out Text_Buffer;
      Char : Character) is
   begin
      if Char = ASCII.LF then
         This.New_Line;
      else
         This.Put (This.Cursor, Char, This.Foreground, This.Background);
         This.Advance;
      end if;
   end Put;

   procedure Put
      (This : in out Text_Buffer;
      Str  : String) is
   begin
      for Char of Str loop
         This.Put (Char);
      end loop;
   end Put;

   procedure Put_Line
      (This : in out Text_Buffer;
      Str  : String) is
   begin
      This.Put (Str);
      This.Put (ASCII.LF);
   end Put_Line;
end Tiny_Text;
