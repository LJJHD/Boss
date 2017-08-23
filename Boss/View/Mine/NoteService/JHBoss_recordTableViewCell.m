//
//  JHBoss_recordTableViewCell.m
//  Boss
//
//  Created by SeaDragon on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_recordTableViewCell.h"

@interface JHBoss_recordTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@end
@implementation JHBoss_recordTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _dateLabel.preferredMaxLayoutWidth = 100;
    self.messageLabel.textColor = [UIColor colorWithRGBValue:180 g:134 b:69];
}

#pragma mark - setter Methord

-(void)setRecordModel:(Records *)recordModel{

    self.dateLabel.text    = [NSString dateStr:recordModel.operateDate.stringValue format:@"MM-dd"];
    self.moneyLabel.text   = [[NSString stringWithFormat:@"%g",recordModel.amount.doubleValue/100] stringByAppendingString:@"元"];
    self.messageLabel.text = recordModel.content;
}

-(void)setNoteConRecordModel:(MerchantMessageList *)noteConRecordModel{

    _noteConRecordModel = noteConRecordModel;
    self.dateLabel.text    = noteConRecordModel.merchantName;
    self.moneyLabel.text   = [[noteConRecordModel.consumeMessageAmount stringValue] stringByAppendingString:@"条"];
    self.messageLabel.text = noteConRecordModel.messageTypeName;
}

-(void)setWarningStr:(NSString *)warningStr{

    self.messageLabel.text = warningStr;
    self.dateLabel.text = nil;
    self.moneyLabel.text = nil;
}
@end
