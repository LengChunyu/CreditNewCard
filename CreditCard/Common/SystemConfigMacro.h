//
//  SystemConfigMacro.h
//  Copyright (c) 2019年 lengchunyu. All rights reserved.
/**
 *  判刑是否是iphone5设备
 */

#define ipad ([[UIDevice currentDevice].model rangeOfString:@"iPad"].location != NSNotFound?YES:NO)

//#define iphone4s  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 960),[[UIScreen mainScreen] currentMode].size):NO)
//
//
//#define iphone5  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size):NO)
//
//#define iphone5Plus  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size)|| (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size))||CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size):NO)
//
//
//#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
//
//#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)
//
//#define iphoneX  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen] currentMode].size):NO)
//#define iphoneXS  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(1125, 2436),[[UIScreen mainScreen] currentMode].size):NO)
//#define iphoneXSM  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(1242, 2688),[[UIScreen mainScreen] currentMode].size):NO)
//#define iphoneXR  ([UIScreen instancesRespondToSelector:@selector(currentMode)]? CGSizeEqualToSize(CGSizeMake(828, 1792),[[UIScreen mainScreen] currentMode].size):NO)

#define WIDTHRATIO \
MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)/720.0f

#define HEIGHTRATIO \
((iphoneX || iphoneXS || iphoneXSM || iphoneXR) ? MIN([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)/720.0f : MAX([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)/1280.0f)

#define HEIGHTRATION \
MAX([[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height)/1280.0f

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define SingletonH + (instancetype)sharedInstance;


#define SingletonM  \
static id _instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone\
{\
    static dispatch_once_t onceToken ;\
    dispatch_once(&onceToken, ^{ \
        _instance = [super allocWithZone:zone];\
    });\
    return _instance;\
}\
+ (instancetype)sharedInstance\
{\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        _instance = [[self alloc]init];\
    });\
    return _instance;\
    \
}\
+ (id) copyWithZone:(struct _NSZone *)zone\
{\
    return _instance;\
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define MB_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define LABEL_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define LABEL_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
#endif

#define IOS7    7.0
#define IOS6    6.0


#define IOS8    IOS_VERSION >= 8.0 ? YES : NO

#define IOS9    IOS_VERSION >= 9.0 ? YES : NO

#define IOS10    IOS_VERSION >= 10.0 ? YES : NO

#define LESSIOS10    IOS_VERSION < 10.0 ? YES : NO

#define IOS11       IOS_VERSION >= 11.0 ? YES : NO

#define IOS11_3     IOS_VERSION >= 11.3 ? YES : NO

#define ISIOS7     IOS_VERSION >= 7.0 ? YES : NO

#define SETCOLOR(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];

#define mainSize    [UIScreen mainScreen].bounds.size

static const  NSString *kDeviceState            = @"DeviceState";//修改小助手问题

#define RGBConvertColor(R,G,B,Alpha) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:Alpha]

#define SETLABLERGBCOLOUR(X,Y,Z) [UIColor colorWithRed:X/255.0 green:Y/255.0 blue:Z/255.0
//获取本地语言
#define LocalLanguage [((NSArray *)[[NSUserDefaults standardUserDefaults]objectForKey:@"AppleLanguages"])firstObject]
// 去掉string前后的空格
#define stringTrim(str) [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]

#define FIRST_80_VERSION 2007918

