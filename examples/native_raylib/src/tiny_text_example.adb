--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Interfaces.C; use Interfaces.C;
with Raylib;

with Generic_Tiny_Text;

procedure Tiny_Text_Example is
   Width  : constant := 320;
   Height : constant := 320;

   Foreground : constant Raylib.Color :=
      (255, 255, 255, 255);
   Background : constant Raylib.Color :=
      (0, 0, 0, 255);

   procedure Set_Pixel
      (X, Y : Integer)
   is
   begin
      Raylib.DrawPixel (int (X), int (Y), Foreground);
   end Set_Pixel;

   procedure Clear_Screen is
   begin
      Raylib.ClearBackground (Background);
   end Clear_Screen;

   package Text is new Generic_Tiny_Text
      (Set_Pixel     => Set_Pixel,
       Clear_Screen  => Clear_Screen,
       Width         => Width,
       Height        => Height);
begin
   Raylib.InitWindow (Width, Height, New_String ("tiny_text_example"));
   Raylib.SetTargetFPS (60);
   Text.Scale := 4;
   while not Raylib.WindowShouldClose loop
      exit when Raylib.IsKeyDown (int (Raylib.KEY_ESCAPE));

      Raylib.BeginDrawing;

      Text.Clear;
      for Ch in Text.Printable'Range loop
         Text.Put (Ch);
      end loop;
      Text.New_Line;
      Text.Put ("ESC to exit");

      Raylib.EndDrawing;
   end loop;

   Raylib.CloseWindow;
end Tiny_Text_Example;
