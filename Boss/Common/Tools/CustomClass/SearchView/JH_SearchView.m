//
//  JH_SearchView.m
//  JinghanLife
//
//  Created by jinghan on 17/3/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JH_SearchView.h"

@interface JH_SearchView() <UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *iconImageView;

@property (nonatomic,assign) JH_SearchViewType searchViewType;

@end

@implementation JH_SearchView




- (instancetype)initWithSearchViewType:(JH_SearchViewType)searchViewType{
    if (self = [super init]) {
        self.searchViewType = searchViewType;
         self.frame = CGRectMake(0, 0, DEF_WIDTH, self.searchViewType==JH_SearchViewType_Navigation?64:44);
        self.backgroundColor = [UIColor colorWithRGBValue:220 g:220 b:220];
        [self addSubview:self.searchView];
        
        
    }
    return self;
}



- (void)setIconImageViewImageWithImageName:(NSString *)imageName{
    self.iconImageView.image = DEF_IMAGENAME(imageName);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([self.delegate respondsToSelector:@selector(jh_SearchViewShouldReturn:)]) {
        [self.delegate jh_SearchViewShouldReturn:textField];
    }

    return YES;
}

#pragma mark - Setter/Getter
- (UIView *)searchView{
    if(!_searchView){
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchViewType==JH_SearchViewType_Navigation?0:0, DEF_WIDTH,64)];
        _searchView.backgroundColor = DEF_COLOR_RGB(244, 244, 244);
        
        @weakify(self);
        [_searchView addSubview:self.cancelBtn];
        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(44);
            make.leading.mas_equalTo(8);
            make.centerY.equalTo(_searchView).offset(8);
        }];
        
        UIView *infoView = [[UIView alloc] init];
        infoView.layer.masksToBounds = YES;
        infoView.layer.cornerRadius = 15;
        infoView.layer.borderWidth = 0.5;
        infoView.layer.borderColor = [UIColor colorWithRGBValue:210 g:210 b:210].CGColor;
        infoView.backgroundColor = [UIColor whiteColor];
        
        [_searchView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
//            make.top.equalTo(_searchView.mas_top).offset(6);
            make.leading.equalTo(self.cancelBtn.mas_trailing).offset(8);
            make.trailing.mas_equalTo(-30);
            make.height.mas_equalTo(30);
            make.centerY.equalTo(self.cancelBtn.mas_centerY);
//            make.bottom.equalTo(_searchView.mas_bottom).offset(-6);
        }];
        
        [infoView addSubview:self.textField];
        
        [infoView addSubview:self.iconImageView];
        
        [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
             @strongify(self);
            make.top.offset(0);
            make.leading.equalTo(@10);
            make.trailing.equalTo(self.iconImageView.mas_leading);
            make.bottom.offset(0);
        }];
        
        
       
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.trailing.offset(-10);
            make.width.offset(40);
            make.bottom.offset(0);
        }];

        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor colorWithRGBValue:220 g:220 b:220 alpha:1];
        [_searchView addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0.5);
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.bottom.offset(0);
        }];
    }
    
    return _searchView;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.placeholder = @"搜索";
        _textField.textColor = [UIColor colorWithRGBValue_Hex:0x666666];
        _textField.font = DEF_SET_FONT(14);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeySearch;
        @weakify(self);
        [_textField.rac_textSignal subscribeNext:^(NSString *text) {
            @strongify(self);
            
            
            if ([self.delegate respondsToSelector:@selector(jh_SearchViewTextFieldTextChange:text:)]) {
                
                [self.delegate jh_SearchViewTextFieldTextChange:self.textField text:text];
            }
        }];
        
      
        
    }
    return _textField;
}


- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setimage:@"2.1.3.6_icon_back"];
        
        _cancelBtn.titleLabel.font = DEF_SET_FONT(15);
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        @weakify(self);
        _cancelBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(jh_SearchViewCancelButtonClick:)]) {
                [self.delegate jh_SearchViewCancelButtonClick:self];
            }
            
            return [RACSignal empty];
        }];
    }
    return _cancelBtn;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _iconImageView.image = DEF_IMAGENAME(@"2.1.3.6");
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}
@end
