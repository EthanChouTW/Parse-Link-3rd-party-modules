//
//  logginViewController.m
//  ParseFBlink
//
//  Created by pp1285 on 2016/3/17.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

#import "logginViewController.h"
#import <ParseUI/PFLogInView.h>
#import <Parse/PFConstants.h>

#import <ParseUI/ParseUIConstants.h>
#import <ParseUI/PFLogInView.h>
#import "Parse.h"
#import "PFFacebookUtils.h"
#import <FBSDKCoreKit/FBSDKGraphRequestConnection.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import "PFLogInViewController.h"
#import "ViewController.h"

@interface logginViewController ()

@end

@implementation logginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:true];
    if (![PFUser currentUser] || // Check if user is cached
        ![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) { // Check if user is linked to Facebook
        
        PFLogInViewController *controller = [[PFLogInViewController alloc] init];
        controller.fields = (PFLogInFieldsUsernameAndPassword
                                  | PFLogInFieldsFacebook
                                  | PFLogInFieldsDismissButton);
        controller.delegate = self;
        [self presentViewController:controller animated:true completion:^{
//            [self dismissViewControllerAnimated:true completion:nil];
//
            ViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
            [self presentViewController:VC animated:true completion:nil];
            
        }];
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
//    ViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
//    [self presentViewController:VC animated:true completion:nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
