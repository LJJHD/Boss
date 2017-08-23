//
//  JHBoss_OrderDetailWaiterTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderDetailWaiterTableViewCell.h"

@interface JHBoss_OrderDetailWaiterTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *natureLB;

@end

@implementation JHBoss_OrderDetailWaiterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        
    }
    return self;
}

-(void)setWaiterListModel:(WaiterList *)waiterListModel{

    _waiterListModel = waiterListModel;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:waiterListModel.picture] placeholderImage:DEF_IMAGENAME(@"2.2.2_icon_zhanweitu")];
    _nameLB.text = waiterListModel.name;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
