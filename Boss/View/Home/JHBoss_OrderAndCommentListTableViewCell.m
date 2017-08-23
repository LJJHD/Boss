//
//  JHBoss_OrderAndCommentListTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/21.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderAndCommentListTableViewCell.h"

@interface JHBoss_OrderAndCommentListTableViewCell ()
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) YYLabel *reasonLB;
@property (nonatomic, strong) YYTextLayout *reasonText;
@end

@implementation JHBoss_OrderAndCommentListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
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
    
    self.backgroundColor = DEF_COLOR_F5F5F5;
    
    _timeLB = [[UILabel alloc] init];
    _timeLB.font = DEF_SET_FONT(11);
    _timeLB.textColor = [UIColor whiteColor];
    _timeLB.textAlignment = NSTextAlignmentCenter;
    _timeLB.layer.cornerRadius = 9;
    _timeLB.layer.masksToBounds = YES;
    _timeLB.backgroundColor = DEF_COLOR_D7D7D7;
    [self.contentView addSubview:self.timeLB];
    [_timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(100, 18));
    }];
    
    _whiteView = [[UIView alloc] init];
    _whiteView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.whiteView];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(38);
        make.left.right.and.bottom.mas_equalTo(0);
    }];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.whiteView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    _iconImageView = [[UIImageView alloc] init];
    [self.whiteView addSubview:self.iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(7, 40));
    }];
    
    _textLB = [[UILabel alloc] init];
    _textLB.font = DEF_SET_FONT(14);
    _textLB.textColor = DEF_COLOR_333339;
    [self.whiteView addSubview:self.textLB];
    [_textLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).with.offset(7);
        make.centerY.equalTo(self.iconImageView);
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.whiteView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(39.5);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.whiteView addSubview:self.reasonLB];
    [_reasonLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.iconImageView.mas_bottom).with.offset(15.5);
        make.left.mas_equalTo(14);
        make.bottom.mas_equalTo(-12);
    }];
    
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.whiteView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
}


- (void)setTotalString:(NSString *)reasonString withModel:(JHBoss_BadEvaluateModel *)model
{
    NSMutableAttributedString *total = [NSMutableAttributedString new];
    [total yy_appendString:reasonString];
    total.yy_font = [UIFont systemFontOfSize:13];
    total.yy_color = DEF_COLOR_333339;
    total.yy_lineSpacing = 5;
    
    NSUInteger loc = 0;
    NSUInteger len = 0;
    
    if (model.type == 1) {
        //会员 %@ 给您的餐厅 %@ 新的投诉建议「 %@ 」请予以关注。
        loc += 3;
        len = model.commenter.length;
        NSRange range = NSMakeRange(loc, len);
        [total yy_setColor:DEF_COLOR_CDA265 range:range];
        
        loc += len + 7;
        len = model.mcntName.length;
        range = NSMakeRange(loc, len);
        [total yy_setColor:DEF_COLOR_CDA265 range:range];
        
        if (model.desc.length > 0) {
            loc += len + 9;
            len = model.desc.length;
            range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
        }
    }else if (model.type == 2){
        
        loc += 3;
        len = model.commenter.length;
        NSRange range = NSMakeRange(loc, len);
        [total yy_setColor:DEF_COLOR_CDA265 range:range];
        
        loc += len + 3;
        len = model.mcntName.length;
        range = NSMakeRange(loc, len);
        [total yy_setColor:DEF_COLOR_CDA265 range:range];
        
        loc += len + 5;
        len = model.waiter.length;
        range = NSMakeRange(loc, len);
        [total yy_setColor:DEF_COLOR_CDA265 range:range];
        
        if (model.desc.length > 0) {
            
            loc += len + 5;
            len = model.desc.length;
            range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];

        }
        
    }
    // 着色 点击
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(DEF_WIDTH - 28, 9999)];
    container.maximumNumberOfRows = 9999;
    _reasonText = [YYTextLayout layoutWithContainer:container text:total];
    _reasonLB.textLayout = _reasonText;
    @weakify(self);
    [_reasonLB mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.height.mas_equalTo(self.reasonLB.textLayout.textBoundingSize.height);
    }];
}

- (YYLabel *)reasonLB
{
    if (!_reasonLB) {
        @weakify(self);
        _reasonLB = [[YYLabel alloc] init];
        _reasonLB.displaysAsynchronously = YES;
        _reasonLB.ignoreCommonProperties = YES;
        _reasonLB.fadeOnAsynchronouslyDisplay = NO;
        _reasonLB.fadeOnHighlight = NO;
        _reasonLB.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            @strongify(self);
//            if ([self.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
//                [self.delegate cell:self didClickInLabel:(YYLabel *)containerView textRange:range];
//            }
        };
    }
    return _reasonLB;
}

- (void)setModel:(JHBoss_BadEvaluateModel *)model
{
    _model = model;
    NSString *totalString = @"";
    //后面需要添加时间
    self.timeLB.text = [NSString dateStr:[model.date stringValue]];
    if (model.type == 1) {
       
      self.textLB.text = @"餐厅收到差评";
        if (model.desc.length > 0) {
            
        totalString = [NSString stringWithFormat:@"会员 %@ 给您的餐厅 %@ 新的投诉建议「 %@ 」请予以关注。", model.commenter, model.mcntName,  model.desc];
        }else{
        totalString = [NSString stringWithFormat:@"会员 %@ 给您的餐厅 %@ 新的投诉建议,请予以关注。" , model.commenter, model.mcntName];
        }
    
    }else if (model.type == 2){
    
      self.textLB.text = @"服务员收到差评";
        if (model.desc.length > 0) {
            
        totalString = [NSString stringWithFormat:@"会员 %@ 给 %@ 服务员 %@ 以差评 %@ 请予以关注。", model.commenter, model.mcntName, model.waiter, model.desc];
        }else{
        
        totalString = [NSString stringWithFormat:@"会员 %@ 给 %@ 服务员 %@ 以差评,请予以关注。", model.commenter, model.mcntName, model.waiter];
        }
        
    }
  
    [self setTotalString:totalString withModel:model];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
