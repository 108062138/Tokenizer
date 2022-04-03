Tokenizer
=== 
108062138 Po-Yu,Wu
## PRAGMA NOTES
### ORTHOGONAL
**THOSE TWO FLAGS ARE ORTHOGONAL. SEE THE FOLLOW TABLE**
### PRAGMA SOURCE
- `pragma source on`: normal display the line buffer
> sample input: `int a = 5;`
```javascript=
	#key:int
	#id:a
	#punc:=
	#num:5
	#punc:;
	[5]int a = 5;<-shown
```
- `pragma source off`: hide the number line buffer. See the follow code segement:
> sample input: `int a = 5;`
```javascript=
	#key:int
	#id:a
	#punc:=
	#num:5
	#punc:;
		     <-disappear!
```
### PRAGMA TOKEN
- `pragma token on`: normal display the parsed token
> sample input: `int a = 5;`
```javascript=
	#key:int
	#id:a
	#punc:=
	#:num:5
	#punc:;
	[5]int a = 5;
```
- `pragma token off`: hide the parsed token
> sample input: `int a = 5;`
```javascript=
	




	[5]int a = 5;
```


