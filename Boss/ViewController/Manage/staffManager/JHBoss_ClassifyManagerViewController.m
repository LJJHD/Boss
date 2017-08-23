//
//  JHBoss_ClassifyManagerViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ClassifyManagerViewController.h"
#import "JHBoss_ClassifyManagerTableViewCell.h"
#import "JHBoss_RestClassification.h"
#import "JHBoss_staffRemarkInfoViewController.h"
@interface JHBoss_ClassifyManagerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, strong) UITableView     *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableDictionary *selectedIndexesDic;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;//上一次被点击的cell
@property (nonatomic, strong) NSString *lastModificationContent;//上次更新的内容
@end

@implementation JHBoss_ClassifyManagerViewController

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
    _selectedIndexesDic = [NSMutableDictionary dictionary];
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_ClassifyManagerTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_ClassifyManagerTableViewCell"];
   
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArr.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuse = @"JHBoss_ClassifyManagerTableViewCell";
    JHBoss_ClassifyManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    JHBoss_RestClassification *model = self.dataArr[indexPath.row];
    [cell restClassificationModel:model indexPath:indexPath];
    cell.textTF.delegate = self;
    @weakify(self);
    cell.deletBlock = ^(NSIndexPath *indexPath) {
        @strongify(self);
        
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }];
        
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteStaffSection:indexPath.row];
        }];
        
        NSString *titleStr = [@"确定要删除 " stringByAppendingString:model.name];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleStr message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:cancel];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
       
    };
    return cell;
}

//cell 是否选中
- (BOOL)cellIsSelected:(NSIndexPath*)indexPath {
    // Return whether the cell at the specified index path is selected or not
    NSNumber *selectedIndex = [_selectedIndexesDic objectForKey:indexPath];
    return selectedIndex == nil ? FALSE : [selectedIndex boolValue];
}

//设置行高

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    //return 35;
    if ([self cellIsSelected:indexPath]) {
        return 70;
    }
    return 50;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    // Deselect cell
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    // Toggle 'selected' state
    BOOL isSelected = ![self cellIsSelected:indexPath];
    // Store cell 'selected' state keyed on indexPath
    NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
    [_selectedIndexesDic setObject:selectedIndex forKey:indexPath];
    
    if (_lastIndexPath) {
        
        BOOL lastisSelected = ![self cellIsSelected:_lastIndexPath];
        NSNumber *lastSelectedIndex = [NSNumber numberWithBool:lastisSelected];
        [_selectedIndexesDic setObject:lastSelectedIndex forKey:_lastIndexPath];

    }
    
    
    // This is where magic happens...
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    JHBoss_ClassifyManagerTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textTF.hidden = NO;
    cell.sectionNamLab.hidden = YES;
    [cell.textTF becomeFirstResponder];
    cell.deletBtn.hidden = YES;
    
    if (_lastIndexPath) {
        
        JHBoss_ClassifyManagerTableViewCell *lastCell = [tableView cellForRowAtIndexPath:_lastIndexPath];
        lastCell.textTF.hidden = YES;
        [lastCell.textTF resignFirstResponder];
        lastCell.deletBtn.hidden = NO;
        lastCell.sectionNamLab.hidden = NO;

        _lastModificationContent = lastCell.textTF.text;
        JHBoss_RestClassification *ClassificationModel = self.dataArr[_lastIndexPath.row];
        if (![ClassificationModel.name isEqualToString:lastCell.textTF.text] && _lastModificationContent.length > 0) {
            
            [self modificationStaffSection:_lastIndexPath.row newClassifyName:lastCell.textTF.text];
            
        }
    }
   
    
    _lastIndexPath = indexPath;
}



//获取所有分组
//加载数据
-(void)loadData{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:_currentShop forKey:@"restId"];
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
    [parmDic setValue:_currentShop forKey:@"restId"];
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
            
             NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:indexPath inSection:0];
            JHBoss_RestClassification *model = [JHBoss_RestClassification mj_objectWithKeyValues:dic[@"data"]];
            [self.dataArr replaceObjectAtIndex:indexPath withObject:model];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
              
               JHBoss_ClassifyManagerTableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:lastIndexPath];
                lastCell.sectionNamLab.text = dic[@"data"][@"name"];
            });
    
        }
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
        
        
    }];
    
}

//删除分组
-(void)deleteStaffSection:(NSInteger)indexPath{
    
    JHBoss_RestClassification *ClassificationModel = self.dataArr[indexPath];
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:_currentShop forKey:@"restId"];
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
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorColor = DEF_COLOR_ECECEC;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}


-(void)onClickRightNavButton:(UIButton *)rightNavButton{
    
    JHBoss_staffRemarkInfoViewController *remarkVC = [[JHBoss_staffRemarkInfoViewController alloc]init];
    remarkVC.enterIntoType = JHBoss_type_addSection;
    remarkVC.currentShop = self.currentShop;
    remarkVC.addSectionBlock = ^{
        [self loadData];
    };
    [self.navigationController pushViewController:remarkVC animated:YES];
    
}

#pragma  mark --- UITextFieldDelegate ----
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    JHBoss_ClassifyManagerTableViewCell *lastCell = [self.tableView cellForRowAtIndexPath:_lastIndexPath];
    [self modificationStaffSection:_lastIndexPath.row newClassifyName:lastCell.textTF.text];
    
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    if (self.modificationSectionBlock) {
        self.modificationSectionBlock();
    }


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
