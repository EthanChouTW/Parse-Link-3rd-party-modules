//
//  ViewController.m
//  ParseFBlink
//
//  Created by pp1285 on 2016/3/17.
//  Copyright © 2016年 EthanChou. All rights reserved.
//

#import "ViewController.h"
#import <Parse/PFConstants.h>
#import <ParseUI/ParseUIConstants.h>
#import <ParseUI/PFLogInView.h>
#import "Parse.h"
#import "PFFacebookUtils.h"
#import <FBSDKCoreKit/FBSDKGraphRequestConnection.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import "PFLogInViewController.h"
#import "ViewController.h"
#import "Parse.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *genderLbl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    [self _loadData];
}

-(void) viewDidAppear:(BOOL)animated {
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
//            ViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
//            [self presentViewController:VC animated:true completion:nil];
            
        }];
        
    }
}
- (IBAction)login:(id)sender {
    [self _loginWithFacebook];
    
}
- (IBAction)logout:(id)sender {
    [self _logOut];
}
- (void)_logOut  {
    [PFUser logOut]; // Log out
    NSLog(@"%@", [PFUser currentUser]);
    _userInfo = nil;
    _nameLbl = nil;
    _genderLbl = nil;
}
- (void)_loginWithFacebook {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"email"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self _loadData];

        } else {
            NSLog(@"User logged in through Facebook!");
            [self _loadData];

        }
    }];
}
- (void)_loadData {
    // ...
    
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *gender = userData[@"user_location"];
            NSString *birthday = userData[@"birthday"];
            NSString *relationship = userData[@"relationship_status"];
            NSString *email = userData[@"email"];

            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Now add the data to the UI elements
            // ...
            
            _userInfo.text = facebookID;
            _nameLbl.text = name;
            _genderLbl.text = email;
        }
    }];
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
    //    ViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    //    [self presentViewController:VC animated:true completion:nil];
    [self _loadData];

}


@end
