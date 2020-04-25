//
//  CardCreatImage.h
//  CreditCard
//
//  Created by lengchunyu on 19/1/1.
//  Copyright © 2019年 lengchunyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CardCreatImage : NSObject
+ (UIImage*)creatImageFromColors:(NSArray*)colors ByGradientType:(GradientType)gradientType withFrame:(CGRect)frame;
@end
