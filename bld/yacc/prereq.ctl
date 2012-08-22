# YACC Prerequisite Tool Build Control File
# =========================================

set PROJDIR=<CWD>

[ INCLUDE <OWROOT>/build/master.ctl ]
[ LOG <LOGFNAME>.<LOGEXT> ]

cdsay .

set TMP_BUILD_PLATFORM=<BUILD_PLATFORM>
set ODIR=<OWPREOBJDIR>

[ BLOCK <OWLINUXBUILD> bootstrap ]
#=================================
set BUILD_PLATFORM=<BUILD_PLATFORM>boot
set ODIR=<OWOBJDIR>

[ BLOCK <1> clean ]
#==================
    echo rm -f -r <PROJDIR>/<ODIR>
    rm -f -r <PROJDIR>/<ODIR>
    rm -f <OWBINDIR>/byacc
    rm -f <OWBINDIR>/byacc.exe
    set BUILD_PLATFORM=

[ BLOCK <BUILD_PLATFORM> dos386 ]
#================================
    mkdir <PROJDIR>/<OWPREOBJDIR>
    cdsay <PROJDIR>/<OWPREOBJDIR>
    wmake -h -f ../dos386/makefile prebuild=1
    <CPCMD> yacc.exe <OWBINDIR>/byacc.exe

[ BLOCK <BUILD_PLATFORM> os2386 ]
#================================
    mkdir <PROJDIR>/<OWPREOBJDIR>
    cdsay <PROJDIR>/<OWPREOBJDIR>
    wmake -h -f ../os2386/makefile prebuild=1
    <CPCMD> yacc.exe <OWBINDIR>/byacc.exe

[ BLOCK <BUILD_PLATFORM> nt386 ]
#===============================
    mkdir <PROJDIR>/<OWPREOBJDIR>
    cdsay <PROJDIR>/<OWPREOBJDIR>
    wmake -h -f ../nt386/makefile prebuild=1
    <CPCMD> yacc.exe <OWBINDIR>/byacc.exe

[ BLOCK <BUILD_PLATFORM> ntaxp ]
#===============================
    mkdir <PROJDIR>/<OWPREOBJDIR>
    cdsay <PROJDIR>/<OWPREOBJDIR>
    wmake -h -f ../ntaxp/makefile prebuild=1
    <CPCMD> yacc.exe <OWBINDIR>/byacc.exe

[ BLOCK <BUILD_PLATFORM> linux386boot ]
#======================================
    mkdir <PROJDIR>/<OWPREOBJDIR>
    cdsay <PROJDIR>/<OWPREOBJDIR>
    wmake -h -f ../linux386/makefile bootstrap=1
    <CPCMD> yacc.exe <OWBINDIR>/byacc

[ BLOCK <BUILD_PLATFORM> linux386 ]
#==================================
    mkdir <PROJDIR>/<OWPREOBJDIR>
    cdsay <PROJDIR>/<OWPREOBJDIR>
    wmake -h -f ../linux386/makefile prebuild=1
    <CPCMD> yacc.exe <OWBINDIR>/byacc

[ BLOCK . . ]
#============
set BUILD_PLATFORM=<TMP_BUILD_PLATFORM>
set TMP_BUILD_PLATFORM=

cdsay <PROJDIR>
