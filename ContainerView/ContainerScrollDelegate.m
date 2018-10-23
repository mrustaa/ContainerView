
//  Created by Rustam Motygullin on 11.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "ContainerScrollDelegate.h"

@implementation ContainerScrollDelegate {
    BOOL bordersRunContainer;
    BOOL bordersRunContainerFirstAnimate;
    BOOL onceEnded;
    BOOL onceScrollingBeginDragging;
    CGFloat startScrollPosition;
    CGAffineTransform selfTransform;
}



#pragma mark - Scroll Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [selfWindow endEditing:YES];

    CGFloat velocityInViewY    = [scrollView.panGestureRecognizer velocityInView:   selfWindow].y;
    CGFloat translationInViewY = [scrollView.panGestureRecognizer translationInView:selfWindow].y;
    
    if((scrollView.panGestureRecognizer.state) && (scrollView.contentOffset.y <= 0)) {
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentOffset = (CGPoint){ scrollView.contentOffset.x, 0 };
    } else {
        scrollView.showsVerticalScrollIndicator = YES;
    }
    
    
    if( (scrollView.contentOffset.y == 0) && (0 < velocityInViewY )) {
        bordersRunContainer =1;
    } else{
        bordersRunContainer =0;
    }
    
    
    self->selfTransform = self.containerView.transform;
    
    NSInteger _containerTop = (self.containerTop == 0) ? 60 : self.containerTop;
    if(NAV_ADDED) {
        if(((UINavigationController *)ROOT_VC).navigationBarHidden == NO) _containerTop = (_containerTop + 64);
    }
    
    NSInteger yPosition = ((selfFrame.size.height == iphoneX) ? ( _containerTop +24) : _containerTop );
    
    if(scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) onceScrollingBeginDragging = NO;
    
    if (bordersRunContainer == 1) {
        onceEnded = 0;
        onceScrollingBeginDragging = NO;
        
        self->selfTransform = self.containerView.transform;
        self->selfTransform.ty = (yPosition + translationInViewY - startScrollPosition);
        
        if (selfTransform.ty < yPosition) self->selfTransform.ty = yPosition;
        
        if(bordersRunContainerFirstAnimate == 1)
        {
            animationsSpring(.225,^(void) {
                self.containerView.transform = self->selfTransform ;
            });
            
            bordersRunContainerFirstAnimate = 0;
            
        } else {
            self.containerView.transform = self->selfTransform ;
        }
    }
    else
    {
        if((yPosition == self->selfTransform.ty) && !onceScrollingBeginDragging) {
            onceScrollingBeginDragging = YES;
            
            CGFloat height = ((selfFrame.size.height -defaultHeaderHeight)
                              - ((self.containerTop == 0) ? defaultFrameY : self.containerTop) );
            
            if(scrollView.frame.size.height != height) {
                CGRect scrollFrame = (CGRect)
                {
                    defaultHeaderOrigin,
                    {
                        selfFrame.size.width,
                        height
                    }
                };
                animationsSpring(.45,^(void){
                    scrollView.frame = scrollFrame;
                });
                
            }
        }
        
        if(yPosition < self->selfTransform.ty)
        {
            if (velocityInViewY < 0. )
            {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0 );
                
                self->selfTransform = self.containerView.transform;
                self->selfTransform.ty = (yPosition + translationInViewY - startScrollPosition);
                
                if( self->selfTransform.ty < yPosition ) self->selfTransform.ty = yPosition;
                
                self.containerView.transform = self->selfTransform;
            }
        }

    }
    
    if(self.blockTransform) self.blockTransform( self->selfTransform.ty );
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    bordersRunContainerFirstAnimate = 1;
    
    startScrollPosition = scrollView.contentOffset.y;
    if(startScrollPosition < 0) {
        startScrollPosition = 0;
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat velocityInViewY = [scrollView.panGestureRecognizer velocityInView:selfWindow].y;
    
    if(!self.containerView) return;
    
    if(!onceEnded)
    {
        onceEnded = 1;
        
        if(self.containerMove3position)
        {
            if( self.containerView.transform.ty < ((selfFrame.size.height * 64) / 100) )
            {
                if(velocityInViewY < 0) {
                    [self.containerView containerMove:ContainerMoveTypeTop];
                } else {
                    if( 2500 < velocityInViewY) {
                        [self.containerView containerMove:ContainerMoveTypeBottom];
                    } else {
                        [self.containerView containerMove:ContainerMoveTypeMiddle];
                    }
                }
            } else {
                if(velocityInViewY < 0) {
                    if( velocityInViewY < -2000 ) {
                        [self.containerView containerMove:ContainerMoveTypeTop];
                    } else {
                        [self.containerView containerMove:ContainerMoveTypeMiddle];
                    }
                } else {
                    [self.containerView containerMove:ContainerMoveTypeBottom];
                }
            }
        }
        else
        {
            if(velocityInViewY < 0) {
                [self.containerView containerMove:ContainerMoveTypeTop];
            } else {
                [self.containerView containerMove:ContainerMoveTypeBottom];
            }
        }
    }
}


@end
