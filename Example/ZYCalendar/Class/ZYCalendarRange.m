//
//  ZYCalendarRange.m
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ZYCalendarRange.h"
#import "NSDate+ZYDateTools.h"
@implementation ZYCalendarRange

- (BOOL)isContainsDate:(NSDate *)date {
    
    return [date lzy_isLaterThanOrEqualTo:self.beginDate] && [date lzy_isEarlierThanOrEqualTo:self.endDate];
}

- (BOOL)isOverlappingWithRange:(ZYCalendarRange *)range {
    
    BOOL isEndEarilerThanRangeBegin = [self.endDate lzy_isEarlierThan:range.beginDate];
    BOOL isBeginLaterThanRangeEnd = [self.beginDate lzy_isLaterThan:range.endDate];
    BOOL isBeginLaterThanRangeBegin = [self.beginDate lzy_isLaterThan:range.beginDate];
    BOOL isBeginEarilerThanRangeBegin = !isBeginLaterThanRangeBegin;
    
    if ((isBeginLaterThanRangeEnd ||isEndEarilerThanRangeBegin) || (isBeginEarilerThanRangeBegin && isEndEarilerThanRangeBegin)) {
        
        return NO;
    }
    else {
        
       return  YES;
        
    }
}

- (BOOL)isLargeOrEqualToRange:(ZYCalendarRange *)range {
    
    return ([self.beginDate lzy_isEarlierThan:range.beginDate] || [self.endDate lzy_isLaterThan:range.endDate]) && [self isOverlappingWithRange:range];
    
}

+ (instancetype)rangeWithBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate color:(UIColor *)color
{
    ZYCalendarRange *range = [ZYCalendarRange new];
    range.beginDate = [NSDate lzy_dateStandardFormatTimeZeroWithDate:beginDate];
    range.endDate   = [NSDate lzy_dateStandardFormatTimeZeroWithDate:endDate];;
    range.rangeColor = color;
    range.dateColor = [UIColor whiteColor];
    
    return range;
    
}

@end
