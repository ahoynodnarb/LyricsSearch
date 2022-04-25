//
//  Utils.m
//  LyricsTester
//
//  Created by Brandon Yao on 4/21/22.
//

#import "LTDataManager.h"

@implementation LTDataManager

+ (NSData *)dataForURL:(NSURL *)URL headers:(NSDictionary *)headers {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    NSData *__block responseData = nil;
    BOOL __block fetchComplete = NO;
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200) responseData = data;
        fetchComplete = YES;
    }];
    [dataTask resume];
    while(!fetchComplete) {}
    return responseData;
}

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
    NSArray *array = @[
            @{ @"timestamp": @(11750), @"words": @"You prolly think that you are better now, better now" },
            @{ @"timestamp": @(15190), @"words": @"You only say that 'cause I'm not around, not around" },
            @{ @"timestamp": @(18220), @"words": @"You know I never meant to let you down, let you down" },
            @{ @"timestamp": @(21660), @"words": @"Woulda gave you anything" },
            @{ @"timestamp": @(23470), @"words": @"Woulda gave you everything" },
            @{ @"timestamp": @(25350), @"words": @"You know I say that I am better now, better now" },
            @{ @"timestamp": @(28260), @"words": @"I only say that 'cause you're not around, not around" },
            @{ @"timestamp": @(31600), @"words": @"You know I never meant to let you down, let you down" },
            @{ @"timestamp": @(35080), @"words": @"Woulda gave you anything" },
            @{ @"timestamp": @(36940), @"words": @"Woulda gave you everything, oh-oh" },
            @{ @"timestamp": @(39700), @"words": @"I did not believe that it would end, no" },
            @{ @"timestamp": @(42870), @"words": @"Everything came second to the Benzo" },
            @{ @"timestamp": @(46150), @"words": @"You're not even speakin' to my friends, no" },
            @{ @"timestamp": @(49520), @"words": @"You knew all my uncles and my aunts though" },
            @{ @"timestamp": @(52900), @"words": @"Twenty candles, blow 'em out and open your eyes" },
            @{ @"timestamp": @(56150), @"words": @"We were lookin' forward to the rest of our lives" },
            @{ @"timestamp": @(59310), @"words": @"Used to keep my picture posted by your bedside" },
            @{ @"timestamp": @(62670), @"words": @"Now it's in your dresser with the socks you don't like" },
            @{ @"timestamp": @(65910), @"words": @"And I'm rollin', rollin', rollin', rollin'" },
            @{ @"timestamp": @(69160), @"words": @"With my brothers like it's Jonas, Jonas" },
            @{ @"timestamp": @(72480), @"words": @"Drinkin' Henny and I'm tryna forget" },
            @{ @"timestamp": @(75900), @"words": @"But I can't get this shit outta my head" },
            @{ @"timestamp": @(78170), @"words": @"You prolly think that you are better now, better now" },
            @{ @"timestamp": @(81000), @"words": @"You only say that 'cause I'm not around, not around" },
            @{ @"timestamp": @(84430), @"words": @"You know I never meant to let you down, let you down" },
            @{ @"timestamp": @(87910), @"words": @"Woulda gave you anything" },
            @{ @"timestamp": @(89710), @"words": @"Woulda gave you everything" },
            @{ @"timestamp": @(91480), @"words": @"You know I say that I am better now, better now" },
            @{ @"timestamp": @(94300), @"words": @"I only say that 'cause you're not around, not around" },
            @{ @"timestamp": @(98150), @"words": @"You know I never meant to let you down, let you down" },
            @{ @"timestamp": @(100950), @"words": @"Woulda gave you anything" },
            @{ @"timestamp": @(102650), @"words": @"Woulda gave you everything, oh-oh" },
            @{ @"timestamp": @(106050), @"words": @"I seen you with your other dude" },
            @{ @"timestamp": @(109280), @"words": @"He seemed like he was pretty cool" },
            @{ @"timestamp": @(112420), @"words": @"I was so broken over you" },
            @{ @"timestamp": @(115820), @"words": @"Life, it goes on, what can you do?" },
            @{ @"timestamp": @(118430), @"words": @"I just wonder what it's gonna take" },
            @{ @"timestamp": @(121880), @"words": @"Another foreign or a bigger chain" },
            @{ @"timestamp": @(125130), @"words": @"Because no matter how my life has changed" },
            @{ @"timestamp": @(128310), @"words": @"I keep on looking back on better days" },
            @{ @"timestamp": @(131020), @"words": @"You prolly think that you are better now, better now" },
            @{ @"timestamp": @(134130), @"words": @"You only say that 'cause I'm not around, not around" },
            @{ @"timestamp": @(137580), @"words": @"You know I never meant to let you down, let you down" },
            @{ @"timestamp": @(140670), @"words": @"Woulda gave you anything" },
            @{ @"timestamp": @(142460), @"words": @"Woulda gave you everything" },
            @{ @"timestamp": @(144390), @"words": @"You know I say that I am better now, better now" },
            @{ @"timestamp": @(147530), @"words": @"I only say that 'cause you're not around, not around" },
            @{ @"timestamp": @(150570), @"words": @"You know I never meant to let you down, let you down" },
            @{ @"timestamp": @(154160), @"words": @"Woulda gave you anything" },
            @{ @"timestamp": @(155660), @"words": @"Woulda gave you everything, oh-oh" },
            @{ @"timestamp": @(159030), @"words": @"I promise, I swear to you, I'll be okay" },
            @{ @"timestamp": @(164850), @"words": @"You're only the love of my life (the love of my life)" },
            @{ @"timestamp": @(171140), @"words": @"You prolly think that you are better now, better now" },
            @{ @"timestamp": @(174100), @"words": @"You only say that 'cause I'm not around, not around" },
            @{ @"timestamp": @(177660), @"words": @"You know I never meant to let you down, let you down" },
            @{ @"timestamp": @(180570), @"words": @"Woulda gave you anything" },
            @{ @"timestamp": @(182110), @"words": @"Woulda gave you everything" },
            @{ @"timestamp": @(184080), @"words": @"You know I say that I am better now, better now" },
            @{ @"timestamp": @(186950), @"words": @"I only say that 'cause you're not around, not around" },
            @{ @"timestamp": @(190310), @"words": @"You know I never meant to let you down, let you down" },
            @{ @"timestamp": @(193530), @"words": @"Woulda gave you anything" },
            @{ @"timestamp": @(195810), @"words": @"Woulda gave you everything, oh-oh" },
            @{ @"timestamp": @(197350), @"words": @"" }
    ];
    return array;

//   @ NSString *searchTerm = [NSString stringWithFormat:@"%@ %@", song, artist];
//    NSString *URLString = [NSString stringWithFormat:@"https://timestamp-lyrics.p.rapidapi.com/extract-lyrics?name=%@", searchTerm];
//    URLString = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSURL *URL = [NSURL URLWithString:URLString];
//    NSString *host = @"timestamp-lyrics.p.rapidapi.com";
////    NSString *key = @"f47ed3409dmsh35cdc754cb3d2c2p1bb437jsnfd4b45952108";
//    NSString *key = @"3208b5e382mshb926545181fd915p1ac7ffjsne5199020e9c5";
//    NSDictionary *headers = @{
//        @"X-RapidAPI-Host": host,
//        @"X-RapidAPI-Key": key
//    };
//    NSData *responseData = [LTDataManager dataForURL:URL headers:headers];
//    if(responseData) {
//        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
//        NSArray *lyrics = [responseDict objectForKey:@"lyrics"];
//        // slice the first one because it's empty
//        return [lyrics subarrayWithRange:NSMakeRange(1, [lyrics count] - 1)];
//    }
//    return nil;
}

@end
