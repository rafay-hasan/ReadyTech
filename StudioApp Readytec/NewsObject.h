//
//  NewsObject.h
//  ReadyTech
//
//  Created by Muhammod Rafay on 3/13/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsObject : NSObject

@property (strong,nonatomic) NSString *newsTitle,*newsDateTime;

@property (strong,nonatomic) NSAttributedString *newsDescription;

@end
