//
//  User Details.h
//  ReadyTech
//
//  Created by Muhammod Rafay on 3/16/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User_Details : NSObject

@property (strong,nonatomic) NSString *userDetailsId,*studio_Details_ID,*userTypeId,*groupId,*profileName,*userName;

-(NSString *) loadXibFile : (NSString *)name;


+ (User_Details *) sharedInstance;

@end
