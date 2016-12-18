//
//  ZYCalendarCorver.m
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ZYCalendarCorver.h"

@interface ZYCalendarCorver ()

@property (nonatomic, strong, readwrite)UIBezierPath *corverPath;



@end


@implementation ZYCalendarCorver


- (void)drawRect:(CGRect)rect {
    
    
    [super drawRect:rect];
    [self drawSelectedCover:rect];
}


- (void)drawSelectedCover:(CGRect)rect
{
    if (self.corverType == ZYCalendarCorverTypeNone) {
  
        return;
    }
    
  
    CGFloat height = rect.size.height;
    CGFloat width = rect.size.width;
    
    //corverInsets.top must equal to corverInstes.bottom;
    CGFloat radius;
    if (self.corverHeight <= 1) {
        radius =  MIN(height/2 - self.corverInsets.top - self.corverInsets.bottom, height/2 - self.corverInsets.left - self.corverInsets.right);
        
    }
    else {
        radius =  MIN(self.corverHeight/2 - self.corverInsets.top - self.corverInsets.bottom, self.corverHeight/2 - self.corverInsets.left - self.corverInsets.right);
    }
    
    
    CGFloat leftPadding = width/2 - radius;
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat midX = CGRectGetMidX(rect);
    self.corverPath = [UIBezierPath bezierPath];
    UIBezierPath *path = self.corverPath;
    
    CGFloat top = (height - radius *2)/2;
    CGFloat bottom = top + 2 * radius;
    if (!self.square) {
        if (self.corverType == ZYCalendarCorverTypeBegin) {
            
            [path moveToPoint:CGPointMake(midX + self.corverInsets.left, top)];
            [path addArcWithCenter:CGPointMake(midX, midY) radius:radius startAngle: - M_PI / 2 endAngle: M_PI / 2 clockwise:NO];
            [path addLineToPoint:CGPointMake(width, bottom)];
            [path addLineToPoint:CGPointMake(width, top)];
            [path closePath];
            
        }
        else if (self.corverType == ZYCalendarCorverTypeEnd) {
            
            [path moveToPoint:CGPointMake(0, top)];
            [path addArcWithCenter:CGPointMake(midX, midY) radius:radius startAngle: - M_PI / 2 endAngle: M_PI / 2 clockwise:YES];
            [path addLineToPoint:CGPointMake(0, bottom)];
            [path closePath];
            
        }
        else if (self.corverType == ZYCalendarCorverTypeMiddle){
            
            [path moveToPoint:CGPointMake(0, top)];
            [path addLineToPoint:CGPointMake(width, top)];
            [path addLineToPoint:CGPointMake(width, bottom)];
            [path addLineToPoint:CGPointMake(0, bottom)];
            [path closePath];
            
            
        }
        else if (self.corverType == ZYCalendarCorverTypeRound) {
            
            path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(leftPadding, top, 2 * radius, 2 * radius)];
            [path closePath];
        }
        

        
    }
    else{
        
        path = [UIBezierPath bezierPathWithRect:CGRectMake(0, (height - bottom + top)/2, width, bottom - top)];
    }
    
    [self.color setFill];
    [path fill];
}

@end
