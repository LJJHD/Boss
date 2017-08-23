//
//  JHBoss_OrderExceptionListTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/7/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderExceptionListTableViewCell.h"

@interface JHBoss_OrderExceptionListTableViewCell ()
@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UILabel *timeLB;


@property (nonatomic, strong) YYLabel *reasonLB;
@property (nonatomic, strong) YYTextLayout *reasonText;
@end

@implementation JHBoss_OrderExceptionListTableViewCell

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


    [self.whiteView addSubview:self.reasonLB];
    [_reasonLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(topLineView.mas_bottom).with.offset(15.5);
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
    
//    [self.contentView addSubview:self.reasonLB];
//    [_reasonLB mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.top.equalTo(self.contentView.mas_top).with.offset(16);
//        make.left.mas_equalTo(14);
//        make.right.mas_equalTo(-14);
//        make.bottom.mas_equalTo(-16);
//    }];
    
}

-(void)setModel:(JHBoss_OrderExceptionListModel *)model{

    _timeLB.text = [NSString dateStr:[model.exOrderDate stringValue] format:@"MM-dd HH:mm:ss"];
    NSString *totalString = [NSString stringWithFormat:@"餐厅 %@ 订单号为 %@ 的订单发生异常情况为 %@ 请予以关注。", model.mcntName, model.exOrderNo, model.exOrderDesc];
    [self setTotalString:totalString withModel:model];
}

- (void)setTotalString:(NSString *)reasonString withModel:(JHBoss_OrderExceptionListModel *)model
{
    NSMutableAttributedString *total = [NSMutableAttributedString new];
    [total yy_appendString:reasonString];
    total.yy_font = [UIFont systemFontOfSize:13];
    total.yy_color = DEF_COLOR_333339;
    total.yy_lineSpacing = 5;
    
    NSUInteger loc = 0;
    NSUInteger len = 0;
    
    loc += 3;
    len = model.mcntName.length;
    NSRange range = NSMakeRange(loc, len);
    [total yy_setColor:DEF_COLOR_CDA265 range:range];
    
    loc += len + 6;
    len = model.exOrderNo.length;
    range = NSMakeRange(loc, len);
    [total yy_setColor:DEF_COLOR_CDA265 range:range];
    
    loc += len + 12;
    len = model.exOrderDesc.length;
    range = NSMakeRange(loc, len);
    [total yy_setColor:DEF_COLOR_CDA265 range:range];
    
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
//            @strongify(self);
//            if ([self.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
//                [self.delegate cell:self didClickInLabel:(YYLabel *)containerView textRange:range];
//            }
        };
    }
    return _reasonLB;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
