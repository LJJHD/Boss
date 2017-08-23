//
//  JHCRM_HomeTableViewCell.m
//  SuppliersCRM
//
//  Created by jinghankeji on 2017/3/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHCRM_TagsView.h"

static NSString * const kTagCellID = @"TagCellID";

@interface FMTagModel()

@property (copy, nonnull) NSString *name;

//用于计算文字大小
@property (strong, nonatomic) UIFont *font;

@property (nonatomic, readonly) CGSize contentSize; //文字的大小

@property (nonatomic, assign) CGFloat AddLabelW; //标签label 在文字宽度上增加的宽度
@property (nonatomic, assign) CGFloat AddLabelH; //标签label 在文字高度的基础上增加的高度


- (instancetype)initWithName:(NSString *)name font:(UIFont *)font labelAddw:(CGFloat)labelAddw labelAddH:(CGFloat)labelAddH;

@end

@implementation FMTagModel

-(instancetype)initWithName:(NSString *)name font:(UIFont *)font labelAddw:(CGFloat)labelAddw labelAddH:(CGFloat)labelAddH{
   
    if (self = [super init]) {
        _name = name;
        self.font = font;
        _AddLabelH = labelAddH;
        _AddLabelW = labelAddw;
        [self setFont:font addw:labelAddw addH:labelAddH];
    }
    return self;

}


- (void)setFont:(UIFont *)font addw:(CGFloat )addw addH:(CGFloat )addH{

    _font = font;
    
    NSDictionary *dict = @{NSFontAttributeName: self.font};
    CGSize textSize = [_name boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 1000)
                                          options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    _contentSize = CGSizeMake(ceil(textSize.width) + addw  , ceil(textSize.height) + addH);

}



@end
//collectionViewCell 样式一
@interface FMTagCell : UICollectionViewCell

@property (strong, nonatomic) UILabel *tagLabel;
@property (nonatomic, strong) UIImageView *reMoveImageView; //删除图片
@property (nonatomic) FMTagModel *tagModel;
@property (nonatomic) UIEdgeInsets contentInsets;

@end

@implementation FMTagCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        _tagLabel.userInteractionEnabled = NO;
        
        [self.contentView addSubview:_tagLabel];
        
        _reMoveImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_home_merchandise_editor_variety_delete"]];
        _reMoveImageView.hidden = YES;
        _reMoveImageView.contentMode = UIViewContentModeScaleAspectFit;
        _reMoveImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_reMoveImageView];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
   
    
    CGRect bounds = self.contentView.bounds;
    CGFloat width = bounds.size.width - self.contentInsets.left - self.contentInsets.right;
   
    CGRect frame = CGRectMake(0, 0, width, [self.tagModel contentSize].height);
    self.tagLabel.frame = frame;
    self.tagLabel.center = self.contentView.center;
    
    CGPoint ImageCenter = CGPointMake(CGRectGetMaxX(self.tagLabel.frame)-1, CGRectGetMinY(self.tagLabel.frame)+1);
    self.reMoveImageView.center = ImageCenter;
    
}

@end

//collectionViewCell 样式二 最后一个item用
@interface lastStyleCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *addImageView;
@property (nonatomic) UIEdgeInsets contentInsets;
@end

@implementation lastStyleCell
-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
       // _addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds))];
        _addImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 47, 25)];
        
        _addImageView.image = [UIImage imageNamed:@"icon_home_merchandise_editor_add-1"];
        _addImageView.backgroundColor = [UIColor whiteColor];
        _addImageView.userInteractionEnabled = YES;
        _addImageView.center = self.contentView.center;
        _addImageView.contentMode = UIViewContentModeScaleAspectFit;
       // self.contentView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:_addImageView];
        
    }

    return self;
}


@end

@interface FMEqualSpaceFlowLayout : UICollectionViewFlowLayout

@property (weak, nonatomic) id<UICollectionViewDelegateFlowLayout> delegate;
@property (nonatomic, strong) NSMutableArray *itemAttributes;
@property (assign,nonatomic) CGFloat contentHeight;

@end

@implementation FMEqualSpaceFlowLayout

- (id)init
{
    if (self = [super init]) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumInteritemSpacing = 5;
        self.minimumLineSpacing = 5;
        self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    
    return self;
}
//最item之间 间距
- (CGFloat)minimumInteritemSpacingAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    }
    
    return self.minimumInteritemSpacing;
}

- (CGFloat)minimumLineSpacingAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:minimumLineSpacingForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self minimumLineSpacingForSectionAtIndex:section];
    }
    
    return self.minimumLineSpacing;
}

- (UIEdgeInsets)sectionInsetAtSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)]) {
        return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    }
    
    return self.sectionInset;
}

#pragma mark - Methods to Override
- (void)prepareLayout
{
    [super prepareLayout];
    
    _contentHeight = 0;
    NSInteger itemCount = [[self collectionView] numberOfItemsInSection:0];
    self.itemAttributes = [NSMutableArray arrayWithCapacity:itemCount];
    
    CGFloat minimumInteritemSpacing = [self minimumInteritemSpacingAtSection:0];
    CGFloat minimumLineSpacing = [self minimumLineSpacingAtSection:0];
    UIEdgeInsets sectionInset = [self sectionInsetAtSection:0];
    
    CGFloat xOffset = sectionInset.left;
    CGFloat yOffset = sectionInset.top;
    CGFloat xNextOffset = sectionInset.left;
    
    for (NSInteger idx = 0; idx < itemCount; idx++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:0];
        
        CGSize itemSize = [self.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];

        xNextOffset += (minimumInteritemSpacing + itemSize.width);
        
        if (xNextOffset - minimumInteritemSpacing > [self collectionView].bounds.size.width - sectionInset.right) {
            xOffset = sectionInset.left;
            xNextOffset = (sectionInset.left + minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (minimumInteritemSpacing + itemSize.width);
        }
        
        UICollectionViewLayoutAttributes *layoutAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        
        layoutAttributes.frame = CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height);
        [_itemAttributes addObject:layoutAttributes];
        
        _contentHeight = MAX(_contentHeight, CGRectGetMaxY(layoutAttributes.frame));
    }
    
    _contentHeight += sectionInset.bottom ;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.itemAttributes)[indexPath.item];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [self.itemAttributes filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *evaluatedObject, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, [evaluatedObject frame]);
    }]];
}

- (CGSize)collectionViewContentSize {
    //重新计算布局
    [self prepareLayout];

    CGSize contentSize  = CGSizeMake(self.collectionView.frame.size.width, self.contentHeight);
  
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGSizeEqualToSize(oldBounds.size, newBounds.size)) {
        return YES;
    }
    return NO;
}

@end

@interface JHCRM_TagsView ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<NSString *> *tagsMutableArray;


@end

@implementation JHCRM_TagsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    
    _backGroundImageView = [[UIImageView alloc] init];
    [self addSubview:_backGroundImageView];
    
    [_backGroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.and.bottom.mas_equalTo(0);
    }];
    
    _contentInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    _tagInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    _tagBorderWidth = 0;
    _tagBackgroundColor = [UIColor whiteColor];
//    _tagSelectedBackgroundColor = [UIColor colorWithRGBValue:74 g:144 b:226];
    _tagFont = [UIFont systemFontOfSize:11];
    _tagSelectedFont = [UIFont systemFontOfSize:11];
    _tagTextColor = [UIColor colorWithRGBValue:90 g:90 b:90];
    _tagSelectedTextColor = [UIColor whiteColor];
    
    _tagHeight = 28;
    _mininumTagWidth = 0;
    _maximumTagWidth = CGFLOAT_MAX;
    _lineSpacing = 10;
    _interitemSpacing = 5;
    
    _allowsSelection = YES;
    _allowsMultipleSelection = NO;
    _allowEmptySelection = YES;
    
    _isEdit = NO;//默认不处于编辑状态
    _maxTagsNumber = 20; //默认 20个
    _tagLabelBorderWidth = 0;
    _tagLabelCornerRadius = 0;
    _tagLabelBackgroundColor = [UIColor whiteColor];
    _tagLabelSelectedBackgroundColor = [UIColor colorWithRGBValue:74 g:144 b:226];
    _tagLabelSelectedBorderColor = _tagLabelSelectedBackgroundColor;
    _tagLabelAddH = 11;
    _tagLabelAddW = 30;
    _maxSelectNumber = 10000;
    [self addSubview:self.collectionView];
    
    UICollectionView *collectionView = self.collectionView;
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = NSDictionaryOfVariableBindings(collectionView);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[collectionView]|"
                                                                   options:NSLayoutFormatAlignAllTop
                                                                   metrics:nil
                                                                     views:views];
    constraints = [constraints arrayByAddingObjectsFromArray:
                   [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[collectionView]|"
                                                           options:0
                                                           metrics:nil
                                                             views:views]];
    [self addConstraints:constraints];
}

- (CGSize)intrinsicContentSize {
    CGSize contentSize = self.collectionView.collectionViewLayout.collectionViewContentSize;
    return CGSizeMake(UIViewNoIntrinsicMetric, contentSize.height);
}

- (void)setTagsArray:(NSMutableArray<NSString *> *)tagsArray {
    
   
    _tagsMutableArray = [tagsArray mutableCopy];
    
    if (_isShowAddImageView) {
        
        [_tagsMutableArray addObject:@"addImage"]; //添加到最后占位用
    }
    
    [self.tagModels removeAllObjects];
    [_tagsMutableArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
         FMTagModel *tagModel = [[FMTagModel alloc] initWithName:obj font:self.tagFont labelAddw:self.tagLabelAddW labelAddH:self.tagLabelAddH];
        
        
        [self.tagModels addObject:tagModel];
    }];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
    
}

- (void)selectTagAtIndex:(NSMutableArray *)indexArr animate:(BOOL)animate {
    
    if (isObjEmpty(indexArr)) {
        return;
    }
    
    for (NSString * index in indexArr) {
        
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:[index intValue] inSection:0]
                                          animated:animate
                                    scrollPosition:UICollectionViewScrollPositionNone];
        
        //ljj 添加
        FMTagModel *tagModel = self.tagModels[[index intValue]];
        FMTagCell *cell = (FMTagCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[index intValue] inSection:0]];
        tagModel.selected = YES;
        [self setCell:cell selected:YES];
    }
}

- (void)deSelectTagAtIndex:(NSUInteger)index animate:(BOOL)animate {
    [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES];
}

#pragma mark - ......::::::: Edit :::::::......

- (NSUInteger)indexOfTag:(NSString *)tagName {
    __block NSUInteger index = NSNotFound;
    [self.tagsMutableArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:tagName]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

- (void)addTag:(NSString *)tagName isFront:(BOOL)isFront {
    //每次从前面添加
    
    if (self.tagsMutableArray.count >= 21) {
        
        if ([self.delegate respondsToSelector:@selector(tagsView:maxTagsNum:)]) {
            
            [self.delegate tagsView:self maxTagsNum:self.tagsMutableArray.count - 1];
        }
        
        return;
    }
    
    
    if (isFront) {
        //从最前面添加
        [self.tagsMutableArray insertObject:tagName atIndex:0];
        FMTagModel *tagModel = [[FMTagModel alloc] initWithName:tagName font:self.tagFont labelAddw:self.tagLabelAddW labelAddH:self.tagLabelAddH];
        
        
        [self.tagModels insertObject:tagModel atIndex:0];
    }else{
    
        //从最后面开始添加
        [self.tagsMutableArray insertObject:tagName atIndex:self.tagsMutableArray.count - 1];
        
         FMTagModel *tagModel = [[FMTagModel alloc] initWithName:tagName font:self.tagFont labelAddw:self.tagLabelAddW labelAddH:self.tagLabelAddH];
        [self.tagModels insertObject:tagModel atIndex:self.tagModels.count - 1];
    }
    
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)insertTag:(NSString *)tagName AtIndex:(NSUInteger)index {
    if (index >= self.tagsMutableArray.count) {
        return;
    }
    
    [self.tagsMutableArray insertObject:tagName atIndex:index];
    FMTagModel *tagModel = [[FMTagModel alloc] initWithName:tagName font:self.tagFont labelAddw:self.tagLabelAddW labelAddH:self.tagLabelAddH];
    [self.tagModels insertObject:tagModel atIndex:index];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)removeTagWithName:(NSString *)tagName {
    return [self removeTagAtIndex:[self indexOfTag:tagName]];
}

- (void)removeTagAtIndex:(NSUInteger)index {
    
    if (index >= self.tagsMutableArray.count || index == NSNotFound) {
        return ;
    }
    
    if (_isShowAddImageView) {
        
        if (index >= self.tagsMutableArray.count - 1 || index == NSNotFound) {
            return;
        }
    }
    
    [self.tagsMutableArray removeObjectAtIndex:index];
    [self.tagModels removeObjectAtIndex:index];
    [self.collectionView reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)removeAllTags {
    
    if (_isShowAddImageView) {
        
        [self.tagsMutableArray removeObjectsInRange:NSMakeRange(0, self.tagsMutableArray.count - 1)];
        [self.tagModels removeObjectsInRange:NSMakeRange(0, self.tagModels.count - 1)];
        
    }else{
    
    
        [self.tagsMutableArray removeAllObjects];
        [self.tagModels removeAllObjects];
    }
    
    [self.collectionView reloadData];
}

-(void)removeItem:(BOOL)remove{

    self.isEdit = remove;
    
    
    if (remove) {
        
        if (_isShowAddImageView) {
            
            _isShowAddImageView = NO;
        [self.tagsMutableArray removeLastObject];
        [self.tagModels removeLastObject ];
            
        }
        
        
    }else{
    
        if (!_isShowAddImageView) {
            
            _isShowAddImageView = YES;
//            [_tagsMutableArray addObject:@"zhanwei"];
            [self setTagsArray:_tagsMutableArray];
//            [_tagModels addObject:[[FMTagModel alloc]init]];
        }
    
    }
    
    
    [self.collectionView reloadData];

}

#pragma mark - ......::::::: CollectionView DataSource :::::::......

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isShowAddImageView && _tagsMutableArray.count - 1 == indexPath.row){
        
        static NSString *reuse = @"lastCell";
        lastStyleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
        cell.contentInsets = self.tagInsets;
        return cell;
    }

    FMTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTagCellID forIndexPath:indexPath];
    
    if (_isEdit) {
        
        cell.reMoveImageView.hidden = !_isEdit;
        
    }else{
    
       cell.reMoveImageView.hidden = !_isEdit;
    }
    
    
    FMTagModel *tagModel = self.tagModels[indexPath.row];
    cell.tagModel = tagModel;
    cell.tagLabel.text = tagModel.name;
//    cell.layer.cornerRadius = self.tagcornerRadius;
//    cell.layer.masksToBounds = self.tagcornerRadius > 0;
    
    cell.tagLabel.layer.cornerRadius = self.tagLabelCornerRadius;
    cell.tagLabel.layer.masksToBounds = self.tagLabelCornerRadius >0;
    
    cell.contentInsets = self.tagInsets;
    cell.layer.borderWidth = self.tagBorderWidth;
    
    NSArray *textArray = [tagModel.name componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
    
    if (textArray.count > 1) {
        tagModel.selected = YES;
    }
    
    [self setCell:cell selected:tagModel.selected];
    
    return cell;
}

- (void)setCell:(FMTagCell *)cell selected:(BOOL)selected {
    
    if (selected) {
        cell.backgroundColor = self.tagSelectedBackgroundColor;
        cell.tagLabel.font = self.tagSelectedFont;
        cell.tagLabel.textColor = self.tagSelectedTextColor;
        cell.tagLabel.layer.borderColor = self.tagLabelSelectedBorderColor.CGColor;
        cell.tagLabel.layer.borderWidth = self.tagLabelBorderWidth;
        
        cell.tagLabel.backgroundColor = self.tagLabelSelectedBackgroundColor;
//        cell.layer.borderColor = self.tagSelectedBorderColor.CGColor;
        
    }else {
        cell.backgroundColor = self.tagBackgroundColor;
        cell.tagLabel.font = self.tagFont;
        cell.tagLabel.textColor = self.tagTextColor;
        cell.tagLabel.layer.borderColor = self.tagLabelBorderColor.CGColor;
        cell.tagLabel.layer.borderWidth = self.tagLabelBorderWidth;
        cell.tagLabel.backgroundColor = self.tagLabelBackgroundColor;
//        cell.layer.borderColor = self.tagBorderColor.CGColor;
    }
}

#pragma mark - ......::::::: UICollectionViewDelegate :::::::......

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tagsView:shouldSelectTagAtIndex:)]) {
        return [self.delegate tagsView:self shouldSelectTagAtIndex:indexPath.row];
    }
    
    return _allowsSelection;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isShowAddImageView && _tagsMutableArray.count - 1 == indexPath.row) {
        //点击加号按钮不用取消选中
       
        return NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(tagsView:shouldDeselectItemAtIndex:)]) {
        return [self.delegate tagsView:self shouldDeselectItemAtIndex:indexPath.row];
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (_isShowAddImageView && _tagsMutableArray.count - 1 == indexPath.row) {
        
        //点击最后的加号按钮
        
              
        if ([self.delegate respondsToSelector:@selector(tagsView:didSelectAddItemAtIndex:)]) {
            [self.delegate tagsView:self didSelectAddItemAtIndex:indexPath.row];
        }

       
    }else{
    
        
        if (_isEdit) {
            
            [self removeRemind:indexPath];
            return;
        }
        
    
        if ([self.delegate respondsToSelector:@selector(tagsView:didSelectTagAtIndex:)]) {
            [self.delegate tagsView:self didSelectTagAtIndex:indexPath.row];
            if (self.forbidAction) {
                return;
            }
        }
        
        FMTagModel *tagModel = self.tagModels[indexPath.row];
        FMTagCell *cell = (FMTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        //如果允许多选
        if (self.allowsMultipleSelection) {
            
            
            if (self.selectedIndexes.count > self.maxSelectNumber) {
                
                if ([self.delegate respondsToSelector:@selector(tagsView:maxSelectTagsNum:)]) {
                    
                    [self.delegate tagsView:self maxSelectTagsNum:indexPath.row];
                }
            }
            
            tagModel.selected = YES;
            [self setCell:cell selected:YES];
            return;
        }
        
        //修复单选情况下，无法取消选中的问题
        if (tagModel.selected) {
            //不允许空选，直接返回
            if (!self.allowEmptySelection && self.collectionView.indexPathsForSelectedItems.count == 1) {
                return;
            }
            
            cell.selected = NO;
            collectionView.allowsMultipleSelection = YES;
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            [self collectionView:collectionView didDeselectItemAtIndexPath:indexPath];
            collectionView.allowsMultipleSelection = NO;
            return;
        }
        
        tagModel.selected = YES;
        [self setCell:cell selected:YES];
    
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isShowAddImageView && _tagsMutableArray.count - 1 == indexPath.row) {
        
        //点击最后的加号按钮
        
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(tagsView:didDeSelectTagAtIndex:)]) {
        [self.delegate tagsView:self didDeSelectTagAtIndex:indexPath.row];
    }
    
    FMTagModel *tagModel = self.tagModels[indexPath.row];
    FMTagCell *cell = (FMTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
    tagModel.selected = NO;
    [self setCell:cell selected:NO];
}



#pragma mark - ......::::::: UICollectionViewDelegateFlowLayout :::::::......

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMTagModel *tagModel = self.tagModels[indexPath.row];
    
    CGFloat width = tagModel.contentSize.width + self.tagInsets.left + self.tagInsets.right;
    if (width < self.mininumTagWidth) {
        width = self.mininumTagWidth;
    }
    if (width > self.maximumTagWidth) {
        width = self.maximumTagWidth;
    }
    
    return CGSizeMake(width, self.tagHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return self.interitemSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return self.lineSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return self.contentInsets;
}

#pragma mark -- item处于编辑状态下 删除item 的提示框--
-(void)removeRemind:(NSIndexPath *)indexPath{

    FMTagCell *cell = (FMTagCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSString *shopName = cell.tagLabel.text;
    
    
    if ([self.delegate respondsToSelector:@selector(tagsView:isEnditDidSelectTagAtIndex:commodityName:)]) {
        
       [self.delegate tagsView:self isEnditDidSelectTagAtIndex:indexPath.row commodityName:shopName];
        
        
    }
    
}



#pragma mark - ......::::::: Getter and Setter :::::::......

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        FMEqualSpaceFlowLayout *flowLayout = [[FMEqualSpaceFlowLayout alloc] init];
        flowLayout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[FMTagCell class] forCellWithReuseIdentifier:kTagCellID];
        
        [_collectionView registerClass:[lastStyleCell class] forCellWithReuseIdentifier:@"lastCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    
    _collectionView.allowsSelection = _allowsSelection;
    _collectionView.allowsMultipleSelection = _allowsMultipleSelection;
    
    return _collectionView;
}

- (UIFont *)tagSelectedFont {
    if (!_tagSelectedFont) {
        return _tagFont;
    }
    
    return _tagSelectedFont;
}

- (UIColor *)tagSelectedBorderColor {
    if (!_tagSelectedBorderColor) {
        return _tagBorderColor;
    }
    
    return _tagSelectedBorderColor;
}

- (NSUInteger)selectedIndex {
    return self.collectionView.indexPathsForSelectedItems.firstObject.row;
}

- (NSArray<NSString *> *)selecedTags {
    if (!self.allowsMultipleSelection) {
        return nil;
    }
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [result addObject:self.tagsMutableArray[indexPath.row]];
    }
    
    return result.copy;
}

- (NSArray<NSNumber *> *)selectedIndexes {
    if (!self.allowsMultipleSelection) {
        return nil;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSIndexPath *indexPath in self.collectionView.indexPathsForSelectedItems) {
        [result addObject:@(indexPath.row)];
    }
    
    return result.copy;
}

- (NSMutableArray<FMTagModel *> *)tagModels {
    if (!_tagModels) {
        _tagModels = [[NSMutableArray alloc] init];
    }
    return _tagModels;
}

- (NSArray<NSString *> *)tagsArray {
    return [self.tagsMutableArray copy];
}

@end
