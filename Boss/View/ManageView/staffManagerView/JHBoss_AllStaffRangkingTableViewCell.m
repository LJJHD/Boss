//
//  JHBoss_AllStaffRangkingTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AllStaffRangkingTableViewCell.h"

@interface JHBoss_AllStaffRangkingTableViewCell ()

@property (nonatomic, strong) UILabel *nameLB;//员工名字
@property (nonatomic, strong) UILabel *badEvNumLB;//差评数
@property (nonatomic, strong) UILabel *serviceResponseTimeLB;//服务响应时间

@property (nonatomic, strong) UILabel *peopleMoney;//人均消费
@property (nonatomic, strong) UIImageView *customImageView;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *rewardMoneyLB;//打赏次数
@end

@implementation JHBoss_AllStaffRangkingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUI];
    }
    return self;
}
//设置UI
-(void)setUI
{
    @weakify(self);
    
    _numberLB = [[UILabel alloc] init];
    _numberLB.font = DEF_SET_FONT(13);
    _numberLB.textColor = DEF_COLOR_A1A1A1;
    _numberLB.text = @"666";
    _numberLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.numberLB];
    [_numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        //.with.offset(MYDIMESCALE(18))
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self);
    }];
    
    _nameLB = [[UILabel alloc] init];
    _nameLB.font = DEF_SET_FONT(13);
    _nameLB.textColor = DEF_COLOR_333339;
    _nameLB.text = @"张三";
    _nameLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.nameLB];
    [_nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        //.with.offset(MYDIMESCALE(55))
        make.left.equalTo(self.numberLB.mas_right);
        make.width.equalTo(self.numberLB);
        make.centerY.equalTo(self);
    }];
    
    _badEvNumLB = [[UILabel alloc] init];
    _badEvNumLB.font = DEF_SET_FONT(13);
    _badEvNumLB.textColor = DEF_COLOR_A1A1A1;
    _badEvNumLB.text = @"900";
    _badEvNumLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.badEvNumLB];
    [_badEvNumLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        //.with.offset(MYDIMESCALE(116))
        make.left.equalTo(self.nameLB.mas_right);
        make.width.equalTo(self.nameLB);
        make.centerY.equalTo(self);
    }];
    
    // update nameLB
//    [_nameLB mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.right.lessThanOrEqualTo(self.badEvNumLB.mas_left).with.offset(-6);
//    }];
    /*
    _serviceResponseTimeLB = [[UILabel alloc]init];
    _serviceResponseTimeLB.font = DEF_SET_FONT(13);
    _serviceResponseTimeLB.textColor = DEF_COLOR_A1A1A1;
    _serviceResponseTimeLB.text = @"68";
    _serviceResponseTimeLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.serviceResponseTimeLB];
    [_serviceResponseTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self);
    }];
    */
    _rewardMoneyLB = [[UILabel alloc] init];
    _rewardMoneyLB.font = DEF_SET_FONT(13);
    _rewardMoneyLB.textColor = DEF_COLOR_A1A1A1;
    _rewardMoneyLB.text = @"1000";
    _rewardMoneyLB.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rewardMoneyLB];
    [_rewardMoneyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
       // .with.offset(MYDIMESCALE(-140))
        make.left.equalTo(self.badEvNumLB.mas_right);
        make.width.equalTo(self.badEvNumLB);
        make.centerY.equalTo(self);
    }];
    
    _peopleMoney = [[UILabel alloc] init];
    _peopleMoney.font = DEF_SET_FONT(13);
    _peopleMoney.textColor = DEF_COLOR_A1A1A1;
    _peopleMoney.text = @"￥300";
    _peopleMoney.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.peopleMoney];
    
    _customImageView = [[UIImageView alloc] init];
    _customImageView.image = DEF_IMAGENAME(@"1.1_btn_dropdown");
    [self.contentView addSubview:self.customImageView];
    
    
    
    [_peopleMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        //
        make.left.equalTo(self.rewardMoneyLB.mas_right);
        //MYDIMESCALE(-42.5)
        make.right.equalTo(self.customImageView.mas_left);
        make.centerY.equalTo(self);
        make.width.equalTo(self.rewardMoneyLB);
    }];
    
    
    [_customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}

-(void)setModel:(JHBoss_StaffRankingModel *)model{

    _nameLB.text = DEF_OBJECT_TO_STIRNG(model.name);
    
    _badEvNumLB.text = [model.negativeCommentNum stringValue];
    
//    _serviceResponseTimeLB.text = [model.serviceResponse stringValue];

    _rewardMoneyLB.text = [model.rewardNum stringValue];
    
    NSString *str = @"￥";
    _peopleMoney.text =  [str stringByAppendingString:[NSString stringWithFormat:@"%g",model.rewardNum.doubleValue/100]];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
