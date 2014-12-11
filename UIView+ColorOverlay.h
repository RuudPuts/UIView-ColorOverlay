//
//  UIView+ColorOverlay.h
//  ThemeModes
//
//  Created by Ruud Puts on 11/12/14.
//  Copyright (c) 2014 Ruud Puts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ColorOverlay)

@property (nonatomic, strong) CALayer *colorOverlay;

/**
 *  Adds the color overlay ontop of the complete view
 *
 *  @param color    The color of the overlay
 *  @param opacity  The opacity of the overlay (0 - 1)
 *  @param animated YES when animated, NO otherwise
 */
- (void)addOverlayWithColor:(UIColor *)color andOpacity:(CGFloat)opacity animated:(BOOL)animated;

/**
 *  Removes a previously added color overlay
 *
 *  @param animated YES when animated, NO otherwise
 */
- (void)removeColorOverlay:(BOOL)animated;

@end
