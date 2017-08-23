//
//  JHBoss_staffEvaluateHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_staffEvaluateHeaderView.h"

@interface JHBoss_staffEvaluateHeaderView ()<JHTagsViewDelegate>
@property (weak, nonatomic) IBOutlet JHCRM_TagsView *tagsView;
@property (weak, nonatomic) IBOutlet UIButton *showMoreBtn;

@end

@implementation JHBoss_staffEvaluateHeaderView

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
  
    _showMoreBtn.hidden = YES;
//    _tagsView.tagsArray = [NSMutableArray arrayWithObjects:@"好",@"人不错",@"轻快好",@"非常不错",@"人配料",@"会说话",@"手机发了时间冻结",@"暗室逢灯上的",@"多少",@"爱过水电费",@"案发地方",@"法规热给个大概", nil];
//    [_tagsView selectTagAtIndex:[NSMutableArray arrayWithObjects:@"2",@"3",@"5",@"6", nil] animate:YES];
    
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_staffEvaluateHeaderView" owner:self options:nil]objectAtIndex:0];
        self.frame = CGRectMake(0, 0, DEF_WIDTH, [_tagsView intrinsicContentSize].height + _showMoreBtn.height);
    }
    
    return self;
}


- (IBAction)showMore:(UIButton *)sender {
    
    
}


-(void)setStaffDetailModel:(JHBoss_StaffDetailModel *)staffDetailModel{
    _staffDetailModel  = staffDetailModel;
    NSMutableArray *evaluationListArr = [NSMutableArray array];
    NSMutableArray *selectArr = [NSMutableArray array];
    if (isObjNotEmpty(staffDetailModel.evaluationList)) {
        
        for (int i = 0; i < staffDetailModel.evaluationList.count; i++) {
            
            JHBoss_StaffEvaluationListModel *evalModel = staffDetailModel.evaluationList[i];
            NSString *evalStr = [NSString stringWithFormat:@"%@%ld 人评价",evalModel.content,evalModel.count];
            [evaluationListArr addObject: evalStr];
            
            if (evalModel.flag == 1) {
                
                [selectArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        
        
        self.tagsView.tagsArray = evaluationListArr;
        [self.tagsView selectTagAtIndex:selectArr animate:YES];
    }else{
    
    
     _showMoreBtn.hidden = YES;
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
