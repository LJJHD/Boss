//
//  JHBoss_HomeChartTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_HomeChartTableViewCell.h"
#import "PNPieChart.h"
@interface JHBoss_HomeChartTableViewCell ()
@property (nonatomic, strong)PNPieChart *pieChart;
@property (nonatomic, strong)UILabel *clientNumLab;//客流量
@property (nonatomic, strong)UILabel *personalPriceLab;//客单价文字
@property (nonatomic, strong)UILabel *personalPriceMoneyLab;//客单价具体数字
@property (nonatomic, strong)UILabel *oldClientNumLab;
@property (nonatomic, strong)UILabel *oldClientPerLab;//老顾客占比
@property (nonatomic, strong)UILabel *NewClientNumLab;
@property (nonatomic, strong)UILabel *NewClientPercenLab;//新顾客占比
@property (nonatomic, strong)UIImageView *moreImageView;//更多图标
@end

@implementation JHBoss_HomeChartTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
         @weakify(self);
        _personalPriceLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _personalPriceLab.text = @"客单价(元)";
        _personalPriceLab.font = [UIFont systemFontOfSize:MYDIMESCALE(12)];
        _personalPriceLab.textColor = DEF_COLOR_6E6E6E;
        [self.contentView addSubview:_personalPriceLab];
        [_personalPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.contentView.mas_left).offset(MYDIMESCALE(32.5));
            make.top.equalTo(self.contentView.mas_top).offset(MYDIMESCALE(16));
        }];
        
        _moreImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _moreImageView.image = DEF_IMAGENAME(@"1.1_btn_dropdown");
        [self.contentView addSubview:_moreImageView];
        [_moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.centerY.equalTo(self.personalPriceLab.mas_centerY);
            make.height.mas_equalTo(10);
            make.width.mas_equalTo(6);
        }];
        
        _personalPriceMoneyLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _personalPriceMoneyLab.text = @"￥300";
        _personalPriceMoneyLab.font = [UIFont systemFontOfSize:MYDIMESCALE(25)];
        _personalPriceMoneyLab.textColor = DEF_COLOR_B48645;
        [self.contentView addSubview:_personalPriceMoneyLab];
        [_personalPriceMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.personalPriceLab.mas_left);
            make.top.equalTo(self.personalPriceLab.mas_bottom).offset(MYDIMESCALE(10));
        }];
        
//        NSArray *items = @[
//                           [PNPieChartDataItem dataItemWithValue:20 color:[UIColor colorWithRGBValue:255 g:71 b:71 alpha:1] description:@"WWDC"],
//                           [PNPieChartDataItem dataItemWithValue:40 color:[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1] description:@"GOOG I/O"],
//                           ];
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectZero items:nil];
        self.pieChart.displayAnimated = NO;
        self.pieChart.backgroundColor = [UIColor colorWithRGBValue:245 g:245 b:245 alpha:1];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
//        self.pieChart.showAbsoluteValues = NO;
//        self.pieChart.showOnlyValues = YES;
        self.pieChart.hideValues = YES;
        self.pieChart.shouldHighlightSectorOnTouch = NO;
        self.pieChart.innerRadius = 4;
        self.pieChart.outerRadius = 2.2;
        [self.pieChart strokeChart];
        
        [self.contentView addSubview:self.pieChart];
        
       
        [self.pieChart mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(MYDIMESCALE(180));
            make.height.mas_equalTo(MYDIMESCALE(180));
            make.top.equalTo(self.personalPriceMoneyLab.mas_bottom).offset(0);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
        self.pieChart.layer.cornerRadius = MYDIMESCALE(180)/2;
        self.pieChart.layer.masksToBounds = YES;
        
        
        UILabel *contentLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.clientNumLab = contentLab;
        contentLab.backgroundColor = [UIColor whiteColor];
        contentLab.font = [UIFont systemFontOfSize:MYDIMESCALE(12)];
        contentLab.numberOfLines = 0;
        contentLab.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *contentAttStr = [[NSMutableAttributedString alloc]init];
        [contentAttStr appendAttributedString:[JHUtility getAttributedStringWithString:@"客流量(人)\n" font:MYDIMESCALE(12) textColor:[UIColor colorWithRGBValue:110 g:110 b:110 alpha:1]]];
        [contentAttStr appendAttributedString:[JHUtility getAttributedStringWithString:@"29889" font:MYDIMESCALE(25) textColor:[UIColor colorWithRGBValue:180 g:134 b:69 alpha:1]]];
        contentLab.attributedText = contentAttStr;
        [self.pieChart addSubview:contentLab];
        
        [contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.width.mas_equalTo(MYDIMESCALE(80));
            make.height.mas_equalTo(MYDIMESCALE(80));
            make.centerX.equalTo(self.pieChart.mas_centerX);
            make.centerY.equalTo(self.pieChart.mas_centerY);
        }];
        
        contentLab.layer.cornerRadius = MYDIMESCALE(80)/2;
        contentLab.layer.masksToBounds = YES;
        
        
        
        _NewClientNumLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _NewClientNumLab.text = @"300人";
        _NewClientNumLab.textAlignment = NSTextAlignmentCenter;
        _NewClientNumLab.font = [UIFont systemFontOfSize:14];
        _NewClientNumLab.textColor = [UIColor whiteColor];
        _NewClientNumLab.backgroundColor = DEF_COLOR_FF4747;
        _NewClientNumLab.layer.cornerRadius = MYDIMESCALE(17);
        _NewClientNumLab.layer.masksToBounds = YES;
        [self.contentView addSubview:_NewClientNumLab];
        [_NewClientNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.pieChart.mas_right).offset(MYDIMESCALE(7));
            make.top.equalTo(self.pieChart.mas_top).offset(MYDIMESCALE(7));
            make.width.mas_equalTo(MYDIMESCALE(55));
            make.height.mas_equalTo(MYDIMESCALE(33));
        }];
        _NewClientPercenLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _NewClientPercenLab.textAlignment = NSTextAlignmentLeft;
        _NewClientPercenLab.font = [UIFont systemFontOfSize:DEF_DEVICE_Iphone5 ? 11 : 12];
        _NewClientPercenLab.textColor = [UIColor whiteColor];
       
        [self.contentView addSubview:_NewClientPercenLab];
        [_NewClientPercenLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.NewClientNumLab.mas_left);
            make.right.equalTo(self.contentView).offset(-3);
            make.top.equalTo(self.NewClientNumLab.mas_bottom).offset(6);
            
        }];

        
        _oldClientNumLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _oldClientNumLab.text = @"300人";
        _oldClientNumLab.textAlignment = NSTextAlignmentCenter;
        _oldClientNumLab.font = [UIFont systemFontOfSize:14];
        _oldClientNumLab.textColor = [UIColor whiteColor];
        _oldClientNumLab.backgroundColor = [UIColor colorWithHexString:@"#eeb11e"];
        _oldClientNumLab.layer.cornerRadius = MYDIMESCALE(17);
        _oldClientNumLab.layer.masksToBounds = YES;
        [self.contentView addSubview:_oldClientNumLab];
        [_oldClientNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self.pieChart.mas_left).offset(MYDIMESCALE(-7.5));
            make.bottom.equalTo(self.pieChart.mas_bottom).offset(MYDIMESCALE(-30));
            make.width.mas_equalTo(MYDIMESCALE(55));
            make.height.mas_equalTo(MYDIMESCALE(33));
        }];
        _oldClientPerLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _oldClientPerLab.textAlignment = NSTextAlignmentCenter;
        _oldClientPerLab.font = [UIFont systemFontOfSize:12];
        _oldClientPerLab.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_oldClientPerLab];
        [_oldClientPerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.oldClientNumLab.mas_centerX);
            make.top.equalTo(self.oldClientNumLab.mas_bottom).offset(6);
            
        }];

        
    }
    return self;
}


-(void)setGeneralModel:(JHBoss_MerchatBusinessDataModel *)generalModel{

    _generalModel = generalModel;
    self.personalPriceMoneyLab.text = [NSString stringWithFormat:@"￥%.2f",generalModel.perPassergerPrice/100.0];
    
    NSMutableAttributedString *contentAttStr = [[NSMutableAttributedString alloc]init];
    [contentAttStr appendAttributedString:[JHUtility getAttributedStringWithString:@"客流量(人)\n" font:MYDIMESCALE(12) textColor:[UIColor colorWithRGBValue:110 g:110 b:110 alpha:1]]];
    [contentAttStr appendAttributedString:[JHUtility getAttributedStringWithString:[generalModel.passengerFlow stringValue] font:MYDIMESCALE(25) textColor:[UIColor colorWithRGBValue:180 g:134 b:69 alpha:1]]];
    self.clientNumLab.attributedText = contentAttStr;
    
    _oldClientNumLab.text = [generalModel.oldPassenger.stringValue stringByAppendingString:@"人"];
    
     int NewClientFont = DEF_DEVICE_Iphone5 ? 10 : 12;
    NSMutableAttributedString *oldClientPercen = [[NSMutableAttributedString alloc]init];
    [oldClientPercen appendAttributedString:[JHUtility getAttributedStringWithString:@"老顾客 " font:NewClientFont textColor:DEF_COLOR_A1A1A1]];
    [oldClientPercen appendAttributedString:[JHUtility getAttributedStringWithString:generalModel.rateOfOldPassenger font:NewClientFont textColor:DEF_COLOR_333339]];
    _oldClientPerLab.attributedText = oldClientPercen;
    
    
    _NewClientNumLab.text = [generalModel.NewPassenger.stringValue stringByAppendingString:@"人"];
    NSMutableAttributedString *NewClientPercen = [[NSMutableAttributedString alloc]init];
   
    [NewClientPercen appendAttributedString:[JHUtility getAttributedStringWithString:@"新顾客 " font:NewClientFont textColor:DEF_COLOR_A1A1A1]];
    [NewClientPercen appendAttributedString:[JHUtility getAttributedStringWithString:generalModel.rateOfNewPassenger font:NewClientFont textColor:DEF_COLOR_333339]];
    _NewClientPercenLab.attributedText = NewClientPercen;
    
    NSArray *items = @[
                       //fabsf取绝对值
                       [PNPieChartDataItem dataItemWithValue:fabsf(generalModel.NewPassenger.floatValue) color:[UIColor colorWithRGBValue:255 g:71 b:71 alpha:1] description:@"新顾客"],
                       [PNPieChartDataItem dataItemWithValue:fabsf(generalModel.oldPassenger.floatValue) color:[UIColor colorWithRGBValue:238 g:177 b:30 alpha:1] description:@"老顾客"],
                       ];
   
    [self.pieChart updateChartData:items];
//    self.pieChart.displayAnimated = YES;
    [self.pieChart strokeChart];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
