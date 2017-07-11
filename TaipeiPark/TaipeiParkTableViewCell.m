//
//  TaipeiParkTableViewCell.m
//  TaipeiPark
//
//  Created by Vivi on 11/07/2017.
//  Copyright © 2017 Vivi. All rights reserved.
//

#import "TaipeiParkTableViewCell.h"
#import <SDWebImage/UIView+WebCache.h>

@implementation TaipeiParkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellWidth:(CGFloat)cellWidth {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGFloat x, y, w, h;
        
        // Thumbnail image view
        x = 20;
        y = 10;
        w = h = 70;
        self.thumbImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.thumbImageView.clipsToBounds = YES;
        self.thumbImageView.layer.cornerRadius = h / 2.0;
        self.thumbImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        [self.contentView addSubview:self.thumbImageView];
        
        // Name label
        x = CGRectGetMaxY(self.thumbImageView.frame) + 20;
        w = cellWidth - 10 - x;
        h = 22;
        y = CGRectGetMidY(self.thumbImageView.frame) - h;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.nameLabel.textColor = [UIColor blackColor];
        self.nameLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:15];
        self.nameLabel.numberOfLines = 1;
        self.nameLabel.adjustsFontSizeToFitWidth = YES;
        self.nameLabel.minimumScaleFactor = 11.0 / self.nameLabel.font.pointSize;
        [self.contentView addSubview:self.nameLabel];
        
        // Park name label
        x = CGRectGetMinX(self.nameLabel.frame);
        y = CGRectGetMidY(self.thumbImageView.frame);
        w = CGRectGetWidth(self.nameLabel.frame);
        h = CGRectGetHeight(self.nameLabel.frame);
        self.parkNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.parkNameLabel.textColor = [UIColor blackColor];
        self.parkNameLabel.font = [UIFont fontWithName:@"Avenir Next" size:13];
        self.parkNameLabel.numberOfLines = 1;
        self.parkNameLabel.adjustsFontSizeToFitWidth = YES;
        self.parkNameLabel.minimumScaleFactor = 11.0 / self.parkNameLabel.font.pointSize;
        [self.contentView addSubview:self.parkNameLabel];
        
        // Introduction label
        x = CGRectGetMinX(self.thumbImageView.frame);
        y = CGRectGetMaxY(self.thumbImageView.frame) + 10;
        w = cellWidth - x * 2;
        h = 20; // temporary
        self.introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.introductionLabel.font = [UIFont fontWithName:@"Avenir Next" size:14];
        self.introductionLabel.numberOfLines = 0;
        [self.contentView addSubview:self.introductionLabel];
    }
    
    return self;
}

- (void)prepareForReuse {
    self.thumbImageView.image = nil;
    [self.thumbImageView sd_cancelCurrentImageLoad];
    self.nameLabel.text = nil;
    self.parkNameLabel.text = nil;
    self.introductionLabel.text = nil;
}

- (void)setIntroductionLabelText:(NSString *)introductionText {
    CGRect frame = self.introductionLabel.frame;
    self.introductionLabel.text = introductionText;
    [self.introductionLabel sizeToFit];
    frame.size.height = CGRectGetHeight(self.introductionLabel.frame);
    self.introductionLabel.frame = frame;
}

@end
