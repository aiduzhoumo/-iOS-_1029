//
//  MZLAuthorCoverPickerViewController.m
//  mzl_mobile_ios
//
//  Created by race on 14-9-18.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLAuthorCoverPickerViewController.h"
#import "MZLAuthorCoverCollectionViewCell.h"
#import "MZLModelImage.h"
#import "MZLUserDetailResponse.h"
#import "MZLServices.h"

#define MZL_AUTHOR_COVER_CELL @"MZLAuthorCoverCell"
static const NSInteger numberOfSections = 3;

@interface MZLAuthorCoverPickerViewController (){
    NSMutableArray *_models;
    MZLModelImage *_coverImage;
}

@end

@implementation MZLAuthorCoverPickerViewController

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
    [self initInternal];
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
     Get the new view controller using [segue destinationViewController].
     Pass the selected object to the new view controller.
}
*/
- (void)initInternal {
    [self.vwCollection setDelegate:self];
    [self.vwCollection setBackgroundColor:MZL_BG_COLOR()];
    [self.btnSetCover setTintColor:MZL_COLOR_BLACK_999999()];

    [self showNetworkProgressIndicator];
    [MZLServices authorCoversServiceWithSuccBlock:^(NSArray *models) {
        [self handleModelsOnLoad:models];
        [self.vwCollection reloadData];
        [self hideProgressIndicator];
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];
}

- (void)resetSelectedCover:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //取消原先封面的高亮状态
    MZLAuthorCoverCollectionViewCell *selectedCell = (MZLAuthorCoverCollectionViewCell *)[collectionView viewWithTag: TAG_AUTHOR_COVER_SELECTED];
    if (selectedCell != nil) {
        selectedCell.selectedImage.visible = NO;
    }
    
    MZLAuthorCoverCollectionViewCell *cell = (MZLAuthorCoverCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedImage.visible = YES;
    _coverImage = cell.coverImage;
    if (_coverImage != nil) {
        self.btnSetCover.tintColor = MZL_COLOR_YELLOW_FDD414();
    }
}

#pragma mark - protected for LocationItemCell

- (MZLAuthorCoverCollectionViewCell *)authorCoverCollectionViewCellAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger indexOfModels = (indexPath.section) * (_models.count/numberOfSections) + indexPath.row;
    return [self authorCoverCollectionViewCellAtIndexPath:indexPath covers:[self modelObjectForIndexPath:indexOfModels]];
}

- (MZLAuthorCoverCollectionViewCell *)authorCoverCollectionViewCellAtIndexPath:(NSIndexPath *)indexPath covers:(MZLModelImage *)imageModel {
    MZLAuthorCoverCollectionViewCell *cell = [self.vwCollection dequeueReusableCellWithReuseIdentifier:MZL_AUTHOR_COVER_CELL forIndexPath:indexPath];
    if (! cell.isVisted) {
        [cell updateOnFirstVisit:imageModel currentImageId:self.userDetail.coverImage.identifier];
    }
    [cell updateContentWithCoversImage:imageModel.fileUrl];
    return cell;
}

- (id)modelObjectForIndexPath:(NSInteger )indexOfModels {
    return _models[indexOfModels];
}

#pragma mark - protected for load

- (NSMutableArray *)mapModelsOnLoad:(NSArray *)modelsFromSvc {
    return [NSMutableArray arrayWithArray:modelsFromSvc];
}

- (void)handleModelsOnLoad:(NSArray *)modelsFromSvc {
    _models = [self mapModelsOnLoad:modelsFromSvc];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _models.count/numberOfSections;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return numberOfSections;
}

//定义每个UICollectionView 的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section == _models.count/numberOfSections) {
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self authorCoverCollectionViewCellAtIndexPath:indexPath];
}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self resetSelectedCover:collectionView didSelectItemAtIndexPath:indexPath];
}

//UICollectionView取消选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    MZLAuthorCoverCollectionViewCell *cell = (MZLAuthorCoverCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedImage.visible = NO;
}

- (IBAction)setCover:(id)sender {
    if(_coverImage == nil){
        return;
    }
    [self showWorkInProgressIndicator];
    [MZLServices updateCoverWithCoverId:_coverImage.identifier succBlock:^(NSArray *models) {
        [self hideProgressIndicator];
        self.userDetail.coverImage = _coverImage;
        [self dismissCurrentViewController];
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];
}

@end
