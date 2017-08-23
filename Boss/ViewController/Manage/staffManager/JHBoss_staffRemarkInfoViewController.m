//
//  JHBoss_staffRemarkInfoViewController.m
//  Boss
//
//  Created by jinghankeji on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_staffRemarkInfoViewController.h"
#import "JH_CustomTextView.h"
@interface JHBoss_staffRemarkInfoViewController ()
@property (weak, nonatomic) IBOutlet JH_CustomTextView *customTextView;

@end

@implementation JHBoss_staffRemarkInfoViewController

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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    
    if (self.enterIntoType == JHBoss_type_remark) {
        
        self.jhtitle = @"备注信息";
        self.customTextView.textView.text = self.staffDetailModel.remarks;
        
        self.customTextView.maxNumber = 200;
    }else if (self.enterIntoType ==  JHBoss_type_addSection){
    
        self.jhtitle = @"添加分类";
        self.customTextView.textView.text = self.staffDetailModel.remarks;
        self.customTextView.maxNumber = 20;
    }
    [self.customTextView.textView becomeFirstResponder];
    [self.rightNavButton setimage:@"nav_icon_wancheng"];
}

-(void)onClickRightNavButton:(UIButton *)rightNavButton{

    DPLog(@"提交");
    NSString *url;
     NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    if (self.enterIntoType == JHBoss_type_remark) {
        
        [parmDic setValue:[NSString stringWithFormat:@"%ld",self.staffDetailModel.ID] forKey:@"staffId"];
        [parmDic setValue:self.customTextView.textView.text forKey:@"remarksContent"];
       
        url = JH_StaffRemarkUrl;
    }else if (self.enterIntoType ==  JHBoss_type_addSection){
        
        url = JH_addRestSectionURL;
        
        [parmDic setValue:_currentShop forKey:@"restId"];
        [parmDic setValue:self.customTextView.textView.text forKey:@"name"];
    }
    //添加部门
    [JHUtility showGifProgressViewInView:self.view];
    
    @weakify(self);
    [JHHttpRequest postRequestWithParams:parmDic path:url isShowLoading:NO isNeedCache:NO success:^(id object) {
        @strongify(self);
        [JHUtility hiddenGifProgressViewInView:self.view];
    
        NSDictionary *dic = object;
        [JHUtility showToastWithMessage:dic[@"showMsg"]];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            
            if (self.enterIntoType == JHBoss_type_remark) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }else if (self.enterIntoType ==  JHBoss_type_addSection){
                
               [self.navigationController popViewControllerAnimated:YES];
            }
           
        }
        
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    if (self.addSectionBlock) {
        self.addSectionBlock();
    }

    if (self.updateStaffDeatil) {
        self.updateStaffDeatil();
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
