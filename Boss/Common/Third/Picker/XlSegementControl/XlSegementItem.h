 

#import <UIKit/UIKit.h>

@interface XlSegementItem : NSObject
@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)UIImage * image;
@property(nonatomic,strong)UIImage * highlightedImage;

+(instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;
@end
