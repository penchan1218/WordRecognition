//
//  YQImagePageViewController.m
//  YuanQuan
//
//  Created by 陈颖鹏 on 15/10/10.
//
//

#import "YQImagePageViewController.h"
#import "CardView.h"

#import "YTOperations.h"

#import "UIView+BGTouchView.h"
#import "UIImage+Resize.h"
//#import "YQNotificationPoster.h"

#define MIN_ZOOM 1.0
#define MAX_ZOOM 2.0

#define TAG_OUTERSCROLLVIEW 1000

@interface YQImagePageViewController () {
    CGFloat width_scrollView;
    CGFloat height_scrollView;
    
    CGFloat inset_beyondBound;
}

@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) NSMutableArray *scrollViews;

@property (nonatomic, assign) BOOL naviBarHide;

@end

@implementation YQImagePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 设置背景色
    self.view.backgroundColor = [UIColor blackColor];
    // UI布置
    [self setupUI];
    // 开始加载图片
    [self startLoadingImages];
    
    // 点击手势
    __weak typeof(self) weakSelf = self;
    [self.view touchEndedBlock:^(UIView *selfView) {
        [weakSelf handleNaviBar];
    }];
    
    [self.view longPressEndedBlock:^(UIView *selfView) {
        [weakSelf shouldSavePhoto];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [YQNotificationPoster postNotification_fadeHideNaviBar_withObj:self];
    self.navigationController.navigationBarHidden = NO;
    self.toolBar.hidden = NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self action:@selector(backAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editCard)];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", (unsigned long)(self.selectedIndex+1), (unsigned long)self.numOfImages];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [YQNotificationPoster postNotification_fadeShowNaviBar_withObj:self];
    self.navigationController.navigationBarHidden = NO;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editCard
{
    
}

- (void)scrollToPage:(NSInteger)page
{
    [self.scrollView setContentOffset:CGPointMake(width_scrollView*page, 0) animated:NO];
}

- (void)handleNaviBar
{
    if (!self.naviBarHide) {
//        [YQNotificationPoster postNotification_fadeHideNaviBar_withObj:self];
        self.navigationController.navigationBarHidden = YES;
        self.toolBar.hidden = YES;
    } else {
//        [YQNotificationPoster postNotification_fadeShowNaviBar_withObj:self];
        self.navigationController.navigationBarHidden = NO;
        self.toolBar.hidden = NO;
    }
    
    self.naviBarHide = !self.naviBarHide;
}

- (void)shouldSavePhoto
{
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil
                                                    delegate:self
                                           cancelButtonTitle:@"取消" destructiveButtonTitle:nil
                                           otherButtonTitles:@"保存图片", nil];
    [as showInView:self.view];
}

- (void)setupUI
{
    inset_beyondBound = 10.0;
    width_scrollView  = SCREEN_WIDTH + inset_beyondBound*2;
    height_scrollView = SCREEN_HEIGHT;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-inset_beyondBound, 0, width_scrollView, height_scrollView)];
    scrollView.tag                            = TAG_OUTERSCROLLVIEW;
    scrollView.delegate                       = self;
    scrollView.pagingEnabled                  = YES;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [scrollView setContentSize:CGSizeMake(width_scrollView*self.numOfImages, 1)];
    self.scrollView = scrollView;
    
    self.cards = [NSMutableArray array];
    self.scrollViews = [NSMutableArray array];
    for (NSInteger i = 0; i < self.numOfImages; i++) {
        UIScrollView *innerScrollView = [self newInnerScrollView];
        innerScrollView.tag           = i;
        innerScrollView._left         = width_scrollView*i+10;
        [self.scrollView addSubview:innerScrollView];
    }
    
    [self scrollToPage:self.selectedIndex];
    
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-49, SCREEN_WIDTH, 49)];
//    [self.view addSubview:toolBar];
//    self.toolBar = toolBar;
    
//    UIBarButtonItem *photosBtn = [[UIBarButtonItem alloc] initWithTitle:@"Photos" style:UIBarButtonItemStylePlain target:self action:@selector(photosAction)];
//    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *trashBtn = [[UIBarButtonItem alloc] initWithTitle:@"Trash" style:UIBarButtonItemStylePlain target:self action:@selector(trashAction)];
//    [toolBar setItems:@[photosBtn, flexItem, trashBtn]];
}

- (void)photosAction
{
    
}

- (void)trashAction
{
    
}

/**
 *  要嵌套scrollView才能实现放大缩小效果
 *
 *  @return inner scrollView
 */
- (UIScrollView *)newInnerScrollView
{
    UIScrollView *innerScrollView                  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height_scrollView)];
    innerScrollView.showsVerticalScrollIndicator   = NO;
    innerScrollView.showsHorizontalScrollIndicator = NO;
    innerScrollView.delegate                       = self;
    innerScrollView.minimumZoomScale               = MIN_ZOOM;
    innerScrollView.maximumZoomScale               = MAX_ZOOM;
    
    CardView *card = [[CardView alloc] initWithFrame:innerScrollView.bounds];
    [innerScrollView addSubview:card];
    
    [self.cards addObject:card];
    [self.scrollViews addObject:innerScrollView];
    
    return innerScrollView;
}

- (void)startLoadingImages
{
    NSArray *names = @[@"card_res00", @"card_res01", @"card_res02", @"card_res03", @"card_res04", @"card_res05", @"card_res06"];
    for (NSInteger i = 0; i < MIN(names.count, self.numOfImages); i++) {
        CardView *card = self.cards[i];
        // load images
        UIImage *image = [UIImage imageNamed:names[i]];
        card.imgView_staff.image = image;
        [YTOperations identifyImage:[UIImage cutImage:image size:CGSizeMake(200, 200)] ok:^(NSArray *array, NSError *error) {
            if (array.count > 0) {
                YTTagModel *model = array[0];
                card.name = model.tag_name;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate - scroll view

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == TAG_OUTERSCROLLVIEW) {
        NSInteger lastPage = self.selectedIndex;
        NSInteger nextPage = scrollView.contentOffset.x / (SCREEN_WIDTH);
        if (lastPage != nextPage) {
            // 翻页
            for (NSInteger i = 0; i < self.numOfImages; i++) {
                UIScrollView *innerScrollView = self.scrollViews[i];
                [innerScrollView setZoomScale:MIN_ZOOM animated:YES];
            }
        }
        
        self.selectedIndex = nextPage;
        self.navigationItem.title = [NSString stringWithFormat:@"%ld/%ld", (unsigned long)(self.selectedIndex+1), (unsigned long)self.numOfImages];
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (scrollView.tag == TAG_OUTERSCROLLVIEW) {
        return nil;
    }
    
    return self.cards[scrollView.tag];
}

#pragma mark - delegate - action sheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 保存图片
        [self savePhoto];
    }
}

- (void)savePhoto
{
//    UIImage *img = [(UIImageView *)(self.cards[self.selectedIndex]) image];
//    if (img) {
//        UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *hudTxt = error?@"保存失败":@"已存入手机相册";
    NSLog(@"%@", hudTxt);
}

@end
