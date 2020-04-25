//
//  JVCCreatImage.h
//  CloudSEENew
//
//  Created by David on 16/7/6.
//  Copyright © 2016年 baoym. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JVCCreatImage : NSObject
+ (UIImage*)creatImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType withFrame:(CGRect)frame;
@end
