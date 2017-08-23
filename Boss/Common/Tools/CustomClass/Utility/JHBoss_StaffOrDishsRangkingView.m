//
//  JHBoss_StaffOrDishsRangkingView.m
//  Boss
//
//  Created by jinghankeji on 2017/7/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffOrDishsRangkingView.h"

@interface JHBoss_StaffOrDishsRangkingView ()
@property (nonatomic, strong) UILabel *restNameLB;
@property (nonatomic, strong) UIImageView *restNameImage;

@property (nonatomic, strong) UILabel *selectTimeLB;
@property (nonatomic, strong) UIImageView *selectTimeImage;

//排序view
@property (nonatomic, strong) UILabel *rangkingLB;
@property (nonatomic, strong) UIImageView *rangkingImage;
@end

@implementation JHBoss_StaffOrDishsRangkingView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        @weakify(self);
        self.backgroundColor = [UIColor colorWithHexString:@"#cda265"];
        
        
        
        self.restNameBackView = [UIView new];
        self.restNameBackView.backgroundColor = [UIColor colorWithHexString:@"#dab580"];
        self.restNameBackView.layer.cornerRadius = 3;
        self.restNameBackView.layer.masksToBounds = YES;
        UITapGestureRecognizer *restNameTap  = [[UITapGestureRecognizer alloc]init];
        [[restNameTap rac_gestureSignal] subscribeNext:^(id x) {
            @strongify(self);
            [self chioceRest];
        }];
        [self.restNameBackView addGestureRecognizer:restNameTap];
        [self addSubview:self.restNameBackView];
        [self.restNameBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.mas_left).offset(12.5);
            make.right.mas_equalTo(-12.5);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(45);
        }];
        
        self.restNameImage = [UIImageView new];
        self.restNameImage.image = DEF_IMAGENAME(@"2.2.2.1_icon_diapu");
        self.restNameImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.restNameBackView addSubview:self.restNameImage];
        [self.restNameImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(16);
            make.centerY.equalTo(self.restNameBackView);
        }];
        
        self.restNameLB = [UILabel new];
        self.restNameLB.text = @"暂无餐厅";
        self.restNameLB.font = [UIFont systemFontOfSize:16];
        self.restNameLB.textColor = [UIColor whiteColor];
        self.restNameLB.textAlignment = NSTextAlignmentLeft;
        [self.restNameBackView addSubview:self.restNameLB];
        [self.restNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.restNameImage.mas_right).offset(10);
            make.centerY.equalTo(self.restNameBackView);
        }];
        
        self.restTimeLB = [UILabel new];
        self.restTimeLB.text = @"2017.6.30-2017.7.3";
        self.restTimeLB.font = [UIFont systemFontOfSize:16];
        self.restTimeLB.textColor = [UIColor whiteColor];
        self.restTimeLB.textAlignment = NSTextAlignmentLeft;
        self.restTimeLB.alpha = 0;
        [self.restNameBackView addSubview:self.restTimeLB];
        [self.restTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.restNameLB.mas_right).offset(8);
            make.centerY.equalTo(self.restNameBackView);
        }];
        
        self.rangkingBackgroundView = [UIView new];;
        self.rangkingBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#dab580"];
        self.rangkingBackgroundView.layer.cornerRadius = 3;
        self.rangkingBackgroundView.layer.masksToBounds = YES;
        UITapGestureRecognizer *rangkingTap = [[UITapGestureRecognizer alloc]init];
        [rangkingTap.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            [self rangking];
        }];
        [self.rangkingBackgroundView addGestureRecognizer:rangkingTap];
        [self addSubview:self.rangkingBackgroundView];
        [self.rangkingBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.restNameBackView.mas_bottom).offset(7);
            make.left.equalTo(self.mas_left).offset(12.5);
            make.right.mas_equalTo(-12.5);
            make.height.mas_equalTo(45);
        }];
        
        
        self.rangkingImage = [UIImageView new];
        self.rangkingImage.image = DEF_IMAGENAME(@"2.2.2.1_icon_paihang");
        [self.rangkingBackgroundView addSubview:self.rangkingImage];
        [self.rangkingImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(16);
            make.centerY.equalTo(self.rangkingBackgroundView);
        }];
        
        self.rangkingLB = [UILabel new];
        self.rangkingLB.text = @"排序";
        self.rangkingLB.font = [UIFont systemFontOfSize:16];
        self.rangkingLB.textColor = [UIColor whiteColor];
        self.rangkingLB.textAlignment = NSTextAlignmentLeft;
        [self.rangkingBackgroundView addSubview:self.rangkingLB];
        [self.rangkingLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.rangkingImage.mas_right).offset(10);
            make.centerY.equalTo(self.rangkingBackgroundView);
        }];


        
        self.selectTimeBackView = [UIView new];;
        self.selectTimeBackView.backgroundColor = [UIColor colorWithHexString:@"#dab580"];
        self.selectTimeBackView.layer.cornerRadius = 3;
        self.selectTimeBackView.layer.masksToBounds = YES;
        UITapGestureRecognizer *selectTimeTap = [[UITapGestureRecognizer alloc]init];
        [selectTimeTap.rac_gestureSignal subscribeNext:^(id x) {
            @strongify(self);
            [self choiceTime];
        }];
        [self.selectTimeBackView addGestureRecognizer:selectTimeTap];
        [self addSubview:self.selectTimeBackView];
        [self.selectTimeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.rangkingBackgroundView.mas_bottom).offset(7);
            make.left.equalTo(self.mas_left).offset(12.5);
            make.right.mas_equalTo(-12.5);
            make.height.mas_equalTo(45);
        }];
        
        
        self.selectTimeImage = [UIImageView new];
        self.selectTimeImage.image = DEF_IMAGENAME(@"2.2.2.1_icon_date");
        [self.selectTimeBackView addSubview:self.selectTimeImage];
        [self.selectTimeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(22);
            make.height.mas_equalTo(16);
            make.centerY.equalTo(self.selectTimeBackView);
        }];
        
        self.selectTimeLB = [UILabel new];
        self.selectTimeLB.text = @"今日";
        self.selectTimeLB.font = [UIFont systemFontOfSize:16];
        self.selectTimeLB.textColor = [UIColor whiteColor];
        self.selectTimeLB.textAlignment = NSTextAlignmentLeft;
        [self.selectTimeBackView addSubview:self.selectTimeLB];
        [self.selectTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.restNameImage.mas_right).offset(10);
            make.centerY.equalTo(self.selectTimeBackView);
        }];
        
    }
    return self;
}



-(void)setRestName:(NSString *)restName{
    
    if (restName.length > 0) {
        _restName = restName;
        self.restNameLB.text = restName;
        
        [self.restNameLB sizeToFit];
    }
    
}

-(void)setRangkingLbStr:(NSString *)rangkingLbStr{

    if (rangkingLbStr.length > 0) {
        _rangkingLbStr = rangkingLbStr;
        self.rangkingLB.text = rangkingLbStr;
    }

}

-(void)setSelectTime:(NSString *)selectTime{
    
    if (selectTime.length > 0) {
        _selectTime = selectTime;
        _selectTimeLB.text = selectTime;
        [_selectTimeLB sizeToFit];
    }
    
}

-(void)setRestImageStr:(NSString *)restImageStr{
    
    if (restImageStr.length > 0) {
        _restImageStr = restImageStr;
        self.restNameImage.image = DEF_IMAGENAME(restImageStr);
    }
}

-(void)setHideLBStr:(NSString *)hideLBStr{
    
    
    
}

-(void)chioceRest{
    
    if (self.choiceRestHandler) {
        self.choiceRestHandler();
    }
    
}

-(void)choiceTime{
    
    if (self.selectTimeHandler) {
        self.selectTimeHandler();
    }
    
}

-(void)rangking{

    if (self.rangkingHandler) {
        self.rangkingHandler();
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
