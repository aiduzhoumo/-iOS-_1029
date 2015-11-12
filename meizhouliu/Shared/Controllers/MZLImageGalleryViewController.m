//
//  MZLImageGalleryViewController.m
//  mzl_mobile_ios
//
//  Created by race on 14-8-20.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLImageGalleryViewController.h"
#import "MZLImageGalleryNavigationController.h"
#import "UIBarButtonItem+COAdditions.h"
#import "MZLServices.h"
#import "MZLModelLocationBase.h"
#import "MZLPagingSvcParam.h"
#import "MZLModelImage.h"
#import "UIImageView+MZLNetwork.h"

@interface MZLImageGalleryViewController () {
    BOOL _isLoadingNextPageOfImages;
    NSMutableArray *_allPhotos;
}

//@property (nonatomic, readonly) NSMutableArray *allPhotos;

@end

#define kPTDemoSourceKey        @"source"
#define kPTDemoSizeKey          @"size"
#define kPTDemoThumbnailKey     @"thumbnail"
#define kPTDemoCaptionKey       @"caption"

@implementation MZLImageGalleryViewController

//@synthesize allPhotos = _allPhotos;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.toolbar setTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]];
    self.navigationItem.rightBarButtonItem = [self backBarButtonItem];
    [self.previousButton setImage:[UIImage imageNamed:@"PreviousArrowWhite"]];
    [self.nextButton setImage:[UIImage imageNamed:@"NextArrowWhite"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)setTitle:(NSString *)title {
    NSString *newTitle = [title stringByReplacingOccurrencesOfString:@" of " withString:@"  /  "];
    [super setTitle:newTitle];
}

- (UIBarButtonItem *)backBarButtonItem {
    return [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
}

- (void)back {
    [self dismissViewControllerAnimated:YES completion:^{
        if ([[UIApplication sharedApplication] isStatusBarHidden]) {
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
    return YES;
}

- (void)addPhotos:(NSArray *)photos {
    if (! _allPhotos) {
        _allPhotos = [[NSMutableArray alloc] init];
    }
    [_allPhotos addObjectsFromArray:photos];
}

- (void)loadNextPageOfImagesIfNecessary {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (! _isLoadingNextPageOfImages) {
            _isLoadingNextPageOfImages = YES;
            NSInteger nextPage = _allPhotos.count / MZL_IMAGE_GALLERY_SVC_FETCH_SIZE + 1;
            MZLPagingSvcParam *pagingParam = [MZLPagingSvcParam pagingSvcParamWithPageIndex:nextPage fetchCount:MZL_IMAGE_GALLERY_SVC_FETCH_SIZE];
            [MZLServices locationPhotosService:self.location pagingParam:pagingParam succBlock:^(NSArray *models) {
                _isLoadingNextPageOfImages = NO;
                NSArray *photos = [models map:^id(id object) {
                    return [object fileUrl];
                }];
                [self addPhotos:photos];
            } errorBlock:^(NSError *error) {
                _isLoadingNextPageOfImages = NO;
            }];
        }
    });
}

#pragma mark - PTImageAlbumViewDataSource

- (NSInteger)numberOfImagesInAlbumView:(PTImageAlbumView *)imageAlbumView
{
    return self.totalPhotoCount;
}

- (CGSize)imageAlbumView:(PTImageAlbumView *)imageAlbumView sizeForImageAtIndex:(NSInteger)index
{
    return CGSizeMake(CO_SCREEN_WIDTH, 300);
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForImageAtIndex:(NSInteger)index
{
    // 当已经浏览到当前图片总数的80%，开始加载新的一页
    NSInteger currentPhotoCount = _allPhotos.count;
    if (index + 1 >= (int)(currentPhotoCount * 0.8)) {
        [self loadNextPageOfImagesIfNecessary];
    }
    
    if (index + 1 >= currentPhotoCount) {
        return nil;
    }
    return _allPhotos[index];
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView sourceForThumbnailImageAtIndex:(NSInteger)index
{
    return nil;
}

- (NSString *)imageAlbumView:(PTImageAlbumView *)imageAlbumView captionForImageAtIndex:(NSInteger)index
{
    return @" ";
}

@end
