//
//  JHBoss_NoteServiceTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_NoteServiceTableViewCell.h"

@interface JHBoss_NoteServiceTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLB;
@property (weak, nonatomic) IBOutlet UILabel *subheadingLB;

@end

@implementation JHBoss_NoteServiceTableViewCell

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

-(void)setModel:(JHCRM_MineMainModel *)model{

    _titleLB.text = model.title;
    _subheadingLB.text = model.titleDel;

}

-(void)setResidueMessageCount:(NSString *)residueMessageCount{
    
    _subheadingLB.text = [residueMessageCount.intValue ? residueMessageCount : @"0" stringByAppendingString:@"条"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
