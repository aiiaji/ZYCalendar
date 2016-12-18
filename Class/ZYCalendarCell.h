//
//  ZYCalendarCell.h
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCalendarRange.h"


typedef NS_ENUM(NSUInteger, ZYCalendarCellPosition)  {
    
    ZYCalendarCellPositionLeft = 0,
    ZYCalendarCellPositionRight,
    ZYCalendarCellPositionMiddle,
    ZYCalendarCellPositionNoneBefore,
    ZYCalendarCellPositionNoneLater,
    
};

typedef NS_ENUM(NSUInteger, ZYCalendarCellRangeProterty) {
    
    ZYCalendarCellRangeProtertyBegin = 0,
    ZYCalendarCellRangeProtertyEnd,
    ZYCalendarCellRangeProtertyMiddle,
    ZYCalendarCellRangeProtertyNone,
    
    
};

@class ZYCalendarCellModel;

@class ZYCalendarCell;
@protocol ZYCalendarCellDelegate <NSObject>

- (void)customConfigForDateCell:(ZYCalendarCell *)cell;

@end

@interface ZYCalendarCell : UICollectionViewCell

@property (nonatomic, strong, readonly)UILabel *dateLabel;
@property (nonatomic, strong, readonly)UIView *highlightView;
@property (nonatomic, strong, readonly)UIView *dotView;

@property (nonatomic, assign,readonly)ZYCalendarCellPosition      position;
@property (nonatomic, assign,readonly)ZYCalendarCellRangeProterty rangeProterty;
@property (nonatomic, strong,readonly)NSDate *date;
@property (nonatomic, strong, readonly)ZYCalendarCellModel *modelItem;
@property (nonatomic, copy)UIColor *hightlightColor;
@property (nonatomic, copy)UIColor *dotColor;
@property (nonatomic, assign)CGFloat dotRadius;
@property (nonatomic, assign)BOOL square;
@property (nonatomic, assign)BOOL hideNonePositionDay;
@property (nonatomic, assign)BOOL userInteractionEnabledForOtherDays;
@property (nonatomic, copy)NSString *todayTitle;
@property (nonatomic, weak)id<ZYCalendarCellDelegate> delegate;
@property (nonatomic, copy)UIColor *dateColor;

- (BOOL)isFromOtherMonth;

- (void)updateWithModelItem:(ZYCalendarCellModel *)model;


@end
