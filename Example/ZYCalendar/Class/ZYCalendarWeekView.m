//
//  ZYCalendarWeekView.m
//  LZCalendar
//
//  Created by 李耔余 on 2016/12/18.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ZYCalendarWeekView.h"

@implementation ZYCalendarWeekView

+ (instancetype)ZYCalendarWeekViewWithFrame:(CGRect )frame
                                 weekArray:(NSArray<NSString *> *)titles {
    
    ZYCalendarWeekView *view = [[ZYCalendarWeekView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
    
   [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       UILabel *label = [UILabel new];
       label.text = obj;
       label.textColor = [UIColor whiteColor];
       label.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16];
       [label sizeToFit];
       CGSize size = label.frame.size;
       CGFloat padding = (frame.size.width - titles.count * size.width)/(titles.count - 1);
       label.frame = CGRectMake(idx * (size.width + padding), (frame.size.height - size.height)/2, size.width, size.height);
       [view addSubview:label];

   }];
    
    return view;
}

@end
