# Tokenizer
> by popo
## abstract
- This project is about the first project in LJK-NTHU-COMPILER class. It aims to convert `.c` file into tokens. Those token will be utilized in the second project
## how to run this project
- type `chmod 777 run.sh` to enable the the shell script in the current working directory
- `./run.sh` to automically test all the testbench under `/testcases` folder

## PRAGMA NOTES:
- It is composed of three parts:conclusion, pragma source, and pragma token. The idea about pragma is shown in the conclusion part. As for the each detailed effect, see pragama source and pragma token part. 
### CONCLUSION(PLACED AT THE TOP TO LEVEL KNOWLEDGE ABSORBING DIFFICULTY):
**THOSE TWO FLAGS ARE ORTHOGONAL. SEE THE FOLLOW TABLE**
|            | `TOKEN ON`         | `TOKEN OFF`                         |
|------------|------------------|-----------------------------------|
| `SOURCE ON`  | SHOW EVERYTHING  | ONLY BUFFER LINE APPEARS          |
| `SOURCE OFF` | ONLY SHOWS TOKEN | SHOW NEIGHOR BUFFER LINE OR TOKEN |
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
	[5]int a = 5;<-shown
```
- `pragma token off`: hide the parsed token
> sample input: `int a = 5;`
```javascript=
			<-disappear!	
			<-disappear!
			<-disappear!
			<-disappear!
			<-disappear!
	[5]int a = 5;
```

### ORTHOGONAL
- `pragma token off` AND `pragma source off`: hide everything...
> sample input: `int a = 5;`
```javascript=
			<-disappear!	
			<-disappear!
			<-disappear!
			<-disappear!
			<-disappear!
			<-disappear!
```
