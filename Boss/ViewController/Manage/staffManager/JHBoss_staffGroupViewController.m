//
//  JHBoss_staffGroupViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_staffGroupViewController.h"
#import "JHBoss_RestClassification.h"
@interface JHBoss_staffGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation JHBoss_staffGroupViewController

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
    [self loadData];
    [self setUI];
}

-(void)setUI{
    
    self.jhtitle = @"所在分组";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
       [self.view addSubview:self.tableView];
    _tableView.tableHeaderView.backgroundColor = DEF_COLOR_ECECEC;
    _tableView.rowHeight = 50;
    _tableView.tableFooterView = [UIView new];
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    JHBoss_RestClassification *model = self.dataArr[indexPath.row];
    
    if ([self.sectionName isEqualToString:model.name]) {
        
      cell.textLabel.textColor = DEF_COLOR_CDA265;
    }else{
    
      cell.textLabel.textColor = DEF_COLOR_6E6E6E;
    
    }
    DPLog(@"%ld",self.staffInfo.ID);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
  
    cell.textLabel.text = model.name;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self modificationStaffSection:indexPath];
    }];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"您确定修改该员工所在部门?" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:cancel];
    [alertC addAction:sure];
    
    [self presentViewController:alertC animated:YES completion:nil];

}

#pragma mark - Getter/Settrt
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setCellLineUIEdgeInsetsZero];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorColor = DEF_COLOR_ECECEC;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

//获取所有分组
//加载数据
-(void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.currentSelectShop forKey:@"restId"];
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_restSectionURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        
        NSDictionary *dic = object;
        [JHUtility hiddenGifProgressViewInView:self.view];
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (isObjNotEmpty(dic[@"data"])) {
                
                
                self.dataArr = [JHBoss_RestClassification mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            }
            
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
         [JHUtility hiddenGifProgressViewInView:self.view];
    }];
    
}


//修改分组
-(void)modificationStaffSection:(NSIndexPath *)indexPath{

    JHBoss_RestClassification *ClassificationModel = self.dataArr[indexPath.row];
   
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.currentSelectShop forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%ld",self.staffInfo.ID] forKey:@"staffId"];
    
    [parmDic setValue:[NSString stringWithFormat:@"%ld",ClassificationModel.ID] forKey:@"newGroupId"];
    [parmDic setValue:self.sectionId forKey:@"oldGroupId"];
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_ModifyStaffSectionURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        [JHUtility hiddenGifProgressViewInView:self.view];
        NSDictionary *dic = object;
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (self.modificationSectionBlock) {
                self.modificationSectionBlock();
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
        
      
    }];

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
