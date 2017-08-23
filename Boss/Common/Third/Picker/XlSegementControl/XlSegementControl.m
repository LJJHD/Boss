 

#import "XlSegementControl.h"

@interface XlSegementControl ()
{
    NSMutableArray *_segments;       //保存 按钮的数组
    NSInteger       _highlightedSegmentView;
    UIBarStyle      _barStyle;
    CGFloat         _width;    // 按钮的宽
    CGFloat         _height;   // 按钮的高
    NSMutableArray *_separators;
    UIView         *_bottomLineView;
    
    UIView *       _topLine;
    UIView *       _bottomLine;
    UIImageView    *_bottomIconView;
}

@end

@implementation XlSegementControl
@synthesize selectedSegmentIndex = _selectedSegmentIndex;

- (void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    
    _separators = [[NSMutableArray alloc] init];
    _segments = [[NSMutableArray alloc] init];
    _selectedSegmentIndex = 0;
    _textColor = [UIColor blackColor];
    _selectTextColor = [UIColor redColor];
    _lineColor = [UIColor redColor];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
    _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleWidth;
    [self addSubview:_backgroundView];
    
    _bottomIconView =[[UIImageView alloc]init];
    [self addSubview:_bottomIconView];
    
    _bottomLineView = [[UIView alloc] init];
    [self addSubview:_bottomLineView];
    [self bringSubviewToFront:_bottomLineView];
}
- (void)setBottomLineViewFrame {

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (id)initWithSegmentViews:(NSArray *)items
{
    self = [super init];
    if (self) {
        // Initialization code
        [self initialize];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            XlSegmentView *segmentView = [self segmentView];
            segmentView.text = (NSString *)obj;
            [self addSubview:segmentView];
            
            [_segments addObject:segmentView];
        }];
    }
    return self;
}

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        // Initialization code
        [self initialize];
        [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            XlSegmentView *segmentView = [self segmentView];
            XlSegementItem *item = (XlSegementItem *) obj;
            segmentView.text = item.title;
            [segmentView setImage:item.image highlineImage:item.highlightedImage];
            [self addSubview:segmentView];
            [_segments addObject:segmentView];
        }];
    }
    return self;
}

-(void)reloadSeparators
{
    [_separators makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_separators removeAllObjects];
    if(_separatorImage){
        for(int i = 1;i< _segments.count;i++){
            UIImageView *separatorView = [[UIImageView alloc] initWithImage:_separatorImage];
            separatorView.clipsToBounds = YES;
            [self addSubview:separatorView];
            [_separators addObject:separatorView];
        }
    }
}

-(XlSegmentView *)segmentView
{
    XlSegmentView *XlSegmentItem = [[XlSegmentView alloc] init];
    XlSegmentItem.font = [UIFont boldSystemFontOfSize:14.f];
    
    [XlSegmentItem setLableTextColor:[UIColor blackColor] highlineColor:[UIColor redColor]];
    
    return XlSegmentItem;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self touchesContain:touches];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesContain:touches];
}

-(void)touchesContain:(NSSet *)touches
{
    _highlightedSegmentView = -1;
    
    [self XlSegmentItemOfTouches:touches isEnded:YES];
    
    if(_highlightedSegmentView == -1){
        XlSegmentView *XlSegmentItem = [_segments objectAtIndex:_selectedSegmentIndex];
        XlSegmentItem.selected     = YES;
    }else{
        _selectedSegmentIndex = _highlightedSegmentView;
        [self selectedSegmentChangeWithIndex];
    }
}

-(void)selectedSegmentChangeWithIndex
{
    if([_delegate respondsToSelector:@selector(segmentedControl:didSelectIndex:)])
    {
        [self.delegate segmentedControl:self didSelectIndex:_selectedSegmentIndex ];
    }
}

-(void)XlSegmentItemOfTouches:(NSSet *)touches isEnded:(BOOL)ended
{
    [_segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint pt = [[touches anyObject] locationInView:obj];
        XlSegmentView *XlSegmentItem = obj;
        CGRect rect = UIEdgeInsetsInsetRect(XlSegmentItem.bounds, UIEdgeInsetsMake(-10, 0, -10, 0));
        BOOL flag = CGRectContainsPoint(rect, pt);
        if(flag){
            XlSegmentItem.selected = YES;
            _highlightedSegmentView = XlSegmentItem.index;
            [self configBottomLineViewWithOffsetX:XlSegmentItem.frame.origin.x];
        }else{
            XlSegmentItem.selected = NO;
        }
    }];
}

-(void)configBottomLineViewWithOffsetX:(CGFloat)OffsetX
{
    // 初始化避免动画
    CGFloat oriX = (_width - 20)/2;
    if (_bottomLineView.width <= 0) {
        _bottomLineView.frame = CGRectMake(oriX, _height-5, 20, 5);
        _bottomIconView.center = CGPointMake(oriX + _width/2, _height+(CGRectGetHeight(_bottomIconView.bounds)/2 - 0.5));
        return;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        _bottomLineView.frame = CGRectMake(OffsetX + oriX, _height-5, 20, 5);
        _bottomIconView.center = CGPointMake(OffsetX + oriX + _width/2, _height+(CGRectGetHeight(_bottomIconView.bounds)/2 - 0.5));
    } completion:nil];
 
}

-(void)setIsShowBottomLine:(BOOL)isShowBottomLine
{
    _isShowBottomLine = isShowBottomLine;
    _bottomLineView.hidden = !_isShowBottomLine;
}

-(void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex
{
    _selectedSegmentIndex = selectedSegmentIndex;
    [self layoutSubviews];
}
- (void)segmentIndex:(NSInteger)index dotShow:(BOOL)show{
    if (_segments.count){
        XlSegmentView *XlSegmentItem = _segments[index];
        XlSegmentItem.showDot = show;
    }
}

-(void)setSeparatorImage:(UIImage *)separatorImage
{
    _separatorImage = separatorImage;
    [self reloadSeparators];
}

-(void)setLineColor:(UIColor *)lineColor
{
    _lineColor = lineColor;
    _bottomLineView.backgroundColor = _lineColor;
}

-(void)setBottomIcon:(UIImage *)bottomIcon{
    _bottomIconView.image = bottomIcon;
}

- (void)removeSegmentAtIndex:(NSUInteger)index
{
    if(index <= _segments.count){
        [_segments removeObjectAtIndex:index];
    }
}

- (void)removeAllSegments
{
    [_segments removeAllObjects];
}

-(NSMutableArray *)getAllSegments
{
    return _segments;
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)index
{
    XlSegmentView *XlSegmentItemView = [_segments objectAtIndex:index];
    XlSegmentItemView.text = title;
}


- (void)setImage:(UIImage *)image setHighlineImage:(UIImage *)highlineImage forSegmentAtIndex:(NSUInteger)index;
{
    XlSegmentView *XlSegmentItemView = [_segments objectAtIndex:index];
    [XlSegmentItemView setImage:image highlineImage:highlineImage];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _width = self.bounds.size.width / _segments.count;
    _height = self.bounds.size.height ;
    
    [_segments enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        XlSegmentView *XlSegmentItem = obj;
        XlSegmentItem.index = idx;
        XlSegmentItem.font = _font;
        XlSegmentItem.width = 60;
        [XlSegmentItem setLableTextColor:_textColor highlineColor:_selectTextColor];
        XlSegmentItem.frame = CGRectMake(idx * _width, 0, _width, _height);
        XlSegmentItem.selected = NO;
        
        if(idx == _selectedSegmentIndex){
            XlSegmentItem.selected = YES;
           [self configBottomLineViewWithOffsetX:XlSegmentItem.frame.origin.x];
            
            CGFloat xlSegementWidth = CGRectGetWidth(XlSegmentItem.bounds)/2;
            [_bottomIconView sizeToFit];
            _bottomIconView.frame = CGRectMake(0, 0, CGRectGetWidth(_bottomIconView.bounds), CGRectGetHeight(_bottomIconView.bounds));
            _bottomIconView.center = CGPointMake(xlSegementWidth + _selectedSegmentIndex * CGRectGetWidth(XlSegmentItem.bounds), _height+(CGRectGetHeight(_bottomIconView.bounds)/2 - 0.5));
        }
    }];
    
    [_separators enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *separatorView = obj;
        separatorView.frame = CGRectMake(0, 0, _separatorImage.size.width, self.frame.size.height - 20);
        separatorView.center = CGPointMake(_width*(idx + 1), _height/2);
    }];
}

@end
