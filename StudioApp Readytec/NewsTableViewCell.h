//
//  NewsTableViewCell.h
//  StudioApp Readytec
//
//  Created by Rafay Hasan on 11/9/16.
//  Copyright © 2016 Rafay Hasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *newsDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLAbel;
@property (weak, nonatomic) IBOutlet UILabel *newsDescriptionLabel;



@end
