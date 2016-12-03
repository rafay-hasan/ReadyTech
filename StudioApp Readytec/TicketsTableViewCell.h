//
//  TicketsTableViewCell.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/3/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ticketIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusChangeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketCurrentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketCreationDateLabel;




@end
