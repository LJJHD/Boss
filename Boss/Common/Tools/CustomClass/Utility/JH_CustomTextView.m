//
//  JH_CustomTextView.m
//  JinghanLife
//
//  Created by jinghankeji on 2017/3/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JH_CustomTextView.h"

@interface JH_CustomTextView   ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *textViewBottomView;

@property (nonatomic, assign) int nowNumber;
@end

@implementation JH_CustomTextView

-(void)awakeFromNib{

    [super awakeFromNib];
    
    self.placeholderLabel.text = self.placeHolder;
    
    self.residueCharacterLabel.text = [NSString stringWithFormat:@"0/%d",_maxNumber];
    self.textView.delegate = self;
    
    self.textViewBottomView.layer.borderWidth = 1;
    self.textViewBottomView.layer.borderColor = [UIColor colorWithRGBValue:230 g:230 b:230].CGColor;
    self.textViewBottomView.layer.cornerRadius = 4;
    self.textViewBottomView.layer.masksToBounds = YES;
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];
    if (self) {
        
        UIView *containerView = [[[UINib nibWithNibName:@"JH_CustomTextView" bundle:nil]instantiateWithOwner:self options:nil]objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        containerView.frame = newFrame;
        [self addSubview:containerView];
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.and.top.bottom.mas_equalTo(0);
           
        }];
    }
    
    return self;

}


-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        UIView *containerView = [[[NSBundle mainBundle] loadNibNamed:@"JH_CustomTextView" owner:self options:nil]objectAtIndex:0];
        CGRect newFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        containerView.frame = newFrame;
        [self addSubview:containerView];
        self.textView.delegate = self;
        
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.and.top.bottom.mas_equalTo(0);
            
        }];
    }

    return self;
}

- (void)setMaxNumber:(int)maxNumber
{
    _maxNumber = maxNumber;
    self.residueCharacterLabel.text = [NSString stringWithFormat:@"0/%d",_maxNumber];
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.placeholderLabel.text = self.placeHolder;
}


#pragma mark textview delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString *lang = textView.textInputMode.primaryLanguage;//键盘输入模式
    static NSInteger length = 0;
    if ([lang isEqualToString:@"zh-Hans"]){
        UITextRange *selectedRange = [textView markedTextRange];
        if (!selectedRange) {//没有有高亮
            length = textView.text.length;
        }else{
            
        }
    }else{
        length = textView.text.length;
    }
    
    if (length > _maxNumber) {
        textView.text = [textView.text substringToIndex:_maxNumber];
    }
    self.residueCharacterLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)length,(long)_maxNumber];
    [self.residueCharacterLabel sizeToFit];
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeholderLabel.hidden = self.textView.hasText;
}


@end
