//
//  JHBoss_OrderDetailViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_MenuOrderDetailViewController.h"
#import "JHBoss_OrderDetailFoodView.h"
#import "JHBoss_OrderDetailTableViewCell.h"
#import "JHBoss_OrderDeatailTableViewCell.h"
#import "JHBoss_OrderListModel.h"
#import "JHBoss_OrderDetailWaiterTableViewCell.h"
#import "JHBoss_OrderDetailWaiterEvaluateView.h"
@interface JHBoss_MenuOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHBoss_OrderDetailFoodView *tableFoodView;//section foodview
@property (nonatomic, strong) UILabel *restaurantName;//餐厅名
@property (nonatomic, strong) JHBoss_OrderListModel *orderDetailModel;
@property (nonatomic, strong) JHBoss_OrderDetailWaiterEvaluateView *ClientEvaluateView;//客户评价View  tableFoodView
@end

@implementation JHBoss_MenuOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}


-(void)dealloc{

    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self orderDeatail];
    [self setUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    
    CGRect keyBoardRect=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height+20, 0);
}

-(void)keyboardWillHide:(NSNotification *)notification{

    self.tableView.contentInset = UIEdgeInsetsZero;
}


-(void)setUI{
    
    self.jhtitle = @"订单详情";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorColor = DEF_COLOR_LINEVIEW;
    _tableView.rowHeight = 90;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    [_tableView setCellLineUIEdgeInsetsZero];
    [self.view addSubview:_tableView];
    @weakify(self)
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self)
        make.top.equalTo(self.navBar.mas_bottom);
        make.left.right.and.bottom.mas_equalTo(0);
        
    }];
   
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_OrderDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_OrderDetailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_OrderDeatailTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_OrderDeatailTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JHBoss_OrderDetailWaiterTableViewCell" bundle:nil] forCellReuseIdentifier:@"JHBoss_OrderDetailWaiterTableViewCell"];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else if (section == 1){
    
        return self.orderDetailModel.dishesList.count;
    }else if (section == 2){
    
        
        return self.orderDetailModel.waiterList.count;
    }
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 40;
    } else if(section == 1) {
        
        if (self.orderDetailModel.dishesList.count > 0) {
            
          return 50;
        }else{
        
         return 0.0000000000001;
        }
       
    }else if (section == 2){
    
        return 40;
    }
    return 0.0000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
       
        return 0.0000000001;
    }else if (section == 1){
    
        return self.orderDetailModel.state == 1 ? 145 : 99;
    }else if (section == 2){
    
        return 40;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        
        return 124;
    } else if(indexPath.section == 1) {
        return 44;
    }else{
    
        return 92;
    }

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *OrderDetail = @"JHBoss_OrderDetailTableViewCell";
    static NSString *OrderManager = @"JHBoss_OrderDeatailTableViewCell";
    static NSString *waiter = @"JHBoss_OrderDetailWaiterTableViewCell";

    if (indexPath.section == 0) {
        
        JHBoss_OrderDeatailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderManager forIndexPath:indexPath];
        cell.orderListModel = self.orderDetailModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    }else if (indexPath.section == 1){
    
        JHBoss_OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderDetail forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.dishesList = self.orderDetailModel.dishesList[indexPath.row];
        return cell;
    
    }else{
    
        JHBoss_OrderDetailWaiterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:waiter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.waiterListModel = self.orderDetailModel.waiterList[indexPath.row];
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    if (section == 0) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        
        _restaurantName = [[UILabel alloc]initWithFrame:CGRectZero];
        _restaurantName.textColor = DEF_COLOR_6E6E6E;
        _restaurantName.font = DEF_SET_FONT(15);
        _restaurantName.text = self.orderDetailModel.restName;
        [view addSubview:_restaurantName];
        [_restaurantName mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.left.mas_equalTo(20);
            make.centerY.equalTo(view.mas_centerY);
        }];
        
        UIView *Lineview = [[UIView alloc]initWithFrame:CGRectZero];
        Lineview.backgroundColor = DEF_COLOR_ECECEC;
        [view addSubview:Lineview];
        [Lineview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.and.bottom.mas_equalTo(0);
            make.height.mas_equalTo(0.5);
        }];
        return view;
        
    }else if(section == 1){
    
        if (self.orderDetailModel.dishesList.count > 0) {
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 25)];
            view.backgroundColor = [UIColor whiteColor];
            UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 21, 120, 30)];
            lab.text = @"菜品明细:";
            lab.font = [UIFont systemFontOfSize:15];
            lab.textColor = DEF_COLOR_6E6E6E;
            [view addSubview:lab];
                       return view;
        }else{
        
            return nil;
        }
        
    }else if (section == 2){
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 40)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLB.text = @"服务人员";
        titleLB.font = [UIFont systemFontOfSize:15];
        titleLB.textColor = DEF_COLOR_6E6E6E;
        [view addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.5);
            make.centerY.equalTo(view.mas_centerY);
        }];

        return view;
    
    }
    
    return nil;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    if(section == 1){

        return self.tableFoodView;
       
    }else if (section == 2){
    
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 40)];
        view.backgroundColor = [UIColor colorWithHexString:@"#f4f4f4"];
        UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLB.text = @"评价";
        titleLB.font = [UIFont systemFontOfSize:15];
        titleLB.textColor = DEF_COLOR_6E6E6E;
        [view addSubview:titleLB];
        [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20.5);
            make.centerY.equalTo(view.mas_centerY);
        }];
        return view;
    }
    return nil;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 2) {
         WaiterList *waiterListModel = self.orderDetailModel.waiterList[indexPath.row];
        if (waiterListModel.phone.length > 0) {
            
            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",waiterListModel.phone];
            UIWebView *callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }else{
        
            [JHUtility showToastWithMessage:@"暂无该员工联系电话"];
        }
        
    }
}


-(JHBoss_OrderDetailFoodView *)tableFoodView{

    if (!_tableFoodView) {
        _tableFoodView = [[JHBoss_OrderDetailFoodView alloc]initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 135)];
        @weakify(self);
        _tableFoodView.discountBlock = ^(NSString *money, NSString *discount) {
            @strongify(self)
            [self manageOrderMoney:money discount:discount];
        };
    }
    return _tableFoodView;
}

-(JHBoss_OrderDetailWaiterEvaluateView *)ClientEvaluateView{

    if (!_ClientEvaluateView) {
        
        _ClientEvaluateView = [[JHBoss_OrderDetailWaiterEvaluateView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0) orientation:MyOrientation_Vert];
//        _ClientEvaluateView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 0);
        _ClientEvaluateView.backgroundColor = [UIColor whiteColor];
        
    }

    return _ClientEvaluateView;
}

//减/免订单
-(void)manageOrderMoney:(NSString *)money discount:(NSString *)discount{

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.currentSelectShop forKey:@"restId"];
    [parmDic setValue:[NSString stringWithFormat:@"%ld",_orderDetailModel.ID] forKey:@"orderId"];
    [parmDic setValue:money forKey:@"decrease"];//减免金额
//    [parmDic setValue:discount forKey:@"discount"];//折扣
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_orderMangerUrl isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        [JHUtility hiddenGifProgressViewInView:self.view];
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
          [JHUtility showToastWithMessage:@"网络异常"];
         [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}
//获取订单详情
-(void)orderDeatail{

    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    [parmDic setValue:self.currentSelectShop forKey:@"restId"];
    [parmDic setValue:self.orderId forKey:@"orderId"];
   
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:JH_OrderDetailURL isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        NSDictionary *dic = object;
        [JHUtility hiddenGifProgressViewInView:self.view];
        
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            self.orderDetailModel = [JHBoss_OrderListModel mj_objectWithKeyValues:dic[@"data"]];

            self.tableFoodView.orderListModel = self.orderDetailModel;
            self.ClientEvaluateView.model = self.orderDetailModel;
            
            //由于tableFooterView为非布局视图，需要具体的frame
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.ClientEvaluateView layoutIfNeeded];
                self.tableView.tableFooterView = self.ClientEvaluateView;
            });
           
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        
        [JHUtility showToastWithMessage:@"网络异常"];
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
