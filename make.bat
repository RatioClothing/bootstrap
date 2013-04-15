@echo off

SET BOOTSTRAP=.\docs\assets\css\bootstrap.css
SET BOOTSTRAP_LESS=.\less\bootstrap.less
SET BOOTSTRAP_RESPONSIVE=.\docs\assets\css\bootstrap-responsive.css
SET BOOTSTRAP_RESPONSIVE_LESS=.\less\responsive.less
SET "CHECK= "
SET HR=##################################################

SETLOCAL ENABLEDELAYEDEXPANSION

if /i "%~1"=="bootstrap" goto bootstrap
echo Unknown make action "%~1"
goto end

::
:: BUILD SIMPLE BOOTSTRAP DIRECTORY
:: recess & uglifyjs are required
::

:bootstrap
if not exist ".\bootstrap\css" md .\bootstrap\css
if not exist ".\bootstrap\js" md .\bootstrap\js
if not exist ".\bootstrap\fonts" md .\bootstrap\fonts

copy /Y  .\fonts\* .\bootstrap\fonts\>nul

call recess --compile %BOOTSTRAP_LESS% > .\bootstrap\css\bootstrap.css
call recess --compress %BOOTSTRAP_LESS% > .\bootstrap\css\bootstrap.min.css

copy /B .\js\bootstrap-transition.js+.\js\bootstrap-alert.js+.\js\bootstrap-button.js+.\js\bootstrap-carousel.js+.\js\bootstrap-collapse.js+.\js\bootstrap-dropdown.js+.\js\bootstrap-modal.js+.\js\bootstrap-tooltip.js+.\js\bootstrap-popover.js+.\js\bootstrap-scrollspy.js+.\js\bootstrap-tab.js+.\js\bootstrap-typeahead.js+.\js\bootstrap-affix.js .\bootstrap\js\bootstrap.js>nul
call uglifyjs -nc .\bootstrap\js\bootstrap.js > .\bootstrap\js\bootstrap.min.tmp.js
(
echo /** && ^
echo.* Bootstrap.js by @fat ^& @mdo && ^
echo.* Copyright 2012 Twitter, Inc. && ^
echo.* http://www.apache.org/licenses/LICENSE-2.0.txt && ^
echo.*/
) > .\bootstrap\js\copyright.js
copy /B .\bootstrap\js\copyright.js+.\bootstrap\js\bootstrap.min.tmp.js .\bootstrap\js\bootstrap.min.js>nul
del /F /Q .\bootstrap\js\copyright.js .\bootstrap\js\bootstrap.min.tmp.js
goto end

:end