//
//  MZLAuthorCoverPickerViewController.h
//  mzl_mobile_ios
//
//  Created by race on 14-9-18.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLBaseViewController.h"


@class MZLModelUserInfoDetail;

@interface MZLAuthorCoverPickerViewController : MZLBaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnSetCover;
@property (weak, nonatomic) IBOutlet UICollectionView *vwCollection;
- (IBAction)setCover:(id)sender;

@property MZLModelUserInfoDetail *userDetail;


@end
