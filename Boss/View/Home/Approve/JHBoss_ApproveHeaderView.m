//
//  JHBoss_ApproveHeaderView.m
//  Boss
//
//  Created by sftoday on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ApproveHeaderView.h"

@interface JHBoss_ApproveHeaderView ()
@property (nonatomic, strong) NSArray *menuArray;
@property (nonatomic, strong) MenuButton *currentBtn;
@property (nonatomic, strong) UIView *bottomLine;
@property (nonatomic, assign) CGPoint menuBtnCenter;
@end


@implementation JHBoss_ApproveHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [self setupView];
        _itemFont = 15;
        _selectItemFont = _itemFont;
        
        _itemColor = DEF_COLOR_A1A1A1;
        _selectItemColor = DEF_COLOR_333339;
        _isShowBottonLine = YES;
        _bottomLineColor = DEF_COLOR_CDA265;
        _ViewBackgroundColor = [UIColor whiteColor];
        _ItemBackgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)setTabIndex:(NSNumber *)tabIndex {
    _tabIndex = tabIndex;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[MenuButton class]]) {
            MenuButton *button = (MenuButton *)view;
            if (button.index == tabIndex.integerValue) {
                [self menuBtnAction:button];
            }
        }
    }
}

- (void)setupView {
    self.backgroundColor = self.ViewBackgroundColor;
    
    for (NSInteger index = 0; index < self.menuArray.count; index++) {
        MenuButton *menuBtn = [self buttonWithTitle:self.menuArray[index]];
//        menuBtn.frame = CGRectMake(30 + index * (DEF_WIDTH/3 - 20), 0, DEF_WIDTH/3 - 20, 44);
        menuBtn.frame = CGRectMake(_leftSpace + index * ((DEF_WIDTH - _leftSpace - _rightSpace)/self.menuArray.count), 0, ((DEF_WIDTH - _leftSpace - _rightSpace)/self.menuArray.count), 44);
    
        menuBtn.index = index;
        index != 0 ? : [self menuBtnAction:menuBtn];
        if (!index) {
            self.menuBtnCenter =  menuBtn.center;
        }
        [menuBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:menuBtn];
    }
    
    if (_isShowBottonLine) {
        
        [self addSubview:self.bottomLine];
        self.bottomLine.centerX = self.menuBtnCenter.x;

    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 0.5, DEF_WIDTH, 0.5)];
    lineView.backgroundColor = DEF_COLOR_LINEVIEW;
    [self addSubview:lineView];
}

- (void)menuBtnAction:(MenuButton *)menuButton {
    _currentBtn.enabled = YES;
    _currentBtn.selected = NO;
    [_currentBtn setTitleColor:_itemColor forState:UIControlStateNormal];
    menuButton.selected = YES;
   
    _currentBtn = menuButton;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomLine.width = 20;
        self.bottomLine.centerX = menuButton.center.x;
    }];
    menuButton.enabled = NO;
    [menuButton setTitleColor:_selectItemColor forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(didSelectMenuBtn:)]) {
        [self.delegate didSelectMenuBtn:menuButton];
    }
    
}

- (MenuButton *)buttonWithTitle:(NSString *)title {
    MenuButton *button = [[MenuButton alloc] init];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:_itemColor forState:UIControlStateNormal];
    [button setTitleColor:_selectItemColor forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:_itemFont];
    button.backgroundColor = self.ItemBackgroundColor;
    
    return button;
}

- (UIView *)bottomLine
{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44 - 5, 20, 5)];
        _bottomLine.backgroundColor = DEF_COLOR_CDA265;
    }
    return _bottomLine;
}

- (NSArray *)menuArray {
    if (!_menuArray) {
//        _menuArray = [NSMutableArray array];
//        _menuArray = @[@"待审批",@"已通过",@"已拒绝"];
    }
    return _menuArray;
}

-(void)setIsShowBottonLine:(BOOL)isShowBottonLine{

    _isShowBottonLine = isShowBottonLine;
}

-(void)setItemArray:(NSMutableArray *)itemArray{

    _menuArray = [itemArray mutableCopy];
    
}

-(void)setLeftSpace:(float)leftSpace{

    if (leftSpace == 0) {
        leftSpace = 30;
    }
    _leftSpace = leftSpace;

}

-(void)setRightSpace:(float)rightSpace{

    if (rightSpace == 0) {
        rightSpace = 30;
    }
    _rightSpace = rightSpace;
}

-(void)setSelectItemColor:(UIColor *)selectItemColor{

    _selectItemColor = selectItemColor;
}

-(void)setItemColor:(UIColor *)itemColor{

    _itemColor = itemColor;
}

-(void)setSelectItemFont:(float)selectItemFont{

    _selectItemFont = selectItemFont;
}

-(void)setItemFont:(float)itemFont{

    _itemFont = itemFont;
}

-(void)setItemBackgroundColor:(UIColor *)ItemBackgroundColor{

    _ItemBackgroundColor = ItemBackgroundColor;
}


-(void)setViewBackgroundColor:(UIColor *)ViewBackgroundColor{

    _ViewBackgroundColor = ViewBackgroundColor;
}


-(void)setBottomLineColor:(UIColor *)bottomLineColor{

    _bottomLineColor = bottomLineColor;
}

-(void)showApproveHeaderView{

    [self setupView];

}



@end

@implementation MenuButton
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
@end
