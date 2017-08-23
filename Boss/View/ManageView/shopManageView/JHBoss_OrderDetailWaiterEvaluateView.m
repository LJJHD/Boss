//
//  JHBoss_OrderDetailWaiterEvaluateView.m
//  Boss
//
//  Created by jinghankeji on 2017/6/23.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_OrderDetailWaiterEvaluateView.h"
#import "JHBoss_ApproveHeaderView.h"
#import "JHBoss_OrderDetailEvaluateView.h"
@interface JHBoss_OrderDetailWaiterEvaluateView ()<JHBoss_ApproveHeaderViewDelegate>
@property (nonatomic, strong) JHBoss_ApproveHeaderView *headerView;
@property (nonatomic, strong) UIImageView *ClientIcon;
@property (nonatomic, strong) UILabel *ClientName;
@property (nonatomic, strong) UIImageView *ClientGrande;//客户等级

@property (nonatomic, strong) UIScrollView *scrollView;//用户评论的
@property (nonatomic, strong) UILabel *evaluateLB;//用户

@property (nonatomic, strong) MyLinearLayout *backGroundLinearView;//评价view
@property (nonatomic, strong) JHBoss_OrderDetailEvaluateView *restEvaluateView;//餐厅评价
@property (nonatomic, strong) JHBoss_OrderDetailEvaluateView *staffEvaluateView;//服务员评价
@property (nonatomic, strong) MyFlowLayout *topFlowLayout;//评价客户
@end

@implementation JHBoss_OrderDetailWaiterEvaluateView

-(instancetype)initWithFrame:(CGRect)frame orientation:(MyOrientation)orientation{

    self = [super initWithFrame:frame orientation:orientation];
    if (self) {
        self.wrapContentWidth = NO;
        self.wrapContentHeight = YES;
        
        [self setUpUI];
    }
    return self;

}

-(void)setUpUI{

    @weakify(self);
    
    self.topFlowLayout = [[MyFlowLayout alloc]initWithOrientation:MyOrientation_Vert arrangedCount:0];
    _topFlowLayout.wrapContentWidth = NO;
    _topFlowLayout.wrapContentHeight = NO;
    _topFlowLayout.arrangedGravity = MyGravity_Vert_Center;
    _topFlowLayout.myLeft = _topFlowLayout.myRight = 0;
    _topFlowLayout.myTop = 20;
    _topFlowLayout.myHeight = 40;
    [self addSubview:_topFlowLayout];
    
    _ClientIcon = [UIImageView new];
    _ClientIcon.image = DEF_IMAGENAME(@"2.2.2_icon_zhanweitu");
    self.ClientIcon.myLeft = 25;
    self.ClientIcon.myWidth = self.ClientIcon.myHeight = 40;
    [_topFlowLayout addSubview:self.ClientIcon];
    
    [self.topFlowLayout setEndLayoutBlock:^{
        @strongify(self);
        self.ClientIcon.layer.cornerRadius = 20;
        self.ClientIcon.layer.masksToBounds = YES;
    }];
    
    self.ClientName = [UILabel new];
    self.ClientName.text = @"张三";
    self.ClientName.font = [UIFont systemFontOfSize:14];
    self.ClientName.textColor = DEF_COLOR_B48645;
    self.ClientName.myLeft = 20;
    [self.ClientName sizeToFit];
    [_topFlowLayout addSubview:self.ClientName];
    
    
    self.ClientGrande = [UIImageView new];
    self.ClientGrande.image = DEF_IMAGENAME(@"2.1.2.1_icon_vip");
    self.ClientGrande.myLeft = 7;
    self.ClientGrande.myWidth = 25;
    self.ClientGrande.myHeight = 11.4;
    self.ClientGrande.centerY = 0;
    self.ClientGrande.contentMode = UIViewContentModeScaleAspectFill;
    self.ClientGrande.hidden = YES;
    [_topFlowLayout addSubview:self.ClientGrande];
    
    _headerView = [[JHBoss_ApproveHeaderView alloc]initWithFrame:CGRectZero];
    _headerView.delegate = self;
    _headerView.leftSpace = 74;
    _headerView.rightSpace = 74;
    _headerView.isShowBottonLine = NO;
    _headerView.itemFont = 15;
    _headerView.itemColor = [DEF_COLOR_6E6E6E colorWithAlphaComponent:0.5];
    _headerView.selectItemColor = DEF_COLOR_6E6E6E;
    _headerView.ViewBackgroundColor = [UIColor whiteColor];
    _headerView.isShowBottonLine = YES;
    _headerView.ItemBackgroundColor = [UIColor clearColor];
    _headerView.itemArray = [NSMutableArray arrayWithObjects:@"餐厅评价",@"服务员评价", nil];
    _headerView.myLeft = _headerView.myRight = 0;
    _headerView.myHeight = 44;
    _headerView.myTop = 10;
    [self addSubview:_headerView];
    [self.headerView showApproveHeaderView];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.myLeft = self.scrollView.myRight = 0;
    self.scrollView.wrapContentHeight = YES;
    self.scrollView.wrapContentWidth = NO;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.contentSize = CGSizeMake(DEF_WIDTH *2, 0);
    [self addSubview:self.scrollView];
    
    self.backGroundLinearView = [MyLinearLayout linearLayoutWithOrientation:MyOrientation_Horz];
    self.backGroundLinearView.frame= CGRectMake(0, 0, DEF_WIDTH *2, 0);
    self.backGroundLinearView.wrapContentWidth = NO;
    self.backGroundLinearView.wrapContentHeight = YES;
    [self.scrollView addSubview:self.backGroundLinearView];
    
    
    [self.backGroundLinearView addSubview:self.restEvaluateView];
    [self.backGroundLinearView addSubview:self.staffEvaluateView];
    
    
    [self setEndLayoutBlock:^{
        @strongify(self);
        self.ClientIcon.layer.cornerRadius = self.ClientIcon.frame.size.width/2;
        self.ClientIcon.layer.masksToBounds = YES;
    }];

   
    
}

/**
 懒加载餐厅评价

 @return <#return value description#>
 */
-(JHBoss_OrderDetailEvaluateView *)restEvaluateView{

    if (!_restEvaluateView) {
        _restEvaluateView = [JHBoss_OrderDetailEvaluateView linearLayoutWithOrientation:MyOrientation_Vert];
        _restEvaluateView.wrapContentHeight = YES;
        _restEvaluateView.wrapContentWidth = NO;
        _restEvaluateView.myLeft = 0;
        _restEvaluateView.myTop = 0;
        _restEvaluateView.backgroundColor = [UIColor whiteColor];
        _restEvaluateView.myWidth = DEF_WIDTH;
    }

    return _restEvaluateView;
}

-(JHBoss_OrderDetailEvaluateView *)staffEvaluateView{

    if (!_staffEvaluateView) {
        _staffEvaluateView = [JHBoss_OrderDetailEvaluateView linearLayoutWithOrientation:MyOrientation_Vert];
        _staffEvaluateView.wrapContentHeight = YES;
        _staffEvaluateView.wrapContentWidth = NO;
        _staffEvaluateView.myLeft = self.restEvaluateView.myRight;
        _staffEvaluateView.myWidth = DEF_WIDTH;
        _staffEvaluateView.myTop = 0;
        _staffEvaluateView.backgroundColor = [UIColor whiteColor];

    }
    return _staffEvaluateView;
}

-(void)setModel:(JHBoss_OrderListModel *)model{

    _model = model;
    CommentList *commentModel = model.commentList.firstObject;//餐厅评价

    self.restEvaluateView.restArr = model.commentList;
    self.staffEvaluateView.commentArr = model.commentList;
    if (model.commentList.count <= 0) {
        
        self.topFlowLayout.hidden = YES;
    }else{
        self.ClientGrande.hidden = NO;
    }
    [self.ClientIcon sd_setImageWithURL:[NSURL URLWithString:commentModel.photo] placeholderImage:DEF_IMAGENAME(@"2.2.2_icon_zhanweitu")];
    self.ClientName.text = commentModel.commenter;
    [self.ClientName sizeToFit];
}


- (void)didSelectMenuBtn:(MenuButton *)menuButton{

    if (menuButton.index == 0) {
        
        [self.scrollView setContentOffset:CGPointMake(DEF_WIDTH*menuButton.index, 0) animated:YES];
    }else{
    
        [self.scrollView setContentOffset:CGPointMake(DEF_WIDTH*menuButton.index, 0) animated:YES];

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
