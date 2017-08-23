//
//  JHBoss_InviteStaffDetailViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_InviteStaffDetailViewController.h"
#import "JHBoss_InviteStaffDetailHeaderView.h"
#import "JHBoss_InviteStaffDetailTableViewCell.h"
@interface JHBoss_InviteStaffDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) JHBoss_InviteStaffDetailHeaderView *headerView;
@property (nonatomic, strong) UIView *footView;
@end

@implementation JHBoss_InviteStaffDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

-(void)setUI{

    self.jhtitle = @"人员详情";
    
    
    self.headerView = [[JHBoss_InviteStaffDetailHeaderView alloc]initWithFrame:CGRectZero];
//    self.headerView.frame = CGRectMake(0, 0, DEF_WIDTH, 200);
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footView;
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_InviteStaffDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_InviteStaffDetailTableViewCell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 3;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_InviteStaffDetailTableViewCell";
    JHBoss_InviteStaffDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - Getter/Settrt
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 111;
        [_tableView setCellLineUIEdgeInsetsZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}


-(UIView *)footView{

    if (!_footView) {
        _footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 110)];
        _footView.backgroundColor = DEF_COLOR_F5F5F5;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = DEF_COLOR_CDA265;
        [btn setTitle:@"联系他"];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(contactStaff:) forControlEvents:UIControlEventTouchUpInside];
        [_footView addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.mas_equalTo(37.5);
            make.right.mas_equalTo(-37.5);

            make.top.mas_equalTo(50);
        }];
        
    }

    return _footView;
}

-(void)contactStaff:(UIButton *)sender{

    DPLog(@"联系他");

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
