//
//  JHCRM_MineMainCell.m
//  SuppliersCRM
//
//  Created by jinghan on 17/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_MineMainCell.h"

@implementation JHCRM_MineMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headerImageView.hidden = YES;
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = self.headerImageView.width/2.0;
    self.headerImageView.backgroundColor = DEF_COLOR_F5F5F5;
    self.headerImageView.layer.borderWidth = 0.7;
    self.headerImageView.layer.borderColor = [UIColor colorWithRGBValue:220 g:220 b:200].CGColor;
    
    
}


- (void)setModel:(JHCRM_MineMainModel *)model{
    self.titleLabel.text = model.title;
    
    self.headerImageView.hidden = YES;
    self.infoLable.hidden = YES;
//    self.infoLable.textColor = [UIColor blackColor];
    self.rightImageView.hidden = YES;
    self.iconImageView.hidden = YES;
    
    self.titleLabel.text = model.title;
    self.titleLabel.font = model.titleFont;
    self.titleLabel.textColor = model.titleColor;
    self.infoLable.font = model.titleDelFont;
    self.infoLable.textColor = model.titleDelColor;
    
    switch (model.personalCenterCellType) {
            
        case PersonalCenterCellType_Title_Arrow:
        {
            /*   Title    >   */
            self.rightImageView.hidden = NO;
        }
            break;
        case PersonalCenterCellType_Title_Image:
        {
            /*   Title    Image   */
            self.headerImageView.hidden = NO;
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        }
            break;
        case PersonalCenterCellType_Title_DescribeLb:
        case PersonalCenterCellType_Title_DescribeLb_Space:
        {
            /*   Title    DescribeLb  */
            self.infoLable.hidden = NO;
            self.infoLable.text = model.titleDel;
            
            if ([self.infoLable.text isEqualToString:@"工作中"]) {
                self.infoLable.textColor = [UIColor colorWithRGBValue:68 g:201 b:122];
            }
        }
            break;
        case PersonalCenterCellType_Title_DescribeLb_Arrow:
        {
            /*   Title    DescribeLb   >   */
            self.rightImageView.hidden = NO;
            self.infoLable.hidden = NO;
            self.infoLable.text = model.titleDel;
        }
            break;
        case PersonalCenterCellType_Icon_Title_Image_Arrow:
        {
            /*   Icon     Title    Image   >   */
            self.rightImageView.hidden = NO;
            self.infoLable.hidden = YES;
            self.iconImageView.image = DEF_IMAGENAME(model.iconName);
            self.iconImageView.hidden = NO;
            self.headerImageView.hidden = NO;
            
            NSString *imageUrl = @"";
            if (model.headImageUrl) {
                 imageUrl = [imageUrl stringByAppendingString:model.headImageUrl];
            }
           
            
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        }
            break;
        case PersonalCenterCellType_Icon_Title_DescribeLb_Arrow:
        {
            /*   Icon     Title    DescribeLb   >   */
            self.rightImageView.hidden = NO;
            self.infoLable.hidden = NO;
            self.infoLable.text = model.titleDel;
            self.infoLable.textColor = model.titleDelColor;
            self.iconImageView.image = DEF_IMAGENAME(model.iconName);
            self.iconImageView.hidden = NO;
        }
            break;
    
            break;
        default:
            break;
    }
    
    
    if (self.rightImageView.isHidden && model.personalCenterCellType != PersonalCenterCellType_Title_DescribeLb_Space) {
        self.InfoLbTralingLayout.constant = 12;
    }else {
        self.InfoLbTralingLayout.constant = 40;
    }
    
    self.TitleLbleadingLayout.constant = self.iconImageView.hidden?20:57;
}


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CustomListCellID = @"JHCRM_MineMainCell";
    JHCRM_MineMainCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomListCellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JHCRM_MineMainCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setCellLineUIEdgeInsetsZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
