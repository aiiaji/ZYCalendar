//
//  ZYCalendarCellModel.m
//  LZCalendar
//
//  Created by 李耔余 on 2016/12/15.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ZYCalendarCellModel.h"
#import "NSDate+ZYDateTools.h"
#import "ZYCalendarCell.h"

@interface ZYCalendarCellModel ()

@property (nonatomic, assign, readwrite)ZYCalendarCellPosition position;

@property (nonatomic, copy, readwrite)NSDate *cellDate;

@property (nonatomic, assign, readwrite)NSInteger currentMonth;

@property (nonatomic, assign, readwrite)CGFloat lineHeight;

@property (nonatomic, assign, readwrite)UIEdgeInsets corverInsets;

@end


@implementation ZYCalendarCellModel

+ (instancetype)modelWithDaysOffset:(CGFloat)daysOffset
                          beginDate:(NSDate *)beginDate
                            endDate:(NSDate *)endDate
                          indexPath:(NSIndexPath *)indexPath
                         lineHeight:(CGFloat)lineHeight
                              range:(ZYCalendarRange *)range
                       corverInsets:(UIEdgeInsets)corverInsets {
    
    ZYCalendarCellModel *model = [ZYCalendarCellModel new];
    model.range = range;
    NSDate *cellDate = nil;
    model.lineHeight = lineHeight;
    model.corverInsets = corverInsets;
    cellDate = [beginDate lzy_dateByAddingDays:-daysOffset + indexPath.item];
    
    NSUInteger locate_x = indexPath.item % 7;
    ZYCalendarCellPosition position;
    
    
    if ([cellDate lzy_isLaterThanOrEqualTo:beginDate] && [cellDate lzy_isEarlierThanOrEqualTo:endDate]) {
        
        if (locate_x == 0) {
            
            position = ZYCalendarCellPositionLeft;
        }
        else if (locate_x == 6){
            
            position = ZYCalendarCellPositionRight;
            
        }else {
            
            position = ZYCalendarCellPositionMiddle;
        }
    }
    else {
        
        //在当前显示月份之外
        //cellDate is not belong current display month
        if ([cellDate lzy_isLaterThanOrEqualTo:endDate]) {
            position = ZYCalendarCellPositionNoneLater;
        }
        else if ([cellDate lzy_isEarlierThanOrEqualTo:beginDate]){
            position = ZYCalendarCellPositionNoneBefore;
        }
        
    }
    
    model.position = position;
    model.cellDate = cellDate;
    model.currentMonth = beginDate.lzy_month;
    
    return model;
    
}

@end
