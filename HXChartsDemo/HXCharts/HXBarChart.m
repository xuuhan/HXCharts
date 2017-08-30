//
//  HXBarChart.m
//  移动运维
//
//  Created by 韩旭 on 2017/8/22.
//  Copyright © 2017年 韩旭. All rights reserved.
//

#import "HXBarChart.h"

@interface HXBarChart()
@property (nonatomic, strong) CAShapeLayer *lineLayer;

@property (nonatomic, strong) NSMutableArray *colorLayerArray;
@property (nonatomic, strong) NSMutableArray *markLabelArray;
@property (nonatomic, strong) NSMutableArray *gradientLayerArray;
@property (nonatomic, strong) NSMutableArray *singleColorLayer;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat titleWidth;
@property (nonatomic, assign) CGFloat maxChar;
@property (nonatomic, assign) int maxValue;
@property (nonatomic, assign) int valueLength;
@property (nonatomic, assign) int markLabelCount;
@property (nonatomic, assign) CGFloat barMargin;///柱子间间距

@property (nonatomic,assign) OrientationType type;
@end

@implementation HXBarChart



- (instancetype)initWithFrame:(CGRect)frame withMarkLabelCount:(int)markLabelCount withOrientationType:(OrientationType)type{
    self = [super initWithFrame:frame];
    
    if (self) {
        _markLabelCount = markLabelCount;
        _type = type;
        
        [self drawBar];
    }
    
    return self;
}

- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    
    if (titleArray.count == 0) {
        return;
    }
    
    if (_type == OrientationHorizontal) {
        _titleHeight = (_lineHeight - _barMargin - (titleArray.count - 1) * _barMargin) / titleArray.count;
        _titleWidth = _x - 10;
        
        for (int i = 0; i < titleArray.count; i++) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _barMargin / 2 + i * (_titleHeight + _barMargin), _titleWidth, _titleHeight)];
            [self addSubview:titleLabel];
            [self.markLabelArray addObject:titleLabel];
            titleLabel.textColor = [UIColor whiteColor];
            titleLabel.font = [UIFont systemFontOfSize:12];
            titleLabel.text = titleArray[i];
            titleLabel.textAlignment = NSTextAlignmentRight;
        }
    } else{

        _titleHeight = (_lineHeight - _barMargin - (titleArray.count - 1) * _barMargin) / titleArray.count;
        
        _titleWidth = _lineWidth;
        
        CGFloat labelWidth = _lineWidth / _markLabelCount;
        
        for (int i = 0; i < titleArray.count; i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth + _x, _lineHeight + 5, labelWidth, 15)];
            
            [self addSubview:label];
            [self.markLabelArray addObject:label];
            
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = titleArray[i];
        }
    }
    
}

- (void)setValueArray:(NSArray *)valueArray{
    _valueArray = valueArray;
    
    if (valueArray.count == 0) {
        return;
    }
    
    int maxValueAtArray = [[valueArray valueForKeyPath:@"@max.intValue"] intValue];
    
    if (maxValueAtArray == 0) {
        return;
    }
    
    [self maxValue:maxValueAtArray];
    _maxValue = _maxChar + 1;
    
    for (int i = 0; i < _valueLength - 1; i++) {
        _maxValue = _maxValue * 10;
    }
    
    CGFloat valueHeight = 0;
    CGFloat valueWidth = 0;
    CGFloat labelWidth = 0;
    
    if (_type == OrientationHorizontal) {
        valueHeight = (_lineHeight - _barMargin - (valueArray.count - 1) * _barMargin) / valueArray.count;
        
        valueWidth = _lineWidth;
        
        labelWidth = _lineWidth / _markLabelCount;
        for (int i = 0; i < (_markLabelCount + 1); i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * labelWidth + _x - labelWidth / 2, _lineHeight + 5, labelWidth, 15)];
            
            [self addSubview:label];
            [self.markLabelArray addObject:label];
            
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                label.text = @"0";
            } else if(i == _markLabelCount){
                label.text = [NSString stringWithFormat:@"%d",_maxValue];
            } else{
                if (_maxValue < _markLabelCount) {
                    label.text = [NSString stringWithFormat:@"%.1f",(float)_maxValue / _markLabelCount * i];
                } else{
                    label.text = [NSString stringWithFormat:@"%d",_maxValue / _markLabelCount * i];
                }
            }
        }
    } else{
        valueHeight = _lineHeight / valueArray.count;
        valueWidth = _x - 10;
        labelWidth = (_lineWidth - _barMargin - ((_titleArray.count - 1) *_barMargin)) / _titleArray.count ;
        
        for (int i = 0; i < (_markLabelCount + 1); i ++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,_lineHeight - (valueHeight / 2 + i * valueHeight), valueWidth, valueHeight)];
            
            [self addSubview:label];
            [self.markLabelArray addObject:label];
            
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textAlignment = NSTextAlignmentCenter;
            
            if (i == 0) {
                label.text = @"0";
            } else if(i == _markLabelCount){
                label.text = [NSString stringWithFormat:@"%d",_maxValue];
            } else{
                if (_maxValue < _markLabelCount) {
                    label.text = [NSString stringWithFormat:@"%.1f",(float)_maxValue / _markLabelCount * i];
                } else{
                    label.text = [NSString stringWithFormat:@"%d",_maxValue / _markLabelCount * i];
                }
            }
        }
    }
    
    for (int i = 0; i < valueArray.count; i++) {
        //柱状图
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [self.singleColorLayer addObject:shapeLayer];
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        
        UILabel *label = [[UILabel alloc] init];
        [self.markLabelArray addObject:label];
        
        UIBezierPath *barPath = [UIBezierPath bezierPath];
        
        if (_type == OrientationHorizontal) {
            shapeLayer.lineWidth= valueHeight;
            
            [barPath moveToPoint:CGPointMake(_x,_barMargin / 2 + _titleHeight / 2 + i * (_barMargin + valueHeight))];
            [barPath addLineToPoint:CGPointMake(_x + valueWidth * ([valueArray[i] floatValue] / _maxValue),_barMargin / 2 + _titleHeight / 2 + i * (_barMargin + valueHeight))];
            
            label.frame = CGRectMake(_x + valueWidth * ([valueArray[i] floatValue] / _maxValue) + 5, _barMargin / 2 + _titleHeight / 2 + i * (_barMargin + valueHeight) - valueHeight / 2, 50, valueHeight);
            label.textAlignment = NSTextAlignmentLeft;
            
        } else{
            shapeLayer.lineWidth= labelWidth;
            
            [barPath moveToPoint:CGPointMake(_x + _barMargin / 2 + labelWidth / 2 + i * (_barMargin + labelWidth),_lineHeight)];
            [barPath addLineToPoint:CGPointMake(_x + _barMargin / 2 + labelWidth / 2 + i * (_barMargin + labelWidth),_lineHeight - _lineHeight * ([valueArray[i] floatValue] / _maxValue))];
        
            label.frame = CGRectMake(_x + _barMargin / 2 + labelWidth / 2 + i * (_barMargin + labelWidth) - 25, _lineHeight - _lineHeight * ([valueArray[i] floatValue] / _maxValue) - 20, 50, 20);
            label.textAlignment = NSTextAlignmentCenter;
        }
        
        [self addSubview:label];
        
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"%@",valueArray[i]];
        
        
        shapeLayer.path= barPath.CGPath;
        [self.layer addSublayer:shapeLayer];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        [self.gradientLayerArray addObject:gradientLayer];
        gradientLayer.frame = self.bounds;
        gradientLayer.backgroundColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:gradientLayer];

        CAGradientLayer *colorLayer = [CAGradientLayer layer];
        [self.colorLayerArray addObject:colorLayer];

        colorLayer.frame = CGRectMake(_x, 0, _lineWidth,_lineHeight);
        colorLayer.startPoint = CGPointMake(0, 0);
        colorLayer.endPoint = CGPointMake(1, 0);
        
        [gradientLayer addSublayer:colorLayer];
        
        CAShapeLayer *gressLayer = [CAShapeLayer layer];
        if (_type == OrientationHorizontal) {
            gressLayer.lineWidth = valueHeight;
        } else{
            gressLayer.lineWidth = labelWidth;
        }
        gressLayer.strokeColor = [UIColor blueColor].CGColor;
        gressLayer.fillColor = [UIColor clearColor].CGColor;
        gressLayer.lineCap = @"bevel";
        gressLayer.path = barPath.CGPath;
        gradientLayer.mask = gressLayer;
        
        CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
        ani.fromValue = @0;
        ani.toValue = @1;
        ani.duration = 1.0;
        [gressLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    }
}

- (void)drawBar{
    
    CAShapeLayer *lineLayer= [CAShapeLayer layer];
    _lineLayer = lineLayer;
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.lineWidth = 1.0f;
    lineLayer.strokeColor = [UIColor grayColor].CGColor;
    
    _height = self.frame.size.height;
    _width = self.frame.size.width;
    _barMargin = 20.0;
    _lineHeight = _height - 20;
    if (_type == OrientationHorizontal) {
        _x = 60;
    } else{
        _x = 40;
    }
    _lineWidth = _width - _x;
    
    //参照线
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    
    [linePath moveToPoint:CGPointMake(_x,0)];
    [linePath addLineToPoint:CGPointMake(_x + _lineWidth,0)];
    [linePath addLineToPoint:CGPointMake(_x + _lineWidth,_lineHeight)];
    [linePath addLineToPoint:CGPointMake(_x,_lineHeight)];
    [linePath addLineToPoint:CGPointMake(_x,0)];
    if (_type == OrientationHorizontal) {
        for (int i = 1; i < _markLabelCount; i++) {
            [linePath moveToPoint:CGPointMake(_x + _lineWidth / _markLabelCount * i, 0)];
            [linePath addLineToPoint:CGPointMake(_x + _lineWidth / _markLabelCount * i,_lineHeight)];
        }
    } else{
        for (int i = 1; i < _markLabelCount; i++) {
            [linePath moveToPoint:CGPointMake(_x, _lineHeight / _markLabelCount * i)];
            [linePath addLineToPoint:CGPointMake(_x + _lineWidth,_lineHeight / _markLabelCount * i)];
        }
    }
    
    
    
    lineLayer.path = linePath.CGPath;
    [self.layer addSublayer:lineLayer];
    
}

#pragma mark set

- (void)maxValue:(int)value{
    _valueLength ++;
    
    if (value < 10) {
        _maxChar = value;
        return;
    }
    
    int v = value / 10;
    
    [self maxValue:v];
}

- (void)setColorArray:(NSArray *)colorArray{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (int i = 0; i < colorArray.count; i ++) {
        NSArray *color = colorArray[i];
        for (UIColor *c in color) {
            [array addObject:(id)c.CGColor];
        }
        CAGradientLayer *layer = _colorLayerArray[i];
        layer.colors = array.copy;
        [array removeAllObjects];
    }
}

- (void)setLocations:(NSArray *)locations{
    for (CAGradientLayer *layer in _colorLayerArray) {
        layer.locations = locations;
    }
}

- (void)setSingleColorArray:(NSArray *)singleColorArray{
    
    for (CAGradientLayer *layer in _gradientLayerArray) {
        [layer removeFromSuperlayer];
    }
    
    for (int i = 0; i < singleColorArray.count; i ++) {
        CAShapeLayer *layer = _singleColorLayer[i];
        UIColor *color = singleColorArray[i];
        layer.strokeColor = color.CGColor;
        
        CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
        ani.fromValue = @0;
        ani.toValue = @1;
        ani.duration = 1.0;
        [layer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    }
    
    
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

- (void)setBackgroundLineColor:(UIColor *)backgroundLineColor{
    _lineLayer.strokeColor = backgroundLineColor.CGColor;
}

- (NSMutableArray *)colorLayerArray{
    if (!_colorLayerArray) {
        _colorLayerArray = [NSMutableArray array];
    }
    return _colorLayerArray;
}

- (NSMutableArray *)markLabelArray{
    if (!_markLabelArray) {
        _markLabelArray = [NSMutableArray array];
    }
    return _markLabelArray;
}

- (NSMutableArray *)gradientLayerArray{
    if (!_gradientLayerArray) {
        _gradientLayerArray = [NSMutableArray array];
    }
    return _gradientLayerArray;
}

- (NSMutableArray *)singleColorLayer{
    if (!_singleColorLayer) {
        _singleColorLayer = [NSMutableArray array];
    }
    return _singleColorLayer;
}


@end
