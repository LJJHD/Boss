//
//  JHBoss_tableHeaderSearchView.m
//  Boss
//
//  Created by jinghankeji on 2017/5/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_tableHeaderSearchView.h"

@interface JHBoss_tableHeaderSearchView ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation JHBoss_tableHeaderSearchView



-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHBoss_tableHeaderSearchView" owner:self options:nil]objectAtIndex:0];
    }
    
    self.backgroundColor = DEF_COLOR_ECECEC;
    _backgroundView.layer.cornerRadius = 16.2;
    _backgroundView.layer.masksToBounds = YES;
   
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.backgroundView addGestureRecognizer:tap];
    return self;
}
-(void)tap{

    if (self.tapBlock) {
        self.tapBlock();
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
