
//  Created by Rustam Motygullin on 11.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import "ContainerScrollDelegate.h"

@implementation ContainerScrollDelegate {
    BOOL bordersRunContainer;                   /// скролл дошел до края - и тянет контейнер вниз 👇
    
    BOOL onceEnded;                             /// отпустил скролл - разрешает запуск анимации который вернет в исходную точку
    BOOL bottomDeceleratingDisable;
    
    BOOL onceScrollingBeginDragging;            /// есть 3 варианта когда он (NO) 1) при старте 2) когда отпустил скролл 3) скролл дошел до края
    
    BOOL scrollBegin;                           /// скроллинг начался
    CGFloat startScrollPosition;                /// begin стартовая позиция скролла
    
    CGAffineTransform selfTransform;            /// трансформ контейнера
}



#pragma mark - Scroll Delegate



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if(scrollView.decelerating) bottomDeceleratingDisable = NO;
    
    // сила движения
    CGFloat velocityInViewY    = [scrollView.panGestureRecognizer velocityInView:   WINDOW].y;
    
    // расстояние от нажатой точки
    CGFloat translationInViewY = [scrollView.panGestureRecognizer translationInView:WINDOW].y;
    
    
    
    // скролл дошел до края - и тянет контейнер вниз 👇
        // off индикатор
        // закрепить скролл на 1 месте - на стартовом
    if((scrollView.panGestureRecognizer.state) && (scrollView.contentOffset.y <= 0)) {
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.contentOffset = CGPointMake( scrollView.contentOffset.x, 0 );
    } else {
        // on индикатор
        scrollView.showsVerticalScrollIndicator = YES;
    }
    
    
    // скролл дошел до края - и тянет контейнер вниз 👇
    bordersRunContainer = ( (scrollView.contentOffset.y == 0) && (0 < velocityInViewY)); // сила движения

    
    // текущий транформ контейнера
    // тожи плоха что контейнер здесь
    selfTransform = self.containerView.transform;
    
    

    // если стоит навигатор + 64 к top
//    if(NAV_ADDED) {
//        UINavigationController *nvc = (UINavigationController *)ROOT_VC;
//        if(!nvc.navigationBarHidden) {
//            top = (top + nvc.navigationBar.height);
//        }
//    }
    
    CGFloat top     = self.containerView.containerTop;
    CGFloat bottom  = self.containerView.containerBottom;
    CGFloat middle  = self.containerView.containerMiddle;
    
    top    += (IS_IPHONE_X ? (24) : 0);
    bottom -= (IS_IPHONE_X ? (34) :0);
    
    CGFloat calculation;
    
    if((self.containerView.containerPosition == ContainerMoveTypeBottom) ||
       (self.containerView.containerPosition == ContainerMoveTypeMiddle)) {
        onceEnded = NO;
        bottomDeceleratingDisable = YES;
    }
    
    if(self.containerView.containerPosition == ContainerMoveTypeBottom) {
        calculation = bottom;
    } else if(self.containerView.containerPosition == ContainerMoveTypeMiddle) {
        calculation = middle;
    } else {
        calculation = top;
    }
    
    
    // если закончил скролл - и отпустил
    if(scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded)
        onceScrollingBeginDragging = NO; // есть 3 варианта когда он (NO) 1) при старте 2) когда отпустил скролл 3) скролл дошел до края
    
    // скролл дошел до края - и тянет контейнер вниз 👇
    if(bordersRunContainer) {
        
        onceEnded = NO;
        onceScrollingBeginDragging = NO; // есть 3 варианта когда он (NO) 1) при старте 2) когда отпустил скролл 3) скролл дошел до края
        
        // (топ - стартовая позиция скролла) + расстояние от нажатой точки
        selfTransform.ty = ((calculation -startScrollPosition) +translationInViewY );
        
        // если трансформ меньше топа - то трансформ равен топу
        if(selfTransform.ty < top) selfTransform.ty = top;
        
        /*
         
        ааа
        это для того что - если ты разгонишь скролл до края
        и оставишь след
        то при повторном нажатии - анимированно возвращался в исходное положение - уничтожая след
        
        но эта какая то дичь - не понятно как он работает ващи - потому что неправильно
         тут
         scrollBegin - один раз устанвливается каждый раз при начальном скролле
        и заходит он сюда каждый раз - когда дошел до края - и тяняш контейнер вниз
         
         - но это не означает что след существует
         - вообще не какой проверки на существование следа
         
         */
        if(scrollBegin)
        {
            ANIMATION_SPRING(.325, ^(void) {
                self.containerView.transform = self->selfTransform;
            });
            
            scrollBegin = NO;
            
        } else {
            self.containerView.transform = selfTransform;
        }
        
        PRINT(@" 👇 %f ",self.containerView.transform.ty);
    }
    // скроллинг вверх вниз - без прикосновения к краю 👆👇
    else
    {
        // это условие признано менять размеры скролл вью
        // есть 3 варианта когда он (NO) 1) при старте 2) когда отпустил скролл 3) скролл дошел до края - и только на 1 раз
        if((top == selfTransform.ty) && !onceScrollingBeginDragging) {
            onceScrollingBeginDragging = YES;
            
            CGFloat headerHeight = (self.containerView.headerView) ?self.containerView.headerView.height :0;
            CGFloat top = (self.containerView.containerTop == 0) ? CUSTOM_TOP : self.containerView.containerTop;
            CGFloat iphnX = (IS_IPHONE_X ? 24 :0);
            
            CGFloat height = (SCREEN_HEIGHT -(top +headerHeight +iphnX ));
            
            if(scrollView.height != height) {
                
                ANIMATION_SPRING( .45, ^(void) {
                    scrollView.y = headerHeight;
                    scrollView.height = height;
                });
            }
        }
        

        if(top < selfTransform.ty) /// позиция контейнера - выше топа
        {
            if (velocityInViewY < 0. ) /// палиц движется вверх
            {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0 );
                
                selfTransform = self.containerView.transform;
                selfTransform.ty = (calculation +translationInViewY ); /// здесь расстояние от нажатой точки  складывается с + топом
                
                if(selfTransform.ty < top) selfTransform.ty = top;
                
                self.containerView.transform = selfTransform;
            }
        }
        
        PRINT(@" 🔥 top %f | self %f ",top,self.containerView.transform.ty);
    }
    
    if(self.blockTransform) self.blockTransform(selfTransform.ty);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    PRINT(@" ✅ ");
    if(bottomDeceleratingDisable) {
        [scrollView setContentOffset:scrollView.contentOffset animated:YES];
        bottomDeceleratingDisable = NO;
    }
    
}

/// скроллинг начался
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    scrollBegin = YES;
    
    startScrollPosition = scrollView.contentOffset.y;
    if(startScrollPosition < 0) startScrollPosition = 0;
}

/// скроллинг закончился
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGFloat velocityInViewY = [scrollView.panGestureRecognizer velocityInView:WINDOW].y;
    
    PRINT(@" ⚠️ ");
    
    if(!self.containerView) return;
    
    if(!onceEnded)
    {
        onceEnded = YES;
        [self.containerView containerMoveForVelocityInView:velocityInViewY];
    }
}


@end
