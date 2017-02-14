//
//  AmazedView.m
//  StudyCoreGraphics
//
//  Created by wangyuehong on 2017/2/14.
//  Copyright © 2017年 Oradt. All rights reserved.
//

#import "AmazedView.h"

#define DEGREES_TO_RADIANS(degrees)  ((M_PI * degrees)/ 180)

@implementation AmazedView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat colors[] = {
        0,0,1, 0.05,
        0,0,1, 0.05,
        0,0,1, 0.07,
        1,0,0, 0.07,
        1,0,0, 0.05,
        1,0,0, 0.05};
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));//形成梯形，渐变的效果
    CGColorSpaceRelease(rgb);

    //big circle radius
    float bRadius = self.frame.size.width * 0.5;

    //middle circle radius
    float mRadius = self.frame.size.width * 0.416666667;

    //little circle radius
    float lRadius = self.frame.size.width * 0.277777778;

    float process = 0.25;
    float offset1 = 0.16;
    float offset2 = 0.09;
    float lOffset = bRadius - lRadius;
    float mOffset = bRadius - mRadius;
    for (int i = 0; i < 5; i ++) {
        CGContextSaveGState(context);
        float offsetAngle = i * 0.1;
        CGPoint p1 = [self pointInCircle:bRadius withAngle:[self fixAngle:offset1 + offsetAngle ]];
        CGPoint p2 = [self pointInCircle:bRadius withAngle:[self fixAngle:process + offset2 + offsetAngle]];
        CGPoint p3 = [self pointInCircle:bRadius withAngle:[self fixAngle:process * 2 + offset1 + offsetAngle]];
        CGPoint p4 = [self pointInCircle:bRadius withAngle:[self fixAngle:process * 3 + offset2 + offsetAngle]];

        CGPoint lp1 = [self pointInCircle:lRadius withAngle:[self fixAngle:0 + offsetAngle]];
        CGPoint lp2 = [self pointInCircle:lRadius withAngle:[self fixAngle:0.5 + offsetAngle]];
        CGPoint mp1 = [self pointInCircle:mRadius withAngle:[self fixAngle:0.25 + offsetAngle]];
        CGPoint mp2 = [self pointInCircle:mRadius withAngle:[self fixAngle:0.75 + offsetAngle]];

        CGContextMoveToPoint(context, lp1.x + lOffset, lp1.y + lOffset);
        CGContextAddCurveToPoint(context, lp1.x + lOffset, lp1.y + lOffset, p1.x, p1.y, mp1.x + mOffset, mp1.y + mOffset);
        CGContextAddCurveToPoint(context, mp1.x + mOffset, mp1.y + mOffset, p2.x, p2.y, lp2.x + lOffset, lp2.y + lOffset);
        CGContextAddCurveToPoint(context, lp2.x + lOffset, lp2.y + lOffset, p3.x, p3.y, mp2.x + mOffset, mp2.y + mOffset);
        CGContextAddCurveToPoint(context, mp2.x + mOffset, mp2.y + mOffset, p4.x, p4.y, lp1.x + lOffset, lp1.y + lOffset);
        CGContextClosePath(context);
        CGContextClip(context);

        float halfHeight = self.frame.size.height * 0.5;
        CGContextDrawLinearGradient(context, gradient,
                                    CGPointMake(0,halfHeight) ,CGPointMake(self.frame.size.width,halfHeight),
                                    kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(context);
    }
}

- (float)fixAngle:(float)angle {
    int tmp = angle;
    return angle > 1 ? angle - tmp : angle;
}
//更新小点的位置
- (CGPoint)pointInCircle:(float)radius withAngle:(float)ang {
    CGFloat angle = M_PI * 2.0 * ang;//将进度转换成弧度
    angle += self.offset;
    if (angle > M_PI*2.0) {
        angle -= M_PI*2.0;
    }
    int index = angle / M_PI_2;//用户区分在第几象限内
    float needAngle = angle - index * M_PI_2;//用于计算正弦/余弦的角度
    float x = 0;
    float y = 0;
    switch (index) {
        case 0: {
            //NSLog(@"第一象限");
            x = radius + sinf(needAngle)*radius;
            y = radius - cosf(needAngle)*radius;
            break;
        }
        case 1: {
            //NSLog(@"第二象限");
            x = radius + cosf(needAngle)*radius;
            y = radius + sinf(needAngle)*radius;
            break;
        }
        case 2: {
            //NSLog(@"第三象限");
            x = radius - sinf(needAngle)*radius;
            y = radius + cosf(needAngle)*radius;
            break;
        }
        case 3: {
            //NSLog(@"第四象限");
            x = radius - cosf(needAngle)*radius;
            y = radius - sinf(needAngle)*radius;
            break;
        }
        default:
            break;
    }
    return  CGPointMake(x, y);
}

@end
