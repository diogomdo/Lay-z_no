@echo off
set PATH=%PATH%;%USERPROFILE%\AppData\Local\Atlassian\SourceTree\git_local\bin
set GIT_SSH=%PROGRAMFILES(X86)%\Atlassian\SourceTree\tools\putty\plink.exe
set count=0
set CHANGECMD=git diff-index --name-only HEAD --


FOR /d %%G in (*) DO (
	echo %%G
	if "%%G"=="ellucian-external" (
		cd %%G
		FOR /d %%R in (*) DO (
			echo %%R
		    cd %%R
		    call :gitRepos
			cd ..
		)
	cd ..
	)
	if "%%G"=="sources" (
		cd %%G
		FOR /d %%R in (*) DO (
			echo %%R
		    cd %%R
		    if "%%R"=="application-common-java" call :gitSources
			if "%%R"=="core-utils" call :gitSources
			if "%%R"=="runtime-html5" call :gitSources
			if "%%R"=="runtime-java" call :gitSources
			if "%%R"=="runtime-java-extensions" call :gitSources
			if "%%R"=="runtime-java-flavors-forms" call :gitSources
			cd ..
		)
	cd ..
	)

)

goto eof

::--------------------------------------------------------
::-- Function section
::--------------------------------------------------------

:gitRepos
FOR /F %%i IN ('%CHANGECMD%') DO SET /A count=count+1

if "%count%" == 0 (
		
		git pull
	) else (

		git stash save "tempRep"

		git pull

		git stash list

		git stash apply stash@{0}

		)
exit /b

:gitSources
git checkout .
git pull
exit /b

::--------------------------------------------------------

:eof
PAUSE

::TODO
::Add date to stash name
::Recursice search on directory for repos or specific directories
::Drop specific stash
::Ignore case on dir names

::git stash apply stash^{/tempRep} - This will apply the youngest stash that matches the regular expression "tempRep". The funny thing is you no need to keep in mind with full stash name.
