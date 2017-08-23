//
//  JHBoss_ShopManagerViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/4/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ShopManagerViewController.h"
#import "JHBoss_MenuViewController.h"
#import "JHBoss_OrderManagerViewController.h"
#import "JHBoss_tableManagerViewController.h"
@interface JHBoss_ShopManagerViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation JHBoss_ShopManagerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"店铺管理"];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:@"店铺管理"];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

-(void)setUI{

     self.view.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = DEF_COLOR_LINEVIEW;
    _tableView.rowHeight = 50;
    _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    [_tableView setCellLineUIEdgeInsetsZero];
    [self.view addSubview:_tableView];
    
    @weakify(self)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.left.right.and.top.bottom.mas_equalTo(0);
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"tableViewCell"];
    [self.tableView addCustomGifHeaderWithRefreshingBlock:^{
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:loadRestListNotifiction object:nil];
        [self.tableView.mj_header endRefreshing];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse forIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        cell.imageView.image = DEF_IMAGENAME(@"2.1_icon_caidanchakan");
        cell.textLabel.text = @"菜单查看";
        
    }else if (indexPath.row == 1){
    
        cell.imageView.image = DEF_IMAGENAME(@"2.1_icon_dingdanguanli");
        cell.textLabel.text = @"订单管理";
        
    }else if (indexPath.row == 2){
        
        cell.imageView.image = DEF_IMAGENAME(@"2.1_icon_zhuotaiguanli");
        cell.textLabel.text = @"桌台管理";
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = DEF_COLOR_RGB(110, 110, 110);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)setAllShopArr:(NSMutableArray *)allShopArr{

    _allShopArr = allShopArr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        
        JHBoss_MenuViewController *menuVC  = [[JHBoss_MenuViewController alloc]init];
        menuVC.currentSelectShop = self.currentSelectShop;
        menuVC.allShopArr = [self.allShopArr mutableCopy];
        [self.navigationController pushViewController:menuVC animated:YES];
        
    }else if (indexPath.row == 1){
    
        JHBoss_OrderManagerViewController *orderVC = [[JHBoss_OrderManagerViewController alloc]init];
        orderVC.allShopArr = [self.allShopArr mutableCopy];
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }else if (indexPath.row == 2){
        
        JHBoss_tableManagerViewController *tableMangVC = [[JHBoss_tableManagerViewController alloc]init];
        tableMangVC.allShopArr = [self.allShopArr mutableCopy];
        [self.navigationController pushViewController:tableMangVC animated:YES];
    }
}

//隐藏导航条
-(BOOL)disableAutomaticSetNavBar{
    
    return YES;
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
