//
// Created by leixing on 2025-07-16.
//

#pragma once

#if !defined( LIB_STORAGE_API )
#  if defined( LIB_STORAGE_SHARED )
#    if defined( _MSC_VER )
#      if defined( LIB_STORAGE_SHARED_EXPORT )
#        define LIB_STORAGE_API __declspec( dllexport )
#      else
#        define LIB_STORAGE_API __declspec( dllimport )
#      endif
#    elif defined( __clang__ ) || defined( __GNUC__ )
#      if defined( LIB_STORAGE_SHARED_EXPORT )
#        define LIB_STORAGE_API __attribute__( ( visibility( "default" ) ) )
#      else
#        define LIB_STORAGE_API
#      endif
#    else
#      define LIB_STORAGE_API
#      pragma warning Unknown import / export semantics
#    endif
#  else
#    define LIB_STORAGE_API
#  endif
#endif
