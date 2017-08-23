//
//  JHBoss_SuggestViewController.m
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_SuggestViewController.h"
#import "JHCRM_TagsView.h"
#import "JH_CustomTextView.h"
#import "JHBoss_SuggestModel.h"
#import "JHUserInfoData.h"
@interface JHBoss_SuggestViewController ()<UITableViewDelegate, UITableViewDataSource, JHTagsViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JHCRM_TagsView *tagsView;
@property (nonatomic, assign) CGFloat topHeight;
@property (nonatomic, strong) JH_CustomTextView *textView;
@property (nonatomic, strong) UIButton *submitBtn;

@end

@implementation JHBoss_SuggestViewController

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
    
    [self requestFunctionState];
    [self setup];
}


#pragma mark - request

// 获得反馈意见标签
- (void)requestFunctionState
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [JHHttpRequest postRequestWithParams:param path:JH_SuggestionLabels isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            self.dataArray = [JHBoss_SuggestModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            self.tagsView.tagsArray = [self.dataArray mutableArrayValueForKey:@"labelValue"];
            self.topHeight = self.dataArray.count ? self.tagsView.intrinsicContentSize.height : 0.01;
        }
        [self.tableView reloadData];
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
        
    }];
}

// 提交反馈意见
- (void)submitFeedback
{
    if (!self.textView.textView.text.length && !self.tagsView.selectedIndexes.count) {
        [JHUtility showToastWithMessage:@"请表达意见或建议再提交"];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSMutableString *paramString = [NSMutableString string];
    if (self.tagsView.selectedIndexes.count) {
        for (int i = 0; i < self.tagsView.selectedIndexes.count; i++) {
            JHBoss_SuggestModel *model = self.dataArray[[self.tagsView.selectedIndexes[i] integerValue]];
            [paramString appendString:model.Id.stringValue];
            if (i < self.tagsView.selectedIndexes.count - 1) {
                [paramString appendString:@","];
            }
        }
    }
    [JHUtility showGifProgressViewInView:self.view];
    [param setObject:paramString forKey:@"labelIds"];
    [param setObject:self.textView.textView.text forKey:@"content"];
    [JHHttpRequest postRequestWithParams:param path:JH_SubmitFeedback isShowLoading:NO isNeedCache:NO success:^(id object) {
        NSDictionary *dic = object;
        [JHUtility hiddenGifProgressViewInView:self.view];
        [JHUtility showToastWithMessage:dic[@"msg"]];
        if ([dic[@"code"] intValue]  == JH_REQUEST_SUCCESS) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } fail:^(NSString *errorMsg ,JH_HttpRequestFailState errorState) {
           [JHUtility hiddenGifProgressViewInView:self.view];
    }];
}


#pragma mark - UI

- (void)setup
{
    self.jhtitle = @"意见建议";
    self.view.backgroundColor = DEF_COLOR_F5F5F5;
    
    [self tagsViewInit];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.mas_equalTo(0);
        make.top.equalTo(self.navBar.mas_bottom);
    }];
    
    @weakify(self);
    [[self.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self submitFeedback];
    }];
    
    [[self.textView.textView rac_textSignal] subscribeNext:^(NSString *x) {
        @strongify(self);
        if (x.length) {
            self.submitBtn.enabled = YES;
        } else {
            self.submitBtn.enabled = self.tagsView.selecedTags.count;
        }
    }];
}

- (void)tagsViewInit
{
    self.tagsView.backgroundColor = [UIColor whiteColor];
    self.tagsView.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    self.tagsView.lineSpacing = 10;
    self.tagsView.interitemSpacing = 10;
    self.tagsView.isShowAddImageView = NO;
    self.tagsView.tagLabelBorderWidth = 0.5;
    self.tagsView.tagLabelBorderColor = DEF_COLOR_D7D7D7;
    self.tagsView.tagLabelSelectedBorderColor = DEF_COLOR_CDA265;
    self.tagsView.tagLabelBackgroundColor = [UIColor whiteColor];
    self.tagsView.tagLabelSelectedBackgroundColor = [UIColor whiteColor];
    self.tagsView.tagFont = DEF_SET_FONT(14);
    self.tagsView.tagSelectedFont = DEF_SET_FONT(14);
    self.tagsView.tagTextColor = DEF_COLOR_A1A1A1;
    self.tagsView.tagSelectedTextColor = DEF_COLOR_CDA265;
    self.tagsView.tagHeight = 30;
    self.tagsView.allowsMultipleSelection = YES;
    self.topHeight = 0.01;
}


#pragma mark - tagsViewDelegate

- (void)tagsView:(JHCRM_TagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index
{
    self.submitBtn.enabled = YES;
}

- (void)tagsView:(JHCRM_TagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index
{
    if (tagsView.selecedTags.count) {
        self.submitBtn.enabled = YES;
    } else {
        self.submitBtn.enabled = self.textView.textView.text.length;
    }
}


#pragma mark - tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section ? 150 : self.topHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            UIView *footer = [[UIView alloc] init];
            footer.backgroundColor = [UIColor whiteColor];
            [footer addSubview:self.tagsView];
            [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.bottom.mas_equalTo(0);
            }];
            return footer;
        }
            break;
        case 1:
        {
            UIView *footer = [[UIView alloc] init];
            footer.backgroundColor = [UIColor whiteColor];

            [footer addSubview:self.textView];
            [self.textView.residueCharacterLabel removeFromSuperview];;
            self.textView.maxNumber = 500;
            self.textView.backgroundColor = [UIColor clearColor];
            self.textView.placeHolder = @"请留下您宝贵的意见";
            [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.and.top.mas_equalTo(16);
                make.right.and.bottom.mas_equalTo(-16);
            }];
            [self.textView.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.and.top.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];

            return footer;
        }
            break;
        case 2:
        {
            UIView *footer = [[UIView alloc] init];
            [footer addSubview:self.submitBtn];
            [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(62.5);
                make.right.mas_equalTo(-62.5);
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(35);
            }];
            return footer;
        }
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

- (JHCRM_TagsView *)tagsView
{
    if (!_tagsView) {
        _tagsView = [[JHCRM_TagsView alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH, 0)];
        _tagsView.delegate = self;
    }
    
    return _tagsView;
}

- (JH_CustomTextView *)textView
{
    if (!_textView) {
        _textView = [[JH_CustomTextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textView.textColor = DEF_COLOR_A1A1A1;
        _textView.textView.font = DEF_SET_FONT(15);
        _textView.placeholderLabel.textColor = DEF_COLOR_D7D7D7;
    }
    return _textView;
}

- (UIButton *)submitBtn
{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.titleLabel.font = DEF_SET_FONT(17);
//        _submitBtn.titleLabel.textColor = [UIColor whiteColor];
        _submitBtn.backgroundColor = DEF_COLOR_CDA265;
        _submitBtn.layer.cornerRadius = 17.5;
        _submitBtn.layer.masksToBounds = YES;
        [_submitBtn setTitle:@"递交"];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor colorWithRGBValue:255 g:255 b:255 alpha:0.5] forState:UIControlStateDisabled];
    }
    return _submitBtn;
}


@end
