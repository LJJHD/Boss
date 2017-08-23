//
//  JHBoss_OrderDeatailTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/7/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderDeatailTableViewCell.h"

@interface JHBoss_OrderDeatailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNumLB;
@property (weak, nonatomic) IBOutlet UILabel *payStauteLB;
@property (weak, nonatomic) IBOutlet UILabel *tableNumLB;
@property (weak, nonatomic) IBOutlet UILabel *popleNumLB;
@property (weak, nonatomic) IBOutlet UILabel *begainTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *payTimeLB;

@end

@implementation JHBoss_OrderDeatailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _payStauteLB.layer.cornerRadius = 3;
    _payStauteLB.layer.masksToBounds = YES;
    _payStauteLB.backgroundColor = DEF_COLOR_RGB(238, 177, 30);
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
    _orderNumLB.attributedText = attrOrderNumStr;
    
    
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
    
    _payStauteLB.text = payStaute;
    _payStauteLB.backgroundColor = stauteBackG;
    [_payStauteLB sizeToFit];
    
    NSString *tableNumber = DEF_OBJECT_TO_STIRNG(orderListModel.tableNumber);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"桌号 "];
    [attrStr appendAttributedString:[JHUtility getAttributedStringWithString:tableNumber font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _tableNumLB.attributedText = attrStr;
    
    
    NSMutableAttributedString *peopleNumStr = [[NSMutableAttributedString alloc]initWithString:@"人数 "];
    [peopleNumStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%ld",orderListModel.peopleNum] font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
    [peopleNumStr appendAttributedString:[JHUtility getAttributedStringWithString:@"人" font:14 textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _popleNumLB.attributedText = peopleNumStr;
    
    NSMutableAttributedString *beginTimeStr = [[NSMutableAttributedString alloc]init];
    [beginTimeStr appendAttributedString:[JHUtility getAttributedStringWithString:@"开台时间 " font:14 textColor:DEF_COLOR_RGB(110, 110, 110)]];
    [beginTimeStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%@",orderListModel.openTime] font:font textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _begainTimeLB.attributedText = beginTimeStr;
    
    
    NSMutableAttributedString *payTimeStr = [[NSMutableAttributedString alloc]init];
    [payTimeStr appendAttributedString:[JHUtility getAttributedStringWithString:@"支付时间 " font:14 textColor:DEF_COLOR_RGB(110, 110, 110)]];
    [payTimeStr appendAttributedString:[JHUtility getAttributedStringWithString:[NSString stringWithFormat:@"%@",orderListModel.payTime] font:font textColor:DEF_COLOR_RGB(164, 115, 54)]];
    _payTimeLB.attributedText = payTimeStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
