
//  Created by Rustam Motygullin on 08.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "ContainerView.h"

#import "UIView+Frame.h"
#import "Defines.h"

@interface ContainerView () <UIGestureRecognizerDelegate, UISearchBarDelegate>  {
    CGFloat _containerTop;
    CGFloat _containerMiddle;
    CGFloat _containerBottom;
    CGFloat _savePositionContainer;
    CGFloat _containerCornerRadius;
    BOOL _containerAllowMiddlePosition;
    BOOL _containerShadow;
    UIView * _headerView;
}



@property (strong, nonatomic) UIButton *bottomButtonToMoveTop;

@property (strong, nonatomic) UIScrollView *scrollView;


@property (strong, nonatomic) UIVisualEffectView *visualEffectViewOrigin;
@property (strong, nonatomic) UIView *visualEffectView;

@end


@implementation ContainerView

- (id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if(self) [self initContainer];
    return self;
}

- (void)initContainer
{
    self.backgroundColor     = CLR_COLOR;
    self.clipsToBounds       = NO;
    //self.layer.masksToBounds = NO;
    
    self.layer.shadowOffset  = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 0.75;
    self.layer.shadowRadius  = 5;
    self.layer.shadowColor   = RGB(44, 62, 80).CGColor;
    
    
    
    _containerAllowMiddlePosition = NO;
    _containerShadow = YES;
    
    UIPanGestureRecognizer *
    containerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    containerPan.delegate = self;
    [self addGestureRecognizer:containerPan];
    
    
// TODO: Implement these.
//    if (NAV_ADDED) {
//        UINavigationController * nav = (UINavigationController *)ROOT_VC;
//        if(!nav.navigationBarHidden) {
//            if(!nav.navigationBar.translucent) {
//
//            }
//            if (@available(iOS 11.0, *)) {
//                if(!nav.navigationBar.prefersLargeTitles) {
//
//                }
//            }
//         }
//    }
    
    
    self.transform = CGAffineTransformMakeTranslation( 0, self.containerBottom - (IS_IPHONE_X ?34 :0));
    self.containerPosition = ContainerMoveTypeBottom;
    
    if(!self.visualEffectView) {
        self.visualEffectView = [[UIView alloc] initWithFrame: (CGRect){ {0, 0}, self.frame.size } ];
        self.visualEffectView.clipsToBounds = YES;
        [self addSubview: self.visualEffectView];
        
        if(!self.visualEffectViewOrigin)
        {
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            self.visualEffectViewOrigin = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.visualEffectViewOrigin.frame = (CGRect){ { 0, 0 }, self.frame.size };
            [self.visualEffectView addSubview: self.visualEffectViewOrigin];
        }
        self.visualEffectView.backgroundColor = WHITE_COLOR;
        self.visualEffectViewOrigin.hidden = YES;
    }
}

/// Add Subview - Search ScrollView
- (void)addSubview:(UIView *)subview {
    if(subview == self.visualEffectView)
         [super addSubview:subview];
    else [self.visualEffectView addSubview:subview];
    
    if([subview isKindOfClass:[UIScrollView class]]) {
        if(self.containerBottomButtonToMoveTop) {
            self.containerBottomButtonToMoveTop = NO;
        }
        
        [super addSubview:self.bottomButtonToMoveTop];
        
        self.scrollView = (UIScrollView *)subview;
        if (@available(iOS 11.0, *)) {
            self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        
        self.scrollView.userInteractionEnabled = (self.containerPosition == ContainerMoveTypeTop);
        
        self.scrollView.indicatorStyle =
        (self.containerStyle == ContainerStyleDark) ? UIScrollViewIndicatorStyleWhite :UIScrollViewIndicatorStyleDefault;
        
        [self changeCornerRadius:_containerCornerRadius];
    }
}

- (void)setContainerBottomButtonToMoveTop:(BOOL)newValue {
    if(newValue) {
        [self addSubview: self.bottomButtonToMoveTop];
    } else if (!newValue && _bottomButtonToMoveTop) {
        [_bottomButtonToMoveTop removeFromSuperview];
        _bottomButtonToMoveTop = nil;
    }
}

- (BOOL)containerBottomButtonToMoveTop {
    return _bottomButtonToMoveTop != nil;
}

- (void)setContainerCornerRadius:(CGFloat)containerCornerRadius {
    [self changeCornerRadius:containerCornerRadius];
}

- (CGFloat)containerCornerRadius {
    return _containerCornerRadius;
}

- (void)changeCornerRadius:(CGFloat)newValue {
    _containerCornerRadius = newValue;
    
    self.layer.cornerRadius = _containerCornerRadius;
    
    if (self.visualEffectView)
        self.visualEffectView.layer.cornerRadius = _containerCornerRadius;
    
    [self calculationScrollViewHeight:0];
}





- (UIButton *)bottomButtonToMoveTop {
    
    if(!_bottomButtonToMoveTop)
    {
        UIButton *
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(containerBottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        //[btn addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerBottomButtonAction)]];
        //[btn addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(containerBottomButtonAction)]];
        
        btn.frame = CGRectMake( 0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - self.containerBottom + (IS_IPHONE_X ?34 :0)) );
        btn.backgroundColor = CLR_COLOR;
        _bottomButtonToMoveTop = btn;
    }
    
    return _bottomButtonToMoveTop;
}
- (void)containerBottomButtonAction {
    if(self.containerPosition == ContainerMoveTypeBottom) {
        [self containerMove:ContainerMoveTypeTop];
    }
}



- (void)transitionToSizeTop:(CGFloat)top middle:(CGFloat)middle bottom:(CGFloat)bottom size:(CGSize)size {
    _containerTop = top;
    _containerMiddle = middle;
    _containerBottom = bottom;
    
    self.width  = size.width;
    self.height = size.height;
    
    self.visualEffectView.width  = size.width;
    self.visualEffectView.height = size.height;
    
    self.visualEffectViewOrigin.width  = size.width;
    self.visualEffectViewOrigin.height = size.height;
    
    if(self.headerView) self.headerView.width = size.width;
    
    [self calculationScrollViewHeight:0];
}

/// Top
- (void)setContainerTop:(CGFloat)containerTop {
    if(!_addedTop) _addedTop = YES;
    _containerTop = containerTop;
}

- (CGFloat)containerTop {
    if(!_containerTop) _containerTop = CUSTOM_TOP;
    return _containerTop;
}

/// Middle
- (void)setContainerMiddle:(CGFloat)containerMiddle {
    if(!_addedMiddle) _addedMiddle = YES;
    // if(IS_IPHONE_X) containerMiddle -= 34;
    _containerMiddle = containerMiddle;
}

- (CGFloat)containerMiddle {
    if(!_containerMiddle) _containerMiddle = CUSTOM_MIDDLE;
    return _containerMiddle;
}

/// Bottom
- (void)setContainerBottom:(CGFloat)containerBottom {
    if(!_addedBottom) _addedBottom = YES;
    _containerBottom = containerBottom;
    if(_bottomButtonToMoveTop) _bottomButtonToMoveTop.height = containerBottom;
}

- (CGFloat)containerBottom {
    if(!_containerBottom) _containerBottom = CUSTOM_BOTTOM;
    return _containerBottom;
}


/// Enabled Move Middle
- (void)setContainerAllowMiddlePosition:(BOOL)containerAllowMiddlePosition {
    _containerAllowMiddlePosition = containerAllowMiddlePosition;
    [self containerMove: (containerAllowMiddlePosition) ?ContainerMoveTypeMiddle :ContainerMoveTypeBottom];    
}

- (BOOL)containerAllowMiddlePosition {
    return _containerAllowMiddlePosition;
}


/// Shadow
- (void)setContainerShadow:(BOOL)containerShadow {
    _containerShadow = containerShadow;
    
    if(containerShadow) {
        self.layer.shadowOffset  = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.75;
        self.layer.shadowRadius  = 5;
    } else {
        self.layer.shadowOffset  = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.;
        self.layer.shadowRadius  = 0;
    }
}

- (BOOL)containerShadow {
    return _containerShadow;
}


/// Header
- (void)setHeaderView:(UIView *)hv {
    
    if(hv) {
        if(_headerView) [self removeHeaderView];
        _headerView = hv;
        [self addSubview:_headerView];
    } else {
        [self removeHeaderView];
    }
    [self calculationScrollViewHeight:0];
}

- (UIView *)headerView {
    return _headerView;
}

- (void)removeHeaderView {
    if(_headerView) {
        [_headerView removeFromSuperview];
    }
    _headerView = nil;
}


/// Calculation ScrollView
- (void)calculationScrollViewHeight:(CGFloat)containerPositionBottom {
    if(self.scrollView) {
        CGFloat headerHeight = (_headerView ?_headerView.height :0);
        CGFloat top = self.containerTop;
        CGFloat iphnXpaddingTop     = (IS_IPHONE_X ?24:0);
        CGFloat iphnXpaddingBottom  = (IS_IPHONE_X ?34:0);
        CGFloat scrollIndicatorInsetsBottom = (!_headerView) ? (0.66 * self.containerCornerRadius) :0;
        
        self.scrollView.y = headerHeight;
        self.scrollView.width = SCREEN_WIDTH;
        self.scrollView.height = (SCREEN_HEIGHT + containerPositionBottom - (top + headerHeight + iphnXpaddingTop));
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake( scrollIndicatorInsetsBottom, 0, iphnXpaddingBottom , 0);
    }
}


/// Gesture
- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer {
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _savePositionContainer = self.transform.ty;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform
        _transform = self.transform;
        _transform.ty = (_savePositionContainer + [recognizer translationInView: self].y );
        if (_transform.ty < 0) {
            _transform.ty = 0;
        } else if( _transform.ty < self.containerTop) {
            _transform.ty = ( self.containerTop / 2) + (_transform.ty / 2);
            
            CGFloat containerPositionBottom = (self.containerPosition == ContainerMoveTypeBottom) ?(self.containerTop + 5) :0;
            
            if( (self.scrollView.contentOffset.y + self.scrollView.height + containerPositionBottom) < self.scrollView.contentSize.height) {
                [self calculationScrollViewHeight:(_transform.ty + 5)];
            }
            
            self.transform = _transform;
        } else {
            self.transform = _transform;
        }
        
        if ([self.delegate respondsToSelector:@selector(changeContainerMove:containerY:animated:)]) {
            [self.delegate changeContainerMove:ContainerMoveTypeTop containerY:self.transform.ty animated:NO];
        }
        
        self.bottomButtonToMoveTop.hidden = YES;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat velocityInViewY = [recognizer velocityInView:self].y;
        [self containerMoveForVelocityInView:velocityInViewY];
    }
}

/// Container Move
- (void)containerMoveForVelocityInView:(CGFloat)velocityInViewY {
    
    ContainerMoveType moveType;
    
    if( self.containerAllowMiddlePosition ) {
        if( self.transform.ty < self.containerMiddle ) {
            if(velocityInViewY < 0) {
                moveType = ContainerMoveTypeTop;
            } else {
                moveType = (2500 < velocityInViewY) ?ContainerMoveTypeBottom :ContainerMoveTypeMiddle;
            }
        } else {
            if(velocityInViewY < 0) {
                moveType = (velocityInViewY < (-2000)) ?ContainerMoveTypeTop :ContainerMoveTypeMiddle;
            } else {
                moveType = ContainerMoveTypeBottom;
            }
        }
    } else {
        if( self.transform.ty < self.containerTop ) {
            moveType = (750 < velocityInViewY) ?ContainerMoveTypeBottom :ContainerMoveTypeTop;
        } else {
            moveType = (velocityInViewY < 0) ?ContainerMoveTypeTop :ContainerMoveTypeBottom;
        }
    }
    [self containerMove:moveType];
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}


- (void)changeBlurStyle:(ContainerStyle)styleType {
    
    self.containerStyle = styleType;
    
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    
    CGFloat alpha = 0.5;
    UIColor *graberColor = GRAYLEVEL(180);
    UIColor *separatorColor = [graberColor copy];
    
    if((styleType == ContainerStyleDark) ||
       (styleType == ContainerStyleDefault)) {
        graberColor     = RGB(235, 239, 245);
        separatorColor  = GRAYLEVEL(222);
    }
    
    if      (styleType == ContainerStyleDark)    alpha = 0.2;
    else if (styleType == ContainerStyleDefault) alpha = 1.0;
    
    if(styleType == ContainerStyleDark) {
        self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    }
    
    if(styleType != ContainerStyleDefault) {
        self.visualEffectView.backgroundColor = CLR_COLOR;
        self.visualEffectViewOrigin.hidden = NO;
        
        UIBlurEffectStyle effect;
        if      (styleType == ContainerStyleLight)      effect = UIBlurEffectStyleLight;
        else if (styleType == ContainerStyleExtraLight) effect = UIBlurEffectStyleExtraLight;
        else                                            effect = UIBlurEffectStyleDark;
        
        self.visualEffectViewOrigin.effect = [UIBlurEffect effectWithStyle:effect];
    } else {
        self.visualEffectView.backgroundColor = WHITE_COLOR;
        self.visualEffectViewOrigin.hidden = YES;
    }
}


#pragma mark - ContainerMove

- (void)containerMove:(ContainerMoveType)moveType {
    [self containerMove:moveType animated:YES completion:nil];
}

- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated {
    [self containerMove:moveType animated:animated completion:nil];
}

- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion {
    
    self.containerPosition = moveType;
    
    CGFloat position = 0;
    
    switch (moveType) {
        case ContainerMoveTypeTop:      position = self.containerTop + (IS_IPHONE_X ?24 :0); break;
        case ContainerMoveTypeMiddle:   position = self.containerMiddle; break;
        case ContainerMoveTypeBottom:   position = self.containerBottom - (IS_IPHONE_X ?34 :0); break;
        case ContainerMoveTypeHide:     position = SCREEN_HEIGHT; break;
    }
    
    [self containerMovePosition:position moveType:moveType animated:animated completion:completion];
}

- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType {
    [self containerMoveCustomPosition:position moveType:moveType animated:YES completion:nil];
}

- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated {
    [self containerMoveCustomPosition:position moveType:moveType animated:animated completion:nil];
}

- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion {
    [self calculationScrollViewHeight:0];
    
    self.containerPosition = moveType;
    [self containerMovePosition:position moveType:moveType animated:animated completion:completion];
}

- (void)containerMovePosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion {
    if(_bottomButtonToMoveTop) self.bottomButtonToMoveTop.hidden = (moveType == ContainerMoveTypeTop) ? YES : NO;
    
    
    self.scrollView.userInteractionEnabled = (moveType == ContainerMoveTypeTop);
    
    CGFloat containerPositionBottom = (self.containerPosition == ContainerMoveTypeBottom) ?(self.containerTop + 5) :0;
    
    CGAffineTransform _transform = CGAffineTransformMakeTranslation( 0, position);
    
    if ([self.delegate respondsToSelector:@selector(changeContainerMove:containerY:animated:)]) {
        [self.delegate changeContainerMove:moveType containerY:_transform.ty animated:animated];
    }
    
    if(animated) {
        ANIMATION_SPRINGCOMP(.45, ^(void) {
            self.transform = _transform;
        }, ^(BOOL fin) {
            
            if(self.scrollView) {
                if( (self.scrollView.contentOffset.y + self.scrollView.height + containerPositionBottom) < self.scrollView.contentSize.height) {
                    [self calculationScrollViewHeight:containerPositionBottom];
                }
            }
            if(completion) completion();
        });
    } else {
        self.transform = _transform;
        if(completion) completion();
    }
}



@end
