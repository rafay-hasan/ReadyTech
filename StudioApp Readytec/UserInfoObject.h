//
//  UserInfoObject.h
//  ReadyTech
//
//  Created by Muhammod Rafay on 5/23/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoObject : NSObject

@property (strong,nonatomic) NSString *firstName,*lastName,*userName,*password,*Email,*cellPhone,*city,*country,*totalUserService,*totalStudioService;

@property (strong,nonatomic) NSString *userDetailsId,*studioDetailsId,*targetUserDetailsId;

@property (strong,nonatomic) NSString *userAddedByAdmin;
@property (strong,nonatomic) NSString *userActive;

@end
