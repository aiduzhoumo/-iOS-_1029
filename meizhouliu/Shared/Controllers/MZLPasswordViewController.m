//
//  MZLPasswordViewController.m
//  mzl_mobile_ios
//
//  Created by alfred on 14-8-14.
//  Copyright (c) 2014年 Whitman. All rights reserved.
//

#import "MZLPasswordViewController.h"
#import "MZLPasswordTableViewCell.h"
#import "UIViewController+COTextFieldDelegate.h"
#import "UIViewController+MZLValidation.h"
#import "MZLServices.h"
#import "MZLServiceResponseObject.h"

@interface MZLPasswordViewController () {
    __weak UITextField *_txtOldPwd;
    __weak UITextField *_txtNewPwd;
    __weak UITextField *_txtConfirm;
}

@end

@implementation MZLPasswordViewController

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
    [self.tvPassword setBackgroundColor:MZL_BG_COLOR()];
    [self.tvPassword addTapGestureRecognizerToDismissKeyboard];
    [self.tvPassword setDelegate:self];
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

#pragma mark - Table view data source
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MZLPasswordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZLPwdCell"];
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setTextColor:colorWithHexString(@"#cccccc")];
    UITextField *txtPwd = cell.txtFieldPwd;
    txtPwd.tag = indexPath.row;
    txtPwd.secureTextEntry = YES;
    txtPwd.returnKeyType = UIReturnKeyNext;
    txtPwd.delegate = self;
    txtPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (txtPwd.tag == 0) {
        txtPwd.placeholder = @"旧密码";
        _txtOldPwd = txtPwd;
    }
    else if (indexPath.row == 1) {
        txtPwd.placeholder = @"输入新密码";
        _txtNewPwd = txtPwd;
    }
    else {
        txtPwd.placeholder = @"确认新密码";
        txtPwd.returnKeyType = UIReturnKeyDone;
        _txtConfirm = txtPwd;
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

#pragma mark - table view delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:MZL_BG_COLOR()];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - save

- (void)save:(id)sender {
    if (isEmptyString(_txtOldPwd.text)) {
        [UIAlertView showAlertMessage:@"请填写密码！"];
        return;
    }
    if (isEmptyString(_txtNewPwd.text)) {
        [UIAlertView showAlertMessage:@"请填写新密码！"];
        return;
    }
    if (isEmptyString(_txtConfirm.text)) {
        [UIAlertView showAlertMessage:@"请填写确认密码！"];
        return;
    }
    if (! [self verifyPassword:_txtNewPwd]) {
        return;
    }
    if (! [_txtNewPwd.text isEqualToString:_txtConfirm.text]) {
        [UIAlertView showAlertMessage:@"新密码与确认密码不一致！"];
        return;
    }
    [self dismissKeyboard];
    [self showWorkInProgressIndicator];
    [MZLServices modifyPasswordWithOldPassword:_txtOldPwd.text newPassword:_txtNewPwd.text succBlock:^(NSArray *models) {
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
