//
//  JHBoss_OrderManagerTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderManagerTableViewCell.h"

@interface JHBoss_OrderManagerTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;//订单号
@property (weak, nonatomic) IBOutlet UILabel *payStauteLab;

@property (weak, nonatomic) IBOutlet UILabel *tableNumLab;
@property (weak, nonatomic) IBOutlet UILabel *pepoleNumLab;
@property (weak, nonatomic) IBOutlet UILabel *memberNumLab;
@property (weak, nonatomic) IBOutlet UILabel *memberGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashierLab;//收银员
@property (weak, nonatomic) IBOutlet UILabel *waiterLab;//服务员
@property (weak, nonatomic) IBOutlet UILabel *beginTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@end

@implementation JHBoss_OrderManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _topLineView.backgroundColor = DEF_COLOR_ECECEC;
    
    _payStauteLab.layer.cornerRadius = 3;
    _payStauteLab.layer.masksToBounds = YES;
    _payStauteLab.backgroundColor = DEF_COLOR_RGB(238, 177, 30);
    
//    if (DEF_WIDTH < 375) {
//        
//        _orderNumLab.font = DEF_SET_FONT(12);
//    }
    
}

-(void)setOrderListModel:(JHBoss_OrderListModel *)orderListModel{
    //开台时间和支付时间字体大小
    int font = 14;
    if (DEF_WIDTH < 375) {
        font = 11;
    }
    
    int orderNumFont;
    if (DEF_WIDTH > 375) {
        
        orderNumFont = 15;
    }else if (DEF_WIDTH > 320 && DEF_WIDTH <= 375){
    
        orderNumFont = 14;
    }else {
    
        orderNumFont = 12;
    }

    _orderListModel = orderListModel;
     NSString *orderNumber =  DEF_OBJECT_TO_STIRNG(orderListModel.number);
    NSMutableAttributedString *attrOrderNumStr = [[NSMutableAttributedString alloc]init];
    [attrOrderNumStr appendAttributedString:[JHUtility getAttributedStringWithString:@"订单号: " font:DEF_WIDTH <= 375 ? 14 : 15 textColor:DEF_COLOR_RGB(110, 110, 110)]];
    [attrOrderNumStr appendAttributedString:[JHUtility getAttributedStringWithString:orderNumber font:orderNumFont textColor:DEF_COLOR_RGB(110, 110, 110)]];
    _orderNumLab.attributedText = attrOrderNumStr;
    
    
    NSString *payStaute;
    UIColor *stauteBackG;
    if (orderListModel.state == 1) {
        
       payStaute = @"待支付";
      stauteBackG = DEF_COLOR_RGB(238, 177, 30);
    }else if (orderListModel.state == 2){
    
       payStaute = @"支付中";
     stauteBackG = DEF_COLOR_RGB(161, 161, 161);
    }else if (orderListModel.state == 3){
        
       payStaute = @"已支付";
    stauteBackG = DEF_COLOR_RGB(95, 172, 18);
    }else if (orderListModel.state == 4){
        
        payStaute = @"支付失败";
        stauteBackG = DEF_COLOR_RGB(215, 215, 215);
    }else{
    
        payStaute = @"未知";
        stauteBackG = [UIColor redColor];
    }
    
    _payStauteLab.text = payStaute;
    _payStauteLab.backgroundColor = stauteBackG;
    [_payStauteLab sizeToFit];
    
    NSString *tableNumber = DEF_OBJECT_TO_STIRNG(orderListModel.tableNumber);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"桌号 "];
    [attrStr appendAttributedString:[JHUtility getAttributedStringWithString:tableNumber font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _tableNumLab.attributedText = attrStr;
    
    
    NSMutableAttributedString *peopleNumStr = [[NSMutableAttributedString alloc]initWithString:@"人数 "];
    [peopleNumStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%ld",orderListModel.peopleNum] font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
    [peopleNumStr appendAttributedString:[JHUtility getAttributedStringWithString:@"人" font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _pepoleNumLab.attributedText = peopleNumStr;
    
    
    
    NSMutableAttributedString *memberNumStr = [[NSMutableAttributedString alloc]init];
    [memberNumStr appendAttributedString:[JHUtility getAttributedStringWithString:@"会员号 " font:14 textColor:DEF_COLOR_RGB(91, 91, 91)]];
    [memberNumStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%@",orderListModel.memberId] font:font textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _memberNumLab.attributedText = memberNumStr;

    NSMutableAttributedString *memberGradeStr = [[NSMutableAttributedString alloc]initWithString:@"会员等级 "];
    [memberGradeStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%@",orderListModel.memberLevel] font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _memberGradeLabel.attributedText = memberGradeStr;
    
    
    
     NSString *cashier = DEF_OBJECT_TO_STIRNG(orderListModel.cashier);
    NSMutableAttributedString *cashierStr = [[NSMutableAttributedString alloc]initWithString:@"收银员 "];
    [cashierStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%@",cashier] font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _cashierLab.attributedText = cashierStr;
    
    
    NSMutableAttributedString *waiterStr = [[NSMutableAttributedString alloc]initWithString:@"服务员 "];
    
    if (isObjNotEmpty(orderListModel.waiterList) && orderListModel.waiterList.count > 0) {
        
        for (WaiterList *waiterModel in orderListModel.waiterList) {
            
            [waiterStr appendAttributedString:[JHUtility getAttributedStringWithString:waiterModel.name font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
        }
        
    }
    _waiterLab.attributedText = waiterStr;
    
    
    NSMutableAttributedString *beginTimeStr = [[NSMutableAttributedString alloc]init];
    [beginTimeStr appendAttributedString:[JHUtility getAttributedStringWithString:@"开台时间 " font:14 textColor:DEF_COLOR_RGB(91, 91, 91)]];
    [beginTimeStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%@",orderListModel.openTime] font:font textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _beginTimeLab.attributedText = beginTimeStr;
    
    
    NSMutableAttributedString *payTimeStr = [[NSMutableAttributedString alloc]init];
    [payTimeStr appendAttributedString:[JHUtility getAttributedStringWithString:@"支付时间 " font:14 textColor:DEF_COLOR_RGB(91, 91, 91)]];
    [payTimeStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%@",orderListModel.payTime] font:font textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _payTimeLab.attributedText = payTimeStr;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
