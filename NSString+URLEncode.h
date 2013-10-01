//
//  NSString+URLEncode.h
//  Santander Visual


#import <Foundation/Foundation.h>

@interface NSString (URLEncode)
    -(NSString *)urlencode;
    + (NSString *)decodeHTMLEntities:(NSString *)source;
    + (NSString *)encodeHTMLEntities:(NSString *)source;
@end

@interface NSMutableString (URLVariable)
    - (NSMutableString *)appendValue:(NSString *)value forName:(NSString *)name;
@end
