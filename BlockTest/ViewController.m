//
//  ViewController.m
//  BlockTest
//
//  Created by Anand PR on 13/06/13.
//  Copyright (c) 2013 Vofox. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //*****simple method*****
//    int (^add1)(int,int)=^(int a,int b){return a+b;};
    
//    int (^add)(int,int) = ^(int number1, int number2){
//        return number1+number2;
//    };
//    int reult=add1(10,90);
//    NSLog(@"result:%d",reult);
    
    //*****using array*******
    NSMutableArray *theArray=[[NSMutableArray alloc]initWithObjects:@"one",@"two", nil];
    BOOL stop = '\0';
    int idx = 0;
    for (id obj in theArray) {
        NSLog(@"The object at index %d is %@",idx,obj);
        if (stop)
            break;
        idx++;
    }
    
    [theArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        NSLog(@"The object at index %d is %@",idx,obj);
    }];
    
    
    
    
    
    
    //base 64 conversion
//    NSData* imageData = UIImageJPEGRepresentation(smallImage, 0.2f);
//    
//    NSString *testData ;
//    testData= [self base64forData:imageData];

//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:@"basicsound.wav"];
    NSString *file1 = [[NSBundle mainBundle] pathForResource:@"basicsound" ofType:@"wav"]; 
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:file1];
//    NSString *base64Data = [self base64forData:data];
    
    NSString *base64String=[self base64forData:data];
    NSLog(@"base64Data:%@",base64String);
    
    NSData *recievedData=[self base64DataFromString:base64String];
    
    NSString *urlString = [[NSString alloc] initWithData:recievedData encoding:NSUTF8StringEncoding];
    NSLog(@"urlString:%@",urlString);
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    
    self.player=[[AVPlayer alloc] initWithURL:url];
    
    [self.player play];

    
}
//from: http://www.cocoadev.com/index.pl?BaseSixtyFour
//change to base 64 string from data
- (NSString*)base64forData:(NSData*)theData {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

//string from base64 data
#pragma mark - base64DataFromString
- (NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

#pragma mark-Base64 Convertion
//- (NSString*)base64forData:(NSData*)theData {
//    
//    const uint8_t* input = (const uint8_t*)[theData bytes];
//    NSInteger length = [theData length];
//    
//    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
//    
//    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
//    uint8_t* output = (uint8_t*)data.mutableBytes;
//    
//    NSInteger i;
//    for (i=0; i < length; i += 3) {
//        NSInteger value = 0;
//        NSInteger j;
//        for (j = i; j < (i + 3); j++) {
//            value <<= 8;
//            
//            if (j < length) {
//                value |= (0xFF & input[j]);
//            }
//        }
//        
//        NSInteger theIndex = (i / 3) * 4;
//        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
//        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
//        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
//        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
//    }
//    
//    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
//}

-(void)convertBase64TpPlayableMode:(NSData *)data
{
    NSString *urlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
//    NSData *wavDATA = [NSData dataWithContentsOfURL:url];
//    NSError *error;
    
//    self.player=[[AVAudioPlayer alloc] initWithData:wavDATA error:&error];
    self.player=[[AVPlayer alloc] initWithURL:url];

    [self.player play];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
