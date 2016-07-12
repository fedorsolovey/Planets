//
//  CustomBlocks.h
//

#ifndef CustomBlocks_h
#define CustomBlocks_h

typedef void (^ErrorResponseBlock)(NSError *__nullable error);
typedef void (^ItemResponseBlock)(id __nullable data, NSError *__nullable error);

typedef void (^ArrayResponseBlock)(NSArray *__nullable data, NSError *__nullable error);
typedef void (^DictionaryResponseBlock)(NSDictionary *__nullable data, NSError *__nullable error);

typedef void (^StringResponseBlock)(NSString *__nullable data, NSError *__nullable error);
typedef void (^NumberResponseBlock)(NSNumber *__nullable number, NSError *__nullable error);
typedef void (^LogicalResponseBlock)(BOOL flag, NSError *__nullable error);
typedef void (^ImageResponseBlock)(UIImage *__nullable image, NSError *__nullable error);

typedef void (^TransmitProgressBlock)(NSInteger bytesTransmited,
                                      long long totalBytesTransmited,
                                      long long totalBytesExpectedToTransmit);

typedef void (^ImageResponseBlock)(UIImage *__nullable data, NSError *__nullable error);

#endif
