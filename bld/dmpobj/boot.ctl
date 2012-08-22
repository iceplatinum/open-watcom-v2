# dmpobj Builder Control file
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
    echo Building the wlib bootstrap
    mkdir <PROJDIR>/<OWOBJDIR>
    cdsay <PROJDIR>/<OWOBJDIR>
    wmake -h -f ../bootmake
    <CPCMD> dmpobj.exe <DEVDIR>/build/bin/dmpobj
    cdsay <PROJDIR>
