//
//  ZYCanendar.m
//  LZCalendar
//
//  Email:lztuna04@gmail.com or 278759888@qq.com
//  welcome to issue me or whatever you want,I will help you.
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ZYCalendar.h"
#import "ZYCalendarCell.h"
#import "ZYCalendarRange.h"
#import "NSDate+ZYDateTools.h"
#import "ZYCalendarTableViewCell.h"
#import "ZYCalendarTableViewCellModel.h"
#import "ZYCalendarCellModel.h"

#define  ZYCalendar_TableViewCellID @"ZYCalendar_TableViewCellID"
#define ZYCalendar_CollectionViewCellID @"ZYCalendar_CollectionViewCellID"

@interface ZYCalendar ()<UITableViewDataSource,UITableViewDelegate,ZYCalendarTableViewCellDelegate,ZYCalendarTableViewCellCache,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong)UITableView *tableView;

@property (nonatomic, strong)NSMutableDictionary *modelsCache;

@property (nonatomic, assign)BOOL pagingEnabled;

@property (nonatomic, assign)ZYCalendarStyle calendarStyle;


@property (nonatomic, weak)ZYCalendarRange *selectedRange;

@end



@implementation ZYCalendar {
    
    @private
    NSMutableArray *_ranges;

    
}


@dynamic ranges;


- (instancetype)initWithFrame:(CGRect)frame style:(ZYCalendarStyle)style {
    
    self = [super initWithFrame:frame];
    
    self.calendarStyle = style;
    self.modelsCache = [NSMutableDictionary dictionary];
    self.hideOtherDay = YES;
    self.userInteractionEnabledForOtherDays = NO;
    self.sundayFirst = YES;
    self.dotRadius = 3;
    self.corverInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    self.highlightDateCellColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    self.dateColor = [UIColor whiteColor];
    self.selectDateColor = [UIColor colorWithRed:199/255.0 green:63/255.0 blue:96/255.0 alpha:1];
    self.selectedColor = [UIColor whiteColor];
    self.dotColor = [UIColor colorWithRed:199/255.0 green:63/255.0 blue:96/255.0 alpha:1];
    
    self.pagingEnabled = style == ZYCalendarStyleVerticalPage;
    if (self.pagingEnabled) {
        
        self.staticMonthHeight = YES;
    }
    UITableViewStyle tableViewStyle = style == ZYCalendarStyleVerticalPage?UITableViewStylePlain:(UITableViewStyle)style;
    [self setUpTableViewWithStyle:tableViewStyle];
    return self;
}

- (CGFloat)monthHeight {
    if (!self.staticMonthHeight) {
        NSLog(@"Do not read monthHeight when style wasn't ZYCalendarStyleVerticalPage");
    }
    return [self tableView:self.tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)setUpTableViewWithStyle:(UITableViewStyle)style {
    
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:style];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorEffect = self.separatorEffect;
    self.tableView.separatorColor = self.separatorColor;
    self.tableView.separatorInset = self.separatorInset;
    self.tableView.separatorStyle = (UITableViewCellSeparatorStyle)self.separatorStyle;
    self.tableView.pagingEnabled = self.pagingEnabled;
    self.tableView.allowsSelection = NO;
    if (self.calendarStyle == ZYCalendarStyleVerticalPage) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [self monthHeight] + [self headerHeight]);
        self.tableView.frame = self.bounds;
        
    }
    
    [self addSubview:self.tableView];
    
}


- (void)customConfigForDateCell:(ZYCalendarCell *)cell {
    
    if ([self.delegate respondsToSelector:@selector(ZYCalendar:customConfigDateCell:)]) {
        
        [self.delegate ZYCalendar:self customConfigDateCell:cell];
    }
    
}

- (void)scrollToYear:(NSInteger)year month:(NSInteger)month {
    
    NSDate *targetDate = [NSDate lzy_dateWithYear:year month:month day:1];
    NSInteger section = [self.beginDate lzy_monthsEarlierThan:targetDate];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)reload {

       [self.tableView reloadData];
}

- (ZYCalendarRange *)rangeWithDate:(NSDate *)date {
    
    ZYCalendarRange *temp = nil;
    for (ZYCalendarRange *range in self.ranges) {
        if ([range isContainsDate:date]) {
            temp = range;
        }
    }
    
    return temp;
}

- (NSMutableArray<ZYCalendarRange *> *)ranges {
    
    if (_ranges == nil) {
        _ranges = [NSMutableArray array];
    }
    
    return _ranges;
}

- (void)setStaticMonthHeight:(BOOL)staticMonthHeight {
    _staticMonthHeight = staticMonthHeight;
    [self.modelsCache removeAllObjects];
    [self.ranges removeAllObjects];
    [self.tableView reloadData];
}

- (CGFloat)headerHeight {
    
   return  [self tableView:self.tableView heightForHeaderInSection:0];
}

- (void)setSelectedRange:(ZYCalendarRange *)selectedRange {
    _selectedRange = selectedRange;
    if (selectedRange != nil && ![self.ranges containsObject:_selectedRange]) {
        [self.ranges addObject:_selectedRange];
    }
 
}

- (void)setSelectedDrawMode:(ZYCalendarRangeDrawMode)selectedDrawMode {
    _selectedDrawMode = selectedDrawMode;
    [self.modelsCache removeAllObjects];
    [self.ranges removeAllObjects];
    [self.tableView reloadData];
}

- (void)setSundayFirst:(BOOL)sundayFirst {
    _sundayFirst = sundayFirst;
    [self.modelsCache removeAllObjects];
    [self.ranges removeAllObjects];
    [self.tableView reloadData];
}

- (void)setSelectSquare:(BOOL)selectSquare {
    _selectSquare = selectSquare;
    [self.modelsCache removeAllObjects];
    [self.ranges removeAllObjects];
    [self.tableView reloadData];
}

- (void)setHideOtherDay:(BOOL)hideOtherDay {
    _hideOtherDay = hideOtherDay;
    [self.modelsCache removeAllObjects];
    [self.tableView reloadData];
}


- (void)ZYCalendarTableViewCell:(ZYCalendarTableViewCell *)cell didSelectDateCell:(ZYCalendarCell *)dateCell {
    
   
    if ([self.delegate respondsToSelector:@selector(ZYCalendar:didSelectCell:)]) {
        
        [self.delegate ZYCalendar:self didSelectCell:dateCell];
        return;
    }
    
    if (dateCell.modelItem.range.disabled) {
        
        return;
    }
    
    NSDate *date = dateCell.date;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    BOOL hasSelectedBeginDate;
    BOOL hasSelectedEndDate;
    
    if (self.selectedRange) {
        beginDate = self.selectedRange.beginDate;
        endDate = self.selectedRange.endDate;
        hasSelectedBeginDate = !(beginDate == nil);
        hasSelectedEndDate = ![beginDate lzy_isSameDay:endDate];
    }
    else {
        hasSelectedBeginDate = NO;
        hasSelectedEndDate = NO;
    }
    
    if ([date lzy_isSameDay:beginDate] && [date lzy_isSameDay:endDate]) {
        
        return;
    }
    
    [self.ranges removeObject:self.selectedRange];
   
    ZYCalendarRange *newRange = nil;
    
    //如果已经选择了开始日期,结束日期
    if (hasSelectedEndDate && hasSelectedBeginDate) {
        NSInteger daysOffset_begin = [beginDate lzy_daysOffsetWithDate:date];
        NSInteger daysOffset_end = [endDate lzy_daysOffsetWithDate:date];
        //如果选择日期早于现有开始日期，我们认为用户想重新选中
        if (daysOffset_begin > 0 || (daysOffset_begin <=0 && daysOffset_end >= 0)) {
            
            
            newRange = [ZYCalendarRange rangeWithBeginDate:date endDate:date color:self.selectedColor];
          
            
           
        //延长时间
        }else if (daysOffset_end <0) {
            newRange = [ZYCalendarRange rangeWithBeginDate:self.selectedRange.beginDate endDate:date color:self.selectedColor];
            
           
            
        }
        //只选择了开始日期
    }else if (hasSelectedBeginDate && !hasSelectedEndDate) {
    
     NSInteger daysOffset_begin = [beginDate lzy_daysOffsetWithDate:date];
        
        
        
        //如果选中日期晚于开始时间,我们认为用户在选择结束时间
        if (daysOffset_begin < 0) {
            newRange = [ZYCalendarRange rangeWithBeginDate:self.selectedRange.beginDate endDate:date color:self.selectedColor];
            
        //如果选中日期早于开始时间,我们认为用户想提前开始时间
        } else if (daysOffset_begin >= 0) {
           
           newRange = [ZYCalendarRange rangeWithBeginDate:date endDate:date color:self.selectedColor];
            
            
        }
        
        
        //两个都没有选择
    }else if (!hasSelectedBeginDate && !hasSelectedEndDate) {
        
        newRange = [ZYCalendarRange rangeWithBeginDate:date endDate:date color:self.selectedColor];
    
        
        
        }
   
    
   __block BOOL isOverlappingWithSelectedRanges = NO;
    [self.ranges enumerateObjectsUsingBlock:^(ZYCalendarRange * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isOverlappingWithRange:newRange] && obj.isDisabled == YES) {
            
            isOverlappingWithSelectedRanges = YES;
            *stop = YES;
        }
        
    }];

    if (isOverlappingWithSelectedRanges == YES) {
        
        return;
    }
    
    newRange.drawMode = self.selectedDrawMode;
    newRange.dateColor = self.selectDateColor;
    newRange.dotColor = self.dotColor;
    
    
    self.selectedRange = newRange;
    
    [self reload];
    
}




- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSString *identifier = [NSString stringWithFormat:@"%d0",(int)section];
    ZYCalendarTableViewCellModel *model = self.modelsCache[identifier];
    if ([self.dataSource respondsToSelector:@selector(ZYCalendar:heightForHeaderWithYear:month:)]) {
        
        return  [self.dataSource ZYCalendar:self heightForHeaderWithYear:model.currentYear month:model.currentMonth];
    }

    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *identifier = [NSString stringWithFormat:@"%d0",(int)section];
    ZYCalendarTableViewCellModel *model = self.modelsCache[identifier];
    if ([self.dataSource respondsToSelector:@selector(ZYCalendar:headerTitleForYear:month:)]) {
        
      return  [self.dataSource ZYCalendar:self headerTitleForYear:model.currentYear month:model.currentMonth];
    }

    return [NSString stringWithFormat:@"%d-%d",(int)model.currentYear,(int)model.currentMonth];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = [NSString stringWithFormat:@"%d0",(int)section];
    ZYCalendarTableViewCellModel *model = self.modelsCache[identifier];
    if ([self.dataSource respondsToSelector:@selector(ZYCalendar:headerViewForYear:month:)]) {
        
        return  [self.dataSource ZYCalendar:self headerViewForYear:model.currentYear month:model.currentMonth];
    }
    
    UILabel *label = [[UILabel alloc]init];
    label.text = [NSString stringWithFormat:@"  %d-%d",(int)model.currentYear,(int)model.currentMonth];
    label.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:30];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:24/255.0 green:49/255.0 blue:85/255.0 alpha:1];
    return label;
    
}


- (void)setBeginDate:(NSDate *)beginDate {
    
    _beginDate = [NSDate lzy_dateStandardFormatTimeZeroWithDate:[NSDate lzy_dateWithYear:beginDate.lzy_year month:beginDate.lzy_month day:1]];;
    [self reload];
    
}

- (void)setEndDate:(NSDate *)endDate {
    
    _endDate = [NSDate lzy_dateStandardFormatTimeZeroWithDate:[[NSDate lzy_dateWithYear:endDate.lzy_year month:endDate.lzy_month day:1] lzy_dateByAddingDays:[endDate lzy_daysCount]]];
    [self reload];
    
}


- (void)setRanges:(NSMutableArray<ZYCalendarRange *> *)ranges {
    _ranges = ranges;
    
    [self reload];
    
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    [self.modelsCache removeAllObjects];
    [self reload];
}

- (void)setCorverInsets:(UIEdgeInsets)corverInsets {
    _corverInsets = corverInsets;
    [self.modelsCache removeAllObjects];
    [self reload];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return [self.beginDate lzy_monthsEarlierThan:self.endDate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 1;
    
    
}


- (ZYCalendarCellModel *)ZYCalendarTableViewCell:(ZYCalendarTableViewCell *)cell cacheForCell:(ZYCalendarCell *)dateCell dateCellIndexPath:(NSIndexPath *)indexPath {
    
    
    NSString *identifier = [NSString stringWithFormat:@"%@%d",cell.beginDate,(int)indexPath.item];
    if (self.modelsCache[identifier] == nil) {
        
        ZYCalendarCellModel *model = [ZYCalendarCellModel modelWithDaysOffset:cell.modelItem.daysOffset
                                                                    beginDate:cell.modelItem.beginDate
                                                                      endDate:cell.modelItem.endDate
                                                                    indexPath:indexPath
                                                                   lineHeight:self.lineHeight
                                                                        range:nil
                                                                 corverInsets:cell.modelItem.corverInsets];
        dateCell.hideNonePositionDay = cell.hideNonePositionDay;
        self.modelsCache[identifier] = model;
    }
    
    return self.modelsCache[identifier];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%d%d",(int)indexPath.section,(int)indexPath.row];
    ZYCalendarTableViewCellModel *model = self.modelsCache[identifier];
    ZYCalendarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ZYCalendar_TableViewCellID stringByAppendingString:[NSString stringWithFormat:@"%d",(int)model.cellHeight]]];
    
    if (cell == nil) {
        NSString *identifier = [ZYCalendar_TableViewCellID stringByAppendingString:[NSString stringWithFormat:@"%d",(int)model.cellHeight]];
        cell = [ZYCalendarTableViewCell tableViewCellWithIdentifier:identifier
                                                          cellWidth:model.cellWidth
                                                         cellHeight:model.cellHeight
                                                        leftPadding:model.leftPadding
                                                       rightPadding:model.rightPadding
                                                        linePadding:self.linePadding];
  
         cell.delegate = self;
         cell.cacher = self;
    }
   
   
    cell.square = self.selectSquare;
    cell.dotColor = self.dotColor;
    cell.highlightDateCellColor = self.highlightDateCellColor;
    cell.dotRadius = self.dotRadius;
    cell.todayTitle = self.todayTitle;
    cell.userInteractionEnabledForOtherDays = self.userInteractionEnabledForOtherDays;
    cell.hideNonePositionDay = self.hideOtherDay;
    cell.dateColor = self.dateColor;
    
    model.ranges = [self rangesWithBaginDate:model.beginDate endDate:model.endDate];
//
    cell.modelItem = model;
   
    
    return cell;
}


- (NSMutableArray <ZYCalendarRange *>*)rangesWithBaginDate:(NSDate *)beginDate endDate:(NSDate *)endDate {
    
    __block NSMutableArray *arrayM = [NSMutableArray array];
    ZYCalendarRange *tempRange = [ZYCalendarRange rangeWithBeginDate:beginDate endDate:endDate color:nil];
    [self.ranges enumerateObjectsUsingBlock:^(ZYCalendarRange * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([obj isOverlappingWithRange:tempRange]) {
            
            [arrayM addObject:obj];
        }
        
    }];
    
    return arrayM;
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = [NSString stringWithFormat:@"%d%d",(int)indexPath.section,(int)indexPath.row];
    if (!self.modelsCache[identifier]) {
      
        NSDate *beginDate = [[NSDate lzy_dateWithYear:self.beginDate.lzy_year month:self.beginDate.lzy_month day:1] lzy_dateByAddingMonths:indexPath.section];
        NSDate *endDate = [beginDate lzy_dateByAddingDays:[beginDate lzy_daysCount] - 1];

        ZYCalendarTableViewCellModel *model = [ZYCalendarTableViewCellModel modelWithBeginDate:beginDate
                                                                                       endDate:endDate
                                                                                     cellWidth:self.bounds.size.width
                                                                                   leftPadding:self.leftPadding
                                                                                  rightPadding:self.rightPadding
                                                                                   linePadding:self.linePadding
                                                                                    lineHeight:self.lineHeight
                                                                                   sundayFirst:self.sundayFirst
                                                                                  corverInsets:self.corverInsets];
        model.staticMonthHeight = self.staticMonthHeight;
        self.modelsCache[identifier] = model;
    }
    
    return [self.modelsCache[identifier] cellHeight];
    
}




@end
