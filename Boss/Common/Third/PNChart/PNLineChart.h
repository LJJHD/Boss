//
//  PNLineChart.h
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PNChartDelegate.h"
#import "PNGenericChart.h"

@interface PNLineChart : PNGenericChart

/**
 * Draws the chart in an animated fashion.
 */
- (void)strokeChart;

@property (nonatomic, weak) id<PNChartDelegate> delegate;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;

/**
 * Array of `LineChartData` objects, one for each line.
 */
@property (nonatomic) NSArray *chartData;

@property (nonatomic) NSMutableArray *pathPoints;
@property (nonatomic) NSMutableArray *xChartLabels;
@property (nonatomic) NSMutableArray *yChartLabels;

@property (nonatomic) CGFloat xLabelWidth;
@property (nonatomic) UIFont *xLabelFont;
@property (nonatomic) UIColor *xLabelColor;
@property (nonatomic) CGFloat yValueMax; // 纵坐标最大值
@property (nonatomic) CGFloat yFixedValueMax; // 更新纵坐标最大值
@property (nonatomic) CGFloat yFixedValueMin; // 更新纵坐标最小值
@property (nonatomic) CGFloat yValueMin; // 纵坐标最小值
@property (nonatomic) NSInteger yLabelNum;
@property (nonatomic) CGFloat yLabelHeight; // 纵坐标label的高度
@property (nonatomic) UIFont *yLabelFont;
@property (nonatomic) UIColor *yLabelColor;
@property (nonatomic) CGFloat chartCavanHeight; // 图表高度
@property (nonatomic) CGFloat chartCavanWidth; // 图表宽度
@property (nonatomic) BOOL showGenYLabels; // 是否显示纵坐标
@property (nonatomic) BOOL showYGridLines; // 是否显示y轴网格线
@property (nonatomic) UIColor *yGridLinesColor; // y轴网格线颜色
@property (nonatomic) BOOL thousandsSeparator; // 是否逢千分割 eg:123,456,789

#pragma mark - UI config

@property (nonatomic) BOOL showLabel; // 是否显示横纵坐标上边的标记
@property (nonatomic) BOOL showXMark; // 是否显示x轴标记点的小竖线
@property (nonatomic) BOOL showYMark; // 是否显示y轴标记点的小横线

@property (nonatomic) CGFloat chartInnerMarginLeft; // 折线图显示区域左内边距(y轴距左边界的左边距) default:0
@property (nonatomic) CGFloat chartInnerMarginRight; // 折线图显示区域右内边距(x轴最大值距右边界的右边距) default:0
@property (nonatomic) CGFloat chartInnerMarginTop; // 折线图显示区域上内边距(y轴最大值距上边界的上边距) default:0
@property (nonatomic) CGFloat chartInnerMarginBottom; // 折线图显示区域下内边距(x轴距下边界的下边距) default:0

@property (nonatomic) CGFloat chartMarginLeft; // 折线图显示区域左边距(y轴距左边界的左边距) default:25
@property (nonatomic) CGFloat chartMarginRight; // 折线图显示区域右边距(x轴最大值距右边界的右边距) default:25
@property (nonatomic) CGFloat chartMarginTop; // 折线图显示区域上边距(y轴最大值距上边界的上边距) default:25
@property (nonatomic) CGFloat chartMarginBottom; // 折线图显示区域下边距(x轴距下边界的下边距) default:25

/**
 * Controls whether to show the coordinate axis. Default is NO.
 */
@property (nonatomic, getter = isShowCoordinateAxis) BOOL showCoordinateAxis;
@property (nonatomic) UIColor *axisColor; // 坐标轴线的颜色
@property (nonatomic) CGFloat axisWidth; // 坐标轴线的宽度 default:1

@property (nonatomic, strong) NSString *xUnit; // 横坐标的单位
@property (nonatomic, strong) NSString *yUnit; // 纵坐标的单位

/**
 * String formatter for float values in y-axis labels. If not set, defaults to @"%1.f"
 */
@property (nonatomic, strong) NSString *yLabelFormat;

/**
 * Block formatter for custom string in y-axis labels. If not set, defaults to yLabelFormat
 */
@property (nonatomic, copy) NSString* (^yLabelBlockFormatter)(CGFloat);


/**
 * Controls whether to curve the line chart or not
 */
@property (nonatomic) BOOL showSmoothLines;

- (void)setXLabels:(NSArray *)xLabels withWidth:(CGFloat)width;

/**
 * Update Chart Value
 */

- (void)updateChartData:(NSArray *)data;


/**
 *  returns the Legend View, or nil if no chart data is present. 
 *  The origin of the legend frame is 0,0 but you can set it with setFrame:(CGRect)
 *
 *  @param mWidth Maximum width of legend. Height will depend on this and font size
 *
 *  @return UIView of Legend
 */
- (UIView*) getLegendWithMaxWidth:(CGFloat)mWidth;


+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font;

+ (CGPoint)midPointBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;
+ (CGPoint)controlPointBetweenPoint1:(CGPoint)point1 andPoint2:(CGPoint)point2;

@end
