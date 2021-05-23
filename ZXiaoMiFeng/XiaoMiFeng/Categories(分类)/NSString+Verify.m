

#import "NSString+Verify.h"
#import <CommonCrypto/CommonDigest.h>

// 这个分类类需要会使用。
@implementation NSString (Verify)


//防止字符串为空显示null，返回非nil字符串的方法
+(NSString *)returnNonemptyString:(NSString *)string{
    
    
    if ([string isKindOfClass:[NSNull class]] || string == NULL ||
        ([string isKindOfClass:[NSString class]] && [string isEqualToString:@"null"])) {

        return @"";
        
    }else{
        
        return string;
    }
    
    /*
    if ([string nullToString]) {
        
        return @"";
        
    }else{
        
        return string;
    }*/
    
    
    
}

//判断空字符串
-(BOOL)nullToString{
    
    
    if ([self isEqual:@"NULL"] || [self isKindOfClass:[NSNull class]] || [self isEqual:[NSNull null]] || [self isEqual:NULL] || [[self class] isSubclassOfClass:[NSNull class]] || self == nil || self == NULL || [self isKindOfClass:[NSNull class]] || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [self isEqualToString:@"<null>"] || [self isEqualToString:@"(null)"] || [self isEqual:@"null"]) {
        
        return YES;
        
    } else {
        
        return NO;
    }
}


//判断是否是空字符
- (BOOL) isBlankString{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (BOOL) isQQ {
//  QQ的匹配模式
    NSString *pattern = @"^[1-9]\\d{5,10}$";
    return [self matchWithPattern:pattern];
}

//只允许输入纯中文（中文的•可加可不加）长度限制30位，或只允许输入纯英文（英文的.或空格可加可不加）长度限制60位则提示
-(BOOL)isAvailableName{
    
//    NSString *pattern = @"^[\u4e00-\u9fcc·]{1,30}$|^[a-zA-Z .]{1,60}$";
    
//    NSString *pattern = @"^[\u4e00-\u9fcc ·]{0,30}$|^[a-zA-Z .]{0,60}$";
    
    //中文、英文包括下划线
    NSString *pattern = @"^[\u4E00-\u9FA5A-Za-z_]+$";
    
    return [self matchWithPattern:pattern];
}

- (BOOL) isPhone {
//    NSString *pattern = @"^(0|86)?1([358]\\d|7[678]|4[57])\\d{8}$";
    
    
    //比较精准的正则：^((13[0-9])|(14[5-9])|(15([0-3]|[5-9]))|(16[2,5,6,7])|(17[0-8])|(18[0-9])|(19[1|3|8|9]))\d{8}$
    
//    NSString *pattern = @"^(((13[0-9]{1})|(15[0-9]{1})|(18[0-9]{1})|(19[0-9]{1})|(17[0-9]{1})|(14[4-7]{1})|(16[0-9]{1}))+\\d{8})$";//更全面的校验正则
    
    //20200917更新版本正则
    NSString *pattern =     @"^(((13[0-9]{1})|(15[0-9]{1})|(16[2|5|6|7])|(18[0-9]{1})|(19[0-9]{1})|(17[0-9]{1})|(14[4-9]{1}))+\\d{8})$";
    
    
    return [self matchWithPattern:pattern];
}

-(BOOL)isHongKongPhone{
    
    //香港手机号码正则：^(4|5|6|7|8|9)\\d{7}$
    
    NSString *pattern = @"^(4|5|6|7|8|9)\\d{7}$";
    
    return [self matchWithPattern:pattern];
    
}

- (BOOL) isEmail{
    NSString  *pattern = @"^[a-z0-9]+([\\._\\-]*[a-z0-9])*@([a-z0-9]+\\-*[a-z0-9]+\\.){1,63}[a-z0-9]+$";
    return [self matchWithPattern:pattern];
}


//验证是否身份证
-(BOOL)isIdentityCard{
    //长度不为18的都排除掉
    if (self.length!=18) {
        return NO;
    }
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:self];
    if (!flag) {
        return flag; //格式错误
    }else{
        //格式正确在判断是否合法
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++){
            NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            idCardWiSum+= subStrIndex * idCardWiIndex;
        }
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        //得到最后一位身份证号码
        NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2){
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]){
                return YES;
            }else{
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]){
                return YES;
            }else{
                return NO;
            }
        }
    }
}

//6-12数字和字母的密码
-(BOOL) isValidPassword{
    
    //1、密码验证:字母+数字组合密码
//    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,12}";
//    return [self matchWithPattern:pattern];
    
    /*
    //2、只要求6 - 12位的字符，没有其他限制
    NSUInteger character = 0;
    for (int i = 0; i < [self length]; i++) {
        int a = [self characterAtIndex:i];
        
        if (a > 0x4e00 && a < 0x9fff) {//判断是否为中文
            character += 2;
        }else{
            character += 1;
        }
    }
    
    if (character >= 6 && character <= 12) {
        return YES;
    }else{
        return NO;
    }*/
    
    
    //3、6位纯数字
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"^[0-9]{6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
    
    
   
    // 4、密码验证:任意字母或数字6 - 11位
//    NSString *pattern = @"^[a-zA-Z0-9]{6,12}";
//    return [self matchWithPattern:pattern];
    
}

-(BOOL)is18NumCharacter{
    
//    只要求1 - 18位的字符，没有其他限制
        NSUInteger character = 0;
        for (int i = 0; i < [self length]; i++) {
            int a = [self characterAtIndex:i];
    
            if (a > 0x4e00 && a < 0x9fff) {//判断是否为中文
                character += 2;
            }else{
                character += 1;
            }
        }
    
        if (character >= 1 && character <= 18) {
            return YES;
        }else{
            return NO;
        }
    
}

//是否是验证码
-(BOOL) isVerificationCode{
    
    if (self.length == 0) {
        return NO;
    }
    NSString *regex = @"^[0-9]{4}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}

//可用的网址
-(BOOL)isAvailableURL{
    
    NSString *urlStr = [self getCompleteWebsite:self];
    
    static BOOL isAvailable;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"不可用");
            isAvailable = NO;
        }else{
            NSLog(@"可用");
            isAvailable = YES;
        }
    }];
    [task resume];
  
    return isAvailable;
}

//邮政编码
-(BOOL)isPostCode{
    
    NSString *pattern = @"^[1-9]\\d{5}(?!\\d)";
    
    return [self matchWithPattern:pattern];
    
}

//是否符合规则的字符串
-(BOOL)isMatchPatternString:(NSString *)pattern{
    
    return [self matchWithPattern:pattern];
}

//进行币种中文转换
-(NSString *)isCurrencyTranslationChinese{
    
    /*
     币种对应
     0702 SGD 新加坡币
     0156 CNY 人民币
     0344 HKD 港币
     */
    
    NSInteger currencyNum = [self integerValue];
    
    NSString *currencyStr;
    
    switch (currencyNum) {
        case 702:
            {
                currencyStr = XMFLI(@"新币");
            }
            break;
        
        case 156:
        {
            currencyStr = XMFLI(@"元");
        }
            break;
            
        case 344:
        {
            currencyStr = XMFLI(@"港币");
        }
            break;
            
        default:
            break;
    }
    
    
    return currencyStr;
}

//进行币种英文转换
-(NSString *)isCurrencyTranslationEnglish{
    
    /*
     币种对应
     0702 SGD 新加坡币
     0156 CNY 人民币
     0344 HKD 港币
     */
    
    NSInteger currencyNum = [self integerValue];
    
    NSString *currencyStr;
    
    switch (currencyNum) {
        case 702:
        {
            currencyStr = @"SGD";
        }
            break;
            
        case 156:
        {
            currencyStr = @"CNY";
        }
            break;
            
        case 344:
        {
            currencyStr = @"HKD";
        }
            break;
            
        default:
            break;
    }
    
    
    return currencyStr;
}

#pragma mark - ——————— 处理数据精度 ————————
/**
 过滤器/ 将.2f格式化的字符串，去除末尾0

 @param numberStr .2f格式化后的字符串
 @return 去除末尾0之后的
 */
+ (NSString *)removeSuffix:(NSString *)numberStr{
    
    //先对字符串进行.2f格式化
    double numberNum = [numberStr doubleValue];
        
    numberStr = [NSString stringWithFormat:@"%.2f",numberNum];
    
    
    if (numberStr.length > 1) {
        
        if ([numberStr componentsSeparatedByString:@"."].count == 2) {
            NSString *last = [numberStr componentsSeparatedByString:@"."].lastObject;
            if ([last isEqualToString:@"00"]) {
                numberStr = [numberStr substringToIndex:numberStr.length - (last.length + 1)];
                return numberStr;
            }else{
                if ([[last substringFromIndex:last.length -1] isEqualToString:@"0"]) {
                    numberStr = [numberStr substringToIndex:numberStr.length - 1];
                    return numberStr;
                }
            }
        }
        return numberStr;
    }else{
        return nil;
    }
}


#pragma mark - ——————— 验证网址 ————————
- (NSString *)getCompleteWebsite:(NSString *)urlStr{
    NSString *returnUrlStr = nil;
    NSString *scheme = nil;
    
    assert(urlStr != nil);
    
    urlStr = [urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (urlStr != nil) && (urlStr.length != 0) ) {
        NSRange  urlRange = [urlStr rangeOfString:@"://"];
        if (urlRange.location == NSNotFound) {
            returnUrlStr = [NSString stringWithFormat:@"http://%@", urlStr];
        } else {
            scheme = [urlStr substringWithRange:NSMakeRange(0, urlRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                returnUrlStr = urlStr;
            } else {
                //不支持的URL方案
            }
        }
    }
    return returnUrlStr;
}


/// 匹配字符串
/// @param pattern 匹配模式
- (BOOL) matchWithPattern:(NSString *) pattern {
    NSError *error = nil;
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (error) {
        //DLog(@"创建正则表达式失败%@",error);
        return NO;
    }
    
    //  匹配
    NSTextCheckingResult *results  = [regularExpression firstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
    if (results) {
        return YES;
    }else {
        return NO;
    }
}



#pragma mark - 计算UILabel的高度(带有行间距的情况)
- (CGFloat)getSpaceLabelHeightWithFont:(CGFloat)font withWidth:(CGFloat)width lineSpacing:(NSInteger)nLineSpace {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = nLineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
                          };
    
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
}

+ (CGFloat)getStrHeightWithFont:(CGFloat)font withWidth:(CGFloat)width withContentStr:(NSString *)contentStr
{
    CGSize infoSize = CGSizeMake(width, CGFLOAT_MAX);
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    //默认的
    CGRect infoRect =   [contentStr boundingRectWithSize:infoSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    // 参数1: 自适应尺寸,提供一个宽度,去自适应高度
    // 参数2:自适应设置 (以行为矩形区域自适应,以字体字形自适应)
    // 参数3:文字属性,通常这里面需要知道是字体大小
    // 参数4:绘制文本上下文,做底层排版时使用,填nil即可
    
    //上面方法在计算文字高度的时候可能得到的是带小数的值,如果用来做视图尺寸的适应的话,需要使用更大一点的整数值.取整的方法使用ceil函数
    return ceil(infoRect.size.height);
    
    
}


#pragma mark - 计算文字宽度

- (CGFloat)calculateRowWidthFont:(CGFloat)font withHeight:(CGFloat)height
{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};  //指定字号
    CGRect rect = [self boundingRectWithSize:CGSizeMake(0, height) /*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

//传入 秒  得到  xx分钟xx秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime {
    
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%.2ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%.2ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    return format_time;
    
}


//判断字符串是否为空
- (NSString *)confirm_empty
{
    
    
    if (!self) {
        return @"";
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if (!self.length) {
        return @"";
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [self stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return @"";
    }
    return self;
    
}

+ (NSMutableAttributedString *)getAttr:(NSString*)str {
    
    NSMutableParagraphStyle   *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.f];//行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;//文本对齐方式 左右对齐（两边对齐）
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [str length])];//设置段落样式
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0] range:NSMakeRange(0, [str length])];//设置字体大小
    
    [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleNone] range:NSMakeRange(0, [str length])];//这段话必须要添加，否则UIlabel两边对齐无效 NSUnderlineStyleAttributeName （设置下划线）
    
    return attributedString;
    
}

// 字符串转对象
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        DLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

- (BOOL)isUrl {
    
    if(self == nil) {
        return NO;
    }
    
    NSString *url;
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = self;
    }
    NSString *urlRegex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:url];
    
}

//字符串加密至MD5
+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

// 处理大文件检测的MD5
+ (NSString *)md5OfFilePath:(NSString *)filePath
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (!handle) {
        return @"";
    }
    
    CC_MD5_CTX md5;
    CC_MD5_Init(&md5);
    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: 256 ];
        CC_MD5_Update(&md5, [fileData bytes], (CC_LONG)[fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString *s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    
    return s;
}

// 计算不换行文字的宽度
+ (CGFloat)widthForString:(NSString *)value
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:11.f] constrainedToSize:CGSizeMake(CGFLOAT_MAX, 18.f) lineBreakMode:NSLineBreakByWordWrapping];
    return sizeToFit.width;
}

+  (BOOL)isBlankString:(NSString *)aStr {
    
    if (!aStr) {
        return YES;
    }
    if ([aStr isKindOfClass:[NSNull class]]) {
        return YES;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [aStr stringByTrimmingCharactersInSet:set];
    if (!trimmedStr.length) {
        return YES;
    }
    return NO;
}

#pragma mark - 拼接成中间有空格的字符串
+ (NSString *)jointWithString:(NSString *)str{
    
    
    NSString *getString = @"";
    
    int a = (int)str.length/4;
    int b = (int)str.length%4;
    int c = a;
    if (b>0)
    {
        c = a+1;
    }
    else
    {
        c = a;
    }
    for (int i = 0 ; i<c; i++)
    {
        NSString *string = @"";
        
        if (i == (c-1))
        {
            if (b>0)
            {
                string = [str substringWithRange:NSMakeRange(4*(c-1), b)];
            }
            else
            {
                string = [str substringWithRange:NSMakeRange(4*i, 4)];
            }
            
        }
        else
        {
            string = [str substringWithRange:NSMakeRange(4*i, 4)];
        }
        getString = [NSString stringWithFormat:@"%@ %@",getString,string];
    }
    return getString;
}


//时间字符串转换格式
+(NSString *)dateStrConvertStr:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    
    [newDateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    
    NSString *newDateString = [newDateFormatter stringFromDate:date];
    
    return newDateString;
}

//时间字符串转换格式,--年--月--日 时：分
+(NSString *)dateStrConvertYYMMDDHHMMStr:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc] init];
    
    [newDateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    NSString *newDateString = [newDateFormatter stringFromDate:date];
    
    return newDateString;
}

//计算两个日期的间隔
+ (NSString *)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    // 创建一个标准国际时间的日历
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 可根据需要自己设置时区.
    calendar.timeZone = [NSTimeZone systemTimeZone];
    // 获取两个日期的间隔
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay|NSCalendarUnitHour fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
//     NSInteger hour = (comp.hour - comp.day * 24);
//    return [NSString stringWithFormat:@"%ld天%ld小时", comp.day, hour];
    
     return [NSString stringWithFormat:@"%ld", comp.day];
    
//    return comp;
    
}

//计算两个日期的间隔
+ (NSString *)numberOfDaysIntervalFromDate:(NSString *)fromDateStr toDate:(NSString *)toDateStr{
    
    NSDate *now = [NSDate date];
    
    //时间格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSDate *fromDate = [fmt dateFromString:fromDateStr];
    
//    NSString *dateStr = [fmt stringFromDate:fromDate];
//    // 2014-10-18
//    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
//    NSDate *date = [fmt dateFromString:toDateStr];
    // 2014-10-18 00:00:00
   NSDate *nowDate = [fmt dateFromString:toDateStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:fromDate toDate:nowDate options:0];
    
//    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
    
    return [NSString stringWithFormat:@"%ld",cmps.day];
    
}

//计算一个日期到现在的间隔
+ (NSString *)numberOfDaysIntervalFromDateToNowDate:(NSString *)fromDateStr{
    
    //时间格式
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    //新格式的现在date
    NSDate *now = [NSDate date];
    
    NSString *nowDateStr = [fmt stringFromDate:now];
    
    NSDate *nowDate = [fmt dateFromString:nowDateStr];
    
    //起点date
    if ([self isBlankString:fromDateStr]) {//如果fromDateStr为空
        
        fromDateStr = nowDateStr;
    }
    
    NSDate *fromDate = [fmt dateFromString:fromDateStr];

    
    //计算两个date的间隔
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:fromDate toDate:nowDate options:0];
    
    //    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
    
    return [NSString stringWithFormat:@"%ld",cmps.day];
    
}


#pragma mark - - - 计算字符串宽度
+ (CGFloat)SG_widthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}


/**
    金额分转元
 */
+ (NSString *)formatToTwoDecimal:(id)count {
    NSString *originNumber;
    if ([count isKindOfClass:[NSString class]] || [count isKindOfClass:[NSNumber class]]) {
        NSInteger i = [count integerValue];
        originNumber = [NSString stringWithFormat:@"%ld",(long)i];
    } else {
        return @"0.00";
    }
    NSDecimalNumber *one = [NSDecimalNumber decimalNumberWithString:originNumber];
    NSDecimalNumber *two = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *thr = [one decimalNumberByDividingBy:two];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.positiveFormat = @",###.##";
    NSString *money = [formatter stringFromNumber:[NSNumber numberWithDouble:[thr doubleValue]]];
    
    NSString *result = [NSString stringWithFormat:@"%@",money];
    
    if (![result containsString:@"."]) {  //被整除的情况
        result = [NSString stringWithFormat:@"%@.00",result];
    } else {                              //小数不足两位
        NSArray *array = [result componentsSeparatedByString:@"."];
        NSString *subNumber = array.lastObject;
        if (subNumber.length == 1) {
            result = [NSString stringWithFormat:@"%@.%@0",array.firstObject, array.lastObject];
        }
    }
    return result;
}



#pragma mark - ——————— 中英混合长度及字符个数 ————————
//判断中英混合的的字符串长度及字符个数
- (HWTitleInfo)getInfoWithTextMaxLength:(NSInteger)maxLength{
    
    HWTitleInfo title;
    int length = 0;
    int singleNum = 0;
    int totalNum = 0;
    char *p = (char *)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            length++;
            if (length <= maxLength) {
                totalNum++;
            }
        }
        else {
            if (length <= maxLength) {
                singleNum++;
            }
        }
        p++;
    }
    
    title.length = length;
    title.number = (totalNum - singleNum) / 2 + singleNum;
    
    return title;
    
}


@end
