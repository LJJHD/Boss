//
//  JHCRM_CerTableViewCell.m
//  Boss
//
//  Created by 晶汉mac on 2017/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_CerTableViewCell.h"

@interface JHCRM_CerTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation JHCRM_CerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CustomListCellID = @"JHCRM_CerTableViewCell";
    JHCRM_CerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomListCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHCRM_CerTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)setModel:(JHCRM_LoginAndRegistModel *)model
{
    _model = model;
    self.titleLb.text = model.titleStr;
    self.textField.placeholder = model.placeStr;
    self.textField.text = model.textFieldStr;
    self.textField.userInteractionEnabled  = NO;
}
@end
