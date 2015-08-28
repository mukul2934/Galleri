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

@end

@implementation AlbumsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomAlbumTableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    customCell.albumTitle.text = @"Trip to Venice";
    return customCell;
}




@end
