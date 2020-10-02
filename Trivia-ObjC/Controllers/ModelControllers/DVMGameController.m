//
//  DVMGameController.m
//  Trivia-ObjC
//
//  Created by Jason Koceja on 10/1/20.
//

#import "DVMGameController.h"

static NSString * const kQueryURLString = @"https://opentdb.com/api.php";
static NSString * const kCategoriesURLString = @"https://opentdb.com/api_category.php";
static NSString * const kSessionTokenURLString = @"https://opentdb.com/api_token.php";

static NSString * const kQueryItemAmount = @"amount";
static NSString * const kQueryItemCategory = @"category";
static NSString * const kQueryItemDifficulty = @"difficulty";
static NSString * const kQueryItemType = @"type";
static NSString * const kQueryItemEncode = @"encode";
static NSString * const kQueryItemCommand = @"command";
static NSString * const kQueryItemToken = @"token";

static NSString * const kKeyResponseCode = @"response_code";
static NSString * const kKeyResults = @"results";
static NSString * const kKeyTriviaCategories = @"trivia_categories";
static NSString * const kKeyCategoryId = @"id";
static NSString * const kKeyCategoryName = @"name";

static NSString * const kEncodeType3986 = @"url3986";

@implementation DVMGameController

+ (void)fetchNewGameOfType:(NSString *)type
                difficulty:(NSString *)difficulty
                  category:(NSInteger)category
         numberOfQuestions:(NSInteger)numberOfQuestions
              sessionToken:(NSString *)sessionToken
                completion:(void (^) (DVMGame *, ResponseCode))completion
{
    NSURL *baseURL = [NSURL URLWithString:kQueryURLString];
    NSURLQueryItem *typeQueryItem =
    [NSURLQueryItem queryItemWithName:kQueryItemType
                                value:type];
    NSURLQueryItem *difficultyQueryItem =
    [NSURLQueryItem queryItemWithName:kQueryItemDifficulty
                                value:difficulty];
    NSURLQueryItem *categoryQueryItem =
    [NSURLQueryItem queryItemWithName:kQueryItemCategory
                                value:[NSString stringWithFormat:@"%ld",category]];
    NSURLQueryItem *amountQueryItem =
    [NSURLQueryItem queryItemWithName:kQueryItemAmount
                                value:[NSString stringWithFormat:@"%ld",numberOfQuestions]];
    NSURLQueryItem *tokenQueryItem =
    [NSURLQueryItem queryItemWithName:kQueryItemToken
                                value:sessionToken];
    NSURLQueryItem *encodeQueryItem =
    [NSURLQueryItem queryItemWithName:kQueryItemEncode
                                value:kEncodeType3986];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL
                                             resolvingAgainstBaseURL:true];
    components.queryItems = @[typeQueryItem,
                              difficultyQueryItem,
                              categoryQueryItem,
                              amountQueryItem,
                              tokenQueryItem,
                              encodeQueryItem];
    NSURL *finalURL = components.URL;
    NSLog(@"%s[%d]: finalURL:%@", __FUNCTION__,__LINE__, finalURL);
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL
                               completionHandler:^(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%s[%d]: %@\n---\n%@",__FUNCTION__,__LINE__, error, error.localizedDescription);
            return completion(nil, ResponseCodeFetchError);
        }
        if (!data) {
            NSLog(@"%s[%d]: There appears to be no \"data\"",__FUNCTION__,__LINE__);
            return completion(nil, ResponseCodeFetchError);
        }
        
        NSDictionary *topLevelDictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
        
        NSInteger responseCode = [[topLevelDictionary objectForKey:kKeyResponseCode] integerValue];
        NSArray *results = [topLevelDictionary objectForKey:kKeyResults];
        
        if (responseCode) {
            return completion(nil, responseCode);
        }
        
        DVMGame *newGame = [[DVMGame alloc] initWithResults:results];
        return completion(newGame, ResponseCodeSuccess);
        
        
    }] resume];
}

+ (void)fetchCategoriesList:(void (^) (NSArray *))completion
{
    
    NSURL *categoriesURL = [NSURL URLWithString:kCategoriesURLString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:categoriesURL
                               completionHandler:^(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error) {
        if (error) {
            NSLog(@"%s[%d]: %@\n---\n%@",__FUNCTION__,__LINE__, error, error.localizedDescription);
            return completion(nil);
        }
        if (!data) {
            NSLog(@"%s[%d]: There appears to be no \"data\"",__FUNCTION__,__LINE__);
            return completion(nil);
        }
        
        NSDictionary *topLevelDictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
        NSArray *results = [topLevelDictionary objectForKey:kKeyTriviaCategories];
        NSMutableArray *categories = [NSMutableArray new];
        for (NSDictionary *result in results) {
            NSInteger identifier = [[result objectForKey:kKeyCategoryId] integerValue];
            NSString *name = [result objectForKey:kKeyCategoryName];
            DVMCategory *category =
            [[DVMCategory alloc] initWithCategoryName:name
                                           categoryId:identifier];
            [categories addObject:category];
        }
        return completion(categories);
        
    }] resume];
}

+ (void)requestSessionToken:(void (^) (NSString *, ResponseCode))completion
{
    NSURL *sessionTokenURL = [NSURL URLWithString:kSessionTokenURLString];
    NSURLQueryItem *requestQueryItem =
    [NSURLQueryItem queryItemWithName:kQueryItemCommand
                                value:@"request"];
    NSURLComponents *components = [NSURLComponents componentsWithURL:sessionTokenURL
                                             resolvingAgainstBaseURL:true];
    components.queryItems = @[requestQueryItem];
    NSURL *finalURL = components.URL;
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL
                               completionHandler:^(NSData * _Nullable data,
                                                   NSURLResponse * _Nullable response,
                                                   NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"%s[%d]: %@\n---\n%@",__FUNCTION__,__LINE__, error, error.localizedDescription);
        }
        if (!data) {
            NSLog(@"%s[%d]: There appears to be no \"data\"",__FUNCTION__,__LINE__);
        }
        
        NSDictionary *topLevelDictionary =
        [NSJSONSerialization JSONObjectWithData:data
                                        options:NSJSONReadingAllowFragments
                                          error:&error];
        
        NSInteger responseCode = [[topLevelDictionary objectForKey:kKeyResponseCode] integerValue];
        NSString *token = [topLevelDictionary objectForKey:kQueryItemToken];
        return completion(token, responseCode);
        
    }] resume];
}

@end
