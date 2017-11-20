//
//  FeedViewController.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/16/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "FeedViewController.h"
#import "CommentViewController.h"
#import "Instagram.h"
#import "CoreData.h"
#import "InstagramAuthViewController.h"
//#import "Instaham+CoreDataModel.h"
#import "InstagramPost+CoreDataProperties.h"
#import "InstagramComment+CoreDataProperties.h"

#import "InstagramCell.h"
#import "UIImageView+URL.h"
#import "Sanity.h"

static NSString *cellIdentifier = @"InstagramCell";

@interface FeedViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property Instagram *instagram;
@property NSFetchedResultsController *dataController;
@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.instagram = [Instagram new];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"InstagramPost"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"postID" ascending:false]];
    // make sure the 'comments' relationship is hydrated out of the gate.
    request.relationshipKeyPathsForPrefetching = @[@"comments"];
    
    self.dataController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:CoreData.managedContext sectionNameKeyPath:nil cacheName:@"instaham.cache"];
    self.dataController.delegate = self;
    [self.dataController performFetch:nil];
    
    // start the loading process the next time the run loop comes around.
    weakify(self);
    dispatch_async(dispatch_get_main_queue(), ^{
        strongify(self);
        [self loadContent];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadContent {
    // if we don't have a token, go get one.
    if (self.instagram.hasToken == FALSE) {
        InstagramAuthViewController *authController = [InstagramAuthViewController new];
        /*
         yes, this comes with the risk that the user fails to get a token AND
         can't get out of the webview since there's no "Close" button on the auth controller.
         */
        weakify(self);
        authController.tokenCompletion = ^{
            strongify(self);
            // jump back in to load content now that we have a token.
            [self loadContent];
        };
        [self presentViewController:authController animated:TRUE completion:nil];
    }
    
    [self.instagram recentForUserWithCompletion:nil];
}

- (IBAction)refresh:(id)sender {
    [self.instagram recentForUserWithCompletion:^(NSError * _Nullable error) {
        [sender endRefreshing];
    }];
}

- (void)configureCell:(InstagramCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    InstagramPost *post = [self.dataController.fetchedObjects objectAtIndex:indexPath.row];
    cell.usernameLabel.text = post.userName;
    cell.likesLabel.text = [NSString stringWithFormat:@"%d likes", post.likeCount];
    cell.captionLabel.text = post.captionText;
    [cell.urlImageView setImageWithURL:[NSURL URLWithString:post.imageURL]];
    [cell.profileIimageView setImageWithURL:[NSURL URLWithString:post.profileImageURL]];
    
    /**
     Interesting thing here that made me pull out my hair.
     
     the payload returns a `commentsCount` value, which doesn't reflect the actual # of comments
     that will come across via the comments enpoint.  This represents the total, however the
     only content the comments endpoint will return is YOURS.
     
     "Get a list of recent comments on a media object.
     The public_content scope is required for media that does not belong to the owner of the access_token."
     
     Ugh, bummer.  To get permissions for "public_content", the app has to be submitted to Instagram
     for review.
     */
    
    NSUInteger commentCount = post.comments.count;
    
    if (commentCount > 0) {
        cell.commentButton.hidden = FALSE;
        
        NSString *commentString = @"1 Comment";
        if (commentCount > 1) {
            commentString = [NSString stringWithFormat:@"%lu Comments", commentCount];
        }
        [cell.commentButton setTitle:commentString forState:UIControlStateNormal];
        
        weakify(self);
        cell.commentAction = ^{
            strongify(self);
            CommentViewController *controller = [CommentViewController fromStoryboard];
            controller.post = post;
            [self.navigationController pushViewController:controller animated:TRUE];
        };
    } else {
        cell.commentButton.hidden = TRUE;
        cell.commentAction = nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    InstagramPost *post = [self.dataController.fetchedObjects objectAtIndex:indexPath.row];
    
    if (post.captionText == nil) {
        return 460;
    }
    return 491;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InstagramCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.dataController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.dataController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

@end
