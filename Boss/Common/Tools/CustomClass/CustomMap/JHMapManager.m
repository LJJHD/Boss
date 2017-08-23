//
//  JHMapManager.m
//  JinghanLife
//
//  Created by 晶汉mac on 2017/2/15.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHMapManager.h"
#import "JHLocationService.h"

@implementation JHMapManager
+(void)setup
{
    BMKMapManager *mapManager  = [[BMKMapManager alloc]init];
    BOOL ret = [mapManager start:@"UGlrPpAfKQIWPOrOsDvG6qT67OpviDvC"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
}
@end
