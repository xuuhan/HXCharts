//
//  HXCircleChart.m
//  移动运维
//
//  Created by 韩旭 on 2017/8/18.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import "HXGaugeChart.h"

@interface HXGaugeChart()

@property (nonatomic, strong) UILabel *valueLabel;

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, assign) CGFloat maxValue;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat halfWidth;

@property (nonatomic, assign) CGPoint viewCenter;

@property (nonatomic, strong) CAGradientLayer *colorLayer;

@property (nonatomic, strong) NSMutableArray *markLabelArray;

@property (nonatomic, strong) CAShapeLayer *outerCircleLayer;

@property (nonatomic, strong) CAShapeLayer *insideCircleLayer;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation HXGaugeChart

- (instancetype)initWithFrame:(CGRect)frame withMaxValue:(CGFloat)maxValue value:(CGFloat)value{
    
    self =  [super initWithFrame:frame];
    
    if (self) {
        NSLog(@"%f---%f",maxValue,value);
        
        if (maxValue < value) {
            maxValue = value;
        }
        
        
        _value = value;
        _maxValue = maxValue;

        [self drawArc];
    }
    return self;
}

-(void)drawArc
{
    
    NSLog(@"%f",_value / _maxValue);

    _width = self.frame.size.width;
    
    ///计算中心点
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    _viewCenter = center;
    ///外圆
    CGFloat radius = self.frame.size.width * 0.5 - 15;
    _radius = radius;
    UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    _outerCircleLayer = shapelayer;
    shapelayer.lineWidth = 3.0;
    shapelayer.strokeColor = [UIColor colorWithRed:51.0/255.0 green:55.0/255.0 blue:60.0/255.0 alpha:1].CGColor;
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.path = arcPath.CGPath;
   
    [self.layer addSublayer:shapelayer];
    
    ///内圆
    CGFloat insideRadius = radius - 20;
   
    UIBezierPath *insideArcPath = [UIBezierPath bezierPathWithArcCenter:center radius:insideRadius startAngle:M_PI endAngle:M_PI * (1 + (M_PI * 2 * (_value / _maxValue)) / (M_PI * 2)) clockwise:YES];

    CAShapeLayer *insideShapelayer = [CAShapeLayer layer];
    _insideCircleLayer = insideShapelayer;
    insideShapelayer.lineWidth = 20.0;
    _halfWidth = insideShapelayer.lineWidth /2;
    insideShapelayer.strokeColor = [UIColor clearColor].CGColor;
    insideShapelayer.fillColor = [UIColor clearColor].CGColor;
    insideShapelayer.path = insideArcPath.CGPath;
    
    [self.layer addSublayer:insideShapelayer];
    
    ///标注值
    UILabel *valueLabel = [[UILabel alloc] init];
    
    [self addSubview:valueLabel];
    
    self.valueLabel = valueLabel;
    
    valueLabel.frame = CGRectMake(center.x - 50, center.y - 25, 100, 25);
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font = [UIFont systemFontOfSize:20 weight:2];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    _gradientLayer = gradientLayer;
    gradientLayer.frame = self.bounds;
    gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:gradientLayer];
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    self.colorLayer = colorLayer;
    colorLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint = CGPointMake(1, 0);
    [gradientLayer addSublayer:colorLayer];
    
    
    CAShapeLayer *gressLayer = [CAShapeLayer layer];
    gressLayer.lineWidth = 20.0;
    gressLayer.strokeColor = [UIColor blueColor].CGColor;
    gressLayer.fillColor = [UIColor clearColor].CGColor;
    gressLayer.lineCap = @"bevel";
    gressLayer.path = insideArcPath.CGPath;
    gradientLayer.mask = gressLayer;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 1.0;
    [gressLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
}

#pragma mark set

- (void)setColorArray:(NSArray *)colorArray{
    NSMutableArray *array = [NSMutableArray array];
    for (UIColor *color in colorArray) {
        [array addObject:(id)color.CGColor];
    }
    _colorLayer.colors = array.copy;
}

- (void)setLocations:(NSArray *)locations{
    _colorLayer.locations = locations;
}

- (void)setCircleColor:(UIColor *)circleColor{
    _outerCircleLayer.strokeColor = circleColor.CGColor;
}

- (void)setOuterCircleColor:(UIColor *)outerCircleColor{
    _outerCircleLayer.strokeColor = outerCircleColor.CGColor;
}

- (void)setOuterCircleWidth:(CGFloat)outerCircleWidth{
    _outerCircleLayer.lineWidth = outerCircleWidth;
}

- (void)setValueTitle:(NSString *)valueTitle{
    _valueLabel.text = valueTitle;
}

- (void)setValueFont:(UIFont *)valueFont{
    _valueLabel.font = valueFont;
}

-(void)setValueColor:(UIColor *)valueColor{
    _valueLabel.textColor = valueColor;
}

- (void)setMarkTextColor:(UIColor *)markTextColor{
    for (UILabel *label in _markLabelArray) {
        label.textColor = markTextColor;
    }
}

- (void)setMarkTextFont:(UIFont *)markTextFont{
    for (UILabel *label in _markLabelArray) {
        label.font = markTextFont;
    }
}

- (void)setSingleColor:(UIColor *)singleColor{
    _insideCircleLayer.strokeColor = singleColor.CGColor;
    [_gradientLayer removeFromSuperlayer];
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 1.0;
    [_insideCircleLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
}

- (void)setMarkLabelCount:(int)markLabelCount{

    for (int i = 0; i < markLabelCount; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
        [self addSubview:label];
        [self.markLabelArray addObject:label];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;

        
        CGFloat centerX = 0.0;
        CGFloat centerY = 0.0;
        CGFloat half = label.frame.size.width / 2;
        CGFloat radius = _radius + 5 + half;
        CGFloat a = 180 / (markLabelCount - 1) * i;
        centerX = _width / 2 - radius *  cos(a * M_PI / 180);
        centerY = self.frame.size.height / 2  - radius * sin(a * M_PI / 180   );
        label.center = CGPointMake(centerX, centerY);
        
        if (i == 0) {
            label.text = @"0";
        } else if (i == markLabelCount - 1){
            label.text = [NSString stringWithFormat:@"%.0f",_maxValue];
        } else{
            label.text = [NSString stringWithFormat:@"%.0f",_maxValue / (markLabelCount - 1) * i];
        }
    }
}

- (NSMutableArray *)markLabelArray{
    if (!_markLabelArray) {
        _markLabelArray = [NSMutableArray array];
    }
    return _markLabelArray;
}

@end
