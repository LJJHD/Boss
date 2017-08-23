//
//  JHBoss_SectionManagerHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SectionManagerHeaderView.h"

@interface JHBoss_SectionManagerHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *unfoldBtn;
@property (nonatomic, strong) UIButton *deletBtn;

@end

@implementation JHBoss_SectionManagerHeaderView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithReuseIdentifier:reuseIdentifier];

    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLabel.text = @"服务部";
        [self.contentView addSubview:self.titleLabel];
        
        @weakify(self);
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            
            make.left.mas_equalTo(25);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        self.unfoldBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.unfoldBtn.backgroundColor = [UIColor clearColor];
        [self.unfoldBtn addTarget:self action:@selector(unfoldHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.unfoldBtn];
        
        self.deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deletBtn setimage:@"2.2.1.2_icon_delete"];
        [self.deletBtn addTarget:self action:@selector(deletHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deletBtn];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectZero];
        line.backgroundColor = DEF_COLOR_ECECEC;
        [self.contentView addSubview:line];
        
        [self.unfoldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.deletBtn.mas_left);
        }];
        
        [self.deletBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.height.width.mas_equalTo(44);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.and.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];

        
    }

    return self;
}

-(void)setModel:(JHBoss_SectionManagerUnfoldModel *)model{

    if (_model != model) {
        _model = model;
    }
   

}

-(void)setClassificationModel:(JHBoss_RestClassification *)ClassificationModel{

    _ClassificationModel = ClassificationModel;

    self.titleLabel.text = ClassificationModel.name;

}


//点击折叠
-(void)unfoldHandler:(UIButton *)sender{
   self.model.isExpand = ! self.model.isExpand;
    
    if (self.unfoldBlock) {
        self.unfoldBlock(self.model.isExpand,sender);
    }

}

//点击删除
-(void)deletHandler:(UIButton *)sender{
    
    if (self.deletBlock) {
        self.deletBlock();
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
