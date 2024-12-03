
CROSS_COMPILE=aarch64-linux-gnu-
CC=${CROSS_COMPILE}gcc

all: vpd_cvmm vpd_mezz vpd_sliop vpd_wing vpd_hvvmm vpd_shvpp vpd_hzb

# CVMM tar file
#  - build on SLIOP, use vpd_sliop, vpd_shvpp, & vpd_wing there
#  -  CVMM: vpd_cvmm vpd_mezz vpd_hvvmm vpd_hzb
#  - SLIOP: vpd_sliop vpd_wing vpd_shvpp
tar: vpd_cvmm vpd_mezz vpd_hvvmm vpd_hzb
	(cd ..; tar -czvf vpd.tgz vpd/vpd_cvmm vpd/vpd_mezz vpd/vpd_hvvmm vpd_hzb)


vpd_cvmm: vpd.o vpd_cvmm.o
	$(CC) vpd.o vpd_cvmm.o -o vpd_cvmm

vpd_mezz: vpd.o vpd_mezz.o
	$(CC) vpd.o vpd_mezz.o -o vpd_mezz

vpd_sliop: vpd.o vpd_sliop.o
	$(CC) vpd.o vpd_sliop.o -o vpd_sliop

vpd_wing: vpd.o vpd_wing.o
	$(CC) vpd.o vpd_wing.o -o vpd_wing

vpd_hvvmm: vpd.o vpd_hvvmm.o
	$(CC) vpd.o vpd_hvvmm.o -o vpd_hvvmm

vpd_shvpp: vpd.o vpd_shvpp.o
	$(CC) vpd.o vpd_shvpp.o -o vpd_shvpp

vpd_hzb: vpd.o vpd_hzb.o
	$(CC) vpd.o vpd_hzb.o -o vpd_hzb


vpd.o: vpd.c vpd.h


vpd_cvmm.o: vpd.h vpd_cvmm.c

vpd_mezz.o: vpd.h vpd_mezz.c

vpd_sliop.o: vpd.h vpd_sliop.c

vpd_wing.o: vpd.h vpd_wing.c

vpd_hvvmm.o: vpd.h vpd_hvvmm.c

vpd_shvpp.o: vpd.h vpd_shvpp.c

vpd_hzb.o: vpd.h vpd_hzb.c

clean:
	@rm -f *.o vpd_cvmm vpd_mezz vpd_sliop vpd_wing vpd_hvvmm vpd_shvpp vpd_hzb
