//
//  ServiceItemsViewController.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/4/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceObject.h"

@interface ServiceItemsViewController : UIViewController

@property (strong,nonatomic) NSString *urlString;
@property (strong,nonatomic) ServiceObject *service;

@end
