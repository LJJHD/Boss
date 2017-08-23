//
//  JH_Menu.m
//  Boss
//
//  Created by jinghankeji on 2017/3/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JH_Menu.h"

const CGFloat kArrowSize = 12.f;

@interface JHMenuView : UIView

@end

//蒙版
@interface KxMenuOverlay : UIView
@end

@implementation KxMenuOverlay

// - (void) dealloc { NSLog(@"dealloc %@", self); }

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    
    
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:[JHMenuView class]] && [v respondsToSelector:@selector(dismissMenu:)]) {
           
            [v performSelector:@selector(dismissMenu:) withObject:@(YES)];
        }
    }
}

@end



typedef NS_ENUM(NSUInteger,JHMenuViewArrowDirection){

    JHMenuViewArrowDirection_None,
    JHMenuViewArrowDirection_up,
    JHMenuViewArrowDirection_down,
    JHMenuViewArrowDirection_left,
    JHMenuViewArrowDirection_right,
};

@implementation JHMenuView{

    JHMenuViewArrowDirection    _arrowDirection;
    CGFloat                     _arrowPosition;
    UIView                      *_contentView;
    NSArray                     *_menuItems; //数量
    CGFloat                     _DEFWidth; //默认宽度 默认245
    CGFloat                     _itemMargin; //label 之间间距 默认 5
}

- (id)init
{
    self = [super initWithFrame:CGRectZero];
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        self.alpha = 0;
        
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowOffset = CGSizeMake(2, 2);
        self.layer.shadowRadius = 2;
        
        _DEFWidth = 245;
        _itemMargin = 5;
    }
    
    return self;
}

- (void) setupFrameInView:(UIView *)view
                 fromRect:(CGRect)fromRect{

    //内容大小
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat addWight = 15;//self 在contenSize上面添加的宽度
    
    //最外面的宽度和高度
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    //点击位置的rect的x
    const CGFloat rectX0 = fromRect.origin.x;
    
    //点击位置的rect的最大x
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    
    //点击位置的rect的中间x
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    
    //点击位置的rect的y
    const CGFloat rectY0 = fromRect.origin.y;
    
    //点击位置的rect的最大y
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    
    //点击位置的rect的中间y
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;
    
    //内容的宽度加上三角指示的宽度
    const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
    
    //内容的高度加上三角指示的高度
    const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
    
    //内容宽度的一半
    const CGFloat widthHalf = contentSize.width * 0.5f;
    
    //内容高度的一半
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    //距离屏幕边缘的距离
    const CGFloat kMargin = addWight + 5;
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = JHMenuViewArrowDirection_up;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        //_arrowPosition = MAX(16, MIN(_arrowPosition, contentSize.width - 16));
        _contentView.frame = (CGRect){0, kArrowSize, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + addWight,
            contentSize.height + kArrowSize
        };
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = JHMenuViewArrowDirection_down;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + addWight,
            contentSize.height + kArrowSize
        };
        
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        
        _arrowDirection = JHMenuViewArrowDirection_left;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){kArrowSize, 0, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + kArrowSize + addWight,
            contentSize.height
        };
        
    } else if (widthPlusArrow < rectX0) {
        
        _arrowDirection = JHMenuViewArrowDirection_right;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width  + kArrowSize + addWight,
            contentSize.height
        };
        
    } else {
        
        _arrowDirection = JHMenuViewArrowDirection_None;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}

-(void)createMenuInView:(UIView *)view fromRect:(CGRect)rect textItems:(NSMutableArray *)textItemsArr{

    _menuItems = textItemsArr;
    
    _contentView = [self createContentView];
   
    [self addSubview:_contentView];
    
    [self setupFrameInView:view fromRect:rect];

    //蒙版
    KxMenuOverlay *overlay = [[KxMenuOverlay alloc] initWithFrame:view.bounds];
    [overlay addSubview:self];
    [view addSubview:overlay];
    
    _contentView.hidden = YES;
    const CGRect toFrame = self.frame;
    self.frame = (CGRect){self.arrowPoint, 1, 1};
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame;
                         
                     } completion:^(BOOL completed) {
                         _contentView.hidden = NO;
                     }];
}


// 第七步 指示三角位置
- (CGPoint) arrowPoint
{
    CGPoint point;
    
    if (_arrowDirection == JHMenuViewArrowDirection_up) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMinY(self.frame) };
        
    } else if (_arrowDirection == JHMenuViewArrowDirection_down) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame) + _arrowPosition, CGRectGetMaxY(self.frame) };
        
    } else if (_arrowDirection == JHMenuViewArrowDirection_left) {
        
        point = (CGPoint){ CGRectGetMinX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else if (_arrowDirection == JHMenuViewArrowDirection_right) {
        
        point = (CGPoint){ CGRectGetMaxX(self.frame), CGRectGetMinY(self.frame) + _arrowPosition  };
        
    } else {
        
        point = self.center;
    }
    
    return point;
}


-(UIView *)createContentView{

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectZero];
    contentView.autoresizingMask = UIViewAutoresizingNone;
    contentView.backgroundColor = [UIColor clearColor];
    contentView.opaque = NO;
   
    CGFloat firstLabTop = 13.5;
    CGFloat labTop = 4;
    CGFloat lastLabBottom = 9.5;
    
    
    UILabel *lastLabel;
    for (int i = 0; i < _menuItems.count; i++) {
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        titleLab.text = _menuItems[i];
        titleLab.font = [UIFont systemFontOfSize:15];
        titleLab.textColor = DEF_COLOR_D7D7D7;
        titleLab.preferredMaxLayoutWidth = _DEFWidth - 10;
        titleLab.numberOfLines = 0;
        [contentView addSubview:titleLab];
        
    
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (lastLabel) {
                
                 make.top.equalTo(lastLabel.mas_bottom).offset(labTop);
                
            }else{
            
             make.top.equalTo(@13.5);
            }
           
           
            make.left.right.mas_equalTo(10);
            
            
        }];
        
        lastLabel = titleLab;
    }
    
    //计算contentView 的高度
    CGFloat contentH = 0.0f;
   
    
    for (NSString *title in _menuItems) {
        
        contentH += [title stringHeight:^(StringRectParamModel *param) {
            
            param.fontNumber = 15;
            param.lineSpace = 1;
            //左右间距5 所以减10
            param.maxWidth = _DEFWidth - 10;
            
        } ];
        
       
        
    }
    
    contentH += ((_menuItems.count - 1) * labTop) + lastLabBottom + firstLabTop;
    
     contentView.frame = CGRectMake(0, 0, _DEFWidth, contentH );
    
    return contentView;
}


- (void)dismissMenu:(BOOL) animated
{
    
    if (self.superview) {
        
        if (animated) {
            
            _contentView.hidden = YES;
            const CGRect toFrame = (CGRect){self.arrowPoint, 1, 1};
            
            [UIView animateWithDuration:0.2
                             animations:^(void) {
                                 
                                 self.alpha = 0;
                                 self.frame = toFrame;
                                 
                             } completion:^(BOOL finished) {
                                 
                                 if ([self.superview isKindOfClass:[KxMenuOverlay class]])
                                     [self.superview removeFromSuperview];
                                 [self removeFromSuperview];
                             }];
            
        } else {
            
            if ([self.superview isKindOfClass:[KxMenuOverlay class]])
                [self.superview removeFromSuperview];
            [self removeFromSuperview];
        }
    }
}



- (void) drawRect:(CGRect)rect
{
    [self drawBackground:self.bounds
               inContext:UIGraphicsGetCurrentContext()];
}

//绘制背景
- (void)drawBackground:(CGRect)frame
             inContext:(CGContextRef) context
{
    
    CGFloat X0 = frame.origin.x;
    CGFloat X1 = frame.origin.x + frame.size.width;
    CGFloat Y0 = frame.origin.y;
    CGFloat Y1 = frame.origin.y + frame.size.height;
    
    // render arrow 绘制箭头
    
    UIBezierPath *arrowPath = [UIBezierPath bezierPath];
    
    // fix the issue with gap of arrow's base if on the edge
    const CGFloat kEmbedFix = 3.f;
    
    if (_arrowDirection == JHMenuViewArrowDirection_up) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y0;
        const CGFloat arrowY1 = Y0 + kArrowSize + kEmbedFix;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY0}];
        
//        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        Y0 += kArrowSize;
        
    } else if (_arrowDirection == JHMenuViewArrowDirection_down) {
        
        const CGFloat arrowXM = _arrowPosition;
        const CGFloat arrowX0 = arrowXM - kArrowSize;
        const CGFloat arrowX1 = arrowXM + kArrowSize;
        const CGFloat arrowY0 = Y1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY1 = Y1;
        
        [arrowPath moveToPoint:    (CGPoint){arrowXM, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowXM, arrowY1}];
        
//        [[UIColor colorWithRed:R1 green:G1 blue:B1 alpha:1] set];
        
        Y1 -= kArrowSize;
        
    } else if (_arrowDirection == JHMenuViewArrowDirection_left) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X0;
        const CGFloat arrowX1 = X0 + kArrowSize + kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
//        [[UIColor colorWithRed:R0 green:G0 blue:B0 alpha:1] set];
        
        X0 += kArrowSize;
        
    } else if (_arrowDirection == JHMenuViewArrowDirection_right) {
        
        const CGFloat arrowYM = _arrowPosition;
        const CGFloat arrowX0 = X1;
        const CGFloat arrowX1 = X1 - kArrowSize - kEmbedFix;
        const CGFloat arrowY0 = arrowYM - kArrowSize;;
        const CGFloat arrowY1 = arrowYM + kArrowSize;
        
        [arrowPath moveToPoint:    (CGPoint){arrowX0, arrowYM}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY0}];
        [arrowPath addLineToPoint: (CGPoint){arrowX1, arrowY1}];
        [arrowPath addLineToPoint: (CGPoint){arrowX0, arrowYM}];
        
     
        
        X1 -= kArrowSize;
    }
    
    [DEF_COLOR_6E6E6E set];
    
    [arrowPath fill];
    
    // render 绘制 body
    
    
    
    const CGRect bodyFrame = {X0, Y0, X1 - X0, Y1 - Y0};
    
    //绘制带圆角矩形
    CGContextRef ctx = context;
    
    [DEF_COLOR_6E6E6E setFill];
    
    UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:bodyFrame
                                                          cornerRadius:3];
    CGContextAddPath(ctx, borderPath.CGPath);
    
    CGContextFillPath(ctx);
    

}


@end


static JH_Menu *JHMenu;
@implementation JH_Menu{

    JHMenuView *_JHMenuView;
    BOOL        _observing;
}

//单例 2
+ (instancetype) sharedMenu
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        JHMenu = [[JH_Menu alloc] init];
    });
    return JHMenu;
}

- (id) init
{
    NSAssert(!JHMenu, @"singleton object");
    
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)createMenuInView:(UIView *)view fromRect:(CGRect)rect textItems:(NSMutableArray *)textItemsArr{

    NSParameterAssert(view);
    NSParameterAssert(textItemsArr.count);
    
    if (_JHMenuView) {
        

        [_JHMenuView dismissMenu:NO];
        _JHMenuView = nil;
    }
    
    if (!_observing) {
        
        _observing = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(orientationWillChange:)
                                                     name:UIApplicationWillChangeStatusBarOrientationNotification
                                                   object:nil];
    }

    _JHMenuView = [[JHMenuView alloc] init];
    [_JHMenuView createMenuInView:view fromRect:rect textItems:textItemsArr];
}



- (void) orientationWillChange: (NSNotification *) n
{
    [self dismissMenu];
}

- (void) dismissMenu
{
    if (_JHMenuView) {
        
        [_JHMenuView dismissMenu:NO];
        _JHMenuView = nil;
    }
    
    if (_observing) {
        
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

//创建menu 1
+ (void)createMenuInView:(UIView *)view fromRect:(CGRect)rect textItems:(NSMutableArray *)textItemsArr{


    [[JH_Menu sharedMenu]createMenuInView:view fromRect:rect textItems:textItemsArr];
}
@end
