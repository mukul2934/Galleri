//
//  CustomAlbumTableViewCell.h
//  Galleri V2
//
//  Created by Mukul Surajiwale on 8/28/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlbumTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *customImageView;
@property (strong, nonatomic) IBOutlet UILabel *albumTitle;
@property (strong, nonatomic) IBOutlet UILabel *numberOfPictures;

@end
