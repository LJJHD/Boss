//
//  JHCRM_RegistCodeTableViewCell.m
//  Boss
//
//  Created by 晶汉mac on 2017/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_RegistCodeTableViewCell.h"


@interface JHCRM_RegistCodeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@end

@implementation JHCRM_RegistCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.getCodeBtn.clipsToBounds = YES;
    self.getCodeBtn.layer.cornerRadius = 3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CustomListCellID = @"JHCRM_RegistCodeTableViewCell";
    JHCRM_RegistCodeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomListCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHCRM_RegistCodeTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (IBAction)getCode:(id)sender {
}
- (void)setModel:(JHCRM_LoginAndRegistModel *)model
{
    _model = model;
    self.titleLb.text = model.titleStr;
    self.textField.placeholder = model.placeStr;
    self.textField.text = model.textFieldStr;
}
@end
