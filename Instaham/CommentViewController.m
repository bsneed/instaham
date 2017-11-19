//
//  CommentViewController.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/18/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import "CommentViewController.h"
#import "InstagramCell.h"
#import "UIImageView+URL.h"


@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@property InstagramCell *headerCell;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPost:(InstagramPost *)post {
    _post = post;
    
    self.headerCell = [[InstagramCell alloc] initWithFrame:CGRectZero];
    self.headerCell.usernameLabel.text = post.userName;
    self.headerCell.likesLabel.text = [NSString stringWithFormat:@"%d likes", post.likeCount];
    self.headerCell.captionLabel.text = post.captionText;
    [self.headerCell.urlImageView setImageWithURL:[NSURL URLWithString:post.imageURL]];
    [self.headerCell.profileIimageView setImageWithURL:[NSURL URLWithString:post.profileImageURL]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 468;
    }
    return 43;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.headerCell;
    }/* else {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        cell.textLabel.text = post.comments[indexPath.row - 1].
    }*/
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 0;
}

@end
