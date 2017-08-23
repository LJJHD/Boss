//
//  JHBoss_ClientAnalyzeDataTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ClientAnalyzeDataTableViewCell.h"
#import "PNChart.h"
@interface JHBoss_ClientAnalyzeDataTableViewCell ()<PNChartDelegate>
@property (nonatomic, strong) UILabel *themeLB;//主题
@property (nonatomic, strong) UILabel *subheadLB;//副主题
@property (nonatomic, strong) UIView *chartHeaderView;
@property (nonatomic, strong) UILabel *unitLB;//单位
@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) UIScrollView *chartView;
@end

@implementation JHBoss_ClientAnalyzeDataTableViewCell

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

    _themeLB = [UILabel new];
    _themeLB.text = @"客流量(人)";
    _themeLB.font = [UIFont systemFontOfSize:12];
    _themeLB.textColor =DEF_COLOR_6E6E6E;
    [self.contentView addSubview:_themeLB];
    @weakify(self);
    [_themeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left).offset(32.5);
        make.top.equalTo(self.contentView.mas_top).offset(16);
    }];
    
    _subheadLB = [UILabel new];
    _subheadLB.text = @"666688";
    _subheadLB.font = [UIFont systemFontOfSize:25];
    _subheadLB.textColor = DEF_COLOR_B48645;
    [self.contentView addSubview:_subheadLB];
    [_subheadLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.themeLB.mas_left);
        make.top.equalTo(self.themeLB.mas_bottom).offset(7);
    }];
    
    UIView *topLine = [UIView new];
    topLine.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [self.contentView addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left);
        make.height.mas_equalTo(10);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.subheadLB.mas_bottom).offset(13);
    }];

    
    [self.contentView addSubview:self.chartHeaderView];
    [self.chartHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(topLine.mas_bottom);
        make.height.mas_equalTo(35);
    }];
    
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [self.contentView addSubview:bottomLine];
    
    
    [self.contentView addSubview:self.chartView];
    [self.chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.chartHeaderView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(bottomLine.mas_top);
    }];
    
    
    [self lineChartUI];
    [self.chartView addSubview:self.lineChart];
//    [self.lineChart mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.equalTo(self.chartView.mas_top);
//        make.left.equalTo(self.chartView.mas_left);
////        make.right.equalTo(self.chartView.mas_right);
////        make.bottom.equalTo(self.chartView.mas_bottom);
//        make.width.mas_equalTo(self.chartView.contentSize.width);
//        make.height.equalTo(self.chartView.mas_height);
//    }];

    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left);
        make.height.mas_equalTo(10);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];


}

- (UIView *)chartHeaderView
{
    if (!_chartHeaderView) {
        _chartHeaderView = [[UIView alloc] init];
        _chartHeaderView.backgroundColor = [UIColor whiteColor];
        
        UILabel *tipLB = [[UILabel alloc] init];
        tipLB.text = @"分时数据";
        tipLB.textColor = DEF_COLOR_6E6E6E;
        tipLB.font = DEF_SET_FONT(14);
        [_chartHeaderView addSubview:tipLB];
        [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
        }];
        
        _unitLB = [[UILabel alloc] init];
        _unitLB.text = @"单位：份";
        _unitLB.textColor = DEF_COLOR_A1A1A1;
        _unitLB.font = DEF_SET_FONT(12);
        [_chartHeaderView addSubview:_unitLB];
        [_unitLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.mas_equalTo(0);
        }];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = DEF_COLOR_LINEVIEW;
        [_chartHeaderView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _chartHeaderView;
}

- (void)lineChartUI
{
    // added an example to show how yGridLines can be enabled
    // the color is set to clearColor so that the demo remains the same
    self.lineChart.showGenYLabels = YES;
    self.lineChart.showYGridLines = NO;
    self.lineChart.showLabel = YES;
    self.lineChart.showXMark = YES;
    self.lineChart.showYMark = YES;
    self.lineChart.chartMarginTop = 0;
    self.lineChart.chartInnerMarginLeft = 16;
    self.lineChart.chartInnerMarginRight = 32;
    self.lineChart.chartInnerMarginTop = 16;
    
    if ([self.model.yunit isEqualToString:@"day"]) {
        
        NSMutableArray *XArr = [NSMutableArray array];
        [self.model.xlist enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //去掉年
            [XArr addObject:[obj substringFromIndex:5]];
        }];
        [self.lineChart setXLabels:XArr];
    }else{
        
        [self.lineChart setXLabels:self.model.xlist];
    }
    //Use yFixedValueMax and yFixedValueMin to Fix the Max and Min Y Value
    //Only if you needed
    
    if ([[self.model.ylist valueForKeyPath:@"@max.floatValue"] floatValue] > 0.0) {
        if ([self.model.name isEqualToString:@"客单价"]) {
            
            self.lineChart.yFixedValueMax = [[self.model.ylist valueForKeyPath:@"@max.floatValue"] floatValue]/100;

        }else{
            
            self.lineChart.yFixedValueMax = [[self.model.ylist valueForKeyPath:@"@max.floatValue"] intValue];

        }

    }else{
    
        if ([self.model.name isEqualToString:@"客单价"]) {
            
            self.lineChart.yFixedValueMin = 0.0;
            
        }else{
            
            self.lineChart.yFixedValueMin = 0;
            
        }

    }

    
    // Line Chart #1
    NSArray *data01Array = self.model.ylist;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.dataTitle = @"Alpha";
    data01.color = DEF_COLOR_CDA265;
    data01.lineWidth = 1.5;
    data01.pointLabelColor = [UIColor blackColor];
    data01.alpha = 1.0;
    data01.showPointLabel = YES;
    data01.pointLabelFont = [UIFont fontWithName:@"Helvetica-Light" size:9.0];
    data01.itemCount = data01Array.count;
    data01.inflexionPointColor = DEF_COLOR_CDA265;
    data01.inflexionPointStyle = PNLineChartPointStyleCircle;
    data01.inflexionPointWidth = 7;
    if ([self.model.name isEqualToString:@"客单价"]) {
        data01.pointLabelFormat = @"%1.2f";
    }
    @weakify(self);
    data01.getData = ^(NSUInteger index) {
        @strongify(self);
         CGFloat yValue = 0 ;
        if ([self.model.name isEqualToString:@"客单价"]) {
            yValue = [data01Array[index] floatValue];
            yValue = yValue/100;
        }else{
            self.lineChart.yLabelFormat = @"%.0f";
            yValue = [data01Array[index] floatValue];
        }
      
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
        
    self.lineChart.chartData = @[data01];
    [self.lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
        obj.pointLabelColor = [UIColor blackColor];
    }];
    
    [self.lineChart strokeChart];
}

- (PNLineChart *)lineChart
{
    if (!_lineChart) {
        _lineChart.backgroundColor = [UIColor whiteColor];
        [_lineChart.chartData enumerateObjectsUsingBlock:^(PNLineChartData *obj, NSUInteger idx, BOOL *stop) {
            obj.pointLabelColor = [UIColor blackColor];
        }];
        //CGRectMake(0, 0, SCREEN_WIDTH * 3 + 30, 215.0)
        _lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 3 + 30, 215)];
        // 显示坐标轴
        _lineChart.showCoordinateAxis = YES;
        _lineChart.yLabelFormat = @"%1.1f";
        _lineChart.xLabelFont = DEF_SET_FONT(11);
        _lineChart.xLabelColor = DEF_COLOR_6E6E6E;
        _lineChart.yLabelColor = [UIColor blackColor];
    }
    return _lineChart;
}

- (UIScrollView *)chartView
{
    if (!_chartView) {
        _chartView = [[UIScrollView alloc] init];
        _chartView.backgroundColor= [UIColor whiteColor];
        _chartView.contentSize = CGSizeMake(DEF_WIDTH * 3 +30, 215);
        _chartView.contentOffset = CGPointMake(DEF_WIDTH * 3 +30, 0);
        
    }
    return _chartView;
}

-(void)setModel:(JHBoss_TurnoverOrFlowOrPriceModel *)model{
    _model = model;
    _themeLB.text = [[[model.name stringByAppendingString:@"("]stringByAppendingString:model.unit]stringByAppendingString:@")"];
    if ([model.name isEqualToString:@"客流量"]) {
        
        _subheadLB.text = [NSString stringWithFormat:@"%d",model.data.intValue];

    }else{
    
        _subheadLB.text = [NSString stringWithFormat:@"%.2lf",model.data.doubleValue/100];

    }
    _unitLB.text = [@"单位:" stringByAppendingString:DEF_OBJECT_TO_STIRNG(model.unit)];
    [self lineChartUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
