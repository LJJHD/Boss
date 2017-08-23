//
//  JHBoss_AppreciationServiceFeeViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/6/26.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_AppreciationServiceFeeViewController.h"
#import "JHCRM_MineMainModel.h"
#import "JHCRM_MineMainCell.h"
#import "JHBoss_NoteServiceTableViewCell.h"

#import "JHBoss_RecordViewController.h"
#import "JHBoss_TemsForUsageViewController.h"
@interface JHBoss_AppreciationServiceFeeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JHBoss_AppreciationServiceFeeViewController

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
    [self setUpUI];
}

-(void)setUpUI{

    self.jhtitle = @"增值服务费";
    [self defaultData];
    
    @weakify(self);
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
    self.tableView.separatorColor = DEF_COLOR_ECECEC;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.and.bottom.right.mas_equalTo(0);
        
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_NoteServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_NoteServiceTableViewCell"];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_NoteServiceTableViewCell";
    JHBoss_NoteServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    JHCRM_MineMainModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    [cell setCellLineUIEdgeInsetsZero];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        JHCRM_MineMainModel *model = self.dataArray[indexPath.row];
        
        //进入记录页面
        JHBoss_RecordViewController *recordVC = [[JHBoss_RecordViewController alloc] init];
        recordVC.recordTittle                 = model.title;
        recordVC.merchanId = self.merchanId;
        recordVC.recordType = JHBoss_recordType_recharge;
        [self.navigationController pushViewController:recordVC animated:YES];
        
    }else if (indexPath.row == 1){
    
        JHCRM_MineMainModel *model = self.dataArray[indexPath.row];
        
        //进入记录页面
        JHBoss_RecordViewController *recordVC = [[JHBoss_RecordViewController alloc] init];
        recordVC.recordTittle                 = model.title;
        recordVC.merchanId = self.merchanId;
        recordVC.recordType = JHBoss_recordType_consum;
        [self.navigationController pushViewController:recordVC animated:YES];
    }else{
    
        JHBoss_TemsForUsageViewController *TemsVC = [[JHBoss_TemsForUsageViewController alloc]init];
        TemsVC.protocalType = JHBoss_protocalType_WalletOrNoteProtocal;
        [self.navigationController pushViewController:TemsVC animated:YES];
    
    }
    
}

//给dataArr赋值
-(void)defaultData{
    
    NSArray *titleArr = @[@"钱包充值记录",@"钱包消费记录",@"增值服务说明"];
    
    NSArray *typeArr = @[[NSNumber numberWithInteger:PersonalCenterCellType_Title_Arrow],[NSNumber numberWithInteger:PersonalCenterCellType_Title_Arrow],[NSNumber numberWithInteger:PersonalCenterCellType_Title_Arrow],[NSNumber numberWithInteger:PersonalCenterCellType_Title_Arrow]];
    
    for (int i = 0; i < titleArr.count; i++) {
        JHCRM_MineMainModel *model = [[JHCRM_MineMainModel alloc] init];
        model.title = titleArr[i];
        model.personalCenterCellType = [typeArr[i] integerValue];
        
        model.titleFont = [UIFont systemFontOfSize:15];
        model.titleColor = DEF_COLOR_6E6E6E;
        [self.dataArray addObject:model];
    }
    
//    self.dataArray = [NSMutableArray arrayWithObjects:contactInfoArr, nil];
}

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
