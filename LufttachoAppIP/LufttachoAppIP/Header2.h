







NSData *data = [NSData dataWithBytes:"FF3C" length:4];
NSString *string = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
string = [@"0x" stringByAppendingString:string];

unsigned short value;
sscanf([string UTF8String], "%hx", &value);

NSLog(@"%d", value);