//
//  JHBoss_HomeOrderAbnormalView.h
//  Boss
//
//  Created by jinghankeji on 2017/6/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBoss_MerchatBusinessDataModel.h"
@interface JHBoss_HomeOrderAbnormalView : UIView
@property (nonatomic, strong) JHBoss_MerchatBusinessDataModel *model;//订单异常使用
@property (nonatomic, strong) JHBoss_MerchatBusinessDataModel *clientFlowModel;//订单异常使用

@property (weak, nonatomic) IBOutlet UIView *topLine;
@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

-(void)leftPicture:(NSString *)leftPic rightPic:(NSString *)rightPic leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
@property (nonatomic, copy) void(^orderTurnoverBlock)();
@property (nonatomic, copy) void(^badCommentBlock)();
@end
