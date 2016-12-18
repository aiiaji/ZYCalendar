//
//  ZYCalendar.h
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYCalendarRange.h"
#import "ZYCalendarCell.h"
#import "ZYCalendarTableViewCell.h"
#import "ZYCalendarCellModel.h"
#import "ZYCalendarTableViewCellModel.h"
#import "NSDate+ZYDateTools.h"
#import "ZYCalendarWeekView.h"
typedef NS_ENUM(NSInteger, ZYCalendarStyle) {
    
    ZYCalendarStyleVerticalPlain,
    ZYCalendarStyleVerticalGroup,
    //  if use ZYCalendarStyleVerticalPage,will set pagingEnabled = YES and adjust the height of calendar to make sure scroll currently
    ZYCalendarStyleVerticalPage,
    
};

typedef NS_ENUM(NSInteger, ZYCalendarSeparatorStyle) {
    ZYCalendarSeparatorStyleeNone,
    ZYCalendarSeparatorStyleSingleLine,
    ZYCalendarSeparatorStyleSingleLineEtched   // This separator style is only supported for grouped style calendar views currently
};

@class ZYCalendar;
@class ZYCalendarCell;
@protocol ZYCalendarDataSource <NSObject>
/*
 * You can set height for month,height will adjust for calendar width,you could set linePadding or lineHeight;
 * 不建议调整每个月份的高度，每个月份的高度会计算好，可以通过linePadding和LineHight去调整高度
 *
 */

/***********************************************************************************/

/*
 * Just like UITableView,you could set title for header;
 *
 * 使用方法就像UITableView，可以设置Header的标题;
 *
 * @param - calendar currentCalendar
 * @param - year yearForMonthView
 * @param - month monthForMonthView
 */
- (NSString *)ZYCalendar:(ZYCalendar *)calendar headerTitleForYear:(NSInteger )year month:(NSInteger)month;
/*
 * Just like UITableView,you could set view for header;
 *
 * 使用方法就像UITableView，可以设置Header的View;
 *
 * @param - calendar currentCalendar
 * @param - year yearForMonthView
 * @param - month monthForMonthView
 */
- (UIView *)ZYCalendar:(ZYCalendar *)calendar headerViewForYear:(NSInteger )year month:(NSInteger )month;
/*
 * Just like UITableView,you could set height for header;
 *
 * 使用方法就像UITableView，可以设置Header的高度;
 *
 * @param - calendar currentCalendar
 * @param - year yearForMonthView
 * @param - month monthForMonthView
 */
- (CGFloat )ZYCalendar:(ZYCalendar *)calendar heightForHeaderWithYear:(NSInteger)year month:(NSInteger)month;


@end

@protocol ZYCalendarDelegate <NSObject>


/*
 * you could use this method to set your logic when cell was selected
 *
 * 通过实现这个方法去实现点击cell时的自定义逻辑，默认的逻辑会进行范围的选择,如果实现了这个方法将不会执行默认逻辑
 *
 * @param - cell cell was selected
 */
- (void)ZYCalendar:(ZYCalendar *)calendar didSelectCell:(ZYCalendarCell *)cell;
/*
 * you could use this method to custom config date cell
 *
 * 通过实现这个方法去实现自定义datecell
 *
 * 
 */
- (void)ZYCalendar:(ZYCalendar *)calendar customConfigDateCell:(ZYCalendarCell *)cell;

@end





@interface ZYCalendar : UIView


@property (nonatomic, copy)NSString *todayTitle;

/*
 * set ranges to display the range of date
 *
 *  more properties for ZYCalendarRange please check "ZYCalendarRange.h"
 */
@property (nonatomic, strong)NSMutableArray<ZYCalendarRange *> *ranges;

@property (nonatomic, strong)NSDate *beginDate;

@property (nonatomic, strong)NSDate *endDate;

@property (nonatomic, assign)CGFloat leftPadding;

@property (nonatomic, assign)CGFloat rightPadding;

//padding of two line
 
@property (nonatomic, assign)CGFloat linePadding;

//  if you use ZYCalendarStyleVerticalPage style to init a calendar it will same for every month
@property (nonatomic, assign,readonly)CGFloat monthHeight;

@property (nonatomic, assign, readonly)CGFloat headerHeight;

//set corverInsets will make influence for corver height/radius
@property (nonatomic, assign)UIEdgeInsets corverInsets;


@property (nonatomic, assign)BOOL sundayFirst;

//if YES,when your select corver will become square rather then round
@property (nonatomic, assign)BOOL selectSquare;

//if YES,date from other month will be hidden
@property (nonatomic, assign)BOOL hideOtherDay;

//if NO ,in the ZYCalendarDelegate you will not receive calling for the date from other month
@property (nonatomic, assign)BOOL userInteractionEnabledForOtherDays;

//if YES,all month lines will become 6,and the height will equal,I suggest to use it when you want pageEnabled
@property (nonatomic, assign)BOOL staticMonthHeight;

//when user select date will display this color for selected date
@property (nonatomic, copy)UIColor *selectedColor;


@property (nonatomic, copy)UIColor *dotColor;

@property (nonatomic, copy)UIColor *highlightDateCellColor;

//date label textColor
@property (nonatomic, copy)UIColor *dateColor;

//selected date label textColor
@property (nonatomic, copy)UIColor *selectDateColor;

//the line height for corver,if lineHeight > the height of dateCell,corver will become square
@property (nonatomic, assign)CGFloat lineHeight;

@property (nonatomic, assign)ZYCalendarRangeDrawMode selectedDrawMode;

@property (nonatomic, assign)CGFloat dotRadius;

@property (nonatomic, copy,) UIVisualEffect *separatorEffect;

@property (nonatomic, copy,) UIColor *separatorColor;

@property (nonatomic) UIEdgeInsets separatorInset;

@property (nonatomic) ZYCalendarSeparatorStyle separatorStyle;

@property (nonatomic, weak)id<ZYCalendarDelegate> delegate;

@property (nonatomic, weak)id<ZYCalendarDataSource> dataSource;

// set default for range
@property (nonatomic, weak)ZYCalendarRange *selectedRange;



- (instancetype)initWithFrame:(CGRect)frame style:(ZYCalendarStyle)style ;

- (void)reload;

- (void)scrollToYear:(NSInteger )year month:(NSInteger)month;





@end
