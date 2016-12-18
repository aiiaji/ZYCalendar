//
//  ZYCalendarRange.h
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ZYCalendarRangeDrawMode) {
    
    ZYCalendarRangeDrawModeAirbnb,
    ZYCalendarRangeDrawModeSingleLine,
    ZYCalendarRangeDrawModeOnlyCurrentMonth,
    
    
    
};

@interface ZYCalendarRange : NSObject

@property (nonatomic, copy)NSDate *beginDate;
@property (nonatomic, copy)NSDate *endDate;
@property (nonatomic, assign)ZYCalendarRangeDrawMode drawMode;
@property (nonatomic, strong)UIColor *rangeColor;
@property (nonatomic, copy)UIColor *dotColor;
@property (nonatomic, copy)UIColor *dateColor;

@property (nonatomic, assign,getter=isDisabled)BOOL disabled;

- (BOOL)isContainsDate:(NSDate *)date;

- (BOOL)isOverlappingWithRange:(ZYCalendarRange *)range;

- (BOOL)isLargeOrEqualToRange:(ZYCalendarRange *)range;

+ (instancetype)rangeWithBeginDate:(NSDate *)beginDate endDate:(NSDate *)endDate color:(UIColor *)color;

@end
