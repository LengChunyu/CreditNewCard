//
//  NoPasteTextField.m
//  CreditCard
//
//  Created by liujingtao on 2020/3/6.
//  Copyright © 2020 liujingtao. All rights reserved.
//

#import "NoPasteTextField.h"

@implementation NoPasteTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//    if (action == @selector(paste:))
//        return NO;
//    return [super canPerformAction:action withSender:sender];
    
    return NO;
}
@end
