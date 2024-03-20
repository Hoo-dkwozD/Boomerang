# Dev Contribution Guide

## Setup
Instructions for first time setup. 

1. Start Docker engine on your local machine.   

2. Start LocalStack with the following CLI command: 

```
localstack start
```

3. Ensure all the required programs listed on the [README file](./README.md) are installed.   

4. Create a (preferably) new Python Env with Python>=3.9.   

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

5. Active the Env & install the necessary Python packages and wrappers.   

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

## Update Codebase
Instructions on how to update the repo locally.   

1. Run the following CLI commands to get the latest codebase:   

```
git fetch
git checkout main
git pull
git checkout <branch-being-worked-on>
git pull
```

2. Ensure Docker & LocalStack are running with the same set of instructions above.   

3. Activate the Python Env & re-install all the latest necessary packages with the same set of instructions above.   

## Add New Changes
Instructions on how to update the codebase with new changes.   

1. Add changes onto a new branch with branch name structured as <feature>/<author>/<desc.>

```
git checkout main
git checkout -b <feature>/<author>/<desc.>
```

2. After finalising & testing your own code changes, complete any necessary updates in the `tests` and `bin/deploy.sh` folders/files.   

3. Stage all the changes & commit them with signing and an appropriate commit message that details the changes, using the following CLI commands:

```
git add .
git commit -s -m "<commit-message>"
```

4. Before the code is pushed to the origin repo, merge the latest main into the feature branch & test the code to ensure it works.   

```
git fetch
git checkout main
git pull
git checkout <feature-branch>
git merge main
```

4. Push all changes to the origin repo.   

First time push:
```
git push --set-upstream origin <branch-name>
```

Usual push:
```
git push
```

5. On the Github web app, create a new pull request & wait for the approval of the branch merge.   
