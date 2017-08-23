//
//  NSString+Rect.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/4.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 设置字符串计算上的一些基础参数。
 */
@interface StringRectParamModel : NSObject

@property (assign, nonatomic) CGFloat fontNumber;
@property (strong, nonatomic) UIFont * font;
@property (assign, nonatomic) int numberOfLine;
@property (assign, nonatomic) CGSize boundingSize;
@property (assign, nonatomic) CGFloat maxWidth;
@property (assign, nonatomic) CGFloat maxheigh;
@property (assign, nonatomic) CGFloat lineSpace;
@property (assign, nonatomic) CGFloat paragraqphSpace;
@property (strong, nonatomic) NSDictionary *attributes;
@property (strong, nonatomic, readonly) NSMutableParagraphStyle * paragraphStyle;

@property (copy, nonatomic, readonly) StringRectParamModel*(^setFontNumber)(CGFloat font);
@property (copy, nonatomic, readonly) StringRectParamModel*(^setNumberOfLine)(int numberOfLine);
@property (copy, nonatomic, readonly) StringRectParamModel*(^setBoundingSize)(CGSize size);
@property (copy, nonatomic, readonly) StringRectParamModel*(^setMaxWidth)(CGFloat width);
@property (copy, nonatomic, readonly) StringRectParamModel*(^setMaxheight)(CGFloat height);
@property (copy, nonatomic, readonly) StringRectParamModel*(^setAttributes)(NSDictionary * attributes);
@property (copy, nonatomic, readonly) StringRectParamModel*(^setLineSpace)(CGFloat lineSpace);
@property (copy, nonatomic, readonly) StringRectParamModel*(^setFont)(UIFont * font);
@property (copy, nonatomic, readonly) StringRectParamModel*(^setParagraphSpace)(CGFloat paragraqphSpace);

@end

@interface NSString (Rect)

/**
 * 动态计算文案的 rect
 */
- (CGRect)stringRect:(void (^)(StringRectParamModel *param))paramBlock;

/**
 * 动态计算文案的 size
 */
- (CGSize)stringSize:(void (^)(StringRectParamModel *param))paramBlock;

/**
 * 动态计算文案的 height
 */
- (CGFloat)stringHeight:(void (^)(StringRectParamModel *param))paramBlock;

/**
 * 动态计算文案的 width
 */
- (CGFloat)stringWidth:(void (^)(StringRectParamModel *param))paramBlock;

@end
