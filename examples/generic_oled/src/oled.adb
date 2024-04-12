--
--  Copyright (C) 2024 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: MIT
--
pragma Extensions_Allowed (On);

package body OLED is

   subtype Framebuffer is UInt8_Array (0 .. Width * Height / 8 - 1);
   FB : Framebuffer;

   procedure Write_Command
      (Data : UInt8_Array)
   is
      Buffer : UInt8_Array (1 .. 2);
   begin
      for D of Data loop
         Buffer (1) := 16#80#;
         Buffer (2) := D;
         Write (Buffer);
      end loop;
   end Write_Command;

   procedure Write_Data
      (Data : UInt8_Array)
   is
      Buffer : UInt8_Array (1 .. Data'Length + 1);
   begin
      Buffer (1) := 16#40#;
      Buffer (2 .. Buffer'Last) := Data;
      Write (Buffer);
   end Write_Data;

   Init : constant UInt8_Array := [
      16#AE#,           --  Display off
      16#D5#, 16#80#,   --  Display clock divide ratio
      16#A8#, 16#27#,   --  mux ratio
      16#D3#, 16#00#,   --  display offset
      16#AD#, 16#30#,   --  Internal IREF
      16#8D#, 16#14#,   --  Charge pump enable

      16#40#,           --  Start line 0
      16#A6#,           --  Normal mode
      16#A4#,           --  RAM output enable

      16#20#, 16#00#,   --  Horizontal addressing mode

      16#A1#,           --  Segment remap
      16#C8#,           --  COM scan direction

      16#DA#, 16#12#,   --  COM pins sequential, disable remap
      16#81#, 16#AF#,   --  Contrast control
      16#D9#, 16#22#,   --  Pre-charge period
      16#DB#, 16#20#,   --  VCOMH deselect level

      16#2E#,           --  No scroll

      --  16#1F#,           --  column address
      16#AF#            --  Display on
   ];

   procedure Initialize is
   begin
      Clear;
      Write_Command (Init);
      Update;
   end Initialize;

   procedure Set_Pixel
      (X   : Column;
       Y   : Row;
       Set : Boolean)
   is
      Index  : constant Natural := (Natural (Y) / 8) * Width + Natural (X);
      Offset : constant Natural := Natural (Y) mod 8;
      Mask   : constant UInt8 := 2 ** Offset;
   begin
      if Set then
         FB (Index) := FB (Index) or Mask;
      else
         FB (Index) := FB (Index) and not Mask;
      end if;
   end Set_Pixel;

   procedure Update is
      SET_COLUMN_RANGE : constant UInt8 := 16#21#;
      SET_PAGE_RANGE : constant UInt8 := 16#22#;
      X_Offset : constant := 28;
      Data : UInt8_Array (1 .. Width * Height / 8)
         with Import, Address => FB'Address;
   begin
      Write_Command (UInt8_Array'(SET_COLUMN_RANGE, X_Offset, X_Offset + UInt8 (Width) - 1));
      Write_Command (UInt8_Array'(SET_PAGE_RANGE, 0, UInt8 (Height) / 8 - 1));
      Write_Data (Data);
   end Update;

   procedure Clear is
   begin
      FB := [others => 0];
   end Clear;
end OLED;
