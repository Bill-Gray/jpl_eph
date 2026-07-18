/* watdefs.h: header file for inter-compiler compatibility

Copyright (C) 2010, Project Pluto

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
02110-1301, USA.
*/

#ifndef WATDEFS_H
#define WATDEFS_H

#ifdef __WATCOMC__
   #ifndef bool
      #define bool int
   #endif
   #ifndef true
      #define true 1
   #endif
   #ifndef false
      #define false 0
   #endif
   #ifdef __386__
      #define BITS_32
   #endif
#endif

#ifdef __GNUC__
   #define BITS_32
#endif

#ifdef _WIN32
   #define BITS_32
#endif

#ifdef BITS_32
   #ifndef FAR
      #define FAR
   #endif
   #ifndef _HUGE
      #define _HUGE
   #endif
   #ifndef NEAR
      #define NEAR
   #endif
   #ifndef PASCAL
      #define PASCAL
   #endif
   #define FMEMCPY memcpy
   #define FMEMCMP memcmp
   #define FMEMICMP memicmp
   #define FMEMMOVE memmove
   #define FMEMSET memset
   #define FSTRCPY strcpy
   #define FSTRSTR strstr
   #define FSTRCAT strcat
   #define FSTRNCPY strncpy
   #define FSTRICMP stricmp
   #define FSTRCMP strcmp
   #define FSTRLEN strlen
   #define FMALLOC malloc
   #define FCALLOC calloc
   #define FFREE free
   #define FREALLOC realloc
   #define STRUPR strupr
   #ifdef __WATCOMC__
      #define _ftime ftime
      #define _timeb timeb
      #define _videoconfig videoconfig
      #define _timezone timezone
      #define _tzset tzset
      #define _swab swab
      #define _unlink unlink
      /* int _stricmp( char *s1, char *s2); */
      /* int _memicmp( char *s1, char *s2, int n); */
   #endif
#endif

#ifndef BITS_32
   #define _FAR __far
   #define _HUGE huge
   #ifndef FAR
      #define FAR far
   #endif
   #ifndef NEAR
      #define NEAR near
   #endif
   #ifndef PASCAL
      #define PASCAL pascal
   #endif
   #define FMEMCPY _fmemcpy
   #define FMEMCMP _fmemcmp
   #define FMEMICMP _fmemicmp
   #define FMEMMOVE _fmemmove
   #define FMEMSET _fmemset
   #define FSTRCPY _fstrcpy
   #define FSTRSTR _fstrstr
   #define FSTRCAT _fstrcat
   #define FSTRNCPY _fstrncpy
   #define FSTRLEN _fstrlen
   #define FSTRICMP _fstricmp
   #define FSTRCMP _fstrcmp
   #define FMALLOC _fmalloc
   #define FCALLOC _fcalloc
   #define FFREE _ffree
   #define FREALLOC _frealloc
   #define STRUPR _strupr
#endif

#ifndef DLL_FUNC
   #ifdef _WIN32
      #define DLL_FUNC __stdcall
   #else
      #define DLL_FUNC
   #endif
#endif
#define DLLPTR

/* __restrict is defined in MinGW and Digital Mars, no matter what;
   and in Watcom for C, but not C++.  It's not in Visual C++ at all. */
#if defined( __WATCOMC__) && defined( __cplusplus)
   #define __restrict
#elif defined( _MSC_VER)
   #define __restrict
#endif

/* A useful trick to suppress 'unused parameter' warnings, modified from
   https://stackoverflow.com/questions/1486904/how-do-i-best-silence-a-warning-about-unused-variables */
#define INTENTIONALLY_UNUSED_PARAMETER( param) (void)(param)

#endif      /* WATDEFS_H */
