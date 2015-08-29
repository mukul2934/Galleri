//
//  AlbumsViewController.m
//  Galleri V2
//
//  Created by Mukul Surajiwale on 8/28/15.
//  Copyright (c) 2015 Mukul Surajiwale. All rights reserved.
//

#import "AlbumsViewController.h"
#import "CustomAlbumTableViewCell.h"

@interface AlbumsViewController ()

#pragma Outlets
@property (strong, nonatomic) IBOutlet UITableView *tableView;

#pragma Actions


#pragma Properties
@property (strong, nonatomic) NSMutableArray *albums;


@end


@implementation AlbumsViewController

- (NSMutableArray *)albums{
    if (!_albums) {
        _albums = [[NSMutableArray alloc]init];
    }
    return _albums;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"View Did Appear");
    
    PFQuery *queryUserAlbum = [PFQuery queryWithClassName:@"User_Album"];
    [queryUserAlbum whereKey:@"User" equalTo:[PFUser currentUser]];
    [queryUserAlbum findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] > 0) {
            [self.albums removeAllObjects];
            for (PFObject *obj in objects) {
                PFObject *objAlbum = obj[@"Album"];
                [self.albums addObject:objAlbum];
                
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Failed to find albums");
        }
        
    }];
}

#pragma TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomAlbumTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    customCell.albumTitle.text = self.albums[indexPath.row][@"Name"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    PFObject *album = self.albums[indexPath.row];
    query.limit = 1;
    [query whereKey:@"Album" equalTo:album];
    [query orderByDescending:@"createdAt"];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            PFFile *imageFile = object[@"ImageFile"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (data) {
                    customCell.customImageView.image = [UIImage imageWithData:data];
                } else {
                    NSLog(@"Failed to retrive image");
                }
            }];
        } else {
            customCell.customImageView.image = [UIImage imageNamed:@"noImage.png"];
            NSLog(@"No Pictures Found");
        }
    }];
    
    return customCell;
}




@end
