# Tiny Text
Low resolution bitmap font with a small memory footprint

Based on the "Tom Thumb" font, available under the CC0 license.  
https://robey.lag.net/2010/01/23/tiny-monospace-font.html

Tiny Text is a 5x3 bitmap font. This implementation supports drawing on any display with the HAL.Bitmap interface.

## Examples

- [examples/hal_bitmap_pcd8544](examples/hal_bitmap_pcd8544) uses the Tiny_Text with the HAL.Bitmap interface implemented by the PCD8544 driver from Ada_Drivers_Library.
- [examples/generic_oled](examples/generic_oled) uses an instantiation of the `Generic_Tiny_Text` package with a custom OLED driver's `Set_Pixel` procedure.

MIT License  
Copyright 2020-2024 Jeremy Grosser  
See LICENSE for details.  
