//
//  UIView+NLTVScheduleTemplateCellHelper.m
//  ScheduleTemplate
//
//  Created by GuoYongming on 11/14/16.
//  Copyright © 2016 Neulion. All rights reserved.
//

#import "UIView+NLTVScheduleTemplateCellHelper.h"
#import <objc/runtime.h>

@implementation UIView (NLTVScheduleTemplateCellHelper)

- (void)setOutterIndex:(NSNumber *)outterIndex
{
    objc_setAssociatedObject(self, "outterIndex", outterIndex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)outterIndex
{
    return objc_getAssociatedObject(self, "outterIndex");
}

- (void)setInnerIndex:(NSNumber *)innerIndex
{
    objc_setAssociatedObject(self, "innerIndex", innerIndex, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)innerIndex
{
    return objc_getAssociatedObject(self, "innerIndex");
}

@end
