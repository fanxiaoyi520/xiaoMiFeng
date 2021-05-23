

#import <Foundation/Foundation.h>

//中英文字数限制结构体
struct HWTitleInfo {
    NSInteger length;
    NSInteger number;
};
typedef struct HWTitleInfo HWTitleInfo;



@interface NSString (Verify)

//防止字符串为空显示null，返回非nil字符串的方法
+(NSString *)returnNonemptyString:(NSString *)string;

- (BOOL) nullToString;//判断是否是空字符

- (BOOL) isBlankString;//判断是否是空字符

- (BOOL) isQQ;

- (BOOL) isPhone;

- (BOOL) isHongKongPhone;//判断是否香港手机号码

- (BOOL) isEmail;

-(BOOL) isValidPassword;//密码验证

-(BOOL) isIdentityCard;//身份证验证

-(BOOL) isAvailableURL;//可用的网址

-(BOOL) isVerificationCode;//是否是验证码

-(BOOL) is18NumCharacter;//是否是18位的数字和字母

-(BOOL) isAvailableName;//只允许输入纯中文（中文的•可加可不加）长度限制30位，或只允许输入纯英文（英文的.或空格可加可不加）长度限制60位则提示


-(BOOL) isPostCode;//是否是邮政编码

-(BOOL)isMatchPatternString:(NSString *)pattern;//是否符合规则的字符串


-(NSString *) isCurrencyTranslationChinese;//币种中文转换

-(NSString *) isCurrencyTranslationEnglish;//币种英文转换

//最多保留两位小数，小数点后末尾的0不要
+ (NSString *)removeSuffix:(NSString *)numberStr;

#pragma mark - 计算UILabel的高度(带有行间距的情况)
- (CGFloat)getSpaceLabelHeightWithFont:(CGFloat)font withWidth:(CGFloat)width lineSpacing:(NSInteger)nLineSpace ;

+ (CGFloat)getStrHeightWithFont:(CGFloat)font withWidth:(CGFloat)width withContentStr:(NSString *)contentStr;

#pragma mark - 计算文字宽度

- (CGFloat)calculateRowWidthFont:(CGFloat)font withHeight:(CGFloat)height;

//传入 秒  得到  xx分钟xx秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

//判断字符串是否为空
- (NSString *)confirm_empty;

#pragma mark - 设置文本文字对齐
+ (NSMutableAttributedString *)getAttr:(NSString *)str;

//字符串转json对象
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//检测当前字符串是否为有效url
- (BOOL)isUrl;

//字符串加密至MD5
+ (NSString *)md5:(NSString *)str;

// 处理大文件检测的MD5
+ (NSString *)md5OfFilePath:(NSString *)filePath;

// 计算不换行文字宽度
+ (CGFloat)widthForString:(NSString *)value;

//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)aStr;

//拼接成中间有空格的字符串（每四位加入一个空格）
+ (NSString *)jointWithString:(NSString *)str;

//时间字符串转换格式,--月--日 时：分
+(NSString *)dateStrConvertStr:(NSString *)dateString;

//时间字符串转换格式,--年--月--日 时：分
+(NSString *)dateStrConvertYYMMDDHHMMStr:(NSString *)dateString;

//计算两个日期的间隔
//+ (NSString *)numberOfDaysWithFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

//计算一个日期到现在的间隔
+ (NSString *)numberOfDaysIntervalFromDateToNowDate:(NSString *)fromDateStr;

//SGPagingView的计算字符串宽度
+ (CGFloat)SG_widthWithString:(NSString *)string font:(UIFont *)font;

/**
    金额分转元
 */
+ (NSString *)formatToTwoDecimal:(id)count;



//判断中英混合的的字符串长度及字符个数
- (HWTitleInfo)getInfoWithTextMaxLength:(NSInteger)maxLength;


@end
