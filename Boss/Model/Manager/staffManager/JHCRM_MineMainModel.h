//
//  JHCRM_MineMainModel.h
//  SuppliersCRM
//
//  Created by jinghan on 17/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBaseModel.h"

/**
 *  Cell 类型
 */
typedef NS_ENUM(NSUInteger, PersonalCenterCellType) {
    /*   Title    >   */
    PersonalCenterCellType_Title_Arrow,
    /*   Title    Image   */
    PersonalCenterCellType_Title_Image,
    /*   Title    DescribeLb  */
    PersonalCenterCellType_Title_DescribeLb,
    /*   Title    DescribeLb   >   */
    PersonalCenterCellType_Title_DescribeLb_Arrow,
    /*   Icon     Title    Image   >   */
    PersonalCenterCellType_Icon_Title_Image_Arrow,
    /*   Icon     Title    DescribeLb   >   */
    PersonalCenterCellType_Icon_Title_DescribeLb_Arrow,
    /*   Title    DescribeLb   Space */
    PersonalCenterCellType_Title_DescribeLb_Space,
};


@interface JHCRM_MineMainModel : JHBaseModel

@property (nonatomic, copy)   NSString *iconName;

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, copy) NSString *titleDel;
@property (nonatomic, strong) UIFont *titleDelFont;
@property (nonatomic, strong) UIColor *titleDelColor;

@property (nonatomic, copy) NSString *headImageUrl;

@property (nonatomic, assign) PersonalCenterCellType personalCenterCellType;


@end
