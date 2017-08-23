//
//  NSString+Rect.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "NSString+Rect.h"

@interface StringRectParamModel()
@property (strong, nonatomic, readwrite) NSMutableParagraphStyle * paragraphStyle;
@end

@implementation StringRectParamModel

- (instancetype)init{
    if (self = [super init]) {
        self.fontNumber = 14;
        self.font = [UIFont systemFontOfSize:self.fontNumber];
        self.numberOfLine = 1;
        self.boundingSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    }
    return self;
}

- (StringRectParamModel *(^)(CGFloat))setFontNumber{
    return ^(CGFloat font){
        self.fontNumber = font;
        return self;
    };
}

- (StringRectParamModel *(^)(int))setNumberOfLine{
    return ^(int numberOfLine){
        self.numberOfLine = numberOfLine;
        return self;
    };
}

- (StringRectParamModel *(^)(CGSize))setBoundingSize{
    return ^(CGSize boundingSize){
        self.boundingSize = boundingSize;
        return self;
    };
}

- (StringRectParamModel *(^)(CGFloat))setMaxWidth{
    return ^(CGFloat maxWidth){
        self.maxWidth = maxWidth;
        [self didChangeValueForKey:@"maxWidth"];
        return self;
    };
}

- (StringRectParamModel *(^)(CGFloat))setMaxheight{
    return ^(CGFloat maxHeight){
        self.maxheigh = maxHeight;
        [self didChangeValueForKey:@"maxHeight"];
        return self;
    };
}

- (StringRectParamModel *(^)(NSDictionary *))setAttributes{
    return ^(NSDictionary *attributes){
        self.attributes = attributes;
        return self;
    };
}

- (StringRectParamModel *(^)(CGFloat))setLineSpace{
    return ^(CGFloat lineSpace){
        self.lineSpace = lineSpace;
        return self;
    };
}

- (StringRectParamModel *(^)(UIFont *))setFont{
    return ^(UIFont *font){
        self.font = font;
        return self;
    };
}

- (StringRectParamModel *(^)(CGFloat))setParagraphSpace{
    return ^(CGFloat paragraqphSpace){
        self.paragraqphSpace = paragraqphSpace;
        return self;
    };
}

- (void)setMaxheigh:(CGFloat)maxheigh{
    _maxheigh = maxheigh;
    [self didChangeValueForKey:@"maxHeight"];
}

- (void)setMaxWidth:(CGFloat)maxWidth{
    _maxWidth = maxWidth;
    [self didChangeValueForKey:@"maxWidth"];
}

- (void)setFontNumber:(CGFloat)fontNumber{
    _fontNumber = fontNumber;
    [self didChangeValueForKey:@"fontNumber"];
}

- (NSMutableParagraphStyle *)paragraphStyle{
    if (_paragraphStyle == nil) {
        _paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    }
    return _paragraphStyle;
}

- (void)didChangeValueForKey:(NSString *)key{
    if ([key isEqualToString:@"maxHeight"]) {
        self.boundingSize = CGSizeMake(self.boundingSize.width,self.maxheigh);
    }else if ([key isEqualToString:@"maxWidth"]){
        self.boundingSize = CGSizeMake(self.maxWidth, self.boundingSize.height);
    }else if ([key isEqualToString:@"fontNumber"]){
        self.font = [UIFont systemFontOfSize:self.fontNumber];
    }
}

@end

@implementation NSString (Rect)
- (CGRect)stringRect:(void (^)(StringRectParamModel *param))paramBlock{
    if (paramBlock != nil) {
        __block StringRectParamModel * param = [[StringRectParamModel alloc]init];
        paramBlock(param);
#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
        NSMutableDictionary * attributes = nil;
        if (isObjNotEmpty(param.attributes)) {
            attributes = [NSMutableDictionary dictionaryWithDictionary:param.attributes];
        }else{
            attributes = [NSMutableDictionary dictionary];
        }
        [attributes setObject:param.font forKey:NSFontAttributeName];
        if (param.lineSpace != param.paragraphStyle.lineSpacing) {
            param.paragraphStyle.lineSpacing = param.lineSpace;
        }
        if (param.paragraqphSpace != param.paragraphStyle.paragraphSpacing) {
            param.paragraphStyle.paragraphSpacing = param.paragraqphSpace;
        }
        [attributes setObject:param.paragraphStyle forKey:NSParagraphStyleAttributeName];
        return [self boundingRectWithSize:param.boundingSize
                                  options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:attributes
                                  context:nil];
#else
        return [self sizeWithFont:param.font
                constrainedToSize:param.boundingSize
                    lineBreakMode:NSLineBreakByCharWrapping];
        
#endif
    }
    return CGRectZero;
}

- (CGSize)stringSize:(void (^)(StringRectParamModel *))paramBlock{
    return [self stringRect:paramBlock].size;
}

- (CGFloat)stringHeight:(void (^)(StringRectParamModel *))paramBlock{
    return [self stringSize:paramBlock].height;
}

- (CGFloat)stringWidth:(void (^)(StringRectParamModel *))paramBlock{
    return [self stringSize:paramBlock].width;
}

@end
