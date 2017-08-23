//
//  JHBoss_staffDetailViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_staffDetailViewController.h"
#import "JHCRM_MineMainCell.h"
#import "JHCRM_MineMainModel.h"
#import "JHBoss_staffDeatailHeaderView.h"
#import "JHBoss_StaffEvaluateViewController.h"
#import "JHBoss_staffGroupViewController.h"
#import "JHBoss_staffAccountInfoViewController.h"
#import "JHBoss_staffRemarkInfoViewController.h"
#import "JHBoss_StaffRewardDetailViewController.h"
#import "JHBoss_RechargeViewController.h"
#import "JHBoss_StaffDetailModel.h"
#import "JHBoss_ShowStaffQRImageViewController.h"
#import "JH_CreateQRCode.h"
@interface JHBoss_staffDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArr;
@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, strong) JHBoss_staffDeatailHeaderView *headerView;
@property (nonatomic, strong) JHBoss_StaffDetailModel *staffDetailModel;
@end

@implementation JHBoss_staffDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [self setUI];
    [self loadData];
   
}
-(void)setUI{
    
    self.jhtitle = @"员工详情";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    _headerView = [[JHBoss_staffDeatailHeaderView alloc]initWithFrame:CGRectZero];

    @weakify(self);
     _headerView.moneyBlock = ^{
          @strongify(self);
         JHBoss_RechargeViewController *GMTVC = [[JHBoss_RechargeViewController alloc]init];
         GMTVC.staffId         =  @(self.staffDetailModel.ID).stringValue;
         GMTVC.staffName       =  self.staffDetailModel.name;
         GMTVC.staffPictureUrl =  self.staffDetailModel.photo;
         GMTVC.payType = kPayMethodType_Employees_Reward;
         [self.navigationController pushViewController:GMTVC animated:YES];
     };
    
    _headerView.QRcodeBlock = ^(UIButton *btn) {
         @strongify(self);
        
        [self showHelpImage:btn];
    };
    
    _headerView.evaluateBlock = ^{
        @strongify(self);
        [self toStaffEvaluateViewController];
        
    };
    
    
    [self.view addSubview:self.tableView];
    _tableView.tableHeaderView.backgroundColor = DEF_COLOR_ECECEC;
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
   

}

-(void)toStaffEvaluateViewController{

    JHBoss_StaffEvaluateViewController *evaluateVC = [[JHBoss_StaffEvaluateViewController alloc]init];
    evaluateVC.staffDetailModel = self.staffDetailModel;
    evaluateVC.currentSelectShop = self.currentSelectShop;
    [self.navigationController pushViewController:evaluateVC animated:YES];

}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHCRM_MineMainCell *cell = [JHCRM_MineMainCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JHCRM_MineMainModel *model = self.dataArr[indexPath.section][indexPath.row];;
    if ([model.title isEqualToString:@"所在分组"]){
        
        JHBoss_staffGroupViewController *groupVC = [[JHBoss_staffGroupViewController alloc]init];
        groupVC.staffInfo = self.staffInfo;
        groupVC.sectionName = self.sectionName;
        groupVC.sectionId = self.sectionId;
        groupVC.currentSelectShop = self.currentSelectShop;
        @weakify(self);
        groupVC.modificationSectionBlock = ^{
            @strongify(self);
            [self loadData];
            
            if (self.updateStaffListBlock) {
                self.updateStaffListBlock();
            }
        };
        [self.navigationController pushViewController:groupVC animated:YES];
        
    }else if ([model.title isEqualToString:@"账号信息"]){
        
        JHBoss_staffAccountInfoViewController *accountVC = [[JHBoss_staffAccountInfoViewController alloc]init];
        accountVC.accountModel = self.staffDetailModel.accountModel;
        [self.navigationController pushViewController:accountVC animated:YES];
        
    }else if ([model.title isEqualToString:@"备注信息"]){
        
        JHBoss_staffRemarkInfoViewController *remarkVC = [[JHBoss_staffRemarkInfoViewController alloc]init];
        remarkVC.enterIntoType = JHBoss_type_remark;
        @weakify(self);
        remarkVC.updateStaffDeatil = ^{
            @strongify(self);
            [self loadData];
        };
        remarkVC.staffDetailModel = self.staffDetailModel;
        [self.navigationController pushViewController:remarkVC animated:YES];
    }else if ([model.title isEqualToString:@"收到打赏"]){
        
        JHBoss_StaffRewardDetailViewController *rewardVC = [[JHBoss_StaffRewardDetailViewController alloc]init];
        rewardVC.staffDetailModel = self.staffDetailModel;
        rewardVC.restId = self.currentSelectShop;
        [self.navigationController pushViewController:rewardVC animated:YES];
    }
}

//加载数据
-(void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.currentSelectShop forKey:@"restId"];

    [parmDic setValue:[NSString stringWithFormat:@"%ld",self.staffInfo.ID] forKey:@"staffId"];
    [JHUtility showGifProgressViewInView:self.view];
   
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_StaffDetailsURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
         [JHUtility hiddenGifProgressViewInView:self.view];
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                self.staffDetailModel = [JHBoss_StaffDetailModel mj_objectWithKeyValues:dic[@"data"]];
                self.headerView.staffDetailModel = self.staffDetailModel;
                self.sectionId = self.staffDetailModel.departmentId.stringValue;
                [self evaluationData];
            
            }
            
        }
        
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
         [JHUtility hiddenGifProgressViewInView:self.view];
    }];
    
}



#pragma mark - Getter/Settrt
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setCellLineUIEdgeInsetsZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}


- (NSMutableArray *)dataArr{
    if (!_dataArr) {
       
        _dataArr = [NSMutableArray array];
    }
   
    return _dataArr;
}
//给dataArr赋值
-(void)evaluationData{

    self.sectionName = self.staffDetailModel.classify;
    NSMutableArray *shopArr = [[NSMutableArray alloc] init];
    NSArray *shopTitleArr = @[@"所在店铺",@"所在分组"];
    NSArray *shopInfoArr = @[DEF_OBJECT_TO_STIRNG(_staffDetailModel.shopName),DEF_OBJECT_TO_STIRNG(_staffDetailModel.classify)];
    NSArray *shopTypeArr = @[[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Space],[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Arrow]];
    for (int i = 0; i < shopTitleArr.count; i++) {
        JHCRM_MineMainModel *model = [[JHCRM_MineMainModel alloc] init];
        model.title = shopTitleArr[i];
        model.personalCenterCellType = [shopTypeArr[i] integerValue];
        model.titleDel = shopInfoArr[i];
        model.titleFont = [UIFont systemFontOfSize:15];
        model.titleDelFont = [UIFont systemFontOfSize:15];
        model.titleColor = DEF_COLOR_6E6E6E;
        model.titleDelColor = DEF_COLOR_A1A1A1;
        [shopArr addObject:model];
    }
    
    
    NSMutableArray *contactInfoArr = [[NSMutableArray alloc] init];
    NSArray *titleArr = @[@"联系电话",@"通讯地址",@"账号信息"];
    NSArray *infoArr = @[DEF_OBJECT_TO_STIRNG(_staffDetailModel.phone),DEF_OBJECT_TO_STIRNG(_staffDetailModel.address),@""];
    NSArray *typeArr = @[[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Space],[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Space],[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Arrow]];
    
    for (int i = 0; i < titleArr.count; i++) {
        JHCRM_MineMainModel *model = [[JHCRM_MineMainModel alloc] init];
        model.title = titleArr[i];
        model.personalCenterCellType = [typeArr[i] integerValue];
        model.titleDel = infoArr[i];
        model.titleFont = [UIFont systemFontOfSize:15];
        model.titleDelFont = [UIFont systemFontOfSize:15];
        model.titleColor = DEF_COLOR_6E6E6E;
        model.titleDelColor = DEF_COLOR_A1A1A1;
        [contactInfoArr addObject:model];
    }
    
    
    NSMutableArray *lastArr = [[NSMutableArray alloc] init];
    NSArray *lastTitleArr = @[@"收到打赏",@"备注信息"];
    NSString *rewardMoney = [NSString stringWithFormat:@"%g",_staffDetailModel.rewardMoney.doubleValue/100];
    NSArray *lastInfoArr = @[[rewardMoney stringByAppendingString:@"元"],DEF_OBJECT_TO_STIRNG(_staffDetailModel.remarks)];
    NSArray *lastTypeArr = @[[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Arrow],[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Arrow]];
    for (int i = 0; i < shopTitleArr.count; i++) {
        JHCRM_MineMainModel *model = [[JHCRM_MineMainModel alloc] init];
        model.title = lastTitleArr[i];
        model.personalCenterCellType = [lastTypeArr[i] integerValue];
        model.titleDel = lastInfoArr[i];
        model.titleFont = [UIFont systemFontOfSize:15];
        model.titleDelFont = [UIFont systemFontOfSize:15];
        model.titleColor = DEF_COLOR_6E6E6E;
        model.titleDelColor = DEF_COLOR_A1A1A1;
        [lastArr addObject:model];
    }
    
    self.dataArr = [NSMutableArray arrayWithObjects:shopArr,contactInfoArr,lastArr, nil];

//     self.infoArr = _dataArr;
}


#pragma mark ---显示员工二维码-----
#pragma mark 显示图片
- (void)showHelpImage:(id)sender{
    [self.view endEditing:YES];
    JHBoss_ShowStaffQRImageViewController *imageViewController = [[JHBoss_ShowStaffQRImageViewController alloc] init];
    imageViewController.modalPresentationStyle = UIModalPresentationPopover;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"image4" ofType:@"jpg"];
    UIImage *fileImage = [UIImage imageWithContentsOfFile:path];
    imageViewController.image = fileImage;
    //MYDIMESCALE(DEF_WIDTH - MYDIMESCALE(50)
    imageViewController.preferredContentSize = CGSizeMake(DEF_WIDTH - 20, DEF_WIDTH - 10);
    
    UIPopoverPresentationController *presentationController =
    [imageViewController popoverPresentationController];
    presentationController.delegate = self;
    UIButton *thisButton = sender;
    presentationController.sourceView = thisButton;
    presentationController.sourceRect = thisButton.bounds;
    presentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    presentationController.backgroundColor = [UIColor colorWithRGBValue:0 g:0 b:0 alpha:0.9];
    [self presentViewController:imageViewController animated:YES completion:nil];
}

#pragma mark - UIAdaptivePresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
