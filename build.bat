@echo off
setlocal

REM Set environment variables
set REPO_OWNER=hannesdelbeke
set DST_REPO=build\dst_repo
set TEMP_SUBMODULE=build\temp_submodule
set NOTE_LINK_JANITOR=build\note-link-janitor




REM Clone the repository to the 'dst_repo' folder
echo Cloning repository...
if exist %DST_REPO% (
    echo Deleting existing dst_repo directory...
    rd /s /q %DST_REPO%
)
git clone https://github.com/%REPO_OWNER%/wiki.git %DST_REPO%
if %ERRORLEVEL% NEQ 0 (
    echo Failed to clone repository.
    exit /b %ERRORLEVEL%
)

REM Switch to the 'mkdocs' branch
echo Switching to mkdocs branch...
cd %DST_REPO%
git checkout mkdocs
if %ERRORLEVEL% NEQ 0 (
    echo Failed to switch to mkdocs branch. Ensure the branch name is correct.
    exit /b %ERRORLEVEL%
)
cd ..




REM Load content files in submodule in the docs folder
if exist %TEMP_SUBMODULE% (
    echo Deleting existing dst_repo directory...
    rd /s /q %TEMP_SUBMODULE%
)
echo Loading submodule...
echo clone https://github.com/%REPO_OWNER%/brain.git %TEMP_SUBMODULE%
git clone https://github.com/%REPO_OWNER%/brain.git %TEMP_SUBMODULE%

REM Set up Node.js and Yarn using winget
echo Setting up Node.js and Yarn...
winget install OpenJS.NodeJS.LTS
winget install Yarn.Yarn

REM Check if note-link-janitor already exists
if exist %NOTE_LINK_JANITOR% (
    echo note-link-janitor already exists, skipping clone...
) else (
    echo Cloning note-link-janitor...
    git clone --branch stable https://github.com/%REPO_OWNER%/note-link-janitor.git %NOTE_LINK_JANITOR%
)

REM Install dependencies and build note-link-janitor
cd %NOTE_LINK_JANITOR%
yarn install
yarn run build

REM Run Note Link Janitor
echo Running Note Link Janitor...
node dist/index.js ..\%TEMP_SUBMODULE%
cd ..

REM Clean dst_repo/docs before syncing new files
echo Cleaning dst_repo/docs...
rd /s /q %DST_REPO%\docs
mkdir %DST_REPO%\docs

REM Move submodule files to dst_repo
echo Moving submodule files...
mkdir %DST_REPO%\static\images
move %TEMP_SUBMODULE%\image\* %DST_REPO%\static\images
rd /s /q %TEMP_SUBMODULE%\.git
xcopy %TEMP_SUBMODULE%\* %DST_REPO%\docs /s /e /y

REM Set up Python environment
echo Setting up Python environment...
py -m venv %DST_REPO%\venv
call %DST_REPO%\venv\Scripts\activate
pip install --requirement %DST_REPO%\requirements.txt

REM Build mkdocs and deploy to GitHub Pages
echo Building mkdocs and deploying to GitHub Pages...
cd %DST_REPO%
mkdocs serve

echo DONE
endlocal