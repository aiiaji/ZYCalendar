# ZYCalendar
A highly customizable calendar view for iOS/一个iOS端高度可定制化的日历视图

![](http://i1.piimg.com/567571/6f6e5d9c8dd5a259.gif)

Features
==============
- __Highly customizable__
- __Has three effect__
- __Use like tableView__
- __Provide NSDate tool__


Usage
=======
### Basic
```Objc
//#import "ZYCalendar.h"
_calendar = [[ZYCalendar alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.58) style:ZYCalendarStyleVerticalGroup];

_calendar.leftPadding = 10;
_calendar.rightPadding = 10;
_calendar.linePadding = 10;
// more property.......
_calendar.backgroundColor = [UIColor colorWithRed:24/255.0 green:49/255.0 blue:85/255.0 alpha:1];

//set beginDate and endDate
_calendar.beginDate = [NSDate date];
_calendar.endDate = [[NSDate date] lzy_dateByAddingMonths:40];

_calendar.sundayFirst = YES;
// three draw mode
_calendar.selectedDrawMode = ZYCalendarRangeDrawModeSingleLine;

_calendar.separatorStyle = ZYCalendarSeparatorStyleSingleLineEtched;
_calendar.todayTitle = @"Today";

// create a range of calendar  
ZYCalendarRange *range = [ZYCalendarRange rangeWithBeginDate:[NSDate date] endDate:[NSDate date] color:[UIColor whiteColor]];
//set disabled to protect the range
range.disabled = YES;
range.drawMode = ZYCalendarRangeDrawModeSingleLine;
range.dateColor = [UIColor redColor];
range.dotColor = [UIColor clearColor];
_calendar.ranges = [NSMutableArray arrayWithArray:@[range]];

[self.view addSubview:_calendar];



```


### Custom

``` objc

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



```


Requirements
==============
This library requires `iOS 8.0+` and `Xcode 7.0+`.


License
==============
ZYCalendar is released under the MIT license. See LICENSE file for details.
