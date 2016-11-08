//
//  MessageObject.h
//  ReadyTech
//
//  Created by Muhammod Rafay on 3/24/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject

@property (strong,nonatomic) NSString *messageTitle;

@property (strong,nonatomic) NSString *messageDetails;

@property (strong,nonatomic) NSString *messageDate;

@property (strong,nonatomic) NSString *messageTime;

@end
