#cls
#Import-Module posh-git
#Import-Module oh-my-posh
#Set-PoshPrompt -Theme hotstick.minimal
#Write-Host "Ola, Paulo"
echo "Ola, Paulo"
#new-alias cls (cls && echo "ola, paulo")
Set-Variable PROJETO G:\projeto

function touch{
     param (
        [string[]]$ParameterName
    )

    foreach ($Parameter in $ParameterName) {
        echo "" | out-file -encoding utf8 $Parameter
    }
}

function Create-Docker{
    param (
        [string[]]$ParameterName
    )

    echo 'FROM node:12-alpine
RUN apk add --no-cache python2 g++ make
WORKDIR /app
COPY . .
RUN yarn install --production
CMD ["node", "src/index.js\]' | out-file -encoding utf8 "Dockerfile"

    foreach ($Parameter in $ParameterName) {
       if ($Parameter -eq "PHP") {
        echo 'FROM php:5.6-apache 
COPY site/ /var/www/html/' | out-file -encoding utf8 "Dockerfile"
       }
    }
}

function Create-DockerImg{
    param (
        [string[]]$ParameterName
    )

    docker build -t $ParameterName[0] .
    echo "Finalizou"
    docker run -d --name $ParameterName[1] $ParameterName[0]
    
}

function Write-BranchName () {
    try {
        #$branch = git rev-parse --abbrev-ref HEAD
        $branch = git branch --show-current

        if ($branch -eq "HEAD") {
            # we're probably in detached HEAD state, so print the SHA
            $branch = git rev-parse --short HEAD
            Write-Host " ($branch)" -NoNewline -ForegroundColor "red"
        }
        else {
            # we're on an actual branch, so print it
            Write-Host " ($branch)" -NoNewline -ForegroundColor "blue"
        }
    } catch {
        # we'll end up here if we're in a newly initiated git repo
        Write-Host " (no branches yet)" -NoNewline -ForegroundColor "yellow"
    }
}

function prompt {
    $base = "PS "
    $path = "$($executionContext.SessionState.Path.CurrentLocation)"
    $userPrompt = "$(' >' * ($nestedPromptLevel + 1)) "

    Write-Host "`n$base" -NoNewline

    if (Test-Path .git) {
        Write-Host $path -NoNewline -ForegroundColor "green"
        Write-BranchName
    }
    else {
        # we're not in a repo so don't bother displaying branch name/sha
        Write-Host $path -NoNewline -ForegroundColor "green"
    }

    return $userPrompt
}

function Get-GitAdd {& git add $args }
New-Alias -Name gta -Value Get-GitAdd
function Get-GitStts {& git status $args }
New-Alias -Name gts -Value Get-GitStts
function Get-GitCommit {& git commit -m $args }
New-Alias -Name gtc -Value Get-GitStts
function Get-GitCommita {& git commit -am $args }
New-Alias -Name gtca -Value Get-GitCommita
function Get-GitPush {& git push $args }
New-Alias -Name gtp! -Value Get-GitPush
New-Alias -Name gtp1 -Value Get-GitPush
function Get-GitPull {& git pull $args }
New-Alias -Name gtp -Value Get-GitPull