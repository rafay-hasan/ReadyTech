//
//  User Details.m
//  ReadyTech
//
//  Created by Muhammod Rafay on 3/16/16.
//  Copyright (c) 2016 Rafay. All rights reserved.
//

#import "User Details.h"

@implementation User_Details

+ (User_Details *) sharedInstance
{
    static dispatch_once_t pred;
    static User_Details *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    
    return sharedInstance;
    
}


-(id) init
{
    self.userDetailsId = @"";
    
    self.studio_Details_ID = @"";
    
    self.userTypeId = @"";
    
    self.groupId = @"";
    
    self.profileName = @"";
    
    self.userName = @"";
    
    return self;
}

-(NSString *) loadXibFile : (NSString *)name
{
    NSString *xibname = name;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 480)
        {
            // iPhone Classic
            
            //return xibname;
            xibname = [NSString stringWithFormat:@"%@4s",xibname];
        }
        else if (result.height == 568)
        {
            
            return xibname;
        }
        else if (result.height == 667)
        {
            //Iphone 6
            
            xibname = [NSString stringWithFormat:@"%@6",xibname];
            
            return xibname;
            
        }
        else if (result.height == 736)
        {
            //Iphone 6 plus
            
            xibname = [NSString stringWithFormat:@"%@6p",xibname];
            
            
            return xibname;
        }
    }
    else
    {
        return xibname;
        //xibname = [NSString stringWithFormat:@"%@5s",xibname];
    }
    
    
    return xibname;
}


@end
