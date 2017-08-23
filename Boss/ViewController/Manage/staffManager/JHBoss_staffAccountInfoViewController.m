//
//  JHBoss_staffAccountInfoViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_staffAccountInfoViewController.h"
#import "JHCRM_MineMainCell.h"
#import "JHCRM_MineMainModel.h"
@interface JHBoss_staffAccountInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArr;

@end

@implementation JHBoss_staffAccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

-(void)setUI{
    
    self.jhtitle = @"员工详情";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    
        [self.view addSubview:self.tableView];
    _tableView.tableHeaderView.backgroundColor = DEF_COLOR_ECECEC;
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
  
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHCRM_MineMainCell *cell = [JHCRM_MineMainCell cellWithTableView:tableView];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  50;
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
        NSArray *shopTitleArr = @[@"银行卡号",@"微信号"];
        NSArray *shopInfoArr = @[DEF_OBJECT_TO_STIRNG(_accountModel.bankCard),DEF_OBJECT_TO_STIRNG(_accountModel.wechatNumber)];
       
        NSArray *shopTypeArr = @[[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Space],[NSNumber numberWithInteger:PersonalCenterCellType_Title_DescribeLb_Space]];
        for (int i = 0; i < shopTitleArr.count; i++) {
            JHCRM_MineMainModel *model = [[JHCRM_MineMainModel alloc] init];
            model.title = shopTitleArr[i];
            model.personalCenterCellType = [shopTypeArr[i] integerValue];
            model.titleDel = shopInfoArr[i];
            model.titleFont = [UIFont systemFontOfSize:14];
            model.titleDelFont = [UIFont systemFontOfSize:13];
            model.titleColor = DEF_COLOR_6E6E6E;
            model.titleDelColor = DEF_COLOR_A1A1A1;
            [_dataArr addObject:model];
        }
        
    }
    return _dataArr;
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
