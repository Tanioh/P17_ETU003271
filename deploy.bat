@echo off

REM Variables

set LIB_DIR=lib
set SERVLET_JAR=%LIB_DIR%\jakarta.servlet-api-5.0.0.jar
set OUTPUT_DIR=build
set SOURCE_LIST=sources.txt
set WEBAPPS_PATH=C:\Program Files\Apache Software Foundation\apache-tomcat-10.1.28\webapps
set MYSQL_CONNECTOR_JAR=%LIB_DIR%\mysql-connector-j-9.1.0.jar
set PROJECT_NAME=ETU003271

REM Création du dossier de compilation si inexistant
if not exist "%OUTPUT_DIR%" (
    mkdir "%OUTPUT_DIR%"
)

REM Création des sous-dossiers nécessaires
if not exist "%OUTPUT_DIR%\WEB-INF" mkdir "%OUTPUT_DIR%\WEB-INF"
if not exist "%OUTPUT_DIR%\WEB-INF\classes" mkdir "%OUTPUT_DIR%\WEB-INF\classes"
if not exist "%OUTPUT_DIR%\css" mkdir "%OUTPUT_DIR%\css"
if not exist "%OUTPUT_DIR%\js" mkdir "%OUTPUT_DIR%\js"

REM Compilation des fichiers Java
dir /b /s *.java > %SOURCE_LIST%
"C:\Program Files\Java\jdk-17\bin\javac.exe" -cp %SERVLET_JAR%;%MYSQL_CONNECTOR_JAR% -d %OUTPUT_DIR%/WEB-INF/classes @%SOURCE_LIST%

REM Vérification de la compilation
if %ERRORLEVEL% neq 0 (
    echo "Erreur de compilation. Arrêt du script."
    exit /b %ERRORLEVEL%
)

REM Copie du fichier web.xml
xcopy /I /Y src\main\webapps\WEB-INF\web.xml %OUTPUT_DIR%\WEB-INF\

REM Copie des fichiers statiques
xcopy /I /Y src\main\webapps\*.html %OUTPUT_DIR%\
xcopy /I /Y src\main\webapps\*.jsp %OUTPUT_DIR%\ 2>nul
xcopy /I /Y /S src\main\webapps\css\*.* %OUTPUT_DIR%\css\ 2>nul
xcopy /I /Y /S src\main\webapps\js\*.* %OUTPUT_DIR%\js\ 2>nul

REM Copie du fichier JAR MySQL
echo Copie du fichier JAR MySQL...
xcopy /I /Y lib\mysql-connector-j-9.1.0.jar %OUTPUT_DIR%\WEB-INF\lib\

REM Création du fichier .war
cd %OUTPUT_DIR%
"C:\Program Files\Java\jdk-17\bin\jar.exe" cvf "%PROJECT_NAME%.war" .

REM Suppression de l'ancien déploiement si existant
if exist "%WEBAPPS_PATH%\%PROJECT_NAME%.war" del "%WEBAPPS_PATH%\%PROJECT_NAME%.war"
if exist "%WEBAPPS_PATH%\%PROJECT_NAME%" rmdir /S /Q "%WEBAPPS_PATH%\%PROJECT_NAME%"

REM Copier le fichier .war vers le répertoire webapps
copy %PROJECT_NAME%.war %WEBAPPS_PATH%
if %ERRORLEVEL% neq 0 (
    echo "Erreur lors de la copie du fichier WAR."
    exit /b %ERRORLEVEL%
)

REM Retour au répertoire d'origine
cd ..

echo Déploiement terminé avec succès.