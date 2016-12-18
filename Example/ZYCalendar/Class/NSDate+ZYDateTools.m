
#import "NSDate+ZYDateTools.h"
#import <CoreGraphics/CoreGraphics.h>

#define SECONDS_IN_HOUR 3600
#define SECONDS_IN_MINUTE 60


typedef NS_ENUM(NSUInteger, ZYDateComponent){
    ZYDateComponentEra,
    ZYDateComponentYear,
    ZYDateComponentMonth,
    ZYDateComponentDay,
    ZYDateComponentHour,
    ZYDateComponentMinute,
    ZYDateComponentSecond,
    ZYDateComponentWeekday,
    ZYDateComponentWeekdayOrdinal,
    ZYDateComponentQuarter,
    ZYDateComponentWeekOfMonth,
    ZYDateComponentWeekOfYear,
    ZYDateComponentYearForWeekOfYear,
    ZYDateComponentDayOfYear
};

typedef NS_ENUM(NSUInteger, DateAgoFormat){
    DateAgoLong,
    DateAgoLongUsingNumericDatesAndTimes,
    DateAgoLongUsingNumericDates,
    DateAgoLongUsingNumericTimes,
    DateAgoShort
};

typedef NS_ENUM(NSUInteger, DateAgoValues){
    YearsAgo,
    MonthsAgo,
    WeeksAgo,
    DaysAgo,
    HoursAgo,
    MinutesAgo,
    SecondsAgo
};

static const unsigned int allCalendarUnitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear;

static NSString *defaultCalendarIdentifier = nil;
static NSCalendar *implicitCalendar = nil;

@implementation NSDate (ZYDateTools)

+ (void)load {
    [self lzy_setDefaultCalendarIdentifier:NSCalendarIdentifierGregorian];
}

#pragma mark - Time Ago



- (NSInteger)lzy_daysCount {

        
    NSUInteger month = self.lzy_month;
        if (month != 2) {
            
            if ([self lzy_is31DaysMonth:month]) {
                
                return 31;
            }else {
                
                return 30;
            }
            
        }
        
        if ([self lzy_isInLeapYear]) {
            
            return 29;
            
        }else {
            
            return 28;
        }
        
    
    
    
}

- (BOOL)lzy_isToday {
    
    return [self lzy_daysOffsetWithDate:[NSDate date]] == 0;
}

- (BOOL)lzy_is31DaysMonth:(NSUInteger )month {
    
    __block BOOL is31DayMonth = NO;
    NSArray *array = @[@"1",@"3",@"5",@"7",@"8",@"10",@"12"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (month == [obj integerValue]) {
            
            is31DayMonth = YES;
        }
        
    }];
    
    
    return is31DayMonth;
    
    
}



+ (NSDate *) lzy_dateStandardFormatTimeZeroWithDate: (NSDate *) aDate{
    
    NSDate *date = [self lzy_dateWithYear:aDate.lzy_year month:aDate.lzy_month day:aDate.lzy_day hour:0 minute:0 second:0];
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    date = [NSDate dateWithTimeIntervalSince1970:interval + 8 * 3600];
    
    return date;
}






- (NSString *)lzy_getLocaleFormatUnderscoresWithValue:(double)value {
    NSString *localeCode = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    
   
    if([localeCode isEqualToString:@"ru"] || [localeCode isEqualToString:@"uk"]) {
        int XY = (int)floor(value) % 100;
        int Y = (int)floor(value) % 10;
        
        if(Y == 0 || Y > 4 || (XY > 10 && XY < 15)) {
            return @"";
        }

        if(Y > 1 && Y < 5 && (XY < 10 || XY > 20))  {
            return @"_";
        }

        if(Y == 1 && XY != 11) {
            return @"__";
        }
    }
    

    
    return @"";
}

#pragma mark - Date Components Without Calendar

- (NSInteger)lzy_era{
    return [self lzy_componentForDate:self type:ZYDateComponentEra calendar:nil];
}


- (NSInteger)lzy_year{
    return [self lzy_componentForDate:self type:ZYDateComponentYear calendar:nil];
}


- (NSInteger)lzy_month{
    return [self lzy_componentForDate:self type:ZYDateComponentMonth calendar:nil];
}


- (NSInteger)lzy_day{
    return [self lzy_componentForDate:self type:ZYDateComponentDay calendar:nil];
}


- (NSInteger)lzy_hour{
    return [self lzy_componentForDate:self type:ZYDateComponentHour calendar:nil];
}


- (NSInteger)lzy_minute {
    return [self lzy_componentForDate:self type:ZYDateComponentMinute calendar:nil];
}


- (NSInteger)lzy_second{
    return [self lzy_componentForDate:self type:ZYDateComponentSecond calendar:nil];
}


- (NSInteger)lzy_weekday{
    return [self lzy_componentForDate:self type:ZYDateComponentWeekday calendar:nil];
}


- (NSInteger)lzy_weekdayOrdinal{
    return [self lzy_componentForDate:self type:ZYDateComponentWeekdayOrdinal calendar:nil];
}


- (NSInteger)lzy_quarter{
    return [self lzy_componentForDate:self type:ZYDateComponentQuarter calendar:nil];
}


- (NSInteger)lzy_weekOfMonth{
    return [self lzy_componentForDate:self type:ZYDateComponentWeekOfMonth calendar:nil];
}


- (NSInteger)lzy_weekOfYear{
    return [self lzy_componentForDate:self type:ZYDateComponentWeekOfYear calendar:nil];
}


- (NSInteger)lzy_yearForWeekOfYear{
    return [self lzy_componentForDate:self type:ZYDateComponentYearForWeekOfYear calendar:nil];
}


- (NSInteger)lzy_daysInMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay
                                  inUnit:NSCalendarUnitMonth
                                 forDate:self];
    return days.length;
}


- (NSInteger)lzy_dayOfYear{
    return [self lzy_componentForDate:self type:ZYDateComponentDayOfYear calendar:nil];
}


- (NSInteger)lzy_daysInYear{
    if (self.lzy_isInLeapYear) {
        return 366;
    }
    
    return 365;
}


- (BOOL)lzy_isInLeapYear{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *dateComponents = [calendar components:allCalendarUnitFlags fromDate:self];
    
    if (dateComponents.year%400 == 0){
        return YES;
    }
    else if (dateComponents.year%100 == 0){
        return NO;
    }
    else if (dateComponents.year%4 == 0){
        return YES;
    }
    
    return NO;
}

- (BOOL)lzy_isWeekend {
    
    NSCalendar *calendar            = [NSCalendar currentCalendar];
    NSRange weekdayRange            = [calendar maximumRangeOfUnit:NSCalendarUnitWeekday];
    NSDateComponents *components    = [calendar components:NSCalendarUnitWeekday
                                                  fromDate:self];
    NSUInteger weekdayOfSomeDate    = [components weekday];
    
    BOOL result = NO;
    
    if (weekdayOfSomeDate == weekdayRange.location || weekdayOfSomeDate == weekdayRange.length)
        result = YES;
    
    return result;

}

- (BOOL)lcck_isToday {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    return [today isEqualToDate:otherDate];
}


- (BOOL)lzy_isSameDay:(NSDate *)date {
    return [self lzy_daysOffsetWithDate:date] == 0;
}


+ (BOOL)lzy_isSameDay:(NSDate *)date asDate:(NSDate *)compareDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *dateOne = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:compareDate];
    NSDate *dateTwo = [cal dateFromComponents:components];
    
    return [dateOne isEqualToDate:dateTwo];
}

#pragma mark - Date Components With Calendar

- (NSInteger)lzy_eraWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentEra calendar:calendar];
}


- (NSInteger)lzy_yearWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentYear calendar:calendar];
}


- (NSInteger)lzy_monthWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentMonth calendar:calendar];
}

- (NSInteger)lzy_dayWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentDay calendar:calendar];
}

- (NSInteger)lzy_hourWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentHour calendar:calendar];
}


- (NSInteger)lzy_minuteWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentMinute calendar:calendar];
}


- (NSInteger)lzy_secondWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentSecond calendar:calendar];
}

- (NSInteger)lzy_weekdayWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentWeekday calendar:calendar];
}

- (NSInteger)lzy_weekdayOrdinalWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentWeekdayOrdinal calendar:calendar];
}


- (NSInteger)lzy_quarterWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentQuarter calendar:calendar];
}


- (NSInteger)lzy_weekOfMonthWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentWeekOfMonth calendar:calendar];
}


- (NSInteger)lzy_weekOfYearWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentWeekOfYear calendar:calendar];
}


- (NSInteger)lzy_yearForWeekOfYearWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentYearForWeekOfYear calendar:calendar];
}



- (NSInteger)lzy_dayOfYearWithCalendar:(NSCalendar *)calendar{
    return [self lzy_componentForDate:self type:ZYDateComponentDayOfYear calendar:calendar];
}

- (NSInteger)lzy_componentForDate:(NSDate *)date type:(ZYDateComponent)component calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] lzy_implicitCalendar];
    }
    
    unsigned int unitFlags = 0;
    
    if (component == ZYDateComponentYearForWeekOfYear) {
       unitFlags = NSCalendarUnitYear | NSCalendarUnitQuarter | NSCalendarUnitMonth | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitEra | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitWeekOfYear | NSCalendarUnitYearForWeekOfYear;
    }
    else {
        unitFlags = allCalendarUnitFlags;
    }

    NSDateComponents *dateComponents = [calendar components:unitFlags fromDate:date];
    
    switch (component) {
        case ZYDateComponentEra:
            return [dateComponents era];
        case ZYDateComponentYear:
            return [dateComponents year];
        case ZYDateComponentMonth:
            return [dateComponents month];
        case ZYDateComponentDay:
            return [dateComponents day];
        case ZYDateComponentHour:
            return [dateComponents hour];
        case ZYDateComponentMinute:
            return [dateComponents minute];
        case ZYDateComponentSecond:
            return [dateComponents second];
        case ZYDateComponentWeekday:
            return [dateComponents weekday];
        case ZYDateComponentWeekdayOrdinal:
            return [dateComponents weekdayOrdinal];
        case ZYDateComponentQuarter:
            return [dateComponents quarter];
        case ZYDateComponentWeekOfMonth:
            return [dateComponents weekOfMonth];
        case ZYDateComponentWeekOfYear:
            return [dateComponents weekOfYear];
        case ZYDateComponentYearForWeekOfYear:
            return [dateComponents yearForWeekOfYear];
        case ZYDateComponentDayOfYear:
            return [calendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitYear forDate:date];
        default:
            break;
    }
    
    return 0;
}

#pragma mark - Date Creating
+ (NSDate *)lzy_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
	
    return [NSDate lzy_dateStandardFormatTimeZeroWithDate:[self lzy_dateWithYear:year month:month day:day hour:0 minute:0 second:0]];
}

+ (NSDate *)lzy_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
	
	NSDate *nsDate = nil;
	NSDateComponents *components = [[NSDateComponents alloc] init];
	
	components.year   = year;
	components.month  = month;
	components.day    = day;
	components.hour   = hour;
	components.minute = minute;
	components.second = second;
	
	nsDate = [[[self class] lzy_implicitCalendar] dateFromComponents:components];
	
	return nsDate;
}

+ (NSDate *)lzy_dateWithString:(NSString *)dateString formatString:(NSString *)formatString {

	return [self lzy_dateWithString:dateString formatString:formatString timeZone:[NSTimeZone systemTimeZone]];
}

+ (NSDate *)lzy_dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone {

	static NSDateFormatter *parser = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
	    parser = [[NSDateFormatter alloc] init];
	});

	parser.dateStyle = NSDateFormatterNoStyle;
	parser.timeStyle = NSDateFormatterNoStyle;
	parser.timeZone = timeZone;
	parser.dateFormat = formatString;

	return [parser dateFromString:dateString];
}


#pragma mark - Date Editing
#pragma mark Date By Adding

- (NSDate *)lzy_dateByAddingYears:(NSInteger)years{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateByAddingMonths:(NSInteger)months{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)lzy_dateByAddingDays:(NSInteger)days{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:days];
    
    return [NSDate lzy_dateStandardFormatTimeZeroWithDate:[calendar dateByAddingComponents:components toDate:self options:0]];
}


- (NSDate *)lzy_dateByAddingHours:(NSInteger)hours{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hours];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateByAddingMinutes:(NSInteger)minutes{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:minutes];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateByAddingSeconds:(NSInteger)seconds{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:seconds];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark Date By Subtracting
- (NSDate *)lzy_dateBySubtractingYears:(NSInteger)years{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:-1*years];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateBySubtractingMonths:(NSInteger)months{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:-1*months];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateBySubtractingWeeks:(NSInteger)weeks{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:-1*weeks];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateBySubtractingDays:(NSInteger)days{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:-1*days];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateBySubtractingHours:(NSInteger)hours{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:-1*hours];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateBySubtractingMinutes:(NSInteger)minutes{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMinute:-1*minutes];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}


- (NSDate *)lzy_dateBySubtractingSeconds:(NSInteger)seconds{
    NSCalendar *calendar = [[self class] lzy_implicitCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setSecond:-1*seconds];
    
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

#pragma mark - Date Comparison
#pragma mark Time From

- (NSInteger)lzy_yearsFrom:(NSDate *)date {
    return [self lzy_yearsFrom:date calendar:nil];
}


- (NSInteger)lzy_monthsFrom:(NSDate *)date {
    if (!date) {
        return 0;
    }
    return [self lzy_monthsFrom:date calendar:nil];
}


- (NSInteger)lzy_weeksFrom:(NSDate *)date {
    return [self lzy_weeksFrom:date calendar:nil];
}


- (NSInteger)lzy_daysFrom:(NSDate *)date {
    return [self lzy_daysFrom:date calendar:nil];
}


- (double)lzy_hoursFrom:(NSDate *)date {
    return ([self timeIntervalSinceDate:date])/SECONDS_IN_HOUR;
}


- (double)lzy_minutesFrom:(NSDate *)date {
    return ([self timeIntervalSinceDate:date])/SECONDS_IN_MINUTE;
}


- (double)lzy_secondsFrom:(NSDate *)date {
    return [self timeIntervalSinceDate:date];
}

#pragma mark Time From With Calendar

- (NSInteger)lzy_yearsFrom:(NSDate *)date calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] lzy_implicitCalendar];
    }
    
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:earliest toDate:latest options:0];
    return multiplier*components.year;
}


- (NSInteger)lzy_monthsFrom:(NSDate *)date calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] lzy_implicitCalendar];
    }
    
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:allCalendarUnitFlags fromDate:earliest toDate:latest options:0];
    return multiplier*(components.month + 12*components.year);
}


- (NSInteger)lzy_weeksFrom:(NSDate *)date calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] lzy_implicitCalendar];
    }
    
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekOfYear fromDate:earliest toDate:latest options:0];
    return multiplier*components.weekOfYear;
}


- (NSInteger)lzy_daysFrom:(NSDate *)date calendar:(NSCalendar *)calendar{
    if (!calendar) {
        calendar = [[self class] lzy_implicitCalendar];
    }
    
    NSDate *earliest = [self earlierDate:date];
    NSDate *latest = (earliest == self) ? date : self;
    NSInteger multiplier = (earliest == self) ? -1 : 1;
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:earliest toDate:latest options:0];
    return multiplier*components.day;
}

#pragma mark Time Until

- (NSInteger)lzy_yearsUntil{
    return [self lzy_yearsLaterThan:[NSDate date]];
}


- (NSInteger)lzy_monthsUntil{
    return [self lzy_monthsLaterThan:[NSDate date]];
}


- (NSInteger)lzy_weeksUntil{
    return [self lzy_weeksLaterThan:[NSDate date]];
}


- (NSInteger)lzy_daysUntil{
    return [self lzy_daysLaterThan:[NSDate date]];
}


- (double)lzy_hoursUntil{
    return [self lzy_hoursLaterThan:[NSDate date]];
}


- (double)lzy_minutesUntil{
    return [self lzy_minutesLaterThan:[NSDate date]];
}


- (double)lzy_secondsUntil{
    return [self lzy_secondsLaterThan:[NSDate date]];
}

#pragma mark Time Ago

- (NSInteger)lzy_yearsAgo{
    return [self lzy_yearsEarlierThan:[NSDate date]];
}


- (NSInteger)lzy_monthsAgo{
    return [self lzy_monthsEarlierThan:[NSDate date]];
}


- (NSInteger)lzy_weeksAgo{
    return [self lzy_weeksEarlierThan:[NSDate date]];
}


- (NSInteger)lzy_daysAgo{
    return [self lzy_daysEarlierThan:[NSDate date]];
}


- (double)lzy_hoursAgo{
    return [self lzy_hoursEarlierThan:[NSDate date]];
}


- (double)lzy_minutesAgo{
    return [self lzy_minutesEarlierThan:[NSDate date]];
}


- (double)lzy_secondsAgo{
    return [self lzy_secondsEarlierThan:[NSDate date]];
}

#pragma mark Earlier Than

- (NSInteger)lzy_yearsEarlierThan:(NSDate *)date {
    return ABS(MIN([self lzy_yearsFrom:date], 0));
}


- (NSInteger)lzy_monthsEarlierThan:(NSDate *)date {
    return ABS(MIN([self lzy_monthsFrom:date], 0));
}


- (NSInteger)lzy_weeksEarlierThan:(NSDate *)date {
    return ABS(MIN([self lzy_weeksFrom:date], 0));
}


- (NSInteger)lzy_daysEarlierThan:(NSDate *)date {
    return ABS(MIN([self lzy_daysFrom:date], 0));
}


- (double)lzy_hoursEarlierThan:(NSDate *)date {
    return ABS(MIN([self lzy_hoursFrom:date], 0));
}


- (double)lzy_minutesEarlierThan:(NSDate *)date {
    return ABS(MIN([self lzy_minutesFrom:date], 0));
}


- (double)lzy_secondsEarlierThan:(NSDate *)date {
    return ABS(MIN([self lzy_secondsFrom:date], 0));
}

#pragma mark Later Than

- (NSInteger)lzy_yearsLaterThan:(NSDate *)date {
    return MAX([self lzy_yearsFrom:date], 0);
}


- (NSInteger)lzy_monthsLaterThan:(NSDate *)date {
    return MAX([self lzy_monthsFrom:date], 0);
}


- (NSInteger)lzy_weeksLaterThan:(NSDate *)date {
    return MAX([self lzy_weeksFrom:date], 0);
}


- (NSInteger)lzy_daysLaterThan:(NSDate *)date {
    return MAX([self lzy_daysFrom:date], 0);
}


- (double)lzy_hoursLaterThan:(NSDate *)date {
    return MAX([self lzy_hoursFrom:date], 0);
}


- (double)lzy_minutesLaterThan:(NSDate *)date {
    return MAX([self lzy_minutesFrom:date], 0);
}


- (double)lzy_secondsLaterThan:(NSDate *)date {
    return MAX([self lzy_secondsFrom:date], 0);
}


#pragma mark Comparators

- (BOOL)lzy_isEarlierThan:(NSDate *)date {
   return [self lzy_daysOffsetWithDate:date] <0;
}

- (BOOL)lzy_isLaterThan:(NSDate *)date {
    
    return [self lzy_daysOffsetWithDate:date] >0;
}


- (BOOL)lzy_isLaterThanOrEqualTo:(NSDate *)date {
    return  [self lzy_daysOffsetWithDate:date] >= 0;
}


- (BOOL)lzy_isEarlierThanOrEqualTo:(NSDate *)date {
    
   return  [self lzy_daysOffsetWithDate:date] <= 0;
}


- (NSInteger) lzy_daysOffsetWithDate:(NSDate *)date
{
    //只取年月日比较
    NSDate *dateSelf = [NSDate lzy_dateStandardFormatTimeZeroWithDate:self];
    NSTimeInterval timeInterval = [dateSelf timeIntervalSince1970];
    NSDate *dateNow = [NSDate lzy_dateStandardFormatTimeZeroWithDate:date];
    NSTimeInterval timeIntervalNow = [dateNow timeIntervalSince1970];
    
    NSTimeInterval cha = timeInterval - timeIntervalNow;
    CGFloat chaDay = cha / 86400.0;
    NSInteger day = chaDay * 1;
    return day;
}

#pragma mark - Formatted Dates
#pragma mark Formatted With Style

- (NSString *)lzy_formattedDateWithStyle:(NSDateFormatterStyle)style {
    return [self lzy_formattedDateWithStyle:style timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}


- (NSString *)lzy_formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone {
    return [self lzy_formattedDateWithStyle:style timeZone:timeZone locale:[NSLocale autoupdatingCurrentLocale]];
}


- (NSString *)lzy_formattedDateWithStyle:(NSDateFormatterStyle)style locale:(NSLocale *)locale {
    return [self lzy_formattedDateWithStyle:style timeZone:[NSTimeZone systemTimeZone] locale:locale];
}


- (NSString *)lzy_formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });

    [formatter setDateStyle:style];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

#pragma mark Formatted With Format

- (NSString *)lzy_formattedDateWithFormat:(NSString *)format{
    return [self lzy_formattedDateWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:[NSLocale autoupdatingCurrentLocale]];
}


- (NSString *)lzy_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone {
    return [self lzy_formattedDateWithFormat:format timeZone:timeZone locale:[NSLocale autoupdatingCurrentLocale]];
}


- (NSString *)lzy_formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale {
    return [self lzy_formattedDateWithFormat:format timeZone:[NSTimeZone systemTimeZone] locale:locale];
}


- (NSString *)lzy_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });

    [formatter setDateFormat:format];
    [formatter setTimeZone:timeZone];
    [formatter setLocale:locale];
    return [formatter stringFromDate:self];
}

#pragma mark - Helpers

+ (BOOL)lzy_isLeapYear:(NSInteger)year{
    if (year%400){
        return YES;
    }
    else if (year%100){
        return NO;
    }
    else if (year%4){
        return YES;
    }
    
    return NO;
}


+ (NSString *)lzy_defaultCalendarIdentifier {
    return defaultCalendarIdentifier;
}


+ (void)lzy_setDefaultCalendarIdentifier:(NSString *)identifier {
    defaultCalendarIdentifier = [identifier copy];
    implicitCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:defaultCalendarIdentifier ?: NSCalendarIdentifierGregorian];
}


+ (NSCalendar *)lzy_implicitCalendar {
    return implicitCalendar;
}

@end
