//
//  TrainingDetailsFooterView.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/1/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingDetailsFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *orientationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *registrationDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UILabel *orientationHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *registrationHeaderLabel;




@end
