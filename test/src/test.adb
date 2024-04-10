pragma Style_Checks ("M120");
with System.Storage_Elements;
with Memory_Mapped_Bitmap;
with HAL.Bitmap;

with QOI;

with Tiny_Text;

with Ada.Streams.Stream_IO;
with Ada.Directories;
with Ada.Text_IO;
with Ada.Command_Line;

procedure Test is
   package IO renames Ada.Streams.Stream_IO;
   package SSE renames System.Storage_Elements;
   use type SSE.Storage_Offset;
   use type SSE.Storage_Array;

   Text : Tiny_Text.Text_Buffer;

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

   Verify_Filename : constant String := "hello_tiny.qoi";
   Verify_Length : constant SSE.Storage_Offset := SSE.Storage_Offset
      (Ada.Directories.Size (Verify_Filename));
   Verify : aliased SSE.Storage_Array (1 .. Verify_Length);
   File   : IO.File_Type;
begin
   Text.Initialize
      (Bitmap  => Bitmap'Unrestricted_Access,
       Width   => Width,
       Height  => Height);
   Text.Put ("hello, tiny!");

   QOI.Encode
      (Pix         => Buffer,
       Desc        => Desc,
       Output      => Output,
       Output_Size => Output_Last);

   IO.Open (File, IO.In_File, Verify_Filename);
   SSE.Storage_Array'Read (IO.Stream (File), Verify);
   IO.Close (File);

   if Output (1 .. Output_Last) = Verify then
      Ada.Text_IO.Put_Line ("PASS");
   else
      Ada.Text_IO.Put_Line ("FAIL");
      Ada.Command_Line.Set_Exit_Status (1);
   end if;
end Test;
