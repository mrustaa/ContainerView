
//  Created by Rustam Motygullin on 12.08.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



/// APP
#define APP                         ([UIApplication sharedApplication])
#define WINDOW                      ((UIWindow *)APP.delegate.window)

/// ROOT
#define ROOT_VC                     (APP.keyWindow.rootViewController)

/// NAV
#define NAV_ADDED                   ([ROOT_VC isKindOfClass:[UINavigationController class]])

#define NETWORK_INDICATOR_ON(a)     (APP.networkActivityIndicatorVisible = a)

/// STATUS BAR
#define STATUSBAR_STYLE(a)          ([APP setStatusBarStyle:(UIStatusBarStyle)a animated:YES])


/// SIZE
#define FRAME                       ((CGRect)WINDOW.frame)

#define SCREEN_STATUS_HEIGHT        [UIApplication sharedApplication].statusBarFrame.size.height

#define SCREEN_WIDTH                ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT               ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH           (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH           (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define SCREEN_PORTRAIT             (SCREEN_WIDTH < SCREEN_HEIGHT)

/// DEVICE
#define IS_IPAD                     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA                   ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IPHONE_4                 (IS_IPHONE && SCREEN_MAX_LENGTH <  568.0)
#define IS_IPHONE_5                 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6                 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P                (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X                 (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define IS_BIG_IPHONE               (IS_IPHONE && SCREEN_MAX_LENGTH >  568.0)

#define IPHONE_X_PADDING_TOP        (IS_IPHONE_X ? 24 :0)
#define IPHONE_X_PADDING_BOTTOM     (IS_IPHONE_X ? 34 :0)

/// COLOR
#define RGBA(r,g,b,a)               ([UIColor colorWithRed:(CGFloat)r / 255.0 green:(CGFloat)g / 255.0 blue:(CGFloat)b / 255.0 alpha:(CGFloat)a])
#define RGB(r,g,b)                  RGBA(r,g,b, 1.0)
#define HTMLRGBA(rgb,a)             RGBA( ((rgb >> 16) & 0xff),((rgb >> 8) & 0xff),((rgb) & 0xff),a)
#define HTMLRGB(rgb)                HTMLRGBA(rgb, 1.0)

#define GRAYLEVEL(l)                RGB(l,l,l)

#define BLACK_COLOR                 [UIColor blackColor]
#define WHITE_COLOR                 [UIColor whiteColor]
#define RED_COLOR                   [UIColor   redColor]
#define CLR_COLOR                   [UIColor clearColor]

/// FONTS
#define FONT_S(s)                   [UIFont systemFontOfSize:s]
#define FONT_BS(s)                  [UIFont boldSystemFontOfSize:s]

/// ANIMATION
#define ANIMATION(d,a)              [UIView animateWithDuration:d animations:a completion:nil]
#define ANIMATIONCOMP(d,a,c)        [UIView animateWithDuration:d animations:a completion:c]
#define ANIMATION_SPRING(d,a)       [UIView animateWithDuration:d delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:6.0 options:UIViewAnimationOptionAllowUserInteraction animations:a completion:nil]
#define ANIMATION_SPRINGCOMP(d,a,c) [UIView animateWithDuration:d delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:6.0 options:UIViewAnimationOptionAllowUserInteraction animations:a completion:c]


/// STRING
#define SFMT(str, ...)                            [NSString stringWithFormat:str, ##__VA_ARGS__]
#define PRINT(str, ...)             printf("%s\n",[NSString stringWithFormat:str, ##__VA_ARGS__].UTF8String)

/// IMAGE
#define IMG(name)                   [UIImage imageNamed:name]


/// GCD
#define GCD_SYNC_MAIN_BEGIN dispatch_sync(dispatch_get_main_queue(), ^
#define GCD_ASYNC_MAIN_BEGIN dispatch_async(dispatch_get_main_queue(), ^
#define GCD_MAIN_END });

#define GCD_SYNC_GLOBAL_BEGIN(PRIORITY) dispatch_sync(dispatch_get_global_queue(PRIORITY, 0), ^
#define GCD_ASYNC_GLOBAL_BEGIN(PRIORITY) dispatch_async(dispatch_get_global_queue(PRIORITY, 0), ^
#define GCD_GLOBAL_END });


/// CUSTOM
#define COORDINATE_SAN_FRANCISCO    (MKCoordinateRegionMakeWithDistance( (CLLocationCoordinate2D) { 37.773972, -122.431297 }, 25000, 25000))

#define CUSTOM_TOP                  60.0
#define CUSTOM_BOTTOM               (92)
#define CUSTOM_MIDDLE               (0.5)

#define CUSTOM_HEADER_HEIGHT        64.0

#define FRAME_SCROLLVIEW            CGRectMake ( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT -CUSTOM_TOP -IPHONE_X_PADDING_TOP )


