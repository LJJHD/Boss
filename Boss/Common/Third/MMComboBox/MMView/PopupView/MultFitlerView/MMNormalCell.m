//
//  MMNormalCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMNormalCell.h"
#import "MMComboBoxHeader.h"
static const CGFloat horizontalMargin = 10.0f;
@interface MMNormalCell ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIImageView *selectedImageview;
@property (nonatomic, strong) CALayer *bottomLine;
@end

@implementation MMNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectedImageview.frame = CGRectMake(horizontalMargin, (self.height -16)/2, 16, 16);
    CGFloat leftSpace = self.selectedImageview.right + 20;
    self.title.frame = CGRectMake(leftSpace, 0, DEF_WIDTH - 2 * leftSpace, self.height);
    if (_item.subTitle != nil) {
        self.subTitle.frame = CGRectMake(self.width - horizontalMargin - 100 , 0, 100, self.height);
    }
    self.bottomLine.frame = CGRectMake(16, self.height - 1.0/MMScale , self.width - 32, 1.0/MMScale);
}

- (void)setItem:(MMItem *)item{
    _item = item;
    self.title.text = item.title;
    self.title.textColor = item.isSelected ? [UIColor colorWithHexString:titleSelectedColor] : DEF_COLOR_333339;
    if (item.subTitle != nil) {
        self.subTitle.text  = item.subTitle;
    }
//    self.backgroundColor = item.isSelected?[UIColor colorWithHexString:SelectedBGColor]:[UIColor colorWithHexString:UnselectedBGColor];
    self.selectedImageview.hidden = !item.isSelected;
    self.bottomLine.backgroundColor = item.isSelected ? DEF_COLOR_CDA265.CGColor : DEF_COLOR_ECECEC.CGColor;
}

#pragma mark - get
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = DEF_COLOR_333339;
        _title.font = [UIFont systemFontOfSize:MainTitleFontSize];
        [self addSubview:_title];
    }
    return _title;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = DEF_COLOR_333339;
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.font = [UIFont systemFontOfSize:SubTitleFontSize];
        [self addSubview:_subTitle];
    }
    return _subTitle;
}

- (UIImageView *)selectedImageview {
    if (!_selectedImageview) {
        _selectedImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_selected"]];
        [self addSubview:_selectedImageview];
    }
    return _selectedImageview;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = DEF_COLOR_ECECEC.CGColor;
        [self.layer addSublayer:_bottomLine];
    }
    return _bottomLine;
}
@end
