//
//  JHBoss_InviteStaffDetailHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_InviteStaffDetailHeaderView.h"
#import "JHCRM_TagsView.h"
@interface JHBoss_InviteStaffDetailHeaderView ()<JHTagsViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *staffIconImgV;
@property (weak, nonatomic) IBOutlet UILabel *staffNamLab;
@property (weak, nonatomic) IBOutlet UILabel *staffAgeLab;
@property (weak, nonatomic) IBOutlet UIImageView *staffSexImagV;
@property (weak, nonatomic) IBOutlet UIImageView *starImagV;
@property (weak, nonatomic) IBOutlet UILabel *evaluateLab;
@property (weak, nonatomic) IBOutlet JHCRM_TagsView *tagsView;

@end

@implementation JHBoss_InviteStaffDetailHeaderView

-(void)awakeFromNib{

    [super awakeFromNib];
    
    _tagsView.isShowAddImageView = NO;
    _tagsView.interitemSpacing = 3;
    _tagsView.lineSpacing = 3;
    _tagsView.tagHeight = 30;
    _tagsView.tagFont = [UIFont systemFontOfSize:13];
    _tagsView.allowEmptySelection = NO;
    _tagsView.allowsMultipleSelection = YES;
    _tagsView.delegate = self;
    _tagsView.tagLabelCornerRadius = 4;
    _tagsView.tagLabelBorderWidth = 0.5;
    _tagsView.tagLabelSelectedBackgroundColor = [UIColor whiteColor];
    _tagsView.tagLabelSelectedBorderColor = DEF_COLOR_CDA265;
    _tagsView.tagSelectedTextColor = DEF_COLOR_CDA265;
    _tagsView.tagTextColor = DEF_COLOR_A1A1A1;
    _tagsView.tagLabelBorderColor = DEF_COLOR_A1A1A1;
    _tagsView.contentInsets = UIEdgeInsetsMake(15, 25, 0, 25);
    
    _tagsView.tagsArray = [NSMutableArray arrayWithObjects:@"好",@"人不错",@"轻快好",@"非常不错",@"人配料",@"会说话",@"手机发了时间冻结",@"暗室逢灯上的",@"多少",@"爱过水电费",@"案发地方",@"法规热给个大概", nil];
    [_tagsView selectTagAtIndex:[NSMutableArray arrayWithObjects:@"2",@"3",@"5",@"6", nil] animate:YES];


}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_InviteStaffDetailHeaderView" owner:self options:nil]objectAtIndex:0];
        self.frame = CGRectMake(0, 0, DEF_WIDTH, 90 + [self.tagsView intrinsicContentSize].height);
    }

    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
