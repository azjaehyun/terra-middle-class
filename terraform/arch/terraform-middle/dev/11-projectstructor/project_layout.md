<a href="https://github.com/azjaehyun"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fazjaehyun&count_bg=%23000000&title_bg=%23000000&icon=github.svg&icon_color=%23E7E7E7&title=GitHub&edge_flat=false)"/></a>

terraform 폴더 아키텍처 
============
~~~
.
├── project_layout
│   ├── aws
│   │   └── terraform-project // 20 vpc , 30 rds , 40 eks , 50 service
│   │       ├── dev // 각 환경별로 분리 
│   │       │   └── services
│   │       │       └── backend-app
│   │       │           ├── main.tf
│   │       │           ├── outputs.tf
│   │       │           └── var.tf
│   │       ├── global // 글로벌 영역은 따로 분리.
│   │       │   └── s3
│   │       │       ├── main.tf
│   │       │       └── outputs.tf
│   │       ├── prod // 각 환경별로 분리 
│   │       │   ├── data-storage // db instatnce 별로 분리
│   │       │   │   ├── mongo
│   │       │   │   ├── mysql
│   │       │   │   └── redis
│   │       │   └── services // 서비스 영역 별로 분리.  // 디테일하게 DDD로 디테일하게 분리 가능.
│   │       │       ├── backend-app  // 백엔드 부분
│   │       │       │   ├── data.tf
│   │       │       │   ├── main.tf
│   │       │       │   ├── outputs.tf
│   │       │       │   ├── provider.tf
│   │       │       │   ├── terraform.tfvars
│   │       │       │   └── var.tf
│   │       │       └── frontend-app // front 부분
│   │       │           ├── main.tf
│   │       │           ├── outputs.tf
│   │       │           └── var.tf
│   │       └── stage // 각 환경별로 분리 
│   │           └── services
│   │               └── backend-app
│   │                   ├── main.tf
│   │                   ├── outputs.tf
│   │                   └── var.tf
│   └── gcp
└── project_layout.md
~~~