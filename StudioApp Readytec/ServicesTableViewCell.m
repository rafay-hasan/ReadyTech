//
//  ServicesTableViewCell.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/4/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "ServicesTableViewCell.h"
#import "User Details.h"
#import <QuartzCore/QuartzCore.h>

@implementation ServicesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    if([[User_Details sharedInstance].userTypeId isEqualToString:@"1"])
    {
        //[self.serviceAccessoryButton setTitle:@"" forState:UIControlStateNormal];
       // [self.serviceAccessoryButton setImage:nil forState:UIControlStateNormal];
        self.serviceAccessoryButton.backgroundColor = [UIColor colorWithRed:8.0/255.0 green:30.0/255.0 blue:152.0/255.0 alpha:1];
        //self.serviceAccessoryButton.layer.cornerRadius = self.serviceAccessoryButton.bounds.size.width/2;
        //self.serviceAccessoryButton.layer.masksToBounds = YES;
        
       // self.serviceAccessoryButton.clipsToBounds = YES;
        self.serviceAccessoryButton.layer.cornerRadius = 20;
        self.serviceAccessoryButton.clipsToBounds = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
