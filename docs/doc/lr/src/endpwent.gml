.func endpwent
.synop begin
#include <pwd.h>
void endpwent( );
.synop end
.desc begin
The
.id &funcb.
function closes the system's password database after calls to
.id getpwent 
are complete.
.desc end
.see begin
.seelist setpwent getpwent getpwnam getpwuid
.see end
.exmp begin
.blktext begin
The following program will print out each user and their user id in
the system's password database
.blktext end
.blkcode begin
#include <stdio.h>
#include <pwd.h>

void main()
  {
    struct passwd *pw;
    
    setpwent( );
    
    while((pw = getpwent( )) != NULL) {
        printf("User id %d is %s\n", (int)pw->pw_uid, pw->pw_name);
    }
    
    endpwent( );
  }
.blkcode end
.exmp end
.class POSIX
.system
