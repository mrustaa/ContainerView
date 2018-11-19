
//  Created by Rustam Motygullin on 08.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <UIKit/UIKit.h>
#import "ContainerTypes.h"

@interface ContainerView : UIView

@property (strong, nonatomic) UIView *headerView;

/**
 @brief Этот параментр указывает, следует ли добавить кнопку, когда контейнер находится внизу, для анимированного раскрытия контейнера вверх.
 */
@property BOOL containerBottomButtonToMoveTop;

/**
 @brief Этот параментр устанавливает новое значение позиции, для типа перемещения вверх.
 */
@property CGFloat containerTop;

/**
 @brief Этот параментр устанавливает новое значение позиции, для типа перемещения вниз.
 */
@property CGFloat containerBottom;

/**
 @brief Этот параментр устанавливает новое значение позиции, для типа перемещения в среднее положение.
 */
@property CGFloat containerMiddle;

/**
 @brief Этот параментр указывает, какой из типов перемещения был последним.
 */
@property ContainerMoveType containerPosition;
@property ContainerStyle containerStyle;

/**
 @brief Этот метод для добавления размытия фона для контейнера
 
 @param styleType Существует 3 типа размытия. Размытие с оттенками 1) черного, 2) белого, 3) белого со слабой концентраций размытия. 4) Последний атрибут отключает размытие, для обычного изменения цвета фона
 */
- (void)changeBlurStyle:(ContainerStyle)styleType;

- (void)containerMoveForVelocityInView:(CGFloat)velocityInViewY;

/**
 @brief Этот метод для анимированного перемещения контейнера, по фиксированным позициям
 
 @param moveType Существует 4 типа перемещения. Перемещение 1) наверх, 2) середину, 3) вниз, 4) скрытие в самый вниз за пределы видимости
 */
- (void)containerMove:(ContainerMoveType)moveType;
- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated;
- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 @brief Этот метод для анимированного перемещения контейнера, по пользовательской позиции
 
 @param position Пользовательская позиция
 */
- (void)containerMoveCustomPosition:(NSInteger)position moveType:(ContainerMoveType)moveType;
- (void)containerMoveCustomPosition:(NSInteger)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated;
- (void)containerMoveCustomPosition:(NSInteger)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 @brief Этот метод для изменения радиуса округления границ
 
 @param newValue присвоение нового значения
 */
- (void)changeCornerRadius:(CGFloat)newValue;

- (void)removeScrollView;

@property NSInteger containerCornerRadius;

/**
 @brief При перемещении контейнера, по умолчанию существуют 2 позиции (это перемещение вверх, и вниз). Этот параментр добавляет 3 позицию (перемещение в середину)
 */
@property BOOL containerAllowMiddlePosition;

@property BOOL containerShadow;

@property (strong, nonatomic) void(^blockChangeShadowLevel)(ContainerMoveType containerMove, CGFloat scale, BOOL animation);

- (void)panGestureRecognized:(UIPanGestureRecognizer *)recognizer;

@end
