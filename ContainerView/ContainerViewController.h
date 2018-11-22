
//  Created by Рустам Мотыгуллин on 17.08.2018.
//  Copyright © 2018 GetTransfer. All rights reserved.

#import <UIKit/UIKit.h>
#import "ContainerView.h"



@interface ContainerViewController : UIViewController <UIScrollViewDelegate, ContainerViewDelegate>


@property (strong, nonatomic) UIView            *bottomView;
@property (strong, nonatomic) UIButton          *shadowButton;
@property (strong, nonatomic) ContainerView     *containerView;

@property (nonatomic, weak) id<ContainerViewDelegate> delegate;


/**
 @brief This view sets a custom header for the container.
 */
@property (strong, nonatomic) UIView *headerView;



/**
 @brief This parameter indicates which type of move was last.
 */
@property (nonatomic, readonly) ContainerMoveType containerPosition;

/**
 @brief This parameter to add a blur to the background of the container.
  
 There are 3 types of blur. Blur with hues of
 1) black,
 2) white,
 3) white with low blur concentrations.
 4) The last attribute turns off the blur, for a normal change of the background color.
 */
@property (nonatomic) ContainerStyle containerStyle;

/**
 @brief This parameter for changing the rounding radius
 */
@property (nonatomic) CGFloat containerCornerRadius;

/**
 @brief When moving the container, by default there are 2 positions (this is moving up and down). This parameter adds 3 position (move to the middle)
 */
@property (nonatomic) BOOL containerAllowMiddlePosition;



/**
 @brief This parameter indicates whether to add a button when the container is at the bottom to animate the container upwards.
 */
@property (nonatomic) BOOL containerBottomButtonToMoveTop;


/**
 @brief This parameter sets the shadow under container
 */
@property (nonatomic) BOOL containerShadowView;

/**
 @brief This parameter sets the shadow in container
 */
@property (nonatomic) BOOL containerShadow;


/**
 @brief This parameter allows you to zoom in on the screen under ContainerView.
 */
@property (nonatomic) BOOL containerZoom;

/**
 @brief This parameter sets the new position value for the up move type.
 */
@property (nonatomic) CGFloat containerTop;

/**
 @brief This parameter sets the new position value for the type of movement to the middle position.
 */
@property (nonatomic) CGFloat containerMiddle;

/**
 @brief This parameter sets the new position value for the type of movement to the middle position.
 */
@property (nonatomic) CGFloat containerBottom;


/**
 @brief This method for animated container movement, at fixed positions
  
 @param moveType There are 4 types of movement. Moving 1) up, 2) middle, 3) down, 4) hiding in the most down beyond the limits of visibility
 */
- (void)containerMove:(ContainerMoveType)moveType;
- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated;
- (void)containerMove:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion;

/**
 @brief This method for animated container movement, by user position.
 
 @param position Custom position
 */
- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType;
- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated;
- (void)containerMoveCustomPosition:(CGFloat)position moveType:(ContainerMoveType)moveType animated:(BOOL)animated completion:(void (^)(void))completion;

@end
