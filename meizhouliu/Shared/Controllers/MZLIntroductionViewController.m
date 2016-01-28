//
//  MZLIntroductionViewController.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLIntroductionViewController.h"
#import "MZLIntroductionItemCell.h"
#import "MZLServices.h"
#import "UIViewController+COTextFieldDelegate.h"
#import "MZLServiceResponseObject.h"
#import "MZLModelUserInfoDetail.h"

#define MZL_USER_GENDER_MAN @"男"
#define MZL_USER_GENDER_FEMALE @"女"

#define PLACEHOLDER_TEXT @"填写你的个人简介"

@interface MZLIntroductionViewController () {
    __weak UITextView *_txtViewUserIntro;
    __weak UILabel *_lblSexDetail;
    __weak UILabel *_lblPlaceHolder;
    SBPickerSelector *_picker;
}

@end

@implementation MZLIntroductionViewController

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
    [self.tvIntro setBackgroundColor:MZL_BG_COLOR()];
    [self.tvIntro addTapGestureRecognizerToDismissKeyboard];
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

#pragma mark - helper methods

- (void)setSex {
    if (self.userDetail.sex == MZLModelUserSexMale) {
        _lblSexDetail.text = MZL_USER_GENDER_MAN;
    } else if (self.userDetail.sex == MZLModelUserSexFemale) {
        _lblSexDetail.text = MZL_USER_GENDER_FEMALE;
    } else {
        _lblSexDetail.text = @"未设置";
    }
}

#pragma mark - text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    CGRect frame = self.tvIntro.frame;
    frame.origin.y -=40;
    frame.size.height +=40;
     NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.tvIntro.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidEndEditing:(UITextField *)textField {
    CGRect frame = self.tvIntro.frame;
    frame.origin.y +=40;
    frame.size.height -=40;
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.tvIntro.frame = frame;
    [UIView commitAnimations];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        _lblPlaceHolder.text = PLACEHOLDER_TEXT;
    } else {
        _lblPlaceHolder.text = @"";
    }
}

- (void)showSexPicker {
    [self dismissKeyboard];
    if (! _picker) {
        _picker = [SBPickerSelector picker];
        _picker.pickerData = [@[@"男", @"女"] mutableCopy]; //picker content
        _picker.delegate = self;
        _picker.pickerType = SBPickerSelectorTypeText;
        _picker.doneButtonTitle = MZL_MSG_OK;
        _picker.cancelButtonTitle = MZL_MSG_CANCLE;
    }
    [_picker showPickerOver:self];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MZLIntroductionItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZLIntroSexCell"];
        [cell.lblSex setTextColor:MZL_COLOR_BLACK_555555()];
        [cell.lblSexDetail setTextColor:MZL_COLOR_BLACK_555555()];
        _lblSexDetail = cell.lblSexDetail;
        [cell.contentView addTapGestureRecognizer:self action:@selector(showSexPicker)];
        [cell.imgSex setImage:[UIImage imageNamed:@"Gender"]];
        [self setSex];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZLIntroCell"];
        UIImageView *image = (UIImageView *)[cell viewWithTag:100];
        image.image = [UIImage imageNamed:@"Introduction"];
        UILabel *lbl = (UILabel *)[cell viewWithTag:101];
        [lbl setTextColor:MZL_COLOR_BLACK_555555()];
        UILabel *lblPlaceHolder = (UILabel *)[cell viewWithTag:105];
        [lblPlaceHolder setTextColor:MZL_COLOR_BLACK_999999()];
        lblPlaceHolder.text = PLACEHOLDER_TEXT;
        _lblPlaceHolder = lblPlaceHolder;
        UITextView *textView = (UITextView *)[cell viewWithTag:102];
        textView.textColor = MZL_COLOR_BLACK_555555();
        textView.text = self.userDetail.introduction;
        [self textViewDidChange:textView];
        textView.delegate = self;
        textView.returnKeyType = UIReturnKeyDone;
        _txtViewUserIntro = textView;
        return cell;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 50.0;
    } else {
        return 140.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 该事件已被全局keyboard dismiss事件屏蔽
}

#pragma mark - SBPickerSelectorDelegate

- (void)SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx {
    self.userDetail.sex = (idx + 1);
    [self setSex];
}

- (void)SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
}

//- (void)SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx{
//    if ([value isMemberOfClass:[NSDate class]]) {
//        [self SBPickerSelector:selector dateSelected:value];
//    } else {
//        [self SBPickerSelector:selector selectedValue:value index:idx];
//    }
//}

#pragma mark - save

- (void)save:(id)sender {
    [self dismissKeyboard];
    self.userDetail.introduction = _txtViewUserIntro.text;
    if (! self.userDetail.introduction) {
        self.userDetail.introduction = @"";
    }
    [self showWorkInProgressIndicator];
    [MZLServices modifyUserInfo:self.userDetail succBlock:^(NSArray *models) {
        [self hideProgressIndicator];
        MZLServiceResponseObject *response = models[0];
        if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
            [self dismissCurrentViewController];
        } else if (! isEmptyString(response.errorMessage)) {
            [UIAlertView showAlertMessage:response.errorMessage];
        } else { // 不明错误
            [self onPostError:nil];
        }
    } errorBlock:^(NSError *error) {
        [self onPostError:error];
    }];
}

@end
