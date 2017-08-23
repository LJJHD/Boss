//
//  JHBoss_OrderDetailFoodView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderDetailFoodView.h"

@interface JHBoss_OrderDetailFoodView ()
@property (weak, nonatomic) IBOutlet UILabel *payMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *needPayMoneyLab;
@property (weak, nonatomic) IBOutlet UITextField *jianTF;//减
@property (weak, nonatomic) IBOutlet UITextField *discountTF;//折扣
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;//减免button
@property (weak, nonatomic) IBOutlet UILabel *consumeLB;//已消费或总计
@property (weak, nonatomic) IBOutlet UILabel *needPayIdentificationLB;//应支付标识
@property (weak, nonatomic) IBOutlet UILabel *discoutLB;//优惠金额支付成功显示

@end

@implementation JHBoss_OrderDetailFoodView


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
    self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_OrderDetailFoodView" owner:self options:nil]objectAtIndex:0];
    }
    
    if (DEF_WIDTH <= 320) {
        
        _jianTF.font = [UIFont systemFontOfSize:12];
        _discountTF.font = [UIFont systemFontOfSize:12];
    }
    
    _jianTF.layer.borderColor = DEF_COLOR_D7D7D7.CGColor;
    _jianTF.layer.borderWidth = 1;
    _jianTF.layer.cornerRadius = 4;
    _jianTF.layer.masksToBounds = YES;
    
    _discountTF.layer.borderColor = DEF_COLOR_D7D7D7.CGColor;
    _discountTF.layer.borderWidth = 1;
    _discountTF.layer.cornerRadius = 4;
    _discountTF.layer.masksToBounds = YES;
    
    _sureBtn.layer.borderWidth = 1;
    _sureBtn.layer.borderColor = DEF_COLOR_RGB_A(180, 134, 69, 0.3).CGColor;
    _sureBtn.layer.cornerRadius = 4;
    _sureBtn.layer.masksToBounds = YES;
    
    
    @weakify(self);
    [_jianTF.rac_textSignal subscribeNext:^(NSString *text) {
        @strongify(self);
        
        if (text.length > 0 && text != nil) {
            
            if ([text rangeOfString:@".."].location != NSNotFound) {
                
                NSArray *parts = [text componentsSeparatedByString:@".."];
                text = [parts.firstObject stringByAppendingString:@"."];
                self.jianTF .text = text;
            }else if ([[text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]){
            
                self.jianTF.text = @"";
                return ;
            }else if ([text floatValue] > self.needPayMoney){
            
                [JHUtility showToastWithMessage:@"减免金额大于消费金额"];
                
                if ([text floatValue] > 10.00) {
                    //输入的价格为10位数以上
                  self.jianTF.text = [text substringWithRange:NSMakeRange(0, text.length - 1)];
                }else{
                
                  self.jianTF.text = @"";
                }
              
                return;
            }
            
            if (self.needPayMoney <= 0) {
                
                return ;
            }
            
            float result =  (self.needPayMoney - [text doubleValue])/self.needPayMoney;
            result = roundf(result *100)/100;
            self.discountTF.text = [NSString stringWithFormat:@"%.1f",result*10];
            self.needPayMoneyLab.text = [self isPureInt:[NSString stringWithFormat:@"￥ %.2lf",(self.needPayMoney - [text floatValue])]];
            [self.sureBtn setTitle:@"确定"];
            
            //给已消费添加中划线
            [self setconsumedLabel:[NSString stringWithFormat:@"%f",result]];
        }else{
        
             self.discountTF.text = @"";
             [self.sureBtn setTitle:@"减免"];
            NSString *realPay = [NSString stringWithFormat:@"%.2lf",[self.orderListModel.realPay floatValue]/100.0];
            self.needPayMoneyLab.text = [@"￥" stringByAppendingString:[self isPureInt: realPay]];
            //给已消费去掉中划线
            [self setconsumedLabel:@""];
        }
        
    }];
    
    [_discountTF.rac_textSignal subscribeNext:^(id x) {
        @strongify(self);
        NSString *text = x;
        
        if (text.length > 0 && text != nil) {
            
            if ([text rangeOfString:@".."].location != NSNotFound) {
                
                NSArray *parts = [text componentsSeparatedByString:@".."];
                text = [parts.firstObject stringByAppendingString:@"."];
                self.discountTF.text = text;
            }else if ([[text substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"."]){
                
                self.discountTF.text = @"";
                return ;
            }
            
            //已消费金额小于等于0 不进行技术
            if (self.needPayMoney <= 0) {
                
                return ;
            }
                
            if ([text floatValue] > 10.0 || [text floatValue] < 0 ){
            
                [JHUtility showToastWithMessage:@"无效折扣,范围为0~10"];
                self.discountTF.text = [text substringWithRange:NSMakeRange(0, 1)];
                return;
            }

            float CreditAmount = self.needPayMoney * ([text floatValue]/10.0);
            float result = self.needPayMoney - CreditAmount;
            
            result = roundf(result *100)/100;
            [self.sureBtn setTitle:@"确定"];
            self.jianTF.text = [NSString stringWithFormat:@"%.2f",result];
            self.needPayMoneyLab.text = [self isPureInt:[NSString stringWithFormat:@"￥ %.2lf",(self.needPayMoney - result)]];
            //给已消费添加中划线
            [self setconsumedLabel:[NSString stringWithFormat:@"%f",result]];
        }else{
            
            [self.sureBtn setTitle:@"减免"];
            NSString *realPay = [NSString stringWithFormat:@"%.2lf",[self.orderListModel.realPay floatValue]/100.0];
            self.needPayMoneyLab.text = [@"￥" stringByAppendingString:[self isPureInt: realPay]];
            self.jianTF.text = @"";
            //给已消费去掉中划线
            [self setconsumedLabel:@""];
        }
       
    }];
    
    return self;
}


/**
 订单没有打过折，点击折扣 对已消费label添加中划线穿透
 */
-(void)setconsumedLabel:(NSString *)price{
    
    //已打过折的不用进行设置
    if (_orderListModel.state == 1 && [_orderListModel.decrease floatValue] > 0) {
        return;
    }
    
     NSString *consumeMoneyStr = [NSString stringWithFormat:@"%.2lf",[DEF_OBJECT_TO_STIRNG(_orderListModel.consumedMoney) integerValue] / 100.0 ];
    if (price.length > 0) {
        
        NSString *consumeAttriStr = [NSString stringWithFormat:@"¥%@",consumeMoneyStr];
        NSMutableAttributedString *needPayMoney = [[NSMutableAttributedString alloc] initWithString:consumeAttriStr];
        
        [needPayMoney addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, needPayMoney.length)];
        _payMoneyLab.attributedText = needPayMoney;
        
    }else{
        
        _payMoneyLab.text = [@"￥" stringByAppendingString:[self isPureInt:consumeMoneyStr]];
    }
}


- (IBAction)discountHandle:(UIButton *)sender {
    
    if (self.jianTF.text.length <= 0 ) {
        //减免金额可以为零
        [JHUtility showToastWithMessage:@"请减免金额或折扣"];
        return;
    }
    
//    else if ([self.jianTF.text floatValue] <= 0){
//    减免金额可以为零
//        [JHUtility showToastWithMessage:@"无效减免金额"];
//        return;
//    }
    
    float money = [self.jianTF.text floatValue];
      money = roundf(money *100)/100;
      //转成分
      money = money *100;
    
    if (money > self.needPayMoney * 100) {
        
        [JHUtility showToastWithMessage:@"减免金额大于消费金额"];
        return;
    }

    NSString *resultMoney = [NSString stringWithFormat:@"%.0lf",money];
    if (self.discountBlock) {
        self.discountBlock(resultMoney, self.discountTF.text);
    }
}

-(void)setOrderListModel:(JHBoss_OrderListModel *)orderListModel{

    _orderListModel = orderListModel;
    self.needPayMoney = [orderListModel.consumedMoney floatValue] / 100.0;
    
    if (orderListModel.state == 1) {
        
        self.discountBackgroundView.hidden = NO;
    }else if (orderListModel.state == 2 || orderListModel.state == 3 || orderListModel.state == 4){
    
        self.needPayIdentificationLB.text = @"已支付:";
        self.needPayBackGroundView.hidden = NO;
    }
    
    if (orderListModel.consumedMoney.length > 0) {
        
        NSString *consumeMoneyStr = [NSString stringWithFormat:@"%.2lf",[DEF_OBJECT_TO_STIRNG(orderListModel.consumedMoney) integerValue] / 100.0 ];
        
        if (orderListModel.state == 1 && [orderListModel.decrease floatValue] > 0) {
            
            NSString *consumeAttriStr = [NSString stringWithFormat:@"¥%@",consumeMoneyStr];
            NSMutableAttributedString *needPayMoney = [[NSMutableAttributedString alloc] initWithString:consumeAttriStr];
            
            [needPayMoney addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, needPayMoney.length)];
            _payMoneyLab.attributedText = needPayMoney;
            
        }else{
        
          _payMoneyLab.text = [@"￥" stringByAppendingString:[self isPureInt:consumeMoneyStr]];
            if (orderListModel.decrease.doubleValue > 0) {
                _discoutLB.hidden = NO;
                _discoutLB.text = [NSString stringWithFormat:@"优惠%g元",orderListModel.decrease.doubleValue/100];

            }
        }
    }

    NSString *realPay = [NSString stringWithFormat:@"%.2lf",[orderListModel.realPay floatValue]/100.0];
    _needPayMoneyLab.text = [@"￥" stringByAppendingString:[self isPureInt: realPay]];
    
    if ([orderListModel.decrease floatValue] > 0) {
        
        NSString *decrease = [NSString stringWithFormat:@"%.2lf",[orderListModel.decrease floatValue]/100.0];
        self.jianTF.text = [self isPureInt:decrease];
        
        float result =  (self.needPayMoney - [decrease floatValue])/self.needPayMoney;
        result = roundf(result *100)/100;
        self.discountTF.text = [NSString stringWithFormat:@"%.1f",result*10.0];
    }
}

//判断是否为整形：
- (NSString *)isPureInt:(NSString*)string{
    NSArray *priceArr = [string componentsSeparatedByString:@"."];
    NSString *intPrice = priceArr.firstObject;
    NSString *flotPrice = priceArr.lastObject;
    
    int appointPrice =  [flotPrice intValue];
    
    if (appointPrice > 1) {
        return string;
    }
    return intPrice;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
