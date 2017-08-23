//
//  JHRequsetCaches.h
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHRequsetCaches : NSObject
+ (id)getCachesDataWithKey:(NSString*)key;
+ (void)saveDataWith:(id)data withKey:(NSString*)key;
@end
