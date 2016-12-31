//
//  EditUserViewController.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/31/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoObject.h"

@interface EditUserViewController : UIViewController

@property (strong,nonatomic) UserInfoObject *userObject;
@property (nonatomic) BOOL addUser;

@end
