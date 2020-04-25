//
//  RGBHelper.h
//  CreditCard
//  Copyright © 2019年 lengchunyu. All rights reserved.

#ifndef RGBHelper_h
#define RGBHelper_h

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorWithRGB(R,G,B) [UIColor \
colorWithRed:((float)R)/255.0 \
green:((float)G)/255.0 \
blue:((float)B)/255.0 alpha:1.0]
#define APPGreenColor [UIColor colorWithRed:40.0/255.0 green:205.0/255.0 blue:167.0/255.0 alpha:1]
#define APPGreenColorBg [UIColor colorWithRed:19.0/255.0 green:205.0/255.0 blue:167.0/255.0 alpha:0.4]
#define APPGreenColorBgT [UIColor colorWithRed:19.0/255.0 green:205.0/255.0 blue:167.0/255.0 alpha:0]
#define APPGreenColorBgH [UIColor colorWithRed:19.0/255.0 green:205.0/255.0 blue:167.0/255.0 alpha:0.3]
#endif /* RGBHelper_h */
