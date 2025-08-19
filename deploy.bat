rem deploy.bat for digdilem

c:
cd \code\digdilem

hugo --cleanDestinationDir

git add .
git commit -am "Updating to reflect development"
git push -f origin main

npx wrangler pages deploy c:\code\digdilem\public --project-name=digdilem25  --commit-dirty=true 



