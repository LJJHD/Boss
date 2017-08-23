//
//  AddressManager.h
//  BDMobile
//
//  Created by 朱成尧 on 3/16/16.
//  Copyright © 2016 kedavra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressManager : NSObject

+ (AddressManager *)sharedManager;
+ (NSArray *)firstLevelArray;
+ (NSDictionary *)secondLevelMap;
+ (NSDictionary *)thirdLevelMap;
+ (NSArray *)address;

+ (NSArray *)secondLevelArrayInFirst:(NSString *)firstLevelName;

+ (NSNumber *)indexOfFirst:(NSString *)firstLevelName;
+ (NSNumber *)indexOfSecond:(NSString *)secondLevelName inFirst:(NSString *)firstLevelName;

@end
