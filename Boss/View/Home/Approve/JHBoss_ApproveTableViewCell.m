//
//  JHBoss_ApproveTableViewCell.m
//  Boss
//
//  Created by sftoday on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ApproveTableViewCell.h"

@interface JHBoss_ApproveTableViewCell ()

@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *headerLineView;
@property (nonatomic, strong) UILabel *headerLB;
@property (nonatomic, strong) UIView *headerLine;
@property (nonatomic, strong) UILabel *approvedDescLB;
@property (nonatomic, strong) UILabel *approvedLB;
@property (nonatomic, strong) UILabel *belongToDescLB;
@property (nonatomic, strong) UILabel *belongToLB;
@property (nonatomic, strong) UILabel *itemDescLB;
@property (nonatomic, strong) UILabel *itemLB;
@property (nonatomic, strong) UILabel *suppleDescLB;
@property (nonatomic, strong) UILabel *suppleLB;
@property (nonatomic, strong) UILabel *reasonDescLB;
@property (nonatomic, strong) YYLabel *reasonLB;
@property (nonatomic, strong) YYTextLayout *reasonText;
@property (nonatomic, strong) UIView *footerLine;
@property (nonatomic, strong) UIButton *refuseBtn;
@property (nonatomic, strong) UIButton *consentBtn;

@property (nonatomic, strong) UIView *lineView;

@end


@implementation JHBoss_ApproveTableViewCell

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
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.mas_equalTo(38);
    }];
    
    _headerLineView = [[UIView alloc] init];
    _headerLineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.whiteView addSubview:self.headerLineView];
    [_headerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    _headerLB = [[UILabel alloc] init];
    _headerLB.font = DEF_SET_FONT(14);
    _headerLB.textColor = DEF_COLOR_333339;
    [self.whiteView addSubview:self.headerLB];
    [_headerLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.5);
        make.left.mas_equalTo(14);
    }];
    
    _headerLine = [[UIView alloc] init];
    _headerLine.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.whiteView addSubview:self.headerLine];
    [_headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(39);
        make.height.mas_equalTo(0.5);
    }];
    
    _approvedDescLB = [[UILabel alloc] init];
    _approvedDescLB.font = DEF_SET_FONT(13);
    _approvedDescLB.textColor = DEF_COLOR_333339;
    [self.whiteView addSubview:self.approvedDescLB];
    [_approvedDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerLine.mas_bottom).with.offset(8);
        make.left.mas_equalTo(14);
    }];
    
    _approvedLB = [[UILabel alloc] init];
    _approvedLB.font = DEF_SET_FONT(13);
    _approvedLB.textColor = DEF_COLOR_B48645;
    [self.whiteView addSubview:self.approvedLB];
    [_approvedLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.approvedDescLB);
        make.left.equalTo(self.approvedDescLB.mas_right).with.offset(6);
    }];
    
    _belongToDescLB = [[UILabel alloc] init];
    _belongToDescLB.font = DEF_SET_FONT(13);
    _belongToDescLB.textColor = DEF_COLOR_333339;
    [self.whiteView addSubview:self.belongToDescLB];
    [_belongToDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.approvedDescLB.mas_bottom).with.offset(4);
        make.left.mas_equalTo(14);
    }];
    
    _belongToLB = [[UILabel alloc] init];
    _belongToLB.font = DEF_SET_FONT(13);
    _belongToLB.textColor = DEF_COLOR_B48645;
    [self.whiteView addSubview:self.belongToLB];
    [_belongToLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.belongToDescLB);
        make.left.equalTo(self.belongToDescLB.mas_right).with.offset(6);
    }];
    
    _itemDescLB = [[UILabel alloc] init];
    _itemDescLB.font = DEF_SET_FONT(13);
    _itemDescLB.textColor = DEF_COLOR_333339;
    [self.whiteView addSubview:self.itemDescLB];
    [_itemDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.belongToDescLB.mas_bottom).with.offset(4);
        make.left.mas_equalTo(14);
    }];
    
    _itemLB = [[UILabel alloc] init];
    _itemLB.font = DEF_SET_FONT(13);
    _itemLB.textColor = DEF_COLOR_B48645;
    [self.whiteView addSubview:self.itemLB];
    [_itemLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.itemDescLB);
        make.left.equalTo(self.itemDescLB.mas_right).with.offset(6);
    }];
    
    _suppleDescLB = [[UILabel alloc] init];
    _suppleDescLB.font = DEF_SET_FONT(13);
    _suppleDescLB.textColor = DEF_COLOR_333339;
    [self.whiteView addSubview:self.suppleDescLB];
    [_suppleDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.itemDescLB.mas_bottom).with.offset(4);
        make.left.mas_equalTo(14);
    }];
    
    _suppleLB = [[UILabel alloc] init];
    _suppleLB.font = DEF_SET_FONT(13);
    _suppleLB.textColor = DEF_COLOR_B48645;
    [self.whiteView addSubview:self.suppleLB];
    [_suppleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.suppleDescLB);
        make.left.equalTo(self.suppleDescLB.mas_right).with.offset(6);
    }];
    
    _reasonDescLB = [[UILabel alloc] init];
    _reasonDescLB.font = DEF_SET_FONT(13);
    _reasonDescLB.textColor = DEF_COLOR_333339;
    _reasonDescLB.textAlignment = NSTextAlignmentJustified;
    [self.whiteView addSubview:self.reasonDescLB];
    [_reasonDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.suppleDescLB.mas_bottom).with.offset(4);
        make.left.mas_equalTo(14);
        make.width.mas_equalTo(54);
        make.height.mas_equalTo(16);
    }];
    
    _reasonLB = [[YYLabel alloc] init];
    _reasonLB.font = DEF_SET_FONT(13);
    _reasonLB.textColor = DEF_COLOR_B48645;
    _reasonLB.lineBreakMode = NSLineBreakByWordWrapping;
    _reasonLB.numberOfLines = 0;
    [self.whiteView addSubview:self.reasonLB];
    [_reasonLB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.reasonDescLB).with.offset(1);
        make.left.equalTo(self.reasonDescLB.mas_right).with.offset(6);
        make.right.mas_lessThanOrEqualTo(-16);
        make.bottom.mas_greaterThanOrEqualTo(-50);
    }];
    
    _footerLine = [[UIView alloc] init];
    _footerLine.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.whiteView addSubview:self.footerLine];
    [_footerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-45);
        make.height.mas_equalTo(0.5);
    }];
    
    _consentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_consentBtn setTitle:@"同意"];
    _consentBtn.titleLabel.font = DEF_SET_FONT(14);
    [_consentBtn setTitleColor:DEF_COLOR_965800 forState:UIControlStateNormal];
    _consentBtn.layer.cornerRadius = 4;
    _consentBtn.layer.masksToBounds = YES;
    _consentBtn.layer.borderWidth = 1;
    _consentBtn.layer.borderColor = DEF_COLOR_B48645.CGColor;
    [self.whiteView addSubview:self.consentBtn];
    [_consentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(75, 25));
    }];
    
    [[_consentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.rightAction) {
            self.rightAction();
        }
    }];
    
    _refuseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refuseBtn setTitle:@"拒绝"];
    _refuseBtn.titleLabel.font = DEF_SET_FONT(14);
    [_refuseBtn setTitleColor:DEF_COLOR_CDA265 forState:UIControlStateNormal];
    _refuseBtn.layer.cornerRadius = 4;
    _refuseBtn.layer.masksToBounds = YES;
    _refuseBtn.layer.borderWidth = 1;
    _refuseBtn.layer.borderColor = DEF_COLOR_B48645.CGColor;
    [self.whiteView addSubview:self.refuseBtn];
    [_refuseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.equalTo(self.consentBtn.mas_left).with.offset(-10);
        make.bottom.mas_equalTo(self.consentBtn);
        make.size.mas_equalTo(CGSizeMake(75, 25));
    }];
    
    [[_refuseBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (self.leftAction) {
            self.leftAction();
        }
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self.contentView addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    self.approvedDescLB.text = @"请假员工";
    self.belongToDescLB.text = @"所属店铺";
    self.itemDescLB.text = @"请假日期";
    self.suppleDescLB.text = @"请假天数";
    self.reasonDescLB.text = @"请假理由";
}

- (void)setDisplayType:(NSInteger)displayType
{
    _displayType = displayType;
    self.refuseBtn.hidden = displayType;
    self.consentBtn.hidden = displayType;
    self.footerLine.hidden = displayType;
    
    switch (displayType) {
        case 0:
        {
            [_reasonDescLB mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_lessThanOrEqualTo(-50);
            }];
            
            [_reasonLB mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_lessThanOrEqualTo(-50);
            }];
        }
            break;
        case 1:
        case 2:
        {
            [_reasonDescLB mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_lessThanOrEqualTo(-8);
            }];
            
            [_reasonLB mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_lessThanOrEqualTo(-8);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)setApproveType:(ApproveType)approveType
{
    @weakify(self);
    _approveType = approveType;
    switch (approveType) {
        case ApproveTypeLeave:
        {
            self.approvedDescLB.text = @"请假员工";
            self.belongToDescLB.text = @"所属店铺";
            self.itemDescLB.text = @"请假日期";
            self.suppleDescLB.text = @"请假天数";
            self.reasonDescLB.text = @"请假理由";
            _itemDescLB.hidden = NO;
            _itemLB.hidden = NO;
            
            [_suppleDescLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.equalTo(self.itemDescLB.mas_bottom).with.offset(4);
                make.left.mas_equalTo(14);
            }];
        }
            break;
        case ApproveTypeDiscount:
        {
            self.approvedDescLB.text = @"申请员工";
            self.belongToDescLB.text = @"所属店铺";
            self.suppleDescLB.text = @"申请项目";
            self.reasonDescLB.text = @"申请原因";
            _itemDescLB.hidden = YES;
            _itemLB.hidden = YES;
            
            [_suppleDescLB mas_remakeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.top.equalTo(self.belongToDescLB.mas_bottom).with.offset(4);
                make.left.mas_equalTo(14);
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)setModel:(JHBoss_ApproveModel *)model
{
    _model = model;
    self.timeLB.text = model.submitDate;
    self.headerLB.text = model.title;
    self.approvedLB.text = model.staffName;
    self.belongToLB.text = model.restaurantName;
    self.suppleLB.text = model.approvalType == 1 ? model.leaveDays : model.applyProject;
    self.approveType = model.approvalType;
    
    if (model.leaveStart && model.leaveEnd) {
        self.itemLB.text = [NSString stringWithFormat:@"%@ 至 %@", model.leaveStart, model.leaveEnd];
        NSMutableAttributedString *itemAttributedString = [[NSMutableAttributedString alloc] initWithString:_itemLB.text];
        [itemAttributedString addAttribute:NSForegroundColorAttributeName value:DEF_COLOR_333339 range:NSMakeRange(model.leaveStart.length + 1, 1)];
        _itemLB.attributedText = itemAttributedString;
    } else {
        self.itemLB.text = @"";
    }
    
    if (model.reason) {
        NSMutableAttributedString *total = [NSMutableAttributedString new];
        [total yy_appendString:model.reason];
        total.yy_font = [UIFont systemFontOfSize:13];
        total.yy_color = DEF_COLOR_B48645;
        total.yy_lineSpacing = 4;
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(DEF_WIDTH - 36 - _reasonDescLB.width, 9999)];
        container.maximumNumberOfRows = 9999;
        _reasonText = [YYTextLayout layoutWithContainer:container text:total];
        _reasonLB.textLayout = _reasonText;
        @weakify(self);
        [_reasonLB mas_updateConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.height.mas_equalTo(self.reasonLB.textLayout.textBoundingSize.height);
        }];
    } else {
        _reasonLB.text = @"";
    }
    
}


@end
