

#import <Foundation/Foundation.h>


@interface NSDate (ZYDateTools)





#pragma mark - Date Components Without Calendar
- (NSInteger)lzy_era;
- (NSInteger)lzy_year;
- (NSInteger)lzy_month;
- (NSInteger)lzy_day;
- (NSInteger)lzy_hour;
- (NSInteger)lzy_minute;
- (NSInteger)lzy_second;
- (NSInteger)lzy_weekday;
- (NSInteger)lzy_weekdayOrdinal;
- (NSInteger)lzy_quarter;
- (NSInteger)lzy_weekOfMonth;
- (NSInteger)lzy_weekOfYear;
- (NSInteger)lzy_yearForWeekOfYear;
- (NSInteger)lzy_daysInMonth;
- (NSInteger)lzy_dayOfYear;
- (NSInteger)lzy_daysInYear;
- (BOOL)lzy_isInLeapYear;
- (BOOL)lzy_isToday;
- (BOOL)lzy_isWeekend;
- (BOOL)lzy_isSameDay:(NSDate *)date;


#pragma mark - Date Components With Calendar


- (NSInteger)lzy_eraWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_yearWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_monthWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_dayWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_hourWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_minuteWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_secondWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_weekdayWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_weekdayOrdinalWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_quarterWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_weekOfMonthWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_weekOfYearWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_yearForWeekOfYearWithCalendar:(NSCalendar *)calendar;
- (NSInteger)lzy_daysOffsetWithDate:(NSDate *)date;


+ (NSDate *)lzy_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)lzy_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)lzy_dateWithString:(NSString *)dateString formatString:(NSString *)formatString;
+ (NSDate *)lzy_dateWithString:(NSString *)dateString formatString:(NSString *)formatString timeZone:(NSTimeZone *)timeZone;

+ (NSDate *) lzy_dateStandardFormatTimeZeroWithDate: (NSDate *) aDate;


- (NSDate *)lzy_dateByAddingYears:(NSInteger)years;
- (NSDate *)lzy_dateByAddingMonths:(NSInteger)months;
- (NSDate *)lzy_dateByAddingDays:(NSInteger)days;


- (NSDate *)lzy_dateBySubtractingYears:(NSInteger)years;
- (NSDate *)lzy_dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)lzy_dateBySubtractingDays:(NSInteger)days;



-(NSInteger)lzy_yearsFrom:(NSDate *)date;
-(NSInteger)lzy_monthsFrom:(NSDate *)date;
-(NSInteger)lzy_weeksFrom:(NSDate *)date;
-(NSInteger)lzy_daysFrom:(NSDate *)date;
-(double)lzy_hoursFrom:(NSDate *)date;
-(double)lzy_minutesFrom:(NSDate *)date;
-(double)lzy_secondsFrom:(NSDate *)date;

-(NSInteger)lzy_yearsFrom:(NSDate *)date calendar:(NSCalendar *)calendar;
-(NSInteger)lzy_monthsFrom:(NSDate *)date calendar:(NSCalendar *)calendar;
-(NSInteger)lzy_weeksFrom:(NSDate *)date calendar:(NSCalendar *)calendar;
-(NSInteger)lzy_daysFrom:(NSDate *)date calendar:(NSCalendar *)calendar;


-(NSInteger)lzy_yearsUntil;
-(NSInteger)lzy_monthsUntil;
-(NSInteger)lzy_weeksUntil;
-(NSInteger)lzy_daysUntil;
-(double)lzy_hoursUntil;
-(double)lzy_minutesUntil;
-(double)lzy_secondsUntil;
#pragma mark Time Ago
-(NSInteger)lzy_yearsAgo;
-(NSInteger)lzy_monthsAgo;
-(NSInteger)lzy_weeksAgo;
-(NSInteger)lzy_daysAgo;
-(double)lzy_hoursAgo;
-(double)lzy_minutesAgo;
-(double)lzy_secondsAgo;
#pragma mark Earlier Than
-(NSInteger)lzy_yearsEarlierThan:(NSDate *)date;
-(NSInteger)lzy_monthsEarlierThan:(NSDate *)date;
-(NSInteger)lzy_weeksEarlierThan:(NSDate *)date;
-(NSInteger)lzy_daysEarlierThan:(NSDate *)date;
-(double)lzy_hoursEarlierThan:(NSDate *)date;
-(double)lzy_minutesEarlierThan:(NSDate *)date;
-(double)lzy_secondsEarlierThan:(NSDate *)date;
#pragma mark Later Than
-(NSInteger)lzy_yearsLaterThan:(NSDate *)date;
-(NSInteger)lzy_monthsLaterThan:(NSDate *)date;
-(NSInteger)lzy_weeksLaterThan:(NSDate *)date;
-(NSInteger)lzy_daysLaterThan:(NSDate *)date;
-(double)lzy_hoursLaterThan:(NSDate *)date;
-(double)lzy_minutesLaterThan:(NSDate *)date;
-(double)lzy_secondsLaterThan:(NSDate *)date;
#pragma mark Comparators
-(BOOL)lzy_isEarlierThan:(NSDate *)date;
-(BOOL)lzy_isLaterThan:(NSDate *)date;
-(BOOL)lzy_isEarlierThanOrEqualTo:(NSDate *)date;
-(BOOL)lzy_isLaterThanOrEqualTo:(NSDate *)date;

- (NSInteger)lzy_daysCount;


#pragma mark - Formatted Dates
#pragma mark Formatted With Style
-(NSString *)lzy_formattedDateWithStyle:(NSDateFormatterStyle)style;
-(NSString *)lzy_formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone;
-(NSString *)lzy_formattedDateWithStyle:(NSDateFormatterStyle)style locale:(NSLocale *)locale;
-(NSString *)lzy_formattedDateWithStyle:(NSDateFormatterStyle)style timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;
#pragma mark Formatted With Format
-(NSString *)lzy_formattedDateWithFormat:(NSString *)format;
-(NSString *)lzy_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone;
-(NSString *)lzy_formattedDateWithFormat:(NSString *)format locale:(NSLocale *)locale;
-(NSString *)lzy_formattedDateWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale;

#pragma mark - Helpers
+(NSString *)lzy_defaultCalendarIdentifier;
+ (void)lzy_setDefaultCalendarIdentifier:(NSString *)identifier;

@end
