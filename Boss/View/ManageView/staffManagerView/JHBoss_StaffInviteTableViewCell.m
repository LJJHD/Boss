//
//  JHBoss_StaffInviteTableViewCell.m
//  Boss
//
//  Created by jinghankeji on 2017/5/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_StaffInviteTableViewCell.h"
#import "JHCRM_TagsView.h"
@interface JHBoss_StaffInviteTableViewCell ()<JHTagsViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *staffIconImView;
@property (weak, nonatomic) IBOutlet UILabel *staffNamLab;
@property (weak, nonatomic) IBOutlet UILabel *staffAgeLabe;
@property (weak, nonatomic) IBOutlet UIImageView *staffGenderImgView;
@property (weak, nonatomic) IBOutlet UIImageView *staffEvaluateImgView;
@property (weak, nonatomic) IBOutlet UILabel *evaluatePepoleLab;
@property (weak, nonatomic) IBOutlet UILabel *workExperienceLab;
@property (weak, nonatomic) IBOutlet JHCRM_TagsView *tagsView;


@end

@implementation JHBoss_StaffInviteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _tagsView.isShowAddImageView = NO;
    _tagsView.interitemSpacing = 3;
    _tagsView.lineSpacing = 3;
    _tagsView.tagHeight = 30;
    _tagsView.tagFont = [UIFont systemFontOfSize:13];
    _tagsView.allowEmptySelection = NO;
    _tagsView.allowsSelection = NO;
    _tagsView.allowsMultipleSelection = NO;
    _tagsView.delegate = self;
    _tagsView.tagLabelCornerRadius = 4;
    _tagsView.tagLabelBorderWidth = 0.5;
    _tagsView.tagLabelSelectedBackgroundColor = [UIColor whiteColor];
    _tagsView.tagLabelSelectedBorderColor = DEF_COLOR_CDA265;
    _tagsView.tagSelectedTextColor = DEF_COLOR_CDA265;
    _tagsView.tagTextColor = DEF_COLOR_A1A1A1;
    _tagsView.tagLabelBorderColor = DEF_COLOR_A1A1A1;
    _tagsView.tagInsets = UIEdgeInsetsMake(1, 1, 1, 1);
    _tagsView.contentInsets = UIEdgeInsetsMake(10, 20, 0, 20);
    
//    _tagsView.tagsArray = [NSMutableArray arrayWithObjects:@"好",@"人不错",@"轻快好",@"非常不错",@"人配料",@"会说话",@"手机发了时间冻结",@"暗室逢灯上的",@"多少",@"爱过水电费",@"案发地方",@"法规热给个大概", nil];
   
    
}

-(void)setApplicantListModel:(JHBoss_applicantListModel *)applicantListModel{

    _applicantListModel = applicantListModel;
    
    [_staffIconImView sd_setImageWithURL:[NSURL URLWithString:DEF_OBJECT_TO_STIRNG(applicantListModel.photo)] placeholderImage:DEF_IMAGENAME(@"ceshi")];
    
    _staffNamLab.text = DEF_OBJECT_TO_STIRNG(applicantListModel.name);

    _staffAgeLabe.text = [NSString stringWithFormat:@"%ld岁",applicantListModel.age];
    
    
    if ([applicantListModel.sex isEqualToString:@"F"]) {
        
        _staffGenderImgView.image = DEF_IMAGENAME(@"2.2.1.1_icon_girl");
        
    }else if ([applicantListModel.sex isEqualToString:@"M"]){
        
        _staffGenderImgView.image = DEF_IMAGENAME(@"2.2.1.1_icon_boy");
        
    }
    
    NSString *starMark;
    if (applicantListModel.starMark == 0.0) {
        
        
        starMark = @"2.2.1.1_icon_sanxing";
    }else if (applicantListModel.starMark == 0.5){
        
        starMark = @"2.2.1.1_icon_sanxing";
    }else if (applicantListModel.starMark == 1.0){
        
        starMark = @"2.2.1.1_icon_sanxing";
    }else if (applicantListModel.starMark  == 1.5){
        
        starMark = @"2.2.1.1_icon_sanxing";
    }else if (applicantListModel.starMark  == 2.0){
        
        starMark = @"2.2.1.1_icon_sanxing";
    }else if (applicantListModel.starMark  == 2.5){
        
        starMark = @"2.2.1.1_icon_sanxing";
    }else if (applicantListModel.starMark  == 3.0){
        
        starMark = @"2.2.1.1_icon_sanxing";
    }else if (applicantListModel.starMark  == 3.5){
        
        starMark = @"2.2.1.1_icon_sanxingban";
    }else if (applicantListModel.starMark  == 4.0){
        
        starMark = @"2.2.1.1_icon_sixing";
    }else if (applicantListModel.starMark  == 4.5){
        
        starMark = @"2.2.1.1_icon_sixingban";
    }else if (applicantListModel.starMark  == 5.0){
        
        starMark = @"2.2.1.1_icon_wuxing";
    }
    _staffEvaluateImgView.image = DEF_IMAGENAME(starMark);
    
    NSString *evaluateStr = [NSString stringWithFormat:@"%ld人评价",applicantListModel.evaluationCount  > 0 ? applicantListModel.evaluationCount  : 0];
    _evaluatePepoleLab.text = DEF_OBJECT_TO_STIRNG(evaluateStr);

    NSMutableArray *tagsArr = [NSMutableArray array];
    
    for (JHBoss_StaffEvaluationListModel *model in applicantListModel.evaluateListArr) {
        
        [tagsArr addObject:[NSString stringWithFormat:@"%@ %ld",model.content,model.count]];
    }
    
    self.tagsView.tagsArray = tagsArr;
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
