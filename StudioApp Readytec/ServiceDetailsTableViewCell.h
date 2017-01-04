//
//  ServiceDetailsTableViewCell.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/4/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceDetailsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *detailsCopyButton;
@property (weak, nonatomic) IBOutlet UIButton *detailsEmailButton;
@property (weak, nonatomic) IBOutlet UILabel *itemDateLabe;
@property (weak, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemDescriptionNameLabel;



@end
