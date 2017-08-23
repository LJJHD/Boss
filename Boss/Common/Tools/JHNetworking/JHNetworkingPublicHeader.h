//
//  JHNetworkingPublicHeader.h
//  JinghanLife
//
//  Created by 方磊 on 2017/2/9.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#ifndef JHNetworkingPublicHeader_h
#define JHNetworkingPublicHeader_h

#pragma mark - service
#import "JHService.h"
#import "JHServiceFactory.h"

#pragma mark - Generators
#import "JHCommonParamsGenerator.h"
#import "JHRequestGenerator.h"

#pragram mark - Configurations
#import "JHNetworkingConfiguration.h"

#pragram mark - Category
#import "NSURLRequest+JHRequestParams.h"
#import "NSDictionary+JHNetworkingMethods.h"
#import "NSArray+JHNetworkingMethod.h"

#pragram mark - Components
#pragram mark - BaseAPIManager
#import "JHBaseAPIManager.h"

#pragram mark - Cache
#import "JHCachedObject.h"
#import "JHCache.h"

#pragram mark - APIProxy
#import "JHAPIProxy.h"

#pragram mark - URLResponse
#import "JHURLResponse.h"

#endif /* JHNetworkingPublicHeader_h */
