pragma Style_Checks ("M120");
with System.Storage_Elements;
with Memory_Mapped_Bitmap;
with HAL.Bitmap;

with QOI;

with Tiny_Text;
with Generic_Tiny_Text;

with Ada.Streams.Stream_IO;
with Ada.Directories;
with Ada.Text_IO;
with Ada.Command_Line;

procedure Test is
   package IO renames Ada.Streams.Stream_IO;
   package SSE renames System.Storage_Elements;
   use type SSE.Storage_Offset;
   use type SSE.Storage_Array;

   Width  : constant := 128;
   Height : constant := 32;
   Buffer : aliased SSE.Storage_Array (1 .. Width * Height * 3);
   Bitmap : aliased Memory_Mapped_Bitmap.Memory_Mapped_Bitmap_Buffer :=
      (Addr                => Buffer'Address,
       Actual_Width        => Width,
       Actual_Height       => Height,
       Actual_Color_Mode   => HAL.Bitmap.RGB_888,
       others              => <>);

   Desc : constant QOI.QOI_Desc :=
      (Width      => Width,
       Height     => Height,
       Channels   => 3,
       Colorspace => QOI.SRGB);

   Output      : aliased SSE.Storage_Array (1 .. QOI.Encode_Worst_Case (Desc));
   Output_Last : SSE.Storage_Offset;

   Output_Filename : constant String := "output.qoi";
   Verify_Filename : constant String := "hello_tiny.qoi";
   Verify_Length : constant SSE.Storage_Offset := SSE.Storage_Offset
      (Ada.Directories.Size (Verify_Filename));
   Verify : aliased SSE.Storage_Array (1 .. Verify_Length);
   File   : IO.File_Type;

   procedure Check_Output
      (Name : String)
   is
   begin
      QOI.Encode
         (Pix         => Buffer,
          Desc        => Desc,
          Output      => Output,
          Output_Size => Output_Last);

      if Ada.Directories.Exists (Output_Filename) then
         Ada.Directories.Delete_File (Output_Filename);
      end if;
      IO.Create (File, IO.Out_File, Output_Filename);
      SSE.Storage_Array'Write (IO.Stream (File), Output (1 .. Output_Last));
      IO.Close (File);

      Ada.Text_IO.Put (Name);
      Ada.Text_IO.Put (' ');
      if Output (1 .. Output_Last) = Verify then
         Ada.Text_IO.Put_Line ("PASS");
      else
         Ada.Text_IO.Put_Line ("FAIL");
         Ada.Command_Line.Set_Exit_Status (1);
      end if;
   end Check_Output;

   procedure Test_HAL is
      Text : Tiny_Text.Text_Buffer;
   begin
      Text.Initialize
         (Bitmap  => Bitmap'Unrestricted_Access,
          Width   => Width,
          Height  => Height);
      Text.Put_Line ("hello, tiny!");
      Text.Scale := 2;
      Text.Put ("hello, big!");

      Check_Output ("Tiny_Text");
   end Test_HAL;

   procedure Test_Generic is
      procedure Set_Pixel
         (X, Y : Natural;
          Set  : Boolean)
      is
      begin
         if Set then
            Bitmap.Set_Source (HAL.Bitmap.White);
         else
            Bitmap.Set_Source (HAL.Bitmap.Black);
         end if;
         Bitmap.Set_Pixel (HAL.Bitmap.Point'(X, Y));
      end Set_Pixel;
      package Text is new Generic_Tiny_Text
         (Width     => Width,
          Height    => Height,
          Set_Pixel => Set_Pixel);
   begin
      Bitmap.Set_Source (HAL.Bitmap.Black);
      Bitmap.Fill;

      for Ch in Character'Range loop
         Text.Put (Ch);
      end loop;
      Text.Clear;

      Text.Put_Line ("hello, tiny!");
      Text.Scale := 2;
      Text.Put ("hello, big!");
      Check_Output ("Generic_Tiny_Text");
   end Test_Generic;
begin
   IO.Open (File, IO.In_File, Verify_Filename);
   SSE.Storage_Array'Read (IO.Stream (File), Verify);
   IO.Close (File);

   Test_HAL;
   Test_Generic;
end Test;
