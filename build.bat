REM winget install OpenJS.NodeJS
REM winget install yarm.yarn


@echo off
setlocal

REM Set environment variables
set REPO_OWNER=hannesdelbeke
set DST_REPO=build\dst_repo
set TEMP_SUBMODULE=build\temp_submodule

REM Clone the 'mkdocs' branch to the 'dst_repo' folder
echo Cloning mkdocs branch...
git clone --branch mkdocs https://github.com/%REPO_OWNER%/%REPO_OWNER%.github.io.git %DST_REPO%

rd /s /q %TEMP_SUBMODULE%

REM Load content files in submodule in the docs folder
echo Loading submodule...
git clone https://github.com/%REPO_OWNER%/brain.git %TEMP_SUBMODULE%

REM Set up Node.js and Yarn
echo Setting up Node.js and Yarn...
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
call %USERPROFILE%\.nvm\nvm install 16
call %USERPROFILE%\.nvm\nvm use 16
npm install --global yarn

REM Clone the note-link-janitor repository and install dependencies
if exist %NOTE_LINK_JANITOR% (
    echo note-link-janitor already exists, skipping clone...
) else (
    echo Cloning and setting up note-link-janitor...
    git clone --branch stable https://github.com/hannesdelbeke/note-link-janitor.git note-link-janitor
)
cd note-link-janitor
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

endlocal