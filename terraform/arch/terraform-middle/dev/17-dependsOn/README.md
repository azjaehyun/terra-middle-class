### https://www.terraform.io/cli/commands/console

## for 문
``` 
> [for i, v in [1,2] : "${i} is ${v}"]
[
  "0 is 1",
  "1 is 2",
]
>  
```

[for i, v in {"region" = "us-east-1"} : "${i} is ${v}"]

