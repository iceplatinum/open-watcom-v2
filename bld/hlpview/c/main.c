/****************************************************************************
*
*                            Open Watcom Project
*
* Copyright (c) 2002-2019 The Open Watcom Contributors. All Rights Reserved.
*    Portions Copyright (c) 1983-2002 Sybase, Inc. All Rights Reserved.
*
*  ========================================================================
*
*    This file contains Original Code and/or Modifications of Original
*    Code as defined in and that are subject to the Sybase Open Watcom
*    Public License version 1.0 (the 'License'). You may not use this file
*    except in compliance with the License. BY USING THIS FILE YOU AGREE TO
*    ALL TERMS AND CONDITIONS OF THE LICENSE. A copy of the License is
*    provided with the Original Code and Modifications, and is also
*    available at www.sybase.com/developer/opensource.
*
*    The Original Code and all software distributed under the License are
*    distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER
*    EXPRESS OR IMPLIED, AND SYBASE AND ALL CONTRIBUTORS HEREBY DISCLAIM
*    ALL SUCH WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF
*    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR
*    NON-INFRINGEMENT. Please see the License for the specific language
*    governing rights and limitations under the License.
*
*  ========================================================================
*
* Description:  Character mode help browser mainline.
*
****************************************************************************/


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef __UNIX__
    #include <dirent.h>
#else
    #include <direct.h>
#endif
#include "watcom.h"
#include "stdui.h"
#include "help.h"
#include "helpmem.h"
#include "filelist.h"
#include "initmode.h"
#include "pathgrp.h"

#include "clibext.h"


#ifdef __UNIX__
#define FIRST_SRCH_PATH "./"
#else
#define FIRST_SRCH_PATH ".\\"
#endif

static HelpSrchPathItem searchList[] = {
    // this may be changed when a cross file hyperlink is processed
    { SRCHTYPE_PATH,    FIRST_SRCH_PATH },
    { SRCHTYPE_ENV,     "WWINHELP" },
    { SRCHTYPE_ENV,     "PATH" },
    { SRCHTYPE_EOL,     NULL }
};

static void showCmdlHelp( char *name )
{
    char        fname[_MAX_FNAME];

    _splitpath( name, NULL, NULL, fname, NULL );
    printf( "\nThe Watcom Help command line:\n" );
    printf( "\n" );
    printf( "               %s help_file [topic_name]\n", fname );
    printf( "\n" );
    printf( "- if help_file is specified without an extension \"%s\" is assumed\n", DEF_EXT );
    printf( "- the topic_name parameter is optional\n" );
    printf( "- if topic_name is not specifed the default topic used.\n" );
    printf( "- if topic_name contains spaces then it must be enclosed in quotes\n" );
    printf( "\n" );
    printf( "The following help files are available:\n\n" );
    PrintHelpFiles( searchList );
}

static HelpSrchPathItem *checkFileName( const char *name, char *buf )
{
    PGROUP      pg;
    char        path[_MAX_PATH];

    _splitpath( name, pg.drive, pg.dir, pg.fname, pg.ext );
    if( pg.ext[0] == '\0' ) {
        strcpy( pg.ext, DEF_EXT );
    }
    _makepath( buf, NULL, NULL, pg.fname, pg.ext );
    if( *pg.drive != '\0' || *pg.dir != '\0' ) {
        _makepath( path, pg.drive, pg.dir, NULL, NULL );
        searchList[0].info = HelpMemAlloc( strlen( path ) + 1 );
        strcpy( searchList[0].info, path );
    }
    return( searchList );
}

static void freeSrchList( void )
{
    if( strcmp( searchList[0].info, FIRST_SRCH_PATH ) ) {
        HelpMemFree( searchList[0].info );
    }
}

int main( int argc, char *argv[] )
{
    const char          *helpfiles[] = { NULL, NULL };
    const char          *topic;
    char                filename[_MAX_PATH];
    HelpSrchPathItem    *srchlist;
    int                 rc;
    bool                err;

    HelpMemOpen();
    err = false;
    if( argc < 2 || strcmp( argv[1], "?" ) == 0 || strcmp( argv[1], "-?" ) == 0
        || strcmp( argv[1], "/?" ) == 0 ) {
        showCmdlHelp( argv[0] );
        return( EXIT_SUCCESS );
    }
    if( argc > 3 ) {
        printf( "Too many arguments specified on the command line\n" );
        printf( "For help type %s -?\n", argv[0] );
        return( EXIT_FAILURE );
    }
    srchlist = checkFileName( argv[1], filename );
    strlwr( filename );
    helpfiles[0] = filename;
    if( argc == 3 ) {
        topic = argv[2];
    } else {
        topic = NULL;
    }
    if( !uistart() ) {
        printf( "ui failed\n" );
        return( EXIT_FAILURE );
    } else {
#if defined( __OS2__ ) || defined( __NT__ )
        initmouse( INIT_MOUSE_INITIALIZED );
#elif !defined __UNIX__
        uiinitgmouse( INIT_MOUSE_INITIALIZED );
        FlipCharacterMap();
#endif
        if( helpinit( helpfiles, srchlist ) ) {
            rc = showhelp( topic, NULL, HELPLANG_ENGLISH );
            if( rc == HELP_NO_SUBJECT ) {
                err = true;
                uirestorebackground();
                printf( "Unable to find the topic \"%s\" in the help file \"%s\".\n",
                        topic, filename );
            }
        } else {
            err = true;
            uirestorebackground();
            printf( "Unable to open the help file \"%s\".\n", filename );
//          printf( "Please check that you have specified the correct help file\n" );
//          printf( "and that the file is in a directory listed in your PATH\n" );
//          printf( "or the file is in the current directory\n" );
//          printf( "or you have specified the path where the file is located.\n" );
        }
        helpfini();
        freeSrchList();
        if( !err ) {
            uirestorebackground();
        }
        uifini();
    }
    HelpMemClose();
    return( EXIT_SUCCESS );
}
