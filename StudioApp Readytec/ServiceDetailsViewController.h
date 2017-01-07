//
//  ServiceDetailsViewController.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/4/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceDetailsObject.h"
#import "ServiceObject.h"

@interface ServiceDetailsViewController : UIViewController

@property (strong,nonatomic) ServiceDetailsObject *detailsObject;
@property (strong,nonatomic) ServiceObject *serviceObject;

@end
