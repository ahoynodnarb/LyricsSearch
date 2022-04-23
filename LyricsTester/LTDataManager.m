//
//  Utils.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LTDataManager.h"

@implementation LTDataManager

+ (NSArray *)infoForTrack:(NSString *)name {
    NSString *searchTerm = [name stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *accessToken = [[[NSProcessInfo processInfo] environment] objectForKey:@"ACCESS_TOKEN"];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.genius.com/search?per_page=12&q=%@&access_token=%@", searchTerm, accessToken]];
    NSData *data = [NSData dataWithContentsOfURL:URL];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSDictionary *response = [dict objectForKey:@"response"];
    NSMutableArray *info = [[NSMutableArray alloc] init];
    for(NSDictionary *hit in [response objectForKey:@"hits"]) {
        NSDictionary *result = [hit objectForKey:@"result"];
        NSString *artistNames = [result objectForKey:@"artist_names"];
        NSString *songName = [result objectForKey:@"title"];
        NSURL *artURL = [NSURL URLWithString:[result objectForKey:@"song_art_image_thumbnail_url"]];
        NSData *artData = [NSData dataWithContentsOfURL:artURL];
        NSDictionary *dict = @{@"artistName":artistNames, @"songName":songName, @"artData":artData};
        [info addObject:dict];
    }
    return info;
}

+ (NSArray *)lyricsForSong:(NSString *)song artist:(NSString *)artist {
    NSString *URLString = [NSString stringWithFormat:@"https://api.textyl.co/api/lyrics?q=%@ %@", song, artist];
    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *URL = [NSURL URLWithString:URLString];
    NSData *responseData = [NSData dataWithContentsOfURL:URL];
    if(responseData) {
        NSArray *lyricsArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        return lyricsArray;
    }
    return nil;
}

@end
