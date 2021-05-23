//
//  DateUtils.m
//  newupop
//
//  Created by Jellyfish on 2017/8/1.
//  Copyright © 2017年 ideasforHK. All rights reserved.
//

#import "DateUtils.h"

@implementation DateUtils

+ (NSString *)getGreetings{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // 只需要获取小时就好,大写HH表示24小时
    [formatter setDateFormat:@"HH"];
    
    NSString *hourTime = [formatter stringFromDate:date];
    
    NSInteger hour = [hourTime integerValue];
    
    NSString *timePeriod = @"";
    if (hour >= 3 && hour < 8) {
        timePeriod = NSLocalizedString(@"早上好!", nil);
    } else if (hour >= 8 && hour < 14) {
        timePeriod = NSLocalizedString(@"上午好!", nil);
    } else if (hour >= 14 && hour < 18) {
        timePeriod = NSLocalizedString(@"下午好!", nil);
    } else {
        timePeriod = NSLocalizedString(@"晚上好!", nil);
    }
    
    
    return timePeriod;
}

+ (NSString *)getCurrentDateWithFormat:(NSString *)dateFormat
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dateFormat];
    NSString *currentDate = [formatter stringFromDate:date];
    
    return currentDate;
}


+ (NSString *)getCurrentTimeStamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //yyyy-MM-dd HH:mm:ss
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    // 当前时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    return currentTimeString;
}


//获取当前时间戳 （以毫秒为单位）
+(NSString *)getNowTimeTimestamp{

    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式

    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)([datenow timeIntervalSince1970]*1000)];

    return timeSp;
}


+ (NSString *)getCurrentTimeWithTimeStamp:(NSString *)timeStamp
{
    if (timeStamp.length == 0) {
        return @"";
    }
    if (![timeStamp isKindOfClass:[NSNull class]]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *payDate = [formatter dateFromString:timeStamp];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        return [formatter stringFromDate:payDate];
    } else {
        return @"时间戳格式错误";
    }
}

+ (long)getTimeIntervalWithDTime:(NSString *)dTime {
    // 保存随机数和时间差 2017-08-30  时间差是手机端时间和服务端时间差值（防止不一致）
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDate *clientDate = [NSDate date];
    long clientInt = [clientDate timeIntervalSince1970];
    NSLog(@"%ld", clientInt);
    
    // 将获取到的时间格式化
    NSDate *serviceDate = [formatter dateFromString:dTime];
    NSInteger timeDiff = [serviceDate timeIntervalSince1970] - clientInt;
    
    NSLog(@"%@--%@--%zd", serviceDate, [NSDate date], timeDiff);
    
    return [serviceDate timeIntervalSince1970] - clientInt;
}

+(NSString *)formatDate:(NSString *)date symbol:(NSString *)symbol
{
    NSString *year = [date substringToIndex:4];
    NSString *month = [date substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [date substringWithRange:NSMakeRange(6, 2)];
    
    return [NSString stringWithFormat:@"%@%@%@%@%@", year, symbol, month, symbol, day];
}

+(NSString *)dateToStringWithFormatter:(NSString *)formatter date:(NSDate *)date{
    NSDateFormatter *ft = [[NSDateFormatter alloc] init];
    [ft setDateFormat:formatter];
    
    return [ft stringFromDate:date];
}

+ (NSString *)getMonthAgoTime:(NSString *)formatter{
    NSDate *date = [NSDate date];
    NSDateFormatter *ft = [[NSDateFormatter alloc] init];
    [ft setDateFormat:formatter];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:-1];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// NSGregorianCalendar
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    NSString *agoString = [ft stringFromDate:mDate];
    
    return agoString;
}

+ (NSInteger)compareBeginTime:(NSString *)beginTime endTime:(NSString *)endTime{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:beginTime];
    NSDate *endDate = [dateFormatter dateFromString:endTime];
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    
    return delta.day;
}


//时间戳转换为指定格式的时间字符串
+(NSString *)getDateByTimeStamp:(NSString *)timeStamp formatter:(NSString *)formatterStr{
    
    //时间戳转换成时间
    NSTimeInterval time =[timeStamp doubleValue];
   
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
  
    DLog(@"date = %@",date);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
   
    [formatter setDateFormat:formatterStr];
    
    NSString *currentTime = [formatter stringFromDate:date];
    
    
    return currentTime;
    
}


//获取N天后日期字符串
+ (NSString *)getDate:(NSString *)beginTime day:(NSInteger)day{
    
    NSInteger days = day;    // n天后的天数
    days = (days == 0 ? 2.f : days);//未指定天数则默认为两天
    NSDate *appointDate;    // 指定日期声明
    NSTimeInterval oneDay = 24 * 60 * 60;  // 一天一共有多少秒
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
   
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   
    NSDate *startDate = [dateFormatter dateFromString:beginTime];
    
    appointDate = [startDate initWithTimeIntervalSinceNow: +(oneDay * days)];
  
    NSString *appointDateString = [dateFormatter stringFromDate:appointDate];
    
  
    return appointDateString;
    
}

@end
