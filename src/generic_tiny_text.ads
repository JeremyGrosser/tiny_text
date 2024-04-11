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

   procedure Put
      (Pos : Point;
       Ch  : Character);

   procedure Clear;

   Cursor : Point := (0, 0);

   procedure Put
      (Ch : Character);
   procedure Put
      (Str : String);
   procedure Put_Line
      (Str : String);
   procedure New_Line;

end Generic_Tiny_Text;
