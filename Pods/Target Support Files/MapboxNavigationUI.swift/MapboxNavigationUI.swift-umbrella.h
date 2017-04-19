#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "MapboxNavigationUI.h"
#import "MGLMapView+MGLNavigationAdditions.h"

FOUNDATION_EXPORT double MapboxNavigationUIVersionNumber;
FOUNDATION_EXPORT const unsigned char MapboxNavigationUIVersionString[];

