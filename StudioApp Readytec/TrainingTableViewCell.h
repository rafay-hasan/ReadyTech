//
//  TrainingTableViewCell.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/28/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *trainingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLessonsLabel;


@end
