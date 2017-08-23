//
//  JHCRM_UploadSingleImgManager.m
//  Boss
//
//  Created by 晶汉mac on 2017/3/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//
#define kAllowVisitorCameroTip @"请到系统“设置”-“隐私”-“相机”中，允许访问相机"
#define kAllowVisitorPhotosTip @"请到系统“设置”-“隐私”-“照片”中，允许访问照片"

#import "JHCRM_UploadSingleImgManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@interface JHCRM_UploadSingleImgManager ()<TOCropViewControllerDelegate>

@end

@implementation JHCRM_UploadSingleImgManager
+(JHCRM_UploadSingleImgManager*)shareManager
{
    static JHCRM_UploadSingleImgManager *__manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[JHCRM_UploadSingleImgManager alloc] init];
    });
    return __manager;
}

-(void)showImagePickWithCurrentVc:(UIViewController*)currentVc
{
    self.delegate = currentVc;
    
    self.customAspectRatio = (CGSize){4.0f, 5.0f};
    self.aspectRatioLockEnabled = YES;
    
    UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册",nil];
    actionsheet.delegate  = self;
 
    [actionsheet showInView:currentVc.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //相机
        //判断是否能使用相机或者相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self photosViewShowWithType:UIImagePickerControllerSourceTypeCamera];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if (buttonIndex == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            [self photosViewShowWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不支持相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
}


- (void)pickImageWithType:(UIImagePickerControllerSourceType)type
{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.view.backgroundColor = DEF_COLOR_F5F5F5;
    picker.delegate = self;
    picker.sourceType = type;
    picker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    picker.allowsEditing = NO;
    
    [(UIViewController*)self.delegate presentViewController:picker animated:YES completion:nil];
}

- (void)photosViewShowWithType:(UIImagePickerControllerSourceType)type
{
    
    
    if (type == UIImagePickerControllerSourceTypeCamera)
    {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
        {
            //无权限
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:kAllowVisitorCameroTip delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil,  nil];
            
            [alert show];
            
        }else
        {
            [self pickImageWithType:type];
        }
    }else if (type == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied)
        {
            //无权限
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:kAllowVisitorPhotosTip delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil,  nil];
            [alert show];
            
        }else
        {
            [self pickImageWithType:type];
        }
    }
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{

    
    TOCropViewController *cropCotroller = [[TOCropViewController alloc]initWithCroppingStyle:self.cropViewCroppingStyle image:info[UIImagePickerControllerOriginalImage]];
    cropCotroller.delegate = self;
    cropCotroller.customAspectRatio = self.customAspectRatio;
    cropCotroller.aspectRatioLockEnabled = self.aspectRatioLockEnabled;
    cropCotroller.resetAspectRatioEnabled = NO;
    //If profile picture, push onto the same navigation stack
    if (self.cropViewCroppingStyle == TOCropViewCroppingStyleCircular) {
        
        [picker pushViewController:cropCotroller animated:YES];
    }
    else { //otherwise dismiss, and then present from the main controller
        
        [picker dismissViewControllerAnimated:YES completion:^{
            
            [self.delegate presentViewController:cropCotroller animated:YES completion:nil];
        }];
    }
     
}

#pragma mark - Cropper Delegate -
- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    
    if (self.returnImage) {
        self.returnImage(image);
    }

     [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToCircularImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    
    if (self.returnImage) {
        self.returnImage(image);
    }
     [cropViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}



@end
