//
//  Instagram.m
//  Instaham
//
//  Created by Sneed, Brandon on 11/16/17.
//  Copyright © 2017 Hammy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "Instagram.h"
#import "Keychain.h"
#import "Conversion.h"
#import "CoreData.h"
//#import "Instaham+CoreDataModel.h"
#import "InstagramPost+CoreDataProperties.h"
#import "InstagramComment+CoreDataProperties.h"
#import "Sanity.h"

static NSString * const kApiEndpoint = @"https://api.instagram.com/v1";
static NSString * const kAuthEndpoint = @"https://api.instagram.com/oauth/authorize";
static NSString * const kClientID = @"3c44288b72434931b0a927b7fe5bbbad";
static NSString * const kTokenKey = @"token";
static NSString * const kServiceName = @"instaham";

typedef void(^NetworkCompletion)(NSData * _Nullable data, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error);

@implementation Instagram {
    NSString *_cachedToken;
    dispatch_queue_t _commentQueue;
}

#pragma mark - Private

/*
 this allows me to test without having the endpoint string scattered all over.
 maybe there's a better way to do this?
 */
- (NSString * _Nonnull)apiEndpoint {
    return kApiEndpoint;
}

- (NSURL * _Nullable)buildURLForPath:(NSString * _Nonnull)path params:(NSArray<NSURLQueryItem *> * _Nullable)params token:(NSString * _Nonnull)token {
    NSURL *url = [[NSURL alloc] initWithString:kApiEndpoint];
    url = [url URLByAppendingPathComponent:path];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [params mutableCopy];
    if (queryItems == nil) {
        queryItems = [[NSMutableArray alloc] init];
    }
    
    NSURLQueryItem *tokenItem = [NSURLQueryItem queryItemWithName:@"access_token" value:token];
    [queryItems addObject:tokenItem];
    
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:url resolvingAgainstBaseURL:NO];
    components.queryItems = queryItems;
    
    NSURL *result = components.URL;
    return result;
}

- (void)callPath:(NSString * _Nonnull)path params:(NSArray<NSURLQueryItem *> * _Nullable)params completion:(NetworkCompletion)completion {
    NSURL *url = [self buildURLForPath:path params:params token:self.token];
    
    NSURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:15.0];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        /*
         Kind of making an assumption here that it'll always be an NSHTTPResponse, and if it's not
         we don't care.  I've seen this come back as NSURLResponse on occasion, depending on the service being hit.
         */
        NSHTTPURLResponse *httpResponse = nil;
        if ([response isKindOfClass: [NSHTTPURLResponse class]]) {
            httpResponse = (NSHTTPURLResponse *)response;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            /*
             call this playa on the main thread y0.  if i knew coredata better, i could ignore the threading gotchas
             i know are there.  this is where i'd go ask for some help.
             */
            completion(data, httpResponse, error);
        });
    }];
    
    [task resume];
}

- (void)clearToken {
    [Instagram setToken:nil];
}

- (BOOL)postExists:(NSString * _Nonnull)postID context:(NSManagedObjectContext * _Nonnull)context {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"InstagramPost" inManagedObjectContext:context];
    request.predicate = [NSPredicate predicateWithFormat:@"postID == %@", postID];
    [request setEntity:entity];
    
    NSUInteger count = [context countForFetchRequest:request error:nil];
    if (count > 0) {
        return TRUE;
    }
    return FALSE;
}

#pragma mark - Public

- (id)init {
    self = [super init];
    _cachedToken = nil;
    _commentQueue = dispatch_queue_create("instaham.comments", DISPATCH_QUEUE_SERIAL);
    return self;
}

- (BOOL)hasToken {
    return (self.token != nil);
}

- (NSString * _Nullable)token {
    if (_cachedToken == nil) {
        _cachedToken = [Keychain stringForKey:kTokenKey serviceName:kServiceName];
    }
    return _cachedToken;
}

- (void)setToken:(NSString * _Nullable)token {
    [Instagram setToken:token];
}

+ (void)setToken:(NSString * _Nullable)token {
    [Keychain setString:token forKey:kTokenKey serviceName:kServiceName];
}

+ (NSURL * _Nullable)authURL {
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=https://hamography.com&response_type=token", kAuthEndpoint, kClientID]];
    return url;
}

#pragma mark - Instagram functionality

- (void)recentForUserWithCompletion:(ServiceCompletion _Nullable)completion {
    weakify(self);
    [self callPath:@"users/self/media/recent" params:nil completion:^(NSData * _Nullable data, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
        strongify(self);
        NSError *passedError = error;
        
        if (response.statusCode == 200 || response == nil) {
            NSError *jsonError = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonError != nil) {
                passedError = jsonError;
            } else if (dict != nil) {
                NSManagedObjectContext *context = [CoreData managedContext];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"InstagramPost" inManagedObjectContext:context];
                
                // start adding our payload to core data.
                NSArray<NSDictionary *> *payloadData = [dict objectForKey:@"data"];
                if (payloadData != nil) {
                    for (NSDictionary *item in payloadData) {
                        NSString *postID = [[item valueForKeyPath:@"id"] stringValue];
                        // TODO: theres probably a better way to do this.  I don't know CoreData terribly well.
                        // i'm attempting to prevent duplicates.  this has the added side effect of not updating new
                        // comments if they come in later.  :(
                        if (![self postExists:postID context:context]) {
                            InstagramPost *post = [[InstagramPost alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                            post.postID = [item valueForKeyPath:@"id"];
                            post.imageURL = [item valueForKeyPath:@"images.standard_resolution.url"];
                            post.userName = [item valueForKeyPath:@"user.username"];
                            post.profileImageURL = [[item valueForKeyPath:@"user.profile_picture"] stringValue];
                            post.captionText = [[item valueForKeyPath:@"caption.text"] stringValue];
                            post.likeCount = [[item valueForKeyPath:@"likes.count"] numberValue].intValue;
                            post.commentCount = [[item valueForKeyPath:@"comments.count"] numberValue].intValue;
                            
                            dispatch_async(_commentQueue, ^{
                                [self commentsForPost:post completion:nil];
                            });
                        }
                    }
                
                    [context save:&passedError];
                }
                
                dispatch_async(_commentQueue, ^{
                    // tell it to do something after all the comments are fetched...
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        NSError *error = nil;
                        [[CoreData managedContext] save:&error];
                    });
                });
            }
        } else {
            
        }
        
        if (completion != nil)
            completion(passedError);
    }];
}

- (void)commentsForPost:(InstagramPost * _Nonnull)post completion:(ServiceCompletion _Nullable)completion {
    NSString *path = [NSString stringWithFormat:@"media/%@/comments", post.postID];
    [self callPath:path params:nil completion:^(NSData * _Nullable data, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *passedError = error;
        
        if (response.statusCode == 200 || response == nil) {
            NSError *jsonError = nil;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (jsonError != nil) {
                passedError = jsonError;
            } else if (dict != nil) {
                NSManagedObjectContext *context = [CoreData managedContext];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"InstagramComment" inManagedObjectContext:context];
                
                // start adding our payload to core data.
                NSArray<NSDictionary *> *payloadData = [dict objectForKey:@"data"];
                if (payloadData != nil) {
                    for (NSDictionary *item in payloadData) {
                        InstagramComment *comment = [[InstagramComment alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
                        //comment.postID = post;
                        comment.commentID = [item valueForKeyPath:@"id"];
                        comment.userName = [item valueForKeyPath:@"from.username"];
                        comment.profileImageURL = [item valueForKeyPath:@"from.profile_picture"];
                        comment.comment = [item valueForKeyPath:@"text"];
                        
                        if ([post.captionText isEqualToString:@"Not my favorite song."]) {
                            NSLog(@"boom");
                        }
                        
                        [post addCommentsObject:comment];
                        
                        NSLog(@"%@", post);
                    }
                    
                    [context save:&passedError];
                }
            }
        } else {
            
        }
        
        if (completion != nil)
            completion(passedError);
    }];

}

@end
