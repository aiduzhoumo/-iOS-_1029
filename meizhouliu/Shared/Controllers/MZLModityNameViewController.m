//
//  MZLModityNameViewController.m
//  mzl_mobile_ios
//
//  Created by mzl_Jfang on 16/1/19.
//  Copyright © 2016年 Whitman. All rights reserved.
//

#import "MZLModityNameViewController.h"
#import "MZLModityNameCell.h"
#import "MZLServices.h"
#import "MZLServiceResponseObject.h"
#import "UIViewController+MZLValidation.h"

@interface MZLModityNameViewController ()
{
    __weak UITextField *_txtName;
}
@end

@implementation MZLModityNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.modityNameTv setBackgroundColor:MZL_BG_COLOR()];
    [self.modityNameTv addTapGestureRecognizerToDismissKeyboard];
    [self.modityNameTv setDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view dataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MZLModityNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MZLModityNameCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.textLabel setTextColor:colorWithHexString(@"#cccccc")];
    UITextField *textname = cell.textFiled;
    textname.returnKeyType = UIReturnKeyDone;
    textname.delegate = self;
    textname.clearButtonMode = UITextFieldViewModeWhileEditing;
    textname.placeholder = @"请输入新昵称";
    _txtName = textname;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
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
- (IBAction)save:(id)sender {
    [self dismissKeyboard];
    
    if (isEmptyString(_txtName.text)) {
        [UIAlertView showAlertMessage:@"请填写新昵称"];
        return;
    }
    if (![self verifyNickName:_txtName]) {
        return;
    }
   
    [self showNetworkProgressIndicator];
    [MZLServices modifyUserName:_userDetail WithNewName:_txtName.text SuccBlock:^(NSArray *models) {
        [self hideProgressIndicator];
        MZLServiceResponseObject *response = models[0];
        if (response.error == MZL_SVC_RESPONSE_CODE_SUCCESS) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"modifyUserName" object:_txtName.text];
            [self dismissCurrentViewController];
        } else if (! isEmptyString(response.errorMessage)) {
            [UIAlertView showAlertMessage:response.errorMessage];
        } else { // 不明错误
            [self onPostError:nil];
        }
    } errorBlock:^(NSError *error) {
        [self onNetworkError];
    }];
}
@end
