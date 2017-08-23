 

#import "XlSegementItem.h"

@implementation XlSegementItem

+(instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage
{
    XlSegementItem * model = [[XlSegementItem alloc] init];
    model.title = title;
    model.image = image;
    model.highlightedImage = highlightedImage;
    
    return model;
}


@end
