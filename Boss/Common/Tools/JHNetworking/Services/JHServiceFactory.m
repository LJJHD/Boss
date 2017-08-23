//
//  JHServiceFactory.m
//  JinghanLife
//
//  Created by 方磊 on 2017/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHServiceFactory.h"

@interface JHServiceFactory()

@property (strong, nonatomic) NSMutableDictionary * serviceStorage;

@property (strong, nonatomic) NSDictionary * allServiceNameDictionary;
@property (strong, nonatomic, readwrite) NSArray * allServiceNameList;

@end

@implementation JHServiceFactory

+ (instancetype)shareInstance{
    static JHServiceFactory * sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JHServiceFactory alloc]init];
    });
    return sharedInstance;
}

#pragma mark - public methods
- (JHService<JHServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier{
    if (isObjEmpty(self.serviceStorage[identifier])){
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

- (JHService<JHServiceProtocol> *)serviceWithServiceClass:(Class)aClass{
    return [self serviceWithIdentifier:NSStringFromClass(aClass)];
}

#pragma mark - private method
- (JHService<JHServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
    NSAssert(self.allServiceNameDictionary[identifier], @"invalid service identifier");
    Class aServiceClass = NSClassFromString(self.allServiceNameDictionary[identifier]);
    return [[aServiceClass alloc]init];
}

#pragma mark - setter / getter
- (NSMutableDictionary *)serviceStorage{
    if (isObjEmpty(_serviceStorage)) {
        _serviceStorage = [NSMutableDictionary dictionary];
    }
    return _serviceStorage;
}

- (NSDictionary *)allServiceNameDictionary{
    if (isObjEmpty(_allServiceNameDictionary)) {
        _allServiceNameDictionary = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"JHServiceNamePlist" ofType:@"plist"]];
    }
    return _allServiceNameDictionary;
}

- (NSArray *)allServiceNameList{
    if (isObjEmpty(_allServiceNameList)) {
        _allServiceNameList = [NSArray arrayWithArray:self.allServiceNameDictionary.allKeys];
    }
    return _allServiceNameList;
}

@end
