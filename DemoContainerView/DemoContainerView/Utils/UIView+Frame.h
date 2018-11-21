
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (FrameUtils)

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)x;
- (CGFloat)y;
- (CGFloat)right;
- (CGFloat)bottom;

- (CGFloat)cx;
- (CGFloat)cy;

- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;

- (void)setRight:(CGFloat)right;
- (void)setBottom:(CGFloat)bottom;

- (void)setCx:(CGFloat)cx;
- (void)setCy:(CGFloat)cy;

@end
