//
//  NSString+Process.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "NSString+Process.h"

@implementation NSString (Process)

- (NSString *)pinyin
{
    NSMutableString *pinyin = [self mutableCopy];
    //转换成拼音
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    //去掉音调
//    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripDiacritics, NO);
    return pinyin;
}

@end
