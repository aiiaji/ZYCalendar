//
//  ZYCalendarCellModel.h
//  LZCalendar
//
//  Created by 李耔余 on 2016/12/15.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYCalendarCell.h"
#import "ZYCalendarRange.h"


@interface ZYCalendarCellModel : NSObject

@property (nonatomic, assign, readonly)ZYCalendarCellPosition position;

@property (nonatomic, copy, readonly)NSDate *cellDate;

@property (nonatomic, strong)ZYCalendarRange *range;

@property (nonatomic, assign, readonly)NSInteger currentMonth;

@property (nonatomic, assign, readonly)CGFloat lineHeight;

@property (nonatomic, assign, readonly)UIEdgeInsets corverInsets;



+ (instancetype)modelWithDaysOffset:(CGFloat )daysOffset
                          beginDate:(NSDate *)beginDate
                            endDate:(NSDate *)endDate
                          indexPath:(NSIndexPath *)indexPath
                         lineHeight:(CGFloat )lineHeight
                              range:(ZYCalendarRange *)range
                       corverInsets:(UIEdgeInsets )corverInsets;

@end
