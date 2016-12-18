//
//  ViewController.m
//  ZYCalendar
//
//  Created by 李耔余 on 2016/12/18.
//  Copyright © 2016年 liziyu. All rights reserved.
//

#import "ViewController.h"
#import "ZYCalendar.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *singleLine;
@property (weak, nonatomic) IBOutlet UISwitch *airbnb;
@property (weak, nonatomic) IBOutlet UISwitch *onlyCurrentMonth;
@property (nonatomic, strong)ZYCalendar *calendar;
@property (nonatomic, strong)ZYCalendarWeekView *weekView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //base usage 
    self.view.backgroundColor = [UIColor colorWithRed:24/255.0 green:49/255.0 blue:85/255.0 alpha:1];
    _calendar = [[ZYCalendar alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 0.5) style:ZYCalendarStyleVerticalGroup];
    
    _calendar.leftPadding = 0;
    _calendar.rightPadding = 0;
    _calendar.backgroundColor = [UIColor colorWithRed:24/255.0 green:49/255.0 blue:85/255.0 alpha:1];
    _calendar.lineHeight = 60;
    _calendar.beginDate = [[NSDate date]lzy_dateByAddingMonths:0];
    _calendar.endDate = [[NSDate date] lzy_dateByAddingMonths:40];
    
    _calendar.sundayFirst = YES;
    _calendar.selectedDrawMode = ZYCalendarRangeDrawModeSingleLine;
    
    _calendar.separatorStyle = ZYCalendarSeparatorStyleSingleLine;

    _calendar.todayTitle = @"Today";
    
    [self.view addSubview:_calendar];
    
    
    
    
    
    _weekView = [ZYCalendarWeekView ZYCalendarWeekViewWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 44)  weekArray:@[@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT"]];
    _weekView.backgroundColor = [UIColor colorWithRed:24/255.0 green:49/255.0 blue:85/255.0 alpha:1];
    [self.view addSubview:_weekView];
    
    
    
}
- (IBAction)staticMonthHeight:(UISwitch *)sender {
    
    _calendar.staticMonthHeight = sender.isOn;
}
- (IBAction)hideOtherDayChange:(UISwitch *)sender {
    _calendar.hideOtherDay = sender.isOn;
}
- (IBAction)square:(UISwitch *)sender {
    _calendar.selectSquare = sender.isOn;
}
- (IBAction)sundayFirst:(UISwitch *)sender {
    _calendar.sundayFirst = sender.isOn;
    if (sender.isOn) {
        [_weekView removeFromSuperview];
        _weekView = [ZYCalendarWeekView ZYCalendarWeekViewWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 44)  weekArray:@[@"SUN",@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT"]];
        _weekView.backgroundColor = [UIColor colorWithRed:24/255.0 green:49/255.0 blue:85/255.0 alpha:1];
        [self.view addSubview:_weekView];
    }
    else {
        
        [_weekView removeFromSuperview];
        _weekView = [ZYCalendarWeekView ZYCalendarWeekViewWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 44)  weekArray:@[@"MON",@"TUE",@"WED",@"THU",@"FRI",@"SAT",@"SUN"]];
        _weekView.backgroundColor = [UIColor colorWithRed:24/255.0 green:49/255.0 blue:85/255.0 alpha:1];
        [self.view addSubview:_weekView];
    }
}
- (IBAction)airbnb:(UISwitch *)sender {
    self.onlyCurrentMonth.on = NO;
    self.singleLine.on = NO;
    _calendar.selectedDrawMode = ZYCalendarRangeDrawModeAirbnb;
}
- (IBAction)singleLine:(id)sender {
    self.airbnb.on = NO;
    self.onlyCurrentMonth.on = NO;
    _calendar.selectedDrawMode = ZYCalendarRangeDrawModeSingleLine;
}
- (IBAction)onlyCurrentMonth:(id)sender {
    self.airbnb.on = NO;
    self.singleLine.on = NO;
    _calendar.selectedDrawMode = ZYCalendarRangeDrawModeOnlyCurrentMonth;
}


- (IBAction)didClickCleanBtn:(id)sender {
    
    self.calendar.ranges = nil;
    
    [self.calendar reload];
    
    
}


@end
