### https://www.terraform.io/cli/commands/console

## if문 String
```
 ${var.ifvalue == "" ? "dog" : "cat"}
```

## if문 bool
```
> var.ifbooltrue ? 1 : 0
1
> var.ifboolfalse ? 1 : 0
0
> (var.stringVal == "stringVal") ? 1 : 0
1
> (var.stringVal == "stringVal2") ? 1 : 0
0
```
## for 문
``` 
> [for i, v in [1,2] : "${i} is ${v}"]
[
  "0 is 1",
  "1 is 2",
]
>  
```

[for key, value in {"region" = "us-east-1" ,"region2" = "us-east-2" } : "${key} is ${value}"]
```
[
  "region is us-east-1",
]
```

> [for key, value in {"region" = "us-east-1" ,"region2" = "us-east-2" } : "${key} is ${value}"]
```
[
  "region is us-east-1",
  "region2 is us-east-2",
]
```
