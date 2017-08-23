//
//  UIControl+PreverQuickTapsBtn.m
//  Boss
//
//  Created by jinghankeji on 2017/4/5.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UIControl+PreverQuickTapsBtn.h"

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";

static const char *UIcontrol_ignoreEvent = "UIcontrol_ignoreEvent";

@implementation UIControl (PreverQuickTapsBtn)

-(NSTimeInterval)JHBtn_acceptEventInterval{

    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

-(void)setJHBtn_acceptEventInterval:(NSTimeInterval)JHBtn_acceptEventInterval{


    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(JHBtn_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(BOOL)JHBtn_ignoreEvent{

    return [objc_getAssociatedObject(self, UIcontrol_ignoreEvent) boolValue];
}


-(void)setJHBtn_ignoreEvent:(BOOL)JHBtn_ignoreEvent{

    return objc_setAssociatedObject(self, UIcontrol_ignoreEvent, @(JHBtn_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}

+(void)load{

    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    
    Method b = class_getInstanceMethod(self, @selector(jh_sendAction:to:forEvent:));
    
    method_exchangeImplementations(a, b);

}

-(void)jh_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {

    if (self.JHBtn_ignoreEvent) {
        return;
    }

    if (self.JHBtn_acceptEventInterval > 0) {
        self.JHBtn_ignoreEvent = YES;
        
        [self performSelector:@selector(setJHBtn_ignoreEvent:) withObject:@(NO) afterDelay:self.JHBtn_acceptEventInterval];
    }

    [self jh_sendAction:action to:target forEvent:event];
}


@end
