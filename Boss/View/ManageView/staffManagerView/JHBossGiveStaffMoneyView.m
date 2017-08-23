//
//  JHBossGiveStaffMoneyView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBossGiveStaffMoneyView.h"
@interface JHBossGiveStaffMoneyView ()
@property (weak, nonatomic) IBOutlet UIImageView *staffPictureImageV;

@property (weak, nonatomic) IBOutlet UILabel *staffNameLab;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *middBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomLeftBtn;
@property (weak, nonatomic) IBOutlet UIButton *bottomMiddBtn;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UIButton *surePayBtn;

@property (weak, nonatomic) IBOutlet UIView *moneyBackgroundView;
@property (nonatomic, strong) UIButton *currentTapBtn;
@end

@implementation JHBossGiveStaffMoneyView

-(void)awakeFromNib{

    [super awakeFromNib];
    
    _leftBtn.layer.borderWidth = 1;
    _leftBtn.layer.borderColor = DEF_COLOR_CDA265.CGColor;
    _leftBtn.selected = YES;
    _leftBtn.tag = 100000;
    _currentTapBtn = _leftBtn;
    
    _middBtn.layer.borderWidth = 1;
    _middBtn.tag = 100001;
    _middBtn.layer.borderColor = DEF_COLOR_D7D7D7.CGColor;

    _rightBtn.layer.borderWidth = 1;
    _rightBtn.tag = 100002;
    _rightBtn.layer.borderColor = DEF_COLOR_D7D7D7.CGColor;
    
    _bottomLeftBtn.layer.borderWidth = 1;
    _bottomLeftBtn.tag = 100003;
    _bottomLeftBtn.layer.borderColor = DEF_COLOR_D7D7D7.CGColor;
    
    _bottomMiddBtn.layer.borderWidth = 1;
    _bottomMiddBtn.tag = 100004;
    _bottomMiddBtn.layer.borderColor = DEF_COLOR_D7D7D7.CGColor;

    _surePayBtn.layer.cornerRadius = 20;
    _surePayBtn.layer.masksToBounds = YES;
    [_surePayBtn setTitle:[@"确定打赏 " stringByAppendingString:_leftBtn.titleLabel.text]];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_GiveMoneyStaffView" owner:self options:nil]objectAtIndex:0];
    }
   
    return self;
}
- (IBAction)tapLeftBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
     [self configurantionBtn:sender];
    
}
- (IBAction)tapMiddBtn:(UIButton *)sender {
     sender.selected = !sender.selected;
     [self configurantionBtn:sender];
}
- (IBAction)tapRightBtn:(UIButton *)sender {
     sender.selected = !sender.selected;
    [self configurantionBtn:sender];
}

- (IBAction)tapBtnHandler:(UIButton *)sender {
     sender.selected = !sender.selected;
    [self configurantionBtn:sender];
}


-(void)configurantionBtn:(UIButton *)sender{

    _currentTapBtn = sender;
   [_surePayBtn setTitle:[@"确定打赏 " stringByAppendingString:sender.titleLabel.text]];
    
    for (UIButton *btn in self.moneyBackgroundView.subviews) {
        
        if (btn != sender) {
            
            btn.selected = NO;
            btn.layer.borderColor = DEF_COLOR_D7D7D7.CGColor;
        }
        
    }
    
     sender.layer.borderColor = sender.selected ? DEF_COLOR_CDA265.CGColor : DEF_COLOR_D7D7D7.CGColor;
}

- (IBAction)surePayHandler:(UIButton *)sender {
    
    if (!_currentTapBtn.selected ) {
        
        [JHUtility showToastWithMessage:@"请输入或选择打赏金额"];
        return;
    }
    
    int btnTag = (int)_currentTapBtn.tag - 100000;
    JHBoss_rewardMoneyListModel *model = self.rewardMoneyArr[btnTag];
    if (self.payBlock) {
        self.payBlock(model.ID.stringValue);
    }
    
}


-(void)setRewardMoneyArr:(NSMutableArray<JHBoss_rewardMoneyListModel *> *)rewardMoneyArr{

    _rewardMoneyArr = rewardMoneyArr;
    
    NSArray *btnArr = @[_leftBtn,_middBtn,_rightBtn,_bottomLeftBtn,_bottomMiddBtn];
    
    [rewardMoneyArr enumerateObjectsUsingBlock:^(JHBoss_rewardMoneyListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        DPLog(@"idx===%lu",(unsigned long)idx);
        UIButton *btn = btnArr[idx];
        
        [btn setTitle:[NSString stringWithFormat:@"￥%.2f",obj.amount]];
    }];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
