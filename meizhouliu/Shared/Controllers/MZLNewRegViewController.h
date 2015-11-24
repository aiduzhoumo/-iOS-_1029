//
//  MZLNewRegViewController.h
//  mzl_mobile_ios
//
//  Created by 楚向楠 on 23/11/15.
//  Copyright © 2015年 Whitman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MZLNewRegViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *Phonetxt;

@property (weak, nonatomic) IBOutlet UITextField *Sectext;

@property (weak, nonatomic) IBOutlet UITextField *PhoneSectxt;

- (IBAction)PhoneSecbtn:(id)sender;


- (IBAction)RegNextbtn:(id)sender;




@end
