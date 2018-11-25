
//  Created by Rustam Motygullin on 08.07.2018.
//  Copyright © 2018 mrusta. All rights reserved.

#import <UIKit/UIKit.h>
#import "ContainerTypes.h"
#import "ContainerDefines.h"


@protocol ContainerViewDelegate <NSObject>
@optional
- (void)changeContainerMove:(ContainerMoveType)containerMove containerY:(CGFloat)containerY animated:(BOOL)animated;
@end



@interface ContainerView : UIView

@property (nonatomic, weak) id<ContainerViewDelegate> delegate;



@property (nonatomic) BOOL portrait;

@property (nonatomic) BOOL firstAddedTop;
@property (nonatomic) BOOL firstAddedMiddle;
@property (nonatomic) BOOL firstAddedBottom;

- (CGFloat)getContainerBottom;
- (CGFloat)getContainerMiddle;

/**
 @brief This view sets a custom header for the container.
 */
@property (strong, nonatomic) UIView *headerView;

/**
 @brief This option indicates whether to add a button when the container is at the bottom to animate the container upwards.
 */
@property (nonatomic) BOOL containerBottomButtonToMoveTop;

/**
 @brief When moving the container, by default there are 2 positions (this is moving up and down). This parameter adds 3 position (move to the middle)
 */
@property (nonatomic) BOOL containerAllowMiddlePosition;

/**
 @brief This parameter sets the shadow for the container.
 */
@property (nonatomic) BOOL containerShadow;


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
@brief This method for changing the rounding radius
*/
@property (nonatomic) CGFloat containerCornerRadius;



/**
 @brief This parameter indicates which type of move was last.
 */
@property (nonatomic) ContainerMoveType containerPosition;

/**
 @brief This parameter indicates which container style
 */
@property (nonatomic) ContainerStyle containerStyle;


/**
 @brief This method to add a blur to the background of the container.
  
 @param styleType There are 3 types of blur. Blur with hues of
    1) black,
    2) white,
    3) white with low blur concentrations.
    4) The last attribute turns off the blur, for a normal change of the background color.
 */
- (void)changeBlurStyle:(ContainerStyle)styleType;

- (void)transitionToSizeTop:(CGFloat)top middle:(CGFloat)middle bottom:(CGFloat)bottom size:(CGSize)size;

- (void)containerMoveForVelocityInView:(CGFloat)velocityInViewY;

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
