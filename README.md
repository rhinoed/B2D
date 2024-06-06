<!-- 
Readme for B2D 
by Mark Edmunds
-->

# B2D (Binary to Decimal)

### Introduction:

B2D is a command line utillity for the converstion of binary numbers to decimal number and vice
versa. It can also be used to encode utf8 text into base 64. It is written in Swift and uses
Swift Argument Parser.

### Useage:
The default mode for b2d is to convert binary to decimal so the pattern of input is: 

b2d -flag \<argument>

Here is an example: 
```bash
# 
b2d 1010100
```
There are a couple options when using the converter functionality they are:

- (--address, -a) Sets the address flag to true indicating the input is an IP address.
- (--dec, -d) Sets the dec flag to true. This will covert decimal numbers to binary.
- (--base64, -b) Sets the base64 flag to true. Will convert a convert a base 64 string into a utf8 string.

```bash
# Converting an IP address or Subnet that is represented in binary into decimal
b2d -a 10100000.01011000.00000001.00001010
```

```bash
# Converting an IP or Subnet from decimal into binary
b2d -ad 192.168.1.40
```

```bash
# Converting a base 64 string into an utf8 string
b2d -b SGVsbG8gV29ybGQ=
```


