//
//  JHBoss_staffDeatailHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_staffDeatailHeaderView.h"
#import <WXApi.h>
@interface JHBoss_staffDeatailHeaderView ()<JHTagsViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *pictureImagevIEW;
@property (weak, nonatomic) IBOutlet JHCRM_TagsView *tagsView;
@property (weak, nonatomic) IBOutlet UIView *topBackGroundView;
@property (weak, nonatomic) IBOutlet UIView *midleBackGroundView;
@property (weak, nonatomic) IBOutlet UIView *evaluateBacView;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *QRcodeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyBtnRightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRBtnConstraint;//left
@property (weak, nonatomic) IBOutlet UILabel *staffNameLab;
@property (weak, nonatomic) IBOutlet UILabel *staffAgeLab;
@property (weak, nonatomic) IBOutlet UIImageView *staffSexImagV;
@property (weak, nonatomic) IBOutlet UIImageView *staffRemarkImagV;
@property (weak, nonatomic) IBOutlet UILabel *evaluateNumLab;

@property (weak, nonatomic) IBOutlet UILabel *serveNumLab;//日均服务人
@property (weak, nonatomic) IBOutlet UILabel *responseNumLab;//服务响应时间
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;//客单价
@property (weak, nonatomic) IBOutlet UILabel *moreEvaluateLab;

@property (nonatomic, strong) NSMutableArray *evaluationListArr;
@property (nonatomic, strong) NSMutableArray *evaluationSelectArr;

@end

@implementation JHBoss_staffDeatailHeaderView

-(void)awakeFromNib{

    [super awakeFromNib];
    
    _pictureImagevIEW.layer.cornerRadius = 30;
    _pictureImagevIEW.layer.masksToBounds = YES;
   
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
    
    [_QRcodeBtn setimage:@"2.2.2.1_icon_erweima"];
    [_QRcodeBtn setTitle:@"二维码"];
    _QRcodeBtn.imageRect = CGRectMake((_QRcodeBtn.width - 20.8)/2, 0, 20.8, 21.1);
     _QRcodeBtn.titleRect = CGRectMake(0, 27.1, _QRcodeBtn.width, 11);
     _QRcodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [_moneyBtn setimage:@"2.2.2.1_icon_dashang"];
    [_moneyBtn setTitle:@"打赏"];
    _moneyBtn.imageRect = CGRectMake((_moneyBtn.width - 20.8)/2, 0, 20.8, 21.1);
    _moneyBtn.titleRect = CGRectMake(0, 27.1, _moneyBtn.width, 11);
    if ( [JHBoss_UserWarpper shareInstance].isInstallWX) {
        _moneyBtn.hidden = NO;
    }
    _moneyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    _evaluationListArr = [NSMutableArray array];
    _evaluationSelectArr = [NSMutableArray array];
    
    UITapGestureRecognizer *evaluateTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(moreEvaluate)];
    [self.evaluateBacView addGestureRecognizer:evaluateTap];
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_staffDeatailHeaderView" owner:self options:nil]objectAtIndex:0];
        float tagsHeight = [_tagsView intrinsicContentSize].height;
        self.frame = CGRectMake(0, 0, DEF_WIDTH, _topBackGroundView.height+_midleBackGroundView.height+_evaluateBacView.height+tagsHeight);
    }

    return self;
}

-(void)moreEvaluate{


    if (self.evaluateBlock) {
        self.evaluateBlock();
    }
}

- (IBAction)showQRcode:(UIButton *)sender {
    
    if (self.QRcodeBlock) {
        self.QRcodeBlock(sender);
    }
   
}

- (IBAction)payMoney:(UIButton *)sender {
    
    if (self.moneyBlock) {
        self.moneyBlock();
    }
}

-(void)setStaffDetailModel:(JHBoss_StaffDetailModel *)staffDetailModel{

    _staffDetailModel = staffDetailModel;
    [_pictureImagevIEW sd_setImageWithURL:[NSURL URLWithString:staffDetailModel.photo] placeholderImage:DEF_IMAGENAME(@"2.2.2_icon_zhanweitu") options:SDWebImageRefreshCached];
    
    _staffNameLab.text = DEF_OBJECT_TO_STIRNG(staffDetailModel.name);
    _staffAgeLab.text = DEF_OBJECT_TO_STIRNG(staffDetailModel.age);
    
    if ([staffDetailModel.sex isEqualToString:@"F"]) {
        
        _staffSexImagV.image = DEF_IMAGENAME(@"2.2.1.1_icon_girl");
        
    }else if ([staffDetailModel.sex isEqualToString:@"M"]){
    
         _staffSexImagV.image = DEF_IMAGENAME(@"2.2.1.1_icon_boy");
    
    }
    
    NSString *starMark;
    float star = [staffDetailModel.starMark floatValue];
    if (star == 0.0) {
        
        starMark = @"zeroStar";
    }else if (star > 0.0 && star <= 0.5){
    
         starMark = @"2.2.1.1_icon_banxing";
        
    }else if (star > 0.5 && star <= 1.0){
        
         starMark = @"2.2.1.1_icon_yixing";
        
    }else if (star > 1.0 && star <= 1.5){
        
         starMark = @"2.2.1.1_icon_yixingban";
        
    }else if (star > 1.5 && star <= 2.0){
        
         starMark = @"2.2.1.1_icon_liangxing";
        
    }else if (star > 2.0 && star <= 2.5){
        
         starMark = @"2.2.1.1_icon_liangxingban";
        
    }else if (star > 2.5 && star <= 3.0){
        
         starMark = @"2.2.1.1_icon_sanxing";
        
    }else if (star > 3.0 && star <= 3.5){
        
         starMark = @"2.2.1.1_icon_sanxingban";
        
    }else if (star > 3.5 && star <= 4){
        
         starMark = @"2.2.1.1_icon_sixing";
        
    }else if (star > 4.0 && star <= 4.5){
        
         starMark = @"2.2.1.1_icon_sixingban";
        
    }else if (star > 4.5 && star <= 5.0){
        
         starMark = @"2.2.1.1_icon_wuxing";
    }
    _staffRemarkImagV.image = DEF_IMAGENAME(starMark);
    
    NSString *evaluateStr = [NSString stringWithFormat:@"%ld人评价",staffDetailModel.evaluationCount  > 0 ? staffDetailModel.evaluationCount : 0];
    _evaluateNumLab.text = DEF_OBJECT_TO_STIRNG(evaluateStr);
    
    
     NSMutableAttributedString *Attributedstr = [[NSMutableAttributedString alloc] init];
    
    NSAttributedString * moreEvaluate = [JHUtility getAttributedStringWithString:@"查看更多评价(" font:15 textColor:DEF_COLOR_RGB(110, 110, 110)];
     NSString *evaluateStr2 = [NSString stringWithFormat:@"%ld",staffDetailModel.evaluationCount  > 0 ? staffDetailModel.evaluationCount : 0];
     NSAttributedString *EvaluateNum = [JHUtility getAttributedStringWithString:evaluateStr2 font:15 textColor:DEF_COLOR_RGB(193, 145, 83)];
     NSAttributedString * other = [JHUtility getAttributedStringWithString:@")" font:15 textColor:DEF_COLOR_RGB(110, 110, 110)];
    
    [Attributedstr appendAttributedString:moreEvaluate];
    [Attributedstr appendAttributedString:EvaluateNum];
    [Attributedstr appendAttributedString:other];
    _moreEvaluateLab.attributedText = Attributedstr;
    
    NSString *serveNumStr = staffDetailModel.dailyServiceCount.length > 0 ? staffDetailModel.dailyServiceCount : @"0";
    _serveNumLab.text = DEF_OBJECT_TO_STIRNG(serveNumStr);
    
     NSString *responseNumStr = [NSString stringWithFormat:@"%g",staffDetailModel.rewardMoney.doubleValue/100];
    _responseNumLab.text = DEF_OBJECT_TO_STIRNG(responseNumStr);
    
    NSString *peopleMoneyStr = [NSString stringWithFormat:@"%g",staffDetailModel.personalCustomPrice.doubleValue/100];
    _moneyLab.text = DEF_OBJECT_TO_STIRNG(peopleMoneyStr);
  
    if (isObjNotEmpty(staffDetailModel.evaluationList)) {
          NSMutableArray *selectArr = [NSMutableArray array];
        for (int i = 0; i < staffDetailModel.evaluationList.count; i++) {
            
            JHBoss_StaffEvaluationListModel *evalModel = staffDetailModel.evaluationList[i];
            NSString *evalStr = [NSString stringWithFormat:@"%@%ld 人评价",evalModel.content,evalModel.count];
            [self.evaluationListArr addObject: evalStr];
            
            if (evalModel.flag == 1) {
                
                [selectArr addObject:[NSString stringWithFormat:@"%d",i]];
            }
        }
        
        self.tagsView.tagsArray = self.evaluationListArr;
        [self.tagsView selectTagAtIndex:selectArr animate:YES];
    }
//    [self calculateHeight];
}

-(void)calculateHeight{

    float evaluateViewH ;
    if (self.staffDetailModel.evaluationCount > 0) {
        evaluateViewH = 57;
    }else{
    
        evaluateViewH = 0;
    }
    float tagsHeight = [_tagsView intrinsicContentSize].height;
    self.frame = CGRectMake(0, 0, DEF_WIDTH, _topBackGroundView.height+_midleBackGroundView.height+evaluateViewH+tagsHeight);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
