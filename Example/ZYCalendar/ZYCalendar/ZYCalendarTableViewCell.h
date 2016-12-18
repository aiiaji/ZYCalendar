//
//  ZYCalendarTableViewCell.h
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCalendarCell.h"
@class ZYCalendarTableViewCellModel;
@class ZYCalendarRange;
@class ZYCalendarTableViewCell;
@protocol ZYCalendarTableViewCellDelegate <NSObject>

- (void)ZYCalendarTableViewCell:(ZYCalendarTableViewCell *)cell  didSelectDateCell:(ZYCalendarCell *)dateCell;

- (void)customConfigForDateCell:(ZYCalendarCell *)cell;

@end


@protocol ZYCalendarTableViewCellCache <NSObject>

- (ZYCalendarCellModel *)ZYCalendarTableViewCell:(ZYCalendarTableViewCell *)cell cacheForCell:(ZYCalendarCell *)dateCell dateCellIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYCalendarTableViewCell : UITableViewCell

@property (nonatomic, copy, readonly)NSDate *beginDate;
@property (nonatomic, copy, readonly )NSDate *endDate;
@property (nonatomic, strong, readonly)NSMutableArray *ranges;
@property (nonatomic, strong)ZYCalendarTableViewCellModel *modelItem;
@property (nonatomic, weak)id<ZYCalendarTableViewCellDelegate> delegate;
@property (nonatomic, weak)id<ZYCalendarTableViewCellCache> cacher;
@property (nonatomic, assign)BOOL hideNonePositionDay;
@property (nonatomic, copy)NSString *todayTitle;
@property (nonatomic, assign)BOOL userInteractionEnabledForOtherDays;
@property (nonatomic, copy)UIColor *highlightDateCellColor;
@property (nonatomic, assign)BOOL square;
@property (nonatomic, copy)UIColor *dotColor;
@property (nonatomic, assign)CGFloat dotRadius;
@property (nonatomic, copy)UIColor *dateColor;



+ (instancetype)tableViewCellWithIdentifier:(NSString *)identifier
                                  cellWidth:(CGFloat )cellwidth
                                 cellHeight:(CGFloat)cellHeight
                                leftPadding:(CGFloat )leftPadding
                               rightPadding:(CGFloat )rightPadding
                                linePadding:(CGFloat )linePadding;


@end
