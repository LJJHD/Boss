//
//  AddressManager.m
//  BDMobile
//
//  Created by 朱成尧 on 3/16/16.
//  Copyright © 2016 kedavra. All rights reserved.
//

#import "AddressManager.h"

@interface AddressManager ()

@property (strong, nonatomic) NSArray *addressArray;
@property (strong, nonatomic) NSMutableArray *firstLevelArray;
@property (strong, nonatomic) NSMutableDictionary *secondLevelMap;
@property (strong, nonatomic) NSMutableDictionary *thirdLevelMap;

@end

@implementation AddressManager

+ (AddressManager *)sharedManager {
    static AddressManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"json"];
        NSError *error = nil;
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if (error) {
        }
        if ([jsonObject valueForKeyPath:@"allRegion"]) {
            shared_manager.addressArray = [jsonObject valueForKeyPath:@"allRegion"];

            NSMutableArray *firstLevelArray = [[NSMutableArray alloc] initWithCapacity:50];
            NSMutableDictionary *secondLevelMap = [[NSMutableDictionary alloc] initWithCapacity:100];
            NSMutableDictionary *thirdLevelMap = [[NSMutableDictionary alloc] initWithCapacity:400];


            for (NSDictionary *firstLevelDict in shared_manager.addressArray) {
                [firstLevelArray addObject:[firstLevelDict objectForKey:@"regionName"]]; // 省列表


                NSMutableArray *secondadd = [NSMutableArray array];

                for (NSDictionary *secondLevelDict in [firstLevelDict objectForKey:@"childCitys"]) {
                    NSMutableArray *thirdadd = [NSMutableArray array];
                    
                    for (NSDictionary *thirdLevelDict in [secondLevelDict objectForKey:@"childDistricts"]) {
                        [thirdadd addObject:thirdLevelDict[@"regionName"]];
                    }
                    [thirdLevelMap setObject:thirdadd forKey:secondLevelDict[@"regionName"]];

                    [secondadd addObject:secondLevelDict[@"regionName"]];
                }
                [secondLevelMap setObject:secondadd forKey:firstLevelDict[@"regionName"]];
            }
            shared_manager.firstLevelArray = firstLevelArray;
            shared_manager.secondLevelMap = secondLevelMap;
            shared_manager.thirdLevelMap = thirdLevelMap;
        }
    });
    return shared_manager;
}

+ (NSArray *)firstLevelArray {
    return [self sharedManager].firstLevelArray;
}
+ (NSDictionary *)secondLevelMap {
    return [self sharedManager].secondLevelMap;
}

+ (NSDictionary *)thirdLevelMap {
    return [self sharedManager].thirdLevelMap;
}

+ (NSArray *)secondLevelArrayInFirst:(NSString *)firstLevelName {
    return [[self sharedManager].secondLevelMap objectForKey:firstLevelName];
}
+ (NSNumber *)indexOfFirst:(NSString *)firstLevelName {
    NSInteger index = [[self firstLevelArray] indexOfObject:firstLevelName];
    if (index == NSNotFound) {
        return nil;
    }
    return [NSNumber numberWithInteger:index];
}
+ (NSNumber *)indexOfSecond:(NSString *)secondLevelName inFirst:(NSString *)firstLevelName {
    NSInteger index = [[self secondLevelArrayInFirst:firstLevelName] indexOfObject:secondLevelName];
    if (index == NSNotFound) {
        return nil;
    }
    return [NSNumber numberWithInteger:index];
}

+ (NSArray *)address {

    return [self sharedManager].addressArray;
}

@end
