//
//  InstagramComment+CoreDataProperties.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/19/17.
//  Copyright © 2017 Hammy. All rights reserved.
//
//

#import "InstagramComment+CoreDataProperties.h"

@implementation InstagramComment (CoreDataProperties)

+ (NSFetchRequest<InstagramComment *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"InstagramComment"];
}

@dynamic comment;
@dynamic commentID;
@dynamic profileImageURL;
@dynamic time;
@dynamic userName;
@dynamic postID;

@end
