# wcc386 Builder Control file
# ===========================

set PROJDIR=<CWD>

[ INCLUDE <OWROOT>/build/master.ctl ]
[ LOG <LOGFNAME>.<LOGEXT> ]

[ BLOCK <1> clean ]
#==================
    echo rm -f -r <PROJDIR>/<OWOBJDIR>
    rm -f -r <PROJDIR>/<OWOBJDIR>

[ BLOCK <1> boot ]
#=================
    echo Building the wcc386 bootstrap
    mkdir <PROJDIR>/<OWOBJDIR>
    cdsay <PROJDIR>/<OWOBJDIR>
    cp -f ../linux386.386/target.h .
    wmake -h -f ../make386
    <CPCMD> wcc386c.exe <DEVDIR>/build/bin/wcc386
    cdsay <PROJDIR>
