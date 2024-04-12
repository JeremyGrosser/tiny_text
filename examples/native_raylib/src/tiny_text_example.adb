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
      (X, Y : Integer;
       Set  : Boolean)
   is
   begin
      Raylib.DrawPixel (int (X), int (Y), (if Set then Foreground else Background));
   end Set_Pixel;

   package Text is new Generic_Tiny_Text
      (Set_Pixel  => Set_Pixel,
       Width      => Width,
       Height     => Height);
begin
   Raylib.InitWindow (Width, Height, New_String ("tiny_text_example"));
   Raylib.SetTargetFPS (60);
   Text.Scale := 4;
   while not Raylib.WindowShouldClose loop
      exit when Raylib.IsKeyDown (int (Raylib.KEY_ESCAPE));

      Raylib.BeginDrawing;
      Raylib.ClearBackground (Background);

      Text.Cursor := (0, 0);
      for Ch in Text.Printable'Range loop
         Text.Put (Ch);
      end loop;

      Raylib.EndDrawing;
   end loop;

   Raylib.CloseWindow;
end Tiny_Text_Example;
