//
//  ZYCalendarCell.m
//  LZCalendar
//
//  Created by 李耔余 on 2016/11/29.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ZYCalendarCell.h"
#import "NSDate+ZYDateTools.h"
#import "ZYCalendarCorver.h"
#import "ZYCalendarCellModel.h"

@interface ZYCalendarCell ()


@property (strong, nonatomic) ZYCalendarCorver *corver;
@property (nonatomic, strong,readwrite)NSDate *date;
@property (nonatomic, assign)ZYCalendarCellPosition position;

@property (nonatomic, assign)CGFloat radius;

@end


@implementation ZYCalendarCell



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    
    {
        _corver = [ZYCalendarCorver new];
        _corver.backgroundColor = [UIColor clearColor];
        [self addSubview:self.corver];

    }
    
    {
        _dateLabel = [UILabel new];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.backgroundColor = [UIColor clearColor];
        _dateLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:16];
        _dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.dateLabel];
        
    }
    
    {
        _dotView = [UIView new];
        _dotView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        _dotView.layer.shouldRasterize = YES;
        _dotView.hidden = YES;
         [self addSubview:self.dotView];
    }
    
    {
        _highlightView = [UIView new];
        _highlightView.hidden = YES;
        [self addSubview:self.highlightView];
    }
    
    {
        self.dateColor = [UIColor whiteColor];
    
    }
    _radius = -9999;
    
    return self;
}

- (CGFloat)radius {
    if (_radius == -9999) {
           CGFloat height = self.frame.size.height;
        if (self.modelItem.lineHeight <= 1) {
            _radius =  MIN(height/2 - self.modelItem.corverInsets.top - self.modelItem.corverInsets.bottom, height/2 - self.modelItem.corverInsets.left - self.modelItem.corverInsets.right);
            
        }
        else {
            _radius =  MIN(self.modelItem.lineHeight/2 - self.modelItem.corverInsets.top - self.modelItem.corverInsets.bottom, self.modelItem.lineHeight/2 - self.modelItem.corverInsets.left - self.modelItem.corverInsets.right);
        }
    }
    
    return _radius;
}


- (void)layoutSubviews {
    
    CGRect bounds = self.bounds;
    
    _dateLabel.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    
    _corver.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    
    _highlightView.frame = CGRectMake((bounds.size.width - self.radius*2)/2, (bounds.size.height - self.radius*2)/2, self.radius*2, self.radius*2);
    _highlightView.layer.cornerRadius = self.square?0:self.radius;
    
    _dotView.frame = CGRectMake((bounds.size.width - self.dotRadius)/2,bounds.size.height*3/4 - self.dotRadius/2, self.dotRadius * 2, self.dotRadius * 2);
    _dotView.layer.cornerRadius = self.dotRadius;
    
}

- (void)setHightlightColor:(UIColor *)hightlightColor {
    _hightlightColor = hightlightColor;
    self.highlightView.backgroundColor = hightlightColor;
    
}

- (void)setDotColor:(UIColor *)dotColor {
    _dotColor = dotColor;
     self.dotView.backgroundColor = dotColor;
}

- (void)setHighlighted:(BOOL)highlighted {
    
    self.highlightView.hidden = !highlighted;
}


- (BOOL)isFromOtherMonth {
    
    return (self.position == ZYCalendarCellPositionNoneBefore || self.position == ZYCalendarCellPositionNoneLater);
    
}

- (void)updateWithModelItem:(ZYCalendarCellModel *) model {
    
    _modelItem = model;
    NSDate *date = model.cellDate;
    ZYCalendarCellPosition position = model.position;
    ZYCalendarRange *range = model.range;
    
    self.date = date;
    self.position = position;
    
    self.dateLabel.hidden = self.hideNonePositionDay && (model.position == ZYCalendarCellPositionNoneBefore || model.position == ZYCalendarCellPositionNoneLater);
    self.dateLabel.text = [NSString stringWithFormat:@"%d",(int)date.lzy_day];
    if ([date lzy_isSameDay:[NSDate date]] && !(model.position == ZYCalendarCellPositionNoneBefore || model.position == ZYCalendarCellPositionNoneLater) && self.todayTitle) {
        
        self.dateLabel.text = self.todayTitle;
    }
   
    self.dotView.hidden = model.position == ZYCalendarCellPositionNoneBefore || model.position == ZYCalendarCellPositionNoneLater || !range;
    if (range) {
        self.dateLabel.textColor = range.dateColor;
    }
    else {
        self.dateLabel.textColor = self.dateColor;
    }
    
    if (model.position == ZYCalendarCellPositionNoneBefore || model.position == ZYCalendarCellPositionNoneLater) {
        
        self.userInteractionEnabled = self.userInteractionEnabledForOtherDays;
    }
    else {
        self.userInteractionEnabled = YES;
    }


    self.corver.corverHeight = model.lineHeight;
    self.corver.corverInsets = model.corverInsets;
    
    if (!range) {
        self.corver.corverType = ZYCalendarCorverTypeNone;
        self.corver.color = [UIColor whiteColor];
        [self.corver setNeedsDisplay];
        if ([self.delegate respondsToSelector:@selector(customConfigForDateCell:)]) {
            
            [self.delegate customConfigForDateCell:self];
        }
        return;
    }
    NSDate *begindate = range.beginDate;
    NSDate *endDate = range.endDate;
    BOOL isSameToBeginDate = [date lzy_isSameDay:begindate];
    BOOL isSameToEndDate   =  [date lzy_isSameDay:endDate];
    BOOL isLeftPosition = position == ZYCalendarCellPositionLeft;
    BOOL isRightPosition = position == ZYCalendarCellPositionRight;
    BOOL isMiddlePotion = position == ZYCalendarCellPositionMiddle;
    BOOL isNonePosition = position == ZYCalendarCellPositionNoneBefore || position == ZYCalendarCellPositionNoneLater;
    UIColor *rangeColor = range.rangeColor;
    ZYCalendarRangeDrawMode drawMode = range.drawMode;
    self.corver.color = rangeColor;
    self.corver.square = self.square;
    if (isNonePosition && drawMode != ZYCalendarRangeDrawModeAirbnb) {
        self.corver.corverType = ZYCalendarCorverTypeNone;
        [self.corver setNeedsDisplay];
        if ([self.delegate respondsToSelector:@selector(customConfigForDateCell:)]) {
            
            [self.delegate customConfigForDateCell:self];
        }
        return;
    }
    else if (isNonePosition && drawMode == ZYCalendarRangeDrawModeAirbnb) {
        self.corver.corverType = ZYCalendarCellPositionMiddle;
        [self.corver setNeedsDisplay];
        if ([self.delegate respondsToSelector:@selector(customConfigForDateCell:)]) {
            
            [self.delegate customConfigForDateCell:self];
        }
        return;
    }
//
    if (isSameToEndDate && isSameToBeginDate) {
        
        self.corver.corverType = ZYCalendarCorverTypeRound;
     
    }
    else if (isSameToBeginDate) {
        if (drawMode == ZYCalendarRangeDrawModeSingleLine) {
            
            if ([date lzy_dateByAddingDays:1].lzy_month != model.currentMonth) {
                self.corver.corverType = ZYCalendarCorverTypeRound;
            }
            else {
                if (isRightPosition) {
                   self.corver.corverType = ZYCalendarCorverTypeRound;
                }
                else {
                    self.corver.corverType = ZYCalendarCorverTypeBegin;
                }
            }        }
        
        else if(drawMode == ZYCalendarRangeDrawModeOnlyCurrentMonth){
            if ([date lzy_dateByAddingDays:1].lzy_month != model.currentMonth) {
                self.corver.corverType = ZYCalendarCorverTypeRound;
            }
            else {
                self.corver.corverType = ZYCalendarCorverTypeBegin;
            }
        }
        else {
            self.corver.corverType = ZYCalendarCorverTypeBegin;
        }
       
    }
    else if (isSameToEndDate) {
        if (drawMode == ZYCalendarRangeDrawModeSingleLine) {
            if (isLeftPosition) {
                 self.corver.corverType = ZYCalendarCorverTypeRound;
            }
            else {
                if ([date lzy_dateBySubtractingDays:1].lzy_month != model.currentMonth) {
                    self.corver.corverType = ZYCalendarCorverTypeRound;
                }
                else {
                    self.corver.corverType = ZYCalendarCorverTypeEnd;
                }
                
            }
           
            
        }else if(drawMode == ZYCalendarRangeDrawModeOnlyCurrentMonth) {
            
            if ([date lzy_dateBySubtractingDays:1].lzy_month != model.currentMonth) {
                self.corver.corverType = ZYCalendarCorverTypeRound;
            }
            else {
                self.corver.corverType = ZYCalendarCorverTypeEnd;
            }
            
           
        }
        else {
            self.corver.corverType = ZYCalendarCorverTypeEnd;
        }
    }
    else {
        
        if (isMiddlePotion) {
            if (drawMode == ZYCalendarRangeDrawModeOnlyCurrentMonth || drawMode == ZYCalendarRangeDrawModeSingleLine) {
                if ([date lzy_dateByAddingDays:1].lzy_month != model.currentMonth) {
                    self.corver.corverType = ZYCalendarCorverTypeEnd;
                }
                else if([date lzy_dateBySubtractingDays:1].lzy_month != model.currentMonth){
                   self.corver.corverType = ZYCalendarCorverTypeBegin;
                }
                else {
                    self.corver.corverType = ZYCalendarCorverTypeMiddle;
                }
                
            }
            else {
            self.corver.corverType = ZYCalendarCellPositionMiddle;
            }
        }
        else if (drawMode == ZYCalendarRangeDrawModeAirbnb) {
            
            
            self.corver.corverType = ZYCalendarCorverTypeMiddle;
     

        }
        else if (drawMode == ZYCalendarRangeDrawModeSingleLine) {
            
            if (isLeftPosition) {
                if ([date lzy_dateByAddingDays:1].lzy_month != model.currentMonth) {
                    self.corver.corverType = ZYCalendarCorverTypeRound;
                }
                else {
                    self.corver.corverType = ZYCalendarCorverTypeBegin;
                }
                
            }
            else if (isRightPosition) {
                if ([date lzy_dateBySubtractingDays:1].lzy_month != model.currentMonth) {
                    self.corver.corverType = ZYCalendarCorverTypeRound;
                }
                else {
                    self.corver.corverType = ZYCalendarCorverTypeEnd;
                }
            }
            else {
                
                self.corver.corverType = ZYCalendarCorverTypeNone;
            }
            
        }else if (drawMode == ZYCalendarRangeDrawModeOnlyCurrentMonth) {
            if (isLeftPosition || isRightPosition) {
                if ([date lzy_dateBySubtractingDays:1].lzy_month != model.currentMonth) {
                    self.corver.corverType = ZYCalendarCorverTypeBegin;
                }
                else if([date lzy_dateByAddingDays:1].lzy_month != model.currentMonth){
                    self.corver.corverType = ZYCalendarCorverTypeEnd;
                }
                else {
                    self.corver.corverType = ZYCalendarCorverTypeMiddle;
                }
            }
            else {
                
                self.corver.corverType = ZYCalendarCorverTypeNone;
                
            }
            
            
        }
 
    }
        [self.corver setNeedsDisplay];
    if ([self.delegate respondsToSelector:@selector(customConfigForDateCell:)]) {
        
        [self.delegate customConfigForDateCell:self];
    }

 

}

@end
