//
//  UIView+CODrawing.m
//  mzl_mobile_ios
//
//  Created by Whitman on 14-9-4.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "UIView+CODrawing.h"

@implementation UIView (CODrawing)

- (void)co_drawLeftArcWithFillColor:(UIColor *)fillColor {
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *rectPathWithLeftArc =
    [UIBezierPath bezierPathWithArcCenter:self.center
                                   radius:self.bounds.size.width / 2.0
                               startAngle:M_PI / 2.0
                                 endAngle:M_PI * 3.0 / 2.0
                                clockwise:YES];
    // to right top
    [rectPathWithLeftArc addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
    // to right bottom
    [rectPathWithLeftArc addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    [rectPathWithLeftArc closePath];
    layer.fillColor = [fillColor CGColor];
    layer.lineCap = kCALineCapRound;
    layer.path = rectPathWithLeftArc.CGPath;    
    [self.layer addSublayer:layer];
}

@end
