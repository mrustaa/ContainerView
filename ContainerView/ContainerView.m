
//  Created by Rustam Motygullin on 08.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "ContainerView.h"

@interface ContainerView () <UIGestureRecognizerDelegate, UISearchBarDelegate>  {
    CGFloat _containerTop;
    CGFloat _containerMiddle;
    CGFloat _containerBottom;
    BOOL _containerAllowMiddlePosition;
    UIView * _headerView;
}

@property (strong, nonatomic) UIButton *bottomButtonToMoveTop;

@property (strong, nonatomic) UIVisualEffectView *visualEffectViewOrigin;
@property (strong, nonatomic) UIView *visualEffectView;

@property NSInteger savePositionContainer;

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
    self.layer.shadowOffset  = CGSizeMake(0, 5);
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius  = 5;
    self.layer.shadowColor   = RGB(44, 62, 80).CGColor;
    
    _containerAllowMiddlePosition = NO;
    
    UIPanGestureRecognizer *
    containerPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)];
    containerPan.delegate = self;
    [self addGestureRecognizer: containerPan];
    
//    NSInteger containerBottom_ = (SCREEN_HEIGHT -92);
//
//    if (NAV_ADDED) {
//        UINavigationController * nav = (UINavigationController *)ROOT_VC;
//        if(!nav.navigationBarHidden) {
//            if(!nav.navigationBar.translucent) {
//
//            }
//            containerBottom_ -= nav.navigationBar.height;
//        }
//    }
//    containerBottom_ -= (IS_IPHONE_X ?34 :0);
    self.transform = CGAffineTransformMakeTranslation( 0, self.containerBottom -(IS_IPHONE_X ?34 :0));
    
    
    if(!self.visualEffectView) {
        self.visualEffectView = [[UIView alloc] initWithFrame: (CGRect){ {0, 0}, self.frame.size } ];
        self.visualEffectView.clipsToBounds = YES;
        [self addSubview: self.visualEffectView];
        
        if(!self.visualEffectViewOrigin)
        {
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            self.visualEffectViewOrigin = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            self.visualEffectViewOrigin.frame = (CGRect){ {0, 0}, self.frame.size };
            [self.visualEffectView addSubview: self.visualEffectViewOrigin];
        }
        self.visualEffectView.backgroundColor = WHITE_COLOR;
        self.visualEffectViewOrigin.hidden = YES;
    }
    
}






- (void)changeCornerRadius:(CGFloat)newValue
{
    self.containerCornerRadius = newValue;
    
    self.layer.cornerRadius = self.containerCornerRadius;
    if (self.visualEffectView)
        self.visualEffectView.layer.cornerRadius = self.containerCornerRadius;
    
    [self calculationScrollViewHeight];
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

- (UIButton *)bottomButtonToMoveTop {
    
    if(!_bottomButtonToMoveTop)
    {
        UIButton *
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(containerBottomButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        //[btn addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(containerBottomButtonAction)]];
        //[btn addGestureRecognizer: [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(containerBottomButtonAction)]];
        
        btn.frame = CGRectMake( 0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT -self.containerBottom +(IS_IPHONE_X ?34 :0)) );
        btn.backgroundColor = RGBA(255, 0, 0, 0.5);
        btn.hidden = YES;
        _bottomButtonToMoveTop = btn;
    }
    
    return _bottomButtonToMoveTop;
}
- (void)containerBottomButtonAction {
    if(self.containerPosition == ContainerMoveTypeBottom) {
        [self containerMove:ContainerMoveTypeTop];
    }
}






- (void)setContainerTop:(CGFloat)containerTop {
    _containerTop = containerTop;
}

- (CGFloat)containerTop {
    if(!_containerTop) _containerTop = CUSTOM_TOP;
    return _containerTop;
}

- (void)setContainerMiddle:(CGFloat)containerMiddle {
    // if(IS_IPHONE_X) containerMiddle -= 34;
    _containerMiddle = containerMiddle;
}

- (CGFloat)containerMiddle {
    if(!_containerMiddle) _containerMiddle = CUSTOM_MIDDLE;
    return _containerMiddle;
}

- (void)setContainerBottom:(CGFloat)containerBottom {
    _containerBottom = containerBottom;
    if(_bottomButtonToMoveTop) _bottomButtonToMoveTop.height = containerBottom;
}

- (CGFloat)containerBottom {
    if(!_containerBottom) _containerBottom = CUSTOM_BOTTOM;
    return _containerBottom;
}


- (void)setContainerAllowMiddlePosition:(BOOL)containerAllowMiddlePosition {
    _containerAllowMiddlePosition = containerAllowMiddlePosition;
    [self containerMove: (containerAllowMiddlePosition) ?ContainerMoveTypeMiddle :ContainerMoveTypeBottom];    
}

- (BOOL)containerAllowMiddlePosition {
    return _containerAllowMiddlePosition;
}




- (UIView *)headerView {
    return _headerView;
}

- (void)setHeaderView:(UIView *)hv {
    
    if(hv) {
        if(_headerView) [self removeHeaderView];
        _headerView = hv;
        [self addSubview:_headerView];
    } else {
        [self removeHeaderView];
    }
    [self calculationScrollViewHeight];
}

- (void)removeHeaderView {
    if(_headerView) {
        [_headerView removeFromSuperview];
    }
    _headerView = nil;
}





- (void)addSubview:(UIView *)subview {
    [super addSubview:subview];
    if([subview isKindOfClass:[UIScrollView class]]) {
        UIScrollView * scrollView = (UIScrollView *)subview;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self calculationScrollViewHeight];
    }
}

- (void)removeScrollView {
    UIScrollView * scrollView = [self searchScrollViewInSubviews];
    if(scrollView) [scrollView removeFromSuperview];
}

- (UIScrollView *)searchScrollViewInSubviews {
    UIScrollView *scrollView = nil;
    for (UIView * view in self.subviews) {
        if([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}

- (void)calculationScrollViewHeight {
    
    UIScrollView * scrollView = [self searchScrollViewInSubviews];
    if(scrollView) {
        
        CGFloat headerHeight = (_headerView ?_headerView.height :0);
        CGFloat top = self.containerTop;
        CGFloat iphnXpaddingTop     = (IS_IPHONE_X ?24:0);
        CGFloat iphnXpaddingBottom  = (IS_IPHONE_X ?34:0);
        CGFloat scrollIndicatorInsetsBottom = (!_headerView) ? (0.66 * self.containerCornerRadius) :0;
        
        scrollView.y = headerHeight;
        scrollView.height = (SCREEN_HEIGHT -(top +headerHeight +iphnXpaddingTop ) );
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake( scrollIndicatorInsetsBottom, 0, iphnXpaddingBottom , 0);
    }
}




- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.savePositionContainer = (NSInteger)self.transform.ty;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform
        _transform = self.transform;
        _transform.ty = (self.savePositionContainer + [recognizer translationInView: self].y );
        if (_transform.ty < 0) {
            _transform.ty = 0;
        } else if( _transform.ty < self.containerTop) {
            _transform.ty = ( self.containerTop / 2) + (_transform.ty / 2);
            self.transform = _transform;
        } else {
            self.transform = _transform;
        }
        
        
        if(self.blockChangeShadowLevel) self.blockChangeShadowLevel(ContainerMoveTypeTop, self.transform.ty, NO);
        
        self.bottomButtonToMoveTop.hidden = YES;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat velocityInViewY = [recognizer velocityInView:self].y;
        [self containerMoveForVelocityInView:velocityInViewY];
    }
}


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
    return 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self containerMove:ContainerMoveTypeTop];
}

- (void)changeBlurStyle:(ContainerStyle)styleType {
    self.containerStyle = styleType;
    
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
    
    NSInteger position = 0;
    
    switch (moveType) {
        case ContainerMoveTypeTop:      position = self.containerTop +(IS_IPHONE_X ?24 :0); break;
        case ContainerMoveTypeMiddle:   position = self.containerMiddle; break;
        case ContainerMoveTypeBottom:   position = self.containerBottom -(IS_IPHONE_X ?34 :0); break;
        case ContainerMoveTypeCustom:
        case ContainerMoveTypeHide:     position = SCREEN_HEIGHT; break;
    }
    
    [self containerMovePosition:position moveType:moveType animated:animated completion:completion];
}

- (void)containerMoveCustomPosition:(NSInteger)position {
    [self containerMoveCustomPosition:position animated:YES completion:nil];
}

- (void)containerMoveCustomPosition:(NSInteger)position animated:(BOOL)animated {
    [self containerMoveCustomPosition:position animated:animated completion:nil];
}

- (void)containerMoveCustomPosition:(NSInteger)position animated:(BOOL)animated completion:(void (^)(void))completion {
    [self calculationScrollViewHeight];
    
    self.containerPosition = ContainerMoveTypeCustom;
    [self containerMovePosition:position moveType:ContainerMoveTypeCustom animated:animated completion:completion];
}

- (void)containerMovePosition:(NSInteger)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion {
    if(_bottomButtonToMoveTop) self.bottomButtonToMoveTop.hidden = (moveType == ContainerMoveTypeTop) ? YES : NO;
    
    CGAffineTransform _transform = CGAffineTransformMakeTranslation( 0, position);
    
    if(self.blockChangeShadowLevel) self.blockChangeShadowLevel(moveType, _transform.ty, animated);
    
    if(animated) {
        ANIMATION_SPRINGCOMP(.45, ^(void) {
            self.transform = _transform;
        }, ^(BOOL fin) {
            if(completion) completion();
        });
    } else {
        self.transform = _transform;
        if(completion) completion();
    }
}


@end
