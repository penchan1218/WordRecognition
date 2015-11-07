//
//  LookThroughCardViewController.m
//  WordRecognition
//
//  Created by 陈颖鹏 on 15/11/8.
//  Copyright © 2015年 陈颖鹏. All rights reserved.
//

#import "LookThroughCardViewController.h"
#import "CardViewController.h"

@interface LookThroughCardViewController () {
    CGFloat previewHeight;
}

@property (nonatomic, strong) NSMutableArray *containers;
@property (nonatomic, strong) NSMutableArray *previews;

@property (nonatomic, assign) NSInteger currPage;

@end

@implementation LookThroughCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadWords];
}

- (void)loadWords
{
    // 数据库读入
    NSArray *words = @[@"人们", @"动物", @"世界"];
    for (NSInteger i = 0; i < words.count; i++) {
        CardViewController *cardvc = self.containers[i];
        cardvc.name = words[i];
        
        UIImageView *imgView = self.previews[i];
        imgView.image = [UIImage imageNamed:@"img_card_bg"];
    }
    
    [self.scroll_bg setContentSize:CGSizeMake(self.scroll_bg._width*words.count, 1)];
    [self.scroll_preview setContentSize:CGSizeMake(previewHeight*words.count, 1)];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    previewHeight = 60.0;
    
    [self setupUI];
    [self setupContainers];
    [self setupPreviews];
}

- (void)setupUI
{
    // 背景，可切换的scrollView
    UIScrollView *scroll_bg = [[UIScrollView alloc] init];
    scroll_bg.pagingEnabled = YES;
    scroll_bg.clipsToBounds = YES;
    scroll_bg.showsVerticalScrollIndicator = NO;
    scroll_bg.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll_bg];
    self.scroll_bg = scroll_bg;
    
    [scroll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.top.equalTo(scroll_bg.superview);
        make.bottom.equalTo(scroll_bg.superview).with.offset(-previewHeight);
    }];
    
    
    UIScrollView *scroll_preview = [[UIScrollView alloc] init];
    scroll_preview.delegate = self;
    scroll_preview.showsVerticalScrollIndicator = NO;
    scroll_preview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll_preview];
    self.scroll_preview = scroll_preview;
    
    [scroll_preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.and.bottom.equalTo(scroll_preview.superview);
        make.top.equalTo(scroll_bg.mas_bottom);
    }];
    
    [scroll_preview setContentInset:UIEdgeInsetsMake(0, SCREEN_WIDTH/2-previewHeight/2, 0, SCREEN_WIDTH/2-previewHeight/2)];
}

- (void)setupContainers
{
    [self.scroll_bg setNeedsLayout];
    [self.scroll_bg layoutIfNeeded];
    
    self.containers = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        CardViewController *cardVC = [[CardViewController alloc] init];
        cardVC.tag = i;
        [self.scroll_bg addSubview:cardVC.view];
        [self.containers addObject:cardVC];
        
        cardVC.view.frame = CGRectOffset(self.scroll_bg.frame, i*self.scroll_bg._width, 0);
    }
}

- (void)setupPreviews
{
    [self.scroll_preview setNeedsLayout];
    [self.scroll_preview layoutIfNeeded];
    
    self.previews = [NSMutableArray array];
    for (NSInteger i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.tag = i;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.clipsToBounds = YES;
        [self.scroll_preview addSubview:imgView];
        [self.previews addObject:imgView];
        
        imgView.frame = CGRectOffset(CGRectMake(0, 0, previewHeight, previewHeight), previewHeight*i, 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (scrollView == self.scroll_preview) {
        // 移动下面
        [self.scroll_bg setScrollEnabled:NO];
        self.currPage = offsetX/previewHeight;
        [self.scroll_bg setScrollEnabled:YES];
    } else if (scrollView == self.scroll_bg) {
        // 移动上面
        [self.scroll_preview setScrollEnabled:NO];
        self.currPage = offsetX/self.scroll_bg._width;
        [self.scroll_preview setScrollEnabled:YES];
    }
}

- (void)setCurrPage:(NSInteger)currPage
{
    
}

@end
