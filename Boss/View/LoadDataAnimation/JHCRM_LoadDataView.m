//
//  JHCRM_LoadDataView.m
//  Boss
//
//  Created by jinghankeji on 2017/4/6.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_LoadDataView.h"

@interface JHCRM_LoadDataView ()
@property (weak, nonatomic) IBOutlet UIImageView *animotionImageView;
@property (nonatomic, strong) NSMutableArray *imagesArr;//存放image
@end

@implementation JHCRM_LoadDataView

-(void)awakeFromNib{

    [super awakeFromNib];
    _imagesArr = [NSMutableArray array];
    for (int i = 1; i <= 9; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"boss_loading_%d",i]];
        [_imagesArr addObject:image];
    }
    _animotionImageView.animationDuration = 0.8f;
    _animotionImageView.animationImages = _imagesArr;
    
}


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self = [[[NSBundle mainBundle]loadNibNamed:@"JHCRM_LoadDataView" owner:self options:nil]objectAtIndex:0];
    }
   
    return self;
}

-(void)startAnimation{

    [_animotionImageView startAnimating];
}

-(void)stopAnimation{

    [_animotionImageView stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
