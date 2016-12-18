//
//  ZYCalendarTableViewCellModel.m
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/30.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ZYCalendarTableViewCellModel.h"
#import "NSDate+ZYDateTools.h"
@interface ZYCalendarTableViewCellModel ()

@property (nonatomic, copy, readwrite)NSDate *beginDate;

@property (nonatomic, copy, readwrite)NSDate *endDate;

@property (nonatomic, assign, readwrite)NSUInteger daysOffset;

@property (nonatomic, assign, readwrite)CGFloat cellHeight;

@property (nonatomic, assign, readwrite)CGFloat cellWidth;

@property (nonatomic, assign, readwrite)CGFloat leftPadding;

@property (nonatomic, assign, readwrite)CGFloat rightPadding;

@property (nonatomic, assign, readwrite)CGFloat linePadding;

@property (nonatomic, assign, readwrite)BOOL sundayFirst;

@property (nonatomic, assign, readwrite)NSInteger linesCount;

@property (nonatomic, assign, readwrite)CGFloat lineHeight;

@property (nonatomic, assign, readwrite)UIEdgeInsets corverInsets;

@end


@implementation ZYCalendarTableViewCellModel



+ (instancetype)modelWithBeginDate:(NSDate *)beginDate
                           endDate:(NSDate *)endDate
                         cellWidth:(CGFloat)cellWidth
                       leftPadding:(CGFloat)leftPadding
                      rightPadding:(CGFloat)rightPadding
                       linePadding:(CGFloat)linePadding
                        lineHeight:(CGFloat )lineHeight
                       sundayFirst:(BOOL)sundayFirst
                      corverInsets:(UIEdgeInsets )corverInsets {
    
    ZYCalendarTableViewCellModel *model = [[ZYCalendarTableViewCellModel alloc]init];
    model.beginDate = beginDate;
    model.endDate = endDate;
    model.leftPadding = leftPadding;
    model.rightPadding = rightPadding;
    model.sundayFirst = sundayFirst;
    model.daysOffset = -9999;
    model.cellWidth = cellWidth;
    model.sundayFirst = sundayFirst;
    model.cellHeight = MAXFLOAT;
    model.linePadding = linePadding;
    model.lineHeight = lineHeight;
    model.corverInsets = corverInsets;
    return model;
    
    
}

- (NSUInteger)currentYear {
    
    return self.beginDate.lzy_year;
}

- (NSUInteger)currentMonth {
    
    return self.beginDate.lzy_month;
}


- (CGFloat)cellHeight {
    
    if (_cellHeight == MAXFLOAT) {
        
        
        //cell必须是正方形
        _cellHeight = (NSInteger)(self.linesCount * (self.cellWidth - _leftPadding - _rightPadding)/7  + (self.linesCount + 1) * self.linePadding) + 0.5;
        
    }
    
    return _cellHeight;
    
}


- (NSUInteger )daysOffset {
    
    if (_daysOffset == -9999) {
        
        NSUInteger daysOffset = [self.beginDate lzy_weekday];
        if (!self.sundayFirst) {
            
            if (daysOffset == 1) {
                
                daysOffset = 6;
            }
            else {
                
                daysOffset -= 2;
            }
            
        }else{
            
            if (daysOffset != 0) {
                
                daysOffset--;
            }
           
        }
        
        
        _daysOffset = daysOffset;
        
        
    }
    
    
    return _daysOffset;
    
}


- (NSInteger)linesCount {
    
    if (self.staticMonthHeight) {
        
        return 6;
    }
    if (_linesCount == 0) {
        
        NSInteger daysCount = [self.beginDate lzy_daysCount];
        NSInteger daysOffset = self.daysOffset;
        NSInteger linesCount = 0;
        
        if (daysCount == 28 && daysOffset == 0) {
            
            linesCount = 4;
        }
        else if (daysCount + daysOffset <= 35) {
            
            linesCount = 5;
        }
        else {
            
            linesCount = 6;
        }
        
        _linesCount = linesCount;
        
        
    }
    
    
    return _linesCount;
    
}


@end
