# Tiny Text
Low resolution bitmap font with a small memory footprint

Based on the "Tom Thumb" font, available under the CC0 license.
https://robey.lag.net/2010/01/23/tiny-monospace-font.html

Tiny Text is a 5x3 bitmap font. This implementation supports drawing on any display with the HAL.Bitmap interface.

`example/example.adb` demonstrates using this font on a PCD8544 LCD. To build the example, use `Ada_Drivers_Library/scripts/project_wizard.py` to generate a project config for the STM32-H405 board and ravenscar-full-stm32f4 runtime.

MIT License
Copyright 2020 Jeremy Grosser
See LICENSE for details.
