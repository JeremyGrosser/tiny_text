with HAL.Bitmap;
with Tiny_Text;
with Board; use Board;

procedure Example is
   Text : Tiny_Text.Text_Buffer
      (Bitmap => Display.Hidden_Buffer (1),
       Width  => Display.Width,
       Height => Display.Height);
begin
   Display.Initialize_Layer (1, HAL.Bitmap.M_1);
   Text.Initialize;

   loop
      Text.Clear;
      Text.Put_Line ("Hello, world");
      Display.Update_Layers;
   end loop;
end Example;
