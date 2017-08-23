//
//  JHCRM_CerFootSectionView.m
//  Boss
//
//  Created by 晶汉mac on 2017/3/13.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_CerFootSectionView.h"
#import "UIButton+Setting.h"

@interface JHCRM_CerFootSectionView ()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@end

@implementation JHCRM_CerFootSectionView
-(void)awakeFromNib
{
    [super awakeFromNib];
 
    
    
}

-(instancetype)initWithFrame:(CGRect)frame permitArr:(NSArray *)permitArr{

    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"JHCRM_CerFootSectionView" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}


- (IBAction)choseImageClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(choseImageWith:)]) {
        
        
        [self.delegate choseImageWith:^(UIImage *image) {
            
            if (image == nil || [image isKindOfClass:[NSNull class]]) {
                
                return ;
            }
            
            if (sender == _firstBtn) {
                
                [_firstBtn setImage:image forState:UIControlStateNormal];
                _firstBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }else if (sender == _secondBtn){
                
                 [_secondBtn setImage:image forState:UIControlStateNormal];
                 _secondBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
            }

            
        }];
    }
}


- (void)tapCklcik:(UITapGestureRecognizer*)tap
{
    
}

@end
