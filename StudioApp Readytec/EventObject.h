//
//  EventObject.h
//  ReadyTech
//
//  Created by Muhammod Rafay on 3/16/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventObject : NSObject

@property (strong,nonatomic) NSString *eventName;

@property (strong,nonatomic) NSString *eventDescription;

@property (strong,nonatomic) NSString *eventWebLink;

@property (strong,nonatomic) NSString *eventStartDate;

@property (strong,nonatomic) NSString *eventEndDate;


@end
