//
//  JHBoss_NotificationReminderTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_NotificationReminderTableViewCell.h"

@interface JHBoss_NotificationReminderTableViewCell ()

@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLB;
@property (nonatomic, strong) UILabel *NewLB;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) YYLabel *reasonLB;
@property (nonatomic, strong) YYTextLayout *reasonText;

@end


@implementation JHBoss_NotificationReminderTableViewCell

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
    
    _NewLB = [[UILabel alloc] init];
    _NewLB.font = DEF_SET_FONT(14);
    _NewLB.textColor = DEF_COLOR_333339;
    _NewLB.layer.borderWidth = 0.5;
    _NewLB.layer.borderColor = [UIColor colorWithHexString:@"#ff4747"].CGColor;
    _NewLB.text = @"NEW";
    _NewLB.textColor = [UIColor colorWithHexString:@"#ff4747"];
    _NewLB.textAlignment = NSTextAlignmentCenter;
    _NewLB.layer.cornerRadius = 3;
    _NewLB.layer.masksToBounds = YES;
    [self.whiteView addSubview:self.NewLB];
    [_NewLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.whiteView.mas_right).with.offset(-11);
        make.centerY.equalTo(self.textLB);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.whiteView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(39.5);
        make.height.mas_equalTo(0.5);
    }];
    
//    _textView = [[YYTextView alloc] init];
//    _textView.font = DEF_SET_FONT(13);
//    _textView.textContainerInset = UIEdgeInsetsMake(15.5, 14, 15.5, 14);
//    _textView.editable = NO;
//    _textView.scrollEnabled = NO;
//    [self.whiteView addSubview:self.textView];
//    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.top.equalTo(self.iconImageView.mas_bottom);
//        make.left.right.and.bottom.mas_equalTo(0);
//    }];
    
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

- (void)setNotificationReminderType:(NotificationReminderType)notificationReminderType
{
    switch (notificationReminderType) {
        case NotificationReminderTypeRestReceivedNegative:
        {
            self.iconImageView.backgroundColor = [UIColor colorWithHexString:@"#eeb11e"];
//            self.textLB.text = @"餐厅收到了差评";
        }
            break;
        case NotificationReminderTypeWiterReceivedNegative:
        {
            self.iconImageView.backgroundColor = DEF_COLOR_FF4747;
//            self.textLB.text = @"服务员收到了差评";
        }
            break;
        case NotificationReminderTypeOrderAbnormal:
        {
            self.iconImageView.backgroundColor = DEF_COLOR_FF4747;
//            self.textLB.text = @"订单异常";
        }
            break;
        case NotificationReminderTypeNoNote:
        {
            self.iconImageView.backgroundColor = DEF_COLOR_FF4747;
            //            self.textLB.text = @"2017-02-23 日报推送";
        }
            break;
        default:
            break;
    }
//    self.timeLB.text = @"02-29 13:34:34";
}

- (void)setTotalString:(NSString *)reasonString withModel:(JHBoss_NotificationReminderModel *)model
{
    [self setNotificationReminderType:model.type];
    
    NSMutableAttributedString *total = [NSMutableAttributedString new];
    [total yy_appendString:reasonString];
    total.yy_font = [UIFont systemFontOfSize:13];
    total.yy_color = DEF_COLOR_333339;
    total.yy_lineSpacing = 5;
    
    NSUInteger loc = 0;
    NSUInteger len = 0;
    
    switch (model.type) {
        case NotificationReminderTypeRestReceivedNegative:
        {
            loc += 3;
            len = model.memberName.length;
            NSRange range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
            
            loc += len + 7;
            len = model.restaurantName.length;
            range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
            
            if (model.reason.length > 0) {
                loc += len + 9;
                len = model.reason.length;
                range = NSMakeRange(loc, len);
                [total yy_setColor:DEF_COLOR_CDA265 range:range];
            }
            
        }
            break;
        case NotificationReminderTypeWiterReceivedNegative:
        {
            loc += 3;
            len = model.memberName.length;
            NSRange range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
            
            loc += len + 3;
            len = model.restaurantName.length;
            range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
            
            loc += len + 5;
            len = model.staffName.length;
            range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
            
            if (model.reason.length > 0) {
                
                loc += len + 5;
                len = model.reason.length;
                range = NSMakeRange(loc, len);
                [total yy_setColor:DEF_COLOR_CDA265 range:range];
            }
           
        }
            break;
        case NotificationReminderTypeOrderAbnormal:
        {
            loc += 3;
            len = model.restaurantName.length;
            NSRange range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
            
            loc += len + 6;
            len = model.orderNumber.length;
            range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
            
            loc += len + 12;
            len = model.reason.length;
            range = NSMakeRange(loc, len);
            [total yy_setColor:DEF_COLOR_CDA265 range:range];
        }
            break;

        case NotificationReminderTypeNoNote:
        {
//            loc += 5;
//            len = model.dataTitle.length;
//            NSRange range = NSMakeRange(loc, len);
//            [total yy_setColor:DEF_COLOR_CDA265 range:range];
        }
            break;
        default:
            break;
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
            if ([self.delegate respondsToSelector:@selector(cell:didClickInLabel:textRange:)]) {
                [self.delegate cell:self didClickInLabel:(YYLabel *)containerView textRange:range];
            }
        };
    }
    return _reasonLB;
}

/*
 
 self.textLB.text = @"餐厅收到差评";
 if (model.desc.length > 0) {
 
 totalString = [NSString stringWithFormat:@"会员 %@ 给您的餐厅 %@ 新的投诉建议「 %@ 」请予以关注。", model.commenter, model.mcntName,  model.desc];
 }else{
 totalString = [NSString stringWithFormat:@"会员 %@ 给您的餐厅 %@ 新的投诉建议,请予以关注。", model.commenter, model.mcntName];
 }
 
 }else if (model.type == 2){
 
 self.textLB.text = @"服务员收到差评";
 if (model.desc.length > 0) {
 
 totalString = [NSString stringWithFormat:@"会员 %@ 给 %@ 服务员 %@ 以差评 %@ 请予以关注。", model.commenter, model.mcntName, model.waiter, model.desc];
 }else{
 
 totalString = [NSString stringWithFormat:@"会员 %@ 给 %@ 服务员 %@ 以差评,请予以关注。", model.commenter, model.mcntName, model.waiter];
 }

 */

- (void)setModel:(JHBoss_NotificationReminderModel *)model
{
    _model = model;
    NSString *totalString = @"";
    self.timeLB.text = [NSString dateStr:self.model.time.stringValue];
    self.textLB.text = self.model.dataTitle;
    self.NewLB.hidden = self.model.readStatus.integerValue;
    switch (model.type) {
        case NotificationReminderTypeRestReceivedNegative:
        {
            
            if (model.reason.length > 0) {
                
                totalString = [NSString stringWithFormat:@"会员 %@ 给您的餐厅 %@ 新的投诉建议「 %@ 」请予以关注。", model.memberName, model.restaurantName,  model.reason];
            }else{
                totalString = [NSString stringWithFormat:@"会员 %@ 给您的餐厅 %@ 新的投诉建议,请予以关注。", model.memberName, model.restaurantName];
            }
        }
            break;
        case NotificationReminderTypeWiterReceivedNegative:
        {
            
            if (model.reason.length > 0) {
                
                 totalString = [NSString stringWithFormat:@"会员 %@ 给 %@ 服务员 %@ 以差评 %@ 请予以关注。", model.memberName, model.restaurantName, model.staffName, model.reason];
            }else{
                
                totalString = [NSString stringWithFormat:@"会员 %@ 给 %@ 服务员 %@ 以差评,请予以关注。", model.memberName, model.restaurantName, model.staffName];
            }
        }
            break;
        case NotificationReminderTypeOrderAbnormal:
        {
            totalString = [NSString stringWithFormat:@"餐厅 %@ 订单号为 %@ 的订单发生异常情况为 %@ 请予以关注。", model.restaurantName, model.orderNumber, model.reason];
        }
            break;
        case NotificationReminderTypeNoNote:
        {
            totalString = [NSString stringWithFormat:@"%@", model.reason];
        }
            break;
        default:
            break;
    }
    
    [self setTotalString:totalString withModel:model];
}

@end
