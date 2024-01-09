# Molex78802 Module
![](Molex78802_PCB_28.jpg)
![](PCB_28_example_1.jpg)
![](PCB_28_example_2.jpg)

This is a 3d-printable carrier similar to Molex 78802, to fit into a Molex 78805 socket, and a PCB template to use in place of a DIP chip.

The OpenSCAD file generates 2 types of carrier, one type that holds a DIP chip like a normal Molex 78802, and a different form that holds a PCB instead of a DIP.

The KiCAD files are for the matching PCB with the special board outline and castellated edge contacts to fit the PCB carrier. The pcbs are empty starter templates. Copy the entire PCB directory to a new project and rename the kicad_pcb file to a new name to start a new pcb.

Each of those are also available in 24, 28, and 32-pin sizes, as the original Molex [78802](references/050395288_sd_corrected.pdf) & [78805](references/015299282_sd_corrected.pdf) were.  
Though almost everything uses the 28-pin.

Uses:
* TRS-80/TANDY Model 100, 102, 200, 600
* Kyotronic KC-85
* Epson PX-4, PX-8
* Intermec 9440, Telexon 710, and various other similar hand-held teriminals
* RB5X robot (24-pin!)

http://tandy.wiki/Molex78802_Module  
http://tandy.wiki/Teeprom  
http://tandy.wiki/REX  

You can get 3d printed parts from Shapeways: (all versions) https://www.shapeways.com/shops/bkw  
Or use the STL files with any service.  Hint: Order pcbs like REX or M4ROM_TANDY or M4ROM_27256 from Elecrow and order the carriers (Molex_78805_PCB_28.stl) in Nylon from them too all on the same order.
<!-- Sculpteo has a $50 minimum order, if you order less than $50 worth of parts before tax & shipping, then they charge you the difference. So you have to order 8 or 9 carriers minimum. -->
<!-- Or Sculpteo: [PCB24](https://www.sculpteo.com/en/print/molex78802_pcb_24-4/xMikpkmg), [PCB28](https://www.sculpteo.com/en/print/molex78802_pcb_28-13/Bw4x3yG6), [PCB32](https://www.sculpteo.com/en/print/molex78802_pcb_32-3/zmUBXFK4), [DIP24](https://www.sculpteo.com/en/print/molex78802_dip_24/P2V6xXt8), [DIP28](https://www.sculpteo.com/en/print/molex78802_dip_28-7/LX6JbLYc), [DIP32](https://www.sculpteo.com/en/print/molex78802_dip_32/sJC8nkke). -->

Brian K. White - b.kenyon.w@gmail.com

## DIP 24  
![](Molex78802_CERDIP_24.jpg)  
![](Molex78802_CERDIP_24_b.jpg)

## DIP 28  
![](Molex78802_CERDIP_28.jpg)  
![](Molex78802_CERDIP_28_b.jpg)

## DIP 32  
![](Molex78802_CERDIP_32.jpg)  
![](Molex78802_CERDIP_32_b.jpg)

## PCB 24  
![](Molex78802_PCB_24.jpg)

## PCB 28  
![](Molex78802_PCB_28.jpg)

## PCB 32  
![](Molex78802_PCB_28.jpg)

***May 19 2021 - The PCB outline changed slightly after [v003](https://github.com/bkw777/Molex78802_Module/tree/v003). The PCB is a little wider now. Old boards will be a little loose side-to-side in new carriers, and probably the polarity chamfer won't prevent inserting an old board backwards in a new carrier. New boards won't fit into old carriers, although the difference is small enough that you could just sand the corners down a little and they should work fine. If you have either old carriers or old boards that you want to get the exact matching counterparts for, then go to [Release v003](https://github.com/bkw777/Molex78802_Module/releases/tag/v003).***
