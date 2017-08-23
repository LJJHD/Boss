//
//  JHBoss_TurnoverCompareHistogramTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_TurnoverCompareHistogramTableViewCell.h"
#import "Boss-Bridging-Header.h"

@interface JHBoss_TurnoverCompareHistogramTableViewCell ()<ChartViewDelegate,IChartAxisValueFormatter>
@property (nonatomic,  strong)BarChartView *barChartView;
@property (nonatomic, strong) NSMutableArray *colorArray;
@property (nonatomic, strong) NSMutableArray *xArray;//x轴值
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UILabel *yoYFirstLB;//同比第一周
@property (nonatomic, strong) UILabel *yoYTwoLB;
@property (nonatomic, strong) UILabel *yoYThereLB;
@property (nonatomic, strong) UILabel *yoYFoureLB;

@property (nonatomic, strong) UILabel *chainFirstLB;//环比比第一周
@property (nonatomic, strong) UILabel *chainTwoLB;
@property (nonatomic, strong) UILabel *chainThereLB;
@property (nonatomic, strong) UILabel *chainFoureLB;


@property (nonatomic, strong) NSMutableArray *thisYearArr;
@property (nonatomic, strong) NSMutableArray *lastYearArr;
@property (nonatomic, strong) NSMutableArray *timeArr;

@end

@implementation JHBoss_TurnoverCompareHistogramTableViewCell

-(NSMutableArray *)thisYearArr{

    if (!_thisYearArr) {
        _thisYearArr = [NSMutableArray array];
    }
    return _thisYearArr;
}

-(NSMutableArray *)lastYearArr{

    if (!_lastYearArr) {
        _lastYearArr = [NSMutableArray array];
    }
    return _lastYearArr;
}

-(NSMutableArray *)timeArr{

    if (!_timeArr) {
        _timeArr = [NSMutableArray array];
    }
    return _timeArr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         @weakify(self);
        
        UILabel *untilLB = [UILabel new];
        untilLB.text = @"单位: 元";
        untilLB.font = [UIFont systemFontOfSize:12];
        untilLB.textColor = DEF_COLOR_6E6E6E;
        [self.contentView addSubview:untilLB];
        [untilLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.contentView.mas_right).offset(-31);
            make.top.equalTo(self.contentView.mas_top).offset(17);
        }];
        
        self.rightBtn = [UIButton new];
        _rightBtn.userInteractionEnabled = NO;
        [_rightBtn setImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#ff4747"] size:CGRectMake(0, 0, 7, 7)] forState:UIControlStateNormal];
        _rightBtn.imageView.layer.cornerRadius = 3.5;
        _rightBtn.imageView.layer.masksToBounds = YES;
        [_rightBtn setTitle:@"6月"];
        [_rightBtn setTitleColor:DEF_COLOR_6E6E6E forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_rightBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_rightBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [self.contentView addSubview:_rightBtn];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(12);
            make.right.equalTo(untilLB.mas_left).offset(-10);
            make.centerY.equalTo(untilLB.mas_centerY);
        }];
        
        self.leftBtn = [UIButton new];
        _leftBtn.userInteractionEnabled = NO;
        [_leftBtn setImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"#877ee7"] size:CGRectMake(0, 0, 7, 7)] forState:UIControlStateNormal];
        [_leftBtn setTitle:@"7月"];
        _leftBtn.imageView.layer.cornerRadius = 3.5;
        _leftBtn.imageView.layer.masksToBounds = YES;
        [_leftBtn setTitleColor:DEF_COLOR_6E6E6E forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [_leftBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [self.contentView addSubview:_leftBtn];
        [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.width.mas_equalTo(42);
            make.height.mas_equalTo(12);
            make.right.equalTo(self.rightBtn.mas_left).offset(-10);
            make.centerY.equalTo(untilLB.mas_centerY);
        }];

        
        self.barChartView = [[BarChartView alloc] initWithFrame:CGRectZero];
        self.barChartView.delegate = self;//设置代理
        _barChartView.legend.form = ChartLegendFormNone;
        _barChartView.descriptionText = @"";//描述文字
        [self.contentView addSubview:self.barChartView];
        
        [self.barChartView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(32);
            make.right.mas_equalTo(-32);
            make.top.mas_equalTo(32);
            make.height.mas_equalTo(210);
        }];
        
        self.barChartView.backgroundColor = [UIColor whiteColor];
        self.barChartView.noDataText = @"暂无数据";//没有数据时的文字提示
        self.barChartView.drawValueAboveBarEnabled = YES;//数值显示在柱形的上面还是下面
        self.barChartView.rightAxis.enabled = NO;//不绘制右边轴
        self.barChartView.leftAxis.enabled = YES;
        _barChartView.xAxis.granularity = 1.f;//适配x轴label
        _barChartView.xAxis.centerAxisLabelsEnabled = YES;//适配x轴label
       
        
        ChartXAxis *xAxis = self.barChartView.xAxis;
        xAxis.axisLineWidth = 0.5;//设置X轴线宽
        xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
        xAxis.drawGridLinesEnabled = NO;//不绘制网格线
//        xAxis.labelCount = 3;//从0开始
        self.barChartView.xAxis.valueFormatter = self; //还有遵守代理IChartAxisValueFormatter
        xAxis.labelTextColor = DEF_COLOR_A1A1A1;//label文字颜色
        xAxis.labelFont = [UIFont systemFontOfSize:12];
        
        
        ChartYAxis *leftAxis = self.barChartView.leftAxis;
        leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
        //    leftAxis.showOnlyMinMaxEnabled = NO;//是否只显示最大值和最小值
        leftAxis.axisMinValue = 0;//设置Y轴的最小值
        //    leftAxis.startAtZeroEnabled = YES;//从0开始绘制
//        leftAxis.axisMaxValue = 105;//设置Y轴的最大值
        leftAxis.inverted = NO;//是否将Y轴进行上下翻转
        leftAxis.axisLineWidth = 0.5;//Y轴线宽
        leftAxis.axisLineColor = [UIColor blackColor];//Y轴颜色
        leftAxis.forceLabelsEnabled = NO;
        leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
        leftAxis.labelTextColor = DEF_COLOR_A1A1A1;//文字颜色
        leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
        leftAxis.gridLineDashLengths = @[@3.0f, @3.0f];//设置虚线样式的网格线
        leftAxis.gridColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1];//网格线颜色
        leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿

       
        //    设置动画效果，可以设置X轴和Y轴的动画效果
        [self.barChartView animateWithYAxisDuration:1.0f];
        
#pragma mark -- 下面的数据显示
        
        UIImageView *yoYImage = [UIImageView new];
        yoYImage.image = [UIImage imageFromColor:[UIColor colorWithHexString:@"#877ee7"] size:CGRectMake(0, 0, 7, 7)];
        yoYImage.layer.cornerRadius = 3.5;
        yoYImage.layer.masksToBounds = YES;
        [self.contentView addSubview:yoYImage];
         int font = 14;
        self.yoYFirstLB = [UILabel new];
        self.yoYFirstLB.text = @"1253";
        self.yoYFirstLB.textAlignment = NSTextAlignmentCenter;
        self.yoYFirstLB.font = [UIFont systemFontOfSize:MYDIMESCALE(14)];
        self.yoYFirstLB.textColor = DEF_COLOR_333339;
        [self.contentView addSubview:self.yoYFirstLB];
        
        self.yoYTwoLB = [UILabel new];
        self.yoYTwoLB.text = @"12953";
        self.yoYTwoLB.textAlignment = NSTextAlignmentCenter;
        self.yoYTwoLB.font = [UIFont systemFontOfSize:MYDIMESCALE(14)];
        self.yoYTwoLB.textColor = DEF_COLOR_333339;
        [self.contentView addSubview:self.yoYTwoLB];
        
        self.yoYThereLB = [UILabel new];
        self.yoYThereLB.text = @"53777";
        self.yoYThereLB.textAlignment = NSTextAlignmentCenter;
        self.yoYThereLB.font = [UIFont systemFontOfSize:MYDIMESCALE(14)];
        self.yoYThereLB.textColor = DEF_COLOR_333339;
        [self.contentView addSubview:self.yoYThereLB];
        
        self.yoYFoureLB = [UILabel new];
        self.yoYFoureLB.text = @"535645";
        self.yoYFoureLB.textAlignment = NSTextAlignmentCenter;
        self.yoYFoureLB.font = [UIFont systemFontOfSize:MYDIMESCALE(14)];
        self.yoYFoureLB.textColor = DEF_COLOR_333339;
        [self.contentView addSubview:self.yoYFoureLB];
        

        float yoYW = (DEF_WIDTH - 64 - 50) /4;
        [yoYImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.contentView.mas_left).offset(56);
            make.centerY.equalTo(self.yoYFoureLB.mas_centerY);
        }];
        
        [self.yoYFirstLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(yoYImage.mas_right).offset(10);
            make.top.equalTo(self.barChartView.mas_bottom).offset(0);
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
            make.top.equalTo(self.barChartView.mas_bottom).offset(0);
            make.width.mas_equalTo(yoYW);
        }];
        
        
#pragma mark --环比
        
        UIImageView *chainImage = [UIImageView new];
        chainImage.image = [UIImage imageFromColor:[UIColor colorWithHexString:@"#eeb11e"] size:CGRectMake(0, 0, 7, 7)];
        chainImage.layer.cornerRadius = 3.5;
        chainImage.layer.masksToBounds = YES;
        [self.contentView addSubview:chainImage];
        
        self.chainFirstLB = [UILabel new];
        self.chainFirstLB.text = @"123453";
        self.chainFirstLB.textAlignment = NSTextAlignmentCenter;
        self.chainFirstLB.font = [UIFont systemFontOfSize:MYDIMESCALE(font)];
        self.chainFirstLB.textColor = DEF_COLOR_333339;
        [self.contentView addSubview:self.chainFirstLB];
        
        self.chainTwoLB = [UILabel new];
        self.chainTwoLB.text = @"123253";
        self.chainTwoLB.textAlignment = NSTextAlignmentCenter;
        self.chainTwoLB.font = [UIFont systemFontOfSize:MYDIMESCALE(font)];
        self.chainTwoLB.textColor = DEF_COLOR_333339;
        [self.contentView addSubview:self.chainTwoLB];
        
        self.chainThereLB = [UILabel new];
        self.chainThereLB.text = @"2313253";
        self.chainThereLB.textAlignment = NSTextAlignmentCenter;
        self.chainThereLB.font = [UIFont systemFontOfSize:MYDIMESCALE(font)];
        self.chainThereLB.textColor = DEF_COLOR_333339;
        [self.contentView addSubview:self.chainThereLB];
        
        self.chainFoureLB = [UILabel new];
        self.chainFoureLB.text = @"2323234";
        self.chainFoureLB.textAlignment = NSTextAlignmentCenter;
        self.chainFoureLB.font = [UIFont systemFontOfSize:MYDIMESCALE(font)];
        self.chainFoureLB.textColor = DEF_COLOR_333339;
        [self.contentView addSubview:self.chainFoureLB];
        
        
        float chainW = (DEF_WIDTH - 64 - 50) /4;
        
        [chainImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.contentView.mas_left).offset(56);
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

        
        UIView *bottomLine = [UIView new];
        bottomLine.backgroundColor = DEF_COLOR_F5F5F5;
        [self.contentView addSubview:bottomLine];
        [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.height.mas_equalTo(10);
            make.left.right.mas_equalTo(0);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
        
    }
    return self;
}


-(BarChartData *)data{

    NSMutableArray *array = self.thisYearArr;
    NSMutableArray *array1 = self.lastYearArr;
   
    NSMutableArray *valueArray = [NSMutableArray array];
    [valueArray addObject:array];
    [valueArray addObject:array1];
    
    double dataSetMin = 0;
    double dataSetMax = 0;
    float groupSpace = 0.5f;
    float barSpace = 0.05f;
    float barWidth = 0.2f;
    
    NSMutableArray *dataSets = [NSMutableArray array];
    for (int i = 0; i < valueArray.count; i++) {
        NSMutableArray *yVals = [NSMutableArray array];
        BarChartDataSet *set = nil;
        NSArray *array = valueArray[i];
        for (int j = 0; j < array.count; j++)
        {
            double val = [array[j] doubleValue];
            dataSetMax = MAX(val, dataSetMax);
            dataSetMin = MIN(val, dataSetMin);
            [yVals addObject:[[BarChartDataEntry alloc]
                              initWithX:j
                              y:val]];
            set = [[BarChartDataSet alloc] initWithValues:yVals label:@""];
            [set setColor:self.colorArray[i]];
            set.drawValuesEnabled = NO;
//            set.valueColors = @[self.colorArray[i]];
        }
        [dataSets addObject:set];
    }
    double diff = dataSetMax - dataSetMin;
    
    if (dataSetMax == 0 && dataSetMin == 0) {
        dataSetMax = 100.0;
        dataSetMin = -10.0;
    } else {
        dataSetMax = (dataSetMax + diff * 0.2);
        dataSetMin = (dataSetMin - diff * 0.1);
    }
    self.barChartView.leftAxis.axisMaximum = dataSetMax;
    self.barChartView.leftAxis.axisMinimum = 0;
    
    BarChartData *data = [[BarChartData alloc] initWithDataSets:dataSets];
    [data setValueFont:[UIFont systemFontOfSize:10.f]];
    data.barWidth = barWidth;
    _barChartView.xAxis.axisMinimum = -0.1;
    _barChartView.xAxis.axisMaximum = 0 + [data groupWidthWithGroupSpace:groupSpace barSpace: barSpace] * 4;
    
    [data groupBarsFromX: 0 groupSpace: groupSpace barSpace: barSpace];
    
    return data;
}

-(NSMutableArray *)colorArray{

    if (!_colorArray) {
        
        _colorArray = [NSMutableArray arrayWithObjects:[UIColor colorWithHexString:@"#877ee7"],[UIColor colorWithHexString:@"#ff4747"], nil];
    }
    return _colorArray;
}

-(NSMutableArray *)xArray{

    if (!_xArray) {
        _xArray = [NSMutableArray array];
    }
    return _xArray;
}

- (NSString * _Nonnull)stringForValue:(double)value axis:(ChartAxisBase * _Nullable)axis{
    
    return self.xArray[(int)value % self.xArray.count];
}

-(void)setModel:(JHBoss_TurnoverCompareModel *)model{

    _model = model;
    @weakify(self);
    [model.thisYearTurnover enumerateObjectsUsingBlock:^(ThisYearTurnover * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self.thisYearArr addObject:obj.turnoverAmount.stringValue];
        [self.xArray addObject:[obj.cdate substringFromIndex:6]];
    }];

    [model.lastYearTurnover enumerateObjectsUsingBlock:^(LastYearTurnover * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        [self.lastYearArr addObject:obj.turnoverAmount.stringValue];
    }];

     ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.labelCount = self.xArray.count - 1;
    //为柱形图提供数据
    self.barChartView.data = [self data];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
