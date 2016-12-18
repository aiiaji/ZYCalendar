//
//  ZYCalendarTableViewCellModel.h
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/30.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface ZYCalendarTableViewCellModel : NSObject

@property (nonatomic, copy, readonly)NSDate *beginDate;

@property (nonatomic, copy, readonly)NSDate *endDate;

@property (nonatomic, assign, readonly)NSUInteger daysOffset;

@property (nonatomic, assign, readonly)CGFloat cellHeight;

@property (nonatomic, assign, readonly)CGFloat cellWidth;

@property (nonatomic, assign, readonly)CGFloat leftPadding;

@property (nonatomic, assign, readonly)CGFloat rightPadding;

@property (nonatomic, assign, readonly)CGFloat linePadding;

@property (nonatomic, assign, readonly)BOOL sundayFirst;

@property (nonatomic, assign, readonly)NSInteger linesCount;

@property (nonatomic, assign, readonly)NSUInteger currentYear;

@property (nonatomic, assign, readonly)NSUInteger currentMonth;

@property (nonatomic, assign, readonly)CGFloat lineHeight;

@property (nonatomic, assign, readonly)UIEdgeInsets corverInsets;

@property (nonatomic, strong)NSMutableArray *ranges;

@property (nonatomic, assign)BOOL staticMonthHeight;

+ (instancetype)modelWithBeginDate:(NSDate *)beginDate
                           endDate:(NSDate *)endDate
                         cellWidth:(CGFloat )cellWidth
                       leftPadding:(CGFloat )leftPadding
                      rightPadding:(CGFloat )rightPadding
                       linePadding:(CGFloat )linePadding
                         lineHeight:(CGFloat )lineHeight
                       sundayFirst:(BOOL)sundayFirst
                      corverInsets:(UIEdgeInsets )corverInsets;


@end
