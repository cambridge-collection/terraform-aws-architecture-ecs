# Terraform Module for ECS Architecture

## GitHub Workflows

### Commit Lint

When pushing a commit to GitHub, or raising a Pull Request, a GitHub workflow will automatically run `commitlint`. This makes use of the Node.js module https://commitlint.js.org. The workflow has been configured to use the Conventional Commits specification https://www.conventionalcommits.org/en/v1.0.0/. 

When commits are formatted using a canonical format such as Conventional Commits these can be used in the release process to determine the version number. The commit history can also be used to generate a `CHANGELOG.md`

For local development it is recommended to use a `commit-msg` Git hook. The following code should be placed in a file `.git/hooks/commit-msg` and made executable:

```sh
#!/bin/sh

if command -v commitlint &> /dev/null
then
  echo $1 | commitlint
fi
```

This is dependent on the `commitlint` tool, which can be installed using `npm install -g @commitlint/{cli,config-conventional}` (for a global installation). When working correctly the hook should fire whenever a commit is attempted, e.g.

```
git commit -m "silly message"
⧗   input: .git/COMMIT_EDITMSG
✖   subject may not be empty [subject-empty]
✖   type may not be empty [type-empty]

✖   found 2 problems, 0 warnings
ⓘ   Get help: https://github.com/conventional-changelog/commitlint/#what-is-commitlint
```

Configuration for the commitlint tool is located in the `.commitlintrc.mjs` file in the root of the project. This is also used by the `commit-msg` hook.

### Semantic Release

On a push to the `main` branch, i.e. after a Pull Request has been approved and merged, a GitHub workflow will run [Semantic Release](https://semantic-release.gitbook.io/semantic-release). This will initiate a chain of actions that will automatically handle versioning, GitHub releases and Changelog generation.

The commit analyzer bundled with Semantic Release follows the same `conventionalcommits` schema as is used in the commit linting.

The semantic release tooling is configured in a file `.releaserc.json` in the root of the project.

### Terraform Format Linting

When pushing a commit to GitHub, or raising a Pull Request, a GitHub workflow will automatically run `terraform fmt -check -recursive` in the root of the project. If this produces a non-zero exit code, the job will fail.

Terraform [fmt](https://developer.hashicorp.com/terraform/cli/commands/fmt) is an "intentionally opinionated" command to rewrite configuration files to a recommended format. Any errors detected by the check can easily be remedied with by running the command `terraform fmt -recursive` which will automatically change all terraform code in the project.

For local development it is recommended to use a `pre-commit` hook to detect formatting issues before they are committed. Place the text below in a file `.git/hooks/pre-commit` and make this executable:

```sh
#!/bin/sh

if command -v terraform &> /dev/null
then
    FORMAT_CHECK=$(terraform fmt -check -recursive)
    FORMAT_RC=$?
    if [ $FORMAT_RC -gt 0 ]
        then
            printf "\033[1;31mThe following files need to be formatted:\033[m\n"
            for f in $FORMAT_CHECK; do
                echo $f
            done
            printf "Run \033[1;32mterraform fmt -recursive\033[m to fix\n" 
        exit $FORMAT_RC
    fi
else
    echo "Terraform executable was not found in $PATH"
    exit 1
fi
```

When working correctly, the git hook will produce output when staged files are commited, e.g.:

```
$ git commit    
The following files need to be formatted:
main.tf
modules/grault/variables.tf
Run terraform fmt -recursive to fix
```
