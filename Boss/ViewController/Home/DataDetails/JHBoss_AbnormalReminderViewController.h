//
//  JHBoss_AbnormalReminderViewController.h
//  Boss
//
//  Created by sftoday on 2017/5/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_ExceptionReminderModel.h"

@interface JHBoss_AbnormalReminderViewController : UIViewController

@property (nonatomic, strong) JHBoss_ExceptionReminderModel *model;
@property (nonatomic, strong) NSNumber *dataId;

@end
