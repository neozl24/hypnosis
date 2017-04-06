//
//  HypnosisView.m
//  Hypnosis
//
//  Created by 钟立 on 16/10/18.
//  Copyright © 2016年 钟立. All rights reserved.
//

#import "HypnosisView.h"

#define SPACING 50
#define SPEED 4

@interface HypnosisView () {
    CGFloat offsetDistance;
    int incrementRed;
    int incrementGreen;
    int incrementBlue;
}

@property (nonatomic) UIColor* circleColor;

@end

@implementation HypnosisView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        self.circleColor = [UIColor lightGrayColor];
        
        incrementRed = incrementGreen = incrementBlue = 1;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width/2;
    center.y = bounds.origin.y + bounds.size.height/2;
    
    CGFloat maxRadius = hypot(bounds.size.width, bounds.size.height) / 2;
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    
    for (CGFloat currentRadius = maxRadius + offsetDistance; currentRadius > 0; currentRadius -= SPACING) {
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];

        //下面这行，在一秒钟多次执行的情况下，占据了绝大部分的CPU资源！
        [path addArcWithCenter:center
                        radius:currentRadius
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    path.lineWidth = SPACING / 2;
    
    [_circleColor setStroke];
    [path stroke];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGFloat red = arc4random_uniform(100) / 100.0;
    CGFloat green = arc4random_uniform(100) / 100.0;
    CGFloat blue = arc4random_uniform(100) / 100.0;
    
    UIColor* randomColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];

    _circleColor = randomColor;
    
    [self setNeedsDisplay];
}

- (void)updateDisplayWithTime:(NSTimeInterval)time {
    self.hidden = NO;
    int seconds = (int)time;
    int count = seconds / SPACING;
    offsetDistance = (time - (CGFloat)(SPACING * count)) * SPEED;

    const CGFloat *components = CGColorGetComponents(_circleColor.CGColor);
    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];

    [self setColor:&red byIncrement:&incrementRed];
    [self setColor:&green byIncrement:&incrementGreen];
    [self setColor:&blue byIncrement:&incrementBlue];

    _circleColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];

    [self setNeedsDisplay];
}

- (void)setColor:(CGFloat *)colorPtr byIncrement:(int *)incrementPtr {
    *colorPtr += arc4random_uniform(4) / 500.0 * (*incrementPtr);
    if (*colorPtr > 1) {
        *colorPtr = 1;
        *incrementPtr = -1;
    } else if (*colorPtr < 0) {
        *colorPtr = 0;
        *incrementPtr = 1;
    }
}

@end












