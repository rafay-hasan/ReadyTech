//
//  TrainingDetailsHeaderView.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 1/1/17.
//  Copyright © 2017 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainingDetailsHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *trainingTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLessonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *trainingNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseOverviewLabel;


@end
