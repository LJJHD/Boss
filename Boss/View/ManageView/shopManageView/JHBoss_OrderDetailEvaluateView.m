//
//  JHBoss_OrderDetailEvaluateView.m
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderDetailEvaluateView.h"

@interface JHBoss_OrderDetailEvaluateView ()
@property (nonatomic, strong) UIImageView *starImageView;
@property (nonatomic, strong) UILabel *evaluateLB;//评价
@property (nonatomic, strong) MyFlowLayout *flowLayout;
@end

@implementation JHBoss_OrderDetailEvaluateView

-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation{

    self = [super initWithFrame:frame orientation:orientation];
    if (self) {
        self.padding = UIEdgeInsetsMake(20, 20, 20, 20);
        self.wrapContentWidth = NO;
        self.wrapContentHeight = YES;

    }
    return self;
}
/*
-(void)setModel:(CommentList *)model{

    _starImageView.hidden = NO;
    NSString *starMark;
    float star = [model.starType floatValue];
    if (star == 0.0) {
        
        starMark = @"zeroStar";
    }else if (star > 0.0 && star <= 0.5){
        
        starMark = @"2.2.1.1_icon_banxing";
        
    }else if (star > 0.5 && star <= 1.0){
        
        starMark = @"2.2.1.1_icon_yixing";
        
    }else if (star > 1.0 && star <= 1.5){
        
        starMark = @"2.2.1.1_icon_yixingban";
        
    }else if (star > 1.5 && star <= 2.0){
        
        starMark = @"2.2.1.1_icon_liangxing";
        
    }else if (star > 2.0 && star <= 2.5){
        
        starMark = @"2.2.1.1_icon_liangxingban";
        
    }else if (star > 2.5 && star <= 3.0){
        
        starMark = @"2.2.1.1_icon_sanxing";
        
    }else if (star > 3.0 && star <= 3.5){
        
        starMark = @"2.2.1.1_icon_sanxingban";
        
    }else if (star > 3.5 && star <= 4){
        
        starMark = @"2.2.1.1_icon_sixing";
        
    }else if (star > 4.0 && star <= 4.5){
        
        starMark = @"2.2.1.1_icon_sixingban";
        
    }else if (star > 4.5 && star <= 5.0){
        
        starMark = @"2.2.1.1_icon_wuxing";
    }

    
    _starImageView.image = DEF_IMAGENAME(starMark);
    
    self.evaluateLB.text = model.content;
    [self.evaluateLB sizeToFit];

}
*/
-(void)setCommentArr:(NSArray *)commentArr{

    _commentArr = commentArr;
    
    [self param:commentArr type:2];
}

-(void)setRestArr:(NSArray *)restArr{

    _restArr = restArr;
    [self param:restArr type:1];
}

/**
 根据model创建ui

 @param paramArr 数据
 @param type 1为餐厅评价  2为服务员评价
 */
-(void)param:(NSArray *)paramArr type:(int)type{

    
    if (type == 1) {
        NSMutableArray *arr = [NSMutableArray array];
        [paramArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CommentList *model = obj;
            if (model.type.integerValue == 1) {
                [arr addObject:model];
            }
        }];
        
        [self createUI:arr];
    }else if (type == 2){
    
        NSMutableArray *arr = [NSMutableArray array];
        [paramArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CommentList *model = obj;
            if (model.type.integerValue == 2) {
                [arr addObject:model];
            }
        }];
        
        [self createUI:arr];
    }
}

-(void)createUI:(NSArray *)paramArr{
    
    if (paramArr.count <= 0) {
        
        self.starImageView = [UIImageView new];
        self.starImageView.myWidth = 70;
        self.starImageView.myHeight = 12;
        self.starImageView.image = DEF_IMAGENAME(@"zeroStar");
        [self addSubview:self.starImageView];
        
        
        self.evaluateLB = [UILabel new];
        self.evaluateLB.text = @"暂无评价";
        self.evaluateLB.myTop = 10;
        self.evaluateLB.myHorzMargin = 0;
        self.evaluateLB.numberOfLines = 0;
        self.evaluateLB.font = [UIFont systemFontOfSize:13];
        self.evaluateLB.textColor = DEF_COLOR_333339;
        self.evaluateLB.wrapContentHeight = YES;

        [self.evaluateLB sizeToFit];
        [self addSubview:self.evaluateLB];
        return;
    }
    
    
    for (int i = 0; i < paramArr.count; i++) {
        
        CommentList *model = paramArr[i];
        
        self.starImageView = [UIImageView new];
        self.starImageView.myWidth = 70;
        self.starImageView.myHeight = 12;
        self.starImageView.image = DEF_IMAGENAME([self starNum:model.starType.floatValue]);
        if (i > 0) {
             self.starImageView.myTop =  15;
        }
        [self addSubview:self.starImageView];
        
        
        self.evaluateLB = [UILabel new];
        self.evaluateLB.myTop = 10;
        self.evaluateLB.myHorzMargin = 0;
        self.evaluateLB.numberOfLines = 0;
        self.evaluateLB.font = [UIFont systemFontOfSize:13];
        self.evaluateLB.textColor = DEF_COLOR_333339;
        self.evaluateLB.wrapContentHeight = YES;
        self.evaluateLB.text = model.content;
        [self.evaluateLB sizeToFit];
        [self addSubview:self.evaluateLB];
        
    }
}

-(NSString *)starNum:(float)star{

    NSString *starMark;
    if (star == 0.0) {
        
        starMark = @"zeroStar";
    }else if (star > 0.0 && star <= 0.5){
        
        starMark = @"2.2.1.1_icon_banxing";
        
    }else if (star > 0.5 && star <= 1.0){
        
        starMark = @"2.2.1.1_icon_yixing";
        
    }else if (star > 1.0 && star <= 1.5){
        
        starMark = @"2.2.1.1_icon_yixingban";
        
    }else if (star > 1.5 && star <= 2.0){
        
        starMark = @"2.2.1.1_icon_liangxing";
        
    }else if (star > 2.0 && star <= 2.5){
        
        starMark = @"2.2.1.1_icon_liangxingban";
        
    }else if (star > 2.5 && star <= 3.0){
        
        starMark = @"2.2.1.1_icon_sanxing";
        
    }else if (star > 3.0 && star <= 3.5){
        
        starMark = @"2.2.1.1_icon_sanxingban";
        
    }else if (star > 3.5 && star <= 4){
        
        starMark = @"2.2.1.1_icon_sixing";
        
    }else if (star > 4.0 && star <= 4.5){
        
        starMark = @"2.2.1.1_icon_sixingban";
        
    }else if (star > 4.5 && star <= 5.0){
        
        starMark = @"2.2.1.1_icon_wuxing";
    }

    return starMark;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
