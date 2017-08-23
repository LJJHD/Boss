//
//  JHBoss_SelectedTableViewCell.h
//  Boss
//
//  Created by sftoday on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)(BOOL selected);

@interface JHBoss_SelectedTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL shouldShowCheckBox;
@property (nonatomic, copy) SelectedBlock selectedBlock;
@property (nonatomic, assign, readonly) BOOL state;

- (void)setState:(BOOL)state block:(BOOL)blcok;

@end
