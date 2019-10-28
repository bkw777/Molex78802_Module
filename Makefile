# Brian K. White - b.kenyon.w@gmail.com

.PHONY: all
all:
	${MAKE} -C Carrier clean all
	mv -vf Carrier/*.png .
	mv -vf Carrier/*.step PCB/000_LOCAL.pretty/3d/
