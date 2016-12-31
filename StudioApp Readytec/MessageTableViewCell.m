//
//  MessageTableViewCell.m
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/29/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    self.layer.shadowOpacity = 0.5f;
    self.layer.shadowRadius = 2.0f;
    self.layer.masksToBounds = NO;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
