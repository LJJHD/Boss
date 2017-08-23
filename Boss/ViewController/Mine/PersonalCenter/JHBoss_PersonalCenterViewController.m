//
//  JHBoss_PersonalCenterViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_PersonalCenterViewController.h"
#import "JHBoss_PersonalCenterTableViewCell.h"
#import "JHBoss_IconTableViewCell.h"
#import "JHBoss_DisplayNameViewController.h"
#import "JHCRM_UploadSingleImgManager.h"
#import "JHBoss_UploadFileModel.h"

@interface JHBoss_PersonalCenterViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHCRM_UploadSingleImgManager *uploadManager;
@property (nonatomic, strong) JHBoss_UploadFileModel *uploadModel;

@end

@implementation JHBoss_PersonalCenterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    // Do any additional setup after loading the view.
}


#pragma mark - request

//上传头像
-(void)uploadImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *parmDic = [NSMutableDictionary dictionary];
    NSData *imageData;
    if (image) {
        imageData= UIImageJPEGRepresentation(image,0.7);
    }
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000 ;
    NSString *commodityName = [NSString stringWithFormat:@"%d.jpeg",(int)interval];
    
    [JHUtility showGifProgressViewInView:self.view];
    @weakify(self);
    [JHHttpRequest uploadFileWithPath:JH_API_UPLOADFILE withParams:parmDic withData:imageData withFileType:1 withmimeType:@"image/jpeg" withFileName:commodityName success:^(id object) {
        @strongify(self);
        [JHUtility hiddenGifProgressViewInView:self.view];
        NSDictionary *dic = object;
        if (isObjNotEmpty(dic)&&[dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.uploadModel = [JHBoss_UploadFileModel mj_objectWithKeyValues:dic[@"data"]];
            
            // 更换头像
            NSMutableDictionary *param = [NSMutableDictionary dictionary];
            [param setObject:self.uploadModel.fullFilename?:@"" forKey:@"pictureFilePath"];
            [JHHttpRequest postRequestWithParams:param path:JH_API_ChangeUserIcon isShowLoading:NO isNeedCache:NO success:^(NSDictionary *object) {
                if ([dic[@"code"] integerValue] == JH_REQUEST_SUCCESS) {
                    self.model.photo = self.uploadModel.fullFilename;
                    [JHUtility showToastWithMessage:object[@"showMsg"]];
                }
                [self.tableView reloadData];
                [JHUtility hiddenGifProgressViewInView:self.view];
            } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
//                [JHUtility hiddenGifProgressViewInView:self.view];
                
            }];
            
        }
    } fail:^(NSString *errorMsg, JH_HttpRequestFailState errorState) {
        [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}


#pragma mark - UI

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [MobClick beginLogPageView:self.jhtitle];
}

-(void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    [MobClick endLogPageView:self.jhtitle];
}

- (void)setup
{
    self.jhtitle = @"个人中心";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
}


#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? section : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath.section) {
        static NSString *reuseId = @"JHBoss_IconTableViewCell";
        JHBoss_IconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[JHBoss_IconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.photo] placeholderImage:DEF_IMAGENAME(@"5.1_icon_gerenziliao")];
        return cell;
    } else {
        static NSString *reuseId = @"JHBoss_PersonalCenterTableViewCell";
        JHBoss_PersonalCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (!cell) {
            cell = [[JHBoss_PersonalCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 1) {
            cell.title = @"显示名称";
            cell.descTitle = self.model.nickName;
            cell.descColor = DEF_COLOR_6E6E6E;
        } else {
            switch (indexPath.row) {
                case 0:
                    cell.title = @"手机号码";
                    if (self.model.phoneNumber.length == 11) {
                        cell.descTitle = [NSString stringWithFormat:@"%@****%@", [self.model.phoneNumber substringToIndex:3], [self.model.phoneNumber substringFromIndex:7]];
                    } else {
                        cell.descTitle = @"";
                    }
                    break;
                case 1:
                    cell.title = @"用户ID";
                    cell.descTitle = self.model.userid.stringValue;
                    break;
//                case 2:
//                    cell.title = @"用户权限";
//                    cell.descTitle = self.model.authorityId.stringValue;
//                    break;
                    
                default:
                    break;
            }
        }
        cell.showIndicate = !(indexPath.section - 1);
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section ? 50 : 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    switch (indexPath.section + indexPath.row) {
        case 0:
        {
            [self.uploadManager showImagePickWithCurrentVc:self];
            
            self.uploadManager.returnImage = ^(UIImage *image){
                @strongify(self);
                if (image) {
                    [self uploadImage:image indexPath:indexPath];
                }
            };
        }
            break;
        case 1:
        {
            JHBoss_DisplayNameViewController *displayNameVC = [[JHBoss_DisplayNameViewController alloc] init];
            displayNameVC.model = self.model;
            [self.navigationController pushViewController:displayNameVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - setter/getter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = DEF_COLOR_F5F5F5;
    }
    return _tableView;
}

- (JHCRM_UploadSingleImgManager *)uploadManager
{
    if (_uploadManager == nil) {
        _uploadManager = [[JHCRM_UploadSingleImgManager alloc] init];
        _uploadManager.cropViewCroppingStyle = TOCropViewCroppingStyleCircular;
    }
    return _uploadManager;
}

@end
