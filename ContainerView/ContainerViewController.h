
//  Created by Рустам Мотыгуллин on 17.08.2018.
//  Copyright © 2018 GetTransfer. All rights reserved.

#import <UIKit/UIKit.h>
#import "ContainerView.h"

@class ContainerScrollDelegate;

@interface ContainerViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) ContainerView *containerView;
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIButton *shadowButton;

@property (strong, nonatomic) UIView *containerHeaderView;

@property (nonatomic, readonly) ContainerMoveType containerPosition;
@property (nonatomic) ContainerStyle containerStyle;



@property (nonatomic) BOOL containerAllowMiddlePosition;

/**
 @brief Долбавлять кнопку, при перемещении вниз, для перемещения вверх по тапу
 */
@property (nonatomic) BOOL containerBottomButtonToMoveTop;

/**
 @brief Добавить тень под контейнером
 */
@property (nonatomic) BOOL containerShadowView;

/**
 @brief Добавить тень под контейнером
 */
@property (nonatomic) BOOL containerZoom;

/**
 @brief Назначить максимальную высоту при перемещении наверх
 */
@property (nonatomic) CGFloat containerTop;

/**
 @brief Назначить максимальную высоту при перемещении в среднее положение
 */
@property (nonatomic) CGFloat containerMiddle;

/**
 @brief Назначить максимальную высоту при перемещении вниз
 */
@property (nonatomic) CGFloat containerBottom;




@property (strong, nonatomic) void(^blockChangeContainerMove)(ContainerMoveType containerMove);


- (void)changeScalesImageAndShadowLevel:(CGFloat)containerFrameY;

- (void)containerMove:(ContainerMoveType)containerMove;
- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated;
- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion;

- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType;
- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated;
- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion;

@end
