//
//  JHBoss_ClientAnalyzeTasteTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ClientAnalyzeTasteTableViewCell.h"
#import "PNChart.h"
@interface JHBoss_ClientAnalyzeTasteTableViewCell ()
@property (nonatomic, strong) UILabel *themeLB;//主题
@property (nonatomic, strong) UILabel *subheadLB;//副主题
@property (nonatomic, strong)PNPieChart *pieChart;
@end

@implementation JHBoss_ClientAnalyzeTasteTableViewCell

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
    _themeLB.text = @"最受欢迎的菜系";
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
    _subheadLB.text = @"本帮菜";
    _subheadLB.font = [UIFont systemFontOfSize:25];
    _subheadLB.textColor = DEF_COLOR_B48645;
    [self.contentView addSubview:_subheadLB];
    [_subheadLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.themeLB.mas_left);
        make.top.equalTo(self.themeLB.mas_bottom).offset(7);
    }];


    NSArray *items = @[
                       [PNPieChartDataItem dataItemWithValue:20 color:[UIColor colorWithRGBValue:255 g:71 b:71 alpha:1] description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1] description:@"GOOG I/O"],
                       [PNPieChartDataItem dataItemWithValue:10 color:[UIColor colorWithRGBValue:255 g:71 b:71 alpha:1] description:@"WWDC"],
                       [PNPieChartDataItem dataItemWithValue:40 color:[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1] description:@"GOOG I/O"],
                       ];
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectZero items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = YES;
    [self.pieChart strokeChart];
    [self.contentView addSubview:self.pieChart];
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [self.contentView addSubview:legend];
    [legend mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
//        @stringify(legend);
        make.left.equalTo(self.pieChart.mas_right).offset(MYDIMESCALE(35));
//        make.top.equalTo(self.pieChart.mas_top).offset(15);
        make.centerY.equalTo(self.pieChart.mas_centerY).offset(-20);
        make.width.mas_equalTo(legend.mas_width);
        make.height.mas_equalTo(legend.mas_height);
    }];
    
    [self.pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(MYDIMESCALE(115));
        make.height.mas_equalTo(MYDIMESCALE(115));
        make.top.equalTo(self.subheadLB.mas_bottom).offset(10);
        make.centerX.equalTo(self.contentView.mas_centerX).offset(-55);
    }];
    
    [self.pieChart recompute];
   
    UIView *bottomLine = [UIView new];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    [self.contentView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.contentView.mas_left);
        make.height.mas_equalTo(10);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}

-(void)recompute{



}

-(void)setModel:(JHBoss_WelcomeDishsModel *)model{
    
    _model = model;
   


}

-(void)setWelcomeDishsArr:(NSMutableArray *)welcomeDishsArr{

    _welcomeDishsArr = welcomeDishsArr;

   [ welcomeDishsArr sortWithOptions:NSSortConcurrent usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
       JHBoss_WelcomeDishsModel *mode1 = obj1;
       JHBoss_WelcomeDishsModel *model2 = obj2;
       if ([mode1.saleAmount intValue] > [model2.saleAmount intValue]) {
           
            return NSOrderedDescending;
       }else if ([mode1.saleAmount intValue] == [model2.saleAmount intValue]){
       
            return NSOrderedSame;
       }else {
       
            return NSOrderedAscending;
       }
   }];
    
    NSArray *colorArr = @[[UIColor colorWithRGBValue:255 g:71 b:71 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:255 g:71 b:71 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1],[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1]];
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i = 0 ; i< 5; i++) {
        JHBoss_WelcomeDishsModel *model = welcomeDishsArr[i];
        UIColor *color = colorArr[i];
      PNPieChartDataItem *item =  [PNPieChartDataItem dataItemWithValue:[model.saleAmount intValue] color:color description:model.dishCategoryName];
        [items addObject:item];
    }
    
    [self.pieChart updateChartData:items];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
