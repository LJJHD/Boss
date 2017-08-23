//
//  JH_SliderSegmentView.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/3/14.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JH_SliderSegmentView.h"
#define CollectionW (self.width)
@interface JH_SliderSegmentView ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *btnArray;
@property (nonatomic,strong) UICollectionView *collectionView;


@end

@implementation JH_SliderSegmentView


- (id)initWithTitleArray:(NSArray*)array
{
  self =   [super init];
    if (self) {
        [self creatSubViews];
    }
    return self;
}
- (id)init{
     self =  [super init];
    if (self) {
        [self createCollectionView];
    }
    return self;
}
- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
 
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    //注册Cell，必须要有
    [self.collectionView registerNibWithClass:[JH_SliderCollectionViewCell class]];
    [self addSubview:self.collectionView];
}
#pragma mark ---delegate---
#pragma mark collectionviewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.modelArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"JH_SliderCollectionViewCell";
    JH_SliderCollectionViewCell * cell =(JH_SliderCollectionViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = [JHUtility boundingRectWithSize:CGSizeMake(DEF_WIDTH, DEF_HEIGHT) font:[UIFont systemFontOfSize:17] string:[self.modelArray[indexPath.row] titleStr] withSpacing:0];
    
    return CGSizeMake(size.width+10, self.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 20;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   JH_SliderCollectionViewCell  *cell = (JH_SliderCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    @weakify(self);
    [self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        JH_SliderModel *model = obj;
        if (model.isSelect) {
            
            model.isSelect = NO;
            JH_SliderCollectionViewCell  *lastcell = (JH_SliderCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
            lastcell.model = model;
            *stop =YES;
        }
        
    }];
    
    JH_SliderModel *model = self.modelArray[indexPath.row];
    model.isSelect = YES;
    cell.model = model;
    
    [self changeScrollConoff:cell];
    
    if ([self.delegate respondsToSelector:@selector(sliderSegmentView:didSelectItemAtIndexPath:)]) {
        [self.delegate sliderSegmentView:self.collectionView didSelectItemAtIndexPath:indexPath.row];
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}
- (void)changeScrollConoff:(UICollectionViewCell*)sender
{
    float conX       = self.collectionView.contentOffset.x;
    float frameX     = CGRectGetMinX(sender.frame);
    float frameWidth = sender.frame.size.width;
    if (frameX-conX > CollectionW/2)
    {
        
        if (frameX-CollectionW/2+sender.frame.size.width/2>self.collectionView.contentSize.width-CollectionW) {
            [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentSize.width-CollectionW, 0) animated:YES];
            
        }else
        {
            [self.collectionView setContentOffset:CGPointMake(frameX-CollectionW/2+sender.frame.size.width/2, 0) animated:YES];
            
        }
    }
    float MaxX = CGRectGetMaxX(sender.frame);
    
    if (MaxX-conX<CollectionW/2) {
        
        if (MaxX-CollectionW/2-frameWidth+frameWidth/2<=0) {
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
            
        }else
        {
            [self.collectionView setContentOffset:CGPointMake(MaxX-CollectionW/2-frameWidth+frameWidth/2, 0) animated:YES];
            
        }
        
        
    }
    
}

- (void)setModelArray:(NSArray *)modelArray
{
    _modelArray = modelArray;
    [self.collectionView reloadData];
}
- (void)creatSubViews
{
    self.sliderScrolView = [[UIScrollView alloc] init];
    [self addSubview:self.sliderScrolView];
    self.btnArray =[NSMutableArray array];
    @weakify(self);
    [self.modelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.modelArray[idx]];
        [self.sliderScrolView addSubview:btn];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btnArray addObject:btn];
    }];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return;
    /***
    [self.sliderScrolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
   
    @weakify(self);
    __block UIButton  *lastBtn;
    [self.btnArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        UIButton *btn = obj;
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastBtn) {
                make.leading.equalTo(lastBtn.mas_trailing).offset(30);
            }
            else
            {
                make.leading.mas_equalTo(30/2.);
            }
            
            make.height.mas_equalTo(self.sliderScrolView);
            
            make.centerY.equalTo(self.sliderScrolView.mas_centerY);
        }];
        lastBtn = btn;
    }];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_offset(-30/2);
        
    }];*/
    
}
@end
