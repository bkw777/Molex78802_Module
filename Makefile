# Brian K. White - b.kenyon.w@gmail.com

.PHONY: all
all:
	${MAKE} -C Carrier clean
	${MAKE} -C Carrier pins=24
	${MAKE} -C Carrier pins=28
	${MAKE} -C Carrier pins=32
	mv -vf Carrier/*.png .
	mv -vf Carrier/*.step PCB/000_LOCAL.pretty/3d/
