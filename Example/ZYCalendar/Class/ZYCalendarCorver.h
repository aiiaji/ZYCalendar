//
//  ZYCalendarCorver.h
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ZYCalendarCorverType) {
    ZYCalendarCorverTypeNone = 0,
    ZYCalendarCorverTypeBegin,
    ZYCalendarCorverTypeMiddle,
    ZYCalendarCorverTypeEnd,
    ZYCalendarCorverTypeRound,
    

    
};



@interface ZYCalendarCorver : UIView

@property (nonatomic, strong,readonly)UIBezierPath *corverPath;

@property (nonatomic, assign)ZYCalendarCorverType corverType;

@property (nonatomic, assign)CGFloat corverHeight;

@property (nonatomic, assign)UIEdgeInsets corverInsets;

@property (nonatomic, strong)UIColor *color;

@property (nonatomic, assign)BOOL square;



@end
