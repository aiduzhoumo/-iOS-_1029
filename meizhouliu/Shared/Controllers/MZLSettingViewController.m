//
//  MZLSettingViewController.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLSettingViewController.h"
#import "MZLTableViewHeaderViewForSetting.h"
#import "MZLSettingItemCell.h"
#import "MZLServices.h"
#import "UIViewController+MZLAdditions.h"
#import "MZLUserDetailResponse.h"
#import "MZLModelUserInfoDetail.h"
#import "MZLModelImage.h"
#import "UIImageView+MZLNetwork.h"
#import "MZLIntroductionViewController.h"
#import "MZLAuthorCoverPickerViewController.h"
#import "MZLImageUploadResponse.h"
#import "UIView+COAdditions.h"
#import "MZLSharedData.h"
#import "MZLAppUser.h"
#import "MZLModityNameViewController.h"

#define SEGUE_TO_INTRODUCTION @"toIntroduction"
#define SEGUE_TO_PASSWORD @"toPassword"
#define SEGUE_TO_AUTHOR_COVER_PICKER @"toAuthorCoverPicker"
#define SEGUE_TO_MODITYNAME @"toModityName"

@interface MZLSettingViewController () {
    MZLModelUserInfoDetail *_userDetail;
    UIImageView *_userHeaderImage;
}

@end

@implementation MZLSettingViewController

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
    _tv = self.tvSetting;
    self.tvSetting.visible = NO;
    [self inittableViewFoot];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyUserName:) name:@"modifyUserName" object:nil];
}

- (void)inittableViewFoot
{
    UIView *foot=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tvSetting.frame.size.width, self.view.frame.size.height-self.tvSetting.frame.size.height)];
    CGFloat BtnWidth = self.view.frame.size.width;
    CGFloat BtnHeight = 20.0;
    UIButton *agreementBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, foot.frame.size.height-BtnHeight, BtnWidth, BtnHeight)];
    [agreementBtn setTitle:@"用户协议" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [agreementBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [agreementBtn addTarget:self action:@selector(onclickAgreementBtn:) forControlEvents:UIControlEventTouchUpInside];
    [foot addSubview:agreementBtn];
    
    self.tvSetting.tableFooterView = foot;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (! self.tvSetting.visible) {
        [self showNetworkProgressIndicator:@"加载用户信息..."];
        [MZLServices userInfoServiceWithSuccBlock:^(NSArray *models) {
            [self hideProgressIndicator];
            _userDetail = ((MZLUserDetailResponse *)models[0]).user;
            MZLAppUser *appUser = [MZLSharedData appUser];
            appUser.user = ((MZLUserDetailResponse *)models[0]).user;
            [appUser saveInPreference];
            [self initInternal];
        } errorBlock:^(NSError *error) {
            [self onNetworkError];
        }];
    } else {
        [self setSexImage];
//        [_tvSetting reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)modifyUserName:(NSNotification *)noti {
    [self setName:noti.object];
}

#pragma mark - init

- (void)initInternal {
    [self.tvSetting setBackgroundColor:MZL_BG_COLOR()];
    self.tvSetting.visible = YES;
    MZLTableViewHeaderViewForSetting *tableHeader = [MZLTableViewHeaderViewForSetting headerViewInstance:CGSizeMake(self.tvSetting.width, 60)];
    self.tvSetting.tableHeaderView = tableHeader;
    tableHeader.lblNickName.text = _userDetail.nickName;
    [self setSexImage];
    [self.tvSetting reloadData];
}

- (void)setSexImage {
    MZLTableViewHeaderViewForSetting *tableHeader = (MZLTableViewHeaderViewForSetting *)_tvSetting.tableHeaderView;
    if (_userDetail.sex == MZLModelUserSexMale) {
        tableHeader.imgSex.image = [UIImage imageNamed:@"SexMale"];
    } else if (_userDetail.sex == MZLModelUserSexFemale) {
        tableHeader.imgSex.image = [UIImage imageNamed:@"SexFemale"];
    } else {
        tableHeader.imgSex.image = nil;
    }
}

- (void)setName:(NSString *)name {
    MZLTableViewHeaderViewForSetting *tableHeader = (MZLTableViewHeaderViewForSetting *)_tvSetting.tableHeaderView;
    tableHeader.lblNickName.text = name;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([SEGUE_TO_INTRODUCTION isEqualToString:segue.identifier]) {
        MZLIntroductionViewController *controller = (MZLIntroductionViewController *)segue.destinationViewController;
        controller.userDetail = _userDetail;
    }
    if ([SEGUE_TO_AUTHOR_COVER_PICKER isEqualToString:segue.identifier]) {
        MZLAuthorCoverPickerViewController *controller = (MZLAuthorCoverPickerViewController *)segue.destinationViewController;
        controller.userDetail = _userDetail;
    }
    if ([SEGUE_TO_MODITYNAME isEqualToString:segue.identifier]) {
        MZLModityNameViewController *controller = (MZLModityNameViewController *)segue.destinationViewController;
        controller.userDetail = _userDetail;
    }
}

#pragma mark - logout

- (void)userLogout {
    UIActionSheet *actionSheet =  [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:@"退出"
                                                     otherButtonTitles:nil];
    // Show the sheet
    [actionSheet showInView:self.view];
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MZLSettingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZLSettingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.lblTitle setTextColor:MZL_COLOR_BLACK_555555()];
        cell.imgHead.image = nil;
        if (indexPath.row == 0) {
            [cell.imgTitle setImage:[UIImage imageNamed:@"User"]];
            [cell.lblTitle setText:@"头像"];
            if (isEmptyString(_userDetail.headerImage.fileUrl)) {
                [cell.imgHead setImage:[UIImage imageNamed:@"DefaultUserHeader"]];
            } else {
                [cell.imgHead loadUserImageFromURL:_userDetail.headerImage.fileUrl];
            }
            _userHeaderImage = cell.imgHead;
            [_userHeaderImage toRoundShape];
        } else if (indexPath.row == 1) {
            [cell.imgTitle setImage:[UIImage imageNamed:@"Data"]];
            [cell.lblTitle setText:@"基本资料"];
        } else if (indexPath.row == 2) {
            [cell.imgTitle setImage:[UIImage imageNamed:@"Password"]];
            [cell.lblTitle setText:@"修改密码"];
        } else if (indexPath.row == 3) {
            [cell.imgTitle setImage:[UIImage imageNamed:@"modityName"]];
            [cell.lblTitle setText:@"修改昵称"];
        }
        return cell;
    }else if ([MZLSharedData appUser].user.level == 100 && indexPath.section == 1){
        MZLSettingItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZLSettingCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.lblTitle setTextColor:MZL_COLOR_BLACK_555555()];
        [cell.imgTitle setImage:[UIImage imageNamed:@"AuthorCover"]];
        [cell.lblTitle setText:@"设置封面"];
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZLSettingLogoutCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl = (UILabel *)[cell viewWithTag:100];
        lbl.textColor = colorWithHexString(@"f83030");
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([MZLSharedData appUser].user.level == 100) {
        return 3;
    }
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if ([[MZLSharedData appUser] isLoginFrom3rdParty]) {
            return 3;
        } else {
            return 4;
        }
    }
    return 1;
}

#pragma mark - table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 80.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 40.0;
    }
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self uploadHeaderImage];
        }
        else if (indexPath.row == 1) {
            [self performSegueWithIdentifier:SEGUE_TO_INTRODUCTION sender:self];
        }
        else if (indexPath.row == 2) {
            [self performSegueWithIdentifier:SEGUE_TO_PASSWORD sender:self];
        }
        else if (indexPath.row == 3) {
            [self performSegueWithIdentifier:SEGUE_TO_MODITYNAME sender:self];
        }
    
    }else if([MZLSharedData appUser].user.level == 100 && indexPath.section == 1) {
        [self performSegueWithIdentifier:SEGUE_TO_AUTHOR_COVER_PICKER sender:self];
    }
    else {
        [self userLogout];
    }
}

#pragma mark - UIActionSheetDelegate (logout)

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [MZLSharedData logout];
        
        [MZLSharedData removeAllIdsFromAttentionIds];
        //给服务进行极光注册
        [MZLServices registerJpushWithUser];
        
        [self dismissCurrentViewController];
    }
}

#pragma mark - upload user image

- (void)uploadHeaderImage {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)aImage editingInfo:(NSDictionary *)editingInfo {
    [picker dismissModalViewControllerAnimated:YES];
    [self showUpLoadingProgressIndicator];
    
//    NSLog(@"%@", NSStringFromCGSize(aImage.size));
   
    UIImage *image = [self compressAImageWithImage:aImage];

    [MZLServices uploadUserImageService:image succBlock:^(NSArray *models) {
        [self hideProgressIndicator];
        _userHeaderImage.image = image;
        [UIAlertView showAlertMessage:@"头像上传成功！"];
    } errorBlock:^(NSError *error) {
        [self hideProgressIndicator];
        [self onNetworkError];
    }];
}

- (UIImage *)compressAImageWithImage:(UIImage *)aImage {
 
    CGFloat oldWidth = aImage.size.width;
    CGFloat oldHeight = aImage.size.height;
    CGFloat newWidth = oldWidth > 300.0f ? 300.0f : oldWidth;
    CGFloat newHeight = oldHeight > 300.0f ? 300.0f : oldHeight;
    
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    UIGraphicsBeginImageContext(newSize);
    [aImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)onclickAgreementBtn:(id)sender
{
    [self performSegueWithIdentifier:@"toAgreement" sender:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end







