//
//  JHCRM_HomeTableViewCell.h
//  SuppliersCRM
//
//  Created by jinghankeji on 2017/3/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JHTagsViewDelegate;

@interface FMTagModel : NSObject

@property (nonatomic) BOOL selected;

@end


@interface JHCRM_TagsView : UIView

@property (nonatomic) UIEdgeInsets contentInsets; //default is (10,10,10,10)

@property (nonatomic) NSMutableArray<NSString *> *tagsArray;   //数据源
@property (nonatomic , assign) NSUInteger maxTagsNumber;//最大tags个数，最大20个默认
@property (nonatomic , assign) NSUInteger maxSelectNumber;//最大多选个数 允许多选的情况下，默认10000，相当于不限制选中个数


@property (strong, nonatomic) NSMutableArray<FMTagModel *> *tagModels;

@property (weak, nonatomic) id<JHTagsViewDelegate> delegate;

@property (nonatomic) CGFloat lineSpacing;       //行间距, 默认为10
@property (nonatomic) CGFloat interitemSpacing; //元素之间的间距，默认为5

#pragma mark - ......::::::: 标签定制属性 :::::::......
@property (nonatomic, assign) BOOL isShowAddImageView; //是否显示加号按钮
@property (nonatomic, assign) BOOL isEdit;//是否处于编辑状态 用于删除item


@property (nonatomic) UIEdgeInsets tagInsets; // default is (5,5,5,5)
@property (nonatomic) CGFloat tagBorderWidth;           //标签边框宽度, default is 0
@property (nonatomic) CGFloat tagcornerRadius;  // default is 0  这个是设置item 的圆角

@property (nonatomic) CGFloat tagLabelBorderWidth; //文字边框宽度 
@property (nonatomic) CGFloat tagLabelCornerRadius; // default is 0 设置label 的圆角
@property (nonatomic, assign) CGFloat tagLabelAddW; //标签label 在文字宽度上增加的宽度 默认 30
@property (nonatomic, assign) CGFloat tagLabelAddH; //标签label 在文字高度的基础上增加的高度 默认 11


@property (strong, nonatomic) UIImageView *backGroundImageView;//tagview的背景图
@property (strong, nonatomic) UIColor *tagBorderColor;//item的的边框颜色
@property (strong, nonatomic) UIColor *tagSelectedBorderColor;//item选中时的边框颜色
@property (strong, nonatomic) UIColor *tagBackgroundColor;//item的背景颜色
@property (strong, nonatomic) UIColor *tagSelectedBackgroundColor;//item选中时的背景颜色
@property (strong, nonatomic) UIFont *tagFont;//字体大小
@property (strong, nonatomic) UIFont *tagSelectedFont;//选中时的字体大小
@property (strong, nonatomic) UIColor *tagTextColor;//文字颜色
@property (strong, nonatomic) UIColor *tagSelectedTextColor;//选中时的字体颜色
@property (strong, nonatomic) UIColor *tagLabelBorderColor;//文字边框颜色
@property (strong, nonatomic) UIColor *tagLabelSelectedBorderColor;//选中label时文字边框颜色 默认和选中时label的背景色一致
@property (strong, nonatomic) UIColor *tagLabelBackgroundColor;//文字背景颜色 默认白色
@property (strong, nonatomic) UIColor *tagLabelSelectedBackgroundColor;//选中item时文字背景颜色文字背景颜色 默认蓝色


@property (nonatomic) CGFloat tagHeight;        //标签高度，默认28
@property (nonatomic) CGFloat mininumTagWidth;  //tag 最小宽度值, 默认是0，即不作最小宽度限制
@property (nonatomic) CGFloat maximumTagWidth;  //tag 最大宽度值, 默认是CGFLOAT_MAX， 即不作最大宽度限制

#pragma mark - ......::::::: 选中 :::::::......

@property (nonatomic) BOOL allowsSelection;             //是否允许选中, default is YES
@property (nonatomic) BOOL allowsMultipleSelection;     //是否允许多选, default is NO
@property (nonatomic) BOOL allowEmptySelection;         //是否允许空选, default is YES

@property (nonatomic, readonly) NSUInteger selectedIndex;   //选中索引
@property (nonatomic, readonly) NSArray<NSString *> *selecedTags;     //多选状态下，选中的Tags
@property (nonatomic, readonly) NSArray<NSNumber *> *selectedIndexes; //多选状态下，选中的索引
@property (nonatomic, assign) BOOL forbidAction; // 禁止动作

- (void)selectTagAtIndex:(NSMutableArray *)indexArr animate:(BOOL)animate ;
- (void)deSelectTagAtIndex:(NSUInteger)index animate:(BOOL)animate;

#pragma mark - ......::::::: Edit :::::::......

//if not found, return NSNotFount
- (NSUInteger)indexOfTag:(NSString *)tagName;
//isFront 是否添加到最前面，否则添加到最后面
- (void)addTag:(NSString *)tagName isFront:(BOOL)isFront;
- (void)insertTag:(NSString *)tagName AtIndex:(NSUInteger)index;

- (void)removeTagWithName:(NSString *)tagName;
- (void)removeTagAtIndex:(NSUInteger)index;
- (void)removeAllTags;

// 用于 删除item，并显示删除图片 remove 表示是否处于编辑状态，处于编辑状态则可删除
- (void)removeItem:(BOOL)remove;

//collectionview 的高度
- (CGSize)intrinsicContentSize;



@end


@protocol JHTagsViewDelegate <NSObject>

@optional
//点击item回调
- (BOOL)tagsView:(JHCRM_TagsView *)tagsView shouldSelectTagAtIndex:(NSUInteger)index;
- (void)tagsView:(JHCRM_TagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index;

- (BOOL)tagsView:(JHCRM_TagsView *)tagsView shouldDeselectItemAtIndex:(NSUInteger)index;
- (void)tagsView:(JHCRM_TagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index;

//处于编辑状态点击item
-(void)tagsView:(JHCRM_TagsView *)tagsView  isEnditDidSelectTagAtIndex:(NSUInteger)index commodityName:(NSString *)commodityName;

//点击加号按钮的回调
- (void)tagsView:(JHCRM_TagsView *)tagsView didSelectAddItemAtIndex:(NSUInteger)index;

//添加标签达到最大值
- (void)tagsView:(JHCRM_TagsView *)tagsView maxTagsNum:(NSUInteger)number;

//允许多选的情况下，选中tag 达到最大数
- (void)tagsView:(JHCRM_TagsView *)tagsView maxSelectTagsNum:(NSUInteger)number;

@end
