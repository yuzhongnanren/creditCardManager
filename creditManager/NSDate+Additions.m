//
//  NSDate+Additions.h
//  KXTicket
//
//  Created by kyori.hu on 13-06-18.
//  Copyright (c) 2013 kuxun.cn. All rights reserved.
//

#import "NSDate+Additions.h"

#define DATE_COMPONENTS  (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (Additions)


+ (NSDate *)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}


- (NSString *)yyyymmdd
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    NSInteger year = comps.year;
    NSInteger month = comps.month;
    NSInteger day = comps.day;
    NSString *strDate = [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
    
    return strDate;
}


- (NSString *)yyyymmddhhmmss {
    NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit
                                          fromDate:self];
	NSInteger year = comps.year;
	NSInteger month = comps.month;
	NSInteger day = comps.day;
    
    NSString *strDate = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d", year, month, day, comps.hour, comps.minute, comps.second];
    
    return strDate;
}


#pragma mark -
#pragma mark Relative Dates

+ (NSDate *) dateWithDaysFromNow:(NSUInteger) days {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}


+ (NSDate *) dateWithDaysBeforeNow:(NSUInteger)days {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}


+ (NSDate *) dateTomorrow {
	return [NSDate dateWithDaysFromNow:1];
}


+ (NSDate *) dateYesterday {
	return [NSDate dateWithDaysBeforeNow:1];
}


+ (NSDate *) dateWithHoursFromNow:(NSUInteger)dHours {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}


+ (NSDate *) dateWithHoursBeforeNow:(NSUInteger)dHours {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;	
}


+ (NSDate *) dateWithMinutesFromNow:(NSUInteger)dMinutes {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}


+ (NSDate *) dateWithMinutesBeforeNow:(NSUInteger)dMinutes {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}


#pragma mark -
#pragma mark Comparing Dates


- (BOOL)isEqualToDateIgnoringTime: (NSDate *) aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return (([components1 year] == [components2 year]) &&
			([components1 month] == [components2 month]) && 
			([components1 day] == [components2 day]));
}


- (BOOL)isToday {
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}


- (BOOL)isTomorrow {
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}


- (BOOL)isYesterday {
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}


// This hard codes the assumption that a week is 7 days
- (BOOL)isSameWeekAsDate:(NSDate *)aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if ([components1 week] != [components2 week]) 
        return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (abs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}


- (BOOL)isThisWeek {
	return [self isSameWeekAsDate:[NSDate date]];
}


- (BOOL)isNextWeek {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
	return [self isSameYearAsDate:newDate];
}


- (BOOL)isLastWeek {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    
	return [self isSameYearAsDate:newDate];
}


- (BOOL)isSameYearAsDate:(NSDate *)aDate {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:aDate];
    
	return ([components1 year] == [components2 year]);
}


- (BOOL)isThisYear {
	return [self isSameWeekAsDate:[NSDate date]];
}


- (BOOL)isNextYear {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] + 1));
}


- (BOOL)isLastYear {
	NSDateComponents *components1 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:NSYearCalendarUnit fromDate:[NSDate date]];
	
	return ([components1 year] == ([components2 year] - 1));
}


- (BOOL)isEarlierThanDate:(NSDate *)aDate {
	return ([self earlierDate:aDate] == self);
}


- (BOOL)isLaterThanDate:(NSDate *)aDate {
	return ([self laterDate:aDate] == self);
}


#pragma mark -
#pragma mark Adjusting Dates


- (NSDate *)dateByAddingDays: (NSUInteger)dDays {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}


- (NSDate *) dateBySubtractingDays: (NSUInteger) dDays {
	return [self dateByAddingDays: (dDays * -1)];
}


- (NSDate *)dateByAddingHours:(NSUInteger)dHours {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;		
}


- (NSDate *)dateBySubtractingHours:(NSUInteger)dHours {
	return [self dateByAddingHours: (dHours * -1)];
}


- (NSDate *) dateByAddingMinutes:(NSUInteger)dMinutes {
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;			
}


- (NSDate *)dateBySubtractingMinutes:(NSUInteger)dMinutes {
	return [self dateByAddingMinutes: (dMinutes * -1)];
}


- (NSDate *)dateAtStartOfDay {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	[components setHour:0];
	[components setMinute:0];
	[components setSecond:0];
	return [CURRENT_CALENDAR dateFromComponents:components];
}


- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate {
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark -
#pragma mark Retrieving Intervals


- (NSInteger)minutesAfterDate:(NSDate *)aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}


- (NSInteger)minutesBeforeDate:(NSDate *)aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}


- (NSInteger)hoursAfterDate:(NSDate *)aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}


- (NSInteger)hoursBeforeDate:(NSDate *)aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}


- (NSInteger)daysAfterDate: (NSDate *)aDate {
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}


- (NSInteger) daysBeforeDate:(NSDate *)aDate {
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}


#pragma mark -
#pragma mark Decomposing Dates

- (NSInteger)nearestHour {
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return [components hour];
}


- (NSInteger)hour {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components hour];
}


- (NSInteger)minute {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components minute];
}


- (NSInteger)seconds {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components second];
}


- (NSInteger)day {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components day];
}


- (NSInteger)month {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components month];
}


- (NSInteger)week {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components week];
}


- (NSInteger)weekday {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekday];
}


- (NSInteger)nthWeekday  {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components weekdayOrdinal];
}


- (NSInteger)year {
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return [components year];
}

@end


NSString *g_strXingqi[] = {
    @"星期日",
    @"星期一",
    @"星期二",
    @"星期三",
    @"星期四",
    @"星期五",
    @"星期六"
};

NSString *g_strZhou[] = {
	@"周日",
	@"周一",
	@"周二",
	@"周三",
	@"周四",
	@"周五",
	@"周六"
};

#define kDataFormat_DateTime       @"yyyy-MM-dd HH:mm:ss"
#define kDataFormat_Date           @"yyyy-MM-dd"
#define kDataFormat_Time           @"HH:mm:ss"
#define kDataFormat_YYYYMMDD        @"yyyyMMdd"
#define kDataFormat_YYYYMMDDHHMMSS  @"yyyyMMddHHmmss"

@implementation NSDate (ext_string)


- (NSString *) xingqiString {
	NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:kCFCalendarUnitWeekday|NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    if ( comps.weekday > 0 && comps.weekday <= 7) {
        return g_strXingqi[comps.weekday-1];
    }
    else {
        return @"";
    }
}

- (NSString *) zhouString {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:kCFCalendarUnitWeekday|NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    if ( comps.weekday > 0 && comps.weekday <= 7) {
        return g_strZhou[comps.weekday-1];
    }
    else {
        return @"";
    }
}

+ (NSDate *) dateWithString:(NSString *)dateString format:(NSString *)format
{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:format];
    NSDate *t_date = [dateFormatter dateFromString:dateString];
	return t_date;
}


- (NSString *)toYYYYMMDD
{
	int year, month, day;
	ParseDate(self, &year, &month, &day);
	return [NSString stringWithFormat:@"%04d%02d%02d", year, month, day];
}

- (NSString *)toYYYY_MM_DD {
	int year, month, day;
	ParseDate(self, &year, &month, &day);
	return [NSString stringWithFormat:@"%04d-%02d-%02d", year, month, day];
}

- (NSString *)toMMDD
{
	int year, month, day;
	ParseDate(self, &year, &month, &day);
	return [NSString stringWithFormat:@"%02d月%02d日", month, day];
}
- (NSString *)toYYYYMMDD2
{
	int year, month, day;
	ParseDate(self, &year, &month, &day);
	return [NSString stringWithFormat:@"%04d年%02d月%02d日", year, month, day];
}

- (NSString *)toHH_MM {
    int year, month, day, hour, minute;
    ParseDateLong(self, &year, &month, &day, &hour, &minute);
    return [NSString stringWithFormat:@"%02d:%02d", hour, minute];
}

- (NSString *)toMM_DD
{
	int year, month, day;
	ParseDate(self, &year, &month, &day);
	return [NSString stringWithFormat:@"%02d-%02d", month, day];
}

- (NSString *)toYYYYMMDDHHMMSS {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:kDataFormat_YYYYMMDDHHMMSS];
	NSString *str = [dateFormatter stringFromDate:self];
	
	
	return str;
}

//只比较日期上的大小
- (NSComparisonResult)compareDate:(NSDate *)anotherDate {
    NSString *str1 = [self toYYYYMMDD];
    NSString *str2 = [anotherDate toYYYYMMDD];
    return [str1 compare:str2];
}


+ (NSDate *)dateWithYYYYMMDD:(NSString *)strDate {
    if ( strDate.length!=8 )
		return nil;
	int n = [strDate intValue];
	int year = n/10000;
	int month = (n/100) % 100;
	int day = n % 100;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	[comps setYear:year];
	[comps setMonth:month];
	[comps setDay:day];
	NSDate *date = [calendar dateFromComponents:comps];
	
	
	return date;
}

+ (NSDate *)dateWithYYYY_MM_DD:(NSString *)strDate {
    
    //    return [NSDate dateWithString:str format:kDataFormat_Date];
    NSArray *arr = [strDate componentsSeparatedByString:@"-"];
	if ( arr.count == 3 ) {
		int year = [[arr objectAtIndex:0] intValue];
		int month = [[arr objectAtIndex:1] intValue];
		int day = [[arr objectAtIndex:2] intValue];
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:year];
		[comps setMonth:month];
		[comps setDay:day];
		NSDate *date = [calendar dateFromComponents:comps];
	
		
		return date;
	}
	return nil;
}

+ (NSDate *)dateWithYYYY_MM_DD:(NSString *)strDate HH_MM:(NSString *)strTime {
    if ( strTime.length == 0 ) {
        strTime = @"00:00";
    }
    
    NSArray *arrDate = [strDate componentsSeparatedByString:@"-"];
	NSArray *arrTime = [strTime componentsSeparatedByString:@":"];
    
	if ( arrDate.count == 3 && arrTime.count == 2) {
		int year = [[arrDate objectAtIndex:0] intValue];
		int month = [[arrDate objectAtIndex:1] intValue];
		int day = [[arrDate objectAtIndex:2] intValue];
		int hour = [[arrTime objectAtIndex:0] intValue];
		int min = [[arrTime objectAtIndex:1] intValue];
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDateComponents *comps = [[NSDateComponents alloc] init];
		[comps setYear:year];
		[comps setMonth:month];
		[comps setDay:day];
		[comps setHour:hour];
		[comps setMinute:min];
		NSDate *date = [calendar dateFromComponents:comps];
		
		
		return date;
	}
	return nil;
}

/*
 
 + (NSDate *) dateWithBeijingTime:(NSString *)str {
 
 if ( str.length > 19 ) {
 str = [str substringToIndex:19];
 }
 
 return [NSDate dateWithString:str format:kDataFormat_DateTime];
 }
 
 
 - (NSString *) beijingTime {
 
 NSCalendar *calendar = [NSCalendar currentCalendar];
 
 NSDateComponents *comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:self];
 
 NSString *str = [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d",
 comps.year, comps.month, comps.day, comps.hour, comps.minute, comps.second];
 return str;
 }
 */



@end


void ParseDate(NSDate *date, int *year, int *month, int* day)
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
	*year = comps.year;
	*month = comps.month;
	*day = comps.day;
    
}

void ParseDateWeek(NSDate *date, int *year, int *month, int* day, int *week)
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	NSDateComponents *comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit |NSWeekdayCalendarUnit fromDate:date];
	*year = comps.year;
	*month = comps.month;
	*day = comps.day;
	*week = comps.weekday;
    
}

void ParseDateLong(NSDate *date, int *year, int *month, int* day, int *hour, int *minute)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps = [calendar components:NSYearCalendarUnit| NSMonthCalendarUnit|NSDayCalendarUnit |NSHourCalendarUnit | NSMinuteCalendarUnit fromDate:date];
    *year = comps.year;
    *month = comps.month;
    *day = comps.day;
    *hour = comps.hour;
    *minute = comps.minute;
}
