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
#import "Instaham+CoreDataModel.h"
#import "CoreData.h"

static NSString *headerCellIdentifier = @"InstagramCell";

@interface CommentViewController () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation CommentViewController {
    InstagramPost *_post;
}

+ (CommentViewController * _Nonnull)fromStoryboard {
    CommentViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle] instantiateViewControllerWithIdentifier:NSStringFromClass([CommentViewController class])];
    return controller;
}

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
    
    InstagramComment *comment = _post.comments.anyObject;
    NSLog(@"%@", comment);
    
    NSLog(@"comments: %@", [_post.comments.anyObject comment]);
    
    NSLog(@"%@", [_post valueForKey:@"comments"]);
}

- (InstagramPost *)post {
    return _post;
}

- (void)configureHeaderCell:(InstagramCell *)cell {
    cell.usernameLabel.text = self.post.userName;
    cell.likesLabel.text = [NSString stringWithFormat:@"%d likes", self.post.likeCount];
    cell.captionLabel.text = self.post.captionText;
    [cell.urlImageView setImageWithURL:[NSURL URLWithString:self.post.imageURL]];
    [cell.profileIimageView setImageWithURL:[NSURL URLWithString:self.post.profileImageURL]];
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
    UITableViewCell *result = nil;
    if (indexPath.row == 0 && indexPath.section == 0) {
        InstagramCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InstagramCell"];
        [self configureHeaderCell:cell];
        result = cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"commentCell"];
        NSArray<InstagramComment *> *comments = self.post.comments.allObjects;
        cell.textLabel.text = comments[indexPath.row].comment;
        result = cell;
    }
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger result = 0;
    if (section == 0) {
        result = 1;
    } else if (section == 1) {
        result = self.post.comments.allObjects.count;
    }
    return result;
}

@end
