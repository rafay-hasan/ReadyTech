//
//  OfferTableViewCell.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/30/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *offerImageView;
@property (weak, nonatomic) IBOutlet UILabel *offerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerStartDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerEndDateLabel;


@end
