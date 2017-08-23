//
//  JHBoss_MoreStaffEvaluateHeaderView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_MoreStaffEvaluateHeaderView.h"
#import "JHBoss_StaffDetailModel.h"

@interface JHBoss_MoreStaffEvaluateHeaderView ()
@property (nonatomic, strong) UIButton *moreBtn;
@end

@implementation JHBoss_MoreStaffEvaluateHeaderView

-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation flagArr:(NSArray *)flagArr{
    
    self = [super initWithFrame:frame orientation:orientation];
    
    if (self) {
        
        self.wrapContentHeight = YES;
        self.wrapContentWidth = NO;
        
        
        self.flowLayout = [MyFlowLayout flowLayoutWithOrientation:MyOrientation_Vert arrangedCount:0];
        
        if (flagArr.count >= 12) {
            
            self.flowLayout.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 105);
            self.flowLayout.wrapContentHeight = NO;
            
        }else{
            
            self.flowLayout.wrapContentHeight = YES;
            
        }
        
        self.flowLayout.padding = UIEdgeInsetsMake(10, 25, 10, 25);
        self.flowLayout.backgroundColor = [UIColor whiteColor];
        self.flowLayout.wrapContentWidth = NO;
        self.flowLayout.myHorzMargin = 0;
        self.flowLayout.subviewSpace = 8;   //流式布局里面的子视图的水平和垂直间距都设置为10
        self.flowLayout.layer.masksToBounds = YES;

        for (int i = 0 ; i < flagArr.count; i++) {
            
            JHBoss_StaffEvaluationListModel *staffDModel = flagArr[i];
            
            UILabel *showLabel = [UILabel new];
            showLabel.text = [NSString stringWithFormat:@"%@ %ld",staffDModel.content,staffDModel.count];
            showLabel.textAlignment = NSTextAlignmentCenter;
            
            if (staffDModel.flag == 1) {
                
                showLabel.textColor = DEF_COLOR_RGB(205, 162, 101);
                showLabel.layer.borderColor = DEF_COLOR_RGB(205, 162, 101).CGColor;
                
            }else if (staffDModel.flag == 0){
            
            
                showLabel.textColor = DEF_COLOR_RGB(161, 161, 161);
                showLabel.layer.borderColor = DEF_COLOR_RGB(161, 161, 161).CGColor;
            }
            
            showLabel.layer.borderWidth = 0.5;
            showLabel.layer.cornerRadius = 2;
            showLabel.layer.masksToBounds = YES;
            showLabel.widthSize.equalTo(showLabel.widthSize).add(15);
            showLabel.font = DEF_SET_FONT(13);
            showLabel.heightSize.equalTo(@25);
            [showLabel sizeToFit];
            [self.flowLayout addSubview:showLabel];
        }
        self.flowLayout.autoArrange = YES;
      
        [self addSubview:self.flowLayout];
        
        if (flagArr.count >= 12) {
            
            self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.moreBtn.myLeft = self.moreBtn.myRight = 0;
            self.moreBtn.myHeight = 44;
            self.moreBtn.myBottom = 0;
            self.moreBtn.backgroundColor = [UIColor whiteColor];
            [self.moreBtn setimage:@"1.1_btn_dropdown_default"];
            [self.moreBtn addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.moreBtn];

        }
        
        
        
        
    }
    
    return self;
}

-(void)showMore:(UIButton *)sender{

    if (self.showMoreBlock) {
        self.showMoreBlock(sender);
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
