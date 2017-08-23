//
//  JH_SearchView.h
//  JinghanLife
//
//  Created by jinghan on 17/3/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JH_SearchViewType) {
    JH_SearchViewType_Navigation,   /**    放在Navigation上  高度为64    **/
    JH_SearchViewType_View,         /**    放在View上  高度为44    **/
};

@class JH_SearchView;

@protocol JH_SearchViewDelegate <NSObject>

@optional//可以选择实现的方法

/**
 *  取消按钮点击回调
 */
- (void)jh_SearchViewCancelButtonClick:(JH_SearchView *)searchView;


/**
 *  键盘return按钮点击回调
 */
- (void)jh_SearchViewShouldReturn:(UITextField *)textField;

/**
 *  TextField内容改变
 */
- (void)jh_SearchViewTextFieldTextChange:(UITextField *)textField text:(NSString *)text;



@end

@interface JH_SearchView : UIView

@property (nonatomic,strong) UIView *searchView;

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIButton *cancelBtn;

@property (nonatomic,strong) UIView *lineView;


@property (nonatomic,weak) id <JH_SearchViewDelegate>delegate;

/**
 * 初始化SearchView  默认为JH_SearchViewType_Navigation
 */
- (instancetype)initWithSearchViewType:(JH_SearchViewType)searchViewType;

/**
 * 修改左边图片
 */
- (void)setIconImageViewImageWithImageName:(NSString *)imageName;


@end
