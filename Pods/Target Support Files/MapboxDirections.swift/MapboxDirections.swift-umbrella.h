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

#import "MapboxDirections.h"
#import "MBAttribute.h"
#import "MBLaneIndication.h"
#import "MBRouteOptions.h"

FOUNDATION_EXPORT double MapboxDirectionsVersionNumber;
FOUNDATION_EXPORT const unsigned char MapboxDirectionsVersionString[];

