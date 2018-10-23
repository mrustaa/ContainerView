
//  Created by Rustam Motygullin on 08.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <UIKit/UIKit.h>
#import "ContainerTypes.h"

@interface ContainerView : UIView

/**
 @brief Этот метод для изменения стиля заголовка контейнера
 
 @param titleType Существует 2 типа заголовка, 1) обычный текст, 2) поиск. 3) Последний атрибут полностью скрывает заголовок
 */
- (void)changeTitleType:(ContainerTitleType)titleType;

/**
 @brief Этот метод для добавления размытия фона для контейнера
 
 @param styleType Существует 3 типа размытия. Размытие с оттенками 1) черного, 2) белого, 3) белого со слабой концентраций размытия. 4) Последний атрибут отключает размытие, для обычного изменения цвета фона
 */
- (void)changeBlurStyle:(ContainerStyle)styleType;

/**
 @brief Этот метод для анимированного перемещения контейнера
 
 @param containerMove Существует 4 типа перемещения. Перемещение 1) наверх, 2) середину, 3) вниз, 4) скрытие в самый вниз за пределы видимости
 */
- (void)containerMove:(ContainerMoveType)containerMove;

/**
 @brief Этот метод для добавления отступа, для одного из типов перемещения контейнера. При перемещении вверх, отступ сверху вниз. При перемещении вниз, отступ снизу вверх
 
 @param newValue присвоение нового значения
 */
- (void)changePositionMoveType:(ContainerMoveType)moveType newValue:(NSInteger)newValue;

/**
 @brief Этот метод для изменения радиуса округления границ
 
 @param newValue присвоение нового значения
 */
- (void)changeCornerRadius:(CGFloat)newValue;

/**
 @brief При перемещении контейнера, по умолчанию существуют 2 позиции (это перемещение вверх, и вниз). Этот параментр добавляет 3 позицию (перемещение в середину)
 */
@property BOOL containerMove3position;

@property (strong, nonatomic) void(^blockScalingBackBackgroundView)(ContainerMoveType containerMove, CGFloat scale, BOOL animation);

@end
