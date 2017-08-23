//
//  JHBoss_HomeDishesSectionHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/6/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_HomeDishesSectionHeaderView.h"

@interface JHBoss_HomeDishesSectionHeaderView ()
@property (weak, nonatomic) IBOutlet UIButton *moreRangkingBtn;

@end

@implementation JHBoss_HomeDishesSectionHeaderView

-(void)awakeFromNib{

    [super awakeFromNib];

}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];

    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_HomeDishesSectionHeaderView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}
- (IBAction)moreRangkingHandler:(UIButton *)sender {
    if (self.moreRangkingBlock) {
        self.moreRangkingBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
