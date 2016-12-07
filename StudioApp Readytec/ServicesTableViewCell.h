//
//  ServicesTableViewCell.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 12/4/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServicesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *serviceCodeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *serviceAccessoryButton;



@end
