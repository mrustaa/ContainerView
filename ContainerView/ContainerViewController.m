
//  Created by Рустам Мотыгуллин on 17.08.2018.
//  Copyright © 2018 GetTransfer. All rights reserved.

#import "ContainerViewController.h"

#import "UIView+Frame.h"
#import "Defines.h"

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

@end

@implementation ContainerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view insertSubview:self.bottomView atIndex:0];
    [self.view addSubview:self.shadowButton];
    
    
    self.containerShadowView = YES;
    self.containerZoom = YES;
    
    [self.view addSubview:self.containerView];
}

#pragma mark - Create

- (ContainerView *)containerView {
    
    if(!_containerView) {
        ContainerView *
        container = [[ContainerView alloc] initWithFrame: (CGRect){ CGPointZero, { SCREEN_WIDTH, SCREEN_HEIGHT +50 }}];
        container.delegate = self;
        _containerView = container;
    }
    return _containerView;
}

- (UIView *)bottomView {
    if(!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:self.view.bounds];
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.clipsToBounds = YES;
        
        for( UIView * v in self.view.subviews ) {
            [_bottomView addSubview:v];
        }
    }
    return _bottomView;
}

- (UIButton *)shadowButton {
    
    if(!_shadowButton) {
        UIButton *
        shadow = [UIButton buttonWithType:UIButtonTypeCustom];
        [shadow addTarget:self action:@selector(shadowButtonAction) forControlEvents:UIControlEventTouchUpInside];
        shadow.frame = FRAME;
        shadow.backgroundColor = [UIColor blackColor];
        shadow.alpha = 0;
        _shadowButton = shadow;

        [self.view addSubview:_shadowButton];
    }
    return _shadowButton;
}

#pragma mark - ContainerView Delegate

- (void)changeContainerMove:(ContainerMoveType)containerMove containerY:(CGFloat)containerY animated:(BOOL)animated {
    
    if(animated) {
        ANIMATION_SPRING(.45,^(void){
            [self changeScalesImageAndShadowLevel:containerY];
        });
    } else {
        [self changeScalesImageAndShadowLevel:containerY];
    }
}



#pragma mark - Getter Setter

- (void)setDelegate:(id<ContainerViewDelegate>)delegate {
    self.containerView.delegate = delegate;
}

- (id<ContainerViewDelegate>)delegate {
    return self.containerView.delegate;
}

- (void)setHeaderView:(UIView *)headerView {
    self.containerView.headerView = headerView;
}

- (UIView *)headerView {
    return self.containerView.headerView;
}


- (void)setContainerShadow:(BOOL)containerShadow {
    self.containerView.containerShadow =containerShadow;
}
- (BOOL)containerShadow {
    return self.containerView.containerShadow;
}



- (void)setContainerBottomButtonToMoveTop:(BOOL)containerBottomButtonToMoveTop {
    self.containerView.containerBottomButtonToMoveTop = containerBottomButtonToMoveTop;
}

- (BOOL)containerBottomButtonToMoveTop {
    return self.containerView.containerBottomButtonToMoveTop;
}


- (void)setContainerShadowView:(BOOL)value {
    _shadowButton.hidden = (!value);
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

- (void)setContainerStyle:(ContainerStyle)containerStyle {
    [self.containerView changeBlurStyle:containerStyle];
}

- (ContainerStyle)containerStyle {
    return self.containerView.containerStyle;
}


- (void)setChangeCornerRadius:(CGFloat)changeCornerRadius {
    self.containerView.containerCornerRadius = changeCornerRadius;
}

- (CGFloat)containerCornerRadius {
    return self.containerView.containerCornerRadius;
}



#pragma mark - Container Set/Get Top/Middle/Bottom position



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



#pragma mark - Container Move

- (ContainerMoveType)containerPosition {
    return self.containerView.containerPosition;
}

- (void)containerMove:(ContainerMoveType)moveType {
    [self.containerView containerMove:moveType];
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









#pragma mark - Change ShadowLevel

- (void)changeScalesImageAndShadowLevel:(CGFloat)containerFrameY {
    [self.view endEditing:YES];
    
    CGFloat selfCenter = self.containerView.containerMiddle;
    
    
    if(containerFrameY < selfCenter) {
        
        CGFloat procent = (((selfCenter -containerFrameY) / selfCenter) / 2);
        
        CGAffineTransform transform = CGAffineTransformMakeScale( 1. -(procent / 5), 1. -(procent / 5));
        
        if(self.containerZoom) {
            self.bottomView.transform = transform;
            self.bottomView.layer.cornerRadius = (procent * 24);
        } else {
            self.bottomView.transform = CGAffineTransformIdentity;
            self.bottomView.layer.cornerRadius = 0;
        }
        
        self.shadowButton.alpha = procent;
        self.shadowButton.height = (containerFrameY +self.containerView.containerCornerRadius +5);
        
    } else {
        self.bottomView.transform = CGAffineTransformIdentity;
        self.bottomView.layer.cornerRadius = 0;
        
//        self.shadowButton.hidden = YES;
        
        self.shadowButton.alpha = 0.; 
        self.shadowButton.height = SCREEN_HEIGHT;
    }
}




#pragma mark - Scroll Delegate

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
    
    
    CGFloat top = self.containerView.containerTop;
    top += (IS_IPHONE_X ? 24 :0);
    
    
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
