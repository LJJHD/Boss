//
//  JHBoss_HomeOrderAbnormalView.m
//  Boss
//
//  Created by jinghankeji on 2017/6/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_HomeOrderAbnormalView.h"

@interface JHBoss_HomeOrderAbnormalView ()
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;
@property (weak, nonatomic) IBOutlet UILabel *orderTurnoverNumLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTurnoverPercentLab;
@property (weak, nonatomic) IBOutlet UIButton *badCommentBtn;
@property (weak, nonatomic) IBOutlet UILabel *badCommentNumLab;
@property (weak, nonatomic) IBOutlet UILabel *badCommentTunoverPercentLab;
@property (weak, nonatomic) IBOutlet UIButton *leftTapBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightTapBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTurnoverRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badCommentRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLineViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *middleLineViewRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badCommentHConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badCommentWconstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OrderTunoverWConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OrderTunoverHconstraint;
@end

@implementation JHBoss_HomeOrderAbnormalView

-(void)awakeFromNib{

    [super awakeFromNib];
    
    if (DEF_WIDTH <= 320) {
        
        _orderTurnoverNumLab.font = DEF_SET_FONT(17);
        _badCommentNumLab.font = DEF_SET_FONT(17);
    }
    
    
    self.OrderTunoverHconstraint.constant = MYDIMESCALE(60);
    self.OrderTunoverWConstraint.constant = MYDIMESCALE(60);
    self.badCommentHConstraint.constant = MYDIMESCALE(60);
    self.badCommentWconstraint.constant = MYDIMESCALE(60);
    
     _orderBtn.imageRect = CGRectMake((MYDIMESCALE(60) - 34.6)/2, 0, 34.6, 35);
     _orderBtn.titleRect = CGRectMake(0, 43.5, MYDIMESCALE(60), 12);
     _orderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
   
   
    _badCommentBtn.imageRect = CGRectMake((MYDIMESCALE(60) - 34.6)/2, 0, 34.6, 35);
    _badCommentBtn.titleRect = CGRectMake(0, 43.5, MYDIMESCALE(60), 12);
    _badCommentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

    
}
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_HomeOrderAbnormalView" owner:self options:nil]objectAtIndex:0];
    }
  
    return self;
}

-(void)leftPicture:(NSString *)leftPic rightPic:(NSString *)rightPic leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle{

    [_orderBtn setimage:leftPic];
    [_orderBtn setTitle:leftTitle];

    [_badCommentBtn setimage:rightPic];
    [_badCommentBtn setTitle:rightTitle];

}

-(void)setModel:(JHBoss_MerchatBusinessDataModel *)model{

    _orderTurnoverNumLab.text = model.exceptionOrderNum.stringValue;
    if ([[model.rateOfLastTime substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"]) {
        
        _orderTurnoverPercentLab.text = model.rateOfLastTime;
        _orderTurnoverPercentLab.textColor =  DEF_COLOR_6E6E6E;
    } else if(model.rateOfLastTime.doubleValue > 0) {
        
        _orderTurnoverPercentLab.text = [@"+" stringByAppendingString:DEF_OBJECT_TO_STIRNG(model.rateOfLastTime)];
        _orderTurnoverPercentLab.textColor = DEF_COLOR_FF4747;
    }else{
    
        _orderTurnoverPercentLab.text = model.rateOfLastTime;
        _orderTurnoverPercentLab.textColor =  DEF_COLOR_6E6E6E;
    }

    
    
    _badCommentNumLab.text = model.negativeNum.stringValue;
   
    if ([[model.rateOfNegative substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"]) {
         _badCommentTunoverPercentLab.text = model.rateOfNegative;
        _badCommentTunoverPercentLab.textColor = DEF_COLOR_6E6E6E;
    } else if (model.rateOfNegative.doubleValue > 0) {
       
        _badCommentTunoverPercentLab.text = [@"+" stringByAppendingString:DEF_OBJECT_TO_STIRNG(model.rateOfNegative) ];
        _badCommentTunoverPercentLab.textColor = DEF_COLOR_FF4747;
    }else{
    
        _badCommentTunoverPercentLab.text = model.rateOfNegative;
        _badCommentTunoverPercentLab.textColor = DEF_COLOR_6E6E6E;
    }
}

-(void)setClientFlowModel:(JHBoss_MerchatBusinessDataModel *)clientFlowModel{

    _orderTurnoverNumLab.text = clientFlowModel.passengerFlow.stringValue;
    
    if (clientFlowModel.rateOfPassengerFlow.doubleValue > 0) {
        
        _orderTurnoverPercentLab.text = [NSString stringWithFormat:@"+%g%%",clientFlowModel.rateOfPassengerFlow.doubleValue * 100];

    }else{
        
        _orderTurnoverPercentLab.text = [NSString stringWithFormat:@"%g%%",clientFlowModel.rateOfPassengerFlow.doubleValue * 100];
    }
    _orderTurnoverPercentLab.textColor = clientFlowModel.rateOfPassengerFlow.doubleValue > 0 ? DEF_COLOR_FF4747 : DEF_COLOR_6E6E6E;
    
    
    
    _badCommentNumLab.text = [NSString stringWithFormat:@"%.2f",clientFlowModel.perPassergerPrice / 100];
    if (clientFlowModel.rateOfPerPassergerPrice.doubleValue > 0) {
        
        _badCommentTunoverPercentLab.text = [NSString stringWithFormat:@"+%g%%",clientFlowModel.rateOfPerPassergerPrice.doubleValue * 100];

    }else{
    
        
        _badCommentTunoverPercentLab.text = [NSString stringWithFormat:@"%g%%",clientFlowModel.rateOfPerPassergerPrice.doubleValue * 100];

    }
     _badCommentTunoverPercentLab.textColor = clientFlowModel.rateOfPerPassergerPrice.doubleValue > 0 ? DEF_COLOR_FF4747 : DEF_COLOR_6E6E6E;
}

- (IBAction)orderTurnoverHandler:(UIButton *)sender {
    
    if (self.orderTurnoverBlock) {
        self.orderTurnoverBlock();
    }
}
- (IBAction)badCommentHandler:(UIButton *)sender {
    
    if (self.badCommentBlock) {
        self.badCommentBlock();
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
