# Boomerang
Code-base migrating the services of Boomerang Electronics to the Cloud (Based in LocalStack)

## Introduction

## Requirements
Operating Systems: Windows 64-Bit, MacOS 64-Bit (X86_64, Arm64), Linux 64-Bit (X86_64, Arm64)

Dependencies:
- Docker: >=20.10.11 recommended
- [LocalStack](https://docs.localstack.cloud/getting-started/installation/): >=3.2.0 recommended
- Python: >=3.9.18 recommended

A [LocalStack account](https://app.localstack.cloud/sign-in) and a [LocalStack Pro license](https://app.localstack.cloud/workspace/members) is needed
- For a free tier of Pro license, use the Hobby License
- To use the license, assign it on the web app & [set the Auth Token locally](https://docs.localstack.cloud/getting-started/auth-token/)

Developed on: MacOS 12.4 (Arm64), Docker v20.10.11, LocalStack v3.2.0, Python v3.9.18

## Project Structure
This section will describe the representation of each of the folders or files in the structure.   

```
.
├── bin
│   └── deploy.sh
├── EC2s
│   └── 
├── ElastiCaches
│   └── 
├── S3s
│   └── 
├── tests
│   └── 
├── .gitignore
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── requirements-dev.txt
└── tests
    └── FS-logo.png
```

### `bin`

### `EC2s`

### `ElastiCaches`

### `S3s`

### `tests`

### `.gitignore`

### `CONTRIBUTING.md`

### `LICENSE`

### `README.md`

### `requirements-dev.txt`

## Running Steps
1. Clone the repo onto your machine & change the working directory to be in the repo using the following CLI commands:

```
git clone 'https://github.com/Hoo-dkwozD/Boomerang.git'
cd Boomerang
```

2. Start Docker engine on your local machine.   

3. Start LocalStack with the following CLI command: 

```
localstack start
```

4. Ensure all the required programs listed here are installed.   

5. Create a (preferably) new Python Env with Python>=3.9.   

Using Conda: 
```
conda create -n <pyenv-name> python=3.9
```

Using Python venv (MacOS)
```
python3 -m venv <path-to-virtual-env-with-folder-being-env-name>
```

Using Python venv (Windows)
```
python3 -m venv <path-to-virtual-env-with-folder-being-env-name>
```

6. Active the Env & install the necessary Python packages and wrappers.   

Using Conda: 
```
conda activate <pyenv-name>
pip install -r requirements-dev.txt
```

Using Python venv (MacOS)
```
source <path-to-virtual-env-with-folder-being-env-name>/bin/activate
pip install -r requirements-dev.txt
```

Using Python venv (Windows)
```
<path-to-virtual-env-with-folder-being-env-name>\Scripts\activate
pip install -r requirements-dev.txt
```

7. Run the entire Architecture using the following CLI command:

```
bin/deploy.sh
```

## Results

## Tested By

## Attributions
Original Web App provided by @puneethreddyhc, sourced from [Source Code & Projects](https://code-projects.org/online-shopping-system-in-php-with-source-code/).   
