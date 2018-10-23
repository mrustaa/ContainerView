
//  Created by Rustam Motygullin on 12.08.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGB(r,g,b)                  ([UIColor colorWithRed:(CGFloat)r / 255.0             green:(CGFloat)g / 255.0            blue:(CGFloat)b / 255.0       alpha:1.0])
#define RGBA(r,g,b,a)               ([UIColor colorWithRed:(CGFloat)r / 255.0             green:(CGFloat)g / 255.0            blue:(CGFloat)b / 255.0       alpha:(CGFloat)a])
#define HTMLRGB(rgb)                ([UIColor colorWithRed:(((rgb >> 16) & 0xff) / 255.0) green:(((rgb >> 8) & 0xff) / 255.0) blue:(((rgb) & 0xff) / 255.0) alpha:1.0])
#define HTMLRGBA(rgb,a)             ([UIColor colorWithRed:(((rgb >> 16) & 0xff) / 255.0) green:(((rgb >> 8) & 0xff) / 255.0) blue:(((rgb) & 0xff) / 255.0) alpha:a  ])

#define APP                         ([UIApplication sharedApplication])

#define statusBarHidden(a)          ([APP setStatusBarHidden:(BOOL)a     animated:YES])
#define statusBarStyle(a)           ([APP setStatusBarStyle:(NSInteger)a animated:YES])
#define networkIndicatorOn(a)       (APP.networkActivityIndicatorVisible = a)

#define ROOT_VC                     APP.keyWindow.rootViewController
#define NAV_ADDED                   ([ROOT_VC isKindOfClass:[UINavigationController class]])

#define selfWindow                  ((UIWindow *)APP.delegate.window)
#define selfFrame                   ((CGRect)selfWindow.frame)

#define coordinateMoscow            (MKCoordinateRegionMakeWithDistance( (CLLocationCoordinate2D) { 55.752316, 37.621014 }, 60000, 60000))

#define defaultFrameY               ((CGFloat) 60.0)
#define defaultHeaderHeight         ((CGFloat) 64.0)
#define defaultHeaderOrigin         ((CGPoint) { 0, defaultHeaderHeight })

#define frameTableCollection        ((CGRect) { defaultHeaderOrigin, { selfFrame.size.width, selfFrame.size.height -defaultFrameY -defaultHeaderHeight }}) 

#define documentsPath               ((NSString *)NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0])

#define animationsSpring(d,a)       ([UIView animateWithDuration:d delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:6.0 options:UIViewAnimationOptionAllowUserInteraction animations:a completion:nil])
#define animationsCompletion(d,a,c) ([UIView animateWithDuration:d animations:a completion:c])
#define animations(d,a)             ([UIView animateWithDuration:d animations:a])

#define iphoneSE                    (568)
#define iphone8                     (667)
#define iphone8plus                 (736)
#define iphoneX                     (812)

#define SCREEN_STATUS_HEIGHT APP.statusBarFrame.size.height

#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define SFMT(str, ...) [NSString stringWithFormat:str, ##__VA_ARGS__]

// GCD tools
#define GCD_SYNC_MAIN_BEGIN dispatch_sync(dispatch_get_main_queue(), ^{
#define GCD_ASYNC_MAIN_BEGIN dispatch_async(dispatch_get_main_queue(), ^{
#define GCD_MAIN_END });

#define GCD_SYNC_GLOBAL_BEGIN(PRIORITY) dispatch_sync(dispatch_get_global_queue(PRIORITY, 0), ^{
#define GCD_ASYNC_GLOBAL_BEGIN(PRIORITY) dispatch_async(dispatch_get_global_queue(PRIORITY, 0), ^{
#define GCD_GLOBAL_END });
//
