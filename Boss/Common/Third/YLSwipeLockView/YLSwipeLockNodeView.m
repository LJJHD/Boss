//
//  YLSwipeLockNodeView.m
//  YLSwipeLockViewDemo
//
//  Created by 肖 玉龙 on 15/2/12.
//  Copyright (c) 2015年 Yulong Xiao. All rights reserved.
//

#import "YLSwipeLockNodeView.h"
#import "YLSwipeLockView.h"
@interface YLSwipeLockNodeView()
@property (nonatomic, strong)CAShapeLayer *outlineLayer;
@property (nonatomic, strong)CAShapeLayer *innerCircleLayer;
@end


@implementation YLSwipeLockNodeView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.outlineLayer];
        [self.layer addSublayer:self.innerCircleLayer];
        self.nodeViewStatus = YLSwipeLockNodeViewStatusNormal;
    }
    return self;
}

-(void)pan:(UIPanGestureRecognizer *)rec
{
    NSLog(@"what the fuck");
    CGPoint point = [rec locationInView:self];
    NSLog(@"location in view:%f, %f", point.x, point.y);
    self.nodeViewStatus = YLSwipeLockNodeViewStatusSelected;
}

-(void)setNodeViewStatus:(YLSwipeLockNodeViewStatus)nodeViewStatus
{
    _nodeViewStatus = nodeViewStatus;
    switch (_nodeViewStatus) {
        case YLSwipeLockNodeViewStatusNormal:
            [self setStatusToNormal];
            break;
        case YLSwipeLockNodeViewStatusSelected:
            [self setStatusToSelected];
            break;
        case YLSwipeLockNodeViewStatusWarning:
            [self setStatusToWarning];
            break;
        default:
            break;
    }
}

-(void)setStatusToNormal
{
    self.outlineLayer.strokeColor = DEF_COLOR_6E6E6E.CGColor;
    self.innerCircleLayer.fillColor = [UIColor clearColor].CGColor;
}

-(void)setStatusToSelected
{
    self.outlineLayer.strokeColor = DEF_COLOR_CDA265.CGColor;
    self.innerCircleLayer.fillColor = DEF_COLOR_CDA265.CGColor;
}

-(void)setStatusToWarning
{
    self.outlineLayer.strokeColor = DEF_COLOR_FF4747.CGColor;
    self.innerCircleLayer.fillColor = DEF_COLOR_FF4747.CGColor;
    
}


-(void)layoutSubviews
{
    self.outlineLayer.frame = self.bounds;
    UIBezierPath *outlinePath = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    self.outlineLayer.path = outlinePath.CGPath;
    
    CGRect frame = self.bounds;
    CGFloat width = frame.size.width / 3;
    self.innerCircleLayer.frame = CGRectMake(width, width, width, width);
    UIBezierPath *innerPath = [UIBezierPath bezierPathWithOvalInRect:self.innerCircleLayer.bounds];
    self.innerCircleLayer.path = innerPath.CGPath;

}

-(CAShapeLayer *)outlineLayer
{
    if (_outlineLayer == nil) {
        _outlineLayer = [[CAShapeLayer alloc] init];
        _outlineLayer.strokeColor = LIGHTBLUE.CGColor;
        _outlineLayer.lineWidth = 1.0f;
        _outlineLayer.fillColor  = [UIColor clearColor].CGColor;
    }
    return _outlineLayer;
}

-(CAShapeLayer *)innerCircleLayer
{
    if (_innerCircleLayer == nil) {
        _innerCircleLayer = [[CAShapeLayer alloc] init];
        _innerCircleLayer.strokeColor = [UIColor clearColor].CGColor;
        _innerCircleLayer.lineWidth = 1.0f;
        _innerCircleLayer.fillColor  = LIGHTBLUE.CGColor;
    }
    return _innerCircleLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
