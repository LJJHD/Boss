//
//  JHCRM_UploadSingleImgManager.h
//  Boss
//
//  Created by 晶汉mac on 2017/3/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TOCropViewController.h>

@interface JHCRM_UploadSingleImgManager : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic, weak)id  delegate;
@property (nonatomic, assign) CGSize customAspectRatio; //自定义裁剪比例，默认 4：5
@property (nonatomic, assign) BOOL aspectRatioLockEnabled;//默认为NO， 不允许编辑裁剪比例
@property (nonatomic, assign) TOCropViewCroppingStyle cropViewCroppingStyle;
- (void)showImagePickWithCurrentVc:(UIViewController*)currentVc;
+(JHCRM_UploadSingleImgManager*)shareManager;

@property (nonatomic, copy) void (^returnImage)(UIImage *picture);
@end
