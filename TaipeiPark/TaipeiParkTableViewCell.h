//
//  TaipeiParkTableViewCell.h
//  TaipeiPark
//
//  Created by Vivi on 11/07/2017.
//  Copyright © 2017 Vivi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaipeiParkTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *thumbImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *parkNameLabel;
@property (strong, nonatomic) UILabel *introductionLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)cellWidth;
- (void)setIntroductionLabelText:(NSString *)introductionText;

@end
