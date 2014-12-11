//
//  UIView+ColorOverlay.m
//  ThemeModes
//
//  Created by Ruud Puts on 11/12/14.
//  Copyright (c) 2014 Ruud Puts. All rights reserved.
//

#import "UIView+ColorOverlay.h"
#import <objc/runtime.h>

static void * ColorOverlayKey = &ColorOverlayKey;
static CGFloat const kAnimationDuration = 0.3;

@implementation UIView (ColorOverlay)

#pragma mark - Public methods

- (void)addOverlayWithColor:(UIColor *)color andOpacity:(CGFloat)opacity animated:(BOOL)animated {
    if (self.colorOverlay) {
        [self updateOverlayWithColor:color andOpacity:opacity animated:animated];
    }
    else {
        [self createOverlayWithColor:color andOpacity:opacity animated:animated];
    }
}

- (void)removeColorOverlay:(BOOL)animated {
    CGFloat waitTime = 0;
    if (animated) {
        [self.colorOverlay addAnimation:[self opacityAnimation:0] forKey:@"opacity"];
        waitTime = kAnimationDuration;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.colorOverlay removeFromSuperlayer];
        self.colorOverlay = nil;
    });
}

#pragma mark - Private methods

- (void)createOverlayWithColor:(UIColor *)color andOpacity:(CGFloat)opacity animated:(BOOL)animated {
    self.colorOverlay = [[CALayer alloc] init];
    self.colorOverlay.frame = self.bounds;
    self.colorOverlay.backgroundColor = color.CGColor;
    self.colorOverlay.opacity = animated ? 0 : opacity;
    [self.layer addSublayer:self.colorOverlay];
    
    if (animated) {
        [self.colorOverlay addAnimation:[self opacityAnimation:opacity] forKey:@"opacity"];
    }
}

- (void)updateOverlayWithColor:(UIColor *)color andOpacity:(CGFloat)opacity animated:(BOOL)animated {
    if (animated) {
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.animations = @[[self opacityAnimation:opacity], [self colorAnimation:color]];
        animationGroup.duration = kAnimationDuration;
        [self.colorOverlay addAnimation:animationGroup forKey:@"opacity and color"];
    }
    else {
        self.colorOverlay.backgroundColor = color.CGColor;
        self.colorOverlay.opacity = opacity;
    }
}

- (CABasicAnimation *)opacityAnimation:(CGFloat)newOpacity {
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(self.colorOverlay.opacity);
    opacityAnimation.toValue = @(newOpacity);
    opacityAnimation.duration = kAnimationDuration;
    self.colorOverlay.opacity = newOpacity;
    return opacityAnimation;
}

- (CABasicAnimation *)colorAnimation:(UIColor *)newColor {
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    colorAnimation.fromValue = (id)self.colorOverlay.backgroundColor;
    colorAnimation.toValue = (id)newColor.CGColor;
    colorAnimation.duration = kAnimationDuration;
    self.colorOverlay.backgroundColor = newColor.CGColor;
    return colorAnimation;
}

- (CALayer *)colorOverlay {
    return objc_getAssociatedObject(self, ColorOverlayKey);
}

- (void)setColorOverlay:(CALayer *)colorOverlay {
    objc_setAssociatedObject(self, ColorOverlayKey, colorOverlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
