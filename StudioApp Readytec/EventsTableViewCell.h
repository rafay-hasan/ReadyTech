//
//  EventsTableViewCell.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/27/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;

@end
