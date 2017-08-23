//
//  JHBoss_SectionManagerViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SectionManagerViewController.h"
#import "JHBoss_SectionManagerTableViewCell.h"
#import "JHBoss_SectionManagerHeaderView.h"
#import "JHBoss_SectionManagerUnfoldModel.h"
#import "JHBoss_staffRemarkInfoViewController.h"
#import "JHBoss_RestClassification.h"
@interface JHBoss_SectionManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray *sectionData;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) UIButton *lastTapBtn;//当前点击cell上的button
@property (nonatomic, assign) NSInteger lastSection;

@end

@implementation JHBoss_SectionManagerViewController

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

    self.jhtitle = @"分类管理";
    [self.rightNavButton setimage:@"nav_icon_add"];
    
    [self.view addSubview:self.tableView];
    _tableView.tableHeaderView.backgroundColor = DEF_COLOR_ECECEC;
    self.tableView.rowHeight = 60;
    @weakify(self);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.navBar.mas_bottom);
        make.trailing.mas_equalTo(0);
        make.leading.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];

    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_SectionManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_SectionManagerTableViewCell"];
    [self.tableView registerClass:[JHBoss_SectionManagerHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    JHBoss_SectionManagerUnfoldModel *model = self.sectionData[section];


    return model.isExpand ? 1 : 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *reuse = @"JHBoss_SectionManagerTableViewCell";
    JHBoss_SectionManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    cell.modificationTF.delegate = self;
   
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    JHBoss_SectionManagerHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
   __block JHBoss_SectionManagerUnfoldModel *model = self.sectionData[section];
    view.model = model;
    
    JHBoss_RestClassification *ClassificationModel = self.dataArr[section];
    view.ClassificationModel = ClassificationModel;
    
    @weakify(self);
    view.unfoldBlock = ^(BOOL isExpanded,UIButton *btn) {
         @strongify(self);
        
        if (isExpanded) {
            
            if (self.lastTapBtn != btn && self.lastTapBtn != nil && self.lastTapBtn != [NSNull class]) {
                
#pragma mark -- 有内存泄漏 ---
                JHBoss_SectionManagerUnfoldModel *lastModel = self.sectionData[_lastSection];
                lastModel.isExpand = NO;
                model.isExpand = NO;
                
                JHBoss_SectionManagerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_lastSection]];
                if (cell.modificationTF.text.length > 0) {
                    
                    
                     lastModel.title = cell.modificationTF.text;
                      [self modificationStaffSection:section newClassifyName:cell.modificationTF.text];
                }
               
                cell.modificationTF.text = @"";
                [self.tableView reloadData];
                

                
                self.lastTapBtn = nil;
                
            }else if (self.lastTapBtn == nil || self.lastTapBtn == [NSNull class]){
            
                self.lastTapBtn = btn;
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
                
                JHBoss_SectionManagerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
                [cell.modificationTF becomeFirstResponder];
            
            }
            
            
        }else{
        
            JHBoss_SectionManagerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
            
            [cell.modificationTF resignFirstResponder];
            JHBoss_SectionManagerUnfoldModel *Model = self.sectionData[section];
            if (cell.modificationTF.text.length > 0) {
                
                Model.title = cell.modificationTF.text;
                 [self modificationStaffSection:section newClassifyName:cell.modificationTF.text];
            }
            cell.modificationTF.text = @"";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            
           
            self.lastTapBtn = nil;
            
        }
        
        self.lastSection = section;
    };
    
    view.deletBlock = ^{
        
//        DPLog(@"删除%ld",(long)section);
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteStaffSection:section];
        }];
      
        NSString *titleStr = [@"确定要删除 " stringByAppendingString:ClassificationModel.name];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    };
    
   
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 50;
}



//获取所有分组
//加载数据
-(void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:@"25" forKey:@"restId"];
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

//编辑分组
-(void)modificationStaffSection:(NSInteger )indexPath newClassifyName:(NSString *)newClassifyName{
    
    JHBoss_RestClassification *ClassificationModel = self.dataArr[indexPath];
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:@"25" forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%ld",ClassificationModel.ID] forKey:@"classifyId"];
    [parmDic setValue:newClassifyName forKey:@"newClassifyName"];
    
    [JHUtility showGifProgressViewInView:self.view];
   
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_EditClassification isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        [JHUtility hiddenGifProgressViewInView:self.view];
        
        NSDictionary *dic = object;
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            
            [self loadData];
        }
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
        
        
    }];
    
}

//删除分组
-(void)deleteStaffSection:(NSInteger)indexPath{
    
    JHBoss_RestClassification *ClassificationModel = self.dataArr[indexPath];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:@"25" forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%ld",ClassificationModel.ID] forKey:@"classifyId"];
   
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_DeleteClassification isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
         [JHUtility hiddenGifProgressViewInView:self.view];
        NSDictionary *dic = object;
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            
            [self loadData];
        }
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


-(void)onClickRightNavButton:(UIButton *)rightNavButton{

    JHBoss_staffRemarkInfoViewController *remarkVC = [[JHBoss_staffRemarkInfoViewController alloc]init];
    remarkVC.enterIntoType = JHBoss_type_addSection;
    remarkVC.addSectionBlock = ^{
        [self loadData];
    };
    [self.navigationController pushViewController:remarkVC animated:YES];

}

#pragma  mark --- UITextFieldDelegate ----
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    JHBoss_SectionManagerTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_lastSection]];
    
    [cell.modificationTF resignFirstResponder];
    JHBoss_SectionManagerUnfoldModel *Model = self.sectionData[_lastSection];
    Model.isExpand = NO;
    if (cell.modificationTF.text.length > 0) {
        
        Model.title = cell.modificationTF.text;
        [self modificationStaffSection:_lastSection newClassifyName:cell.modificationTF.text];
    }
    cell.modificationTF.text = @"";
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:_lastSection] withRowAnimation:UITableViewRowAnimationFade];
    
    
    self.lastTapBtn = nil;
    
    return YES;
}


//懒加载
- (NSMutableArray *)sectionData{
    
    if (_sectionData == nil) {
        
        _sectionData = [[NSMutableArray alloc]init];
        
        for (int i=0; i < self.dataArr.count; i++) {
            
            JHBoss_SectionManagerUnfoldModel *model = [[JHBoss_SectionManagerUnfoldModel alloc]init];
           
            model.isExpand = NO;
            [_sectionData addObject:model];
            
        }
    }
    return _sectionData;
    
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
