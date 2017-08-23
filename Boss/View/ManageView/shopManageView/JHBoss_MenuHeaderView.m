//
//  JHBoss_MenuHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_MenuHeaderView.h"

@interface JHBoss_MenuHeaderView ()
@property (nonatomic, strong) UIImageView *arrowImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numLable;
@end

@implementation JHBoss_MenuHeaderView

/* 在构造方法中，创建UI*/
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        self.arrowImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.arrowImage.image = [UIImage imageNamed:@"2.1.2.1_btn_dropdown_defaulted"];
        [self.contentView addSubview:self.arrowImage];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, w, 44)];
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = DEF_COLOR_6E6E6E;
        
        self.numLable = [[UILabel alloc]initWithFrame:CGRectZero];
        self.numLable.font = [UIFont systemFontOfSize:14];
        self.numLable.text = @"16";
        self.numLable.textColor = DEF_COLOR_A1A1A1;
        
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor = DEF_COLOR_ECECEC;
        [self.contentView addSubview:line];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.numLable];
        
        
        [self.arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.arrowImage.mas_right).offset(4);
            make.centerY.equalTo(self.arrowImage.mas_centerY);
        }];
        
        [self.numLable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(self.arrowImage.mas_centerY);
//            make.left.equalTo(self.titleLabel.mas_right).offset(8);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.and.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

/*
 1、通过懒加载，设置“箭头”的方向
 2、通过头视图SectionView的点击，改变“箭头”的方向
 3、通过点击SectionView，回调block进行section刷新
 */
- (void)setModel:(JHBoss_MenuSectionModel *)model{
    if (_model != model) {
        _model = model;
    }
    self.titleLabel.text = model.title;
    if (model.isExpand) {       //展开
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI_2);
        
    }else{
        self.arrowImage.transform = CGAffineTransformIdentity;
    }
}

-(void)setDishesModel:(JHBoss_DishesListModel *)dishesModel{

    _dishesModel = dishesModel;
    
    _titleLabel.text = DEF_OBJECT_TO_STIRNG(dishesModel.name);
    
    _numLable.text = [NSString stringWithFormat:@"%ld",dishesModel.count];
}

- (void)btnClick:(UIButton *)sender{
    self.model.isExpand = ! self.model.isExpand;
    if (self.model.isExpand) {
        
        self.arrowImage.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        
        self.arrowImage.transform = CGAffineTransformIdentity;
    }
    if (self.block) {
        self.block(self.model.isExpand);
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
