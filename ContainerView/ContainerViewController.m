
//  Created by Рустам Мотыгуллин on 17.08.2018.
//  Copyright © 2018 GetTransfer. All rights reserved.

#import "ContainerViewController.h"



@interface ContainerViewController () {
    BOOL bordersRunContainer;
    
    BOOL onceEnded;
    BOOL bottomDeceleratingDisable;
    
    BOOL onceScrollingBeginDragging;
    
    BOOL scrollBegin;
    CGFloat startScrollPosition;
    CGAffineTransform selfTransform;

    BOOL _containerShadowView;
    BOOL _containerZoom;
}

@property (nonatomic) ContainerScrollDelegate * protocol;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self.view insertSubview:self.shadowButton aboveSubview:self.bottomView];
    [self.view insertSubview:self.bottomView atIndex:0];
//    [self.view addSubview:self.bottomView];
    
    /// тень кнопка нужна
    self.containerShadowView = YES;
    
    [self.view addSubview:self.containerView];
}

#pragma mark - Create

/// инициализация контейнера здесь обязательно
- (ContainerView *)containerView {
    
    if(!_containerView)
    {
        ContainerView *
        container = [[ContainerView alloc] initWithFrame: (CGRect){ CGPointZero, { SCREEN_WIDTH, SCREEN_HEIGHT +50 }}];
        
        __weak typeof(self) weakSelf = self;
        container.blockChangeShadowLevel = ^(ContainerMoveType containerMove, CGFloat containerFrameY, BOOL animated) {
            
            if(animated) {
                
                ANIMATION_SPRING(.45,^(void){
                    [weakSelf changeScalesImageAndShadowLevel:containerFrameY];
                    //self.segmentedContainerMove.selectedSegmentIndex = containerMove;
                    //[weakSelf changeScalesImageAndShadowLevel:containerFrameY];
                });
            } else {
                [weakSelf changeScalesImageAndShadowLevel:containerFrameY];
                //[weakSelf changeScalesImageAndShadowLevel:containerFrameY];
            }
        };
        _containerView = container;
    }
    return _containerView;
}

- (UIView *)bottomView {
    /// боттом вью нужин
    if(!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:self.view.bounds];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}



#pragma mark - Getter Setter


- (void)setContainerHeaderView:(UIView *)containerHeaderView {
    self.containerView.headerView = containerHeaderView;
}

- (UIView *)containerHeaderView {
    return self.containerView.headerView;
}


- (void)setContainerBottomButtonToMoveTop:(BOOL)containerBottomButtonToMoveTop {
    self.containerView.containerBottomButtonToMoveTop = containerBottomButtonToMoveTop;
}

- (BOOL)containerBottomButtonToMoveTop {
    return self.containerView.containerBottomButtonToMoveTop;
}



- (void)setContainerShadowView:(BOOL)value {
    
    if(value == NO) {
        [_shadowButton removeFromSuperview];
        _shadowButton = nil;
    } else {
        
        if(!_shadowButton) {
            UIButton *
            shadow = [UIButton buttonWithType:UIButtonTypeCustom];
            [shadow addTarget:self action:@selector(shadowButtonAction) forControlEvents:UIControlEventTouchUpInside];
            shadow.frame = FRAME;
            shadow.backgroundColor = [UIColor blackColor];
            shadow.alpha = 0;
            _shadowButton = shadow;
//            [self.view insertSubview:_shadowButton aboveSubview:self.bottomView];
            [self.bottomView addSubview:_shadowButton];
        }
    }
    _containerShadowView = value;
}

- (BOOL)containerShadowView {
    return _shadowButton != nil;
}

- (void)shadowButtonAction {
    [self containerMove:ContainerMoveTypeBottom];
}


- (void)setContainerZoom:(BOOL)containerZoom {
    _containerZoom = containerZoom;
}

- (BOOL)containerZoom {
    return _containerZoom;
}



- (void)setContainerAllowMiddlePosition:(BOOL)containerAllowMiddlePosition {
    self.containerView.containerAllowMiddlePosition = containerAllowMiddlePosition;
}

- (BOOL)containerAllowMiddlePosition {
    return self.containerView.containerAllowMiddlePosition;
}





- (void)setContainerTop:(CGFloat)containerTop {
    self.containerView.containerTop = containerTop;
}

- (CGFloat)containerTop {
    return self.containerView.containerTop;
}


- (void)setContainerMiddle:(CGFloat)containerMiddle {
    self.containerView.containerMiddle = containerMiddle;
}

- (CGFloat)containerMiddle {
    return self.containerView.containerMiddle;
}

- (void)setContainerBottom:(CGFloat)containerBottom {
    self.containerView.containerBottom = containerBottom;
}

- (CGFloat)containerBottom {
    return self.containerView.containerBottom;
}





- (ContainerMoveType)containerPosition {
    return self.containerView.containerPosition;
}




- (void)containerMove:(ContainerMoveType)containerMove {
    [self.containerView containerMove:containerMove];
}

- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated {
    [self.containerView containerMove:moveType animated:animated];
}

- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion {
    [self.containerView containerMove:moveType animated:animated completion:completion];
}




- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType {
    [self.containerView containerMoveCustomPosition:position moveType:moveType];
}

- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated {
    [self.containerView containerMoveCustomPosition:position moveType:moveType animated:animated];
}

- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion {
    [self.containerView containerMoveCustomPosition:position moveType:moveType animated:animated completion:completion];
}











#pragma mark - ChangeShadowLevel

//- (void)changeShadowLevel:(CGFloat)containerFrameY {
//
//    if (containerFrameY <= self.containerTop) {
//        self.shadowButton.alpha = 0.8;
//    } else {
//        NSInteger minPos = self.containerTop;
//        NSInteger maxPos = self.view.height;
//
//        if (self.containerAllowMiddlePosition) {
//            maxPos = self.containerMiddle;
//        }
//
//        maxPos -= minPos;
//
//        NSInteger pos = maxPos - (containerFrameY - minPos);
//
//        if (IS_IPHONE_X) {
//            pos -= 34;
//        }
//
//        CGFloat perc = pos * 0.8;
//        perc /= maxPos;
//
//        self.shadowButton.alpha = perc;
//    }
//}


- (void)changeScalesImageAndShadowLevel:(CGFloat)containerFrameY {
    [self.view endEditing:YES];
    
    CGFloat selfCenter = self.containerView.containerMiddle;
    
    
    if(containerFrameY < selfCenter) {
        
        CGFloat procent = (((selfCenter -containerFrameY) / selfCenter) / 2);
        
        CGAffineTransform transform = CGAffineTransformMakeScale( 1. -(procent / 5), 1. -(procent / 5));
        
        
        
        if(self.containerZoom) {
            for(UIView *v in self.view.subviews) {
                if(![v isKindOfClass:[ContainerView class]] && (v != self.shadowButton)) {
                    v.transform = transform;
                    v.layer.cornerRadius = (procent * 24);
                    
                }
                
            }
//            self.bottomView.transform = transform;
//            self.bottomView.layer.cornerRadius = (procent * 24);
        } else {
            for(UIView *v in self.view.subviews) {
                if(![v isKindOfClass:[ContainerView class]] && (v != self.shadowButton)) {
                    v.transform = CGAffineTransformIdentity;
                    v.layer.cornerRadius = 0;
                }
            }
//            self.bottomView.transform = CGAffineTransformIdentity;
//            self.bottomView.layer.cornerRadius = 0;
        }
        
        self.shadowButton.alpha = procent;
        self.shadowButton.height = (containerFrameY +self.containerView.containerCornerRadius +5);
        
    } else {
        
        for(UIView *v in self.view.subviews) {
            if(![v isKindOfClass:[ContainerView class]] && (v != self.shadowButton)) {
                v.transform = CGAffineTransformIdentity;
                v.layer.cornerRadius = 0;
            }
        }
//        self.bottomView.transform = CGAffineTransformIdentity;
//        self.bottomView.layer.cornerRadius = 0;
        
//        self.bottomView.userInteractionEnabled = NO;
        
//        self.shadowButton.userInteractionEnabled = NO;
//        self.shadowButton.hidden = YES;
        
        self.shadowButton.alpha = 0.; 
        self.shadowButton.height = SCREEN_HEIGHT;
    }
}






- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat velocityInViewY    = [scrollView.panGestureRecognizer velocityInView:   WINDOW].y;
    CGFloat translationInViewY = [scrollView.panGestureRecognizer translationInView:WINDOW].y;
    
    if((scrollView.panGestureRecognizer.state) && (scrollView.contentOffset.y <= 0)) {
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentOffset = CGPointMake( scrollView.contentOffset.x, 0 );
    } else {
        scrollView.showsVerticalScrollIndicator = YES;
    }
    
    bordersRunContainer = ( (scrollView.contentOffset.y == 0) && (0 < velocityInViewY));
    
    selfTransform = self.containerView.transform;
    
    
    //    if(NAV_ADDED) {
    //        UINavigationController *nvc = (UINavigationController *)ROOT_VC;
    //        if(!nvc.navigationBarHidden) {
    //            top = (top + nvc.navigationBar.height);
    //        }
    //    }
    
    
    CGFloat top     = self.containerView.containerTop;
    
    if(scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
        onceScrollingBeginDragging = NO;
    
    if(bordersRunContainer) {
        
        onceEnded = NO;
        onceScrollingBeginDragging = NO;
        
        selfTransform.ty = ((top - startScrollPosition) + translationInViewY );
        if(selfTransform.ty < top) selfTransform.ty = top;
        
        if(scrollBegin)
        {
            ANIMATION_SPRING(.325, ^(void) {
                self.containerView.transform = self->selfTransform;
            });
            
            scrollBegin = NO;
            
        } else {
            self.containerView.transform = selfTransform;
        }
    }
    else
    {
        if((top == selfTransform.ty) && !onceScrollingBeginDragging) {
            onceScrollingBeginDragging = YES;
            
            CGFloat headerHeight = (self.containerView.headerView) ?self.containerView.headerView.height :0;
            CGFloat top = (self.containerView.containerTop == 0) ? CUSTOM_TOP : self.containerView.containerTop;
            CGFloat iphnX = (IS_IPHONE_X ? 24 :0);
            
            CGFloat height = (SCREEN_HEIGHT - (top + headerHeight + iphnX ));
            
            if(scrollView.height != height) {
                
                ANIMATION_SPRING( .45, ^(void) {
                    scrollView.y = headerHeight;
                    scrollView.height = height;
                });
            }
        }
        
        
        if(top < selfTransform.ty)
        {
            if (velocityInViewY < 0. )
            {
                if(self.containerView.containerPosition == ContainerMoveTypeTop) {
                    scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0 );
                }
                
                selfTransform = self.containerView.transform;
                selfTransform.ty = ((top - startScrollPosition) + translationInViewY );
                
                if(selfTransform.ty < top) selfTransform.ty = top;
                
                self.containerView.transform = selfTransform;
            }
        }
    }
    

    [self changeScalesImageAndShadowLevel:selfTransform.ty];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startScrollPosition = scrollView.contentOffset.y;
    
    if(bottomDeceleratingDisable) return;
    
    scrollBegin = YES;
    if(startScrollPosition < 0) startScrollPosition = 0;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(bottomDeceleratingDisable) return;
    CGFloat velocityInViewY = [scrollView.panGestureRecognizer velocityInView:WINDOW].y;
    
    if(!self.containerView) return;
    
    if(!onceEnded)
    {
        onceEnded = YES;
        [self.containerView containerMoveForVelocityInView:velocityInViewY];
    }
}





@end
