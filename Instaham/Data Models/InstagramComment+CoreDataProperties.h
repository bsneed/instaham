//
//  InstagramComment+CoreDataProperties.h
//  Instaham
//
//  Created by Sneed, Brandon on 11/19/17.
//  Copyright © 2017 Hammy. All rights reserved.
//
//

#import "InstagramComment+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface InstagramComment (CoreDataProperties)

+ (NSFetchRequest<InstagramComment *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *comment;
@property (nullable, nonatomic, copy) NSString *commentID;
@property (nullable, nonatomic, copy) NSString *profileImageURL;
@property (nonatomic) int64_t time;
@property (nullable, nonatomic, copy) NSString *userName;
@property (nullable, nonatomic, retain) InstagramPost *postID;

@end

NS_ASSUME_NONNULL_END
