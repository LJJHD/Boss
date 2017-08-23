//
//  JHCRM_RegistTableViewCell.m
//  Boss
//
//  Created by 晶汉mac on 2017/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_RegistTableViewCell.h"

@interface JHCRM_RegistTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation JHCRM_RegistTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.borderStyle = UITextBorderStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CustomListCellID = @"JHCRM_RegistTableViewCell";
    JHCRM_RegistTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomListCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHCRM_RegistTableViewCell" owner:self options:nil] objectAtIndex:0];
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
}
@end
