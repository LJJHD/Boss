//
//  JHBoss_ChooseMessageTableViewCell.m
//  Boss
//
//  Created by SeaDragon on 2017/6/27.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHBoss_ChooseMessageTableViewCell.h"

#import "JHBoss_PayMessageView.h"

#import "JHBoss_PayMessageItem.h"
#import "JHBoss_PayMessageHelper.h"

#define kCols 2
#define kRow  2

@interface JHBoss_ChooseMessageTableViewCell ()

@property (nonatomic, strong) NSMutableArray *payViewArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JHBoss_ChooseMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
    }
    
    return self;
}


#pragma mark - Public Method

- (void)showDetailWithPayMessageItemArray:(NSMutableArray *)itemArray indexPath:(NSIndexPath *)indexPath {
    
    self.indexPath = indexPath;
    
    for (NSInteger i = 0; i < itemArray.count; i++) {
        
        JHBoss_PayMessageView *payView = [[JHBoss_PayMessageView alloc] init];
        [self.contentView addSubview:payView];
        [self.payViewArray addObject:payView];
        
        @weakify(self);
        
        [payView setMessageBlock:^(JHBoss_PayMessageItem *item){
    
            @strongify(self);
    
            for (JHBoss_PayMessageItem *tmpItem in itemArray) {
                tmpItem.select = NO;
            }
            
            item.select = YES;

            [self changeChooseWithItemArray:itemArray];

            if (self.delegate && [self.delegate respondsToSelector:@selector(chooseMessageTableViewCellDelegate:payItem:indexPath:)]) {
                [self.delegate chooseMessageTableViewCellDelegate:self payItem:item indexPath:self.indexPath];
            }
        
        }];
        
        [payView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@90);
            make.top.equalTo(@((i/kCols * (90 + 25)) + 20));
            make.width.equalTo(self.contentView).multipliedBy(0.4);
            make.left.equalTo(@((i%kRow * (self.contentView.width * 0.5 + (DEF_DEVICE_Iphone5?0:(DEF_DEVICE_Iphone6p?12.5:5))) + 15)));
        }];
    }

    [self changeChooseWithItemArray:itemArray];

}

- (void)changeChooseWithItemArray:(NSMutableArray *)itemArray {

    for (NSInteger i = 0; i < itemArray.count; i++) {
        JHBoss_PayMessageView *payView = self.payViewArray[i];
        payView.payItem = itemArray[i];
    }
    
}

#pragma mark - Getter

- (NSMutableArray *)payViewArray {

    if (!_payViewArray) {
        
        _payViewArray = [NSMutableArray arrayWithCapacity:4];
    }
    
    return _payViewArray;
}

@end
