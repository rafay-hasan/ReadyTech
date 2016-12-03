//
//  TicketDetailsHeaderView.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/3/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketDetailsHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *ticketdLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketCreationDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketCurrentStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *ticketDescriptionLabel;


@end
