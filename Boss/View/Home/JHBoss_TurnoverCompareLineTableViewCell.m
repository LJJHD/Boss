//
//  JHBoss_TurnoverCompareLineTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_TurnoverCompareLineTableViewCell.h"
#import "PNChart.h"

@interface JHBoss_TurnoverCompareLineTableViewCell ()<PNChartDelegate>
@property (nonatomic, strong) PNLineChart *lineChart;

@property (nonatomic, strong) UILabel *yoYFirstLB;//同比第一周
@property (nonatomic, strong) UILabel *yoYTwoLB;
@property (nonatomic, strong) UILabel *yoYThereLB;
@property (nonatomic, strong) UILabel *yoYFoureLB;

@property (nonatomic, strong) UILabel *chainFirstLB;//环比比第一周
@property (nonatomic, strong) UILabel *chainTwoLB;
@property (nonatomic, strong) UILabel *chainThereLB;
@property (nonatomic, strong) UILabel *chainFoureLB;
@end

@implementation JHBoss_TurnoverCompareLineTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{

   
    
    @weakify(self);
    [self.contentView addSubview:self.lineChart];
     [self lineChartUI];
    [self.lineChart mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(32);
        make.right.mas_equalTo(-32);
        make.top.equalTo(self.contentView.mas_top).offset(42);
        make.height.mas_equalTo(183);
    }];
    
    
    UIButton *chainBtn = [UIButton new];
    chainBtn.userInteractionEnabled = NO;
    [chainBtn setImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#eeb11e"] size:CGRectMake(0, 0, 7, 7)] forState:UIControlStateNormal];
    chainBtn.imageView.layer.cornerRadius = 3.5;
    chainBtn.imageView.layer.masksToBounds = YES;
    [chainBtn setTitle:@"环比增长率"];
    [chainBtn setTitleColor:DEF_COLOR_6E6E6E forState:UIControlStateNormal];
    chainBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [chainBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [chainBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.contentView addSubview:chainBtn];
    [chainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(82);
        make.height.mas_equalTo(12);
        make.right.equalTo(self.contentView.mas_right).offset(-31);
        make.top.equalTo(self.contentView.mas_top).offset(17);
    }];
    
    UIButton *yoYBtn = [UIButton new];
    yoYBtn.userInteractionEnabled = NO;
    [yoYBtn setImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#877ee7"] size:CGRectMake(0, 0, 7, 7)] forState:UIControlStateNormal];
    [yoYBtn setTitle:@"同比增长率"];
    yoYBtn.imageView.layer.cornerRadius = 3.5;
    yoYBtn.imageView.layer.masksToBounds = YES;
    [yoYBtn setTitleColor:DEF_COLOR_6E6E6E forState:UIControlStateNormal];
    yoYBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [yoYBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [yoYBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    [self.contentView addSubview:yoYBtn];
    [yoYBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(82);
        make.height.mas_equalTo(12);
        make.right.equalTo(chainBtn.mas_left).offset(-10);
        make.top.equalTo(self.contentView.mas_top).offset(17);
    }];
    
    UIImageView *yoYImage = [UIImageView new];
    yoYImage.image = [UIImage imageFromColor:[UIColor colorWithHexString:@"#877ee7"] size:CGRectMake(0, 0, 7, 7)];
    yoYImage.layer.cornerRadius = 3.5;
    yoYImage.layer.masksToBounds = YES;
    [self.contentView addSubview:yoYImage];
    
    self.yoYFirstLB = [UILabel new];
    self.yoYFirstLB.text = @"12.53%";
    self.yoYFirstLB.textAlignment = NSTextAlignmentCenter;
    self.yoYFirstLB.font = [UIFont systemFontOfSize:14];
    self.yoYFirstLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.yoYFirstLB];
    
    self.yoYTwoLB = [UILabel new];
    self.yoYTwoLB.text = @"-12.53%";
    self.yoYTwoLB.textAlignment = NSTextAlignmentCenter;
    self.yoYTwoLB.font = [UIFont systemFontOfSize:14];
    self.yoYTwoLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.yoYTwoLB];
   
    self.yoYThereLB = [UILabel new];
    self.yoYThereLB.text = @"2.53%";
    self.yoYThereLB.textAlignment = NSTextAlignmentCenter;
    self.yoYThereLB.font = [UIFont systemFontOfSize:14];
    self.yoYThereLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.yoYThereLB];
    
    self.yoYFoureLB = [UILabel new];
    self.yoYFoureLB.text = @"53%";
    self.yoYFoureLB.textAlignment = NSTextAlignmentCenter;
    self.yoYFoureLB.font = [UIFont systemFontOfSize:14];
    self.yoYFoureLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.yoYFoureLB];
    
    
    float yoYW = (self.lineChart.width - 22.5) /4;
   
    [yoYImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(46);
        make.centerY.equalTo(self.yoYFoureLB.mas_centerY);
    }];
    
    [self.yoYFirstLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(yoYImage.mas_right).offset(10);
        make.top.equalTo(self.lineChart.mas_bottom).offset(32);
        make.width.mas_equalTo(yoYW);
    }];
    
    [self.yoYTwoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.yoYFirstLB.mas_right).offset(0);
        make.centerY.equalTo(self.yoYFoureLB.mas_centerY);
        make.width.mas_equalTo(yoYW);
    }];
    
    [self.yoYThereLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.yoYTwoLB.mas_right).offset(0);
        make.centerY.equalTo(self.yoYFoureLB.mas_centerY);
        make.width.mas_equalTo(yoYW);
    }];
    
    [self.yoYFoureLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.yoYThereLB.mas_right).offset(0);
        make.top.equalTo(self.lineChart.mas_bottom).offset(32);
        make.width.mas_equalTo(yoYW);
    }];
    
    
#pragma mark --环比
    
    UIImageView *chainImage = [UIImageView new];
    chainImage.image = [UIImage imageFromColor:[UIColor colorWithHexString:@"#eeb11e"] size:CGRectMake(0, 0, 7, 7)];
    chainImage.layer.cornerRadius = 3.5;
    chainImage.layer.masksToBounds = YES;
    [self.contentView addSubview:chainImage];
    
    self.chainFirstLB = [UILabel new];
    self.chainFirstLB.text = @"12.53%";
    self.chainFirstLB.textAlignment = NSTextAlignmentCenter;
    self.chainFirstLB.font = [UIFont systemFontOfSize:14];
    self.chainFirstLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.chainFirstLB];
    
    self.chainTwoLB = [UILabel new];
    self.chainTwoLB.text = @"-12.53%";
    self.chainTwoLB.textAlignment = NSTextAlignmentCenter;
    self.chainTwoLB.font = [UIFont systemFontOfSize:14];
    self.chainTwoLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.chainTwoLB];
    
    self.chainThereLB = [UILabel new];
    self.chainThereLB.text = @"2.53%";
    self.chainThereLB.textAlignment = NSTextAlignmentCenter;
    self.chainThereLB.font = [UIFont systemFontOfSize:14];
    self.chainThereLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.chainThereLB];
    
    self.chainFoureLB = [UILabel new];
    self.chainFoureLB.text = @"53%";
    self.chainFoureLB.textAlignment = NSTextAlignmentCenter;
    self.chainFoureLB.font = [UIFont systemFontOfSize:14];
    self.chainFoureLB.textColor = DEF_COLOR_333339;
    [self.contentView addSubview:self.chainFoureLB];
    
    
    float chainW = (self.lineChart.width - 22.5) /4;
    
    [chainImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView.mas_left).offset(46);
        make.centerY.equalTo(self.chainFirstLB.mas_centerY);
    }];
    
    [self.chainFirstLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(chainImage.mas_right).offset(10);
        make.top.equalTo(self.yoYFirstLB.mas_bottom).offset(19);
        make.width.mas_equalTo(chainW);
    }];
    
    [self.chainTwoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.chainFirstLB.mas_right).offset(0);
        make.centerY.equalTo(self.chainFirstLB.mas_centerY);
        make.width.mas_equalTo(chainW);
    }];
    
    [self.chainThereLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.chainTwoLB.mas_right).offset(0);
        make.centerY.equalTo(self.chainFirstLB.mas_centerY);
        make.width.mas_equalTo(chainW);
    }];
    
    [self.chainFoureLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.chainThereLB.mas_right).offset(0);
       make.centerY.equalTo(self.chainFirstLB.mas_centerY);
        make.width.mas_equalTo(chainW);
    }];

}


- (void)lineChartUI
{
    // added an example to show how yGridLines can be enabled
    // the color is set to clearColor so that the demo remains the same
    self.lineChart.showGenYLabels = NO;
    self.lineChart.showYGridLines = YES;
    self.lineChart.showLabel = YES;
    self.lineChart.showXMark = YES;
    self.lineChart.showYMark = YES;
    self.lineChart.xLabelFont = [UIFont systemFontOfSize:12];
    self.lineChart.xLabelWidth = 36.5;
    self.lineChart.chartMarginTop = 0;
    self.lineChart.chartInnerMarginLeft = 40;
    [self.lineChart setXLabels:@[@"第一周",@"第二周",@"第三周",@"第四周"]];
    
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    //    self.lineChart.yFixedValueMax = [[self.model.dataList valueForKeyPath:@"@max.floatValue"] floatValue];
    //    if ([[self.model.dataList valueForKeyPath:@"@max.floatValue"] floatValue] > 0.0) {
    //
    //        self.lineChart.yFixedValueMax = [[self.model.dataList valueForKeyPath:@"@max.floatValue"] floatValue];
    //    }
    self.lineChart.yFixedValueMin = 0.0;
    self.lineChart.yFixedValueMax = 300.0;
    [self.lineChart setYLabels:@[
                                 @"0",
                                 @"50",
                                 @"100",
                                 @"150",
                                 @"200",
                                 @"250",
                                 @"300",
                                 ]
     ];
    
    // Line Chart #1
    //    NSArray *data01Array = self.model.dataList;
    //    PNLineChartData *data01 = [PNLineChartData new];
    //    data01.dataTitle = @"Alpha";
    //    data01.color = DEF_COLOR_CDA265;
    //    data01.lineWidth = 1.5;
    //    data01.pointLabelColor = [UIColor blackColor];
    //    data01.alpha = 1.0;
    //    data01.showPointLabel = YES;
    //    data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:9.0];
    //    data01.itemCount = data01Array.count;
    //    data01.inflexionPointColor = DEF_COLOR_CDA265;
    //    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    //    data01.inflexionPointWidth = 7;
    //    if ([self.generalModel.Id intValue] == 3 || [self.generalModel.Id intValue] == 7) {
    //        data01.pointLabelFormat = @"%1.2f";
    //    }
    //    data01.getData = ^(NSUInteger index) {
    //        CGFloat yValue = [data01Array[index] floatValue];
    //        return [PNLineChartDataItem dataItemWithY:yValue];
    //    };
    
    NSArray *data01Array = @[ @180.1, @26.4, @202.2, @126.2];
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"环比";
    data01.color = [UIColor colorWithHexString:@"#eeb11e"];
    data01.alpha = 0.5f;
    data01.itemCount = data01Array.count;
    data01.inflexionPointStyle = PNLineChartPointStyleNone;
    data01.getData = ^(NSUInteger index) {
        CGFloat yValue = [data01Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    
    NSArray *data02Array = @[@112.2, @226.2, @107.2, @276.2];
    PNLineChartData *data02 = [PNLineChartData new];
    data02.dataTitle = @"同比";
    data02.color = [UIColor colorWithHexString:@"#877ee7"];
    data02.alpha = 0.5f;
    data02.itemCount = data02Array.count;
    data02.inflexionPointStyle = PNLineChartPointStyleNone;
    data02.getData = ^(NSUInteger index) {
        CGFloat yValue = [data02Array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01,data02];
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor blackColor];
        
    }];
    
    [self.lineChart strokeChart];
    self.lineChart.delegate = self;
}


- (PNLineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart.backgroundColor = [UIColor whiteColor];
        [_lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
            obj.pointLabelColor = [UIColor blackColor];
        }];
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(32, 32, SCREEN_WIDTH - 64 , 183)];
        // 显示坐标轴
        _lineChart.showCoordinateAxis = YES;
        _lineChart.yLabelFormat = @"%1.1f";
        _lineChart.xLabelFont = DEF_SET_FONT(11);
        _lineChart.xLabelColor = DEF_COLOR_6E6E6E;
        _lineChart.yLabelColor = [UIColor blackColor];
    }
    return _lineChart;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
