//
//  NetworkManager.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "NetworkManager.h"

static NSString * const YoudaoTranslateAPI = @"http://fanyi.youdao.com/openapi.do";
static NSString * const YoudaoAPIKey       = @"773991981";
static NSString * const YoudaoKeyFrom      = @"WordRecognition";

static NSString * const BaiduAPIKey    = @"TjVj1Spe9cFG4IGq717lMcSo";
static NSString * const BaiduSecretKey = @"1TnVfPW5lRdp05QaNG3NGXhKUneqGk1L";

static NSString *__access_token = nil;

@implementation NetworkManager

+ (NSURLSession *)sharedSession
{
    static NSURLSession *__shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 设置策略
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.URLCache = [NSURLCache sharedURLCache];
        config.requestCachePolicy = NSURLRequestReturnCacheDataElseLoad;
        config.HTTPShouldSetCookies = YES;
        
        //初始化自身的session
        __shared = [NSURLSession sessionWithConfiguration:config];
    });
    
    return __shared;
}

+ (NSURLSessionDataTask *)translate2English:(NSString *)word ok:(void (^)(NSString *english, NSError *error))block
{
    if (!word) {
        return nil;
    }
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@?keyfrom=%@&key=%@&type=data&doctype=json&version=1.1&q=%@", YoudaoTranslateAPI, YoudaoKeyFrom, YoudaoAPIKey, word] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *task = [[self sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *english = nil;
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSArray *array = dic[@"translation"];
            if (array.count > 0) {
                english = [array firstObject];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            block(english, error);
        });
    }];
    [task resume];
    return task;
}

+ (void)getAccessTokenFromBaidu:(void (^)(NSString *accessToken, NSError *error))block
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://openapi.baidu.com/oauth/2.0/token?grant_type=client_credentials&client_id=%@&client_secret=%@", BaiduAPIKey, BaiduSecretKey]];
    
    [[[self sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSString *access_token = dic[@"access_token"];
            __access_token = access_token;
            block(access_token, nil);
        } else {
            block(nil, error);
        }
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];
}

+ (void)uploadRecordFromURL:(NSString *)url ok:(void (^)(NSString *match, NSError *error))block
{
    
    NSDictionary *dic = @{@"format": @"wav",
                          @"rate": @(8000),
                          @"channel": @(1),
                          @"token": __access_token?:[NSString string],
                          @"cuid": @"WordRecognition",
                          @"len": @(4096)};
}

@end
