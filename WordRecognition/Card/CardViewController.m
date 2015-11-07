//
//  CardViewController.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/7.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "CardViewController.h"

#import "NetworkManager.h"

#import "NSString+Process.h"

@interface CardViewController ()

@property (nonatomic, strong) NSMutableArray *array_pinyin;
@property (nonatomic, strong) NSMutableArray *array_name;

@property (nonatomic, weak) UILabel *lbl_english;

@end

@implementation CardViewController

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        self.array_pinyin = [NSMutableArray array];
        self.array_name = [NSMutableArray array];
        
        self.name = name;
        self.pinyin = [self.name pinyin];
        
        // 获取翻译
        __weak typeof(self) weakSelf = self;
        [NetworkManager translate2English:self.name ok:^(NSString *english, NSError *error) {
            if (error) {
                NSLog(@"翻译出错:%@", error.localizedDescription);
            } else {
                weakSelf.english = english;
            }
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 初始化UI
    [self setupUI];
}

- (void)setupUI
{
    // 背景
    UIImageView *imgView_bg = [[UIImageView alloc] init];
    imgView_bg.contentMode = UIViewContentModeScaleAspectFill;
    imgView_bg.image = [UIImage imageNamed:@"img_card_bg"];
    [self.view addSubview:imgView_bg];
    self.imgView_bg = imgView_bg;
    
    [imgView_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // 识别的图片
    UIImageView *imgView_staff = [[UIImageView alloc] init];
    imgView_staff.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:imgView_staff];
    self.imgView_staff = imgView_staff;
    
    [imgView_staff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView_staff.superview).offset(213);
        make.centerX.equalTo(imgView_staff.superview);
        make.size.mas_equalTo(CGSizeMake(300, 400));
    }];
}

- (UILabel *)newLabelOfFontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter and setter

- (void)setName:(NSString *)name
{
    _name = [name copy];
    
    if (name.length > 0) {
        for (NSInteger i = 0; i < name.length; i++) {
            UILabel *lbl_hanzi = [self newLabelOfFontSize:50.0];
            lbl_hanzi.text = [name substringWithRange:NSMakeRange(i, 1)];
            [self.array_name addObject:lbl_hanzi];
            
            [lbl_hanzi sizeToFit];
        }
        
        [self replaceHanziLabels];
    }
}

- (void)setPinyin:(NSString *)pinyin
{
    _pinyin = [pinyin copy];
    
    if (pinyin.length > 0) {
        NSArray *components = [pinyin componentsSeparatedByString:@" "];
        for (NSInteger i = 0; i < MIN(components.count, self.array_name.count); i++) {
            UILabel *lbl_pinyin = [self newLabelOfFontSize:28];
            lbl_pinyin.text = components[i];
            [self.array_pinyin addObject:lbl_pinyin];
            
            UILabel *lbl_hanzi = self.array_name[i];
            [lbl_pinyin sizeToFit];
            lbl_pinyin.center = lbl_hanzi.center;
            lbl_pinyin._top = 44.0;
        }
    }
}

- (void)setEnglish:(NSString *)english
{
    _english = [english copy];
    
    if (english.length > 0) {
        UILabel *lbl_english = [self newLabelOfFontSize:30];
        lbl_english.text = english;
        self.lbl_english = lbl_english;
        
        [lbl_english sizeToFit];
        lbl_english._centerX = SCREEN_WIDTH/2;
        lbl_english._top = 137.0;
    }
}

- (void)replaceHanziLabels
{
    CGFloat width = SCREEN_WIDTH;
    CGFloat dist  = 21.0;
    CGFloat top   = 79.0;
    
    UILabel *middleWord = nil;
    if (self.name.length%2 != 0) {
        // 奇数个字
        middleWord._right = width/2-dist/2;
        middleWord._top   = top;
    }
    if (self.name.length > 1) {
        NSString *leftParts = [self.name substringToIndex:self.name.length/2];
        NSString *rightParts = [self.name substringFromIndex:self.name.length/2];
        
        UILabel *nextLabel = middleWord?:nil;
        for (NSInteger i = leftParts.length-1; i >= 0; i--) {
            UILabel *label = self.array_name[i];
            if (nextLabel) {
                label._right = nextLabel._left-dist;
                label._top   = nextLabel._top;
            } else {
                label._right = width/2-dist/2;
                label._top   = top;
            }
            nextLabel = label;
        }
        
        UILabel *lastLabel = middleWord?:nil;
        for (NSInteger i = rightParts.length; i > 0; i--) {
            UILabel *label = self.array_name[self.name.length-i];
            if (lastLabel) {
                label._left = lastLabel._right+dist;
                label._top  = lastLabel._top;
            } else {
                label._left = width/2+dist/2;
                label._top  = top;
            }
            lastLabel = label;
        }
    }
}

@end
