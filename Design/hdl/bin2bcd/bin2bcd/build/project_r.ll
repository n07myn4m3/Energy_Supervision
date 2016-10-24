Revision 3
; Created by bitgen P.20131013 at Sat Jun  4 18:04:12 2016
; Bit lines have the following form:
; <offset> <frame address> <frame offset> <information>
; <information> may be zero or more <kw>=<value> pairs
; Block=<blockname     specifies the block associated with this
;                      memory cell.
;
; Latch=<name>         specifies the latch associated with this memory cell.
;
; Net=<netname>        specifies the user net associated with this
;                      memory cell.
;
; COMPARE=[YES | NO]   specifies whether or not it is appropriate
;                      to compare this bit position between a
;                      "program" and a "readback" bitstream.
;                      If not present the default is NO.
;
; Ram=<ram id>:<bit>   This is used in cases where a CLB function
; Rom=<ram id>:<bit>   generator is used as RAM (or ROM).  <Ram id>
;                      will be either 'F', 'G', or 'M', indicating
;                      that it is part of a single F or G function
;                      generator used as RAM, or as a single RAM
;                      (or ROM) built from both F and G.  <Bit> is
;                      a decimal number.
;
; Info lines have the following form:
; Info <name>=<value>  specifies a bit associated with the LCA
;                      configuration options, and the value of
;                      that bit.  The names of these bits may have
;                      special meaning to software reading the .ll file.
;
Info STARTSEL0=1
Bit 12718884 0x0040011f    964 Block=SLICE_X1Y65 Latch=AQ Net=finaldd<28>
Bit 12718914 0x0040011f    994 Block=SLICE_X1Y65 Latch=CQ Net=finaldd<29>
Bit 12718932 0x0040011f   1012 Block=SLICE_X1Y65 Latch=DMUX Net=N39
Bit 12718947 0x0040011f   1027 Block=SLICE_X0Y66 Latch=AQ Net=finaldd<26>
Bit 12718977 0x0040011f   1057 Block=SLICE_X0Y66 Latch=CQ Net=finaldd<27>
Bit 12719075 0x0040011f   1155 Block=SLICE_X0Y68 Latch=AQ Net=finaldd<24>
Bit 12719105 0x0040011f   1185 Block=SLICE_X0Y68 Latch=CQ Net=finaldd<25>
Bit 12719123 0x0040011f   1203 Block=SLICE_X0Y68 Latch=DMUX Net=N37
Bit 12719139 0x0040011f   1219 Block=SLICE_X0Y69 Latch=AQ Net=finaldd<22>
Bit 12719194 0x0040011f   1274 Block=SLICE_X0Y69 Latch=DQ Net=finaldd<23>
Bit 12719267 0x0040011f   1347 Block=SLICE_X0Y71 Latch=AQ Net=finaldd<20>
Bit 12719297 0x0040011f   1377 Block=SLICE_X0Y71 Latch=CQ Net=finaldd<21>
Bit 12719315 0x0040011f   1395 Block=SLICE_X0Y71 Latch=DMUX Net=N35
Bit 12719395 0x0040011f   1475 Block=SLICE_X0Y73 Latch=AQ Net=finaldd<18>
Bit 12719425 0x0040011f   1505 Block=SLICE_X0Y73 Latch=CQ Net=finaldd<19>
Bit 12719462 0x0040011f   1542 Block=SLICE_X0Y74 Latch=AMUX Net=Mmux_finaldd[29]_finaldd[29]_mux_24_OUT122
Bit 12719555 0x0040011f   1635 Block=SLICE_X0Y75 Latch=AQ Net=bol
Bit 12719620 0x0040011f   1700 Block=SLICE_X1Y76 Latch=AQ Net=finaldd<4>
Bit 12719644 0x0040011f   1724 Block=SLICE_X0Y76 Latch=BQ Net=init
Bit 12719684 0x0040011f   1764 Block=SLICE_X1Y77 Latch=AQ Net=tmp<0>
Bit 12719708 0x0040011f   1788 Block=SLICE_X0Y77 Latch=BQ Net=tmp<3>
Bit 12719709 0x0040011f   1789 Block=SLICE_X1Y77 Latch=BQ Net=tmp<1>
Bit 12719714 0x0040011f   1794 Block=SLICE_X1Y77 Latch=CQ Net=tmp<2>
Bit 12719721 0x0040011f   1801 Block=SLICE_X0Y77 Latch=CMUX Net=done_glue_set
Bit 12719747 0x0040011f   1827 Block=SLICE_X0Y78 Latch=AQ Net=finaldd<2>
Bit 12719748 0x0040011f   1828 Block=SLICE_X1Y78 Latch=AQ Net=done_OBUF
Bit 12719772 0x0040011f   1852 Block=SLICE_X0Y78 Latch=BQ Net=finaldd<3>
Bit 12719785 0x0040011f   1865 Block=SLICE_X0Y78 Latch=CMUX Net=N55
Bit 12719836 0x0040011f   1916 Block=SLICE_X0Y79 Latch=BQ Net=finaldd<13>
Bit 12719841 0x0040011f   1921 Block=SLICE_X0Y79 Latch=CQ Net=finaldd<1>
Bit 12719859 0x0040011f   1939 Block=SLICE_X0Y79 Latch=DMUX Net=N59
Bit 12719900 0x0040011f   1980 Block=SLICE_X0Y80 Latch=BQ Net=finaldd<0>
Bit 12720195 0x0040011f   2275 Block=SLICE_X0Y85 Latch=AQ Net=finaldd<16>
Bit 12720196 0x0040011f   2276 Block=SLICE_X1Y85 Latch=AQ Net=finaldd<14>
Bit 12720225 0x0040011f   2305 Block=SLICE_X0Y85 Latch=CQ Net=finaldd<17>
Bit 12720226 0x0040011f   2306 Block=SLICE_X1Y85 Latch=CQ Net=finaldd<15>
Bit 12720243 0x0040011f   2323 Block=SLICE_X0Y85 Latch=DMUX Net=N33
Bit 13068452 0x0040029f   1476 Block=SLICE_X7Y73 Latch=AQ Net=finaldd<6>
Bit 13068477 0x0040029f   1501 Block=SLICE_X7Y73 Latch=BQ Net=finaldd<7>
Bit 13068490 0x0040029f   1514 Block=SLICE_X7Y73 Latch=CMUX Net=N47
Bit 13068675 0x0040029f   1699 Block=SLICE_X6Y76 Latch=AQ Net=finaldd<10>
Bit 13068700 0x0040029f   1724 Block=SLICE_X6Y76 Latch=BQ Net=finaldd<12>
Bit 13068701 0x0040029f   1725 Block=SLICE_X7Y76 Latch=BQ Net=finaldd<11>
Bit 13068706 0x0040029f   1730 Block=SLICE_X7Y76 Latch=CQ Net=finaldd<5>
Bit 13068713 0x0040029f   1737 Block=SLICE_X6Y76 Latch=CMUX Net=N65
Bit 13068724 0x0040029f   1748 Block=SLICE_X7Y76 Latch=DMUX Net=N63
Bit 14626276 0x0040099f   1476 Block=SLICE_X29Y73 Latch=AQ Net=finaldd<8>
Bit 14626301 0x0040099f   1501 Block=SLICE_X29Y73 Latch=BQ Net=finaldd<9>
Bit 14626314 0x0040099f   1514 Block=SLICE_X29Y73 Latch=CMUX Net=N43
